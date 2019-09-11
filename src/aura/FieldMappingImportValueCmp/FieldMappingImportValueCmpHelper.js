({
    doInit : function(cmp, evt) {
        this.retrieveSObjects(cmp, evt);
    },

    handleCancel : function(cmp, evt){
        cmp.getEvent("onSuccessCmpEvt").fire();
        evt.preventDefault()
        cmp.destroy();
    },
    handleImport : function(cmp, evt){
        //create the new mappings, with the new values
        var selectedField = cmp.get("v.selectedField");
        var mapName = cmp.get("v.mapName");
        var selectedObject =cmp.get("v.selectedSObject");
        var action = cmp.get("c.createMappings");
  
        action.setParams({"mapName" : mapName, "objectStr" : selectedObject, "field" : selectedField});
        action.setCallback(this, function(response){
            //nothing returned
            cmp.getEvent("onSuccessCmpEvt").fire();
            evt.preventDefault()
            cmp.destroy();
        });
        $A.enqueueAction(action);
    },
    handleKeyUp : function(cmp, evt){
                //do lookup on client side
                var value = cmp.find("enter-search-sobjects").get("v.value");
                var displayed = cmp.get("v.sobjectsDisplayed");
                var master = cmp.get("v.sobjectsMaster");
                displayed = [];
                
                if(value.length >= 2){
                    document.getElementById("combobox-lookup-results").classList.add("slds-is-open");
                    document.getElementById("combobox-lookup-results").setAttribute("aria-expanded", true);
                    for(var i = 0; i < master.length; i++){
                        if(master[i].label.startsWith(value)){
                            displayed.push(master[i]);
                        }
                    }
                    cmp.set("v.sobjectsDisplayed", displayed);
                    
                }else{
                    cmp.set("v.picklistFields", []);
                    cmp.set("v.selectedField", null);
                    this.handleHideResults(cmp);
                }
    },
    handleCloseLookupList : function(cmp, evt){
        var selectedSObject = cmp.get("v.selectedSObject");
        //clear search if no record is selected
        if(selectedSObject == null){
            cmp.find("enter-search-sobjects").set("v.value", "");
        }
        this.handleHideResults(cmp);
    },

    handleClear : function(cmp, evt){
        var selectedSObject = cmp.get("v.selectedSObject");
        if(selectedSObject != null){
            cmp.set("v.selectedSObject", null);
        }
        cmp.set("v.picklistFields", []);
        cmp.set("v.selectedField", null);
        this.handleHideResults(cmp);
    },
    handleHideResults : function(cmp){
        document.getElementById("combobox-lookup-results").classList.remove("slds-is-open");
        document.getElementById("combobox-lookup-results").setAttribute("aria-expanded", false);
        cmp.set("v.sobjectsDisplayed", []);
    },
    handleResultClick : function(cmp, evt){
        var label = evt.target.dataset.recordlabel;
        var api = evt.target.dataset.recordapi;
        
        cmp.set("v.selectedSObject", api);
        cmp.find("enter-search-sobjects").set("v.value", label);
        this.retrievePickListFields(cmp, evt);
        this.handleHideResults(cmp);
    },
    retrieveSObjects : function(cmp, evt){
        var action = cmp.get("c.getAllSObjects");
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            result = JSON.parse(result);
            cmp.set("v.sobjectsMaster", result);
        });
        $A.enqueueAction(action);
    },
    retrievePickListFields : function(cmp, evt){
        //get a possible list of picklist fields, if there is only 1
        //then automatically select it
        var selectedSObject = cmp.get("v.selectedSObject");
        var action = cmp.get("c.getPickLists");
        action.setParams({"objectStr" : selectedSObject});
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            result = JSON.parse(result);
            console.log(result);
            cmp.set("v.picklistFields", result);
        });
        $A.enqueueAction(action);
    },
})