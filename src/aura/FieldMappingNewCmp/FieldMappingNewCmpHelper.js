({
    //instantiates the new record to be created
    doInit: function(cmp, evt) {
        cmp.find("newRecordCreator").getNewRecord(
            "Field_Map__c",
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
    },
    //destroys this component
    handleCancel: function(cmp, evt) {
        evt.preventDefault()
        cmp.destroy();
    },
    //performs call to create record
    handleSave: function(cmp, evt) {
        var inputField = cmp.find("field");
        var allValid = cmp.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        
        if (allValid) {
            cmp.find("newRecordCreator").saveRecord($A.getCallback(function(saveResult) {
                // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful 
                // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    // handle component related logic in event handler
                    var appEvt = $A.get("e.c:OnSuccessEvt").fire();
                    cmp.destroy();
                } else if (saveResult.state === "INCOMPLETE") {
                    throw "User is offline, device doesn't support drafts.";
                } else if (saveResult.state === "ERROR") {
                    throw 'Problem saving record, error: ' + JSON.stringify(saveResult.error);
                } else {
                    throw 'Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error);
                }
            }));
        }
        
    },
    
})