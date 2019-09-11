({
    afterRender : function(cmp, helper){
        this.superAfterRender();
        var j$ = jQuery.noConflict();
        j$("#sortable").sortable({
            
            stop: function(e, ui) { 
                var sorted = j$('#sortable').sortable('toArray');
                helper.updateOrder(cmp, sorted);
            }
        });
        j$("#sortable").disableSelection();
    },
})