@isTest
public class ContactHelperTest {
	
    /*
    *
    * create singe contact record
    *
    */
    @testSetup
    static void testSetup(){
        Contact contact = new Contact();
        contact.LastName = 'L-Test';
        insert contact;
    }
    
    /*
    *
    * expected result - both contacts have the same id
    *
    */
    static testMethod void testGetContact(){
        Contact contact = [SELECT id FROM Contact];
        Contact result;
        test.startTest();
        result = ContactHelper.getContact(contact.Id);
        test.stopTest();
        System.assertEquals(result.Id, contact.Id);
    }
    
    /*
    *
    * expected result - both contacts have the same id
    *
    */
    static testMethod void testGetContactMap(){
        Set<Id> contactIds = new Set<Id>();
        Contact contact = [SELECT id FROM Contact];
        contactIds.add(contact.Id);
        Map<Id,Contact> result;
        test.startTest();
        result = ContactHelper.getContactMap(contactIds);
        test.stopTest();
        List<Id> idList = new List<Id>();
        idList.addAll(result.keySet());
        System.assert(!result.isEmpty());
        System.assertEquals(idList[0], contact.Id);
    }
    
}