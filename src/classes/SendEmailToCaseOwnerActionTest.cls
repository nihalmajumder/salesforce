@isTest
public class SendEmailToCaseOwnerActionTest {

    static testMethod void sendEmailTest() {
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
        List<SendEmailToCaseOwnerAction.SendEmailActionRequest> requests = new List<SendEmailToCaseOwnerAction.SendEmailActionRequest>();
        SendEmailToCaseOwnerAction.SendEmailActionRequest request = new SendEmailToCaseOwnerAction.SendEmailActionRequest();
        request.recordId = c.Id;
        request.templateName = 'Registration_for_Re_enrollment_is_Complete';
        requests.add(request);
    
		SendEmailToCaseOwnerAction.sendEmail(requests);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();

        //System.assertEquals(1, invocations, 'Should be one email invocation');
    }

}