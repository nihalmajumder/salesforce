/**
 * Created by ejc84332 on 10/22/19.
 */

@isTest
public with sharing class TDTM_User_Contact_HandlerTest {

    @TestSetup
    static void testSetup(){
        //create trigger handler record
        hed__Trigger_Handler__c handler = new hed__Trigger_Handler__c();
        handler.Name = 'TDTM_User_Contact_Handler';
        handler.hed__Class__c = 'TDTM_User_Contact_Handler';
        handler.hed__Object__c = 'User';
        handler.hed__Trigger_Action__c = 'AfterInsert;AfterUpdate';
        handler.hed__Active__c = true;
        handler.hed__Load_Order__c = 1;

        insert handler;

        Contact c1 = new Contact(LastName='TestLast', FirstName = 'TestFirst', Email = 'TestContact@example.bethel.com', MailingStateCode = 'MN');
        insert c1;

    }


    static testMethod void testUsers(){

        User u1 = BethelTestDataFactory.createTestUser(BethelTestDataFactory.getStandardProfile().Id, 'test', 'test');
        insert u1;
        update u1;


    }


}