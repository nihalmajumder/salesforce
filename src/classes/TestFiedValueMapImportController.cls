@isTest
public class TestFiedValueMapImportController {
    
    @testSetup
    static void testSetup(){
        TestUtility.setupTestData();
    }
    
    static testMethod void testGetAllSObjects(){
        test.startTest();
        String sObjects = FieldValueMapImportController.getAllSObjects();
        test.stopTest();
        List<FieldValueController.ObjectWrapper> objects = (List<FieldValueController.ObjectWrapper>) JSON.deserialize(sObjects, List<FieldValueController.ObjectWrapper>.class);
        System.assert(!objects.isEmpty());
    }
    
    static testMethod void testGetPickLists(){
        String fields;
        test.startTest();
        fields = FieldValueMapImportController.getPickLists('Account');
        test.stopTest();
        List<FieldValueMapImportController.FieldWrapper> wrapperList = ( List<FieldValueMapImportController.FieldWrapper>) JSON.deserialize(fields,  List<FieldValueMapImportController.FieldWrapper>.class);
        System.assert(!wrapperList.isEmpty());
    }
    
    static testMethod void testCreateMappings(){
        test.startTest();
        FieldValueMapImportController.createMappings('Test', 'Account', 'Type');
        test.stopTest();
        List<Field_Map__c> fieldMaps = [SELECT id, Map_Name__c FROM Field_Map__c WHERE Map_Name__c =: 'Test'];
        System.assert(!fieldMaps.isEmpty());
    }
    
}