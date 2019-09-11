trigger TDTM_Admissions_Document on Admissions_Document__c (after delete, after insert, after update) {
    hed.TDTM_Global_API.run(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.isUndelete, Trigger.new, Trigger.old, Schema.SObjectType.Admissions_Document__c);
}