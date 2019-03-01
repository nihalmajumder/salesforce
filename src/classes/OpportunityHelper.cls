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
                if (c.Care_Area__c == 'Provisional Acceptance') {
                    if (theContact != null) {
                        c.Subject = 'Provisional Acceptance - ' + theContact.Name;
                        c.Description = 'Provisional Acceptance - ' + theContact.Name;
                    }
                }
                if (c.Care_Area__c == 'Conditional Acceptance') {
                    if (theContact != null) {
                        c.Subject = 'Conditional Acceptance - ' + theContact.Name;
                        c.Description = 'Conditional Acceptance - ' + theContact.Name;
                    }
                }
            }
          
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            dmo.optAllOrNone = true;
            Database.insert(newCases, dmo);
            
        } 
    }
    
    public static Map<Id, Contact> getContactMap(Set<Id> contactIds) {
        return new Map<Id, Contact>([SELECT Id, Name FROM Contact WHERE Id IN :contactIds]);
    }
    
    private static Case createProvisionalCase(Opportunity opp) {
        Case c = new Case(
            /*RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Student Success Case').getRecordTypeId(), - no record types*/
            ContactId = opp.Contact__c,
            /*HEDA_Program__c = opp.HEDA_Program__c, - no matching field - Luke*/
            Status = 'New',
            Priority = 'High',
            Care_Area__c = 'Provisional Acceptance',
            Origin = 'Admission Process',
            Subject = 'Provisional Acceptance',
            Description = 'Provisional Acceptance',
            OwnerId = SSR_ADVISING_QUEUE_ID
        );
        return c;
    }
    
    private static Case createConditionalCase(Opportunity opp) {
        Case c = new Case(
            /* RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Student Success Case').getRecordTypeId(), - no record types*/
            ContactId = opp.Contact__c,
            /*HEDA_Program__c = opp.HEDA_Program__c,  - no matching field - Luke*/
            /*Case_Manager__c = opp.OwnerId,  - no matching field - Luke*/
            Status = 'New',
            Priority = 'High',
            Care_Area__c = 'Conditional Acceptance',
            Origin = 'Admission Process',
            Subject = 'Conditional Acceptance',
            Description = 'Conditional Acceptance',
            OwnerId = SSR_ADVISING_QUEUE_ID
        );
        return c;
    }

}