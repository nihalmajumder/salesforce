@isTest
public class PickListControllerTest {
    
    static testMethod void testGetPicklistValues(){
        List<PickListController.PickListWrapper> wrapper = new List<PickListController.PickListWrapper>();
        Test.startTest();
        String result = PickListController.getPicklistValues('Type', 'Account');
        wrapper = (List<PickListController.PickListWrapper>) JSON.deserialize(result, List<PickListController.PickListWrapper>.class);
        Test.stopTest();
        System.assert(!wrapper.isEmpty());
    }

}