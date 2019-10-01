global class TDTM_Academic_Interest_Handler extends TDTMVirtualTriggerHandler {


    global override void onBeforeInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        process(newList);
        
    }

    global override void onBeforeUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        process(newList);
    }

    private Boolean valid_interaction(Interaction__c interaction){

        if(interaction.Interaction_Status__c != 'New'){
            System.debug('Interaction not being processed, skipping');
            return false;
        }

        if(interaction.Opportunity_Stage__c != 'Inquired'){
            System.debug('Opportunity Stage is not Inquired');
            System.debug('Got Opportunity Stage ' + interaction.Opportunity_Stage__c);
            return false;
        }

        // don't process if not Undergrad interaction
        if (interaction.School_College__c == null || interaction.School_College__c == ''){
            System.debug('School / College is blank, skipping');
            return false;
        }

        if (String.isBlank(interaction.All_Academic_Interests__c)){
            System.debug('No data for All Intended Programs');
            return false;
        }

        return true;
    }

    private void process(List<SObject> newList){

        Set<String> lookup_keys = new Set<String>();

        Interaction__c[] interactions_to_process = new List<Interaction__c>();

        for(SObject o : newList) {
            Interaction__c interaction = (Interaction__c) o;

            // check if interaction should be processed
            if(!valid_interaction(interaction)){
                continue;
            }

            interaction.All_Academic_Interests__c = interaction.All_Academic_Interests__c.toLowerCase();

            // populate Intended_Program__c and Secondary_Intended_Program__c from All_Academic_Interests__c
            String[] all_academic_interests = interaction.All_Academic_Interests__c.split(',');

            // there is some data in all_academic_interests so we know we can at least one
            String first_academic_interest = all_academic_interests.get(0).trim();
            String interest_key = first_academic_interest+'---'+interaction.School_College__c;
            lookup_keys.add(interest_key.toLowerCase());


            String second_academic_interest;
            if(all_academic_interests.size() > 1){
                second_academic_interest = all_academic_interests.get(1).trim();
                String second_interest_key = second_academic_interest+'---'+interaction.School_College__c;
                lookup_keys.add(second_interest_key.toLowerCase());
            }else{
                second_academic_interest = null;
            }

            // add to the list to process after SOQL query
            interactions_to_process.add(interaction);

        }

        System.debug('----------------KEYS----------------');
        System.debug(lookup_keys);
        System.debug('------------------------------------');

        // do SOQL queries for the records we need.
        Academic_Interest_Mapping__c[] academic_interests = [SELECT Program__c, Academic_Interest__c, School_College__c, Mapping_Key__c FROM Academic_Interest_Mapping__c WHERE Mapping_Key__c = :lookup_keys];

        Map<String, Id> interest_to_program_map = new Map<String, Id>();
        for( Academic_Interest_Mapping__c m : academic_interests){
            interest_to_program_map.put(m.Mapping_Key__c, m.Program__c);
        }

        System.debug('----------------MAP----------------');
        System.debug(interest_to_program_map);
        System.debug('------------------------------------');


        for(Interaction__c interaction : interactions_to_process){

            //todo:  this is repeated code
            interaction.All_Academic_Interests__c = interaction.All_Academic_Interests__c.toLowerCase();
            String school = interaction.School_College__c.toLowerCase();

            // populate Intended_Program__c and Secondary_Intended_Program__c from All_Academic_Interests__c
            String[] all_academic_interests = interaction.All_Academic_Interests__c.split(',');

            String first_academic_interest = all_academic_interests.get(0).trim();
            String second_academic_interest;
            if(all_academic_interests.size() > 1){
                second_academic_interest = all_academic_interests.get(1).trim();
            }else{
                second_academic_interest = null;
            }

            String first_mapping_key =  first_academic_interest+'---'+school;
            interaction.Academic_Program__c = interest_to_program_map.get(first_mapping_key);
            if(second_academic_interest != null){
                String second_mapping_key =  second_academic_interest+'---'+school;
                interaction.Secondary_Academic_Program__c = interest_to_program_map.get(second_mapping_key);
            }
        }   

    }
}