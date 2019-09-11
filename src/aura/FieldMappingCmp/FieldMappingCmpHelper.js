({
    doInit : function(cmp, evt) {
        this.getAllFieldMappings(cmp);
    },
    handleSuccess : function(cmp, evt){
        var result = evt.getParam("data");
        if(result != null && result.operation == "delete"){
            this.doDelete(cmp, result.mapName);
        }
        this.getAllFieldMappings(cmp);
    },
    getAllFieldMappings : function(cmp){
        var action = cmp.get("c.getFieldMappings");
        
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            cmp.set("v.mappings", JSON.parse(result));
        });
        
        $A.enqueueAction(action);
    },
    handleKeyUp : function(cmp, evt){
        var value = cmp.find("mapping-search").get("v.value");
        
        if(value.length >= 2){
            var action = cmp.get("c.searchFieldMappings");
            
            action.setParams({"input" : value});
            action.setCallback(this, function(response){
                var result = response.getReturnValue();
                cmp.set("v.mappings", JSON.parse(result));
            });
            $A.enqueueAction(action);
        }else{
            this.getAllFieldMappings(cmp);
        }
    },
    
    doDelete : function(cmp, mapName){
        var action = cmp.get("c.deleteRecords");

        action.setParams({"mapName" : mapName });
        action.setCallback(this, function(response){
            //no results returned
        });
        $A.enqueueAction(action);
    },
    //creates edit modal with ligthtning data service
    handleEdit: function(cmp, evt) {
        var mapName = evt.target.dataset.mapname;
        var mappings = cmp.get("v.mappings");
        var obj = {}; // js object, contains name of mapping and ids associated to all mappings with that name
        
        for(var i = 0; i < mappings.length; i++){
            if(mappings[i].name == mapName){
                obj.mapName = mappings[i].name;
                obj.ids = [];
                for(var x = 0; x < mappings[i].fieldMaps.length; x++){
                    obj.ids.push(mappings[i].fieldMaps[x].Id);
                }
                break;
            }
        }
        
        $A.createComponent(
            "c:FieldMappingEditCmp", {
                "aura:id": "edit_mapping",
                "record" : obj
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
        var mapname = evt.target.dataset.mapname;
        
        $A.createComponent(
            "c:FieldValueMapMappingsDeleteCmp", {
                "aura:id": "delete_mapping",
                "name": mapname
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
    handleNew: function(cmp, evt) {
        
        $A.createComponent(
            "c:FieldMappingNewCmp", {
                "aura:id": "new_mapping"
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