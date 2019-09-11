/**
 * Created by ejc84332 on 2019-02-05.
 */

@IsTest
private class Test_TDTM_Soucre_Primary_Handler {

    @IsTest
    static void TestPrimarySourceHandler(){

        Test.startTest();

        // first retrieve default HEDA trigger handlers
        List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();
        // Create our trigger handler using the constructor
        tokens.add(new hed.TDTM_Global_API.TdtmToken('TDTM_Soucre_Primary_Handler', 'Interaction__c', 'BeforeUpdate;AfterInsert;AfterUpdate;AfterDelete', 2.00));
        // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);

        Contact c_one = new Contact(FirstName='First', LastName='Last', Email='test@test.com');
        insert c_one;

        Contact c_two = new Contact(FirstName='First2', LastName='Last2', Email='test2@test.com');
        insert c_two;

        Opportunity opp = new Opportunity(Name='First Last Opp', AccountId=c_one.AccountId, Contact__c=c_one.Id, StageName='Inquired', CloseDate=Date.today(), Stage_Detail__c = 'Inquired');
        Opportunity opp_two = new Opportunity(Name='First2 Last2 Opp', AccountId=c_two.AccountId, Contact__c=c_two.Id, StageName='Inquired', CloseDate=Date.today(),  Stage_Detail__c = 'Inquired');
        insert opp;
        insert opp_two;

        Interaction__c int_one = new Interaction__c(First_Name__c='First', Last_Name__c='Last', Email__c='test@test.com', Lead_Source__c='Email', Source_Detail__c='Email', Opportunity__c=opp.Id);
        Interaction__c int_two = new Interaction__c(First_Name__c='First', Last_Name__c='Last', Email__c='test@test.com', Lead_Source__c='Email', Source_Detail__c='Email');
        Interaction__c int_three = new Interaction__c(First_Name__c='First', Last_Name__c='Last', Email__c='test@test.com');

        Interaction__c int_four = new Interaction__c(First_Name__c='First2', Last_Name__c='Last2', Email__c='test2@test.com', Lead_Source__c='Email', Source_Detail__c='Email');
        Interaction__c int_five = new Interaction__c(First_Name__c='First2', Last_Name__c='Last2', Email__c='test2@test.com');

        List<Interaction__c> ints = new List<Interaction__c>();
        ints.add(int_one);
        ints.add(int_two);
        ints.add(int_three);
        ints.add(int_four);
        ints.add(int_five);

        insert ints;

//        insert int_one;
//        insert int_two;
//        insert int_three;


        // have to add this after it creates for some reason
        int_one.Opportunity__c=opp.Id;
        int_two.Opportunity__c=opp.Id;
        int_three.Opportunity__c=opp.Id;
        int_four.Opportunity__c=opp_two.Id;
        int_five.Opportunity__c=opp_two.Id;
//        update int_one;
//        update int_two;
//        update int_three;
        update ints;

        int_one = [SELECT Id, Name, Contact__c, Opportunity__c, Interaction_Source__c, Interaction_Status__c, Source_Number__c, Is_Primary__c FROM Interaction__c WHERE Id = :int_one.Id];
        int_two = [SELECT Id, Name, Contact__c, Opportunity__c, Interaction_Source__c, Interaction_Status__c, Source_Number__c, Is_Primary__c FROM Interaction__c WHERE Id = :int_two.Id];
        int_three = [SELECT Id, Name, Contact__c, Opportunity__c, Interaction_Source__c, Interaction_Status__c, Source_Number__c, Is_Primary__c FROM Interaction__c WHERE Id = :int_three.Id];
        int_four = [SELECT Id, Name, Contact__c, Opportunity__c, Interaction_Source__c, Interaction_Status__c, Source_Number__c, Is_Primary__c FROM Interaction__c WHERE Id = :int_four.Id];
        int_five = [SELECT Id, Name, Contact__c, Opportunity__c, Interaction_Source__c, Interaction_Status__c, Source_Number__c, Is_Primary__c FROM Interaction__c WHERE Id = :int_five.Id];
        opp = [SELECT Id, Primary_Source_Number__c from Opportunity where Id = :opp.Id];
        opp_two = [SELECT Id, Primary_Source_Number__c from Opportunity where Id = :opp_two.Id];

        // int_one should be primary on the Opp
        System.assert(int_one.Source_Number__c == Integer.valueof(int_one.Name.split('-')[1]));
        System.assert(int_one.Source_Number__c == opp.Primary_Source_Number__c);
        System.assert(int_one.Is_Primary__c == true);

        // manually override int_two's number
        int_two.Source_Number__c=10;
        int_two.Opportunity__c=opp.Id;
        update int_two;

        int_one = [SELECT Id, Name, Contact__c, Opportunity__c, Interaction_Source__c, Interaction_Status__c, Source_Number__c, Is_Primary__c FROM Interaction__c WHERE Id = :int_one.Id];
        int_two = [SELECT Id, Name, Contact__c, Opportunity__c, Interaction_Source__c, Interaction_Status__c, Source_Number__c, Is_Primary__c FROM Interaction__c WHERE Id = :int_two.Id];
        int_three = [SELECT Id, Name, Contact__c, Opportunity__c, Interaction_Source__c, Interaction_Status__c, Source_Number__c, Is_Primary__c FROM Interaction__c WHERE Id = :int_three.Id];
        opp = [SELECT Id, Primary_Source_Number__c from Opportunity where Id = :opp.Id];


        System.assert(opp.Primary_Source_Number__c==10);
        System.assert(int_two.Is_Primary__c == true);
        System.assert(int_one.Is_Primary__c == false);
        int_two.Opportunity__c=opp.Id;
        delete int_two;

        opp = [SELECT Id, Primary_Source_Number__c from Opportunity where Id = :opp.Id];
        System.debug(opp);
        System.assert(opp.Primary_Source_Number__c!=10);

        System.assert(int_one.Source_Number__c == Integer.valueof(int_one.Name.split('-')[1]));


        // make sure it goes back to the name after its nulled out.
        Decimal old_number = int_one.Source_Number__c;
        int_one.Source_Number__c = null;
        update int_one;
        int_one = [SELECT Id, Name, Source_Number__c FROM Interaction__c WHERE Id = :int_one.Id];
        System.assert(int_one.Source_Number__c == old_number);


        Test.stopTest();


    }
}