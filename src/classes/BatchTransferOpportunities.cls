/**
 * Created by bej68982 on 3/5/20.
 */

public class BatchTransferOpportunities implements Database.Batchable<sObject>, Database.Stateful {

    public List <Opportunity> oppsToUpdate = new List<Opportunity>();
    public String csvFileContent = 'oldOwnerId, newOwnerId, opportunityId\R';
    public String newOwnerId;
    public Integer successfulCount = 0;
    public List <String> errors = new List<String>();
    public User newOwner;

    public BatchTransferOpportunities(List<Opportunity> oppsInput, String newOwnerIdInput){
        oppsToUpdate = oppsInput;
        newOwnerId = newOwnerIdInput;
        newOwner = [SELECT FirstName FROM User WHERE Id = :newOwnerId];
    }


    public List<Opportunity> start(Database.BatchableContext bc) {
        return oppsToUpdate;
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope){
        List <Opportunity> batchOfOpps = new List<Opportunity>();
        for (Integer i = 0; i < scope.size(); i++) {
            Opportunity currentOpp = oppsToUpdate[0];
            csvFileContent = csvFileContent + currentOpp.OwnerId + ', '+ newOwnerId + ', ' + currentOpp.Id + '\R';
            currentOpp.OwnerId = newOwnerId;
            currentOpp.Override_Ownership__c = false;
            batchOfOpps.add(currentOpp);
            oppsToUpdate.remove(0);
        }
        Database.SaveResult[] srList = Database.update(batchOfOpps, false);

        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                successfulCount++;
                System.debug('Successfully updated Opportunity. Opportunity ID: ' + sr.getId());
            }
            else {
                for(Database.Error err : sr.getErrors()) {
                    errors.add('Opportunity ID: ' + sr.getId() + ': ' + err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }
    }

    public void finish(Database.BatchableContext bc){
        String subject = 'Batch Transfer Opportunities to ' + newOwner.FirstName + ' - Results';
        String body = 'Batch ID: '+ bc.getJobId() + '\N\N' + successfulCount +' Successful.\N' + errors.size() + ' Failures.\N\NErrors:\n'+string.join(errors,'\N');
        String fileName = 'Opportunities Transferred ' + Datetime.now() + '.csv';
        Flow_TransferOwnership.sendEmail(csvFileContent, subject, body, fileName);
    }
}