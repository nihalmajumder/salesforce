@isTest
public class TestAssignRulesRuleEntriesController {
    
    @testSetup
    static void testSetup(){
        TestUtility.setupTestData();
    }
    
    static testMethod void testRetrieveAssignmentRules(){
        List<Assignment_Rule__c> assignmentRules = new List<Assignment_Rule__c>();
        test.startTest();
        assignmentRules =  AssignRulesRuleEntriesController.retrieveAssignmentRules('Account');
        test.stopTest();
        System.assert(!assignmentRules.isEmpty());
    }
    
}