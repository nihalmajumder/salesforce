({
    //destroys this component
    handleCancel: function(cmp, evt) {
        evt.preventDefault()
        cmp.destroy();
    },
    //user hits delete, which will send a confirmation 
    //can't use lightning data service here, since this is a multi record delete operation
    handleDelete: function(cmp, evt) {
        var name = cmp.get("v.name");
        var data = {"operation" : "delete", "mapName" : name};
        var appEvt = $A.get("e.c:OnSuccessEvt").setParams({"data" : data}).fire();
        cmp.destroy();
    },
})