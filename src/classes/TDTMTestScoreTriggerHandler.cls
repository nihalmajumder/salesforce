global class TDTMTestScoreTriggerHandler extends TDTMVirtualTriggerHandler {

    global override void onBeforeUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        Map<ID, Schema.RecordTypeInfo> infoMap = Schema.SObjectType.Test_Score__c.getRecordTypeInfosById();
        for (SObject o : newList) {
            Test_Score__c score = (Test_Score__c) o;
            Test_Score__c oldScore = (Test_Score__c) oldMap.get(o.Id);
            String name = infoMap.get(score.RecordTypeId).getName();
            if (score.RecordTypeId != oldScore.RecordTypeId && name != score.Test_Type__c) {
                score.Test_Type__c = name;
            }
            else if (score.Test_Type__c != oldScore.Test_Type__c && name != score.Test_Type__c) {
                if (score.Test_Type__c == null) {
                    score.Test_Type__c = name;
                }
                else {
                    Schema.RecordTypeInfo info = Schema.SObjectType.Test_Score__c.getRecordTypeInfosByName().get(score.Test_Type__c);
                    if (info != null) {
                        score.RecordTypeId = info.getRecordTypeId();
                    }
                }
            }
        }
    }

    global override void onBeforeInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        Map<ID, Schema.RecordTypeInfo> infoMap = Schema.SObjectType.Test_Score__c.getRecordTypeInfosById();
        for (SObject o : newList) {
            Test_Score__c score = (Test_Score__c) o;
            String name = infoMap.get(score.RecordTypeId).getName();
            if (score.Test_Type__c == null) {
                score.Test_Type__c = name;
            }
            else if (score.Test_Type__c != name) {
                Schema.RecordTypeInfo info = Schema.SObjectType.Test_Score__c.getRecordTypeInfosByName().get(score.Test_Type__c);
                if (info != null) {
                    score.RecordTypeId = info.getRecordTypeId();
                }
            }
        }
    }

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        try {
            Set<Id> contactIds = new Set<Id>();
            for (SObject o : newList) {
                Test_Score__c score = (Test_Score__c) o;
                Test_Score__c oldScore = (Test_Score__c) oldMap.get(o.Id);
                if (score.Document_Status__c != null && score.Document_Status__c != 'Mandatory' && score.Document_Status__c != oldScore.Document_Status__c && score.Contact__c != null) {
                    contactIds.add(score.Contact__c);
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

    global override void onAfterInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        try {
            Set<Id> contactIds = new Set<Id>();
            for (SObject o : newList) {
                Test_Score__c score = (Test_Score__c) o;
                if (score.Document_Status__c != null && score.Document_Status__c != 'Mandatory' && score.Contact__c != null) {
                    contactIds.add(score.Contact__c);
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