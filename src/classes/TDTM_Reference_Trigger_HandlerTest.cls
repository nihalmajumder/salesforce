@isTest
public class TDTM_Reference_Trigger_HandlerTest {

    @TestSetup
    static void testSetup() {
        //create trigger handler record
        hed__Trigger_Handler__c handler = new hed__Trigger_Handler__c();
        handler.Name = 'TDTM_Reference_Trigger_Handler';
        handler.hed__Class__c = 'TDTM_Reference_Trigger_Handler';
        handler.hed__Object__c = 'Reference__c';
        handler.hed__Trigger_Action__c = 'AfterInsert;AfterUpdate';
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

    static testMethod void onAfterUpdateTest() {
        Reference__c ref = new Reference__c(RecordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('Grad General').getRecordTypeId(), Contact__c = getContact().Id);
        insert ref;

        Application__c app = [SELECT Id, Application_Status__c FROM Application__c];
        app.Application_Status__c = 'Submitted';
        update app;

        Test.startTest();
        ref.Signature__c = 'Received';
        update ref;
        Test.stopTest();

        app = [SELECT Id, Application_Status__c FROM Application__c];
        System.assertEquals('Completed', app.Application_Status__c);
    }

    static testMethod void onAfterInsertTest() {

        Application__c app = [SELECT Id, Application_Status__c FROM Application__c];
        app.Application_Status__c = 'Submitted';
        update app;

        test.startTest();
        Reference__c ref = new Reference__c(RecordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('Grad General').getRecordTypeId(), Contact__c = getContact().Id, Signature__c='Received');
        insert ref;
        test.stopTest();

        app = [SELECT Id, Application_Status__c FROM Application__c];
        System.assertEquals('Completed', app.Application_Status__c);
    }

}