/**
 * Created by ejc84332 on 11/15/19.
 */

@IsTest
private class NightlyChecklistAlertTaskCleanupTest {
    @IsTest
    static void testBehavior() {

        Task t = new Task(Subject='test', Type='Other', Status='Completed', Checklist_Item_Notification__c=true, CreatedDate=Date.today().addDays(-20));
        insert t;
        t = new Task(Subject='test', Type='Other', Status='Completed', Checklist_Item_Notification__c=true, CreatedDate=Date.today().addDays(-22));
        insert t;

        NightlyChecklistAlertTaskCleanup n = new NightlyChecklistAlertTaskCleanup();
        SchedulableContext sc = null;
        n.execute(sc);

        Integer i = [SELECT COUNT() FROM Task];
        System.assert(i == 1);
    }
}