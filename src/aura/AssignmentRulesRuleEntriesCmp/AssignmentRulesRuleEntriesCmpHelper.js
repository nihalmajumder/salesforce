({
    //when an object is selected,
    //this will create and/or destroy the table, if it exists
    handleOnObjectSelect: function(cmp, evt) {
        
        if (cmp.find("entries-data") != null) {
            //destory current able if it exists, and recreate it
            var table = cmp.find("entries-data");
            table.destroy();
        }
        
        var api;
        var label;
        
        if(evt.getParam("api") != null){
            api = evt.getParam("api")
            cmp.set("v.sobject_api", api);
        }else{
            api = cmp.get("v.sobject_api");
        }
        
        if(evt.getParam("label") != null){
            label = evt.getParam("label");
            cmp.set("v.sobject_label", label);
        }else{
            label = cmp.get("v.sobject_label");
        }
        
        this.fireOnLoadChangeEvt(cmp, evt, false);
        
        var action = cmp.get("c.retrieveAssignmentRules");
        
        action.setParams({
            "sobjectType": api
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var entries = response.getReturnValue();
                this.createRuleEntriesDataCmp(cmp, entries)
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
        
        $A.enqueueAction(action);
    },
    
    //creates the component that displays the rules 
    createRuleEntriesDataCmp: function(cmp, entries) {
        var target = cmp.find("rule_entries_card");
        var sobjectType = cmp.get("v.sobject_api");
        $A.createComponent(
            "c:AssignmentRulesRuleEntriesDataCmp", {
                "entries": entries,
                "sobjectType" : sobjectType,
                "aura:id": "entries-data"
            },
            function(content, status, error) {
                if (status === "SUCCESS") {
                    target.set("v.body", content);
                } else if (status === "INCOMPLETE") {
                    
                } else if (status === "ERROR") {
                    throw new Error(error);
                }
            }
        );
    },
    
    //fires method from child to display new model
    handleNew : function(cmp, evt){
        var childCmp = cmp.find("entries-data");
        var sobjectType = cmp.get("v.sobject_api");
        childCmp.newRule(sobjectType);
    },
    
    //fires event to handling loading notification 
    fireOnLoadChangeEvt: function(cmp, evt, doneLoading) {
        var onLoadchangeEvent = cmp.getEvent("onLoadComplete");
        onLoadchangeEvent.setParams({
            "doneLoading": doneLoading
        });
        onLoadchangeEvent.fire();
    }
})