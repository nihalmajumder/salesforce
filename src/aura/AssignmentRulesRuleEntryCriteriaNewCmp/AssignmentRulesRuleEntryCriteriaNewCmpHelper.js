({
   doInit: function(cmp, evt) {
        var recordId = cmp.get("v.recordId");
        if(recordId != null){
            this.getExistingEntry(cmp, evt, recordId);
        }else{
            this.createEmptyEntry(cmp);
        }
        this.retrieveOperators(cmp, evt);
    },
    
    createFieldSelectorCmp : function(cmp, evt){
        var index = evt.target.dataset.index;
        cmp.set("v.selectedFieldIndex", index);
        var sobjectType = cmp.get("v.sobjectType");
        var objects;
        //only allow index 1 to be any assign
        //have multiple conditions is too complicated right now
        if(index ==  0){
            objects = [
                {'label': sobjectType, 'value': sobjectType},
                {'label': 'Current User', 'value': 'User'},
                {'label' : 'GEO Location', 'value' : 'Geo_Location'},
                {'label' : 'Field Value Map', 'value' : 'Field_Value_Map'}
            ]
        }else{
            objects = [
                {'label': sobjectType, 'value': sobjectType},
                {'label': 'Current User', 'value': 'User'}
            ]
        }
        
        $A.createComponent(
            "c:FieldSelectorCmp",
            {
                "aura:id" : "field-selector",
                "objects" : objects
            }, function(content, status, error){
                if(status === "SUCCESS"){
                    cmp.set("v.body", content);
                }else if(status === "INCOMPLETE"){
                    
                }else if(status === "ERROR"){
                    throw new Error(error);
                }
            });      
    },
    
    //retrieves the existing rule entry if a record id is passed in
    getExistingEntry : function(cmp, evt, recordId){
        this.fireOnLoadChangeEvt(cmp, evt, false);
        var action = cmp.get("c.retrieveRuleEntry");
        action.setParams({"id" : recordId});
        action.setCallback(this, function(response){
            var result = response.getReturnValue(); 
            var entry = JSON.parse(result);
            var criteria = entry.criteria;
            if(criteria.length == 1 && criteria[0].dataType == "ANYASSIGN"){
                cmp.set("v.isAnyAssign", true);
            }
            if(entry.assignedToName != null && entry.assignedTo != null){
                var icon =  entry.assignedTo.startsWith("005") ? 'standard:user' : 'standard:queue';
                var type = entry.assignedTo.startsWith("005") ? 'User' : 'Group';
                var assignee = {"name" : entry.assignedToName, "Id" : entry.assignedTo, "icon" : icon, "type" : type};
                cmp.set("v.assignee", assignee);
            }
            
            cmp.set("v.doneLoading", true);
            entry.criteria = []; // removing existing criteria
            cmp.set("v.entry", entry);
            console.log(criteria);
            cmp.set("v.criteria", criteria);
            
            this.fireOnLoadChangeEvt(cmp, evt, true);
        });
        
        $A.enqueueAction(action);
    },
    
    //gets operators from controller
    retrieveOperators: function(cmp, evt) {
        var action = cmp.get("c.getOperators");
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            cmp.set("v.operators", JSON.parse(result));
        });
        
        $A.enqueueAction(action);
    },
    
    //creates empty rule entry objects
    createEmptyEntry: function(cmp) {
        var criteria = [{}, {}, {}, {}, {}];
        var entry = {};
        cmp.set("v.criteria", criteria);
        cmp.set("v.entry", entry);
        cmp.set("v.doneLoading", true);
    },
    
    
    
    //perform call to salesforce to save 
    doSave : function(cmp, entry){
        console.log(JSON.stringify(entry));
        var action = cmp.get("c.handleUpsertEntry");
        action.setParams({"entryJSON" : JSON.stringify(entry)});
        
        action.setCallback(this, function(response){
            var cmpEvt = cmp.getEvent("onSuccessRuleEntry");
            cmpEvt.fire();
            cmp.destroy();
        });
        
        $A.enqueueAction(action);
    },
    
    //fires event to handling loading notification 
    fireOnLoadChangeEvt: function(cmp, evt, doneLoading) {
        var onLoadchangeEvent = cmp.getEvent("onLoadComplete");
        onLoadchangeEvent.setParams({
            "doneLoading": doneLoading
        });
        onLoadchangeEvent.fire();
    },
    
    //destroys this component
    handleCancel: function(cmp, evt) {
        evt.preventDefault()
        cmp.destroy();
    },
    
    //adds a new empty object to our criteria fields row
    handleAddRow: function(cmp, evt) {
        var criteria = cmp.get("v.criteria");
        criteria.push({});
        cmp.set("v.criteria", criteria);
    },
    
    //rows a row from array for criteria fields
    handleRemoveRow: function(cmp, evt) {
        var criteria = cmp.get("v.criteria");
        criteria.pop();
        cmp.set("v.criteria", criteria);
    },
    
    //performs save
    handleSave: function(cmp, evt) {
        
        //do validation on any required fields
        var allValid = cmp.find('field').reduce(function(validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        if (allValid) {
            var assignmentRuleId = cmp.get("v.ruleId");
            var entry = cmp.get("v.entry");
            var criteria = cmp.get("v.criteria");
            var assignee = cmp.get("v.assignee");
            var criteriaToDeleteIds = cmp.get("v.criteriaToDeleteIds");
            if(assignee != null){
                entry.assignedTo = assignee.Id;
                entry.assignedToName = assignee.name;
            }
            entry.assignmenRuleId = assignmentRuleId;
            entry.sobjectType = cmp.get("v.sobjectType");
            entry.criteria = [];
            entry.deleteCriteria = [];
            
            for (var i = 0; i < criteria.length; i++) {
                if (Object.keys(criteria[i]).length != 0 && criteria[i].field != null && criteria[i].field != '') {
                    
                    var c = {
                        "field": criteria[i].field,
                        "operator": criteria[i].operator,
                        "value": criteria[i].value,
                        "position": i + 1,
                        "dataType" : criteria[i].dataType,
                        "sobjectType" : criteria[i].sobjectType,
                        "fieldLabel" : criteria[i].fieldLabel,
                    };
                    if(criteria[i].id != null){
                        c.id = criteria[i].id;
                    }
                    console.log(c);
                    entry.criteria.push(c);
                }else if(criteria[i].field == '' && criteria[i].id != null){
                    entry.deleteCriteria.push(criteria[i].id);
                }
            }
            
            if(criteriaToDeleteIds != null){
                entry.deleteCriteria =  entry.deleteCriteria.concat(criteriaToDeleteIds);
            }
            
            var filterLogic = cmp.find("filterLogic");
            var value = filterLogic.get("v.value");
            var subStrings = [];
            
            //validation for filter logic if needed
            if(value != null && value.length > 0){
                
                filterLogic.setCustomValidity("");
                var nums = [];
                var re = /\d+/g;
                var m;
                do {
                    m = re.exec(value);
                    if (m) {
                        nums.push(m[0]);
                        if(m[0] > entry.criteria.length){
                            filterLogic.setCustomValidity("The filter references an undefined filter: " + m[0]);
                            allValid = false;
                            break;
                        }
                    }
                } while (m);
                
                if (allValid) {
                    if(entry.criteria.length > nums.length){
                        filterLogic.setCustomValidity("The filter references missing.");
                        allValid = false;
                    }
                }
                
                if (allValid) {
                    if(value != null && value.length > 1){
                        if( value.indexOf("(") != -1 && value.indexOf(")") == -1 || value.indexOf(")") != -1 && value.indexOf("(") == -1){
                            filterLogic.setCustomValidity("Your missing a opening or closing parentheses.");
                            allValid = false;
                        }else if((value.indexOf('AND') != -1 && value.indexOf('OR') != -1) && value.indexOf("(") == -1 ){
                            filterLogic.setCustomValidity("Your filter must use parentheses around successive AND and OR expressions.");
                            allValid = false;
                        }else if((value.indexOf('AND') != -1 && value.indexOf('OR') != -1) && value.indexOf(")") == -1){
                            filterLogic.setCustomValidity("Your filter must use parentheses around successive AND and OR expressions.");
                            allValid = false;
                        }else if(value.endsWith('AND') || value.endsWith("OR")){
                            filterLogic.setCustomValidity("Check the spelling in your filter logic.");
                            allValid = false;
                        }
                    }
                }
                
                if (allValid) {
                    var re = /\(([^)]+)\)/g;
                    var m;
                    do {
                        m = re.exec(value);
                        if (m) {
                            if(m[1].indexOf('AND') != -1 &&  m[1].indexOf('OR') != -1){
                                filterLogic.setCustomValidity("Your filter must use parentheses around successive AND and OR expressions.");
                                allValid = false;
                                break;
                            }
                        }
                    } while (m);
                }
                
                filterLogic.reportValidity(); 
            }
            if (allValid) {
                this.doSave(cmp, entry);
            }
        }
    },
    
    handleOnSelectPicklitEvt : function(cmp, evt){      
        var criteria = cmp.get("v.criteria");
        var index = evt.getParam("data");
        var options = evt.getParam("options");
        
        criteria[index].value = options;
        cmp.set("v.criteria", criteria);
        
    },
    
    //set the assignee
    handleLookupEvt : function(cmp, evt){
        var record = evt.getParam("record");
        var assignee = {"name" : record.name, "Id" : record.id, "icon" : record.type.icon, "type" : record.type.api};
        cmp.set("v.assignee", assignee);
    },
    
    handleFieldSelectEvt : function(cmp, evt){
        var fieldData = evt.getParam("fieldData");
        var fieldString = evt.getParam("fieldString");
        var criteria = cmp.get("v.criteria");
        var index = cmp.get("v.selectedFieldIndex");
        var entry = cmp.get("v.entry");
        var criteriaToDeleteIds = cmp.get("v.criteriaToDeleteIds");
        
        if(fieldData.fieldType == "ANYASSIGN"){
            criteriaToDeleteIds = [];
            for(var i = 0; i < criteria.length; i++){
                if(criteria[i] != null && criteria[i].id != null){
                    criteriaToDeleteIds.push(criteria[i].id);
                }
            }
            criteria = [{}];
            cmp.set("v.isAnyAssign", true);
            //clear assignee
            cmp.set("v.assignee", {});
            entry.filterLogic = "";
            cmp.set("v.entry", entry);
            cmp.set("v.criteriaToDeleteIds", criteriaToDeleteIds);
        }else{
            cmp.set("v.isAnyAssign", false);
        }
        
        criteria[index].position = parseInt(index) + 1;
        criteria[index].field = fieldData.fieldValue;
        criteria[index].sobjectType = fieldData.sobjectType;
        criteria[index].fieldLabel = fieldString;
        criteria[index].dataType = fieldData.fieldType;
        
        //clear out operator and values if new field is selected
        
        criteria[index].operator = "";
        criteria[index].value = "";
        
        cmp.set("v.criteria", criteria);
    },
})