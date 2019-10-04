/**
 * Created by ejc84332 on 10/3/19.
 */

@IsTest
private class Test_TDTM_Calculate_Queue_Rank {


    @IsTest
    static void testBehavior() {

        // first retrieve default HEDA trigger handlers
        List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();
        // Create our trigger handler using the constructor
        tokens.add(new hed.TDTM_Global_API.TdtmToken('TDTM_Calculate_Queue_Rank', 'Case', 'BeforeUpdate;AfterUpdate', 2.00));
        // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);

        // have to do this to ssr_record_type to get the assignment rules working?
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = false;

        Case c1 = new Case(Type='General', Subject='test1', Description='test1', Queue_Rank__c=1);
        Case c2 = new Case(Type='General', Subject='test2', Description='test2', Queue_Rank__c=2);
        Case c3 = new Case(Type='General', Subject='test3', Description='test3', Queue_Rank__c=3);
        Case c4 = new Case(Type='General', Subject='test4', Description='test4', Queue_Rank__c=4);

        insert c1;
        insert c2;
        insert c3;
        insert c4;

        c1.Status = 'Closed';
        c2.Status = 'Closed';

        Case[] update_cases = new List<Case>();
        update_cases.add(c1);
        update_cases.add(c2);
        update update_cases;

        c3 = [Select Id, Queue_Rank__c from Case where Id=:c3.Id];
        c4 = [Select Id, Queue_Rank__c from Case where Id=:c4.Id];

        System.assert(c3.Queue_Rank__c == 1);
        System.assert(c4.Queue_Rank__c == 2);

    }
}