/**
 * Created by ejc84332 on 2019-05-20.
 */

// Test: OpportunityHelperTest:updateApplicationRequirements

global class TDTM_Application_Internal_Requirements extends TDTMVirtualTriggerHandler {

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        List<Application__c> update_apps = new List<Application__c>();

        for (Application__c new_app : (List<Application__c>) newList){

            Application__c old_app = (Application__c) oldMap.get(new_app.Id);

            if(new_app.GPA_20_Prerequisite__c != old_app.GPA_20_Prerequisite__c ||
                    new_app.GPA_25_Prerequisite__c != old_app.GPA_25_Prerequisite__c ||
                    new_app.GPA_30_Prerequisite__c != old_app.GPA_30_Prerequisite__c ||
                    new_app.Anatomy_Prerequisite__c != old_app.Anatomy_Prerequisite__c ||
                    new_app.Chemistry_Prerequisite__c != old_app.Chemistry_Prerequisite__c ||
                    new_app.Physiology_Prerequisite__c != old_app.Physiology_Prerequisite__c ||
                    new_app.Microbiology_Prerequisite__c != old_app.Microbiology_Prerequisite__c ||
                    new_app.Nutrition_Prerequisite__c != old_app.Nutrition_Prerequisite__c ||
                    new_app.Lifespan_Prerequisite__c != old_app.Lifespan_Prerequisite__c ||
                    new_app.GPA_30_Prerequisite__c != old_app.GPA_30_Prerequisite__c ||
                    new_app.Earned_Degree_Prerequisite__c != old_app.Earned_Degree_Prerequisite__c ||
                    new_app.Anatomy_Prerequisite__c != old_app.Anatomy_Prerequisite__c ||
                    new_app.Biology_Prerequisite__c != old_app.Biology_Prerequisite__c ||
                    new_app.Biomechanics_Prerequisite__c != old_app.Biomechanics_Prerequisite__c ||
                    new_app.Exercise_Physiology_Prerequisite__c != old_app.Exercise_Physiology_Prerequisite__c ||
                    new_app.Physiology_Prerequisite__c != old_app.Physiology_Prerequisite__c ||
                    new_app.Statistics_Prerequisite__c != old_app.Statistics_Prerequisite__c ||
                    new_app.Behavioral_Sciences_Prerequisite__c != old_app.Behavioral_Sciences_Prerequisite__c ||
                    new_app.Statistics_Research_Methods_Prerequisite__c != old_app.Statistics_Research_Methods_Prerequisite__c ||
                    new_app.Developmental_Studies_Prerequisite__c != old_app.Developmental_Studies_Prerequisite__c ||
                    new_app.Masters_Degree_Posted_Prerequisite__c != old_app.Masters_Degree_Posted_Prerequisite__c ||
                    new_app.RN_Clinical_Experience_Prerequisite__c != old_app.RN_Clinical_Experience_Prerequisite__c ||
                    new_app.Behavioral_Sciences_Prerequisite__c != old_app.Behavioral_Sciences_Prerequisite__c ||
                    new_app.Basic_Counseling_Skills_Prerequisite__c != old_app.Basic_Counseling_Skills_Prerequisite__c ||
                    new_app.Chemistry_Prerequisite__c != old_app.Chemistry_Prerequisite__c ||
                    new_app.General_Psychology_Prerequisite__c != old_app.General_Psychology_Prerequisite__c ||
                    new_app.Physics_Prerequisite__c != old_app.Physics_Prerequisite__c){

                update_apps.add(new_app);

            }

            // this might fail if run on more than one app
            ApplicationHelper.checkCompletion(update_apps);

            List<Opportunity> update_opps = [select Id from Opportunity where Application__c in :update_apps];

            update update_opps;

        }

    }
}