@isTest
public class ReAdmissionControllerTest {

	@TestSetup
	public static void testSetup() {
        ReAdmissionHelperTest.createData();
    }

    static testMethod void constructorTest() {
        
        PageReference pr = Page.Readmission;
        Test.setCurrentPage(pr);

        test.startTest();
        ReAdmissionController controller = new ReAdmissionController();
        test.stopTest();

        System.assert(controller.appControl != null);
    }

    static testMethod void changeSchoolTest() {
        
        PageReference pr = Page.Readmission;
        Test.setCurrentPage(pr);

        test.startTest();
        ReAdmissionController controller = new ReAdmissionController();
        controller.request.school = 'Graduate';
        PageReference reference = controller.changeSchool();
        test.stopTest();

        System.assert(reference == null);
        System.assert(controller.programOptions != null);
        System.assertEquals(4, controller.programOptions.size());
        System.assert(controller.termOptions != null);
        System.assertEquals(2, controller.termOptions.size());
    }

    static testMethod void submitValidationFailTest() {
        
        PageReference pr = Page.Readmission;
        Test.setCurrentPage(pr);

        test.startTest();
        ReAdmissionController controller = new ReAdmissionController();
        controller.request.school = 'Graduate';
        PageReference reference = controller.submit();
        test.stopTest();

        System.assert(reference == null);
        System.assert(ApexPages.hasMessages());
    }

    static testMethod void submitExistsTest() {
        
        PageReference pr = Page.Readmission;
        Test.setCurrentPage(pr);

        ReAdmissionController controller = new ReAdmissionController();
        controller.request.theContact.FirstName = 'TestFirst2';
        controller.request.theContact.MiddleName = 'TestMiddle2';
        controller.request.theContact.LastName = 'TestLast2';
        controller.request.theContact.Email = 'TestContact2@example.bethel.com';
        controller.request.theContact.MailingStreet = '123 Main St';
        controller.request.theContact.MailingCity = 'Rochester';
        controller.request.theContact.MailingStateCode = 'MN';
        controller.request.theContact.MailingCountryCode = 'US';
        controller.request.theContact.MailingPostalCode = '55901';
        controller.request.theContact.HomePhone = '555-555-5555';
        controller.request.theContact.MobilePhone = '555-555-5556';
        controller.request.theContact.hed__Gender__c = 'Male';
        controller.request.theContact.hed__Race__c = 'White';
        controller.request.theContact.hed__Social_Security_Number__c = '123-45-6789';
        controller.request.theContact.hed__WorkPhone__c = '555-555-5557';
        controller.request.theContact.Banner_Id__c = 'TEST2';
        controller.request.theContact.Citizenship__c = 'Citizen';
        controller.request.theContact.Is_Hispanic__c = 'No';
        controller.request.theContact.Is_Veteran__c = 'No';
        controller.request.theContact.Pled_Guilty__c = 'No';
        controller.request.school = 'Graduate';
        controller.request.financialAid = 'No';
        controller.request.hasChanged = 'Yes';
        controller.request.program = [SELECT Id FROM Account WHERE Name = 'test1'].Id;
        controller.request.term = 'Test';
        controller.request.academicRecord = 'Went to school';
        controller.request.employerName = 'ACME';
        controller.request.employerAddress = '124 Main St.; Rochester, MN; US';
        controller.request.responsibilities = 'Do stuff';
        controller.request.hasOtherName = 'Yes';
        controller.request.otherName = 'Tester2';
        controller.request.hasBusinessOffice = 'no';
        controller.request.whyLeftEssay = 'I do not know.';
        controller.request.whyBackEssay = 'Why Not?';
        controller.request.race.add('White');

        test.startTest();
        PageReference reference = controller.submit();
        test.stopTest();

        System.assert(reference == null);
        System.assert(!ApexPages.hasMessages());
        System.assert(controller.createdCase != null);
    }

    static testMethod void submitNotExistsTest() {
        
        PageReference pr = Page.Readmission;
        Test.setCurrentPage(pr);

        ReAdmissionController controller = new ReAdmissionController();
        controller.request.theContact.FirstName = 'TestFirst1';
        controller.request.theContact.MiddleName = 'TestMiddle1';
        controller.request.theContact.LastName = 'TestLast1';
        controller.request.theContact.Email = 'TestContact1@example.bethel.com';
        controller.request.theContact.MailingStreet = '123 Main St';
        controller.request.theContact.MailingCity = 'Rochester';
        controller.request.theContact.MailingStateCode = 'MN';
        controller.request.theContact.MailingCountryCode = 'US';
        controller.request.theContact.MailingPostalCode = '55901';
        controller.request.theContact.HomePhone = '555-555-5555';
        controller.request.theContact.MobilePhone = '555-555-5556';
        controller.request.theContact.hed__Gender__c = 'Male';
        controller.request.theContact.hed__Race__c = 'White';
        controller.request.theContact.hed__Social_Security_Number__c = '123-45-6789';
        controller.request.theContact.hed__WorkPhone__c = '555-555-5557';
        controller.request.theContact.Banner_Id__c = 'TEST1';
        controller.request.theContact.Citizenship__c = 'Citizen';
        controller.request.theContact.Is_Hispanic__c = 'No';
        controller.request.theContact.Is_Veteran__c = 'No';
        controller.request.theContact.Pled_Guilty__c = 'No';
        controller.request.school = 'Graduate';
        controller.request.financialAid = 'No';
        controller.request.hasChanged = 'Yes';
        controller.request.program = [SELECT Id FROM Account WHERE Name = 'test1'].Id;
        controller.request.term = 'Test';
        controller.request.academicRecord = 'Went to school';
        controller.request.employerName = 'ACME';
        controller.request.employerAddress = '124 Main St.; Rochester, MN; US';
        controller.request.responsibilities = 'Do stuff';
        controller.request.hasOtherName = 'Yes';
        controller.request.otherName = 'Tester1';
        controller.request.hasBusinessOffice = 'no';
        controller.request.whyLeftEssay = 'I do not know.';
        controller.request.whyBackEssay = 'Why Not?';

        test.startTest();
        PageReference reference = controller.submit();
        test.stopTest();

        System.assert(reference == null);
        System.assert(!ApexPages.hasMessages());
        System.assert(controller.createdCase != null);
    }

    static testMethod void uploadTest() {
        
        PageReference pr = Page.Readmission;
        Test.setCurrentPage(pr);

        Case c = new Case(
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SSR_Readmission').getRecordTypeId(),
            Type = 'Readmission',
            Status = 'New',
            Priority = 'High',
            Origin = 'Online Form',
            Subject = ' Re-enrollment Application - ',
            Description = 'Re-enrollment application webform submission'
        );
        insert c;

        ReAdmissionController controller = new ReAdmissionController();
        controller.resumeBody = ',' + EncodingUtil.base64Encode(Blob.valueOf('Test'));
        controller.resumeName = 'Resume';
        controller.caseId = c.Id;

        test.startTest();
        PageReference reference = controller.upload();
        test.stopTest();

        System.assert(reference == null);
        System.assert(!ApexPages.hasMessages());
        System.assert(controller.resumeUploaded);
    }

    static testMethod void loadCaseTest() {
        
        PageReference pr = Page.Readmission;
        Test.setCurrentPage(pr);

        Contact theContact = new Contact(
            FirstName = 'First', 
            LastName = 'Last', 
            Email = 'First.Last@test.com',
            MailingStreet = '123 Main St',
            MailingCity = 'Rochester',
            MailingStateCode = 'MN',
            MailingCountryCode = 'US',
            MailingPostalCode = '55901',
            HomePhone = '555-555-5555',
            MobilePhone = '555-555-5556',
            hed__Gender__c = 'Male',
            hed__Race__c = 'White',
            hed__Social_Security_Number__c = '123-45-6789',
            hed__WorkPhone__c = '555-555-5557',
            Banner_Id__c = 'TEST-123',
            Citizenship__c = 'Citizen',
            Is_Hispanic__c = 'No',
            Is_Veteran__c = 'No',
            Pled_Guilty__c = 'No'
        );
        insert theContact;

        Case c = new Case(
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SSR_Readmission').getRecordTypeId(),
            ContactId = theContact.Id,
            Type = 'Readmission',
            Status = 'New',
            Priority = 'High',
            Origin = 'Online Form',
            Subject = ' Re-enrollment Application - ' + theContact.Name,
            Description = 'Re-enrollment application webform submission',
            School__c = 'Graduate',
            Academic_History__c = 'Test',
            Why_Left_Essay__c = 'Test',
            Why_Returning_Essay__c = 'Test'
        );
        insert c;
        pr.getParameters().put('Id', c.Id);

        Employment_History__c history = new Employment_History__c(
            Contact__c = theContact.Id,
            Employer_Name__c = 'Acme',
            Employer_Address__c = '123 Main St', 
            Responsibilities__c = 'Doing stuff'
        );
        insert history;

        ReAdmissionController controller = new ReAdmissionController();

        test.startTest();
        PageReference reference = controller.loadCase();
        test.stopTest();

        System.assert(reference == null);
        System.assertEquals('First', controller.request.theContact.FirstName);
        System.assertEquals('Test', controller.request.academicRecord);
    }
    
}