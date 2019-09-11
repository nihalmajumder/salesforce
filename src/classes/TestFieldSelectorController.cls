@isTest
public class TestFieldSelectorController {
    
    static testMethod void testGetFields (){
        test.startTest();
        String fields = FieldSelectorController.getFields('Account');
        test.stopTest();
        List<AssignmentRuleWrapperObjects.ComboboxWrapper> fieldWrapperList = ( List<AssignmentRuleWrapperObjects.ComboboxWrapper>) JSON.deserialize(fields,  List<AssignmentRuleWrapperObjects.ComboboxWrapper>.class);
        System.assert(!fieldWrapperList.isEmpty());
    }
    
}