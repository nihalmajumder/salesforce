/**
 * Created by ejc84332 on 11/5/19.
 */


global class TDTM_Reference_Trigger_Handler extends TDTMVirtualTriggerHandler {

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        try {
            Set<Id> contactIds = new Set<Id>();
            for (SObject o : newList) {
                Reference__c ref = (Reference__c) o;
                Reference__c old_ref = (Reference__c) oldMap.get(o.Id);
                if (ref.Signature__c != null && old_ref.Signature__c == null) {
                    contactIds.add(ref.Contact__c);
                }
            }
            if (!contactIds.isEmpty()) {

                List<Application__c> apps = ApplicationHelper.getApplicationsForContacts(contactIds);
                if (!apps.isEmpty()) {
                    for(Application__c app: apps){
                        ApplicationHelper.checkCompletionFuture(app.Id);
                    }
                }
            }
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }
    }

    global override void onAfterInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        try {
            Set<Id> contactIds = new Set<Id>();
            for (SObject o : newList) {
                Reference__c ref = (Reference__c) o;
                if (ref.Signature__c != null) {
                    contactIds.add(ref.Contact__c);
                }
            }
            if (!contactIds.isEmpty()) {

                List<Application__c> apps = ApplicationHelper.getApplicationsForContacts(contactIds);
                if (!apps.isEmpty()) {
                    for(Application__c app: apps){
                        ApplicationHelper.checkCompletionFuture(app.Id);
                    }
                }
            }
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }
    }

}