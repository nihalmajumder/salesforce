@IsTest
private class IncomingSMSFlowLauncher_Test {

    @IsTest
    static void testBehavior() {
        Contact contact = new Contact(
            LastName = 'Test Contact Magic Number',
            MobilePhone = '(500) 555-0006'
        );
        insert contact;

        Test.startTest();
        IncomingSMSFlowLauncher.reLaunch();
        Mogli_SMS__SMS__c incomingSMS = new Mogli_SMS__SMS__c(
            Mogli_SMS__Contact__c = contact.Id,
            Mogli_SMS__Phone_Number__c = '+15005550006',
            Mogli_SMS__Direction__c = 'Incoming',
            Mogli_SMS__Status__c = 'Received Successfully',
            Mogli_SMS__Message__c = 'Test Message!'
        );
        insert incomingSMS;
        Test.stopTest();

        System.assertNotEquals(0, [SELECT COUNT() FROM FlowInterview]);
    }

}