({
    doInit : function(component, event, helper) {
        helper.doInit(component, event);
    },
    handleCancel : function(component, event, helper){
        helper.handleCancel(component, event);
    },
    handleEdit : function(component, event, helper){
        helper.handleEdit(component, event);
    },
    handleAdd : function(component, event, helper){
        helper.handleAdd(component, event);
    },
    handleSearchValues : function(component, event, helper){
        helper.handleSearchValues(component, event);
    },
    handleOnSuccessCmpEvt : function(component, event, helper){
        helper.handleSuccess(component, event);  
    },
})