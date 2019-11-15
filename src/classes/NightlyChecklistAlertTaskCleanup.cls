/**
 * Created by ejc84332 on 11/15/19.
 */


global class NightlyChecklistAlertTaskCleanup implements Schedulable {

    global void execute(SchedulableContext sc){

        List<Task> tasks = [select Id from Task where Checklist_Item_Notification__c=true and CreatedDate < LAST_N_DAYS:21];
        System.debug('Deleting tasks:');
        System.debug(tasks);
        delete  tasks;
    }

}