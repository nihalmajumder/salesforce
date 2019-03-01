/*
 * 
 * Test class - TDTMApplicationTriggerHandlerTest
 * 
 * 
 */ 
global class TDTMApplicationTriggerHandler extends TDTMVirtualTriggerHandler {

    global override void onBeforeUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        ApplicationHelper.updateFilters(newList);
    }

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        List<Application__c> apps = new List<Application__c>();
        for (SObject o : newList) {
            Application__c app = (Application__c) o;
            Application__c oldApp = (Application__c) oldMap.get(o.Id);
            if (app.Intended_Program__c != oldApp.Intended_Program__c) {
                apps.add(app);
            }
        }
        if (!apps.isEmpty()) {
            InteractionHelper.createInteractionForChangedApplication(apps);
        }
    }
}