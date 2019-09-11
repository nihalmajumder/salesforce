global class TDTMEducationHistoryTriggerHandler extends TDTMVirtualTriggerHandler {

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        try {
            Set<Id> contactIds = new Set<Id>();
            for (SObject o : newList) {
                Education_History__c history = (Education_History__c) o;
                Education_History__c oldHistory = (Education_History__c) oldMap.get(o.Id);
                if (history.Document_Status__c != null && history.Document_Status__c != 'Mandatory' && history.Document_Status__c != 'Not Received' && history.Document_Status__c != oldHistory.Document_Status__c && history.Contact__c != null) {
                    contactIds.add(history.Contact__c);
                }
            }
            if (!contactIds.isEmpty()) {

                List<Application__c> apps = ApplicationHelper.getApplicationsForContacts(contactIds);
                if (!apps.isEmpty()) {
                    ApplicationHelper.checkCompletion(apps);
                }
            }
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
}