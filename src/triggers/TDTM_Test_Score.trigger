trigger TDTM_Test_Score on Test_Score__c (after delete, before insert, before update, after insert, after update) {
    hed.TDTM_Global_API.run(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.isUndelete, Trigger.new, Trigger.old, Schema.SObjectType.Test_Score__c);
}