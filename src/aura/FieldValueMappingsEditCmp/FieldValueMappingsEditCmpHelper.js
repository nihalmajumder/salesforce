({
    doInit : function(cmp, evt) {
        this.getFieldMappings(cmp, evt);
    },
    handleSearchValues : function(cmp, evt){
        var input = cmp.find("field-map-values-search").get("v.value");
        var mapValues = cmp.get("v.mapValues");
        var displayedMapValues = [];
        
        if(input.length >= 2){
            for(var i = 0; i < mapValues.length; i++){
                if( (mapValues[i].user != null && mapValues[i].user.Name.startsWith(input) ) || (mapValues[i].value != null && mapValues[i].value.startsWith(input)) )
                {
                    displayedMapValues.push(mapValues[i]);
                }
            }
            cmp.set("v.displayedMapValues", displayedMapValues);
        }else{
            cmp.set("v.displayedMapValues", mapValues);
        }
    },
    
    getFieldMappings : function(cmp, evt){
        var action = cmp.get("c.getFieldMappingValues");
        var mapName = cmp.get("v.mapName");
        var sobjectType = cmp.get("v.sobjectType");
        action.setParams({"mapName" : mapName, "sobjectType" : sobjectType});
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            result = JSON.parse(result);
            cmp.set("v.mapValues", result);
            cmp.set("v.displayedMapValues", result)
        });
        
        $A.enqueueAction(action);
    },
    handleCancel : function(cmp, evt){
        cmp.getEvent("onSuccessCmpEvt").fire();
        cmp.destroy();
    },
    handleEdit : function(cmp, evt){
        var recordId = evt.target.dataset.recordid;
        var sobjectType = cmp.get("v.sobjectType");
        var fieldMapId = evt.target.dataset.recordfieldmapid;
        if(recordId == "null") { recordId = null; } 
        $A.createComponent(
            "c:FieldValueMapEditUserCmp", {
                "aura:id": "edit_user_value_map",
                "recordId" : recordId,
                "sobjectType" : sobjectType,
                "fieldMapId" : fieldMapId
            },
            function(form, status, error) {
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(form);
                    cmp.set("v.body",form);
                    document.getElementById("field-value-map-list").style.zIndex = "9000";
                } else if (status === "INCOMPLETE") {
                    
                } else if (status === "ERROR") {
                    throw new Error(error);
                }
                
            });
    },
    handleSuccess : function(cmp, evt){
        document.getElementById("field-value-map-list").style.zIndex = "9001";
        this.getFieldMappings(cmp, evt);
    },
})