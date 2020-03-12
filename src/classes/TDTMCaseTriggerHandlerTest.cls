@IsTest
public class TDTMCaseTriggerHandlerTest {
    @TestSetup
    static void testSetup() {
        //create trigger handler record
        hed__Trigger_Handler__c handler = new hed__Trigger_Handler__c();
        handler.Name = 'TDTMCaseTriggerHandler';
        handler.hed__Class__c = 'TDTMCaseTriggerHandler';
        handler.hed__Object__c = 'Case';
        handler.hed__Trigger_Action__c = 'AfterUpdate';
        handler.hed__Active__c = true;
        handler.hed__Load_Order__c = 1;

        insert handler;
    }

    static testMethod void readmissionTaskTest() {
        Contact student = new Contact(LastName='TestLast', FirstName = 'TestFirst', Email = 'TestContact@example.bethel.com', MailingStateCode = 'MN', Banner_Id__c = 'TEST2');
        insert student;
        Case c = new Case(
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SSR_Readmission').getRecordTypeId(),
            ContactId = student.Id,
            Type = 'Readmission',
            Status = 'New',
            Priority = 'High',
            Origin = 'Online Form',
            Subject = ' Re-enrollment Application',
            Description = 'Re-enrollment application webform submission'
        );
        insert c;

        Test.startTest();
        c.Status = 'Reactivate and Register';
        update c;
        Test.stopTest();

        List<Task> tasks = [Select Id FROM Task WHERE WhatId = :c.Id];
        System.assertEquals(4, tasks.size());
    }

}