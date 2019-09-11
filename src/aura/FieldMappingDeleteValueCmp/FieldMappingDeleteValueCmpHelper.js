({
    //destroys this component
    handleCancel: function(cmp, evt) {
        evt.preventDefault()
        var cmpEvt = cmp.getEvent("onSuccessCmpEvt").fire();
        cmp.destroy();
    },
    //performs the lightning data service call to delete record
    handleDelete: function(cmp, evt) {
        cmp.find("recordHandler").deleteRecord($A.getCallback(function(saveResult) {
            // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful 
            // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // handle component related logic in event handler
                var cmpEvt = cmp.getEvent("onSuccessCmpEvt").fire();
                cmp.destroy();
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
        
        
    },
})