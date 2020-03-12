/**
 * Created by bej68982 on 2/5/20.
 */

@IsTest
private class Flow_BulkSMSTest {

    @IsTest
    static void testUsingMockData(){
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
//
        //Create Campaign member
        CampaignMember testMember = new CampaignMember(ContactId = testContact.Id, CampaignId=testCampaign.Id, Registration_Status__c = 'Sent');
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
        request1.initiator = '';
        request1.smsMessage = 'Test Message {{firstname}}';
        request1.requestedTerms = '';
        request1.stageDetails = '';
        request1.reportId = '';
        request1.requestType = 'campaign total';
        request1.registrationStatus ='Sent;Registered';
        listOfRequests.add(request1);

        //Request to get total contacts in Funnel
        Flow_BulkSMS.BulkSmsRequest request2 = new Flow_BulkSMS.BulkSmsRequest();
        request2.campaignId = testCampaign.Id;
        request2.gateway = testGateway.Id;
        request2.initiator = String.valueOf(testUser.Id);
        request2.smsMessage = 'Test Message {{firstname}}';
        request2.requestedTerms = 'Fall 2021 - CAS';
        request2.stageDetails = 'Inquired;App Started';
        request2.reportId = '';
        request2.requestType = 'funnel total';
        request2.registrationStatus ='Sent;Registered';
        listOfRequests.add(request2);

        //Request to create SMS records for all contacts in Campaign
        Flow_BulkSMS.BulkSmsRequest request5 = new Flow_BulkSMS.BulkSmsRequest();
        request5.campaignId = testCampaign.Id;
        request5.gateway = testGateway.Id;
        request5.initiator = String.valueOf(testUser.Id);
        request5.smsMessage = 'Test Message {{firstname}}';
        request5.requestedTerms = 'Fall 2021 - CAS';
        request5.stageDetails = 'Inquired;App Started';
        request5.reportId = '';
        request5.requestType = 'campaign';
        request5.registrationStatus ='Sent;Registered';
        listOfRequests.add(request5);

        //Request to create SMS records for all contacts in Funnel
        Flow_BulkSMS.BulkSmsRequest request6 = new Flow_BulkSMS.BulkSmsRequest();
        request6.campaignId = testCampaign.Id;
        request6.gateway = testGateway.Id;
        request6.initiator = String.valueOf(testUser.Id);
        request6.smsMessage = 'Test Message {{firstname}}';
        request6.requestedTerms = 'Fall 2021 - CAS';
        request6.stageDetails = 'Inquired;App Started';
        request6.reportId = '';
        request6.requestType = 'funnel';
        request6.registrationStatus ='Sent;Registered';
        listOfRequests.add(request6);


        //Test All Request Types
        Test.startTest();
        Flow_BulkSMS.BulkSMS(listOfRequests);
        Test.stopTest();
    }

    @IsTest (SeeAllData='true')
    static void testUsingRealReportData(){
        // Get report
        List <Report> reportList = [SELECT Id FROM Report LIMIT 1];
        String reportId = (String)reportList.get(0).get('Id');

        //Get a user
        List <User> userList = [SELECT Id FROM User WHERE Department = 'ITS' AND userrole.name = 'System Admin' LIMIT 1];
        String userId = (String)userList.get(0).get('Id');

        //Get a Gateway
        List <Mogli_SMS__Gateway__c> gatewayList = [SELECT Id FROM Mogli_SMS__Gateway__c LIMIT 1];
        String gatewayId = (String)gatewayList.get(0).get('Id');


        //Create requests
        List<Flow_BulkSMS.BulkSmsRequest> listOfRequests = new List<Flow_BulkSMS.BulkSmsRequest>();

        Flow_BulkSMS.BulkSmsRequest request4 = new Flow_BulkSMS.BulkSmsRequest();
        request4.campaignId = '';
        request4.gateway = gatewayId;
        request4.initiator = userId;
        request4.smsMessage = 'Test Message {{firstname}}';
        request4.requestedTerms = 'Fall 2021 - CAS';
        request4.stageDetails = 'Inquired;App Started';
        request4.reportId = reportId;
        request4.requestType = 'report total';
        request4.registrationStatus ='Sent;Registered';
        listOfRequests.add(request4);

        //Request to get total contacts from report
        Flow_BulkSMS.BulkSmsRequest request3 = new Flow_BulkSMS.BulkSmsRequest();
        request3.campaignId = '';
        request3.gateway = gatewayId;
        request3.initiator = userId;
        request3.smsMessage = 'Test Message {{firstname}}';
        request3.requestedTerms = '';
        request3.stageDetails = '';
        request3.reportId = reportId;
        request3.requestType = 'report';
        request3.registrationStatus ='';
        listOfRequests.add(request3);

        Test.startTest();
        Flow_BulkSMS.BulkSMS(listOfRequests);
        Test.stopTest();
    }
}