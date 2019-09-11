({
    //set the first item in the sobject array as the default selected
    handleInit : function(cmp, evt){
        var sobjects = cmp.get("v.sobjects");
        var selectedRecord = cmp.get("v.selectedRecord");
        if(selectedRecord != null){
            for(var i = 0; i < sobjects.length; i++){
                if(sobjects[i].api == selectedRecord.type){
                    sobjects[i].selected = true;
                    cmp.set("v.selectedSObject", sobjects[i]);
                }else{
                    sobjects[i].selected = false;
                }
            }
        }else{
            cmp.set("v.selectedSObject", sobjects[0]);
        }
    },
    
    doValidate : function(cmp, evt){
        var input = cmp.find("combobox-lookup-search");
        var validity = input.get("v.validity");
        
        if(!validity.valid){
            input.setCustomValidity("Lookup cannot be blank");
             inputCmp.reportValidity();
        }else{
            input.setCustomValidity("");
             inputCmp.reportValidity();
        }
        
    },
    
    //opens the sobject select combobox
    handleOpen : function(cmp, evt) {
        document.getElementById("combobox-related").classList.add("slds-is-open");
        document.getElementById("combobox-related").setAttribute("aria-expanded", true);
    },
    
    //hides / closes the sobject select combo box
    handleClose : function(cmp, evt) {
        document.getElementById("combobox-related").classList.remove("slds-is-open");
        document.getElementById("combobox-related").setAttribute("aria-expanded", false);
        this.handleClear(cmp, evt);
    },
    
    handleCloseLookupList : function(cmp, evt) {
        var selectedRecord = cmp.get("v.selectedRecord");
        //clear search if no record is selected
        if(selectedRecord == null){
            cmp.find("combobox-lookup-search").set("v.value", "");
        }
        this.handleHideLookupCombobox();
    },
    
    //handles the lookup input
    //takes the value from the input element, must be more then 2+ characters, then calls to salesforce
    //to perform soql query based on input and other filters defined in json 
    handleSearch : function(cmp, evt){
        var val = cmp.find("combobox-lookup-search").get("v.value");
        //only do lookup for more then 2 characters searched
        if(val.length >= 2 &&  !document.getElementById("combobox-lookup-container").classList.contains("slds-has-selection")){
            var action = cmp.get("c.runLookup");
            var selectedSObject = cmp.get("v.selectedSObject");
            selectedSObject.input = val;
            action.setParams({"input" : JSON.stringify(selectedSObject)});
            action.setCallback(this, function(response){
                var results = response.getReturnValue();
                if(JSON.parse(results).length > 0){
                    var obj = JSON.parse(results);
                    cmp.set("v.sobjectRecords", obj);
                    document.getElementById("combobox-lookup-results").classList.add("slds-is-open");
                    document.getElementById("combobox-lookup-results").setAttribute("aria-expanded", true);
                }
            });
            $A.enqueueAction(action);
        }else{
            this.handleHideLookupCombobox();
        }
    },
    
    //handles click action of the record
    //stores the name and id of the selected record in
    //a attribute. 
    handleRecordClick : function(cmp, evt){
        evt.preventDefault();
        var recordName = evt.target.dataset.recordname;
        var recordId = evt.target.dataset.recordid;
        var selectedRecord = cmp.get("v.selectedRecord");
        
        selectedRecord = {};
        selectedRecord.name = recordName;
        selectedRecord.id = recordId;
        selectedRecord.type = cmp.get("v.selectedSObject");
   
        
        document.getElementById("combobox-lookup-container").classList.add("slds-has-selection");
        cmp.find("combobox-lookup-search").set("v.value", recordName);
        cmp.set("v.selectedRecord", selectedRecord);
        this.handleHideLookupCombobox();
        
        var cmpEvt = cmp.getEvent("lookupEvt");
        cmpEvt.setParams({"record" : selectedRecord}).fire();
    },
    
    //handles hiding combobox
    handleHideLookupCombobox : function(){
        document.getElementById("combobox-lookup-results").classList.remove("slds-is-open");
        document.getElementById("combobox-lookup-results").setAttribute("aria-expanded", false);
    },
    
    //clears out the input, when the x is clicked
    handleClear : function(cmp, evt){
        cmp.set("v.selectedRecord", null);
        document.getElementById("combobox-lookup-container").classList.remove("slds-has-selection");
        cmp.find("combobox-lookup-search").set("v.value", "");
    },
    
    handleSObjectSelect : function(cmp, evt){
        var sobjects = cmp.get("v.sobjects");
        var sobjectName = evt.target.dataset.objname;
        var selectedSObject = {};
        for(var i = 0; i < sobjects.length; i++){
            if(sobjects[i].name == sobjectName){
                sobjects[i].selected = true;
                selectedSObject =  sobjects[i];
            }else{
                sobjects[i].selected = false;
            }
        }
        cmp.set("v.selectedSObject", selectedSObject);
        cmp.set("v.sobjects", sobjects);
    }
    
})