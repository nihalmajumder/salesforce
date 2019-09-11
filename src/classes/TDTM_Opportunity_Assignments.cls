/**
 * Created by ejc84332 on 2019-02-19.
 */



/* this is the signature for AssignmentRuleHander.execute (5/4/19)
public static void execute(List<sObject> newList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap){
 */

global class TDTM_Opportunity_Assignments extends TDTMVirtualTriggerHandler {

    global override void onAfterInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        AssignmentRuleHandler.execute(newList);
    }

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        SObject[] update_list = new List<SObject>();

        for(SObject o : newList){

            Opportunity new_opp = (Opportunity)o;
            Opportunity old_opp = (Opportunity)oldMap.get(new_opp.Id);

            Boolean fields_changed =
                    new_opp.Attributes__c != old_opp.Attributes__c ||
                    new_opp.Academic_Program__c != old_opp.Academic_Program__c ||
                    new_opp.Academic_Term__c != old_opp.Academic_Term__c ||
                    new_opp.Student_Type__c != old_opp.Student_Type__c ||
                    new_opp.Is_International__c != old_opp.Is_International__c ||
                    (new_opp.Process_Assignments__c != old_opp.Process_Assignments__c && new_opp.Process_Assignments__c == true);

            if(fields_changed && new_opp.Override_Ownership__c == False){
                update_list.add(o);
            }
        }
        if(!update_list.isEmpty()){
            AssignmentRuleHandler.execute(update_list);
        }

    }

}