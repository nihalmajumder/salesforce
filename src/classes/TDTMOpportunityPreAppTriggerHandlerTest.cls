@isTest
public class TDTMOpportunityPreAppTriggerHandlerTest {
    @TestSetup
    static void testSetup() {
        //create trigger handler record
        hed__Trigger_Handler__c handler = new hed__Trigger_Handler__c();
        handler.Name = 'TDTMOpportunityPreAppliedTriggerHandler';
        handler.hed__Class__c = 'TDTMOpportunityPreAppliedTriggerHandler';
        handler.hed__Object__c = 'Opportunity';
        handler.hed__Trigger_Action__c = 'BeforeInsert';
        handler.hed__Active__c = true;
        handler.hed__Load_Order__c = 1;

        insert handler;

        Contact c = new Contact(LastName='TestLast', FirstName = 'TestFirst', Email = 'TestContact@example.bethel.com', MailingStateCode = 'MN');
        insert c;
    }
    
    static testMethod void onBeforeInsertAdmissionsDocumentTest() {
        Contact c = [Select Id FROM Contact];

        Admissions_Document__c doc = new Admissions_Document__c(Contact__c = c.Id, Status__c = 'Received');
        insert doc;

        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', Contact__c = c.Id, StageName = 'Inquired', Stage_Detail__c = 'Inquired', CloseDate = Date.today());
        insert opp;
        Test.stopTest();

        Opportunity upOpp = [SELECT Id, StageName, Stage_Detail__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Inquired', upOpp.StageName);
        System.assertEquals('Pre-Applied', upOpp.Stage_Detail__c);

    }

    static testMethod void onBeforeInsertEducationHistoryTest() {
        Contact c = [Select Id FROM Contact];

        Education_History__c history = new Education_History__c(RecordTypeId = Schema.SObjectType.Education_History__c.getRecordTypeInfosByName().get('High School').getRecordTypeId(), Contact__c = c.Id, Document_Status__c = 'Received');
        insert history;

        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', Contact__c = c.Id, StageName = 'Inquired', Stage_Detail__c = 'Inquired', CloseDate = Date.today());
        insert opp;
        Test.stopTest();

        Opportunity upOpp = [SELECT Id, StageName, Stage_Detail__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Inquired', upOpp.StageName);
        System.assertEquals('Pre-Applied', upOpp.Stage_Detail__c);
    }

    static testMethod void onBeforeInsertTestScoreTest() {
        Contact c = [Select Id FROM Contact];

       Test_Score__c testScore = new Test_Score__c(RecordTypeId = Schema.SObjectType.Test_Score__c.getRecordTypeInfosByName().get('ACT').getRecordTypeId(), Contact__c = c.Id, Document_Status__c = 'Received');
       insert testScore;

        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', Contact__c = c.Id, StageName = 'Inquired', Stage_Detail__c = 'Inquired', CloseDate = Date.today());
        insert opp;
        Test.stopTest();

        Opportunity upOpp = [SELECT Id, StageName, Stage_Detail__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Inquired', upOpp.StageName);
        System.assertEquals('Pre-Applied', upOpp.Stage_Detail__c);
    }

    static testMethod void onBeforeInsertNoChangeTest() {
        Contact c = [Select Id FROM Contact];

        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', Contact__c = c.Id, StageName = 'Inquired', Stage_Detail__c = 'Inquired', CloseDate = Date.today());
        insert opp;
        Test.stopTest();

        Opportunity upOpp = [SELECT Id, StageName, Stage_Detail__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Inquired', upOpp.StageName);
        System.assertEquals('Inquired', upOpp.Stage_Detail__c);
    }

    static testMethod void onBeforeInsertNoChange2Test() {
        Contact c = [Select Id FROM Contact];

        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', Contact__c = c.Id, StageName = 'Inquired', Stage_Detail__c = 'App Started', CloseDate = Date.today());
        insert opp;
        Test.stopTest();

        Opportunity upOpp = [SELECT Id, StageName, Stage_Detail__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Inquired', upOpp.StageName);
        System.assertEquals('App Started', upOpp.Stage_Detail__c);
    }

}