({
    handleOnSave : function(component, event, helper) {
        helper.handleOnSave(component, event);
    },
    handleFireEvt: function(component, event, helper) {
        event.preventDefault()
        helper.handleFireEvt(component, event);
    },
    handleDelete : function(component, event, helper) {
        helper.handleDelete(component, event);
    },
})