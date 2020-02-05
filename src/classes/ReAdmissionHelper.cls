public without sharing class ReAdmissionHelper {
    public static void updateContact(Contact sourceContact, Contact targetContact) {
        if (String.isNotBlank(sourceContact.FirstName)) targetContact.FirstName = sourceContact.FirstName;
        if (String.isNotBlank(sourceContact.MiddleName)) targetContact.MiddleName = sourceContact.MiddleName;
        if (String.isNotBlank(sourceContact.LastName)) targetContact.LastName = sourceContact.LastName;
        if (String.isNotBlank(sourceContact.Email)) targetContact.Email = sourceContact.Email;
        if (String.isNotBlank(sourceContact.MailingStreet)) targetContact.MailingStreet = sourceContact.MailingStreet;
        if (String.isNotBlank(sourceContact.MailingCity)) targetContact.MailingCity = sourceContact.MailingCity;
        if (String.isNotBlank(sourceContact.MailingStateCode)) targetContact.MailingStateCode = sourceContact.MailingStateCode;
        if (String.isNotBlank(sourceContact.MailingCountryCode)) targetContact.MailingCountryCode = sourceContact.MailingCountryCode;
        if (String.isNotBlank(sourceContact.MailingPostalCode)) targetContact.MailingPostalCode = sourceContact.MailingPostalCode;
        if (String.isNotBlank(sourceContact.HomePhone)) targetContact.HomePhone = sourceContact.HomePhone;
        if (String.isNotBlank(sourceContact.MobilePhone)) targetContact.MobilePhone = sourceContact.MobilePhone;
        if (String.isNotBlank(sourceContact.hed__Gender__c)) targetContact.hed__Gender__c = sourceContact.hed__Gender__c;
        if (String.isNotBlank(sourceContact.hed__Race__c)) targetContact.hed__Race__c = sourceContact.hed__Race__c;
        if (String.isNotBlank(sourceContact.hed__Social_Security_Number__c)) targetContact.hed__Social_Security_Number__c = sourceContact.hed__Social_Security_Number__c;
        if (String.isNotBlank(sourceContact.hed__WorkPhone__c)) targetContact.hed__WorkPhone__c = sourceContact.hed__WorkPhone__c;
        if (String.isNotBlank(sourceContact.Alien_Registration_Number__c)) targetContact.Alien_Registration_Number__c = sourceContact.Alien_Registration_Number__c;
        if (sourceContact.Alien_Registration_Number_Date__c != null) targetContact.Alien_Registration_Number_Date__c = sourceContact.Alien_Registration_Number_Date__c;
        if (String.isNotBlank(sourceContact.Banner_Id__c)) targetContact.Banner_Id__c = sourceContact.Banner_Id__c;
        if (String.isNotBlank(sourceContact.Citizenship__c)) targetContact.Citizenship__c = sourceContact.Citizenship__c;
        if (String.isNotBlank(sourceContact.Conviction_Description__c)) targetContact.Conviction_Description__c = sourceContact.Conviction_Description__c;
        if (String.isNotBlank(sourceContact.Is_Hispanic__c)) targetContact.Is_Hispanic__c = sourceContact.Is_Hispanic__c;
        if (String.isNotBlank(sourceContact.Is_Veteran__c)) targetContact.Is_Veteran__c = sourceContact.Is_Veteran__c;
        if (String.isNotBlank(sourceContact.Pled_Guilty__c)) targetContact.Pled_Guilty__c = sourceContact.Pled_Guilty__c;
        if (String.isNotBlank(sourceContact.Visa_Type_Code__c)) targetContact.Visa_Type_Code__c = sourceContact.Visa_Type_Code__c;
    }

    public static Case createCase(Contact theContact, ReAdmissionController.ReAdmissionRequest request, Id theCohortId) {
        Case c = new Case(
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SSR_Readmission').getRecordTypeId(),
            ContactId = theContact.Id,
            Cohort__c = theCohortId,
            Type = 'Readmission',
            Status = 'New',
            Priority = 'High',
            Origin = 'Online Form',
            Subject = ' Re-enrollment Application - ' + theContact.Name,
            Description = 'Re-enrollment application webform submission',
            School__c = request.school,
            Program__c = request.program,
            New_Term__c = request.term,
            Will_Apply_For_Financial_Aid__c = (request.financialAid == 'Yes'),
            Collection_Holds__c = (request.hasBusinessOffice == 'Yes'),
            Has_Information_Changed__c = (request.hasChanged == 'Yes'),
            Why_Left_Essay__c = request.whyLeftEssay,
            Why_Returning_Essay__c = request.whyBackEssay
        );
        return c;

    }

    public static void assignCase(Case c) {

		List<QueueSObject> queues = [SELECT Id, Queue.Id, Queue.Name, Queue.Type, Queue.DeveloperName FROM QueueSObject WHERE Queue.Type ='Queue' AND Queue.DeveloperName = 'SSR_Advising'];
        if (queues != null && !queues.isEmpty()){
            c.OwnerId = queues[0].Queue.Id;
	    }
    }

    public static ContentVersion attachDocument(Case c, Blob body, String name) {

        ContentVersion theContentVersion = new ContentVersion();
        theContentVersion.ContentLocation = 'S'; // S = Stored in Salesforce
        theContentVersion.PathOnClient = name;
        theContentVersion.Title = name;
        theContentVersion.VersionData = body;
        theContentVersion.FirstPublishLocationId = c.Id;
        insert theContentVersion;
        return theContentVersion;
    }

    public static Employment_History__c createEmploymentHistory(Contact c, String name, String address, String responsibilities) {
        Employment_History__c history = new Employment_History__c(
            Contact__c = c.Id,
            Employer_Name__c = name,
            Employer_Address__c = address, 
            Responsibilities__c = responsibilities
        );
        insert history;
        return history;
    }

    public static Id findCohort(Id contactId) {
        Id theCohort = null;
        List<Opportunity> opps = [
            SELECT 
                Id, Name, StageName, Cohort__c, Contact__c 
            FROM 
                Opportunity 
            WHERE 
                Contact__c = :contactId AND Cohort__c != null AND StageName = 'Enrolled'
            ORDER BY 
                Academic_Term_Start_Date__c DESC
        ];
        if (!opps.isEmpty()) {
            theCohort = opps[0].Cohort__c;
        }
        return theCohort;
    }
}