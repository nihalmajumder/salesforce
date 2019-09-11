/**
 * Created by ejc84332 on 2019-04-02.
 */

global class TDTM_Opportunity_Program_Term_Validate extends TDTMVirtualTriggerHandler {

    global override void onBeforeInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        ValidateProgramTerm(newList);
    }

    global override void onBeforeUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        SObject[] process_list = new List<SObject>();

        for (SObject s : newList){
            Opportunity new_opp = (Opportunity)s;
            Opportunity old_opp = (Opportunity) oldMap.get(new_opp.Id);

            if(new_opp.Academic_Program__c != old_opp.Academic_Program__c || new_opp.Academic_Term__c != old_opp.Academic_Term__c){
                process_list.add(s);
            }
        }

        ValidateProgramTerm(process_list);
    }


    private void ValidateProgramTerm(List<SObject> newList) {

        Set<Id> program_ids = new Set<Id>();
        for (SObject o : newList) {
            Opportunity opp = (Opportunity) o;
            program_ids.add(opp.Academic_Term__c);
        }

        Intended_Program_Term__c[] intended_programs = [SELECT Academic_Term__c, Intended_Program__r.Name, Intended_Program__c, Academic_Term__r.Name, Delivery_Type__c FROM Intended_Program_Term__c WHERE Academic_Term__c IN :program_ids];

        // todo: I think this logic could be impoved.
        for (SObject o : newList) {
            Opportunity opp = (Opportunity) o;
            Boolean found_match = false;

            if (opp.Academic_Program__c == null || opp.Academic_Term__c == null){
                found_match = true;
                break;
            }

            if (opp.School_College__c == 'Seminary' && opp.Preferred_Delivery_Format__c != null) {
                for (Intended_Program_Term__c ip : intended_programs) {
                    String dt;
                    if(ip.Delivery_Type__c == null){
                        // all apply if this field is blank
                         dt = 'Online;Blended;Face-to-Face';
                    }else{
                        dt = ip.Delivery_Type__c;
                    }
                    if (ip.Academic_Term__c == opp.Academic_Term__c && ip.Intended_Program__c == opp.Academic_Program__c && dt.contains(opp.Preferred_Delivery_Format__c)) {
                        found_match = true;
                        break;
                    }
                }
            } else {
                for (Intended_Program_Term__c ip : intended_programs) {
                    if(ip.Intended_Program__r.Name == 'Marriage and Family Therapy Post-Graduate Certificate'){
                        System.debug('CHECKING PROGRAM');
                        System.debug(ip.Intended_Program__c);
                        System.debug('CHECKING TERM');
                        System.debug(ip.Academic_Term__c);
                        System.debug('Opp Fields');
                        System.debug(opp.Academic_Term__c);
                        System.debug(opp.Academic_Program__c);
                    }

                    if (ip.Academic_Term__c == opp.Academic_Term__c && ip.Intended_Program__c == opp.Academic_Program__c) {
                        found_match = true;
                        break;
                    }
                }
            }
            if(!found_match) {
                if(opp.School_College__c == 'Seminary') {
                    opp.addError('Program, Term, and Delivery not a valid combination.');
                }else {
                    opp.addError('Program and Term not a valid combination.');
                }
            }
        }
    }
}