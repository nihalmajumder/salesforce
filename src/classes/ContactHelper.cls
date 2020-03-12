public class ContactHelper {
    public static Contact getContact(Id theId) {
        Contact c = null;
        List<Contact> contacts = [
            Select 
                Id, Name, 
                FirstName, 
                MiddleName,
                LastName,
                Email,
                MailingStreet,
                MailingCity,
                MailingState,
                MailingStateCode,
                MailingCountry,
                MailingCountryCode,
                MailingPostalCode,
                HomePhone,
                MobilePhone,
                hed__Gender__c,
                hed__Race__c,
                hed__Social_Security_Number__c,
                hed__WorkPhone__c,
                Alien_Registration_Number__c,
                Alien_Registration_Number_Date__c,
                Banner_Id__c,
                Citizenship__c,
                Conviction_Description__c,
                Is_Hispanic__c,
                Is_Veteran__c,
                Pled_Guilty__c,
                Visa_Type_Code__c
            FROM 
                Contact
            WHERE
                Id = :theId
        ];
        if (contacts != null && !contacts.isEmpty()) {
            c = contacts[0];
        }
        return c;
    }

    public static Map<Id, Contact> getContactMap(Set<Id> theIds) {
        Map<Id, Contact> contacts = new Map<Id, Contact>([
            Select 
                Id, 
                FirstName, 
                LastName,
                Email,
                MailingState,
                MailingStateCode,
                MailingCountry,
                MailingCountryCode,
                Citizenship__c
            FROM 
                Contact
            WHERE
                Id IN :theIds
        ]);
        return contacts;
    }

    public static Contact getContactFromBethelId(String theId) {
        Contact c = null;
        List<Contact> contacts = [
            SELECT 
                Id, Name, 
                FirstName, 
                MiddleName,
                LastName,
                Email,
                MailingStreet,
                MailingCity,
                MailingState,
                MailingStateCode,
                MailingCountry,
                MailingCountryCode,
                MailingPostalCode,
                HomePhone,
                MobilePhone,
                hed__Gender__c,
                hed__Race__c,
                hed__Social_Security_Number__c,
                hed__WorkPhone__c,
                Alien_Registration_Number__c,
                Alien_Registration_Number_Date__c,
                Banner_Id__c,
                Citizenship__c,
                Conviction_Description__c,
                Is_Hispanic__c,
                Is_Veteran__c,
                Pled_Guilty__c,
                Visa_Type_Code__c
            FROM 
                Contact
            WHERE
                Banner_Id__c = :theId
        ];
        if (contacts != null && !contacts.isEmpty()) {
            c = contacts[0];
        }
        return c;
    }
}