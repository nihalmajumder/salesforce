@isTest
public class TDTMTestScoreTriggerHandlerTest {
    @TestSetup
    static void testSetup() {
        //create trigger handler record
        hed__Trigger_Handler__c handler = new hed__Trigger_Handler__c();
        handler.Name = 'TDTMTestScoreTriggerHandler';
        handler.hed__Class__c = 'TDTMTestScoreTriggerHandler';
        handler.hed__Object__c = 'Test_Score__c';
        handler.hed__Trigger_Action__c = 'BeforeInsert;BeforeUpdate;AfterInsert;AfterUpdate';
        handler.hed__Active__c = true;
        handler.hed__Load_Order__c = 1;

        insert handler;

        Contact student = new Contact(LastName='TestLast', FirstName = 'TestFirst', Email = 'TestContact@example.bethel.com', MailingStateCode = 'MN');
        insert student;

        Application_Control__c appControl = new Application_Control__c(
            Application_Start_Status__c=Application_Control__c.Application_Start_Status__c.getDescribe().getPicklistValues()[0].getValue(),
            Active__c=true,
            Allow_Cancel_From__c=Application_Control__c.Allow_Cancel_From__c.getDescribe().getPicklistValues()[0].getValue(),
            Allow_Withdraw_From__c=Application_Control__c.Allow_Withdraw_From__c.getDescribe().getPicklistValues()[0].getValue(),
            Allow_Submit_From__c=Application_Control__c.Allow_Submit_From__c.getDescribe().getPicklistValues()[0].getValue(),
            Cancel_Status__c=Application_Control__c.Cancel_Status__c.getDescribe().getPicklistValues()[0].getValue(),
            Default__c=true,
            URL_Parameter__c ='st',
            Submit_Status__c=Application_Control__c.Submit_Status__c.getDescribe().getPicklistValues()[0].getValue(),
            Withdraw_Status__c=Application_Control__c.Withdraw_Status__c.getDescribe().getPicklistValues()[0].getValue()
        );
        insert appControl;

        Application__c app = new Application__c(Contact__c=student.Id,Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue());
        insert app;

        Map<String,Id> rtMap = new Map<String,Id>();
        for(RecordType rt : [Select Id,DeveloperName from RecordType where sObjectType = 'Requirement_Item__c']){
            rtMap.put(rt.DeveloperName,rt.Id);
        }

        Program__c ip = new Program__c(Name='Test');
        insert ip;

        Requirement__c req = new Requirement__c(Active__c = true,Name='Test Req',Application_Control__c=appControl.Id);
        insert req;
        Requirement_Item__c riQG = new Requirement_Item__c(Requirement__c=req.Id,Name='Test RI',Active__c = true,RecordTypeId=rtMap.get('Question_Group'));
        insert new List<Requirement_Item__c>{riQG};

    }

    static Contact getContact() {
        return [SELECT Id FROM Contact WHERE Email = 'TestContact@example.bethel.com'];
    }

    static testMethod void onBeforeInsertRecordTypeTest() {
           Test_Score__c testScore = new Test_Score__c(RecordTypeId = Schema.SObjectType.Test_Score__c.getRecordTypeInfosByName().get('SAT').getRecordTypeId(), Contact__c = getContact().Id);

           test.startTest();
           insert testScore;
           test.stopTest();

           Test_Score__c testScoreUpdate = [SELECT Id, RecordTypeId, RecordType.Name, Test_Type__c FROM Test_Score__c WHERE Id = :testScore.Id];
           System.assertEquals('SAT', testScoreUpdate.Test_Type__c);
           System.assertEquals(testScoreUpdate.RecordType.Name, testScoreUpdate.Test_Type__c);
    }

    static testMethod void onBeforeInsertTypeTest() {
           Test_Score__c testScore = new Test_Score__c(Test_Type__c = 'SAT', Contact__c = getContact().Id);

           test.startTest();
           insert testScore;
           test.stopTest();

           Test_Score__c testScoreUpdate = [SELECT Id, RecordTypeId, RecordType.Name, Test_Type__c FROM Test_Score__c WHERE Id = :testScore.Id];
           System.assertEquals('SAT', testScoreUpdate.Test_Type__c);
           System.assertEquals(testScoreUpdate.RecordType.Name, testScoreUpdate.Test_Type__c);

    }

    static testMethod void onBeforeUpdateRecordTypeTest() {
           Test_Score__c testScore = new Test_Score__c(RecordTypeId = Schema.SObjectType.Test_Score__c.getRecordTypeInfosByName().get('ACT').getRecordTypeId(), Contact__c = getContact().Id);
           insert testScore;

           test.startTest();
           testScore.Test_Type__c = 'SAT';
           update testScore;
           test.stopTest();

           Test_Score__c testScoreUpdate = [SELECT Id, RecordTypeId, RecordType.Name, Test_Type__c FROM Test_Score__c WHERE Id = :testScore.Id];
           System.assertEquals('SAT', testScoreUpdate.Test_Type__c);
           System.assertEquals(testScoreUpdate.RecordType.Name, testScoreUpdate.Test_Type__c);
    }

    static testMethod void onBeforeUpdateTypeTest() {
           Test_Score__c testScore = new Test_Score__c(RecordTypeId = Schema.SObjectType.Test_Score__c.getRecordTypeInfosByName().get('ACT').getRecordTypeId(), Contact__c = getContact().Id);
           insert testScore;

           test.startTest();
           testScore.RecordTypeId = Schema.SObjectType.Test_Score__c.getRecordTypeInfosByName().get('SAT').getRecordTypeId();
           update testScore;
           test.stopTest();

           Test_Score__c testScoreUpdate = [SELECT Id, RecordTypeId, RecordType.Name, Test_Type__c FROM Test_Score__c WHERE Id = :testScore.Id];
           System.assertEquals('SAT', testScoreUpdate.Test_Type__c);
           System.assertEquals(testScoreUpdate.RecordType.Name, testScoreUpdate.Test_Type__c);

    }

    static testMethod void onBeforeUpdateTypeNullTest() {
           Test_Score__c testScore = new Test_Score__c(RecordTypeId = Schema.SObjectType.Test_Score__c.getRecordTypeInfosByName().get('ACT').getRecordTypeId(), Contact__c = getContact().Id);
           insert testScore;

           test.startTest();
           testScore.Test_Type__c = null;
           update testScore;
           test.stopTest();

           Test_Score__c testScoreUpdate = [SELECT Id, RecordTypeId, RecordType.Name, Test_Type__c FROM Test_Score__c WHERE Id = :testScore.Id];
           System.assertEquals('ACT', testScoreUpdate.Test_Type__c);
           System.assertEquals(testScoreUpdate.RecordType.Name, testScoreUpdate.Test_Type__c);

    }

    static testMethod void onAfterUpdateTest() {
           Test_Score__c testScore = new Test_Score__c(RecordTypeId = Schema.SObjectType.Test_Score__c.getRecordTypeInfosByName().get('ACT').getRecordTypeId(), Contact__c = getContact().Id);
           insert testScore;

           Application__c app = [SELECT Id, Application_Status__c FROM Application__c];
           app.Application_Status__c = 'Submitted';
           update app;

           test.startTest();
           testScore.Document_Status__c = 'Received';
           update testScore;
           test.stopTest();

           app = [SELECT Id, Application_Status__c FROM Application__c];
           System.assertEquals('Completed', app.Application_Status__c);

    }

    static testMethod void onAfterInsertOpportunityTest() {
       Contact c = [Select Id FROM Contact];

       Opportunity opp = new Opportunity(Name='Test Opp', Contact__c = c.Id, StageName = 'Inquired', Stage_Detail__c = 'Inquired', CloseDate = Date.today());
       insert opp;

       Test.startTest();
       Test_Score__c testScore = new Test_Score__c(RecordTypeId = Schema.SObjectType.Test_Score__c.getRecordTypeInfosByName().get('ACT').getRecordTypeId(), Contact__c = c.Id, Document_Status__c = 'Received');
       insert testScore;
       Test.stopTest();

       Opportunity upOpp = [SELECT Id, StageName, Stage_Detail__c FROM Opportunity WHERE Id = :opp.Id];
       System.assertEquals('Inquired', upOpp.StageName);
       System.assertEquals('Pre-Applied', upOpp.Stage_Detail__c);

    }

    static testMethod void onAfterUpdateOpporunityTest() {
       Contact c = [Select Id FROM Contact];

       Opportunity opp = new Opportunity(Name='Test Opp', Contact__c = c.Id, StageName = 'Inquired', Stage_Detail__c = 'Inquired', CloseDate = Date.today());
       insert opp;

       Test_Score__c testScore = new Test_Score__c(RecordTypeId = Schema.SObjectType.Test_Score__c.getRecordTypeInfosByName().get('ACT').getRecordTypeId(), Contact__c = c.Id);
       insert testScore;

       Test.startTest();
       testScore.Document_Status__c = 'Received';
       update testScore;
       Test.stopTest();

       Opportunity upOpp = [SELECT Id, StageName, Stage_Detail__c FROM Opportunity WHERE Id = :opp.Id];
       System.assertEquals('Inquired', upOpp.StageName);
       System.assertEquals('Pre-Applied', upOpp.Stage_Detail__c);

    }

}