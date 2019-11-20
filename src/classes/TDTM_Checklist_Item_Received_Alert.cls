/**
 * Created by ejc84332 on 11/12/19.
 */


/*
 Runs for:
   - Admissions Documents
   - Education History
   - Test Scores
   - References
 */

global class TDTM_Checklist_Item_Received_Alert extends TDTMVirtualTriggerHandler {

    global override void onAfterInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        Set<Id> cids = new Set<Id>();
        SObject[] so = new List<SObject>();
        for(SObject o : newList){
            String status = get_status_by_type(o);
            if((status=='Received' || status=='Conditional') || o.getSObjectType() == Admissions_Document__c.SObjectType && status == 'Conditional'){
                cids.add((Id) o.get('Contact__c'));
                so.add(o);
            }
        }
        if(cids.size() > 0){
            create_tasks(cids, so);
        }
    }

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper){
        Set<Id> cids = new Set<Id>();
        SObject[] so = new List<SObject>();
        for(SObject o : newList){
            String status = get_status_by_type(o);
            String old_status = get_status_by_type(oldMap.get(o.Id));
            if((status=='Received' && old_status !='Received') || (o.getSObjectType() == Admissions_Document__c.SObjectType && status == 'Conditional' && old_status != 'Conditional')){
                cids.add((Id) o.get('Contact__c'));
                so.add(o);
            }
        }
        if(cids.size() > 0){
            create_tasks(cids, so);
        }
    }

    private void create_tasks(Set<Id> cids, List<SObject> so){

        Map<Id, List<Opportunity>> contact_opp_map = new Map<Id, List<Opportunity>>();

        Opportunity[] opps = [select Id, Contact__c, OwnerId from Opportunity where School_College__c != 'Undergraduate' and Stage_Detail__c in ('App Started', 'App Submitted') and Contact__c in :cids];

        for(Opportunity opp : opps){
            if(contact_opp_map.containsKey(opp.Contact__c)){
                contact_opp_map.get(opp.Contact__c).add(opp);
            }else{
                Opportunity[] opp_list = new List<Opportunity>();
                opp_list.add(opp);
                contact_opp_map.put(opp.Contact__c, opp_list);
            }
        }

        Task[] create_tasks = new List<Task>();

        for(SObject o : so){
            Id cid = (Id)o.get('Contact__c');
            String subject = get_description_by_type(o);
            for(Opportunity opp : contact_opp_map.get(cid)){

                create_tasks.add(new Task(WhatId=opp.Id, WhoId=opp.Contact__c, OwnerId=opp.OwnerId, Subject=subject, Type='Other', Checklist_Item_Notification__c=true, ActivityDate=date.today()));
            }
        }

        insert create_tasks;

    }

    private String get_description_by_type(SObject s){
        if(s.getSObjectType() == Admissions_Document__c.SObjectType) {
            String ad_status = get_status_by_type(s);
            if(ad_status == 'Conditional'){
                return 'New Conditional Admissions Document: ' + (String) s.get('Type__c');
            }else{
                return 'New Admissions Document Received: ' + (String) s.get('Type__c');
            }
        }else if(s.getSObjectType() == Education_History__c.SObjectType) {
            return 'New Education History Received: ' + (String) s.get('Best_School_Name__c');
        }else if(s.getSObjectType() == Reference__c.SObjectType){
            return 'New Reference Received: ' + (String) s.get('Type__c');
        }else if(s.getSObjectType() == Test_Score__c.SObjectType){
            return 'New Test Score Received: ' + (String) s.get('Test_Type__c');
        }else{
            return '';
        }
    }

    private String get_status_by_type(SObject s){

        if(s.getSObjectType() == Admissions_Document__c.SObjectType) {
            return (String) s.get('Status__c');
        }else if(s.getSObjectType() == Reference__c.SObjectType) {
            String value = (String) s.get('Signature__c');
            if (value != null && value != '' && value != 'Conditional' && value != 'conditional' && value != 'Waived' && value != 'waived') {
                return 'Received';
            } else {
                return value;
            }
        }else if(s.getSObjectType() == Education_History__c.SObjectType || s.getSObjectType() == Test_Score__c.SObjectType) {
            return (String) s.get('Document_Status__c');
        }else{
            return '';
        }
    }
}