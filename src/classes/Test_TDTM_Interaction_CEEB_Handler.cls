/**
 * Created by ejc84332 on 2019-03-07.
 */

@IsTest
private class Test_TDTM_Interaction_CEEB_Handler {


    @IsTest
    static void test_undergrad() {


        // first retrieve default HEDA trigger handlers
        List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();
        // Create our trigger handler using the constructor
        tokens.add(new hed.TDTM_Global_API.TdtmToken('TDTM_Interaction_CEEB_Handler', 'Interaction__c', 'AfterInsert;AfterUpdate', 2.00));
        // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);


        Test.startTest();
        Academic_Term__c[] terms = BethelTestDataFactory.createTerms(2);
        Program__c[] programs = BethelTestDataFactory.createPrograms();
        Account[] schools = BethelTestDataFactory.createHighSchoolAccounts();

        Interaction__c i = new Interaction__c(First_Name__c='First1', Last_Name__c='Last1', Email__c='test1@test.com',  CEEB_Code__c='242683', School_College__c='Undergraduate');

        insert i;

        i = [SELECT Id, First_Name__c, Last_Name__c, Email__c, CEEB_Code__c, Contact__r.Id FROM Interaction__c WHERE Id=:i.Id];

        hed__Affiliation__c affil = [Select Id, Name, hed__Contact__c, hed__Account__r.Name from hed__Affiliation__c where hed__Contact__c=:i.Contact__c];

        System.assert(affil.hed__Account__r.Name == 'White Bear Lake Area High Sch');

        System.debug(affil);

        // create a second one with the ContactID preloaded to test the AfterInsert method.

        Interaction__c i2 = new Interaction__c(First_Name__c='First', Last_Name__c='Last1', Email__c='test1@test.com',  CEEB_Code__c='242215', Contact__c=i.Contact__c, School_College__c='Undergraduate');

        insert i2;

        hed__Affiliation__c affil2 = [Select Id, Name, hed__Contact__c, hed__Account__r.Name from hed__Affiliation__c where hed__Contact__c=:i.Contact__c and Id != :affil.Id];
        System.debug(affil2);
        System.assert(affil2.hed__Account__r.Name == 'Roseville Area High School');

    }
}