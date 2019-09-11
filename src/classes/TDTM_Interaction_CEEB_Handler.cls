global class TDTM_Interaction_CEEB_Handler extends TDTMVirtualTriggerHandler {

    global override void onAfterInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        System.debug('starting onAfterInsert TDTM_Interaction_CEEB_Handler');
        List<hed__Affiliation__c> new_affils = process(newList);
        if(new_affils.size() > 0){
            insert new_affils;
        }
    }

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        System.debug('starting onBeforeUpdate TDTM_Interaction_CEEB_Handler');
        List<hed__Affiliation__c> new_affils = process(newList);
        if(new_affils.size() > 0){
            insert new_affils;
        }
    }

    private List<hed__Affiliation__c> process(List<SObject> newList){
        List<hed__Affiliation__c> new_affils = new List<hed__Affiliation__c>();

        String[] ceebs = new List<String>();
        Id[] cids = new List<Id>();

        for (SObject o : newList) {
            Interaction__c interaction = (Interaction__c) o;
            if(interaction.CEEB_Code__c != null){
                ceebs.add(interaction.CEEB_Code__c);
            }
            if(interaction.Contact__c != null){
                cids.add(interaction.Contact__c);
            }
        }

        if(ceebs.size() == 0 || cids.size() == 0){
            System.debug('EXITING EARLY');
            System.debug(ceebs);
            System.debug(cids);
            return new_affils;
        }

//        Map<String, Id> accts = new Map<String, Account>([SELECT CEEB_Code__c, Id FROM Account ]);
        Map<String, Id> accts = new Map<String, Id>();
        for (Account a : [SELECT Id, CEEB_Code__c FROM Account WHERE CEEB_Code__c IN :ceebs]) {
            accts.put(a.CEEB_Code__c, a.Id);
        }
        System.debug('ACCOUNTS');
        System.debug(accts);
        hed__Affiliation__c[] affils = [SELECT hed__Contact__c, hed__Account__r.CEEB_Code__c FROM hed__Affiliation__c WHERE hed__Contact__c IN :cids];
        System.debug('AFFILIATIONS');
        System.debug(affils);
        for (SObject o : newList) {
            Interaction__c interaction = (Interaction__c) o;
            if(interaction.CEEB_Code__c != null && interaction.Contact__c != null){
                System.debug('CEEB CODE');
                System.debug(interaction.CEEB_Code__c);
                // does an affiliation exist?
                Boolean found_interaction = false;
                for(hed__Affiliation__c a : affils){
                    if(a.hed__Contact__c==interaction.Contact__c && a.hed__Account__r.CEEB_Code__c==interaction.CEEB_Code__c){
                        found_interaction = true;
                        System.debug('FOUND INTERACTION');
                        System.debug(a);
                        break;
                    }
                }
                if(!found_interaction){
                    System.debug('DID NOT FIND INTERACTION');
                    System.debug('LOOKING FOR ACCOUNT WITH CEEB CODE');
                    System.debug(interaction.CEEB_Code__c);
                    new_affils.add(new hed__Affiliation__c(hed__Account__c=accts.get(interaction.CEEB_Code__c), hed__Contact__c=interaction.Contact__c, hed__Role__c='Student'));
                }
            }
        }

        return new_affils;

    }
}