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
            if(status == 'Conditional' || status == 'Provisional' || status == 'Received' || status == 'Mandatory'){
                process_list.add((Id) s.get('Contact__c'));
            }
        }
        if(process_list.size() > 0){
            if (System.isBatch() || System.isFuture()) {
                process_list(process_list);
            }else{
                process_list_future(process_list);
            }
        }
    }

    global override void onAfterDelete(List<SObject> oldList, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        List<Id> process_list = new List<Id>();
        for( SObject s : oldList) {
            String status = get_status_by_type(s);
            if(status == 'Conditional' || status == 'Provisional' || status == 'Received' || status == 'Mandatory'){
                process_list.add((Id) s.get('Contact__c'));
            }
        }
        if(process_list.size() > 0){
            if (System.isBatch() || System.isFuture()) {
                process_list(process_list);
            }else{
                process_list_future(process_list);
            }
        }
    }

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        List<Id> process_list = new List<Id>();
        for( SObject s : newList) {

            String new_status = get_status_by_type(s);
            String old_status = get_status_by_type(oldMap.get(s.Id));


            // did status change?
            // ej: used to do a bunch of compliated logic to find exact change. Most of the time we need to recalculate anyway when it changes,
            // so I simplified. If this is running too often check GitHub history for what it was and then add in "Mandatory" status as well.

            if(new_status != old_status){
                process_list.add((Id) s.get('Contact__c'));
            }
        }
        if(process_list.size() > 0){
            if (System.isBatch() || System.isFuture()) {
                process_list(process_list);
            }else{
                process_list_future(process_list);
            }
        }

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

    private static void process_list(List<Id> contact_ids){
        List<Opportunity> opportunities = [SELECT Id, Stage_Detail__c FROM Opportunity
        WHERE StageName in ('Applied', 'Accepted', 'Confirmed') AND Lock_Documents_Missing__c = False AND Contact__c IN :contact_ids];
        // This wlll cause TDTM_Documents_Missing_All to run which will update the Documents Missing field.
        update opportunities;
    }


    @future
    private static void process_list_future(List<Id> contact_ids){

        List<Opportunity> opportunities = [SELECT Id, Stage_Detail__c FROM Opportunity
        WHERE StageName in ('Applied', 'Accepted', 'Confirmed') AND Lock_Documents_Missing__c = False AND Contact__c IN :contact_ids];
        // This wlll cause TDTM_Documents_Missing_All to run which will update the Documents Missing field.
        update opportunities;
    }

}