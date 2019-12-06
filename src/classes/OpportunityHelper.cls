/**
* Created by Luke Vang ( Contractor ) on 2019-02-28.
*
* Logic taken from ApplicationHelper in previous full sandbox
*
* Test class - OpportunityHelperTest
*
*/
public class OpportunityHelper {

    public static Id SSR_ADVISING_QUEUE_ID = [SELECT id FROM Group WHERE Name =: 'SSR - Advising'].Id;
    
    public final static String CONFIRMED_STATUS = 'Confirmed';
    public final static String PROVISIONAL_TYPE = 'Provisional';
    public final static String CONDITIONAL_TYPE = 'Conditional';
    public final static String CONDITIONAL_AND_PROVISIONAL_TYPE = 'Conditional and Provisional';
    static Id studentSuccessCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SSR - Student Success Case').getRecordTypeId();
    
    public static Boolean createdCases = false;
    
    public static void createCaseOnConfirmed(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        List<Case> newCases = new List<Case>();
        Set<Id> contactIds = new Set<Id>();
        for (Opportunity opp : newList) {
            Opportunity oldOpp = oldMap.get(opp.Id);
            if (oldOpp != null && opp.StageName == CONFIRMED_STATUS && oldOpp.StageName != CONFIRMED_STATUS && opp.School_College__c != 'Undergraduate') {
                if (opp.Admission_Type__c == PROVISIONAL_TYPE) {
                    newCases.add(createProvisionalCase(opp));
                    contactIds.add(opp.Contact__c);
                }
                else if (opp.Admission_Type__c == CONDITIONAL_TYPE) {
                    newCases.add(createConditionalCase(opp));
                    contactIds.add(opp.Contact__c);
                }
                else if (opp.Admission_Type__c == CONDITIONAL_AND_PROVISIONAL_TYPE) {
                    newCases.add(createProvisionalCase(opp));
                    newCases.add(createConditionalCase(opp));
                    contactIds.add(opp.Contact__c);
                }
            }
        }
        if (!newCases.isEmpty() && !createdCases) {
            createdCases = true;
            Map<Id, Contact> contactMap = getContactMap(contactIds);
            for (Case c : newCases) {
                Contact theContact = contactMap.get(c.ContactId);
                if (c.Type == 'Provisional Acceptance') {
                    if (theContact != null) {
                        c.Subject = 'Provisional Acceptance - ' + theContact.Name;
                        c.Description = 'Provisional Acceptance - ' + theContact.Name;
                    }
                }
                if (c.Type == 'Conditional Acceptance') {
                    if (theContact != null) {
                        c.Subject = 'Conditional Acceptance - ' + theContact.Name;
                        c.Description = 'Conditional Acceptance - ' + theContact.Name;
                    }
                }
            }
          
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = false;
            dmo.optAllOrNone = true;
            Database.insert(newCases, dmo);
            
        } 
    }
    
    public static Map<Id, Contact> getContactMap(Set<Id> contactIds) {
        return new Map<Id, Contact>([SELECT Id, Name FROM Contact WHERE Id IN :contactIds]);
    }
    
    private static Case createProvisionalCase(Opportunity opp) {
        Case c = new Case(
            RecordTypeId = studentSuccessCaseRecTypeId,
            ContactId = opp.Contact__c,
            /*HEDA_Program__c = opp.HEDA_Program__c, - no matching field - Luke*/
            Status = 'New',
            Priority = 'High',
            Type = 'Provisional Acceptance',
            Origin = 'Admission Process',
            Subject = 'Provisional Acceptance',
            Description = 'Provisional Acceptance',
            Program__c = opp.EDA_Program_Account_Id__c,
            School__c = opp.School_College__c,
            OwnerId = SSR_ADVISING_QUEUE_ID
        );
        return c;
    }
    
    private static Case createConditionalCase(Opportunity opp) {
        Case c = new Case(
             RecordTypeId = studentSuccessCaseRecTypeId,
            ContactId = opp.Contact__c,
            /*HEDA_Program__c = opp.HEDA_Program__c,  - no matching field - Luke*/
            /*Case_Manager__c = opp.OwnerId,  - no matching field - Luke*/
            Status = 'New',
            Priority = 'High',
            Type = 'Conditional Acceptance',
            Origin = 'Admission Process',
            Subject = 'Conditional Acceptance',
            Description = 'Conditional Acceptance',
            Program__c = opp.EDA_Program_Account_Id__c,
            School__c = opp.School_College__c,
            OwnerId = opp.OwnerId
        );
        return c;
    }

    public static List<Opportunity> getOpportunitiesForApplication(Id appId) {
        List<Opportunity> opps = [
            SELECT 
                Id,
                Application__c,
                StageName,
                Stage_Detail__c
            FROM 
                Opportunity
            WHERE 
                Application__c = :appId 
        ];
        return opps;
    }

    public static List<Opportunity> getOpportunitiesWithCouselorForApplication(Id appId) {
        List<Opportunity> opps = [
            SELECT 
                Id,
                Application__c,
                StageName,
                Stage_Detail__c,
                OwnerId,
                Owner.Name,
                Owner.Email,
                Owner.Profile.Name
            FROM 
                Opportunity
            WHERE 
                Application__c = :appId 
        ];
        return opps;
    }

    public static void updateOpportunityStatusAppCompleted(Id appId) {
        List<Opportunity> opps = getOpportunitiesForApplication(appId);
        List<Opportunity> updateList = new List<Opportunity>();
        for (Opportunity o : opps) {
            if (o.StageName == 'Applied' && o.Stage_Detail__c == 'App Submitted') {
                o.Stage_Detail__c = 'App Completed';
                updateList.add(o);
            }
        }
        if (!updateList.isEmpty()) {
            update updateList;
        }
    }

    public static Map<String, Opportunity> getOpportunitiesForKeys(Set<String> keys) {
        Map<String, Opportunity> oppMap = new Map<String, Opportunity>();
        List<Opportunity> opps = [
            SELECT 
                Id,
                CloseDate,
                StageName,
                Academic_Program__c,
                Opportunity_Key__c,
                Stage_Detail__c,
                Stage_Value__c,
                AccountId
            FROM 
                Opportunity
            WHERE 
                Opportunity_Key__c IN :keys 
        ];
        if (!opps.isEmpty()) {
            for (Opportunity o : opps) {
                oppMap.put(o.Opportunity_Key__c, o);
            }
        }
        return oppMap;
    }

    public static List<Opportunity> getInquiredOpportunitiesForContact(Set<Id> contactIds) {
        List<Opportunity> opps = [
            SELECT 
                Id,
                CloseDate,
                StageName,
                Academic_Program__c,
                Contact__c,
                Opportunity_Key__c,
                Stage_Detail__c,
                Stage_Value__c,
                AccountId
            FROM 
                Opportunity
            WHERE 
                Contact__c IN :contactIds AND StageName = 'Inquired' AND Stage_Detail__c = 'Inquired' 
        ];
        return opps;
    }

}