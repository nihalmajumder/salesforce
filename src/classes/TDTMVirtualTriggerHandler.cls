global virtual class TDTMVirtualTriggerHandler extends hed.TDTM_Runnable {

    global override hed.TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, hed.TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {

        hed.TDTM_Runnable.dmlWrapper dmlWrapper = new hed.TDTM_Runnable.DmlWrapper();

        if (triggerAction == hed.TDTM_Runnable.Action.BeforeInsert) {
            onBeforeInsert(newList, Trigger.newMap, dmlWrapper);
        }
        else if (triggerAction == hed.TDTM_Runnable.Action.BeforeUpdate) {
            onBeforeUpdate(newList, oldList, Trigger.newMap, Trigger.oldMap, dmlWrapper);
        }
        else if (triggerAction == hed.TDTM_Runnable.Action.BeforeDelete) {
            onBeforeDelete(oldList, Trigger.oldMap, dmlWrapper);
        }
        else if (triggerAction == hed.TDTM_Runnable.Action.AfterInsert) {
            onAfterInsert(newList, Trigger.newMap, dmlWrapper);
        }
        else if (triggerAction == hed.TDTM_Runnable.Action.AfterUpdate) {
            onAfterUpdate(newList, oldList, Trigger.newMap, Trigger.oldMap, dmlWrapper);
        }
        else if (triggerAction == hed.TDTM_Runnable.Action.AfterDelete) {
            onAfterDelete(oldList, Trigger.oldMap, dmlWrapper);
        }
        else if (triggerAction == hed.TDTM_Runnable.Action.AfterUndelete) {
            onAfterUndelete(newList, Trigger.newMap, dmlWrapper);
        }

        return dmlWrapper;
    }

    global virtual void onBeforeDelete(List<SObject> oldList, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {}

    global virtual void onBeforeInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {}

    global virtual void onBeforeUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {}

    global virtual void onAfterDelete(List<SObject> oldList, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {}

    global virtual void onAfterInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {}

    global virtual void onAfterUndelete(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {}

    global virtual void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {}
}