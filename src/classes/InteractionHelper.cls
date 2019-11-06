/*
 * 
 * Test class - TDTMApplicationTriggerHandlerTest, InteractionHelperTest
 * 
 * 
 */ 
public class InteractionHelper {

    public static Interaction__c createInteractionForNewApplication(Application__c app) {
        Contact c = ContactHelper.getContact(app.Contact__c);
        Interaction__c i = new Interaction__c(
            Contact__c = app.Contact__c,
            First_Name__c = c.FirstName,
            Last_Name__c = c.LastName,
            Email__c = c.Email,
            School_College__c = app.School_College__c,
            Academic_Program__c = app.Intended_Program__c,
            Academic_Term__c = app.Intended_Term_of_Entry__c,
            Application__c = app.Id,
            Interaction_Source__c = 'Application Create',
            Opportunity_Stage__c = 'Inquired',
            Opportunity_Stage_Detail__c = 'App Started'
        );
        insert i;
        return i;
    }

    public static Interaction__c createInteractionForSubmittedApplication(Id appId) {
        Application__c app = getApplication(appId);
        Contact c = ContactHelper.getContact(app.Contact__c);
        Opportunity o = getOpportunityForApplication(appId);
        Interaction__c i = new Interaction__c(
            Contact__c = app.Contact__c,
            First_Name__c = c.FirstName,
            Last_Name__c = c.LastName,
            Email__c = c.Email,
            School_College__c = app.School_College__c,
            Academic_Program__c = app.Intended_Program__c,
            Academic_Term__c = app.Intended_Term_of_Entry__c,
            Application__c = app.Id,
            Interaction_Source__c = 'Application Submit',
            Opportunity_Stage__c = 'Applied',
            Opportunity_Stage_Detail__c = 'App Submitted'
        );
        if (o != null) {
            i.Opportunity__c = o.Id;
        }
        insert i;
        return i;
    }

    public static Interaction__c createInteractionForChangedApplication(Application__c app) {
        Contact c = ContactHelper.getContact(app.Contact__c);
        Interaction__c i = new Interaction__c(
            Contact__c = app.Contact__c,
            First_Name__c = c.FirstName,
            Last_Name__c = c.LastName,
            Email__c = c.Email,
            School_College__c = app.School_College__c,
            Academic_Program__c = app.Intended_Program__c,
            Academic_Term__c = app.Intended_Term_of_Entry__c,
            Application__c = app.Id,
            Interaction_Source__c = 'Application Change',
            Opportunity_Stage__c = 'Inquired',
            Opportunity_Stage_Detail__c = 'App Started'
        );
        insert i;
        return i;
    }

    public static void createInteractionForChangedApplication(List<Application__c> apps) {
        Set<Id> contactIds = new Set<Id>();
        for (Application__c app : apps) {
            contactIds.add(app.Contact__c);
        }
        Map<Id, Contact> contactMap = ContactHelper.getContactMap(contactIds);
        List<Interaction__c> interactions = new List<Interaction__c>();
        for (Application__c app : apps) {
            Contact c = contactMap.get(app.Contact__c);
            if (c != null) {
                Interaction__c i = new Interaction__c(
                    Contact__c = app.Contact__c,
                    First_Name__c = c.FirstName,
                    Last_Name__c = c.LastName,
                    Email__c = c.Email,
                    School_College__c = app.School_College__c,
                    Academic_Program__c = app.Intended_Program__c,
                    Academic_Term__c = app.Intended_Term_of_Entry__c,
                    Application__c = app.Id,
                    Interaction_Source__c = 'Application Change'
                );
                interactions.add(i);
            }
        }
        insert interactions;
    }

    public static Academic_Term__c getAcademicTerm(Id theId) {
        Academic_Term__c term = null;
        List<Academic_Term__c> terms = [
           Select 
                Id, 
                Term_End_Date__c, 
                Term_Start_Date__c,
                Term_Status__c
            FROM 
                Academic_Term__c
            WHERE
                Id = :theId
        ];
        if (terms != null && !terms.isEmpty()) {
            term = terms[0];
        }
        return term;
    }

    public static Application__c getApplication(Id theId) {
        Application__c app = null;
        List<Application__c> apps = [
            SELECT 
                Id, 
                Contact__c,
                Intended_Program__c, 
                Intended_Term_of_Entry__c,
                School_College__c
            FROM 
                Application__c 
            WHERE 
                Id = :theId
        ];
        if (apps != null && !apps.isEmpty()) {
            app = apps[0];
        }
        return app;
    }

    public static Opportunity getOpportunityForApplication(Id appId) {
        Opportunity opp = null;
        List<Opportunity> opps = [
            SELECT
                Id
            FROM
                Opportunity
            WHERE
                Application__c = :appId
        ];
        if (opps != null && !opps.isEmpty()) {
            opp = opps[0];
        }
        return opp;
    }

    public static void updateInteractionsForContact(Set<Id> contactIds) {
        Map<String, Contact> contactMap = new Map<String, Contact>();
        for (Contact c : [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id IN :contactIds]) {
            contactMap.put(c.Email, c);
        }
        List<Interaction__c> updateList = new List<Interaction__c>();
        for (Interaction__c i : [SELECT Id, First_Name__c, Last_Name__c, Email__c, Contact__c FROM Interaction__c WHERE Email__c IN :contactMap.keySet() AND Contact__c = null AND Interaction_Status__c = 'Imported']) {
            Contact c = contactMap.get(i.Email__c);
            if (c != null && c.LastName == i.Last_Name__c && c.FirstName == i.First_Name__c) {
                i.Contact__c = c.Id;
                updateList.add(i);
            }
        }
        if (!updateList.isEmpty()) {
            update updateList;
        }
    }

    @future
    public static void updateInteractionsForContactFuture(Set<Id> contactIds) {
        updateInteractionsForContact(contactIds);
    }

    public static Interaction__c createInteraction(String firstName, String lastName, String email, String source) {
        Interaction__c interaction = new Interaction__c(
            First_Name__c = firstName, 
            Last_Name__c = lastName, 
            Email__c = email, 
            Interaction_Source__c = source
        );
        insert interaction;
        return interaction;
    }

    public static Interaction__c getInteraction(Id theId) {
        Interaction__c i = null;
        List<Interaction__c> interactions = [
            Select 
                Id, Name, Contact__c
            FROM 
                Interaction__c
            WHERE
                Id = :theId
        ];
        if (interactions != null && !interactions.isEmpty()) {
            i = interactions[0];
        }
        return i;

    }

}