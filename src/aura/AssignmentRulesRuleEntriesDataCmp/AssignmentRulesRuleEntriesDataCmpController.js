({
	handleEdit : function(cmp, evt, helper) {
		helper.handleEdit(cmp, evt);
	},
	handleDelete : function(cmp, evt, helper){
		helper.handleDelete(cmp, evt);
	},
	hanldeNewRule : function(cmp, evt, helper){
		helper.hanldeNewRule(cmp, evt);
	},
	handleClick : function(cmp, evt, helper){
		evt.preventDefault();
		helper.handleClick(cmp, evt);
	},
})