/**
 * Created by ejc84332 on 2019-02-06.
 */

trigger TDTM_Interaction on Interaction__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    hed.TDTM_Global_API.run(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.isUndelete, Trigger.new, Trigger.old, Schema.SObjectType.Interaction__c);
}