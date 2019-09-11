({
    //calls salesforce to retrieve rule entries
    //then creates the component that holds the rule entries
    doInit : function(cmp, evt){
        var recordId = cmp.get("v.selectedRuleId");
        var action = cmp.get("c.retrieveAssignmentRuleEntries");
        var entryCriteriaCmp = cmp.find("entry-criteria");
        if(entryCriteriaCmp  != null){
            entryCriteriaCmp.destroy();
        }
        this.fireOnLoadChangeEvt(cmp, evt, false);
        action.setParams({"ruleId" : recordId});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var ruleEntries = JSON.parse(response.getReturnValue());
                this.createRuleEntryCriteriaDataCmp(cmp, ruleEntries);
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
    
    //fires event to create new/edit modal for rule entries
    handleFireEvt : function(cmp, evt){
        var cmpEvt = cmp.getEvent("onRuleEntryCritieraNew");
        cmpEvt.setParams({"label" : "Assignment Rule Entry - New"});
        cmpEvt.fire();
    },
    
    //handles event to create new/edit modal for rule entries
    //creates the modal
    handleEvt : function(cmp, evt) {
        var sobjectType = cmp.get("v.sobjectType");
        var ruleId = cmp.get("v.selectedRuleId");
        var label = evt.getParam("label");
        var recordId = evt.getParam("recordId");
        
        $A.createComponent(
            "c:AssignmentRulesRuleEntryCriteriaNewCmp", {
                "aura:id": "new_rule_entry",
                "sobjectType": sobjectType,
                "ruleId" : ruleId,
                "label" : label,
                "recordId" : recordId
            },
            function(form, status, error) {
                console.log(status);
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(form);
                    cmp.set("v.body", form);
                } else if (status === "INCOMPLETE") {
                    
                } else if (status === "ERROR") {
                    throw new Error(error);
                }
                
            });
    },
    
    //creates the assignment rule entrie data component
    createRuleEntryCriteriaDataCmp : function(cmp, ruleEntries){
        var target = cmp.find("criteria-data");
        $A.createComponent(
            "c:AssignmentRulesRuleEntryCriteriaDataCmp",
            {
                "aura:id": "entry-criteria",
                "objects" : ruleEntries
            }, function(table, status, error){
                if(status === "SUCCESS"){
                    target.set("v.body", table);
                }else if(status === "INCOMPLETE"){
                    
                }else if(status === "ERROR"){
                    throw new Error(error);
                }
                
            });
    },
    
    //handles the save of the rules, used to save the new rearrange order of rules
    handleSave : function(cmp, evt){
        var appEvt = $A.get("e.c:OnSaveRuleEntriesEvt");
        appEvt.fire();
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