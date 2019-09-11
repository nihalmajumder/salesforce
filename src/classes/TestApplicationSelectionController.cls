@isTest
public class TestApplicationSelectionController {
    
    @testSetup
    static void testSetup(){
        TestUtility.setupTestData();
    }
    
    static testMethod void testGetApps(){
        List<Application_Settings__mdt> apps;
        Test.startTest();
        apps = ApplicationSelectionController.getApps();
        Test.stopTest();
        System.assert(!apps.isEmpty());
    }
    
}