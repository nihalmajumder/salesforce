({
    doInit : function(component, event, helper){
        helper.doInit(component, event);
    },
    handleKeyUp : function(component, event, helper) {
        helper.handleKeyUp(component, event);
    },
    handleCancel: function(cmp, evt, helper) {
        helper.handleCancel(cmp, evt);
    },
    handleLookupEvt : function(component, event, helper){
        helper.handleLookupEvt(component, event);
    },
    
    handleKeyUpEmail : function(component, event, helper){
        helper.handleKeyUpEmail(component, event);
    },
    
    handleSelectEmail : function(component, event, helper){
        event.stopPropagation()
        helper.handleSelectEmail(component, event);
    },
    
    handleAddRow : function(component, event, helper){
        helper.handleAddRow(component, event);
    },
    
    handleRemoveRow : function(component, event, helper){
        helper.handleRemoveRow(component, event);
    },
    handleSave : function(component, event, helper){
        helper.handleSave(component, event);
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