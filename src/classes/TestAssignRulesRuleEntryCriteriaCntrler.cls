@isTest
public class TestAssignRulesRuleEntryCriteriaCntrler {
    
    @testSetup
    static void testSetup(){
         TestUtility.setupTestData();
    }
    
    static testMethod void testRetrieveAssignmentRuleEntries(){
        Assignment_Rule__c rule = [SELECT id FROM Assignment_Rule__c];
        test.startTest();
        String ruleEntries = AssignRulesRuleEntryCriteriaController.retrieveAssignmentRuleEntries(rule.Id);
        test.stopTest();
        List<AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper> entries = (List<AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper>) JSON.deserialize(ruleEntries, List<AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper>.class);
        System.assert(!entries.isEmpty());
        
    }

}