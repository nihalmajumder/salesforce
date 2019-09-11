({  
    doInit : function(cmp, evt){
        var record = cmp.get("v.record");
        this.getAllValues(cmp, record);
    },
    
    handleOnSuccessCmpEvt : function(cmp, evt){
        document.getElementById("field-mapping-edit-section").style.zIndex = "9001";
        var record = cmp.get("v.record");
        this.getAllValues(cmp, record);
    },
	    
    handleEdit : function(cmp, evt){
        var recordId = evt.target.dataset.recordid;
        
        $A.createComponent(
            "c:FieldMappingEditValueCmp", {
                "aura:id": "edit_mapping_value",
                "recordId": recordId
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
    
    handleDelete : function(cmp, evt){
        var recordId = evt.target.dataset.recordid;
        
        $A.createComponent(
            "c:FieldMappingDeleteValueCmp", {
                "aura:id": "delete_mapping_value",
                "recordId": recordId
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

    handleImport : function(cmp, evt){
        //create import component
        var record = cmp.get("v.record");
        var mapName = record.mapName;
        $A.createComponent(
            "c:FieldMappingImportValueCmp", {
                "aura:id": "import_mapping_values",
                "mapName": mapName
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
    
    getAllValues : function(cmp, record){
        var action = cmp.get("c.getValues");
        action.setParams({"mapName" : record.mapName });
        
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            cmp.set("v.mappings", JSON.parse(result));
        });
        
        $A.enqueueAction(action);
    },
    
    handleSearchValues : function(cmp, evt){
        var action = cmp.get("c.searchValues");
        var record = cmp.get("v.record");
        var value = cmp.find("mapping-value-edit").get("v.value");
        if(value.length >= 2){
            action.setParams({"input" : value, "mapName" : record.mapName, "ids" : JSON.stringify(record.ids) });
            
            action.setCallback(this, function(response){
                var result = response.getReturnValue();
                cmp.set("v.mappings", JSON.parse(result));
            });
            
            $A.enqueueAction(action);
        }else{
            this.getAllValues(cmp, record);
        }
    },
    
    handleCancel: function(cmp, evt) {
        evt.preventDefault()
        cmp.destroy();
    },
    
    handleAdd : function(cmp, evt){
        var helper = this;
        var action = cmp.get("c.addValue");
        var record = cmp.get("v.record");
        var input = cmp.find("mapping-value-add")
        var value = input.get("v.value");
        
        if(value.length > 0){
            input.setCustomValidity("");
        }else{
            input.setCustomValidity("Mapping Value cannot be blank");
        }
        
        input.reportValidity();
        
        if(input.get("v.validity").valid){            
            action.setParams({"mapName" : record.mapName, "value" : value});
            action.setCallback(this, function(response){	
                input.set("v.value", "");
                helper.getAllValues(cmp, record);
            });
            $A.enqueueAction(action);
        }
    },
})