({
    //handles which tab is active
    handleActive : function(cmp, evt) {
        this.fireOnLoadChangeEvt(cmp, evt, false);
        var action;
        if(cmp.find("sobject_table") != null){
            var table = cmp.find("sobject_table");
            if(table != null){ table.destroy(); }
        }
        
        var tab = evt.getSource();
        switch(tab.get("v.id")){
            case 'standard' : 
                action = cmp.get("c.retrieveStandardSObjects");
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var map = JSON.parse(response.getReturnValue());
                        this.createObjectTabDataCmp(map, tab);
                        this.fireOnLoadChangeEvt(cmp, evt, true);
                    }
                    else if (state === "INCOMPLETE") {
                        // do something
                    }
                        else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log("Error message: " + 
                                                errors[0].message);
                                }
                            } else {
                                console.log("Unknown error");
                            }
                        }
                });			
                break;
            case 'custom' : 
                action = cmp.get("c.retrieveCustomSObjects");
                
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var map = JSON.parse(response.getReturnValue());
                        this.createObjectTabDataCmp(map, tab);
                        this.fireOnLoadChangeEvt(cmp, evt, true);
                    }
                    else if (state === "INCOMPLETE") {
                        // do something
                    }
                        else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log("Error message: " + 
                                                errors[0].message);
                                }
                            } else {
                                console.log("Unknown error");
                            }
                        }
                });
                
                break;
        }
        $A.enqueueAction(action);
    },
    //call to create the tab that displays the objects to the user
    createObjectTabDataCmp : function(map, target){
        $A.createComponent(
            "c:AssignmentRulesObjectTabDataCmp",
            {
                "aura:id" : "sobject_table",
                "objects" : map
            }, function(table, status, error){
                if(status === "SUCCESS"){
                    target.set("v.body", table);
                }else if(status === "INCOMPLETE"){
                    
                }else if(status === "ERROR"){
                    throw new Error(error);
                }
                
            });
    },
    //generic loading function
    //used by all components to display loading spinner
    //bubbles up from children to main parent cmp
    fireOnLoadChangeEvt : function(cmp, evt, doneLoading){
        var onLoadchangeEvent = cmp.getEvent("onLoadComplete");
        onLoadchangeEvent.setParams({"doneLoading" : doneLoading});
        onLoadchangeEvent.fire();
    }
})