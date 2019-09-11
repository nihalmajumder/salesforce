@isTest
public class TestUtility {
    
    static Id assignmentCritRecTypeId = Schema.SObjectType.Assignment_Rule_Criteria_Based_Rule__c.getRecordTypeInfosByName().get('Assignment Rule - Criteria').getRecordTypeId();
    
    public static void setupTestData(){
        setupAssignmentRuleTestData();
        setupFieldValueMapTestData();
        createGeoTerritories();
    }
    
    public static void setupTestDataCriteriaBasedRule(){
        setupCriteriaBasedAssignmentRuleTestData();
    }
    
    
    static void setupCriteriaBasedAssignmentRuleTestData(){
        
        //create assignment rule for account sobject
        Assignment_Rule__c  assignmentRule = new Assignment_Rule__c(Name = 'For Test Class 2', sObject__c = 'Account', Active__c = true, Has_Run_Criteria__c = true);
        insert assignmentRule;
        
        Assignment_Rule_Criteria_Based_Rule__c assignmentRuleCriteria = new Assignment_Rule_Criteria_Based_Rule__c(RecordTypeId = assignmentCritRecTypeId, Assignment_Rule__c = assignmentRule.Id, Field__c = 'Name', Value__c ='Test Account 1', FieldType__c = 'STRING', Operator__c = 'equals', SObject_Type__c = 'Account');
        insert assignmentRuleCriteria;
        
        //create 2 rule entries
        List<Assignment_Rule_Entry__c> ruleEntries = new List<Assignment_Rule_Entry__c>();
        ruleEntries.add(new Assignment_Rule_Entry__c(Assignment_Rule__c = assignmentRule.Id, Assigned_To__c = UserInfo.getUserId(), Filter_Logic__c = '1', Order__c = 1, Send_Email__c = true));
        
        ruleEntries.add(new Assignment_Rule_Entry__c(Assignment_Rule__c = assignmentRule.Id, Assigned_To__c = UserInfo.getUserId(), Order__c = 2, Send_Email__c = true));
        
        ruleEntries.add(new Assignment_Rule_Entry__c(Assignment_Rule__c = assignmentRule.Id, Assigned_To__c = UserInfo.getUserId(), Order__c = 3, Send_Email__c = true));
        
        ruleEntries.add(new Assignment_Rule_Entry__c(Assignment_Rule__c = assignmentRule.Id, Assigned_To__c = UserInfo.getUserId(), Order__c = 4, Send_Email__c = true));
        
        
        
        insert ruleEntries;
        
        List<Assignment_Rule_Criteria_Based_Rule__c> ruleCriterias = new List<Assignment_Rule_Criteria_Based_Rule__c>();
        // equal
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(0).Id, Field__c = 'Name', Position__c = 1, Value__c = 'Test Account 1', FieldType__c = 'STRING', Operator__c = 'equals', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //not equal
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(0).Id, Field__c = 'Name', Position__c = 2, Value__c = 'Test Account Not 1', FieldType__c = 'STRING', Operator__c = 'not equal to', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        
        
        //less than
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(0).Id, Field__c = 'Name', Position__c = 3, Value__c = 'Test Account 99999', FieldType__c = 'STRING', Operator__c = 'less than', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));        
        //greater than
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(0).Id, Field__c = 'Name', Position__c = 4, Value__c = 'Test Account', FieldType__c = 'STRING', Operator__c = 'greater than', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //less or equal
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(0).Id, Field__c = 'Name', Position__c = 5, Value__c = 'Test Account 99999', FieldType__c = 'STRING', Operator__c = 'less or equal', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //greater or equal 
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(0).Id, Field__c = 'Name', Position__c = 6, Value__c = 'Test Account', FieldType__c = 'STRING', Operator__c = 'greater or equal', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //starts with
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(0).Id, Field__c = 'Name', Position__c = 7, Value__c = 'Test', FieldType__c = 'STRING', Operator__c = 'starts with', Field_Label__c = 'Account Name', SObject_Type__c = 'Account')); 

        
        // equal
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(2).Id, Field__c = 'Name', Position__c = 1, Value__c = 'Test Account 2', FieldType__c = 'STRING', Operator__c = 'equals', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //not equal
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(2).Id, Field__c = 'Name', Position__c = 2, Value__c = 'Test Account Not 2', FieldType__c = 'STRING', Operator__c = 'not equal to', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //starts with
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(2).Id, Field__c = 'Name', Position__c = 3, Value__c = 'Test', FieldType__c = 'STRING', Operator__c = 'starts with', Field_Label__c = 'Account Name', SObject_Type__c = 'Account')); 
        
        //less than
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(2).Id, Field__c = 'Name', Position__c = 4, Value__c = 'Test Account 99999', FieldType__c = 'STRING', Operator__c = 'less than', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));        
        //greater than
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(2).Id, Field__c = 'Name', Position__c = 5, Value__c = 'Test Account', FieldType__c = 'STRING', Operator__c = 'greater than', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //less or equal
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(2).Id, Field__c = 'Name', Position__c = 6, Value__c = 'Test Account 99999', FieldType__c = 'STRING', Operator__c = 'less or equal', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //greater or equal 
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(2).Id, Field__c = 'Name', Position__c = 7, Value__c = 'Test Account', FieldType__c = 'STRING', Operator__c = 'greater or equal', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));

        insert ruleCriterias;
        
    }
    
    //creates all test data for assignment rule application
    static void setupAssignmentRuleTestData(){
        
        //create assignment rule for account sobject
        Assignment_Rule__c  assignmentRule = new Assignment_Rule__c(Name = 'For Test Class', sObject__c = 'Account', Active__c = true);
        insert assignmentRule;
        
        //create 2 rule entries
        List<Assignment_Rule_Entry__c> ruleEntries = new List<Assignment_Rule_Entry__c>();
        ruleEntries.add(new Assignment_Rule_Entry__c(Assignment_Rule__c = assignmentRule.Id, Assigned_To__c = UserInfo.getUserId(), Filter_Logic__c = '1', Order__c = 1, Send_Email__c = true));
        
        ruleEntries.add(new Assignment_Rule_Entry__c(Assignment_Rule__c = assignmentRule.Id, Assigned_To__c = UserInfo.getUserId(), Order__c = 2, Send_Email__c = true));
        
        ruleEntries.add(new Assignment_Rule_Entry__c(Assignment_Rule__c = assignmentRule.Id, Assigned_To__c = UserInfo.getUserId(), Order__c = 3, Send_Email__c = true));
        
        ruleEntries.add(new Assignment_Rule_Entry__c(Assignment_Rule__c = assignmentRule.Id, Assigned_To__c = UserInfo.getUserId(), Order__c = 4, Send_Email__c = true));
        
        
        
        insert ruleEntries;
        
        List<Assignment_Rule_Criteria_Based_Rule__c> ruleCriterias = new List<Assignment_Rule_Criteria_Based_Rule__c>();
        // equal
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(0).Id, Field__c = 'Name', Position__c = 1, Value__c = 'Test Account 1', FieldType__c = 'STRING', Operator__c = 'equals', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //not equal
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(0).Id, Field__c = 'Name', Position__c = 2, Value__c = 'Test Account Not 1', FieldType__c = 'STRING', Operator__c = 'not equal to', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        
        
        //less than
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(0).Id, Field__c = 'Name', Position__c = 3, Value__c = 'Test Account 99999', FieldType__c = 'STRING', Operator__c = 'less than', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));        
        //greater than
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(0).Id, Field__c = 'Name', Position__c = 4, Value__c = 'Test Account', FieldType__c = 'STRING', Operator__c = 'greater than', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //less or equal
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(0).Id, Field__c = 'Name', Position__c = 5, Value__c = 'Test Account 99999', FieldType__c = 'STRING', Operator__c = 'less or equal', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //greater or equal 
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(0).Id, Field__c = 'Name', Position__c = 6, Value__c = 'Test Account', FieldType__c = 'STRING', Operator__c = 'greater or equal', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //starts with
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(0).Id, Field__c = 'Name', Position__c = 7, Value__c = 'Test', FieldType__c = 'STRING', Operator__c = 'starts with', Field_Label__c = 'Account Name', SObject_Type__c = 'Account')); 
        
        // value map and criteria with no filters
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(1).Id, Field__c = 'Field_Value_Map', Position__c = 1, Value__c = 'Type', FieldType__c = 'ANYASSIGN', Operator__c = 'equals', Field_Label__c = 'Field Value Map'));
        
        
        // equal
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(2).Id, Field__c = 'Name', Position__c = 1, Value__c = 'Test Account 2', FieldType__c = 'STRING', Operator__c = 'equals', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //not equal
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(2).Id, Field__c = 'Name', Position__c = 2, Value__c = 'Test Account Not 2', FieldType__c = 'STRING', Operator__c = 'not equal to', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //starts with
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(2).Id, Field__c = 'Name', Position__c = 3, Value__c = 'Test', FieldType__c = 'STRING', Operator__c = 'starts with', Field_Label__c = 'Account Name', SObject_Type__c = 'Account')); 
        
        //less than
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(2).Id, Field__c = 'Name', Position__c = 4, Value__c = 'Test Account 99999', FieldType__c = 'STRING', Operator__c = 'less than', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));        
        //greater than
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(2).Id, Field__c = 'Name', Position__c = 5, Value__c = 'Test Account', FieldType__c = 'STRING', Operator__c = 'greater than', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //less or equal
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(2).Id, Field__c = 'Name', Position__c = 6, Value__c = 'Test Account 99999', FieldType__c = 'STRING', Operator__c = 'less or equal', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        //greater or equal 
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(2).Id, Field__c = 'Name', Position__c = 7, Value__c = 'Test Account', FieldType__c = 'STRING', Operator__c = 'greater or equal', Field_Label__c = 'Account Name', SObject_Type__c = 'Account'));
        
        // geo territory and criteria with no filters
        ruleCriterias.add(new Assignment_Rule_Criteria_Based_Rule__c(
            Assignment_Rule_Entry_Criteria__c = ruleEntries.get(1).Id, Field__c = 'Geo_Location', Position__c = 1, Value__c = 'BillingPostalCode', FieldType__c = 'ANYASSIGN', Operator__c = 'equals', Field_Label__c = 'Geo Location'));
        
        insert ruleCriterias;
        
        
    }
    
    //creates all test data for field value map
    static void setupFieldValueMapTestData(){
        Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<Field_Map__c> fieldMaps = new List<Field_Map__c>();
        
        for( Schema.PicklistEntry f : ple){
            fieldMaps.add(new Field_Map__c(Value__c = f.getValue(), Map_Name__c = 'Account Types'));
        }       
        
        insert fieldMaps;
        
        List<Field_Map_Value__c> fmvList = new List<Field_Map_Value__c>();
        for(Field_Map__c fm : fieldMaps){
            fmvList.add(new Field_Map_Value__c( User__c = UserInfo.getUserId(), Field_Map__c = fm.Id, SObject_Type__c = 'Account'));
        }
        insert fmvList;
    }
    
    static void createGeoTerritories(){
        Geographic_Territory__c geographicTerritory = new Geographic_Territory__c();
        geographicTerritory.name = 'AK--Wasilla';
        geographicTerritory.City__c  = 'Wasilla';    
        geographicTerritory.County__c = 'Matanuska-Susitna Borough';    
        geographicTerritory.County_Code__c = '170';    
        geographicTerritory.Postal_Code__c = '99623';    
        geographicTerritory.State__c = 'Alaska';  
        geographicTerritory.State_Code__c = '02';  
        insert geographicTerritory; 
        
        Geographic_Territory_Assignment__c assignment = new Geographic_Territory_Assignment__c();
        assignment.Geographic_Territory__c = geographicTerritory.id;
        assignment.SObject_Type__c = 'Account';
        assignment.User__c = UserInfo.getUserId();
        insert assignment;
    }
    
    
    
}