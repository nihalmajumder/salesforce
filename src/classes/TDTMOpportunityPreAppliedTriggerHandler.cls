global class TDTMOpportunityPreAppliedTriggerHandler extends TDTMVirtualTriggerHandler {
    global override void onBeforeInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        List<Opportunity> opps = new List<Opportunity>();
        Set<Id> contactIds = new Set<Id>();
        for (SObject o : newList) {
            Opportunity opp = (Opportunity) o;
            if (opp.StageName == 'Inquired' && opp.Stage_Detail__c == 'Inquired' && opp.Contact__c != null) {
                opps.add(opp);
                contactIds.add(opp.Contact__c);
            }
        }
        if (!contactIds.isEmpty()) {
            Map<Id, Boolean> checkMap = doDocumentCheck(contactIds);
            for (Opportunity opp : opps) {
                Boolean check = checkMap.get(opp.Contact__c);
                if (check != null && check == true) {
                    opp.Stage_Detail__c = 'Pre-Applied';
                }
            }
        }
    }

    private Map<Id, Boolean> doDocumentCheck(Set<Id> contactIds) {
        Map<Id, Boolean> checkMap = new Map<Id, Boolean>();
        for (Admissions_Document__c doc : [SELECT Id, Contact__c, Status__c FROM Admissions_Document__c WHERE Contact__c IN :contactIds AND Status__c = 'Received']) {
            checkMap.put(doc.Contact__c, true);
        }
        for (Education_History__c doc : [SELECT Id, Contact__c, Document_Status__c FROM Education_History__c WHERE Contact__c IN :contactIds AND Document_Status__c = 'Received']) {
            checkMap.put(doc.Contact__c, true);
        }
        for (Test_Score__c doc : [SELECT Id, Contact__c, Document_Status__c FROM Test_Score__c WHERE Contact__c IN :contactIds AND Document_Status__c = 'Received']) {
            checkMap.put(doc.Contact__c, true);
        }
        return checkMap;
    }
}