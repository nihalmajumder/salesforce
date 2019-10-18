/*
*
* Test Class:
* AdmissionsDocumentHelperTest
*
*/
public inherited sharing class AdmissionsDocumentHelper {
    public static List<Admissions_Document__c> findAdmissionsDocument(Id contactId, String typeName) {
        List<Admissions_Document__c> docs = [
            Select 
                Id, 
                Type__c, 
                Contact__c,
                Status__c, 
                Date_Received__c,
                (SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title FROM ContentDocumentLinks) 
            FROM 
                Admissions_Document__c 
            WHERE 
                Contact__c = :contactId AND Type__c = :typeName
            ORDER BY 
                LastModifiedDate
        ];
        return  docs;
    }

    /*
    *
    * Requirement_Response__c response not being used, can it be removed? - Luke Vang 
    *
    */
    public static Admissions_Document__c getAdmissionsDocument(Contact con, Requirement_Response__c response, String typeName) {
        Admissions_Document__c doc = null;
        List<Admissions_Document__c> docs = findAdmissionsDocument(con.Id, typeName);
        if (!docs.isEmpty()) {
            doc = docs[0];
        }
        return doc;
    }

    public static Admissions_Document__c getAdmissionsDocument(Id theId) {
        Admissions_Document__c doc = null;
        List<Admissions_Document__c> docs = [
            Select 
                Id, 
                Type__c, 
                Contact__c,
                Status__c, 
                Date_Received__c,
                (SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title FROM ContentDocumentLinks) 
            FROM 
                Admissions_Document__c 
            WHERE 
                Id = :theId
        ];
        if (!docs.isEmpty()) {
            doc = docs[0];
        }
        return  doc;
    }

}