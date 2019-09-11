/**
 * Created by ejc84332 on 2019-03-30.
 */

@IsTest
private class Test_TDTM_Calculate_Closed_Stage_Detail {
    private static void move_opportunity_stage(Opportunity opp, String stages, Boolean reject){


        String final_name = opp.StageName;
        String final_detail = opp.Stage_Detail__c;

        // set the Opportunity stage, and keep track of the last stage it was at
        if(stages != null) {
            for (String stage : stages.split('-->')) {
                String[] name_and_detail = stage.split(':');
                System.debug('Updating to:');
                System.debug(name_and_detail);
                final_name = name_and_detail[0];
                final_detail = name_and_detail[1];
                opp.StageName = final_name;
                opp.Stage_Detail__c = final_detail;
                update opp;
            }
        }

        // now move to file closed and do an assertion.
        opp.StageName = 'File Closed';
        opp.Withdrawal_Reason__c = 'BV - Bad Experience';
        opp.Reject__c = reject;
        System.debug('Updating to:');
        System.debug(opp.StageName);
        update opp;
        System.assert(opp.StageName == 'File Closed');
        // todo expand this one
        opp = [SELECT Id, StageName, Stage_Detail__c from Opportunity where Id= :opp.Id];
        System.assert(opp.Stage_Detail__c.contains('File Closed'));
        System.debug(opp.StageName);
        System.debug(opp.Stage_Detail__c);
        System.assert(opp.Stage_Detail__c.contains(final_name) || opp.Stage_Detail__c.contains(final_detail));

    }

    @IsTest
    static void test_closed_stage_detail() {


        // first retrieve default HEDA trigger handlers
        List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();
        // Create our trigger handler using the constructor
        tokens.add(new hed.TDTM_Global_API.TdtmToken('TDTM_Calculate_File_Closed_Stage_Detail', 'Opportunity', 'BeforeUpdate', 2.00));
        // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);


        Contact c_one = new Contact(FirstName='First', LastName='Last', Email='test@test.com');
        insert c_one;

        Opportunity opp = new Opportunity(Name='First Last Opp', CloseDate=Date.today(), AccountId=c_one.AccountId, Contact__c=c_one.Id, StageName='Inquired', Stage_Detail__c='Inquired');
        insert opp;
        
        Test.startTest();

        // todo: not sure how to test this without a lot of queries, but this does cover all lines.
        move_opportunity_stage(opp, 'Applied:App Submitted', false);

        // trigger the reject error
        try{
            move_opportunity_stage(opp, 'Inquired:Inquired', true);
        }catch (Exception e){
            System.assert(e.getMessage().contains('bad value for restricted picklist field') ? true : false);
        }



    }

}