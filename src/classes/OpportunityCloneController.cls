public with sharing class OpportunityCloneController {

    @AuraEnabled
    public static Opportunity cloneOpportunity(Id oppId) {
        Opportunity newOpp = null;
        try {
            Map<String, Schema.SObjectField> fieldMap = Opportunity.sObjectType.getDescribe().fields.getMap();
            List<String> fieldNames = new List<String>(fieldMap.keySet());
            List<Opportunity> opps = Database.query('SELECT ' + String.join(fieldNames, ',') + ' FROM Opportunity WHERE Id = :oppId');
            if (!opps.isEmpty()) {
                newOpp = opps[0].clone();

                // If we are cloning an enrolled app and the school is CAS, leave it at enrolled.
                // It is a PSEO app that we are cloning forward so they can apply for normal enrollment.
                if(!(newOpp.StageName == 'Enrolled' && newOpp.School_College__c == 'Undergraduate')){
                    newOpp.Application__c = null;
                    newOpp.StageName = 'File Closed';
                    newOpp.Withdrawal_Reason__c = 'ST - Switching Terms';

                    // if it is already File Closed, no need to calculate a new Stage Detail.
                    if(!newOpp.Stage_Detail__c.contains('File Closed')){
                        Set<String> details = new Set<String>{'Prospect', 'Inquired', 'Pre-Applied', 'App Started', 'App Submitted', 'App Completed', 'Wait Listed', 'Accepted', 'Fee Paid', 'Fee Waived', 'Registered'};
                        if (details.contains(newOpp.Stage_Detail__c)) {
                            newOpp.Stage_Detail__c = newOpp.Stage_Detail__c + ' - File Closed';
                        }
                        else {
                            newOpp.Stage_Detail__c = 'Unknown - File Closed';
                        }
                    }
                }

                if (newOpp.Opportunity_Key__c != null) {
                    newOpp.Opportunity_Key__c = newOpp.Opportunity_Key__c + '.Cloned';
                }
                insert newOpp;
            }
        }
        catch (Exception e) {
            System.debug(Logginglevel.ERROR, e);
            throw new AuraHandledException(e.getMessage());
        }
        return newOpp;
    }

    @AuraEnabled
    public static void updateApplication(Id oppId) {
        try {
            Opportunity opp = [SELECT Id, Name, Academic_Term__c, Application__c, Application__r.Intended_Term_of_Entry__c FROM Opportunity WHERE Id = :oppId];
            if (opp.Academic_Term__c != opp.Application__r.Intended_Term_of_Entry__c) {
                update new Application__c(Id = opp.Application__c, Intended_Term_of_Entry__c = opp.Academic_Term__c);
            }
        }
        catch (Exception e) {
            System.debug(Logginglevel.ERROR, e);
            throw new AuraHandledException(e.getMessage());
        }
    }
}