/*
* 
* Author : Luke Vang 
* 
* 
* AssignmentRuleHandler
* 
* This class is called in the trigger after insert/update
* context, to assign the owner of records based on critieria
* defined in custom assignment rule application
* 
*/
public class AssignmentRuleHandler {
    
    private static Boolean hasExecuted = true;
    private static List<Messaging.SingleEmailMessage> emails;
    @testVisible private static Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>();
    private static Map<Id, sObject> resultsToUpdate;
    
    //runs in the after insert trigger context
    public static void execute(List<sObject> newList){
        //recursion flag
        //adding flag to check if list is empty
        if(hasExecuted && !newList.isEmpty()){

            resultsToUpdate = new Map<Id, sObject>();
            emails = new List<Messaging.SingleEmailMessage>();
            hasExecuted = false;

            fieldMap = newList[0].getSObjectType().getDescribe().fields.getMap(); //get map of fields
            
            String sObjectType = newList[0].getSObjectType().getDescribe().getName();
            
            List<Field_Map_Value__c> fieldMapValues = [SELECT User__c, SObject_Type__c, Field_Map__c, Field_Map__r.Value__c 
                                                       FROM Field_Map_Value__c 
                                                       WHERE SObject_Type__c =: sobjectType];
            //get all active geo territory assignments
            List<Geographic_Territory_Assignment__c> geoTerritoryAssignments = [SELECT User__c, SObject_Type__c, Geographic_Territory__r.Postal_Code__c
                                                                                FROM Geographic_Territory_Assignment__c 
                                                                                WHERE SObject_Type__c =: sobjectType];
            
            //get all active assignment rules
            Map<Id, Assignment_Rule__c> assignmentRules = new Map<Id, Assignment_Rule__c>([SELECT id, Active__c, Has_Run_Criteria__c,
                                                                                           (SELECT id, Field__c, Operator__c, FieldType__c,
                                                                                            Value__c, Assignment_Rule_Entry_Criteria__c
                                                                                            FROM Assignment_Rule_Criteria_Based_Rules__r)
                                                                                           FROM Assignment_Rule__c 
                                                                                           WHERE sObject__c =: sObjectType AND Active__c =: TRUE]);
            
            Map<Id, List<Assignment_Rule_Entry__c>> ruleIdToEntries = new Map<Id, List<Assignment_Rule_Entry__c>>();
            
            //retrieve all assignment rule entries
            Map<Id, Assignment_Rule_Entry__c> assignmentRuleEntries = new Map<Id, Assignment_Rule_Entry__c>([SELECT Id, Assigned_To__c, Assignment_Rule__c,
                                                                                                             Send_Email__c, Order__c, Filter_Logic__c, RecordTypeId,
                                                                                                             (SELECT id, Field__c, Operator__c, FieldType__c,
                                                                                                              Position__c, Value__c, Assignment_Rule_Entry_Criteria__c
                                                                                                              FROM Assignment_Rule_Criteria_Based_Rules__r ORDER BY Position__c ASC)
                                                                                                             FROM Assignment_Rule_Entry__c 
                                                                                                             WHERE Assignment_Rule__c IN: assignmentRules.keySet() ORDER BY Order__c ASC]);
            
            for(Assignment_Rule_Entry__c entry : assignmentRuleEntries.values()){
                if(ruleIdToEntries.get(entry.Assignment_Rule__c) != null){
                    ruleIdToEntries.get(entry.Assignment_Rule__c).add(entry);
                }else{
                    ruleIdToEntries.put(entry.Assignment_Rule__c, new List<Assignment_Rule_Entry__c>());
                    ruleIdToEntries.get(entry.Assignment_Rule__c).add(entry);
                }
            }
            
            
            //holds all new records to run assignment rules off of
            Map<Id, List<SObject>> rulesWithRunCriteriaToNewRecords = new Map<Id, List<SObject>>();
            Map<Id, List<SObject>> ruleWithoutRunCriteriaToNewRecords = new Map<Id, List<SObject>>();
            
            for(Assignment_Rule__c rule : assignmentRules.values()){
                if(rule.Has_Run_Criteria__c){
                    //run through each criteria for each rule if there are some, only has 1 criteria per rule
                    for(Assignment_Rule_Criteria_Based_Rule__c criteria : rule.Assignment_Rule_Criteria_Based_Rules__r){
                        for(sObject newRecord : newList){   
                            if(checkCriteria(newRecord, criteria)){
                                if(rulesWithRunCriteriaToNewRecords.get(rule.Id) != null){
                                    rulesWithRunCriteriaToNewRecords.get(rule.Id).add(newRecord);
                                }else{
                                    rulesWithRunCriteriaToNewRecords.put(rule.Id, new List<SObject> { newRecord });
                                }
                            }
                        }
                    }
                }else{
                    //add all records, to this list as these are standard rules ran on everything
                     ruleWithoutRunCriteriaToNewRecords.put(rule.Id, newList);
                }
            }
            
            //run custom assign rules first
            
            if(!rulesWithRunCriteriaToNewRecords.isEmpty()){
                for(Id ruleId : rulesWithRunCriteriaToNewRecords.keySet()){
                    runRules(ruleIdToEntries.get(ruleId), fieldMapValues, geoTerritoryAssignments, sObjectType, rulesWithRunCriteriaToNewRecords.get(ruleId)); 
                }
            }

            //run none custom assign rules next
            if(!ruleWithoutRunCriteriaToNewRecords.isEmpty()){
                 for(Id ruleId : ruleWithoutRunCriteriaToNewRecords.keySet()){
                    runRules(ruleIdToEntries.get(ruleId), fieldMapValues, geoTerritoryAssignments, sObjectType, ruleWithoutRunCriteriaToNewRecords.get(ruleId)); 
                }
            }

            if(!resultsToUpdate.isEmpty()){ 
                 update resultsToUpdate.values();
             }

        }
        //send emails if any
        sendEmail();
    }
    
    /*
     * 
     * checkCriteria
     * 
     * used for criteria based assignment rules
     * each record is tested to see if it matches criteria
     * 
     */ 
    public static Boolean checkCriteria(SObject newRecord, Assignment_Rule_Criteria_Based_Rule__c criteria){
        Boolean valid = false;
        if(fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.STRING || fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.PHONE|| fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.PICKLIST|| fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.TEXTAREA|| fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.URL|| fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.EMAIL || fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.COMBOBOX) 
        {
            valid = handleStringType(newRecord, criteria);
        }else if(fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.BOOLEAN)
        {
            valid = handleBoolean(newRecord, criteria);
        }else if(fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.Date )
        {
            valid = handleDate(newRecord, criteria);
        }else if(fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.DateTime || fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.Time)
        {
            valid = handleDateTime(newRecord, criteria);
        }else if(fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.DOUBLE || fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.Currency ||fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.Percent)
        {
            valid = handleDouble(newRecord, criteria);
        }else if(fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.INTEGER)
        {
            valid = handleInteger(newRecord, criteria);
        }else if(fieldMap.get(criteria.Field__c).getDescribe().getType() == Schema.DisplayType.MULTIPICKLIST)
        {
            valid = handleMultiSelectPickList(newRecord, criteria);
        }
        
        return valid;
    }
    
    /*
     * 
     * checks for multi-select type fields
     *  used in initial criteria check for assignment rules
     * 
     */ 
    static Boolean handleMultiSelectPickList(sObject s, Assignment_Rule_Criteria_Based_Rule__c c){
        String value = String.valueOf(c.Value__c);
        String fieldValue = String.valueOf(s.get(c.Field__c));
        Boolean valid = false;
        
        Set<String> multiSelectSetFieldValue = new Set<String>();
        Set<String> multiSelectSeValue = new Set<String>();
        
        multiSelectSetFieldValue.addAll(fieldValue.split('\\,'));
        multiSelectSeValue.addAll(value.split('\\,'));
        
        if(c.Operator__c == 'equals'){
            if(multiSelectSetFieldValue.equals(multiSelectSeValue)){
                valid =  true;
            }
        }else if(c.Operator__c == 'not equal to'){
            if(!multiSelectSetFieldValue.equals(multiSelectSeValue)){
                valid =  true;
            }
        }else if(c.Operator__c == 'includes'){
            if(multiSelectSetFieldValue.containsAll(multiSelectSeValue)){
                valid =  true;
            }
        }else if(c.Operator__c == 'excludes'){
            if(!multiSelectSetFieldValue.containsAll(multiSelectSeValue)){
                valid =  true;
            }
        }
        return valid;
    }
    
    /*
     * 
     * checks for integer type fields
     *  used in initial criteria check for assignment rules
     * 
     */ 
    static Boolean handleInteger(sObject s, Assignment_Rule_Criteria_Based_Rule__c c){
        Boolean valid = false;
        Integer value = Integer.valueOf(String.valueOf(c.Value__c));
        Integer fieldValue = Integer.valueOf(String.valueOf(s.get(c.Field__c)));
        
        if(c.Operator__c == 'equals'){
            if( fieldValue == value){
                valid =  true;
            }
        }else if(c.Operator__c == 'not equal to'){
            if(fieldValue != value){
                valid =  true;
            }
        }else if(c.Operator__c == 'less than'){
            if(fieldValue < value){
                valid =  true;
            }
        }else if(c.Operator__c == 'greater than'){
            if(fieldValue > value){
                valid =  true;
            }
        }else if(c.Operator__c == 'less or equal'){
            if(fieldValue <= value ){
                valid =  true;
            }
        }else if(c.Operator__c == 'greater or equal'){
            if(fieldValue >= value){
                valid =  true;
            }
        }
        return valid;
    }
    
    /*
     * 
     * checks for double type fields
     *  used in initial criteria check for assignment rules
     * 
     */ 
    static Boolean handleDouble(sObject s, Assignment_Rule_Criteria_Based_Rule__c c){
        Decimal value = Decimal.valueOf(String.valueOf(c.Value__c));
        Decimal fieldValue = Decimal.valueOf(String.valueOf(s.get(c.Field__c)));
        Boolean valid = false;
        
        if(c.Operator__c == 'equals'){
            if( fieldValue == value){
                valid =  true;
            }
        }else if(c.Operator__c == 'not equal to'){
            if(fieldValue != value){
                valid =  true;
            }
        }else if(c.Operator__c == 'less than'){
            if(fieldValue < value){
                valid =  true;
            }
        }else if(c.Operator__c == 'greater than'){
            if(fieldValue > value){
                valid =  true;
            }
        }else if(c.Operator__c == 'less or equal'){
            if(fieldValue <= value ){
                valid =  true;
            }
        }else if(c.Operator__c == 'greater or equal'){
            if(fieldValue >= value){
                valid =  true;
            }
        }
        return valid;
    }
    
    
    /*
     * 
     * checks for boolean type fields
     *  used in initial criteria check for assignment rules
     * 
     */ 
    static Boolean handleBoolean(sObject s, Assignment_Rule_Criteria_Based_Rule__c c){
        Boolean value = Boolean.valueOf(c.Value__c);
        Boolean fieldValue = Boolean.valueOf(s.get(c.Field__c));
        Boolean valid = false;
        
        if(c.Operator__c == 'equals'){
            if(fieldValue == value){
                valid =  true;
            }
        }else if(c.Operator__c == 'not equal to'){
            if(fieldValue != value){
                valid =  true;
            }
        }
        return valid;
    }
    
    
    /*
     * 
     * checks for date time type fields
     *  used in initial criteria check for assignment rules
     * 
     */ 
    static Boolean handleDateTime(sObject s, Assignment_Rule_Criteria_Based_Rule__c c){
        DateTime value = DateTime.valueOf(c.Value__c);
        DateTime fieldValue = DateTime.valueOf(s.get(c.Field__c));
        Boolean valid = false;
        
        if(c.Operator__c == 'equals'){
            if( fieldValue == value){
                valid =  true;
            }
        }else if(c.Operator__c == 'not equal to'){
            if(fieldValue != value){
                valid =  true;
            }
        }else if(c.Operator__c == 'less than'){
            if(fieldValue < value){
                valid =  true;
            }
        }else if(c.Operator__c == 'greater than'){
            if(fieldValue > value){
                valid =  true;
            }
        }else if(c.Operator__c == 'less or equal'){
            if(fieldValue <= value ){
                valid =  true;
            }
        }else if(c.Operator__c == 'greater or equal'){
            if(fieldValue >= value){
                valid =  true;
            }
        }
        return valid;
    }
    
    /*
     * 
     * checks for date type fields
     *  used in initial criteria check for assignment rules
     * 
     */ 
    static Boolean handleDate(sObject s, Assignment_Rule_Criteria_Based_Rule__c c){
        
        Date value = Date.parse(c.Value__c);
        Date fieldValue = Date.valueOf(s.get(c.Field__c));
        Boolean valid = false;
        
        if(c.Operator__c == 'equals'){
            if( fieldValue == value){
                valid =  true;
            }
        }else if(c.Operator__c == 'not equal to'){
            if(fieldValue != value){
                valid =  true;
            }
        }else if(c.Operator__c == 'less than'){
            if(fieldValue < value){
                valid =  true;
            }
        }else if(c.Operator__c == 'greater than'){
            if(fieldValue > value){
                valid =  true;
            }
        }else if(c.Operator__c == 'less or equal'){
            if(fieldValue <= value ){
                valid =  true;
            }
        }else if(c.Operator__c == 'greater or equal'){
            if(fieldValue >= value){
                valid =  true;
            }
        }
        
        return valid;
        
    }
    
    /*
     * 
     * checks for string type fields
     * used in initial criteria check for assignment rules
     * 
     */ 
    static Boolean handleStringType(sObject s, Assignment_Rule_Criteria_Based_Rule__c c){
        String value = String.valueOf(c.Value__c); 
        String fieldValue = (String) (s.get(c.Field__c));
        Boolean valid = false;
        
        if(c.Operator__c == 'equals'){
            if(fieldValue == (value)){
                valid =  true;
            }
        }else if(c.Operator__c == 'not equal to'){
            if(fieldValue != (value)){
                valid =  true;
            }
        }else if(c.Operator__c == 'starts with'){
            if(fieldValue.startsWith(value)){
                valid =  true;
            }
        }else if(c.Operator__c == 'contains'){
            if(fieldValue.contains(value)){
                valid =  true;
            }
        }else if(c.Operator__c == 'does not contain'){
            if(!fieldValue.contains(value)){
                valid =  true;
            }
        }else if(c.Operator__c == 'less than'){
            if(fieldValue.length() < value.length()){
                valid =  true;
            }
        }else if(c.Operator__c == 'greater than'){
            if(fieldValue.length() > value.length()){
                valid =  true;
            }
        }else if(c.Operator__c == 'less or equal'){
            if(fieldValue.length() <= value.length()){
                valid =  true;
            }
        }else if(c.Operator__c == 'greater or equal'){
            if(fieldValue.length() >= value.length()){
                valid =  true;
            }
        }
        return valid;
    }
    
    
    /*
     * 
     * runRules
     * 
     * this function builds the query used to see if records return match the
     * criteria for an assignment rule
     * 
     * if the query returns records, those records owner will be updated
     * 
     */ 
    private static void runRules(List<Assignment_Rule_Entry__c> entries,
                                 List<Field_Map_Value__c> fieldMapValues, List<Geographic_Territory_Assignment__c> geoTerritoryAssignments,
                                 String sobjectType, List<SObject> newList)
    {
        Set<Id> newRecordIds = new Set<Id>();
        for(SObject newRecord : newList){
            newRecordIds.add( (Id) newRecord.get('Id'));
        }
        for(Assignment_Rule_Entry__c entry : entries){
            String ownerId = String.isEmpty(entry.Assigned_To__c) ? UserInfo.getUserId() : entry.Assigned_To__c;
            if(!entry.Assignment_Rule_Criteria_Based_Rules__r.isEmpty()){
                String query =  '';
                if(String.isNotEmpty(entry.Filter_Logic__c)){
                   String filter = entry.Filter_Logic__c;
                    //stores all used positions when creating initial positions for query
                    Set<String> usedPositions = new Set<String>();
                    
                    for(Integer i = 0; i < filter.length(); i++){
                        //loop through characters and string and check both first and 2nd indexes;
                        
                        //builds initial string for query using positions for each entry
                        //example: (1 AND 2 AND 3 )
                        if( i + 2 <= filter.length() && !usedPositions.contains(filter.subString(i, i + 1) + filter.subString(i + 1, i + 2)) 
                           && String.valueOf(filter.subString(i, i + 1) + filter.subString(i + 1, i + 2)).isNumeric()){
                               String num = filter.subString(i, i + 1) + filter.subString(i + 1, i + 2);
                               usedPositions.add(num.trim());
                               filter = filter.replaceFirst('(^|\\b)' + num +'\\b', '(' + num + ')');
                           }else if( i + 2 <= filter.length() && !usedPositions.contains(filter.subString(i, i + 1).trim()) 
                                    && String.valueOf(filter.subString(i, i + 1)).trim().isNumeric() 
                                    && !filter.subString(i + 1, i + 2).isNumeric()
                                    && String.valueOf(filter.subString(i, i + 1)).trim() != '0' ||
                                    !usedPositions.contains(filter.subString(i, i + 1).trim()) 
                                    && String.valueOf(filter.subString(i, i + 1)).trim().isNumeric()  ){
                                        String num = filter.subString(i, i + 1).trim();
                                        usedPositions.add(num);
                                        filter = filter.replaceFirst('(^|\\b)' + num +'\\b', '(' + num + ')');
                                    }
                        
                    }
                    
                    query = 'SELECT id, OwnerId ';
                    
                    for(Assignment_Rule_Criteria_Based_Rule__c cr : entry.Assignment_Rule_Criteria_Based_Rules__r){
                        String criteria = '';
                        
                        if(cr.Field__c.startsWith(sObjectType + '.')){
                            cr.Field__c = cr.Field__c.removeStart(sObjectType + '.');
                        }
                        if(cr.Operator__c == 'equals'){
                            if(cr.FieldType__c == 'BOOLEAN'){
                                criteria = '('+ cr.Field__c + ' = ' + cr.Value__c +  ' )';
                            }else{
                                criteria = '('+ cr.Field__c + ' = \'' + cr.Value__c + '\' )';
                            }
                        }else if(cr.Operator__c == 'not equal to'){
                            criteria = '(' + cr.Field__c + ' != \'' + cr.Value__c + '\' )';
                        }else if(cr.Operator__c == 'starts with'){
                            criteria = '(' + cr.Field__c + ' LIKE \'' + cr.Value__c + '%\' )';
                        }else if(cr.Operator__c == 'contains'){
                            criteria = '(' + cr.Field__c + ' INCLUDES ( \'' + cr.value__c + '\' ) )';
                        }else if(cr.Operator__c == 'does not contains'){
                            criteria = '(' + cr.Field__c + ' EXCLUDES ( \'' + cr.Value__c + '\' ) )';
                        }else if(cr.Operator__c == 'less than'){
                            criteria = '(' + cr.Field__c + ' < \'' + cr.Value__c + '\')';
                        }else if(cr.Operator__c == 'greater than'){
                            criteria = '(' + cr.Field__c + ' > \'' + cr.Value__c + '\')';
                        }else if(cr.Operator__c == 'less or equal'){
                            criteria = '(' + cr.Field__c + ' <= \'' + cr.Value__c + '\')';
                        }else if(cr.Operator__c == 'greater or equal'){
                            criteria = '(' + cr.Field__c + ' >= \'' + cr.Value__c + '\')';
                        }
                        filter = filter.replace('(' + String.valueOf(cr.Position__c) + ')', criteria);
                        
                    }
                    filter = filter.endsWith(' OR ') ? filter.removeEnd(' OR ') : filter;
                    filter = filter.endsWith(' AND ') ? filter.removeEnd(' AND ') : filter;
                    
                    
                    //perform query, if the records meet the criteria 
                    //they'll be updated, 
                    //if not then they won't be updated
                    //and will move to the next iteration
                    query += ' FROM ' + sObjectType + ' WHERE Id IN:  newRecordIds  AND ( ' + filter + ')';
                    List<sObject> result = Database.query(query);
                    
                    if(!result.isEmpty()){
                        for(sObject s : result){
                            SObject sobj = Schema.getGlobalDescribe().get(String.valueOf(s.getSObjectType())).newSObject();
                            sobj.put('OwnerId', ownerId);
                            sobj.put('Id', String.valueOf(s.get('Id')));
                            if(resultsToUpdate.get(String.valueOf(s.get('Id'))) == null) {
                                resultsToUpdate.put(String.valueOf(s.get('Id')), sobj);
                            }
                        }
                    }
                    if(!resultsToUpdate.isEmpty()){ 
                          //create emails for any updated records
                        createEmails(resultsToUpdate.values(), entry);
                        continue;
                    }
                }else{
                    query = 'SELECT id, OwnerId ';
                    String fields = '';
                    for(Assignment_Rule_Criteria_Based_Rule__c cr : entry.Assignment_Rule_Criteria_Based_Rules__r){
                        if(cr.FieldType__c == 'ANYASSIGN'){
                            if(cr.Field__c == 'Geo_Location'){
                                for(sObject newRecord : newList){   
                                    if(newRecord.get(cr.Value__c) != null ){
                                        for(Geographic_Territory_Assignment__c gta : geoTerritoryAssignments){
                                            if(gta.Geographic_Territory__r.Postal_Code__c == String.valueOf(newRecord.get(cr.Value__c))){
                                                String owner = gta.User__c != null ? gta.User__c : UserInfo.getUserId();
                                                SObject sobj = Schema.getGlobalDescribe().get(String.valueOf(newRecord.getSObjectType())).newSObject();
                                                sobj.put('OwnerId', owner);
                                                sobj.put('Id', String.valueOf(newRecord.get('Id')));
                                                if(resultsToUpdate.get(String.valueOf(newRecord.get('Id'))) == null) {
                                                    resultsToUpdate.put(String.valueOf(newRecord.get('Id')), sobj);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            if(cr.Field__c == 'Field_Value_Map'){
                                for(sObject newRecord : newList){   
                                    if(newRecord.get(cr.Value__c) != null ){
                                        for(Field_Map_Value__c fmv : fieldMapValues){
                                            if(fmv.Field_Map__r.Value__c == String.valueOf(newRecord.get(cr.Value__c))){
                                                String owner = fmv.User__c != null ? fmv.User__c : UserInfo.getUserId();
                                                SObject sobj = Schema.getGlobalDescribe().get(String.valueOf(newRecord.getSObjectType())).newSObject();
                                                sobj.put('OwnerId', owner);
                                                sobj.put('Id', String.valueOf(newRecord.get('Id')));
                                                if(resultsToUpdate.get(String.valueOf(newRecord.get('Id'))) == null) {
                                                    resultsToUpdate.put(String.valueOf(newRecord.get('Id')), sobj);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            //if the first position is a any assign just break out
                            continue;
                            
                        }else{      
                            
                            if(cr.Field__c.startsWith(sObjectType + '.')){
                                cr.Field__c =  cr.Field__c.removeStart(sObjectType + '.');
                            }
                            if(cr.Operator__c == 'equals'){
                                if(cr.FieldType__c == 'BOOLEAN'){
                                    fields += '' + cr.Field__c + ' = ' + cr.Value__c + ' AND ';
                                }else{
                                    fields += '' + cr.Field__c + ' = \'' + cr.Value__c + '\' AND ';
                                }
                            }else if(cr.Operator__c == 'not equal to'){
                                fields += '' + cr.Field__c + ' != \'' + cr.Value__c + '\' AND ';
                            }else if(cr.Operator__c == 'starts with'){
                                fields += '' + cr.Field__c + ' LIKE \'' + cr.Value__c + '%\' AND ';
                            }else if(cr.Operator__c == 'contains'){
                                fields += '' + cr.Field__c + ' INCLUDES ( \'' + cr.value__c + '\' )AND ';
                            }else if(cr.Operator__c == 'does not contains'){
                                fields += '' + cr.Field__c + ' EXCLUDES ( \'' + cr.Value__c + '\' ) AND ';
                            }else if(cr.Operator__c == 'less than'){
                                fields += '' + cr.Field__c + ' < \'' + cr.Value__c + '\' AND ';
                            }else if(cr.Operator__c == 'greater than'){
                                fields += '' + cr.Field__c + ' > \'' + cr.Value__c + '\' AND ';
                            }else if(cr.Operator__c == 'less or equal'){
                                fields += '' + cr.Field__c + ' <= \'' + cr.Value__c + '\' AND ';
                            }else if(cr.Operator__c == 'greater or equal'){
                                fields += '' + cr.Field__c + ' >= \'' + cr.Value__c + '\' AND ';
                            }
                        }
                        
                    }
                    
                    if(!String.isEmpty(fields)) {
                        
                        if( fields.endsWith(' AND ')){
                            fields = fields.removeEnd(' AND ');
                        }
                        
                        query += ' FROM ' + sObjectType + ' WHERE Id IN:  newRecordIds AND ' + fields;
                        List<sObject> result = Database.query(query);
                        
                        if(!result.isEmpty()){
                            for(sObject s : result){
                                SObject sobj = Schema.getGlobalDescribe().get(String.valueOf(s.getSObjectType())).newSObject();
                                sobj.put('OwnerId', ownerId);
                                sobj.put('Id', String.valueOf(s.get('Id')));
                                if(resultsToUpdate.get(String.valueOf(s.get('Id'))) == null){
                                    resultsToUpdate.put(String.valueOf(s.get('Id')), sobj);
                                }
                            }
                        }
                    }
                    if(!resultsToUpdate.isEmpty()){ 
                        //create emails for any updated records
                        createEmails(resultsToUpdate.values(), entry);
                        continue;
                    }
                }
            }
        }
    }
    
    //populate email with those whos owners got changed
    private static void createEmails(List<SObject> sobjects, Assignment_Rule_Entry__c entry){
        if(entry.Send_Email__c){
            for(SObject sobj : sobjects){
                Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(String.valueOf(sobj.get('OwnerId')));
                mail.setSubject('New Record Assignment');
                mail.setHtmlBody('A new record has been assigned to you.<br><br>The record can be found here: <a href="' 
                                 + URL.getSalesforceBaseUrl().toExternalForm() + '/' + String.valueOf(sobj.get('Id')) + '">' 
                                 + URL.getSalesforceBaseUrl().toExternalForm() + '/' + String.valueOf(sobj.get('Id')) + '</a>');
                mail.setTreatTargetObjectAsRecipient(true);
                mail.setSaveAsActivity(false);
                emails.add(mail);
            }
        }
    }
    
    
    //send emails    
    private static void sendEmail(){
        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }
    }
}