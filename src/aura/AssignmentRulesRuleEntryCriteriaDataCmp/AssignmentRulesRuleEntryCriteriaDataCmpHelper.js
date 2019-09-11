({
    updateOrder: function(cmp, sorted) {
        var rules = cmp.get("v.objects");
        console.log(rules);
        //sort the rules based on the sorted array of ids
        var sortedRules = _.sortBy(rules, function(rule) {
            rule.order = sorted.indexOf(rule.Id) + 1;
            return rule
        });
        
        cmp.set("v.objects", rules);
    },
    
    handleOnSave : function(cmp, evt) {
        this.fireOnLoadChangeEvt(cmp, evt, false);
        var entries = cmp.get("v.objects");
        var action = cmp.get("c.saveEntries");
        var rules = JSON.stringify(entries);
        action.setParams({
            "ruleEntries": rules
        });
        action.setCallback(this, function(response) {
            //rules = response.getReturnValue();
            this.fireOnLoadChangeEvt(cmp, evt, true);
        });
        $A.enqueueAction(action);
    },
    
    //fires event to handling loading notification 
    fireOnLoadChangeEvt : function(cmp, evt, doneLoading){
        var onLoadchangeEvent = cmp.getEvent("onLoadComplete");
        onLoadchangeEvent.setParams({"doneLoading" : doneLoading});
        onLoadchangeEvent.fire();
    },
    
    handleFireEvt: function(cmp, evt) {
        console.log('firing app event');
        var id = evt.target.dataset.record;
        var appEvt = $A.get("e.c:OnRuleEntryCriteriaNewAppEvt");
        appEvt.setParams({"label" : "Assignment Rule Entry - Edit", "recordId" : id});
        appEvt.fire();
    },
    
    handleDelete: function(cmp, evt) {
        var id = evt.target.dataset.record;
        
        $A.createComponent(
            "c:AssignmentRulesRuleEntryCriteriaDeleteCmp", {
                "aura:id": "delete_rule",
                "recordId": id
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