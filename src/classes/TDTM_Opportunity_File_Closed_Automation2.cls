/**
 * Created by bej68982 on 12/12/19.
 */

global class TDTM_Opportunity_File_Closed_Automation2 extends TDTMVirtualTriggerHandler {
    global override void onBeforeUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        // for loop new list, tell sf object=opps, get old opp, check criteria, change values
        for(SObject s : newList) {
            Opportunity new_opportunity = (Opportunity)s;
            Opportunity old_opportunity = (Opportunity)oldMap.get(new_opportunity.Id);

            Boolean stage_is_changed = new_opportunity.StageName != old_opportunity.StageName;
            if(new_opportunity.StageName == 'File Closed' && stage_is_changed && new_opportunity.School_College__c != 'Undergraduate'){
                new_opportunity.Cohort__c =  null;
                new_opportunity.Likely_to_Enroll__c = false;
            }
        }
    }
}