@isTest
public class TestFieldMappingEditController {
    
    @testSetup
    static void testSetup(){
        TestUtility.setupTestData();
    }
    
    static testMethod void testAddValue(){
        System.assertEquals(0, [SELECT COUNT() FROM Field_Map__c WHERE Map_Name__c =: 'Account Types' AND Value__c = 'Testing']);
        test.startTest();
        FieldMappingEditController.addValue('Account Types', 'Testing');
        test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM Field_Map__c WHERE Map_Name__c =: 'Account Types' AND Value__c = 'Testing']);
    }
    
    static testMethod void testGetValues(){
        String fieldMaps;
        test.startTest();
        fieldMaps = FieldMappingEditController.getValues('Account Types');
        test.stopTest();
        List<Field_Map__c> fmList = (List<Field_Map__c>) JSON.deserialize(fieldMaps, List<Field_Map__c>.class);
        System.assert(!fmList.isEmpty());
    }
    
    static testMethod void testSearchValues(){
        Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        String fieldMaps;
        test.startTest();
        fieldMaps = FieldMappingEditController.searchValues(ple.get(0).getValue(), 'Account Types');
        test.stopTest();
        List<Field_Map__c> fmList = (List<Field_Map__c>) JSON.deserialize(fieldMaps, List<Field_Map__c>.class);
        System.assert(!fmList.isEmpty());
    }
    
}