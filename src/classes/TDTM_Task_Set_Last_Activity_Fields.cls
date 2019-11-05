/**
 * Created by ejc84332 on 2019-04-24.
 */


global class TDTM_Task_Set_Last_Activity_Fields extends TDTMVirtualTriggerHandler {

    global override void onAfterInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        Contact[] update_contacts = new List<Contact>();
        for(SObject s: newList){
            Task task = (Task)s;
            if(!task.Subject.contains('Email') && task.Type != 'Email' && task.Status=='Completed' && task.WhoId != null){
                update_contacts.add(new Contact(Id=task.WhoId,Last_Activity_Date__c=Date.today()));
                /*
                    removed from contact update:
                    Last_Activity_Detail__c=thisTask.Subject+ ' by ' +Userinfo.getName()))
                 */
            }
        }

        // de-dupe list
        Set<Contact> contact_set = new Set<Contact>();
        List<Contact> result = new List<Contact>();
        contact_set.addAll(update_contacts);
        result.addAll(contact_set);

        update result;
    }

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        Contact[] update_contacts = new List<Contact>();
        for(SObject s: newList){
            Task task = (Task)s;
            Task old_task = (Task)oldMap.get(task.Id);
            if(!task.Subject.contains('Email') && task.Type != 'Email' && task.Status=='Completed' &&
                        old_task.Status != 'Completed' && task.WhoId != null
            ){
                update_contacts.add(new Contact(Id=task.WhoId,Last_Activity_Date__c=Date.today()));
                /*
                    removed from contact update:
                    Last_Activity_Detail__c=thisTask.Subject+ ' by ' +Userinfo.getName()))
                 */
            }
        }

        // de-dupe list
        Set<Contact> contact_set = new Set<Contact>();
        List<Contact> result = new List<Contact>();
        contact_set.addAll(update_contacts);
        result.addAll(contact_set);

        update result;
    }
}