/*
 * 
 * @Author - Luke Vang
 * @Description - controller to handle creating run criteria for assignment rules
 *  
 * 
 */ 
public with sharing class AssignmentRulesRuleEntryController {
    
    static Id assignmentCritRecTypeId = Schema.SObjectType.Assignment_Rule_Criteria_Based_Rule__c.getRecordTypeInfosByName().get('Assignment Rule - Criteria').getRecordTypeId();

    //build operators manually
    @AuraEnabled(cacheable=true)
    public static String getOperators(){
        Map<String, List<AssignmentRuleWrapperObjects.ComboboxWrapper>> operatorMap = new Map<String, List<AssignmentRuleWrapperObjects.ComboboxWrapper>>();
        operatorMap.put('STRINGS', 
                        new List<AssignmentRuleWrapperObjects.ComboboxWrapper>{
                            new AssignmentRuleWrapperObjects.ComboboxWrapper('-- none --', ''), 
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('equals', 'equals'),  
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('not equal to', 'not equal to'), 
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('starts with', 'starts with'), 
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('contains', 'contains'), 
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('does not contains', 'does not contains'), 
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('less than', 'less than'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('greater than','greater than'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('less or equal', 'less or equal'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('greater or equal', 'greater or equal')});
        
        
        
        operatorMap.put('BOOLEAN', 
                        new List<AssignmentRuleWrapperObjects.ComboboxWrapper>{
                            new AssignmentRuleWrapperObjects.ComboboxWrapper('-- none --', ''),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('equals', 'equals'),  
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('not equal to', 'not equal to')
                                });
        
        
        operatorMap.put('GENERAL', 
                        new List<AssignmentRuleWrapperObjects.ComboboxWrapper>{ 
                            new AssignmentRuleWrapperObjects.ComboboxWrapper('-- none --', ''),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('equals', 'equals'),  
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('not equal to', 'not equal to'), 
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('less than', 'less than'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('greater than','greater than'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('less or equal', 'less or equal'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('greater or equal', 'greater or equal')
                                });
        
        operatorMap.put('MULTIPICKLIST', 
                        new List<AssignmentRuleWrapperObjects.ComboboxWrapper>{
                            new AssignmentRuleWrapperObjects.ComboboxWrapper('-- none --', ''),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('equals', 'equals'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('not equal to', 'not equal to'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('includes', 'includes'),
                                new AssignmentRuleWrapperObjects.ComboboxWrapper('excludes', 'excludes')
                                });
        
        
        
        return JSON.serialize(operatorMap);
    }
    
    /*
     * 
     * retrieveRuleCriteria
     * 
     * this method takes in a assignment rule id
     * and retrieves all it's related rule entries
     * 
     * @param String ruleId - assignment rule Id
     * @return String json object of rule entries
     */ 
    @AuraEnabled
    public static String retrieveRuleCriteria(String ruleId){
        AssignmentRuleWrapperObjects.EntryCriteriaWrapper critWrapper = new AssignmentRuleWrapperObjects.EntryCriteriaWrapper();
        List<Assignment_Rule_Criteria_Based_Rule__c> ruleCriteria = new List<Assignment_Rule_Criteria_Based_Rule__c>();
        ruleCriteria = [SELECT id, Field__c, Operator__c, Field_Label__c, FieldType__c, Value__c, SObject_Type__c, Assignment_Rule__c, RecordTypeId 
                        FROM Assignment_Rule_Criteria_Based_Rule__c
                        WHERE Assignment_Rule__c =: ruleId];
        
        if(!ruleCriteria.isEmpty()){
            critWrapper.field = ruleCriteria[0].Field__c;
            critWrapper.operator = ruleCriteria[0].Operator__c;
            critWrapper.fieldLabel = ruleCriteria[0].Field_Label__c;
            critWrapper.dataType = ruleCriteria[0].FieldType__c;
            critWrapper.value = ruleCriteria[0].Value__c;
            critWrapper.sobjectType = ruleCriteria[0].SObject_Type__c;
            critWrapper.id = ruleCriteria[0].Id;
        }
        
        return JSON.serialize(critWrapper);
    }
    
    
     /*
     * 
     * createRuleEntry
     * 
     * this method takes in a json object and rule Id
     * to create an assignment rule entry
     * used when create a new rule entry
     * 
     * @param String entryJSON - json object with entries to delete
     * @param String ruleId - assignment rule Id
     * 
     */ 
    @AuraEnabled
    public static void createRuleEntry(String entryJSON, String ruleId){
        AssignmentRuleWrapperObjects.EntryCriteriaWrapper critWrapper = (AssignmentRuleWrapperObjects.EntryCriteriaWrapper) JSON.deserialize(entryJSON, AssignmentRuleWrapperObjects.EntryCriteriaWrapper.class);
        Assignment_Rule_Criteria_Based_Rule__c ruleCriteria = new Assignment_Rule_Criteria_Based_Rule__c();
        
        ruleCriteria.Field__c = critWrapper.field;
        ruleCriteria.Operator__c = critWrapper.operator;
        ruleCriteria.Field_Label__c = critWrapper.fieldLabel;
        ruleCriteria.FieldType__c = critWrapper.dataType;
        ruleCriteria.Value__c = critWrapper.value;
        ruleCriteria.SObject_Type__c = critWrapper.sobjectType;
        ruleCriteria.Assignment_Rule__c = ruleId;
        ruleCriteria.RecordTypeId = assignmentCritRecTypeId;
        
        insert ruleCriteria;
    }
    
     /*
     * 
     * upsertRuleEntry
     * 
     * this method takes in a json object and rule Id
     * to create / update an assignment rule entry
     * used when editing rule entry
     * 
     * @param String entryJSON - json object with entries to delete
     * @param String ruleId - assignment rule Id
     * 
     */ 
    @AuraEnabled
    public static void upsertRuleEntry(String entryJSON, String ruleId){
        AssignmentRuleWrapperObjects.EntryCriteriaWrapper critWrapper = (AssignmentRuleWrapperObjects.EntryCriteriaWrapper) JSON.deserialize(entryJSON, AssignmentRuleWrapperObjects.EntryCriteriaWrapper.class);
        Assignment_Rule_Criteria_Based_Rule__c ruleCriteria = new Assignment_Rule_Criteria_Based_Rule__c();
        
        if(critWrapper.id != null){
            ruleCriteria.Id = critWrapper.id;
        }
        
        ruleCriteria.Field__c = critWrapper.field;
        ruleCriteria.Operator__c = critWrapper.operator;
        ruleCriteria.Field_Label__c = critWrapper.fieldLabel;
        ruleCriteria.FieldType__c = critWrapper.dataType;
        ruleCriteria.Value__c = critWrapper.value;
        ruleCriteria.Assignment_Rule__c = ruleId;
        ruleCriteria.SObject_Type__c = critWrapper.sobjectType;
        ruleCriteria.RecordTypeId = assignmentCritRecTypeId;
        
        if(critWrapper.id != null){
            ruleCriteria.Id = critWrapper.id;
            update ruleCriteria;
        }else{
            insert ruleCriteria;
        } 
    }
    
    /*
     * 
     * deleteRuleEntry
     * 
     * this method takes in a json object that contains all the
     * rules entries to be deleted, and deletes them
     * 
     * @param String entryJSON - json object with entries to delete
     * 
     */ 
    @AuraEnabled
    public static void deleteRuleEntry(String entryJSON){
        AssignmentRuleWrapperObjects.EntryCriteriaWrapper critWrapper = (AssignmentRuleWrapperObjects.EntryCriteriaWrapper) JSON.deserialize(entryJSON, AssignmentRuleWrapperObjects.EntryCriteriaWrapper.class);
        Assignment_Rule_Criteria_Based_Rule__c ruleCriteria = new Assignment_Rule_Criteria_Based_Rule__c();
        if(critWrapper.id != null){
            ruleCriteria.Id = critWrapper.id;
        }
        delete ruleCriteria;
    }
}