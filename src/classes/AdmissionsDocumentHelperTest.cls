/*
*
* @Author Luke Vang (Contractor)
* @Created 4/15/2019
* 
* Description: Test class for AdmissionsDocumentHelper class
*
*/
@isTest
public class AdmissionsDocumentHelperTest {
	
	@TestSetup
	static void testSetup(){
		
		Contact contact = new Contact(FirstName = 'AdminDocTestF', LastName = 'AdminDocTestL');
		insert contact;

		Admissions_Document__c admissionsDoc = new Admissions_Document__c(Contact__c = contact.Id, Type__c = 'ACT or SAT official score');
		insert admissionsDoc;

		Blob x_blob =Blob.valueOf('Unit Test Attachment Body');

		//create a attachment
		ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData = x_blob;    
        insert cv;   

		Id documentId = [SELECT ContentDocumentId FROM ContentVersion].ContentDocumentId;

		ContentDocumentLink link = new ContentDocumentLink();
		link.LinkedEntityId = admissionsDoc.Id;
		link.ContentDocumentId = documentId;
		link.ShareType = 'V';
		link.Visibility = 'AllUsers';
		insert link;
	}
	
	static testMethod void testFindAdmissionsDocument(){
		Contact contact = [SELECT Id FROM Contact];
		Admissions_Document__c doc = [SELECT id FROM Admissions_Document__c];
		Admissions_Document__c result = AdmissionsDocumentHelper.findAdmissionsDocument(contact.Id, 'ACT or SAT official score').get(0);
		System.assertEquals(doc.Id, result.Id);
	}

	static testMethod void testGetAdmissionsDocument(){
		Contact contact = [SELECT Id FROM Contact];
		Admissions_Document__c doc = [SELECT id FROM Admissions_Document__c];
		Admissions_Document__c result = AdmissionsDocumentHelper.getAdmissionsDocument(contact, null, 'ACT or SAT official score');
		System.assertEquals(doc.Id, result.Id);
	}
}