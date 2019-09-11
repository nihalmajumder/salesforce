@isTest
public class TestFieldValueMappingsEditController {
    
    @testSetup
    static void testSetup(){
        TestUtility.setupTestData();
    }
    
    static testMethod void testGetFieldMappingValues(){
        String fmv;
        test.startTest();
        fmv = FieldValueMappingsEditController.getFieldMappingValues('Account Types', 'Account');
        test.stopTest();
        List<FieldValueMappingsEditController.FieldValueWrapper> wrappers = (List<FieldValueMappingsEditController.FieldValueWrapper>) JSON.deserialize(fmv, List<FieldValueMappingsEditController.FieldValueWrapper>.class);
        System.assert(!wrappers.isEmpty());
    }   
    
    static testMethod void testSearchFieldMappingValues(){
        Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        String fmv;
        test.startTest();
        fmv = FieldValueMappingsEditController.searchFieldMappingValues(ple.get(0).getValue(), 'Account Types', 'Account');
        test.stopTest();
        List<FieldValueMappingsEditController.FieldValueWrapper> wrappers = (List<FieldValueMappingsEditController.FieldValueWrapper>) JSON.deserialize(fmv, List<FieldValueMappingsEditController.FieldValueWrapper>.class);
        System.assert(!wrappers.isEmpty());
    }  
    
}