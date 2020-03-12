@isTest
public class ReAdmissionHelperTest {

	@TestSetup
	public static void testSetup() {
        createData();
    }

    public static void createData() {
        System.runAs(new User(Id = UserInfo.getUserId())){
            Group testGroup = new Group(Name='SSR_Advising', Type='Queue');
            insert testGroup;
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }

        Application_Control__c appControl = new Application_Control__c(
            Application_Start_Status__c = 'Started',
            Active__c = true,
            Allow_Submit_From__c = 'Started',
            Cancel_Status__c = 'Cancelled',
            Default__c = true,
            URL_Parameter__c ='st',
            Submit_Status__c = 'Submitted',
            Withdraw_Status__c = 'Withdrawn'
        );
        insert appControl;

        Account acc = new Account(Name='NewAcc');
        insert acc;
        hed__Term__c term = new hed__Term__c(Name = 'test', hed__Account__c = acc.Id, hed__Start_Date__c = Date.TODAY().addDays(2), hed__End_Date__c = Date.TODAY().addDays(20), Term_Description__c = 'Test');
        insert term;
		Academic_Term__c at = new Academic_Term__c(Name = 'test', Activate_Application_Date__c = Date.TODAY().addDays(2), End_Application_Date__c = Date.TODAY().addDays(20), School_College__c = 'Graduate', Term__c = term.Id);
        insert at;

        Account acc1 = new Account(Name = 'test1', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Academic_Program').getRecordTypeId());
        Account acc2 = new Account(Name = 'test2', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Academic_Program').getRecordTypeId());
        Account acc3 = new Account(Name = 'test3', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Academic_Program').getRecordTypeId());
        insert new List<Account>{acc1, acc2, acc3};

		Program__c p1 = new Program__c(Name = 'test1', Academic_Program__c = acc1.Id, Number_of_Applications_Limit__c = 'One Application Per Term', School_College__c = 'Graduate', Active__c = true);
        Program__c p2 = new Program__c(Name = 'test2', Academic_Program__c = acc2.Id, Number_of_Applications_Limit__c = 'One Application Per Term', School_College__c = 'Graduate', Active__c = true);
        Program__c p3 = new Program__c(Name = 'test3', Academic_Program__c = acc3.Id, Number_of_Applications_Limit__c = 'One Application Per Term', School_College__c = 'Graduate', Active__c = true);
        insert new List<Program__c>{p1, p2, p3};

		Intended_Program_Term__c ipt1 = new Intended_Program_Term__c(Academic_Term__c = at.Id, Intended_Program__c = p1.Id, Activate_Application_Date__c = Date.TODAY().addDays(-1), End_Application_Date__c = Date.TODAY().addDays(1), School_College__c = 'Graduate');
		Intended_Program_Term__c ipt2 = new Intended_Program_Term__c(Academic_Term__c = at.Id, Intended_Program__c = p2.Id, Activate_Application_Date__c = Date.TODAY().addDays(-1), End_Application_Date__c = Date.TODAY().addDays(1), School_College__c = 'Graduate');
		Intended_Program_Term__c ipt3 = new Intended_Program_Term__c(Academic_Term__c = at.Id, Intended_Program__c = p3.Id, Activate_Application_Date__c = Date.TODAY().addDays(-1), End_Application_Date__c = Date.TODAY().addDays(1), School_College__c = 'Graduate');
        insert new List<Intended_Program_Term__c>{ipt1, ipt2, ipt3};

        Contact student = new Contact(LastName='TestLast2', FirstName = 'TestFirst2', Email = 'TestContact2@example.bethel.com', MailingStateCode = 'MN', Banner_Id__c = 'TEST2');
        insert student;

   }

    static testMethod void updateContactTest() {
        
        Contact existingContact = ContactHelper.getContactFromBethelId('TEST2');
        System.assert(existingContact != null);

        Contact theContact = new Contact();
        theContact.FirstName = 'TestFirst2';
        theContact.MiddleName = 'TestMiddle2';
        theContact.LastName = 'TestLast2';
        theContact.Email = 'TestContact2@example.bethel.com';
        theContact.MailingStreet = '123 Main St';
        theContact.MailingCity = 'Rochester';
        theContact.MailingStateCode = 'MN';
        theContact.MailingCountryCode = 'US';
        theContact.MailingPostalCode = '55901';
        theContact.HomePhone = '555-555-5555';
        theContact.MobilePhone = '555-555-5556';
        theContact.hed__Gender__c = 'Male';
        theContact.hed__Race__c = 'White';
        theContact.hed__Social_Security_Number__c = '123-45-6789';
        theContact.hed__WorkPhone__c = '555-555-5557';
        theContact.Banner_Id__c = 'TEST2';
        theContact.Citizenship__c = 'Citizen';
        theContact.Is_Hispanic__c = 'No';
        theContact.Is_Veteran__c = 'No';
        theContact.Pled_Guilty__c = 'No';

        test.startTest();
        ReAdmissionHelper.updateContact(theContact, existingContact);
        test.stopTest();

        System.assertEquals(theContact.LastName, existingContact.LastName);
        System.assertEquals(theContact.Email, existingContact.Email);
        System.assertEquals(theContact.hed__Gender__c, existingContact.hed__Gender__c);
    }

    static testMethod void createContactDataStringTest() {
        
        Contact existingContact = ContactHelper.getContactFromBethelId('TEST2');
        System.assert(existingContact != null);

        Contact theContact = new Contact();
        theContact.FirstName = 'TestFirst2';
        theContact.MiddleName = 'TestMiddle2';
        theContact.LastName = 'TestLast2';
        theContact.Email = 'TestContact2@example.bethel.com';
        theContact.MailingStreet = '123 Main St';
        theContact.MailingCity = 'Rochester';
        theContact.MailingStateCode = 'MN';
        theContact.MailingCountryCode = 'US';
        theContact.MailingPostalCode = '55901';
        theContact.HomePhone = '555-555-5555';
        theContact.MobilePhone = '555-555-5556';
        theContact.hed__Gender__c = 'Male';
        theContact.hed__Race__c = 'White';
        theContact.hed__Social_Security_Number__c = '123-45-6789';
        theContact.hed__WorkPhone__c = '555-555-5557';
        theContact.Banner_Id__c = 'TEST2';
        theContact.Citizenship__c = 'Citizen';
        theContact.Is_Hispanic__c = 'No';
        theContact.Is_Veteran__c = 'No';
        theContact.Pled_Guilty__c = 'No';
        ReAdmissionController.ReAdmissionRequest request = new ReAdmissionController.ReAdmissionRequest();
        request.theContact = theContact;

        test.startTest();
        String data = ReAdmissionHelper.createContactDataString(request);
        test.stopTest();

        System.assert(data != null);
    }

    static testMethod void createCaseTest() {
        
        Contact existingContact = ContactHelper.getContactFromBethelId('TEST2');
        System.assert(existingContact != null);

        ReAdmissionController.ReAdmissionRequest request = new ReAdmissionController.ReAdmissionRequest();
        request.school = 'Graduate';
        request.financialAid = 'No';
        request.hasChanged = 'Yes';
        request.program = [SELECT Id FROM Account WHERE Name = 'test1'].Id;
        request.term = 'Test';
        request.academicRecord = 'Went to school';
        request.employerName = 'ACME';
        request.employerAddress = '124 Main St.; Rochester, MN; US';
        request.responsibilities = 'Do stuff';
        request.hasOtherName = 'Yes';
        request.otherName = 'Tester2';
        request.hasBusinessOffice = 'no';
        request.whyLeftEssay = 'I do not know.';
        request.whyBackEssay = 'Why Not?';

        test.startTest();
        Case theCase = ReAdmissionHelper.createCase(existingContact, request, null);
        test.stopTest();

        System.assert(theCase != null);
    }

    static testMethod void assignCaseTest() {
        
        Contact existingContact = ContactHelper.getContactFromBethelId('TEST2');
        System.assert(existingContact != null);

        ReAdmissionController.ReAdmissionRequest request = new ReAdmissionController.ReAdmissionRequest();
        request.school = 'Graduate';
        request.financialAid = 'No';
        request.hasChanged = 'Yes';
        request.program = [SELECT Id FROM Account WHERE Name = 'test1'].Id;
        request.term = 'Test';
        request.academicRecord = 'Went to school';
        request.employerName = 'ACME';
        request.employerAddress = '124 Main St.; Rochester, MN; US';
        request.responsibilities = 'Do stuff';
        request.hasOtherName = 'Yes';
        request.otherName = 'Tester2';
        request.hasBusinessOffice = 'no';
        request.whyLeftEssay = 'I do not know.';
        request.whyBackEssay = 'Why Not?';

        test.startTest();
        Case theCase = ReAdmissionHelper.createCase(existingContact, request, null);
        insert theCase;
        ReAdmissionHelper.assignCase(theCase);
        Case newCase = ReAdmissionHelper.getCase(theCase.Id);
        test.stopTest();

        System.assert(theCase.OwnerId != null);
        System.assert(newCase != null);
    }

    static testMethod void attachDocumentTest() {
        
        Contact existingContact = ContactHelper.getContactFromBethelId('TEST2');
        System.assert(existingContact != null);

        ReAdmissionController.ReAdmissionRequest request = new ReAdmissionController.ReAdmissionRequest();
        request.school = 'Graduate';
        request.financialAid = 'No';
        request.hasChanged = 'Yes';
        request.program = [SELECT Id FROM Account WHERE Name = 'test1'].Id;
        request.term = 'Test';
        request.academicRecord = 'Went to school';
        request.employerName = 'ACME';
        request.employerAddress = '124 Main St.; Rochester, MN; US';
        request.responsibilities = 'Do stuff';
        request.hasOtherName = 'Yes';
        request.otherName = 'Tester2';
        request.hasBusinessOffice = 'no';
        request.whyLeftEssay = 'I do not know.';
        request.whyBackEssay = 'Why Not?';

        test.startTest();
        Case theCase = ReAdmissionHelper.createCase(existingContact, request, null);
        insert theCase;
        ContentVersion link = ReAdmissionHelper.attachDocument(theCase, Blob.valueOf('My Resume'), 'My Resume');
        test.stopTest();

        System.assert(theCase.Id != null);
        System.assert(link != null);
    }

    static testMethod void createEmploymentHistoryTest() {
        
        Contact existingContact = ContactHelper.getContactFromBethelId('TEST2');
        System.assert(existingContact != null);

        test.startTest();
        Employment_History__c history = ReAdmissionHelper.createEmploymentHistory(existingContact, 'ACME', '123 Main St; Chicago, IL; 66066 US', 'Do stuff');
        Employment_History__c newHistory = ReAdmissionHelper.getEmploymentHistory(existingContact.Id);
        test.stopTest();

        System.assert(newHistory != null);
    }

}