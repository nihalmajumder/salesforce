/**
 * Created by bej68982 on 2/5/20.
 */

@IsTest
private class Flow_BulkSMSTest {

    @IsTest//(SeeAllData=true)
    static void testFlow_BulkSMS(){

        // Create an Contact object.
        Contact testContact = new Contact(FirstName='First', LastName='Last', Email='test@test.com', Mogli_SMS__Mogli_Number__c = '+12222222222');
        insert testContact;

        //Create User
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser55641654@testorg.com');
        insert testUser;

        //Create Terms
        Academic_Term__c testTerm = new Academic_Term__c(Name='Fall 2021 - CAS');
        insert testTerm;

        // Create an Opportunity object
        Opportunity testOpportunity = new Opportunity(Academic_Term__c = testTerm.Id, Contact__c = testContact.Id, OwnerId=testUser.Id, StageName='Inquired', Stage_Detail__c = 'App Started', Name = 'Test Opp', CloseDate=System.today());
        insert testOpportunity;

        //Create Campaign object
        Campaign testCampaign = new Campaign(Name = 'Test Campaign');
        insert testCampaign;

        //Create Campaign member
        CampaignMember testMember = new CampaignMember(ContactId = testContact.Id, CampaignId=testCampaign.Id);
        insert testMember;

        //Create Gateway
        Mogli_SMS__Gateway__c testGateway = new Mogli_SMS__Gateway__c();
        insert testGateway;

        //Create requests
        List<Flow_BulkSMS.BulkSmsRequest> listOfRequests = new List<Flow_BulkSMS.BulkSmsRequest>();

        //Request to get total Campaign members
        Flow_BulkSMS.BulkSmsRequest request1 = new Flow_BulkSMS.BulkSmsRequest();
        request1.campaignId = testCampaign.Id;
        request1.gateway = testGateway.Id;
        request1.initiator = String.valueOf(testUser.Id);
        request1.smsMessage = 'Test Message';
        request1.requestedTerms = 'Fall 2021 - CAS';
        request1.stageDetails = 'Inquired;App Started';
        request1.reportId = '00Of0000000rF0IEAU';
        request1.requestType = 'campaign total';
        listOfRequests.add(request1);

        //Request to get total contacts in Funnel
        Flow_BulkSMS.BulkSmsRequest request2 = new Flow_BulkSMS.BulkSmsRequest();
        request2.campaignId = testCampaign.Id;
        request2.gateway = testGateway.Id;
        request2.initiator = String.valueOf(testUser.Id);
        request2.smsMessage = 'Test Message';
        request2.requestedTerms = 'Fall 2021 - CAS';
        request2.stageDetails = 'Inquired;App Started';
        request2.reportId = '00Of0000000rF0IEAU';
        request2.requestType = 'funnel total';
        listOfRequests.add(request2);

        //Request to get total contacts from report
        Flow_BulkSMS.BulkSmsRequest request3 = new Flow_BulkSMS.BulkSmsRequest();
        request3.campaignId = testCampaign.Id;
        request3.gateway = testGateway.Id;
        request3.initiator = String.valueOf(testUser.Id);
        request3.smsMessage = 'Test Message';
        request3.requestedTerms = 'Fall 2021 - CAS';
        request3.stageDetails = 'Inquired;App Started';
        request3.reportId = '00Of0000000rF0IEAU';
        request3.requestType = 'report total';
        listOfRequests.add(request3);

        //Request to create SMS records for all contacts in report
        Flow_BulkSMS.BulkSmsRequest request4 = new Flow_BulkSMS.BulkSmsRequest();
        request4.campaignId = testCampaign.Id;
        request4.gateway = testGateway.Id;
        request4.initiator = String.valueOf(testUser.Id);
        request4.smsMessage = 'Test Message';
        request4.requestedTerms = 'Fall 2021 - CAS';
        request4.stageDetails = 'Inquired;App Started';
        request4.reportId = '00Of0000000rF0IEAU';
        request4.requestType = 'report';
        listOfRequests.add(request4);

        //Request to create SMS records for all contacts in Campaign
        Flow_BulkSMS.BulkSmsRequest request5 = new Flow_BulkSMS.BulkSmsRequest();
        request5.campaignId = testCampaign.Id;
        request5.gateway = testGateway.Id;
        request5.initiator = String.valueOf(testUser.Id);
        request5.smsMessage = 'Test Message';
        request5.requestedTerms = 'Fall 2021 - CAS';
        request5.stageDetails = 'Inquired;App Started';
        request5.reportId = '00Of0000000rF0IEAU';
        request5.requestType = 'campaign';
        listOfRequests.add(request5);

        //Request to create SMS records for all contacts in Funnel
        Flow_BulkSMS.BulkSmsRequest request6 = new Flow_BulkSMS.BulkSmsRequest();
        request6.campaignId = testCampaign.Id;
        request6.gateway = testGateway.Id;
        request6.initiator = String.valueOf(testUser.Id);
        request6.smsMessage = 'Test Message';
        request6.requestedTerms = 'Fall 2021 - CAS';
        request6.stageDetails = 'Inquired;App Started';
        request6.reportId = '00Of0000000rF0IEAU';
        request6.requestType = 'funnel';
        listOfRequests.add(request6);

        //Test All Request Types
        Flow_BulkSMS.BulkSMS(listOfRequests);
    }
}