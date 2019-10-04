/**
 * Created by ejc84332 on 10/3/19.
 */

global class TDTM_Calculate_Queue_Rank extends TDTMVirtualTriggerHandler {


    global override void onBeforeUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        for(SObject s : newList) {
            Case c = (Case) s;
            if(c.Queue_Rank__c != null && c.Status == 'Closed'){
                c.Queue_Rank__c = null;
            }
        }
    }

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        Boolean process = false;

        for(SObject s : newList){
            Case c = (Case)s;
            Case old_case = (Case) oldMap.get(c.Id);

            if(old_case.Queue_Rank__c != null && c.Status == 'Closed' && old_case.Status != 'Closed'){
                process = true;
                break;
            }
        }

        if(process){

            Case[] ranked_cases = [select Id, Queue_Rank__c from Case where Status != 'Closed' and Queue_Rank__c != null order by Queue_Rank__c];

            Integer i = 1;
            for(Case c : ranked_cases){
                c.Queue_Rank__c = i;
                i++;
            }

            update ranked_cases;

        }



    }


}