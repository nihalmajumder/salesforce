public with sharing class AssignRulesRuleEntriesController {
    
    /*
* 
* this method retrieves the assignment rule
* for a specified sobject type
* 
* @param sobjectType - string of object type
* @return collection of wrapper objects
* 
*/ 
    @AuraEnabled(cacheable=true)
    public static List<Assignment_Rule__c> retrieveAssignmentRules(String sobjectType){
        List<Assignment_Rule__c> rules = [SELECT id, Name, Active__c FROM Assignment_Rule__c WHERE sObject__c =: sobjectType Order by Name ASC];
        return rules;
    }

}