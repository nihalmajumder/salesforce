@isTest
public class TestAssignRulesRuleEntCritDataCntrl {
    
    @testSetup
    static void testSetup(){
        TestUtility.setupTestData();
    }
    
    static testMethod void testSaveEntries(){
        
        List<Assignment_Rule_Entry__c> entries = [SELECT id, Order__c FROM Assignment_Rule_Entry__c ORDER BY id];
        
        Map<Id, Integer> orderMap = new Map<Id, Integer>();
        orderMap.put(entries.get(0).Id, Integer.valueOf(entries.get(0).Order__c));
        orderMap.put(entries.get(1).Id, Integer.valueOf(entries.get(1).Order__c));
        
        List<AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper> wrapperList = new List<AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper>();
        
        for(Assignment_Rule_Entry__c entry : entries){
            AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper wrapper = new AssignmentRuleWrapperObjects.AssignmentRuleEntryWrapper();
            Decimal order = entry.Order__c == 1.0 ? 2.0 : 1.0;
            wrapper.order = Integer.valueOf(order);
            wrapper.assignedToId = UserInfo.getUserId();
            wrapper.criteria = 'none';
            wrapper.Id = entry.Id;
            wrapper.sendEmail = false;
            wrapper.assignedToName = 'Bob';
            wrapperList.add(wrapper);
        }
        
        
        String ruleEntries = JSON.serialize(wrapperList);
        
        test.startTest();
        AssignRulesRuleEntryCritDataController.saveEntries(ruleEntries);
        test.stopTest();
        
        //order has been swapped
        for(Assignment_Rule_Entry__c entry : [SELECT id, Order__c FROM Assignment_Rule_Entry__c ORDER BY id]){
            System.assert(entry.Order__c != orderMap.get(entry.Id));
        }
  
    }
    
}