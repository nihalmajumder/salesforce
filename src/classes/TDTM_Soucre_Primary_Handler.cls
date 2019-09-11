/**
 * Created by ejc84332 on 2019-02-05.
 */

global class TDTM_Soucre_Primary_Handler extends TDTMVirtualTriggerHandler {


    global override void onAfterInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        // grab the objects so we can do updates. Only grab the ones that don't have a source number. It should be all new sources
        // unless a source number was manually entered to override the default.
        System.debug('starting onAfterInsert');
        Set<Id> opp_ids = new Set<Id>();
        Interaction__c[] update_interactions = new List<Interaction__c>();

        // Get a non read-only version of the interactions
        Interaction__c[] new_interactions = [SELECT Id, Name, Marketing_Interaction__c, Opportunity__c, Source_Number__c FROM Interaction__c WHERE Id IN :newList];

        for (Interaction__c interaction : new_interactions) {
            System.debug('marketing interaction');
            System.debug(interaction.Marketing_Interaction__c);
            System.debug(interaction.Source_Number__c);

            // Process this if it is a marketing interaction
            if(interaction.Marketing_Interaction__c){

                // if it is a marketing interaction we are going to recalculate the opportunity rollup, if it has an opportunity
                if(interaction.Opportunity__c != null){
                    opp_ids.add(interaction.Opportunity__c);
                }

                // if the Source Number came in blank, calculate it using the Name
                if(interaction.Source_Number__c == null){
                    interaction.Source_Number__c = Integer.valueof(interaction.Name.split('-')[1]);
                    update_interactions.add(interaction);
                }
            }
        }
        if(update_interactions.size() > 0){
            update update_interactions;
        }
        if(opp_ids.size() > 0){
            updateRollUps(opp_ids);
        }
    }

    global override void onBeforeUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        System.debug('starting onBeforeUpdate');
        for (Interaction__c src : (List<Interaction__c>) newList) {

            if (src.Source_Number__c == null && src.Marketing_Interaction__c) {
                if (src.Marketing_Interaction__c) {
                    src.Source_Number__c = Integer.valueof(src.Name.split('-')[1]);
                }
            }
        }
    }


    // After the Interaction has been updated, recacluate primary source number on Opportunity if it has changed
    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {


        // DO THIS HERE OR NOT?
        System.debug('Starting onAfterUpdate');
        Set<Id> opp_ids = new Set<Id>();
        for (SObject o : newList) {
            Interaction__c interaction = (Interaction__c) o;
            Interaction__c oldInteraction = (Interaction__c) oldMap.get(o.Id);

            // it changed, but does it count?
            // Check for Lead_Source__c changing because that might change the formula Marketing_Interaction__c
            System.debug('Checking Interaction');
            System.debug(interaction);
            if(     interaction.Source_Number__c != oldInteraction.Source_Number__c ||
                    interaction.Lead_Source__c != oldInteraction.Lead_Source__c ||
                    interaction.Opportunity__c != oldInteraction.Opportunity__c
            ){
                if(interaction.Opportunity__c != null){
                    opp_ids.add(interaction.Opportunity__c);
                }
            }
            // temp to fix interactions/sources
            else if(interaction.Opportunity__c != null){
                //if(interaction.Opportunity__r.Primary_Source_Number__c == null){
                opp_ids.add(interaction.Opportunity__c);
                //}
            }

        }
        if (!opp_ids.isEmpty()) {
            updateRollUps(opp_ids);
        }
    }

    global override void onAfterDelete(List<SObject> oldList, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        System.debug('starting onAfterDelete');

        Set<Id> opp_ids = new Set<Id>();
        for (SObject o : oldList) {
            Interaction__c interaction = (Interaction__c) o;
            System.debug('checking deleted interaction');
            System.debug(interaction);
            if(interaction.Opportunity__c != null){
                System.debug('evaluating Opportunity');
                System.debug(interaction.Opportunity__c);
                opp_ids.add(interaction.Opportunity__c);
            }
        }

        if (!opp_ids.isEmpty()) {
            updateRollUps(opp_ids);
        }



    }

    private void updateRollUps(Set<Id> masterIds){

//        if(objects.size() != 0){
//                /*
//             First step is to create a context for LREngine, by specifying parent and child objects and
//             lookup relationship field name
//            */
//            LREngine.Context ctx = new LREngine.Context(Opportunity.SObjectType, // parent object
//                    Interaction__c.SObjectType,  // child object
//                    Schema.SObjectType.Interaction__c.fields.Opportunity__c, // relationship field name
//                    'Marketing_Interaction__c=true AND Source_Number__c > 0 AND Source_Number__c != NULL'
//            );
//
//            /*
//             Next, one can add multiple rollup fields on the above relationship.
//             Here specify
//              1. The field to aggregate in child object
//              2. The field to which aggregated value will be saved in master/parent object
//              3. The aggregate operation to be done i.e. SUM, AVG, COUNT, MIN/MAX
//            */
//            ctx.add(
//                    new LREngine.RollupSummaryField(
//                            Schema.SObjectType.Opportunity.fields.Primary_Source_Number__c,
//                            Schema.SObjectType.Interaction__c.fields.Source_Number__c,
//                            LREngine.RollupOperation.Min
//                    ));
//
//            SObject[] masters = LREngine.rollUp(ctx, objects);
//            // Persiste the changes in master
//            System.debug('updating masters: ' + masters);


        // Create a copy of the list of IDs, so we know which ones we updated and which ones should be blanked out.
        // Need to be able to remove values to do this.
        masterIds = masterIds.clone();

        List<AggregateResult> results = [SELECT Opportunity__c, MIN(Source_Number__c) min_source FROM Interaction__c WHERE Opportunity__c IN :masterIds AND Marketing_Interaction__c=TRUE AND Source_Number__c > 0 AND Source_Number__c != NULL GROUP BY Opportunity__c];
        List<Opportunity> update_opps = new List<Opportunity>();

        Map<Id, Opportunity> masterRecordsMap = new Map<Id, Opportunity>();
        for (Id mId : masterIds) {
            masterRecordsMap.put(mId, new Opportunity(Id=mId));
        }


        for (AggregateResult res : results) {
            Id opp_id = (Id)res.get('Opportunity__c');
            SObject opp = masterRecordsMap.get(opp_id);
            if(opp_id != null){
                opp.put('Primary_Source_Number__c', res.get('min_source'));
                masterIds.remove(opp_id);
            }
        }

        // masterIds is now the list of IDs that did not return a min_source value.
        for(Id opp_id : masterIds){
            masterRecordsMap.get(opp_id).put('Primary_Source_Number__c', null);
        }

        // update the objects to set the new values

        update masterRecordsMap.values();
    }
}