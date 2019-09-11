/**
 * Created by ejc84332 on 2019-03-15.
 */


// THIS IS A PROTOTYPE ONLY

global class TDTM_Requirement_Item_Alert extends TDTMVirtualTriggerHandler {

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        Requirement_Response__c[] has_attatchment = new List<Requirement_Response__c>();


        for(SObject o : newList){
            Requirement_Response__c r = (Requirement_Response__c) o;

            if( r.HasDocument__c == true && r.Requirement_Item__r.School_College__c != 'Undergraduate'){
                has_attatchment.add(r);
            }
        }

        insert create_tasks(has_attatchment);
    }

    private Task[] create_tasks(Requirement_Response__c[] response_list){

        Task[] create_tasks = new List<Task>();

        for(Requirement_Response__c r : response_list){
            create_tasks.add(new Task(
                Subject='New atatchment added to application.',
                WhatId=r.Application__c,
                OwnerId='0055A000008O1JqQAK'
            ));
        }

        return create_tasks;

    }

}