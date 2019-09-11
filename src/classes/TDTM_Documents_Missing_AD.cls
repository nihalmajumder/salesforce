/**
 * Created by ejc84332 on 2019-05-18.
 */

// Test: OpportunityHelperTest

global class TDTM_Documents_Missing_AD extends TDTMVirtualTriggerHandler {


    global override void onAfterInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        List<Id> process_list = new List<Id>();

        for( SObject s : newList) {

            // don't process submitted. Hitting too many SOQL errors because the checklist also runs. It will

            String status = get_status_by_type(s);
            if(status == 'Conditional' || status == 'Provisional'){
                process_list.add((Id) s.get('Contact__c'));
            }
        }
        process_list(process_list);
    }

    global override void onAfterDelete(List<SObject> oldList, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        List<Id> process_list = new List<Id>();
        for( SObject s : oldList) {
            String status = get_status_by_type(s);
            if(status == 'Conditional' || status == 'Provisional'){
                process_list.add((Id) s.get('Contact__c'));
            }
        }
        process_list(process_list);
    }

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        List<Id> process_list = new List<Id>();
        for( SObject s : newList) {

            String new_status = get_status_by_type(s);
            String old_status = get_status_by_type(oldMap.get(s.Id));


            Boolean conditional_or_provisional = new_status == 'Conditional' || new_status == 'Provisional';
            Boolean old_not_conditional_or_provisional = old_status != 'Conditional' && old_status != 'Provisional';
            Boolean old_was_conditional_or_provisional = old_status == 'Conditional' || old_status == 'Provisional';

            // did it move TO conditional or provisional
            if(conditional_or_provisional && old_not_conditional_or_provisional){
                process_list.add((Id) s.get('Contact__c'));
            }
            // did it move AWAY from conditional or provisional
            else if(!conditional_or_provisional && old_was_conditional_or_provisional){
                process_list.add((Id) s.get('Contact__c'));
            }


        }
        process_list(process_list);
    }

    private String get_status_by_type(SObject s){

        if(s.getSObjectType() == Admissions_Document__c.SObjectType) {
            return (String) s.get('Status__c');
        }else if(s.getSObjectType() == Education_History__c.SObjectType || s.getSObjectType() == Test_Score__c.SObjectType) {
            return (String) s.get('Document_Status__c');
        }else if(s.getSObjectType() == Reference__c.SObjectType){
            return (String) s.get('Signature__c');
        }else{
            return '';
        }

    }

    @future
    private static void process_list(List<Id> contact_ids){

        List<Opportunity> opportunities = [SELECT Id, Stage_Detail__c FROM Opportunity
        WHERE StageName in ('Applied', 'Accepted', 'Confirmed') AND Lock_Documents_Missing__c = False AND Contact__c IN :contact_ids];
        // This wlll cause TDTM_Documents_Missing_All to run which will update the Documents Missing field.
        update opportunities;
    }

}