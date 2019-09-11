({
    //logic is in helper class, call helper methods
    handleOpen : function(component, event, helper) {
        helper.handleOpen(component, event);
    },
    handleClose : function(component, event, helper) {
        helper.handleClose(component, event);
    },
    
    handleSearch : function(component, event, helper){
        helper.handleSearch(component, event);
    },
    
    handleRecordClick : function(component, event, helper){
        helper.handleRecordClick(component, event);
    },
    
    handleClear : function(component, event, helper){
        helper.handleClear(component, event);
    },

    handleCloseLookupList : function(component, event, helper){
        helper.handleCloseLookupList(component, event);
    },

    handleSObjectSelect : function(component, event, helper){
        helper.handleSObjectSelect(component, event);
    },
    
    handlelookupCmpValidCheckEvt : function(component, event, helper){
        helper.handlelookupCmpValidCheckEvt(component, event);
    },
    
    doValidate : function(component, event, helper){
        helper.doValidate(component, event);
    },
    
    doInit : function(component, event, helper){
        helper.handleInit(component, event);
    }
})