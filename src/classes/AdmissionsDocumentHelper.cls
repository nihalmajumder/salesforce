public with sharing class AdmissionsDocumentHelper {
    public static List<Admissions_Document__c> findAdmissionsDocument(Id contactId, String typeName) {
        List<Admissions_Document__c> docs = [
            Select 
                Id, 
                Type__c, 
                Contact__c, 
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

    public static Admissions_Document__c getAdmissionsDocument(Contact con, Requirement_Response__c response, String typeName) {
        Admissions_Document__c doc = null;
        List<Admissions_Document__c> docs = findAdmissionsDocument(con.Id, typeName);
        if (!docs.isEmpty()) {
            doc = docs[0];
        }
        return doc;
    }

}