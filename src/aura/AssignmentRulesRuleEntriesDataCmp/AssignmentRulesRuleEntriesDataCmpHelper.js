({
    //creates edit modal with ligthtning data service
    handleEdit: function(cmp, evt) {
        var id = evt.target.dataset.record;
        
        $A.createComponent(
            "c:AssignmentRulesRuleEntryEditCmp", {
                "aura:id": "edit_rule",
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
    //creates delete modal with ligthtning data service
    handleDelete: function(cmp, evt) {
        var id = evt.target.dataset.record;
        
        $A.createComponent(
            "c:AssignmentRulesRuleEntryDeleteCmp", {
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
    //creates new modal with ligthtning data service
    hanldeNewRule: function(cmp, evt) {
        var sobjectType = evt.getParam("arguments").param1;
        
        $A.createComponent(
            "c:AssignmentRulesRuleEntryNewCmp", {
                "aura:id": "new_rule",
                "sobjectType": sobjectType
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
    //fires app event for rule selection that
    //bubbles to parent
    handleClick: function(cmp, evt){
        var id = evt.target.dataset.record;
        var appEvt = $A.get("e.c:OnRuleSelectEvt");
        var sobjectType = cmp.get("v.sobjectType");
        appEvt.setParams({"recordId" : id, "sobjectType" : sobjectType}).fire();
        
    },
    
})