({
    doInit: function(cmp, evt, helper) {
        helper.doInit(cmp, evt);
    },
    handleCancel: function(cmp, evt, helper) {
        helper.handleCancel(cmp, evt);
    },
    handleSave: function(cmp, evt, helper) {
        helper.handleSave(cmp, evt);
    },
    handleClick : function(component, event, helper){
        helper.createFieldSelectorCmp(component, event);
    },
    handleFieldSelectEvt : function(component, event, helper){
        helper.handleFieldSelectEvt(component, event);
    },
    handleOnSelectPicklitEvt : function(component, event, helper){
        helper.handleOnSelectPicklitEvt(component, event);  
    },
    
})