/**
 * Created by ejc84332 on 2019-07-31.
 */

({
    handleClose: function() {
        //$A.get('e.force:refreshView').fire();
        console.log('handleClose');
        $A.get("e.force:closeQuickAction").fire();
    }
})