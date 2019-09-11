({
//handles the initial object selection
    handleChangeObject : function(cmp, evt) {
        console.log('handleChangeObject()');
        var objectType = evt.getSource().get("v.value");
        
        if(objectType != "Geo_Location" && objectType != "Field_Value_Map"){
            var fieldsMap = cmp.get("v.fieldsMap");
            var selectedField = {};
            selectedField.fieldstring = objectType + '.';
            cmp.set("v.selectedField", selectedField);
            cmp.set("v.selectObject", objectType);
            cmp.set("v.fieldsMap", []);
            this.retrieveFields(cmp, objectType);
        }else{
            var selectedField = {};
            var label = objectType == "Geo_Location" ? "Geo Location" : "Field Value Map";
            selectedField.fieldstring = label;
            selectedField.fielddata = {
                'Label' : label, 
                'objectType' : '', 
                'fieldType' : 'ANYASSIGN',
                'fieldValue' : objectType
            };
            cmp.set("v.selectedField", selectedField);
            cmp.set("v.selectObject", objectType);
            cmp.set("v.fieldsMap", []);
            cmp.set("v.isReference", false);
        }
    },
    
     //builds the fields
    handleFieldChange : function(cmp, evt){
        console.log('handleFieldChange()');
        var sobject = cmp.get("v.selectObject");
        var fieldsMap = cmp.get("v.fieldsMap");
        var value = evt.getSource().get("v.value");
        var fieldContainer = cmp.get("v.fieldContainer");
        var field = _.find(fieldContainer, function(o) { return o.value == value });
        var fields = cmp.find("fields");
        var parentIdList = cmp.get("v.parentIdList");
        var selectedField = {};
        var referenceLabels = '';
        
        selectedField.fielddata = field;
        
        if( parentIdList.length >= fieldsMap.length ){ 
            var newList = [];
            newList = parentIdList[parentIdList.length - 1] // grab the latest parent;
            parentIdList = [];
            parentIdList = parentIdList.concat(newList);
        }
        
        //if the field selected is reference, then retrieve that reference fields values
        if(field.fieldType == 'REFERENCE'){
            _.forEach(fieldsMap, function(value, key){
                var sf = _.find(value, function(o) {return o.value == field.value });
                if(sf != null){
                    if(key < fieldsMap.length -1){
                        fieldsMap.length = key + 1;
                        return false;
                    }                    
                }
            });
            
            cmp.set("v.fieldsMap", fieldsMap);
            cmp.set("v.isReference", true);
            
            //do not retrieve any more fields if depth is more then 8 objects deep
            if(fieldsMap.length < 6){
                parentIdList.push(field.value);
                this.retrieveFields(cmp, field.sobjectType);
                cmp.set("v.parentIdList", parentIdList);
            }else{
                cmp.set("v.isReference", false);
            }
            
        }else{
            field = _.find(fieldContainer, function(o) { return o.value == value && o.sobjectType == field.sobjectType});
            
            if(parentIdList.length > 0){
                var fieldReferences = '';
                _.forEach(parentIdList, function(id, k){
                    _.forEach(fieldsMap, function(v, key){
                        var sobj = _.find(v, function(o) {return o.value == id });
                        if(sobj != null){
                            if(_.includes(sobj.fieldValue, '__c')){
                                var fieldValue = _.replace(sobj.fieldValue, '__c', '__r');
                                fieldReferences += fieldValue + '.';
                                referenceLabels += sobj.label + ' ';
                            }else{
                                fieldReferences += sobj.fieldValue + '.';
                                referenceLabels += sobj.label + ' ';
                            }
                        }
                    });
                });
                selectedField.fieldstring = sobject + ' > ' + referenceLabels + selectedField.fielddata.label;
                selectedField.fielddata.fieldValue = fieldReferences + selectedField.fielddata.fieldValue;
            }else{
                selectedField.fieldstring = selectedField.fielddata.label;
            }
            
            _.forEach(fieldsMap, function(v, key){
                var sf = _.find(v, function(o) {return o.value == value && o.sobjectType == field.sobjectType});
                if(sf != null){
                    if(key < fieldsMap.length -1){
                        fieldsMap.length = key + 1;
                        return false;
                    }
                }
            });
            
            cmp.set("v.fieldsMap", fieldsMap);
            cmp.set("v.isReference", false);
        }
        
        cmp.set("v.selectedField", selectedField);
    },
    
    //retrieves fields based on sobject type
    retrieveFields : function(cmp, sobjectType){
        console.log('retrieveFields()');
        var action = cmp.get("c.getFields");
        action.setParams({"sObjectType" : sobjectType});
        
        action.setCallback(this, function(response){
            var fieldsMap = cmp.get("v.fieldsMap");
            var fieldContainer = cmp.get("v.fieldContainer");
            var result = action.getReturnValue();
            if(fieldsMap.length == 0){
                fieldsMap = [];
            }
            fieldsMap.push(JSON.parse(result));
            fieldContainer = fieldContainer.concat(JSON.parse(result));
            cmp.set("v.fieldsMap", fieldsMap);
            cmp.set("v.fieldContainer", fieldContainer);
        });
        
        $A.enqueueAction(action);
    },
    
    handleCancel : function(cmp, evt){
        console.log('handleCancel()');
        evt.preventDefault()
        cmp.destroy();
    },
    
    handleFieldSelect : function(cmp, evt){
        console.log('handleFieldSelect()');
        var selectedField = cmp.get("v.selectedField");
        var cmpEvt = cmp.getEvent("fieldSelectEvt");
        console.log(selectedField.fielddata);
        cmpEvt.setParams({"fieldString" : selectedField.fieldstring, "fieldData" : selectedField.fielddata}).fire();
        this.handleCancel(cmp, evt);
    },
})