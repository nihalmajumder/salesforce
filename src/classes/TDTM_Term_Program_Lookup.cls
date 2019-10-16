/**
 * Created by ejc84332 on 2019-03-05.
 */

global class TDTM_Term_Program_Lookup extends TDTMVirtualTriggerHandler {


    global override void onBeforeInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        process_term_program_lookups(newList);
    }

    global override void onBeforeUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        process_term_program_lookups(newList);
    }

    private void process_term_program_lookups(List<SObject> newList){
        Map<String, Id> program_map = get_programs();
        Map<String, Id> term_map = get_terms();

        for (SObject o : newList){
            Interaction__c interaction = (Interaction__c)o;

            System.debug('INTERACTION STATUS');
            System.debug(interaction.Interaction_Status__c);

            // handle CSG
            if(interaction.School_College__c != 'Undergraduate'){

                // get a program if no existing and we got search text.
                if(interaction.Academic_Program__c == null && interaction.Program_Search_Text__c != null){
                    System.debug('LOOKING FOR PROGRAM BY TEXT');
                    System.debug(interaction.Program_Search_Text__c);
                    System.debug(program_map.get(interaction.Program_Search_Text__c));
                    interaction.Academic_Program__c = program_map.get(interaction.Program_Search_Text__c);
                }

                String term_suffix;
                if(interaction.School_College__c == 'Seminary'){
                    term_suffix = ' - SEM';
                }else{
                    term_suffix = ' - CAPS/GS';
                }


                // get a term if no existing and we got search text.
                if(interaction.Academic_Term__c == null && interaction.Term_Search_Text__c != null){

                    String term_key = interaction.Term_Search_Text__c.trim() + term_suffix;

                    System.debug('LOOKING FOR TERM BY TEXT');
                    System.debug(term_key);
                    System.debug(term_map.get(term_key));

                    interaction.Academic_Term__c = term_map.get(term_key);
                }
                // otherwise get term by today's date, if there are more than one result (shouldn't be??), grab the first one.
                else if(interaction.Academic_Term__c == null && interaction.Term_Search_Text__c == null){
                    String term_search = '%' + term_suffix;
                    Academic_Term__c term_by_date = [select Id, Name from Academic_Term__c where Term_Start_Date__c <= TODAY and Term_End_Date__c > TODAY and Name like :term_search limit 1];
                    System.debug('FOUND THESE TERMS BY DATE');
                    System.debug(term_by_date);
                    if(term_by_date != null){
                        interaction.Academic_Term__c = term_by_date.Id;
                    }

                }

            // handle undergrad.
            }else{
                // Prioritze this over age or grad year
                if(interaction.Term_Search_Text__c != null){
                    String term_key = interaction.Term_Search_Text__c.trim() + ' - CAS';
                    System.debug('LOOKING FOR TERM BY TEXT');
                    System.debug(term_key);
                    System.debug(term_map.get(term_key));
                    interaction.Academic_Term__c = term_map.get(term_key);
                }
                else if(interaction.Academic_Term__c == null && (interaction.High_School_Graduation_Year__c != null || interaction.Age__c != null)){

                    if(interaction.Age__c != null && interaction.High_School_Graduation_Year__c == null){
                        Integer age = interaction.Age__c.intValue();
                        if(age > 18){
                            System.debug('AGE OVER 18');
                            System.debug(age);
                            interaction.Age__c.addError('Age cannot be over 18');
                        }else{
                            System.debug('AGE NOT OVER 18');
                            // calculate grad year. If the current month is Jan->August, do 18-1-age. This is to err
                            // on the side of sending them things sooner.
                            Integer grad_year;
                            if(System.today().month()<=8){
                                grad_year = System.today().year() + (17 - age);
                            }else{
                                grad_year = System.today().year() + (18 - age);
                            }
                            interaction.High_School_Graduation_Year__c = String.valueOf(grad_year);
                        }
                    }
                    System.debug('LOOKING FOR TERM');
                    System.debug('Fall ' + interaction.High_School_Graduation_Year__c + ' - CAS');
                    interaction.Academic_Term__c = term_map.get('Fall ' + interaction.High_School_Graduation_Year__c + ' - CAS');
                }

                // If there is a value in <>, Program is handled by TDTM_Academic_Interest_Handler.
                // If nothing, default to Undecided.
                // todo combine these two triggers?
                if(interaction.Academic_Program__c == null && interaction.All_Academic_Interests__c == null){
                    interaction.Academic_Program__c = program_map.get('Undecided');
                }
            }

            System.debug('INTERACTION STATUS END');
            System.debug(interaction.Interaction_Status__c);
        }
    }

    private Map<String, Id> get_programs(){
        // todo, add in filtering by actual list of programs we need.

        Map<String, Id> program_map = new Map<String, Id>();

        Program__c[] programs = [SELECT Id, Program_Name_on_Application__c FROM Program__c WHERE Academic_Program__r.Expired_Program__c=FALSE];

        for(Program__c p : programs){
            program_map.put(p.Program_Name_on_Application__c, p.Id);
        }

        return program_map;
    }


    private Map<String, Id> get_terms(){
        // todo, add in filtering by actual list of terms we need.

        Map<String, Id> term_map = new Map<String, Id>();

        Academic_Term__c[] terms = [SELECT Id, Name FROM Academic_Term__c];

        for(Academic_Term__c t : terms){
            term_map.put(t.Name, t.Id);
        }

        return term_map;
    }


}