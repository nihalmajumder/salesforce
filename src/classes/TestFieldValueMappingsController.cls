@isTest
public class TestFieldValueMappingsController {
    
    @testSetup
    static void testSetup(){
        TestUtility.setupTestData();
    }
    
    static testMethod void testCreateNewMapValues(){
        test.startTest();
        FieldValueMappingsController.createNewMapValues('Account Types', 'Contact');
        test.stopTest();
        List<Field_Map_Value__c> fmv = [SELECT id from Field_Map_Value__c WHERE SObject_Type__c = 'Contact'];
        System.assert(!fmv.isEmpty());
    }
    
    static testMethod void testGetFieldMappingsBySObjectType(){
        String fieldMappings;
        test.startTest();
        fieldMappings = FieldValueMappingsController.getFieldMappingsBySObjectType('Account');
        test.stopTest();
        List<FieldValueMappingsController.FieldMappingWrapper> wrapperList = ( List<FieldValueMappingsController.FieldMappingWrapper> ) JSON.deserialize(fieldMappings,  List<FieldValueMappingsController.FieldMappingWrapper>.class);
        System.assert(!wrapperList.isEmpty());
    }
    
    static testMethod void  testSearchFieldMappings(){
        String fieldMappings;
        test.startTest();
        fieldMappings = FieldValueMappingsController.searchFieldMappings('Account Types', 'Account');
        test.stopTest();
        List<FieldValueMappingsController.FieldMappingWrapper> wrapperList = ( List<FieldValueMappingsController.FieldMappingWrapper> ) JSON.deserialize(fieldMappings,  List<FieldValueMappingsController.FieldMappingWrapper>.class);
        System.assert(!wrapperList.isEmpty());
    }
    
}