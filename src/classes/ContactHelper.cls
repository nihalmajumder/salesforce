public with sharing class ContactHelper {
    public static Contact getContact(Id theId) {
        Contact c = null;
        List<Contact> contacts = [
            Select 
                Id, 
                FirstName, 
                LastName,
                Email
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
}