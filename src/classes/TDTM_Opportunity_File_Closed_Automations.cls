/**
 * Created by jps26784 on 12/12/19.
 */

global class TDTM_Opportunity_File_Closed_Automations extends TDTMVirtualTriggerHandler {

    global override void onBeforeUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        // for loop new list, tell sf object=opps, get old opp, check criteria, change values

        for (SObject s : newList){
            Opportunity new_Opp = (Opportunity)s;
            Opportunity old_Opp = (Opportunity)oldMap.get(new_Opp.Id);

            Boolean StageName_is_changed = new_Opp.StageName != old_Opp.StageName;

            if(new_Opp.StageName == 'File Closed' && StageName_is_changed && new_Opp.School_College__c != 'Undergraduate'){
                new_Opp.Cohort__c = null;
                new_Opp.Likely_to_Enroll__c = false;
            }
        }
    }

}