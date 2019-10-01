/**
 * Created by ejc84332 on 2019-03-30.
 */

@IsTest
private class Test_TDTM_Academic_Interest_Handler {

    private static Interaction__c select_int(String int_id){
        return [SELECT Id, All_Academic_Interests__c, Academic_Program__r.Id, Secondary_Academic_Program__c FROM Interaction__c WHERE Id = :int_id];
    }

    @IsTest
    static void test_academic_interest() {


        // first retrieve default HEDA trigger handlers
        List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();
        // Create our trigger handler using the constructor
        tokens.add(new hed.TDTM_Global_API.TdtmToken('TDTM_Academic_Interest_Handler', 'Interaction__c', 'BeforeInsert;BeforeUpdate', 2.00));
        // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);


        Test.startTest();

        // need these?
        Contact testContact = new Contact(FirstName='testFirstName',LastName ='testLastName',Email='test@email.com000');
        insert testContact;

        Program__c mathematics = new Program__c(Name='Mathematics, BA', School_College__c='Undergraduate');
        insert mathematics;

        Program__c mba = new Program__c(Name='Mathematics, BA', School_College__c='Graduate');
        insert mba;


        Academic_Interest_Mapping__c math = new Academic_Interest_Mapping__c(Academic_Interest__c='math', Program__c=mathematics.Id, School_College__c='Undergraduate');
        insert math;

        Academic_Interest_Mapping__c mba_mapping = new Academic_Interest_Mapping__c(Academic_Interest__c='MBA', Program__c=mba.Id, School_College__c='Graduate');
        insert mba_mapping;

        Interaction__c int_one = new Interaction__c(First_Name__c='First', Last_Name__c='Last', Email__c='test@test.com', School_College__c='Seminary');
        Interaction__c int_two = new Interaction__c(First_Name__c='First2', Last_Name__c='Last2', Email__c='test2@test.com', School_College__c='Undergraduate', Opportunity_Stage__c='Inquired', Opportunity_Stage_Detail__c='App Started');
        Interaction__c int_three = new Interaction__c(First_Name__c='First3', Last_Name__c='Last3', Email__c='test3@test.com', School_College__c='Undergraduate', Opportunity_Stage__c='Applied', Opportunity_Stage_Detail__c='App Submitted');
        Interaction__c int_four = new Interaction__c(First_Name__c='First4', Last_Name__c='Last4', Email__c='test4@test.com', School_College__c='Undergraduate', Opportunity_Stage__c='Inquired', Opportunity_Stage_Detail__c='Inquired');

        Interaction__c int_five = new Interaction__c(First_Name__c='First4', Last_Name__c='Last4', Email__c='test4@test.com', School_College__c='Graduate', Opportunity_Stage__c='Inquired', Opportunity_Stage_Detail__c='Inquired', All_Academic_Interests__c='MBA');

        Interaction__c[] is = new List<Interaction__c>();
        is.add(int_one);
        is.add(int_two);
        is.add(int_three);
        is.add(int_four);
        is.add(int_five);

        insert is;

        // start with with All Academic Interest field
        int_four.All_Academic_Interests__c = 'test2, Test3';
        int_four.Interaction_Status__c = 'New';
        update int_four;
        int_four = select_int(int_four.Id);

        System.assert(int_four.Academic_Program__c == null);
        System.assert(int_four.Secondary_Academic_Program__c == null);

        // good one, test mis-match case.
        int_four.All_Academic_Interests__c = 'MATH';
        int_four.Interaction_Status__c = 'New';
        update int_four;
        int_four = select_int(int_four.Id);

        System.debug(int_four);
        System.assert(int_four.All_Academic_Interests__c == 'math');
        System.assert(int_four.Academic_Program__r.Id == mathematics.Id);

        int_five = select_int(int_five.Id);
        System.debug(int_five);
        System.assert(int_five.All_Academic_Interests__c == 'mba');
        System.assert(int_five.Academic_Program__r.Id == mba.Id);
        
    }

}