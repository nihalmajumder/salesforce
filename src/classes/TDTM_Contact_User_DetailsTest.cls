/**
 * Created by ejc84332 on 10/22/19.
 */

@isTest
public with sharing class TDTM_Contact_User_DetailsTest {


    @TestSetup
    static void testSetup(){
        //create trigger handler record
        hed__Trigger_Handler__c handler = new hed__Trigger_Handler__c();
        handler.Name = 'TDTM_Contact_User_Details';
        handler.hed__Class__c = 'TDTM_Contact_User_Details';
        handler.hed__Object__c = 'Contact';
        handler.hed__Trigger_Action__c = 'BeforeUpdate';
        handler.hed__Active__c = true;
        handler.hed__Load_Order__c = 1;

        insert handler;

        Contact c1 = new Contact(LastName='TestLast', FirstName = 'TestFirst', Email = 'TestContact@example.bethel.com', MailingStateCode = 'MN');
        insert c1;

    }

    static testMethod void testOnBeforeInsert(){

        Contact c1 = [select Id from Contact];
        update c1;
        c1 = [select Id, Portal_Login_Details__c from Contact];

        System.assert(c1.Portal_Login_Details__c.contains('No Portal Login has been created for'));

    }


}