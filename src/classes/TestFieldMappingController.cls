@isTest
public class TestFieldMappingController {
    
    @testSetup
    static void testSetup(){
        TestUtility.setupTestData();
    }
    
    static testMethod void testGetFieldMappings(){
        String fieldMappings;
        test.startTest();
        fieldMappings = FieldMappingController.getFieldMappings();
        test.stopTest();
        List<FieldMappingController.FieldMappingWrapper> wrappers = (  List<FieldMappingController.FieldMappingWrapper> )JSON.deserialize(fieldMappings,   List<FieldMappingController.FieldMappingWrapper>.class);
        System.assert(!wrappers.isEmpty());
    }
    
    static testMethod void testSeachFieldMappings(){
        String fieldMappings;
        test.startTest();
        fieldMappings = FieldMappingController.searchFieldMappings('Account Type');
        test.stopTest();
        List<FieldMappingController.FieldMappingWrapper> wrappers = (  List<FieldMappingController.FieldMappingWrapper> )JSON.deserialize(fieldMappings,   List<FieldMappingController.FieldMappingWrapper>.class);
        System.assert(!wrappers.isEmpty());
    }
    
    static testMethod void testDeleteRecords(){
        System.assert([SELECT COUNT() FROM Field_Map__c] != 0);
        test.startTest();
        FieldMappingController.deleteRecords('Account Types');
        test.stopTest();
        System.assertEquals(0, [SELECT COUNT() FROM Field_Map__c]);
    }
    
}