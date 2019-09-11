public class ApplicationCheckBatch implements Database.Batchable<Application__c> {

    List<Application__c> items = null;

    public ApplicationCheckBatch(List<Application__c> items) {
        this.items = items;
    }

    public Iterable<Application__c> start(Database.BatchableContext info) {
        return items;
    }

    public void execute(Database.BatchableContext info, List<Application__c> scope){
        for (Application__c app : scope) {
            ApplicationHelper.checkCompletion(app.Id);
        }
    }

    public void finish(Database.BatchableContext info) { 
    } 

}