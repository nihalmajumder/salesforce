({
    //fires app event for object selection
    handleClick : function(cmp, evt) {
        var api = evt.target.dataset.api;
        var label = evt.target.dataset.label;
        var appEvt = $A.get("e.c:OnObjectSelectEvt");
        
        appEvt.setParams({"api" : api, "label" : label}).fire();
    },
    
})