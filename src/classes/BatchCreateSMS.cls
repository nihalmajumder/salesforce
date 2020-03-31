/**
 * Created by bej68982 on 3/19/20.
 */

public class BatchCreateSMS implements Database.Batchable<sObject>, Database.Stateful {

    public List <Mogli_SMS__SMS__c> smsRecordsToCreate = new List<Mogli_SMS__SMS__c>();
    public Event_Log__c eventLog;
    public String apexlog = '';

    public BatchCreateSMS(List<Mogli_SMS__SMS__c> smsRecords, Event_Log__c log){
        smsRecordsToCreate = smsRecords;
        eventLog = log;
    }

    public List<Mogli_SMS__SMS__c> start(Database.BatchableContext bc) {
        return smsRecordsToCreate;
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope){
        Database.SaveResult[] srList = Database.insert(scope, false);

        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                apexlog += 'Successfully created SMS record: ' + sr.getId() + '\R';
            }
            else {
                for(Database.Error err : sr.getErrors()) {
                    apexlog += 'SMS ID: ' + sr.getId() + ': ' + err.getStatusCode() + ': ' + err.getMessage() + '\R';
                }
            }
        }
    }

    public void finish(Database.BatchableContext bc){
        eventLog.Status__c = 'Completed';
        update eventLog;

        If(apexlog != ''){
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S';
            conVer.PathOnClient = 'ApexLog.txt';
            conVer.Title = 'Apex Log';
            conVer.VersionData = Blob.valueOf(apexlog);
            insert conVer;

            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;

            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = eventLog.Id;
            conDocLink.ContentDocumentId = conDoc;
            conDocLink.shareType = 'V';
            insert conDocLink;
        }
    }

}