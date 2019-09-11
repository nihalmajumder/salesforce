/**
 * Created by ejc84332 on 2019-03-30.
 */


@IsTest
private class Test_TDTM_Opportunity_Assignments {


    @IsTest
    static void test_opportunity_assignments() {


        // first retrieve default HEDA trigger handlers
        List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();
        // Create our trigger handler using the constructor
        tokens.add(new hed.TDTM_Global_API.TdtmToken('TDTM_Opportunity_Assignments', 'Opportunity', 'AfterInsert;AfterUpdate', 2.00));
        // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);

        // All this does is call the Assignment Engine Class, which has its own tests. So just create an opp to get
        // the trigger to run and trust those tests for the rest.

        Contact c_one = new Contact(FirstName='First', LastName='Last', Email='test@test.com');
        insert c_one;

        Test.startTest();

        Opportunity opp = new Opportunity(Name='First Last Opp', CloseDate=Date.today(), AccountId=c_one.AccountId, Contact__c=c_one.Id, StageName='Inquired', Stage_Detail__c='Inquired');
        insert opp;

        opp.Student_Type__c = 'PSEO';
        update opp;

    }
}