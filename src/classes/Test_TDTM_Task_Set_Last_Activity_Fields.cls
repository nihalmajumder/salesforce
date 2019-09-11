/**
 * Created by ejc84332 on 2019-04-24.
 */

@IsTest
private class Test_TDTM_Task_Set_Last_Activity_Fields {

    @IsTest
    static void test_tasks() {

        // first retrieve default HEDA trigger handlers
        List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();
        // Create our trigger handler using the constructor
        tokens.add(new hed.TDTM_Global_API.TdtmToken('TDTM_Task_Set_Last_Activity_Fields', 'Task', 'AfterInsert;AfterUpdate', 1.00));
        // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);

        Contact c_one = new Contact(FirstName='First', LastName='Last', Email='test@test.com');
        Contact c_two = new Contact(FirstName='First2', LastName='Last2', Email='test2@test.com');
        insert c_one;
        insert c_two;

        Task task_one = new Task(WhoId=c_one.Id, Subject='test');
        insert task_one;

        Test.startTest();

        task_one.Status = 'Completed';
        update task_one;

        c_one = [SELECT Id, Last_Activity_Date__c FROM Contact WHERE Id=:c_one.Id];
        System.assert(c_one.Last_Activity_Date__c==Date.today());


        Task task_two = new Task(WhoId=c_two.Id, Subject='test', Status='Completed');
        insert task_two;
        c_two = [SELECT Id, Last_Activity_Date__c FROM Contact WHERE Id=:c_two.Id];
        System.assert(c_two.Last_Activity_Date__c==Date.today());

        Test.stopTest();

    }

}