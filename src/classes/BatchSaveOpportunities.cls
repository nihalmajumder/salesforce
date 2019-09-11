/**
 * Created by ejc84332 on 9/10/19.
 */

// Test: OpportunityHelperTest

public class BatchSaveOpportunities implements Database.Batchable<sObject> {

    public List <Opportunity> oppsToSave = new List<Opportunity>();

    public BatchSaveOpportunities(List<Opportunity> oppsToSaveInput){
        oppsToSave = oppsToSaveInput;
    }

    public List<Opportunity> start(Database.BatchableContext context) {
        return oppsToSave;
    }
    public void execute(Database.BatchableContext bc, List<Opportunity> opps) {

        update opps;

    }
    public void finish(Database.BatchableContext bc) {

    }
}