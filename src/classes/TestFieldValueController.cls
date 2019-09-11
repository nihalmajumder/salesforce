@isTest
public class TestFieldValueController {
    
    @testSetup
    static void testSetup(){
        TestUtility.setupTestData();
    }
    
    static testMethod void testGetAllSObjects(){
        test.startTest();
        String sObjects = FieldValueController.getAllSObjects();
        test.stopTest();
        List<FieldValueController.ObjectWrapper> objects = (List<FieldValueController.ObjectWrapper>) JSON.deserialize(sObjects, List<FieldValueController.ObjectWrapper>.class);
        System.assert(!objects.isEmpty());
    }

}