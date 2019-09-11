public with sharing class AssignRulesRuleEntryCriteriaController {
    
    /*
* 
* this method retrieves the assignment rule entries 
* for a specified assignment rule id
* 
* @param ruleId - assignment rule id
* @return collection of wrapper objects
* 
*/ 
    @AuraEnabled(cacheable=true)
    public static String retrieveAssignmentRuleEntries(String ruleId){
        List< AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper> entries = new List< AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper>();
        
        for(Assignment_Rule_Entry__c entry : [SELECT id, Order__c, Assigned_To__c, Send_Email__c, Filter_Logic__c,
                                              (SELECT Field__c, Field_Label__c, Operator__c, Value__c, Position__c, SObject_Type__c FROM Assignment_Rule_Criteria_Based_Rules__r ORDER BY Position__c ASC)
                                              FROM Assignment_Rule_Entry__c WHERE Assignment_Rule__c =: ruleId ORDER BY Order__c ])
        {
            AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper wrapper = new  AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper();
            wrapper.order = Integer.valueOf(entry.Order__c);
            wrapper.Id = entry.Id;
            wrapper.assignedToId = entry.Assigned_To__c;
            wrapper.AssignedToName = AssignRulesEntryCriteriaNewController.userMap.get(entry.Assigned_To__c) != null 
                ? AssignRulesEntryCriteriaNewController.userMap.get(entry.Assigned_To__c).Name : AssignRulesEntryCriteriaNewController.groupMap.get(entry.Assigned_To__c) != null 
                    ? AssignRulesEntryCriteriaNewController.groupMap.get(entry.Assigned_To__c).Name : '';
            wrapper.sendEmail = entry.Send_Email__c;
            if(!entry.Assignment_Rule_Criteria_Based_Rules__r.isEmpty()){
                wrapper.criteria = '';
                
                if(entry.Filter_Logic__c != null){
                    String filter = '';
                    Integer size = entry.Filter_Logic__c.length();
                    
                    for(Integer i = 0; i < size; i++){                      
                        if(entry.Filter_Logic__c.subString(i, i + 1).isNumeric()){
                            filter += '(' + entry.Filter_Logic__c.subString(i, i + 1) + ')';
                        }else{
                            filter += entry.Filter_Logic__c.subString(i, i + 1);
                        }
                    }
                    for(Assignment_Rule_Criteria_Based_Rule__c cr : entry.Assignment_Rule_Criteria_Based_Rules__r){
                        String criteria = cr.SObject_Type__c != null ? '(' + cr.Field_Label__c + ' ' + cr.Operator__c + ' ' + cr.Value__c + ')' 
                            :  '(' + cr.Field_Label__c + ' ' + cr.Operator__c + ' ' + cr.Value__c + ')';
                        filter = filter.replace('(' + String.valueOf(cr.Position__c) + ')', criteria);
                    }
                    
                    wrapper.criteria = filter;
                    
                }else{
                    for(Assignment_Rule_Criteria_Based_Rule__c cr : entry.Assignment_Rule_Criteria_Based_Rules__r){
                        wrapper.criteria += cr.SObject_Type__c != null ? '(' + cr.Field_Label__c + ' ' + cr.Operator__c + ' ' + cr.Value__c + ') AND ' 
                            : '(' + cr.Field_Label__c + ' ' + cr.Operator__c + ' ' + cr.Value__c + ') AND ';
                    }
                    if( wrapper.criteria.endsWith(' AND ')){
                        wrapper.criteria = wrapper.criteria.removeEnd(' AND ');
                    }
                }
            }
            entries.add(wrapper);
        }
        
        return JSON.serialize(entries);
    }
    
}