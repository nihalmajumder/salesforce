/**
 * Created by ejc84332 on 2019-05-04.
 */

@IsTest
private class Test_TDTM_Opportunity_Stage_Back {


    @IsTest
    static void test_opportunity_stages() {

        // first retrieve default HEDA trigger handlers
        List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();
        // Create our trigger handler using the constructor
        tokens.add(new hed.TDTM_Global_API.TdtmToken('TDTM_Opportunity_Stage_Back', 'Opportunity', 'AfterUpdate', 2.00));
        // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);

        Contact c_one = new Contact(FirstName='First', LastName='Last', Email='test@test.com');
        insert c_one;

        Application__c app = new Application__c(Contact__c=c_one.Id, Application_Status__c='Submitted');
        insert app;

        Opportunity opp = new Opportunity(Name='First Last Opp', CloseDate=Date.today(),
                Contact__c=c_one.Id, StageName='Applied', Stage_Detail__c='App Submitted',
                Application__c= app.Id);

        insert opp;
        Test.startTest();
        opp.StageName = 'File Closed';
        opp.Withdrawal_Reason__c = 'PR - Personal';

        update opp;

        app = [SELECT Id, Application_Status__c FROM Application__c WHERE Id=:app.Id];
        System.assert(app.Application_Status__c=='Cancelled');

        opp.StageName = 'Applied';
        opp.Stage_Detail__c = 'App Submitted';
        update opp;

        app = [SELECT Id, Application_Status__c FROM Application__c WHERE Id=:app.Id];
        System.assert(app.Application_Status__c=='Submitted');

        opp.StageName = 'Inquired';
        opp.Stage_Detail__c = 'App Started';
        update opp;

        app = [SELECT Id, Application_Status__c FROM Application__c WHERE Id=:app.Id];
        System.assert(app.Application_Status__c=='Started');

        opp.StageName = 'File Closed';
        opp.Stage_Detail__c = 'Inquired - File Closed';
        opp.Withdrawal_Reason__c = 'PR - Personal';
        update opp;

        app = [SELECT Id, Application_Status__c FROM Application__c WHERE Id=:app.Id];
        System.assert(app.Application_Status__c=='Cancelled');

        opp.StageName = 'Applied';
        opp.Stage_Detail__c = 'App Completed';
        update opp;

        app = [SELECT Id, Application_Status__c FROM Application__c WHERE Id=:app.Id];
        System.assert(app.Application_Status__c=='Completed');


    }

}