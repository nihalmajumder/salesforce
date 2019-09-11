/**
 * Created by ejc84332 on 2019-04-02.
 */

@IsTest
        private class Test_TDTM_Opportunity_PT_Validate {


        @IsTest
        static void test_opportunity_program_terms() {

        // first retrieve default HEDA trigger handlers
        List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();
        // Create our trigger handler using the constructor
        tokens.add(new hed.TDTM_Global_API.TdtmToken('TDTM_Opportunity_Program_Term_Validate', 'Opportunity', 'BeforeInsert;BeforeUpdate', 2.00));
        // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);


        Academic_Term__c term = new Academic_Term__c(Name='Fall 2020 - SEM');
        Academic_Term__c term2 = new Academic_Term__c(Name='Fall 2022 - SEM');
        Academic_Term__c term_bad = new Academic_Term__c(Name='Fall 2021 - SEM');
        insert term;
        insert term2;
        insert term_bad;
        Program__c program = new Program__c(Name='Cert/Theological Studies', Program_Name_on_Application__c='Theological Studies Certificate');
        Program__c program2 = new Program__c(Name='Theology Masters', Program_Name_on_Application__c='Theology Masters');
        insert program;
        insert program2;
        Intended_Program_Term__c itp = new Intended_Program_Term__c(Academic_Term__c=term.Id, Intended_Program__c=program.Id);
        Intended_Program_Term__c itp2 = new Intended_Program_Term__c(Academic_Term__c=term2.Id, Intended_Program__c=program2.Id);
        insert itp;
        insert itp2;

        Contact c_one = new Contact(FirstName='First', LastName='Last', Email='test@test.com');
        insert c_one;

        Opportunity opp = new Opportunity(Name='First Last Opp', CloseDate=Date.today(), AccountId=c_one.AccountId,
                Contact__c=c_one.Id, StageName='Inquired', Stage_Detail__c='Inquired',  School_College__c='Seminary',
                Academic_Program__c=program.Id, Academic_Term__c=term_bad.Id);

        Test.startTest();
        // this one should fail
        try{
            insert opp;
        }catch(Exception e){
            System.assert(e.getMessage().contains('not a valid combination'));
        }

        // this one should work
        opp.Academic_Term__c = term.Id;
        insert opp;

        // blank should default to all, so any delivery should work. Program and Term have to change in order to validate.
        opp.Preferred_Delivery_Format__c = 'Face-to-Face';
        opp.Academic_Term__c = term2.Id;
        opp.Academic_Program__c = program2.Id;
        update opp;


        // check bad, specific delivery.
        itp.Delivery_Type__c = 'Blended';
        update itp;
        opp.Preferred_Delivery_Format__c = 'Online';
        try{
            update opp;
        }catch(Exception e){
            System.assert(e.getMessage().contains('not a valid combination'));
        }

        // now good delivery. Program and Term have to change in order to validate.
        itp.Delivery_Type__c = 'Online';
        opp.Academic_Term__c = term.Id;
        opp.Academic_Program__c = program.Id;
        update itp;
        opp.Preferred_Delivery_Format__c = 'Online';
        update opp;

        Test.stopTest();


    }

}