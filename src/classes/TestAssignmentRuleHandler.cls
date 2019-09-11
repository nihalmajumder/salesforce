@isTest
public class TestAssignmentRuleHandler {
    
    @testSetup
    static void testSetup(){
        TestUtility.setupTestData();
        TestUtility.setupTestDataCriteriaBasedRule();
    }
    
    static testMethod void testTriggerHandler(){
        
        List<Account> accounts = new List<Account>();
        Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        accounts.add(new Account(Name = 'Test Account 1', Website = 'www.google.com'));
        accounts.add(new Account(Name = 'Value Map', Type = ple.get(0).getValue()));
        accounts.add(new Account(Name = 'Test Account 2'));
        accounts.add(new Account(Name = 'Geo Territory', BillingPostalCode = '99623'));
        insert accounts;
        
        test.startTest();
        //ownership probably won't change, as I've assigned the owners to the same people
        //but emails should have been sent out
        AssignmentRuleHandler.execute(accounts);
        
        //emails should have been sent out this transaction
        System.assertEquals(1, System.Limits.getEmailInvocations());
        test.stopTest();
    }
    
    static testMethod void testCheckCriteriaStrings(){
        Schema.SObjectType accountType = Schema.getGlobalDescribe().get('Account');

        AssignmentRuleHandler.fieldMap = Account.getSObjectType().getDescribe().fields.getMap();
        List<SObject> sobjects = new List<SObject>();
        List<Assignment_Rule_Criteria_Based_Rule__c> criteria = new List<Assignment_Rule_Criteria_Based_Rule__c>();

        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'Name', Operator__c = 'equals', Value__c = 'Test'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'Name', Operator__c = 'not equal to', Value__c = 'Test 2'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'Name', Operator__c = 'starts with', Value__c = 'T'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'Name', Operator__c = 'contains', Value__c = 'Test'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'Name', Operator__c = 'does not contain', Value__c = '99'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'Name', Operator__c = 'less than', Value__c = 'Test99'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'Name', Operator__c = 'greater than', Value__c = 'Te'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'Name', Operator__c = 'less or equal', Value__c = 'Test'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'Name', Operator__c = 'greater or equal', Value__c = 'Test'));

        SObject acct = accountType.newSObject();
        acct.put('Name', 'Test');

        // all should return true
        for(Integer i = 0; i < criteria.size() ; i++){
            System.assert(AssignmentRuleHandler.checkCriteria(acct, criteria[i]));
        }

    }

    static testMethod void testCheckCriteriaBooleans(){
        Schema.SObjectType oppType = Schema.getGlobalDescribe().get('Opportunity');
        AssignmentRuleHandler.fieldMap = Opportunity.getSObjectType().getDescribe().fields.getMap();
     
        List<Assignment_Rule_Criteria_Based_Rule__c> criteria = new List<Assignment_Rule_Criteria_Based_Rule__c>();

        criteria = new List<Assignment_Rule_Criteria_Based_Rule__c>();
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'IsPrivate', Operator__c = 'equals', Value__c = 'True'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'IsPrivate', Operator__c = 'not equal to', Value__c = 'False'));

        SObject opp = oppType.newSObject();
        opp.put('IsPrivate', true);

        // all should return true
        for(Integer i = 0; i < criteria.size() ; i++){
            System.assert(AssignmentRuleHandler.checkCriteria(opp, criteria[i]));
        }

    }

    static testMethod void testCheckCriteriaDates(){
        Schema.SObjectType oppType = Schema.getGlobalDescribe().get('Opportunity');
        AssignmentRuleHandler.fieldMap = Opportunity.getSObjectType().getDescribe().fields.getMap();
     
        List<Assignment_Rule_Criteria_Based_Rule__c> criteria = new List<Assignment_Rule_Criteria_Based_Rule__c>();

        criteria = new List<Assignment_Rule_Criteria_Based_Rule__c>();
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'CloseDate', Operator__c = 'equals', Value__c = Date.today().format()));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'CloseDate', Operator__c = 'not equal to', Value__c = Date.today().addDays(-1).format()));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'CloseDate', Operator__c = 'less than', Value__c = Date.today().addDays(1).format()));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'CloseDate', Operator__c = 'greater than', Value__c = Date.today().addDays(-1).format()));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'CloseDate', Operator__c = 'less or equal', Value__c = Date.today().format()));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'CloseDate', Operator__c = 'greater or equal', Value__c = Date.today().format()));

        SObject opp = oppType.newSObject();
        opp.put('CloseDate', Date.today());

        // all should return true
        for(Integer i = 0; i < criteria.size() ; i++){
            System.assert(AssignmentRuleHandler.checkCriteria(opp, criteria[i]));
        }
    }

     static testMethod void testCheckCriteriaDateTime(){
        Schema.SObjectType eventType = Schema.getGlobalDescribe().get('Event');
        AssignmentRuleHandler.fieldMap = Event.getSObjectType().getDescribe().fields.getMap();
        Datetime date_time = DateTime.newInstanceGMT(1996, 3, 22);
        List<Assignment_Rule_Criteria_Based_Rule__c> criteria = new List<Assignment_Rule_Criteria_Based_Rule__c>();

        criteria = new List<Assignment_Rule_Criteria_Based_Rule__c>();
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'EndDateTime', Operator__c = 'equals', Value__c = String.valueOf(date_time)));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'EndDateTime', Operator__c = 'not equal to', Value__c = String.valueOf(date_time.addDays(1))));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'EndDateTime', Operator__c = 'less than', Value__c = String.valueOf(date_time.addDays(1))));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'EndDateTime', Operator__c = 'greater than', Value__c = String.valueOf(date_time.addDays(-1))));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'EndDateTime', Operator__c = 'less or equal', Value__c = String.valueOf(date_time)));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'EndDateTime', Operator__c = 'greater or equal', Value__c = String.valueOf(date_time)));

        SObject event = eventType.newSObject();
        event.put('EndDateTime', date_time);

        // all should return true
        for(Integer i = 0; i < criteria.size() ; i++){
            System.assert(AssignmentRuleHandler.checkCriteria(event, criteria[i]));
        }
    }


    static testMethod void testCheckCriteriaDoubles(){
        Schema.SObjectType accountType = Schema.getGlobalDescribe().get('Account');

        AssignmentRuleHandler.fieldMap = Account.getSObjectType().getDescribe().fields.getMap();
        List<SObject> sobjects = new List<SObject>();
        List<Assignment_Rule_Criteria_Based_Rule__c> criteria = new List<Assignment_Rule_Criteria_Based_Rule__c>();

        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'AnnualRevenue', Operator__c = 'equals', Value__c = '1'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'AnnualRevenue', Operator__c = 'not equal to', Value__c = '2'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'AnnualRevenue', Operator__c = 'less than', Value__c = '3'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'AnnualRevenue', Operator__c = 'greater than', Value__c = '0'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'AnnualRevenue', Operator__c = 'less or equal', Value__c = '1'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'AnnualRevenue', Operator__c = 'greater or equal', Value__c = '1'));

        SObject acct = accountType.newSObject();
        acct.put('AnnualRevenue', 1);

        // all should return true
        for(Integer i = 0; i < criteria.size() ; i++){
            System.assert(AssignmentRuleHandler.checkCriteria(acct, criteria[i]));
        }

    }


    static testMethod void testCheckCriteriaIntegers(){
        Schema.SObjectType accountType = Schema.getGlobalDescribe().get('Account');

        AssignmentRuleHandler.fieldMap = Account.getSObjectType().getDescribe().fields.getMap();
        List<SObject> sobjects = new List<SObject>();
        List<Assignment_Rule_Criteria_Based_Rule__c> criteria = new List<Assignment_Rule_Criteria_Based_Rule__c>();

        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'NumberOfEmployees', Operator__c = 'equals', Value__c = '1'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'NumberOfEmployees', Operator__c = 'not equal to', Value__c = '2'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'NumberOfEmployees', Operator__c = 'less than', Value__c = '3'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'NumberOfEmployees', Operator__c = 'greater than', Value__c = '0'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'NumberOfEmployees', Operator__c = 'less or equal', Value__c = '1'));
        criteria.add(new Assignment_Rule_Criteria_Based_Rule__c(Field__c = 'NumberOfEmployees', Operator__c = 'greater or equal', Value__c = '1'));

        SObject acct = accountType.newSObject();
        acct.put('NumberOfEmployees', 1);

        // all should return true
        for(Integer i = 0; i < criteria.size() ; i++){
            System.assert(AssignmentRuleHandler.checkCriteria(acct, criteria[i]));
        }

    }
}