({
    doInit : function(cmp, evt){
        this.retrieveAllSObjects(cmp);
    },
    retrieveAllSObjects : function(cmp){
        var action = cmp.get("c.getAllSObjects");
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            result = JSON.parse(result);
            result = result.reverse();
            cmp.set("v.sobjectsMaster", result);
            cmp.set("v.sobjectsDisplayed", result);
        });
        $A.enqueueAction(action);
    },
    handleOnSuccessCmpEvt : function(cmp, evt){
        console.log("HERE");
        this.retrieveAllSObjects(cmp);
    },
    handleKeyUp : function(cmp, evt){
        //do lookup on client side
        var value = cmp.find("sobject-search").get("v.value");
        var displayed = cmp.get("v.sobjectsDisplayed");
        var master = cmp.get("v.sobjectsMaster");
        displayed = [];
        
        if(value.length >= 2){
            for(var i = 0; i < master.length; i++){
                if(master[i].label.startsWith(value)){
                    displayed.push(master[i]);
                }
            }
            cmp.set("v.sobjectsDisplayed", displayed);
            
        }else{
            cmp.set("v.sobjectsDisplayed", master);
        }
    },
    
    handleClick : function(cmp, evt){
        var apiName = evt.target.dataset.apiname;
        var label = evt.target.dataset.label;
        
        $A.createComponent(
            "c:FieldValueMappingsCmp", {
                "aura:id": "sobject_related_mappings",
                "sobjectType" : apiName,
                "sobjectLabel" : label
            },
            function(form, status, error) {
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(form);
                    cmp.set("v.body", body);
                } else if (status === "INCOMPLETE") {
                    
                } else if (status === "ERROR") {
                    throw new Error(error);
                }
                
            });
    },
    
})