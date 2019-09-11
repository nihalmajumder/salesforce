({
	doInit : function(component, event, helper) {
		helper.doInit(component, event);
	},
    handleClick : function(component, event, helper){
        event.preventDefault();
        helper.fireAppSelectEvt(component, event);
    }
})