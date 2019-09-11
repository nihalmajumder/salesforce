/**
 * Created by ejc84332 on 2019-03-07.
 */

@IsTest
private class Test_TDTM_Term_Program_Lookup {


    @IsTest
    static void test_undergrad() {


        // first retrieve default HEDA trigger handlers
        List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();
        // Create our trigger handler using the constructor
        tokens.add(new hed.TDTM_Global_API.TdtmToken('TDTM_Term_Program_Lookup', 'Interaction__c', 'BeforeInsert;BeforeUpdate', 2.00));
        // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);


        Test.startTest();
        BethelTestDataFactory.createTerms(2);

        // create a term with start and end date on either side of today to test the date lookup
        Academic_Term__c date_term = new Academic_Term__c(Name='TERM BY DATE - CAPS/GS', Term_Start_Date__c=System.today()-1, Term_End_Date__c=System.today()+1);
        insert date_term;

        BethelTestDataFactory.createPrograms();


        // create undergrad Interaction with age instead of grad year, and no program to test for Undecided Program.
        Interaction__c i_cas = new Interaction__c(First_Name__c='First1', Last_Name__c='Last1', Email__c='test1@test.com', Age__c=20, School_College__c='Undergraduate');

        try{
            insert i_cas;
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Age cannot be over 18') ? true : false;
            System.assert(expectedExceptionThrown, true);
        }
	
        i_cas.Age__c=16;
        insert i_cas;
        i_cas = [SELECT Id, First_Name__c, Last_Name__c, Email__c, School_College__c, Academic_Term__c, Academic_Program__c,
                Academic_Program__r.Program_Name_on_Application__c, Age__c, High_School_Graduation_Year__c FROM Interaction__c WHERE Id=:i_cas.Id];

        System.assert(i_cas.High_School_Graduation_Year__c != null);

        if(System.today().month()<=8){
            System.assert(i_cas.High_School_Graduation_Year__c == String.valueOf(System.today().year()+(17-16)));
        }else{
            System.assert(i_cas.High_School_Graduation_Year__c == String.valueOf(System.today().year()+(18-16)));
        }

        System.assert(i_cas.Academic_Program__r.Program_Name_on_Application__c == 'Undecided');

        // Test a CAS with Term Search Text instead of age
        String term_search = 'Fall ' + String.valueOf(System.today().year());
        i_cas = new Interaction__c(First_Name__c='First1', Last_Name__c='Last1', Email__c='test1@test.com', Term_Search_Text__c=term_search, School_College__c='Undergraduate');
		insert i_cas;
        i_cas = [SELECT Id, First_Name__c, Last_Name__c, Email__c, School_College__c, Academic_Term__c, Academic_Program__c,
                 Academic_Program__r.Program_Name_on_Application__c, Age__c, High_School_Graduation_Year__c FROM Interaction__c WHERE Id=:i_cas.Id];
        System.assert(i_cas.Academic_Term__c != null);
        
        // Test a CAPS/GS and SEM using Program and Term search text.


        String term_search_prefix = 'Fall ' + String.valueOf(System.today().year());
        Interaction__c i_capsgs = new Interaction__c(First_Name__c='First2', Last_Name__c='Last2', Email__c='test2@test.com',
                School_College__c='Graduate', Term_Search_Text__c=term_search_prefix, Program_Search_Text__c='Strategic Leadership (M.A.)');

        Interaction__c i_sem = new Interaction__c(First_Name__c='First3', Last_Name__c='Last3', Email__c='test3@test.com',
                School_College__c='Seminary', Term_Search_Text__c=term_search_prefix, Program_Search_Text__c='Theological Studies Certificate');

        // test capsgs without term or term search text.
        Interaction__c i_capsgs_no_term = new Interaction__c(First_Name__c='First2', Last_Name__c='Last2', Email__c='test2@test.com',
                School_College__c='Graduate', Program_Search_Text__c='Strategic Leadership (M.A.)');

        insert i_capsgs;
        insert i_sem;
        insert i_capsgs_no_term;

        i_capsgs = [SELECT Id, First_Name__c, Last_Name__c, Email__c, School_College__c, Academic_Term__c, Academic_Term__r.Name, Academic_Program__c,
                Academic_Program__r.Program_Name_on_Application__c, Term_Search_Text__c, Program_Search_Text__c FROM Interaction__c WHERE Id=:i_capsgs.Id];

        i_sem = [SELECT Id, First_Name__c, Last_Name__c, Email__c, School_College__c, Academic_Term__c, Academic_Term__r.Name, Academic_Program__c,
                Academic_Program__r.Program_Name_on_Application__c, Term_Search_Text__c, Program_Search_Text__c FROM Interaction__c WHERE Id=:i_sem.Id];

        i_capsgs_no_term = [SELECT Id, First_Name__c, Last_Name__c, Email__c, School_College__c, Academic_Term__c, Academic_Term__r.Name, Academic_Program__c,
                Academic_Program__r.Program_Name_on_Application__c, Term_Search_Text__c, Program_Search_Text__c FROM Interaction__c WHERE Id=:i_capsgs_no_term.Id];

        System.assert(i_capsgs.Academic_Program__r.Program_Name_on_Application__c == 'Strategic Leadership (M.A.)');
        System.assert(i_sem.Academic_Program__r.Program_Name_on_Application__c == 'Theological Studies Certificate');

        System.assert(i_capsgs.Academic_Term__r.Name == term_search_prefix + ' - CAPS/GS');
        System.assert(i_sem.Academic_Term__r.Name == term_search_prefix + ' - SEM');
        System.assert(i_capsgs_no_term.Academic_Term__r.Name == date_term.Name);

    }
}