({
	doInit : function(cmp, evt) {
		var action = cmp.get("c.getApps");
        
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            cmp.set("v.apps", result);
        });
        
        $A.enqueueAction(action);
    },
    
    fireAppSelectEvt : function(cmp, evt){
        var applabel = evt.target.dataset.applabel;
        var cmpName = evt.target.dataset.cmpname;
        var auraId = evt.target.dataset.auraid;        
        var cmpEvt = cmp.getEvent("onAppSelectEvt");
        cmpEvt.setParams({"appName" : applabel, "cmpName": cmpName, "auraId" : auraId}).fire();
        
    }
})