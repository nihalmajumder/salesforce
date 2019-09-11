({
    //instantiates the new record to be created
    doInit: function(cmp, evt) {
        cmp.find("newRecordCreator").getNewRecord(
            "Assignment_Rule__c",
            null,
            false,
            $A.getCallback(function() {
                var rec = cmp.get("v.newRecord");
                var error = cmp.get("v.recordErrors");
                if (error || (rec == null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }
                console.log("Record template initialized: " + rec.sobjectType);
            })
        );
        var criteria = [{}]; //create 1 empty rule criteria
        cmp.set("v.criteria", criteria);
        this.retrieveOperators(cmp, evt);
    },
    //destroys this component
    handleCancel: function(cmp, evt) {
        evt.preventDefault()
        cmp.destroy();
    },
    //performs call to create record
    handleSave: function(cmp, evt) {
        var helper = this;
        var criteria = cmp.get("v.criteria");
        var allValid;
        var input = cmp.find("field");
        
        if(Array.isArray(input)){
            console.log(cmp.get("v.simpleRecord.Has_Run_Criteria__c"));
            allValid = cmp.find('field').reduce(function(validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
        }else{
            allValid = input.get("v.validity").valid;
            if(input.get("v.value") == null || input.get("v.value").length == 0){
                input.setCustomValidity("Name cannot be blank");
                input.reportValidity();
            }else{
                input.setCustomValidity("");
                input.reportValidity();
            }
        }

        if(allValid){
            
            cmp.set("v.simpleRecord.sObject__c", cmp.get("v.sobjectType"));
            cmp.find("newRecordCreator").saveRecord($A.getCallback(function(saveResult) {
                // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful 
                // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    var recordId = saveResult.recordId;
                    if(criteria != null && cmp.get("v.simpleRecord.Has_Run_Criteria__c") != null && cmp.get("v.simpleRecord.Has_Run_Criteria__c") == true){
                        helper.createRuleEntryCriteria(cmp, criteria, recordId);
                    }else{
                        // handle component related logic in event handler
                        var cmpEvt = cmp.getEvent("onSuccessRuleEntry");
                        cmpEvt.fire();
                    }
                } else if (saveResult.state === "INCOMPLETE") {
                    console.log("User is offline, device doesn't support drafts.");
                } else if (saveResult.state === "ERROR") {
                    console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                }
            }));
            
        }
    },
    
    createRuleEntryCriteria : function(cmp, criteria, ruleId){
        var action = cmp.get("c.createRuleEntry");
        var json = JSON.stringify(criteria[0]);
        action.setParams({"entryJSON" : json, "ruleId" : ruleId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server: " + response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
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
            var cmpEvt = cmp.getEvent("onSuccessRuleEntry");
            cmpEvt.fire();
        });
        $A.enqueueAction(action);
    },
    
    createFieldSelectorCmp : function(cmp, evt){
        var index = evt.target.dataset.index;
        cmp.set("v.selectedFieldIndex", index);
        var sobjectType = cmp.get("v.sobjectType");
        var objects;
        //only allow index 1 to be any assign
        //have multiple conditions is too complicated right now
        objects = [
            {'label': sobjectType, 'value': sobjectType},
            {'label': 'Current User', 'value': 'User'}
        ];
        
        
        $A.createComponent(
            "c:FieldSelectorCmp",
            {
                "aura:id" : "field-selector",
                "objects" : objects,
                "depth" : 1
            }, function(content, status, error){
                if(status === "SUCCESS"){
                    cmp.set("v.body", content);
                }else if(status === "INCOMPLETE"){
                    
                }else if(status === "ERROR"){
                    throw new Error(error);
                }
            });      
    },
    
    
    handleFieldSelectEvt : function(cmp, evt){
        var fieldData = evt.getParam("fieldData");
        var fieldString = evt.getParam("fieldString");
        var criteria = cmp.get("v.criteria");
        var index = cmp.get("v.selectedFieldIndex");
        var entry = cmp.get("v.entry");
        
        criteria[index].position = parseInt(index) + 1;
        criteria[index].field = fieldData.fieldValue;
        criteria[index].sobjectType = fieldData.sobjectType;
        criteria[index].fieldLabel = fieldString;
        criteria[index].dataType = fieldData.fieldType;
        
        //clear out operator and values if new field is selected
        criteria[index].operator = "";
        criteria[index].value = "";
        
        cmp.set("v.criteria", criteria);
    },
    
    handleOnSelectPicklitEvt : function(cmp, evt){      
        var criteria = cmp.get("v.criteria");
        var index = evt.getParam("data");
        var options = evt.getParam("options");
        criteria[index].value = options;
        cmp.set("v.criteria", criteria);
    },
    
    //gets operators from controller
    retrieveOperators : function(cmp, evt) {
        var action = cmp.get("c.getOperators");
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            cmp.set("v.operators", JSON.parse(result));
        });
        
        $A.enqueueAction(action);
    },
    
})