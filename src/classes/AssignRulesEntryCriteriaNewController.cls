/*
*
* controller for assignment rules entry criteria new lightning component
*
*
*
*/
public with sharing class AssignRulesEntryCriteriaNewController {
    
    static Id assignmentCritRecTypeId = Schema.SObjectType.Assignment_Rule_Criteria_Based_Rule__c.getRecordTypeInfosByName().get('Assignment Rule Entry Criteria - Criteria').getRecordTypeId();
    static Id critBasedRuleRecTypeId = Schema.SObjectType.Assignment_Rule_Entry__c.getRecordTypeInfosByDeveloperName().get('Criteria_Based_Rule').getRecordTypeId();
    
    //map of all active users
    public static Map<Id, User> userMap { 
        get { 
            if( userMap == null) {
                userMap = new Map<Id, User> ([SELECT id, Name, Email FROM User WHERE IsActive =: true]); 
            }
            return userMap;
        }
        private set;
    }
    //map of all active queues
    public static Map<Id, Group> groupMap { 
        get{ 
            if(groupMap == null) {
                groupMap = new Map<Id, Group> ([SELECT id, Name, Email FROM Group WHERE Type =: 'Queue']); 
            }
            return groupMap;
        }
        private set;
    }
    
    //build operators manually
    @AuraEnabled(cacheable=true)
    public static String getOperators(){
        Map<String, List<AssignmentRuleWrapperObjects.ComboboxWrapper>> operatorMap = new Map<String, List<AssignmentRuleWrapperObjects.ComboboxWrapper>>();
        operatorMap.put('STRINGS', 
                        new List<AssignmentRuleWrapperObjects.ComboboxWrapper>{
                            new AssignmentRuleWrapperObjects.ComboboxWrapper('-- none --', ''), 
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('equals', 'equals'),  
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('not equal to', 'not equal to'), 
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('starts with', 'starts with'), 
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('contains', 'contains'), 
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('does not contains', 'does not contains'), 
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('less than', 'less than'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('greater than','greater than'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('less or equal', 'less or equal'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('greater or equal', 'greater or equal')});
        
        
        
        operatorMap.put('BOOLEAN', 
                        new List<AssignmentRuleWrapperObjects.ComboboxWrapper>{
                            new AssignmentRuleWrapperObjects.ComboboxWrapper('-- none --', ''),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('equals', 'equals'),  
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('not equal to', 'not equal to')
                                });
        
        
        operatorMap.put('GENERAL', 
                        new List<AssignmentRuleWrapperObjects.ComboboxWrapper>{ 
                            new AssignmentRuleWrapperObjects.ComboboxWrapper('-- none --', ''),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('equals', 'equals'),  
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('not equal to', 'not equal to'), 
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('less than', 'less than'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('greater than','greater than'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('less or equal', 'less or equal'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('greater or equal', 'greater or equal')
                                });
        
        operatorMap.put('MULTIPICKLIST', 
                        new List<AssignmentRuleWrapperObjects.ComboboxWrapper>{
                            new AssignmentRuleWrapperObjects.ComboboxWrapper('-- none --', ''),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('equals', 'equals'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('not equal to', 'not equal to'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('includes', 'includes'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('excludes', 'excludes')
                                });
        
        
        operatorMap.put('ANYASSIGN', 
                        new List<AssignmentRuleWrapperObjects.ComboboxWrapper>{
                            new AssignmentRuleWrapperObjects.ComboboxWrapper('-- none --', ''),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('equals', 'equals')
                                });
        
        
        
        return JSON.serialize(operatorMap);
    }
    
    
    /*
* 
* this function retrieves an existing rule entry
* and is used when edit button is called for a rule entry
* 
* if any exceptions occur, just allow them to stop the app
* 
* @param id - is of rule entry
* @return string - json of wrapper object
* 
*/ 
     @AuraEnabled(cacheable=true)
    public static string retrieveRuleEntry(String id){
        
        
        Assignment_Rule_Entry__c entry = [SELECT id, 
                                          Order__c, 
                                          Assignment_Rule__c, 
                                          Assignment_Rule__r.sObject__c, 
                                          Filter_Logic__c, 
                                          Assigned_To__c, 
                                          Send_Email__c,
                                          (SELECT id, 
                                           Field__c, 
                                           Field_Label__c,
                                           FieldType__c,
                                           Operator__c,
                                           Position__c, 
                                           SObject_Type__c,
                                           Value__c FROM Assignment_Rule_Criteria_Based_Rules__r ORDER BY Position__c ASC) 
                                          FROM Assignment_Rule_Entry__c WHERE Id =: id];
        
        AssignmentRuleWrapperObjects.EntryWrapper entryWrapper = new AssignmentRuleWrapperObjects.EntryWrapper();
        entryWrapper.order = Integer.valueOf(entry.Order__c);
        entryWrapper.id = entry.Id;
        entryWrapper.filterLogic = entry.Filter_Logic__c;
        entryWrapper.assignmenRuleId = entry.Assignment_Rule__c;
        entryWrapper.assignedTo = entry.Assigned_To__c;
        entryWrapper.assignedToName = userMap.get(entry.Assigned_To__c) != null ? userMap.get(entry.Assigned_To__c).Name 
            : groupMap.get(entry.Assigned_To__c) != null ? groupMap.get(entry.Assigned_To__c).Name : null;
        entryWrapper.sendEmail = entry.Send_Email__c;
        
        SObjectType s_object = Schema.getGlobalDescribe().get(entry.Assignment_Rule__r.sObject__c);
        Map<String,Schema.SObjectField> mfields = s_object.getDescribe().fields.getMap();
        
        //loop through the entry criteria 
        //add them to the wrapper
        for( Assignment_Rule_Criteria_Based_Rule__c crit : entry.Assignment_Rule_Criteria_Based_Rules__r){
            AssignmentRuleWrapperObjects.EntryCriteriaWrapper critWrapper = new AssignmentRuleWrapperObjects.EntryCriteriaWrapper();
            
            critWrapper.id = crit.Id;
            critWrapper.position = Integer.valueOf(crit.Position__c);
            critWrapper.field = crit.Field__c;
            critWrapper.operator = crit.Operator__c;
            critWrapper.fieldLabel = crit.Field_Label__c;
            critWrapper.dataType = crit.FieldType__c;
            critWrapper.value = crit.Value__c;
            critWrapper.sobjectType = crit.SObject_Type__c;
            
            if(entryWrapper.criteria == null){
                entryWrapper.criteria = new List<AssignmentRuleWrapperObjects.EntryCriteriaWrapper>();
            }
            
            entryWrapper.criteria.add(critWrapper);
        }
        
        //recreates the 5 empty rows on initial start
        if(entryWrapper.criteria[0].dataType != 'ANYASSIGN' && entryWrapper.criteria.size() < 5){
            while(entryWrapper.criteria.size() < 5){
                entryWrapper.criteria.add(new AssignmentRuleWrapperObjects.EntryCriteriaWrapper());
            }
        }
        
        return JSON.serialize(entryWrapper);
    }
    
    /*
* 
* this function deserializes passed in json object
* and creates the rule entry and rule entry criteria records
* with the data passed in
* 
* if any exceptions occur, just allow them to stop the app
* 
* @param entryJSON - json of entry passed in from lightning component
* 
*/ 
    @AuraEnabled
    public static void handleUpsertEntry(String entryJSON){
        AssignmentRuleWrapperObjects.EntryWrapper entryWrapper = (AssignmentRuleWrapperObjects.EntryWrapper) JSON.deserialize(entryJSON, AssignmentRuleWrapperObjects.EntryWrapper.class);
        Assignment_Rule_Entry__c entry = new Assignment_Rule_Entry__c();
        List<Assignment_Rule_Criteria_Based_Rule__c> critRules = new List<Assignment_Rule_Criteria_Based_Rule__c>();
        
        //only set the assignment rule id if this is a new record
        if(!String.isEmpty(entryWrapper.id) && entryWrapper.id != null){
            entry.Id = entryWrapper.id;
        }else{
            entry.Assignment_Rule__c = entryWrapper.assignmenRuleId;
        }
        entry.Order__c =  entryWrapper.order;
        entry.Filter_Logic__c = entryWrapper.filterLogic;
        entry.Assigned_To__c =  entryWrapper.assignedTo;
        entry.Send_Email__c = entryWrapper.sendEmail != null ? entryWrapper.sendEmail : false;
        entry.RecordTypeId = critBasedRuleRecTypeId;
        
        //create / upsert the rule entry first
        upsert entry;
        
        for(AssignmentRuleWrapperObjects.EntryCriteriaWrapper critWrapper :  entryWrapper.criteria){
            Assignment_Rule_Criteria_Based_Rule__c critRule = new Assignment_Rule_Criteria_Based_Rule__c();
            critRule.Field__c = critWrapper.field;
            critRule.Value__c = critWrapper.value;
            critRule.Operator__c = critWrapper.operator;
            critRule.Position__c = critWrapper.position;
            critRule.FieldType__c = critWrapper.dataType;
            critRule.Field_Label__c = critWrapper.fieldLabel;
            critRule.SObject_Type__c = critWrapper.sobjectType;
            critRule.RecordTypeId = assignmentCritRecTypeId;
            if(!String.isEmpty(critWrapper.id)){
                critRule.Id = critWrapper.Id;
            }else{
                critRule.Assignment_Rule_Entry_Criteria__c = entry.Id;
            }
            critRules.add(critRule);
        }
        
        //create / upsert the rule entry criteria after
        upsert critRules;
        
        //if there are any to delete, then delete them
        if(entryWrapper.deleteCriteria != null && !entryWrapper.deleteCriteria.isEmpty()){
            List<Id> recordsToDelete = new List<Id>();
            for(String s : entryWrapper.deleteCriteria){
                recordsToDelete.add(Id.valueOf(s));
            }
            Database.delete(recordsToDelete);
        }
        
    }
    
}