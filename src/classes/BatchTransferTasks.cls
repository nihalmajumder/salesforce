/**
 * Created by bej68982 on 3/6/20.
 */

public class BatchTransferTasks implements Database.Batchable<sObject>, Database.Stateful {

    public List <Task> tasksToUpdate = new List<Task>();
    public String csvFileContent = 'oldOwnerId, newOwnerId, taskId\R';
    public String newOwnerId;
    public Integer successfulCount = 0;
    public List <String> errors = new List<String>();
    public User newOwner;

    public BatchTransferTasks(List<Task> tasksInput, String newOwnerIdInput){
        tasksToUpdate = tasksInput;
        newOwnerId = newOwnerIdInput;
        newOwner = [SELECT FirstName FROM User WHERE Id = :newOwnerId];
    }


    public List<Task> start(Database.BatchableContext bc) {
        return tasksToUpdate;
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope){
        List <Task> batchOfTasks = new List<Task>();
        for (Integer i = 0; i < scope.size(); i++) {
            Task currentTask = tasksToUpdate[0];
            csvFileContent = csvFileContent + currentTask.OwnerId + ', '+ newOwnerId + ', ' + currentTask.Id + '\R';
            currentTask.OwnerId = newOwnerId;
            batchOfTasks.add(currentTask);
            tasksToUpdate.remove(0);
        }
        Database.SaveResult[] srList = Database.update(batchOfTasks, false);

        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                successfulCount++;
                System.debug('Successfully updated Task. Task ID: ' + sr.getId());
            }
            else {
                for(Database.Error err : sr.getErrors()) {
                    errors.add('Task ID: ' + sr.getId() + ': ' + err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }
    }

    public void finish(Database.BatchableContext bc){
        String subject = 'Batch Transfer Tasks to ' + newOwner.FirstName + ' - Results';
        String body = 'Batch ID: '+ bc.getJobId() + '\N\N' + successfulCount +' Successful.\N' + errors.size() + ' Failures.\N\NErrors:\n'+string.join(errors,'\N');
        String fileName = 'Tasks Transferred ' + Datetime.now() + '.csv';
        Flow_TransferOwnership.sendEmail(csvFileContent, subject, body, fileName);
    }
}