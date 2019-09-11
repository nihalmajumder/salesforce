@isTest
public class TestAssignmentRulesObjectTabController {
    
    @testSetup
    static void testSetup(){
        TestUtility.setupTestData();
    }
    
    
    static testMethod void testRetrieveCustomSObjects(){
        test.startTest();
        String customObjects = AssignmentRulesObjectTabController.retrieveCustomSObjects();
        test.stopTest();
        System.assert(String.isNotEmpty(customObjects));
    }
    
    static testMethod void testRetrieveStandardSObjects(){
        test.startTest();
        String standardObjects = AssignmentRulesObjectTabController.retrieveStandardSObjects();
        test.stopTest();
        System.assert(String.isNotEmpty(standardObjects));
    }
}