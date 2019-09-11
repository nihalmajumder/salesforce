public with sharing class AssignRulesRuleEntryCritDataController {
  /*
* 
* this function saves is used to save existing rule entries
* and is used when the user modifys the order of the entries using
* the drag sort functionality
* 
* if any exceptions occur, just allow them to stop the app
* 
* @param ruleEntries - string json of wrapper object
* 
*/ 
    @AuraEnabled
    public static void saveEntries(String ruleEntries){
        List<AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper> entryWrapperList = (List<AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper>) JSON.deserialize(ruleEntries, List<AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper>.class);
        List<Assignment_Rule_Entry__c> entries = new List<Assignment_Rule_Entry__c>();
        
        for(AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper wrapper : entryWrapperList){
            entries.add(new Assignment_Rule_Entry__c( Id = wrapper.Id, Order__c = wrapper.Order));
        }
        
        if(!entries.isEmpty()){
            update entries;
        }
    }
}