global class TDTMAdmissionsDocumentTriggerHandler extends TDTMVirtualTriggerHandler {

    global static Boolean skipTrigger = false;

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        try {
            if (!skipTrigger) {
                Set<Id> contactIds = new Set<Id>();
                for (SObject o : newList) {
                    Admissions_Document__c doc = (Admissions_Document__c) o;
                    Admissions_Document__c oldDoc = (Admissions_Document__c) oldMap.get(o.Id);
                    if (doc.Status__c != null && doc.Status__c != 'Mandatory' && doc.Status__c != oldDoc.Status__c && doc.Contact__c != null) {
                        contactIds.add(doc.Contact__c);
                    }
                }
                if (!contactIds.isEmpty()) {

                    List<Opportunity> opps = OpportunityHelper.getInquiredOpportunitiesForContact(contactIds);
                    if (!opps.isEmpty()) {
                        for (Opportunity o : opps) {
                            o.Stage_Detail__c = 'Pre-Applied';
                        }
                        update opps;
                    }

                    List<Application__c> apps = ApplicationHelper.getApplicationsForContacts(contactIds);
                    if (!apps.isEmpty()) {
                        ApplicationHelper.checkCompletion(apps);
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
            if (!skipTrigger) {
                Set<Id> contactIds = new Set<Id>();
                for (SObject o : newList) {
                    Admissions_Document__c doc = (Admissions_Document__c) o;
                    if (doc.Status__c != null && doc.Status__c != 'Mandatory' && doc.Contact__c != null) {
                        contactIds.add(doc.Contact__c);
                    }
                }
                if (!contactIds.isEmpty()) {

                    List<Opportunity> opps = OpportunityHelper.getInquiredOpportunitiesForContact(contactIds);
                    if (!opps.isEmpty()) {
                        for (Opportunity o : opps) {
                            o.Stage_Detail__c = 'Pre-Applied';
                        }
                        update opps;
                    }
                    
                    List<Application__c> apps = ApplicationHelper.getApplicationsForContacts(contactIds);
                    if (!apps.isEmpty()) {
                        ApplicationHelper.checkCompletion(apps);
                    }
                }
            }
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
}