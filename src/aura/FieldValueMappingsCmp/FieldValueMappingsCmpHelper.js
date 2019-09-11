({
    doInit : function(cmp, evt) {
        this.getFieldMappings(cmp, evt);
    },
    handleSuccess : function(cmp, evt){
        document.getElementById("field-mapping-edit-section").style.zIndex = "9001";
        this.getFieldMappings(cmp, evt);
    },
    handleSearchValues : function(cmp, evt){
        var input = cmp.find("mapping-value-edit").get("v.value");
        if(input.length >= 2){
            var sobjectType = cmp.get("v.sobjectType");
            var action = cmp.get("c.searchFieldMappings");
            
            action.setParams({"input" : input, "sobjectType" : sobjectType});
            action.setCallback(this, function(response){
                var result = response.getReturnValue();
                result = JSON.parse(result);
                cmp.set("v.mappings", result);
            });
            
            $A.enqueueAction(action);
        }else{
            this.getFieldMappings(cmp, evt);
        }
    },
    getFieldMappings : function(cmp, evt){
        var sobjectType = cmp.get("v.sobjectType");
        var action = cmp.get("c.getFieldMappingsBySObjectType");
        
        action.setParams({"sobjectType" : sobjectType});
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            result = JSON.parse(result);
            cmp.set("v.mappings", result);
        });
        
        $A.enqueueAction(action);
    },
    
    handleEdit : function(cmp, evt){
        
        var sobjectType = cmp.get("v.sobjectType");
        var mapName = evt.target.dataset.recordname;
        
        $A.createComponent(
            "c:FieldValueMappingsEditCmp", {
                "aura:id": "edit_value_relations",
                "mapName" : mapName,
                "sobjectType" : sobjectType
            },
            function(form, status, error) {
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(form);
                    cmp.set("v.body",form);
                    document.getElementById("field-mapping-edit-section").style.zIndex = "9000";
                } else if (status === "INCOMPLETE") {
                    
                } else if (status === "ERROR") {
                    throw new Error(error);
                }
                
            });
    },
    
    handleAdd : function(cmp, evt){
        var sobjectType = cmp.get("v.sobjectType");
        var mapName = evt.target.dataset.recordname;
        
        var action = cmp.get("c.createNewMapValues");
        console.log(mapName);
        console.log(sobjectType);
        action.setParams({"mapName" : mapName, "sobjectType" : sobjectType});
    
        action.setCallback(this, function(response){
            //returns nothing
            this.getFieldMappings(cmp, evt);
        });
        
        $A.enqueueAction(action);
    },
    
    handleCancel: function(cmp, evt) {
        evt.preventDefault()
        cmp.destroy();
    },
    
})