trigger INT_OpportunityTrigger on Opportunity (before update, after insert) {
    // ejc84332: We decided we don't really need OpportunityContactRole's, so we are just skipping this.
    // TDTM triggers are run via TDTM_Opportunity.

	// INT_OpportunityContactRoleHandler h = new INT_OpportunityContactRoleHandler();
    // h.run(Trigger.new, Trigger.old);
}