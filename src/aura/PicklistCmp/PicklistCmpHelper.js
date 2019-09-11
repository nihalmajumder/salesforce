({
    doInit : function(cmp, evt){
        var action = cmp.get("c.getPicklistValues");
        var field = cmp.get("v.field");
        var sobjectType =  cmp.get("v.sobjectType");
        var selectedValues = cmp.get("v.selectedValues");
        var multi = cmp.get("v.multi");

        action.setParams({"field" : field, "sobjectType" : sobjectType});
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            result = JSON.parse(result);
            var optionsSelected = [];
            if(selectedValues != null){
                var values = selectedValues.trim().split(";");
                for(var i = 0; i < result.length; i++){
                    if(values.indexOf(result[i].value) > -1){
                        result[i].checked = true;
                        optionsSelected.push(result[i].value);
                    }
                }
            }
            if(multi && optionsSelected != null){
                cmp.find("select-combobox").set("v.value",  optionsSelected.length + " Options Selected");            
            }else if(!multi && optionsSelected != null){
                cmp.find("select-combobox").set("v.value",  optionsSelected[0]); 
            }
            cmp.set("v.optionsSelected", optionsSelected);
            cmp.set("v.picklistValues", result);
        });
        $A.enqueueAction(action);
    },
    handleShowOptions : function(cmp, evt) {
        var id = cmp.get("v.id");
        document.getElementById(id).classList.add("slds-is-open");
    },
    handleHideOptions : function(cmp, evt){
        var id = cmp.get("v.id");
        document.getElementById(id).classList.remove("slds-is-open");
    },
    handleSelectOption : function(cmp, evt){
        var option = evt.target.dataset.selectedoption;
        var helper = this;
        this.handleUpdatePickListValueMap(cmp, evt, helper, option);
    },
    handleUpdatePickListValueMap : function(cmp, evt, helper, option){
        var picklistValues = cmp.get("v.picklistValues");
        var optionsSelected = cmp.get("v.optionsSelected");
        var multi = cmp.get("v.multi");
        if(optionsSelected == null){
            optionsSelected = [];
        }
        
        for(var i = 0; i< picklistValues.length; i++){
            if(multi){
                //select more then 1 option
                if(picklistValues[i].value == option){
                    //if the value is checked, and clicked again, uncheck it
                    if(picklistValues[i].checked){
                        picklistValues[i].checked = false;
                        if(optionsSelected.indexOf(option) != -1){
                            var index = optionsSelected.indexOf(option);
                            optionsSelected.splice(index, 1);
                            if(optionsSelected.length == 0){
                                optionsSelected = null;
                            }
                        }
                    }else{
                        picklistValues[i].checked = true;
                        optionsSelected.push(option);                    
                    }
                    break;
                }
            }else{
                
                //only select one option, everything else is false
                if(picklistValues[i].value == option){
                    //if the value is checked, and clicked again, uncheck it
                    if(picklistValues[i].checked){
                        picklistValues[i].checked = false;
                    }else{
                        //create a new array, this should only get called once
                        optionsSelected = [];
                        picklistValues[i].checked = true;
                        optionsSelected.push(option);     
                    }
                }else{
                    picklistValues[i].checked = false;
                }
            }
        }
        
        if(multi && optionsSelected != null){
            cmp.find("select-combobox").set("v.value",  optionsSelected.length + " Options Selected");            
        }else if(!multi && optionsSelected != null){
            cmp.find("select-combobox").set("v.value",  optionsSelected[0]); 
        }else if(optionsSelected == null){
            cmp.find("select-combobox").set("v.value",  ""); 
        }
        cmp.set("v.optionSelect", optionsSelected);
        cmp.set("v.picklistValues", picklistValues);
        helper.fireOnPicklistEvent(cmp, evt, optionsSelected);
        
    },
    
    fireOnPicklistEvent : function(cmp, evt, options){
        var field = cmp.get("v.field");
        var data = cmp.get("v.data");
        options = options.join(";");
        var cmpEvt = cmp.getEvent("onSelectPickListEvt");
        cmpEvt.setParams({"options" : options, "field" : field, "data" : data}).fire();
    },
})