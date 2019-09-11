@isTest
public class TestAssignmentRulesRuleEntryController {
    
    @testSetup
    static void testSetup(){
        TestUtility.setupTestDataCriteriaBasedRule();
    }
    
    static testMethod void testGetOperators(){
        test.startTest();
        System.assert(!String.isEmpty(AssignmentRulesRuleEntryController.getOperators()));
        test.stopTest();
    }
    
    static testMethod void testRetrieveRuleCriteria(){
        Id ruleId = [SELECT id FROM Assignment_Rule__c].Id;
        test.startTest();
        System.assert(!String.isEmpty(AssignmentRulesRuleEntryController.retrieveRuleCriteria(ruleId)));
        test.stopTest();
    }
    
    static testMethod void testCreateRuleEntry(){
        //create assignment rule for account sobject
        Assignment_Rule__c  assignmentRule = new Assignment_Rule__c(Name = 'For Test Class 2', sObject__c = 'Account', Active__c = true);
        insert assignmentRule;
        
        AssignmentRuleWrapperObjects.EntryCriteriaWrapper critWrapper = new AssignmentRuleWrapperObjects.EntryCriteriaWrapper();
        critWrapper.field = 'Name';
        critWrapper.operator = 'equals';
        critWrapper.fieldLabel = 'Account Name';
        critWrapper.dataType = 'STRING';
        critWrapper.value = 'Test';
        critWrapper.sobjectType = 'Account';
        
        test.startTest();
        AssignmentRulesRuleEntryController.createRuleEntry(JSON.serialize(critWrapper), assignmentRule.Id);
        test.stopTest();
        
        Assignment_Rule_Criteria_Based_Rule__c criteria = [SELECT id, Value__c FROM Assignment_Rule_Criteria_Based_Rule__c WHERE Assignment_Rule__c =: assignmentRule.Id];
        
        System.assert(criteria.value__c == 'Test');
        
    }
    
    static testMethod void testUpsertRuleEntry(){
        //create assignment rule for account sobject
        Assignment_Rule__c  assignmentRule = [SELECT id FROM Assignment_Rule__c];
        Assignment_Rule_Criteria_Based_Rule__c criteria = [SELECT id, Value__c FROM Assignment_Rule_Criteria_Based_Rule__c WHERE Assignment_Rule__c =: assignmentRule.Id];
        
        System.assert(criteria.Value__c != 'Testing new');
        
        AssignmentRuleWrapperObjects.EntryCriteriaWrapper critWrapper = new AssignmentRuleWrapperObjects.EntryCriteriaWrapper();
        critWrapper.field = 'Name';
        critWrapper.operator = 'equals';
        critWrapper.fieldLabel = 'Account Name';
        critWrapper.dataType = 'STRING';
        critWrapper.value = 'Testing new';
        critWrapper.sobjectType = 'Account';
        critWrapper.Id = criteria.Id;
        
        test.startTest();
        AssignmentRulesRuleEntryController.upsertRuleEntry(JSON.serialize(critWrapper), assignmentRule.Id);
        test.stopTest();
        
        criteria = [SELECT id, Value__c FROM Assignment_Rule_Criteria_Based_Rule__c WHERE Assignment_Rule__c =: assignmentRule.Id];
        
        System.assert(criteria.Value__c == 'Testing new');
    }
    
    static testMethod void testDeleteRuleEntry(){
        //create assignment rule for account sobject
        Assignment_Rule__c  assignmentRule = [SELECT id FROM Assignment_Rule__c];
        Assignment_Rule_Criteria_Based_Rule__c criteria = [SELECT id, Value__c FROM Assignment_Rule_Criteria_Based_Rule__c WHERE Assignment_Rule__c =: assignmentRule.Id];
        
        AssignmentRuleWrapperObjects.EntryCriteriaWrapper critWrapper = new AssignmentRuleWrapperObjects.EntryCriteriaWrapper();
        critWrapper.field = 'Name';
        critWrapper.operator = 'equals';
        critWrapper.fieldLabel = 'Account Name';
        critWrapper.dataType = 'STRING';
        critWrapper.value = 'Testing new';
        critWrapper.sobjectType = 'Account';
        critWrapper.Id = criteria.Id;
        
        test.startTest();
        AssignmentRulesRuleEntryController.deleteRuleEntry(JSON.serialize(critWrapper));
        test.stopTest();
        
        System.assertEquals(0, [SELECT COUNT() FROM Assignment_Rule_Criteria_Based_Rule__c WHERE Assignment_Rule__c =: assignmentRule.Id]);
    }
}