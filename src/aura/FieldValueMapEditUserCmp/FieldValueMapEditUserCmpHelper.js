({
    doInit : function(cmp, evt) {
        var recordId = cmp.get("v.recordId");
        if(recordId != null){
            var selectedRecord = cmp.get("v.selectedRecord");
            selectedRecord = {};
            selectedRecord.icon = 'standard:user';
            
            var action = cmp.get("c.getUserInfo");
            action.setParams({"recordId" : recordId});
            action.setCallback(this, function(response){
                var result = response.getReturnValue();
                result = JSON.parse(result);
                if(result.User__c != null || result.User__r != null){
                    selectedRecord.name = result.User__r.Name;
                    selectedRecord.Id = result.User__c;
                    cmp.set("v.selectedRecord", selectedRecord);
                }
                
            });
            $A.enqueueAction(action);
        }
    },
    handleSave : function(cmp, evt){
        var user = cmp.get("v.selectedRecord");
        var recordId = cmp.get("v.recordId");
        var fieldMapId = cmp.get("v.fieldMapId");
        var sobjectType = cmp.get("v.sobjectType");
        var userId = user != null ? user.id : null;
        
        var action = cmp.get("c.updateValueMap");
        action.setParams({"recordId" : recordId, "userId" : userId, "fieldMapId" : fieldMapId, "sobjectType" : sobjectType});
        action.setCallback(this, function(response){
            var cmpEvt = cmp.getEvent("onSuccessCmpEvt").fire();
            cmp.destroy();
        });
        
        $A.enqueueAction(action);
        
    },
    handleCancel : function(cmp, evt){
        var cmpEvt = cmp.getEvent("onSuccessCmpEvt").fire();
        evt.preventDefault()
        cmp.destroy();
    },
    
    handleLookupEvt : function(cmp, evt){
        console.log("handle lookup");
        var user = evt.getParam("record");
        cmp.set("v.selectedRecord", user);
    }
})