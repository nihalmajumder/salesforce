({
    doInit : function(cmp, evt) {
        this.createApplicationSelectionCmp(cmp);
        window.location.hash = "home";
        cmp.set("v.previousHash", "#home");
    },
    
    //handles the rule select event
    //replaces screen1 wiwth screen2
    handleRuleSelect : function(cmp, evt){
        var hash = cmp.get("v.hash");
        var ruleId = evt.getParam("recordId");
        var sobjectType = evt.getParam("sobjectType");
        this.createAssignmentRuleScreen2(cmp, ruleId, sobjectType);
        
        window.location.hash = "Assignment Rules Screen 2"
        cmp.set("v.previousHash", hash)
        cmp.set("v.hash",  window.location.hash);
    },
    
    //call to create screen 2 for assignment rules
    //required as inputs are unique
    createAssignmentRuleScreen2 : function(cmp, ruleId, sobjectType){
        
        $A.createComponent(
            "c:AssignmentRulesScreen2Cmp",
            {
                "ruleId" : ruleId,
                "sobjectType" : sobjectType,
                "aura:id" : "screen2",
            }, function(content, status, error){
                if(status === "SUCCESS"){
                    cmp.set("v.body", content);
                }else if(status === "INCOMPLETE"){
                    
                }else if(status === "ERROR"){
                    throw new Error(error);
                }
            });      
    },
    
    handleAppSelectEvt : function(cmp, evt){
        var appDetails = cmp.get("v.appDetails");
        var cmpName = evt.getParam("cmpName");
        var auraId = evt.getParam("auraId");
        var appName = evt.getParam("appName");
        var hash = cmp.get("v.hash");
        
        appDetails = {};
        appDetails.cmpName = cmpName;
        appDetails.auraId = auraId;
        appDetails.appName = appName;
        
        window.location.hash = appDetails.appName;
        cmp.set("v.hash",  window.location.hash);
        cmp.set("v.previousHash", hash);
        
        if(cmp.find("app-select-cmp") != null){
            cmp.find("app-select-cmp").destroy();
        }
        cmp.set("v.appDetails", appDetails);
        
        this.createApplicationCmp(cmp, evt);
        
    },
    handleQuit : function(cmp, evt){
        window.location.href = '/home/home.jsp';
    },
    handlePrevious : function(cmp, evt){
        var previousHash = cmp.get("v.previousHash");
        var hash = cmp.get("v.hash");
        
        if(previousHash == '#home' || hash == '#Assignment%20Rules'){     
            window.location.hash = "home";
            this.createApplicationSelectionCmp(cmp);
            cmp.set("v.appName", "Application Selection");
            cmp.set("v.hash", "#home");
        }else{
            this.createApplicationCmp(cmp);
            window.location.hash = previousHash;
            cmp.set("v.hash",  previousHash);
        }
    },
    createApplicationSelectionCmp : function (cmp){
        
        $A.createComponent(
            "c:ApplicationSelectorCmp",
            {
                "aura:id" : "app-select-cmp",
            }, function(content, status, error){
                if(status === "SUCCESS"){
                    cmp.set("v.body", content);
                    cmp.set("v.doneLoading", true);
                }else if(status === "INCOMPLETE"){
                    
                }else if(status === "ERROR"){
                    throw new Error(error);
                }
            });      
    },
    
    createApplicationCmp : function(cmp){
        var appDetails = cmp.get("v.appDetails");
        $A.createComponent(
            appDetails.cmpName,
            {
                "aura:id" : appDetails.auraId,
            }, function(content, status, error){
                if(status === "SUCCESS"){
                    cmp.set("v.body", content);
                    cmp.set("v.appName", appDetails.appName);
                }else if(status === "INCOMPLETE"){
                    
                }else if(status === "ERROR"){
                    throw new Error(error);
                }
            });    
    },
})