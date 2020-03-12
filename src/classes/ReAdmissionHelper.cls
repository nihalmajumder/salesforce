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

    public static String createContactDataString(ReAdmissionController.ReAdmissionRequest request) {
        String data = '';
        data += Contact.FirstName.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.FirstName) ? request.theContact.FirstName : '') + '\n';
        data += Contact.MiddleName.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.MiddleName) ? request.theContact.MiddleName : '') + '\n';
        data += Contact.LastName.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.LastName) ? request.theContact.LastName : '') + '\n';
        data += Contact.Banner_Id__c.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.Banner_Id__c) ? request.theContact.Banner_Id__c : '') + '\n';
        data += 'Are you or have you ever been known by any other name? : ' + request.hasOtherName + '\n';
        data += Contact.MailingStreet.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.MailingStreet) ? request.theContact.MailingStreet : '') + '\n';
        data += Contact.MailingCity.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.MailingCity) ? request.theContact.MailingCity : '') + '\n';
        data += Contact.MailingStateCode.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.MailingStateCode) ? request.theContact.MailingStateCode : '') + '\n';
        data += Contact.MailingCountryCode.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.MailingCountryCode) ? request.theContact.MailingCountryCode : '') + '\n';
        data += Contact.MailingPostalCode.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.MailingPostalCode) ? request.theContact.MailingPostalCode : '') + '\n';
        data += Contact.Email.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.Email) ? request.theContact.Email : '') + '\n';
        data += Contact.HomePhone.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.HomePhone) ? request.theContact.HomePhone : '') + '\n';
        data += Contact.MobilePhone.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.MobilePhone) ? request.theContact.MobilePhone : '') + '\n';
        data += Contact.hed__WorkPhone__c.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.hed__WorkPhone__c) ? request.theContact.hed__WorkPhone__c : '') + '\n';
        data += Contact.Citizenship__c.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.Citizenship__c) ? request.theContact.Citizenship__c : '') + '\n';
        data += Contact.hed__Social_Security_Number__c.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.hed__Social_Security_Number__c) ? request.theContact.hed__Social_Security_Number__c : '') + '\n';
        data += Contact.Alien_Registration_Number__c.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.Alien_Registration_Number__c) ? request.theContact.Alien_Registration_Number__c : '') + '\n';
        data += Contact.Alien_Registration_Number_Date__c.getDescribe().getLabel() + ' : ' + (request.theContact.Alien_Registration_Number_Date__c != null  ? request.theContact.Alien_Registration_Number_Date__c.format() : '') + '\n';
        data += Contact.Visa_Type_Code__c.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.Visa_Type_Code__c) ? request.theContact.Visa_Type_Code__c : '') + '\n';
        data += Contact.Is_Veteran__c.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.Is_Veteran__c) ? request.theContact.Is_Veteran__c : '') + '\n';
        data += Contact.hed__Gender__c.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.hed__Gender__c) ? request.theContact.hed__Gender__c : '') + '\n';
        data += Contact.Is_Hispanic__c.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.Is_Hispanic__c) ? request.theContact.Is_Hispanic__c : '') + '\n';
        data += Contact.hed__Race__c.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.hed__Race__c) ? request.theContact.hed__Race__c : '') + '\n';
        data += Contact.Pled_Guilty__c.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.Pled_Guilty__c) ? request.theContact.Pled_Guilty__c : '') + '\n';
        data += Contact.Conviction_Description__c.getDescribe().getLabel() + ' : ' + (String.isNotBlank(request.theContact.Conviction_Description__c) ? request.theContact.Conviction_Description__c : '') + '\n';
        return data;
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
            Academic_History__c = request.academicRecord,
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
        return attachDocument(c.Id, body, name);
    }

    public static ContentVersion attachDocument(Id theId, Blob body, String name) {

        ContentVersion theContentVersion = new ContentVersion();
        theContentVersion.ContentLocation = 'S'; // S = Stored in Salesforce
        theContentVersion.PathOnClient = name;
        theContentVersion.Title = name;
        theContentVersion.VersionData = body;
        theContentVersion.FirstPublishLocationId = theId;
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

    public static Case getCase(Id theCaseId) {
        Case c = [
            SELECT
                Id,
                RecordTypeId,
                ContactId,
                Contact.FirstName,
                Contact.MiddleName,
                Contact.LastName,
                Contact.Email,
                Contact.MailingStreet,
                Contact.MailingCity,
                Contact.MailingStateCode,
                Contact.MailingCountryCode,
                Contact.MailingPostalCode,
                Contact.HomePhone,
                Contact.MobilePhone,
                Contact.hed__Gender__c,
                Contact.hed__Race__c,
                Contact.hed__Social_Security_Number__c,
                Contact.hed__WorkPhone__c,
                Contact.Alien_Registration_Number__c,
                Contact.Alien_Registration_Number_Date__c,
                Contact.Banner_Id__c,
                Contact.Citizenship__c,
                Contact.Conviction_Description__c,
                Contact.Is_Hispanic__c,
                Contact.Is_Veteran__c,
                Contact.Pled_Guilty__c,
                Contact.Visa_Type_Code__c,
                Cohort__c,
                Type,
                Status,
                Priority,
                Origin,
                Subject,
                Description,
                School__c,
                Program__c,
                New_Term__c,
                Will_Apply_For_Financial_Aid__c,
                Collection_Holds__c,
                Has_Information_Changed__c,
                Academic_History__c,
                Why_Left_Essay__c,
                Why_Returning_Essay__c
            FROM 
                Case
            WHERE 
                Id = :theCaseId
        ];
        return c;
    }

    public static Employment_History__c getEmploymentHistory(Id theContactId) {
        Employment_History__c history = null;
        List<Employment_History__c> histories = [
            SELECT 
                Id, Name, Contact__c, Employer_Name__c, Employer_Address__c, Responsibilities__c
            FROM
                Employment_History__c
            WHERE
                Contact__c = :theContactId
            ORDER BY 
                CreatedDate DESC

        ];
        if (histories != null && !histories.isEmpty()) {
            history = histories[0];
        }
        return history;
    }


}