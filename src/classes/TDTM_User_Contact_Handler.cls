/**
 * Created by ejc84332 on 10/22/19.
 */

global class TDTM_User_Contact_Handler extends TDTMVirtualTriggerHandler {

    global override void onAfterInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        update_contacts(newList);
    }

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        update_contacts(newList, oldMap);
    }

    private void update_contacts(List<SObject> user_list){

        Contact[] contacts = new List<Contact>();

        for(SObject s : user_list){
            User u = (User)s;
            if(u.ContactId != null){
                contacts.add(new Contact(Id=u.ContactId));
            }
        }

        update contacts;
    }

    private void update_contacts(List<SObject> newList, Map<Id, SObject> oldMap){
        Contact[] contacts = new List<Contact>();

        // for any User that changed Contacts, we need to update both the old and new.

        for(SObject s : newList) {
            User u = (User) s;
            User old_u = (User)oldMap.get(u.Id);

            // changed?
            if(u.ContactId != old_u.ContactId){
                // add both if not null
                if(u.ContactId != null){
                    contacts.add(new Contact(Id=u.ContactId));
                }
                if(old_u.ContactId != null){
                    contacts.add(new Contact(Id=old_u.ContactId));
                }
            }
        }

        update contacts;

    }


}