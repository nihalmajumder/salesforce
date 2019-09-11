({
    handleClose: function() {
        //$A.get('e.force:refreshView').fire();
        console.log('handleClose');
        $A.get("e.force:closeQuickAction").fire();
    }
})