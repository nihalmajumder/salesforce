/**
 * Created by ejc84332 on 11/8/19.
 */



global class NightlyAppCompleteCheck implements Schedulable {

    global void execute(SchedulableContext sc){

        List<Application__c> apps = [SELECT Id FROM Application__c WHERE Application_Status__c='Submitted'];
        ApplicationCheckBatch batchObject = new ApplicationCheckBatch(apps);
        Database.executeBatch(batchObject, 1);
    }

}