/*
 * 
 * 
 * test - ApplicationQueryCacheTest
 * 
 */ 
public with sharing class ApplicationQueryCache {

    public static Map<Id, User> userCache = new Map<Id, User>();
    public static Map<Id, Application__c> applicationCache = new Map<Id, Application__c>();

	public static User getUser(Id userId) {
        User u = userCache.get(userId);
        if (u == null) {
            u = [SELECT Id, ContactId FROM User WHERE Id = :userId];
            userCache.put(userId, u);
        }
        return u;
	}

    public static Id getContactId(Id userId) {
        Id theContactId = null;
        User u = getUser(userId);
        if (u != null) {
            theContactId = u.ContactId;
        }
        return theContactId;
    }

    public static Application__c getApplication(Id applicationId) {
        Application__c app = applicationCache.get(applicationId);
        if (app == null) {
            app = [
                SELECT 
                    Id, 
                    Contact__c,
                    Intended_Program__c, 
                    Intended_Program__r.Program_Name_on_Application__c, 
                    Intended_Program__r.Name, 
                    Intended_Program_Code__c, 
                    Intended_Term_of_Entry__c,
                    Intended_Term_of_Entry__r.Name, 
                    Intended_Term_of_Entry__r.Term_Start_Date__c, 
                    Applicant_Type__c, 
                    Citizenship__c, 
                    Delivery_Type__c, 
                    Student_Type__c, 
                    Residency__c, 
                    Application_Status__c, 
                    School_College__c, 
                    Application_Control__c 
                FROM 
                    Application__c 
                WHERE 
                    Id = :applicationId
            ];
            applicationCache.put(applicationId, app);
        }
        return app;
    }

    public static Application__c getApplication(Id applicationId, Id contactId) {
        Application__c app = getApplication(applicationId);
        if (app.Contact__c != contactId) {
            app = null;
        }
        return app;
    }

 
}