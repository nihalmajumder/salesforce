/**
 * Created by joj28267 on 3/9/20.
 */

global class TDTM_Create_Relationship extends TDTMVirtualTriggerHandler {

    global override void onAfterInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        System.debug('starting onAfterInsert TDTM_Create_Relationship');

        // Get family member(s) from newList
        Family_Member__c family_member = (Family_Member__c)newList[0];

        // List of Relationship objects to add
        List<hed__Relationship__c> new_relationships = new List<hed__Relationship__c>();

        // Add relationship
        new_relationships.add(new hed__Relationship__c(
                hed__Contact__c = family_member.Related_Contact__c,  // Id of contact
                hed__Contact__r = family_member.Related_Contact__r  // Contact
        ));

        if(new_relationships.size() > 0){
            insert new_relationships;
        }
    }

}