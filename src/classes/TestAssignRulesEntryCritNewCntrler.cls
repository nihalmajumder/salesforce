@isTest
public class TestAssignRulesEntryCritNewCntrler {
    
    @testSetup
    static void testSetup(){
        TestUtility.setupTestData();
    }
    
    static testMethod void testGetOperators(){
        test.startTest();
        String operators = AssignRulesEntryCriteriaNewController.getOperators();
        test.stopTest();
        Map<String, List<AssignmentRuleWrapperObjects.ComboboxWrapper>> wrapper  = (Map<String, List<AssignmentRuleWrapperObjects.ComboboxWrapper>>) JSON.deserialize(operators, Map<String, List<AssignmentRuleWrapperObjects.ComboboxWrapper>>.class);
        System.assert(!wrapper.isEmpty());
    }
    
    static testMethod void testRetrieveRuleEntry(){
        List<Assignment_Rule_Entry__c> ruleEntries = [SELECT id,
                                                      Order__c, 
                                                      Assignment_Rule__c, 
                                                      Filter_Logic__c, 
                                                      Assigned_To__c, 
                                                      Send_Email__c, (SELECT id, 
                                                                      Field__c, 
                                                                      Field_Label__c,
                                                                      FieldType__c,
                                                                      Operator__c,
                                                                      Position__c, 
                                                                      SObject_Type__c,
                                                                      Value__c FROM Assignment_Rule_Criteria_Based_Rules__r ORDER BY Position__c ASC)
                                                      FROM Assignment_Rule_Entry__c  LIMIT 1];
        test.startTest();
        String ruleEntry = AssignRulesEntryCriteriaNewController.retrieveRuleEntry(ruleEntries.get(0).Id);
        test.stopTest();
        AssignmentRuleWrapperObjects.EntryWrapper entryWrapper = (AssignmentRuleWrapperObjects.EntryWrapper) JSON.deserialize(ruleEntry, AssignmentRuleWrapperObjects.EntryWrapper.class);
        
        System.assertEquals(ruleEntries.get(0).Id, entryWrapper.id);
        System.assertEquals(ruleEntries.get(0).Send_Email__c, entryWrapper.sendEmail);
        System.assertEquals(ruleEntries.get(0).Filter_Logic__c, entryWrapper.filterLogic);
        System.assertEquals(ruleEntries.get(0).Order__c, entryWrapper.order);
        System.assertEquals(ruleEntries.get(0).Assignment_Rule__c, entryWrapper.assignmenRuleId);
    }
    
    static testMethod void testHandleUpsertEntry(){
          List<Assignment_Rule_Entry__c> ruleEntries = [SELECT id,
                                                      Order__c, 
                                                      Assignment_Rule__c, 
                                                      Filter_Logic__c, 
                                                      Assigned_To__c, 
                                                      Send_Email__c, (SELECT id, 
                                                                      Field__c, 
                                                                      Field_Label__c,
                                                                      FieldType__c,
                                                                      Operator__c,
                                                                      Position__c, 
                                                                      SObject_Type__c,
                                                                      Value__c FROM Assignment_Rule_Criteria_Based_Rules__r ORDER BY Position__c ASC)
                                                        FROM Assignment_Rule_Entry__c  LIMIT 1];
        
        String ruleEntry = AssignRulesEntryCriteriaNewController.retrieveRuleEntry(ruleEntries.get(0).Id);
        AssignmentRuleWrapperObjects.EntryWrapper entryWrapper = (AssignmentRuleWrapperObjects.EntryWrapper) JSON.deserialize(ruleEntry, AssignmentRuleWrapperObjects.EntryWrapper.class);
        entryWrapper.order = 99;
        entryWrapper.sendEmail = true;
        entryWrapper.filterLogic = 'GIBERISH';
        entryWrapper.deleteCriteria = new List<String>();
        entryWrapper.deleteCriteria.add(ruleEntries.get(0).Assignment_Rule_Criteria_Based_Rules__r.get(0).id);
        String entryJSON = JSON.serialize(entryWrapper);
        
        test.startTest();
        AssignRulesEntryCriteriaNewController.handleUpsertEntry(entryJSON);
        test.stopTest();
        
        List<Assignment_Rule_Entry__c> updatedRuleEntries = [SELECT id,
                                                             Order__c, 
                                                             Assignment_Rule__c, 
                                                             Filter_Logic__c, 
                                                             Send_Email__c FROM Assignment_Rule_Entry__c WHERE id =: ruleEntries.get(0).Id ];
        
        //rule entry has been updated with new values
        System.assertEquals(99, updatedRuleEntries.get(0).Order__c);
        System.assertEquals(true, updatedRuleEntries.get(0).Send_Email__c);
        System.assertEquals('GIBERISH', updatedRuleEntries.get(0).Filter_Logic__c);
        System.assertEquals(0, [SELECT COUNT() FROM Assignment_Rule_Criteria_Based_Rule__c WHERE id =: ruleEntries.get(0).Assignment_Rule_Criteria_Based_Rules__r.get(0).id]);
        
    }
}