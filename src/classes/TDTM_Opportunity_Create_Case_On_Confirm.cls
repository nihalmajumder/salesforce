/**
* Created by Luke Vang ( Contractor ) on 2019-02-28.
* Test class - OpportunityHelperTest
*/
global class TDTM_Opportunity_Create_Case_On_Confirm extends TDTMVirtualTriggerHandler {
    
    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        OpportunityHelper.createCaseOnConfirmed((List<Opportunity>) newList, (Map<Id, Opportunity>) oldMap);
    }
    
}