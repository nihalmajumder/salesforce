/**
 * Created by ejc84332 on 10/22/19.
 */

global class TDTM_Contact_User_Details extends TDTMVirtualTriggerHandler {

    global override void onBeforeUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        process_contacts(newList);
    }

    private void process_contacts(List<SObject> newList){
        Id[] contact_ids = new List<Id>();
        for(SObject s : newList){
            contact_ids.add(s.Id);
        }

        User[] user_details = [select Id, Username, Email, ContactId from User where ContactId in :contact_ids and IsActive=True];

        Map<Id, User> contact_user_map = new Map<Id, User>();
        for(User u : user_details){
            contact_user_map.put(u.ContactId, u);
        }

        for(SObject s : newList){
            Contact c = (Contact)s;

            User contact_user = contact_user_map.get(c.Id);

            String contact_name = c.Preferred_Name_Calculated__c + ' ' + c.LastName;

            if(contact_user == null){
                c.Portal_Login_Details__c = 'No Portal Login has been created for ' + contact_name;
            }else{
                c.Portal_Login_Details__c = 'Portal Login for ' + contact_name + ' is: ' + contact_user.Username;
            }
        }
    }

}