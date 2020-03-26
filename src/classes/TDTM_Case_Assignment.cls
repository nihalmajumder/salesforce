/**
 * Created by bej68982 on 3/25/20.
 */

global class TDTM_Case_Assignment extends TDTMVirtualTriggerHandler {

    global override void onBeforeUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        for (SObject s : newList) {
            Case new_Case = (Case) s;
            Case old_Case = (Case) oldMap.get(new_Case.Id);

            Boolean ownerChanged = old_Case.OwnerId != new_Case.OwnerId;
            Boolean statusChanged = old_Case.Status != new_Case.Status;

            if(new_Case.Type == 'readmission' && ownerChanged && old_Case.Status == 'New' && !statusChanged) {
                new_Case.Status = 'Review';
            }
        }
    }
}