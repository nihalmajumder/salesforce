/**
 * Created by ejc84332 on 2019-02-07.
 */

@IsTest
private class Test_TDTMTestScoreHandler {
    @IsTest
    static void testBehavior() {

        Test.startTest();
        // first retrieve default HEDA trigger handlers
        List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();
        // Create our trigger handler using the constructor
        tokens.add(new hed.TDTM_Global_API.TdtmToken('TDTM_Test_Score_Handler', 'Interaction__c', 'AfterInsert;AfterUpdate;', 1.00));
        // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);

        Contact c_one = new Contact(FirstName='First', LastName='Last', Email='test@test.com');
        insert c_one;

        String act = '"ACT_Reading_Score__c:31\n' +
                'ACT_Mathematics_Score__c:32 \n' +
                'ACT_English_Score__c:30\n' +
                'ACT_Science_Score__c:32\n' +
                'ACT_Composite_Score__c:31\n' +
                'ACT_Test_Date__c:06/01/2015\n' +
                'ACT_Writing_Score__c:30\n' +
                'Lead_Date__c:43503\n' +
                'Stauts_Description__c:Official"';

        Interaction__c int_one = new Interaction__c(First_Name__c='First', Last_Name__c='Last', Email__c='test@test.com', Lead_Source__c='Email', Source_Detail__c='Email', ACT_Test_Results__c=act, Contact__c=c_one.Id, Interaction_Status__c='Imported');
        insert int_one;

        Test_Score__c[] ts = [SELECT Id, Contact__c, ACT_Composite_Score__c FROM Test_Score__c WHERE Contact__c = :c_one.Id];

        update int_one;


//        System.assert(ts.Contact__c==c_one.Id);
//        System.assert(ts.ACT_Composite_Score__c==31);

        System.debug('Found Created Test Score');
        System.debug(ts);

        update int_one;

    }
}