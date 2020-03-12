/**
 * Created by bej68982 on 3/6/20.
 */

public class BatchTransferCases implements Database.Batchable<sObject>, Database.Stateful {

    public List <Case> casesToUpdate = new List<Case>();
    public String csvFileContent = 'oldOwnerId, newOwnerId, caseId\R';
    public String newOwnerId;
    public Integer successfulCount = 0;
    public List <String> errors = new List<String>();
    public User newOwner;

    public BatchTransferCases(List<Case> casesInput, String newOwnerIdInput){
        casesToUpdate = casesInput;
        newOwnerId = newOwnerIdInput;
        newOwner = [SELECT FirstName FROM User WHERE Id = :newOwnerId];
    }


    public List<Case> start(Database.BatchableContext bc) {
        return casesToUpdate;
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope){
        List <Case> batchOfCases = new List<Case>();
        for (Integer i = 0; i < scope.size(); i++) {
            Case currentCase = casesToUpdate[0];
            csvFileContent = csvFileContent + currentCase.OwnerId + ', '+ newOwnerId + ', ' + currentCase.Id + '\R';
            currentCase.OwnerId = newOwnerId;
            batchOfCases.add(currentCase);
            casesToUpdate.remove(0);
        }
        Database.SaveResult[] srList = Database.update(batchOfCases, false);

        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                successfulCount++;
                System.debug('Successfully updated Case. Case ID: ' + sr.getId());
            }
            else {
                for(Database.Error err : sr.getErrors()) {
                    errors.add('Case ID: ' + sr.getId() + ': ' + err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }
    }

    public void finish(Database.BatchableContext bc){
        String subject = 'Batch Transfer Cases to ' + newOwner.FirstName + ' - Results';
        String body = 'Batch ID: '+ bc.getJobId() + '\N\N' + successfulCount +' Successful.\N' + errors.size() + ' Failures.\N\NErrors:\n'+string.join(errors,'\N');
        String fileName = 'Cases Transferred ' + Datetime.now() + '.csv';
        Flow_TransferOwnership.sendEmail(csvFileContent, subject, body, fileName);
    }
}