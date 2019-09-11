global class TDTM_Test_Score_Handler extends TDTMVirtualTriggerHandler {

    private Test_Score__c[] createTestScores(List<SObject> newList) {
        Id act_record_type = Schema.SObjectType.Test_Score__c.getRecordTypeInfosByName().get('ACT').getRecordTypeId();

        Id[] contact_ids = new List<Id>();
        for (SObject o : newList) {
            Interaction__c interaction = (Interaction__c) o;
            contact_ids.add(interaction.Contact__c);
        }

        Test_Score__c[] existing_scores = [SELECT Id, Name, ACT_Composite_Score__c, Test_Date__c, Contact__c FROM Test_Score__c WHERE Test_Type__c='ACT' AND Contact__c IN :contact_ids];

        List<Test_Score__c> new_test_scores = new List<Test_Score__c>();

        for (SObject o : newList) {
            Interaction__c interaction = (Interaction__c) o;

            if (interaction.Contact__c != null && interaction.ACT_Test_Results__c != null && interaction.ACT_Test_Results__c != 'none') {

                Map<String, String> act_scores = new Map<String, String>();
                for (String score : interaction.ACT_Test_Results__c.split('\n')) {
                    List<String> split_score = score.split(':');
                    // Excel sometimes send quotes and white space, so get rid of those.
                    act_scores.put(split_score[0].replace('"', '').trim(), split_score[1].replace('"', '').trim());
                }

                // probably could do this more efficiently
                Boolean test_score_exists = false;
                for(Test_Score__c ts : existing_scores){
                    Integer comp = Integer.valueOf(act_scores.get('ACT_Composite_Score__c'));
                    Date test_date = Date.parse(act_scores.get('ACT_Test_Date__c'));
                    if(ts.Contact__c==interaction.Contact__c && ts.ACT_Composite_Score__c==comp && ts.Test_Date__c == test_date){
                        test_score_exists = true;
                    }
                }

                System.debug('DOES TEST SCORE EXIST');
                System.debug(test_score_exists);
                System.debug('CONTACT ID');
                System.debug(interaction.Contact__c);
                if (!test_score_exists && act_scores.get('ACT_Composite_Score__c') != null) {
                    new_test_scores.add(new Test_Score__c(
                            RecordTypeId = act_record_type,
                            Contact__c = interaction.Contact__c,
                            Test_Type__c = 'ACT',
                            Document_Status__c = 'Received',
                            Status_Description__c = 'Official',
                            Display_to_Applicant__c = True,
                            Date_Test_Received__c = interaction.Date_ACT_Test_Received__c,
                            Test_Date__c = Date.parse(act_scores.get('ACT_Test_Date__c')),
                            ACT_Composite_Score__c = Integer.valueOf(act_scores.get('ACT_Composite_Score__c')),
                            ACT_English_Score__c = Integer.valueOf(act_scores.get('ACT_English_Score__c')),
                            ACT_Mathematics_Score__c = Integer.valueOf(act_scores.get('ACT_Mathematics_Score__c')),
                            ACT_Reading_Score__c = Integer.valueOf(act_scores.get('ACT_Reading_Score__c')),
                            ACT_Science_Score__c = Integer.valueOf(act_scores.get('ACT_Science_Score__c')),
                            ACT_Writing_Score__c = act_scores.get('ACT_Writing_Score__c') != '' ? Integer.valueOf(act_scores.get('ACT_Writing_Score__c')) : null
                    ));
                }
            }
        }

        return new_test_scores;
    }

    global override void onAfterInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        // grab the objects so we can do updates. Only grab the ones that don't have a source number. It should be all new sources
        // unless a source number was manually entered to override the default.
        System.debug('starting onAfterInsert TDTM_Test_Score_Handler');

        Test_Score__c[] new_scores = createTestScores(newList);

        if(new_scores.size() > 0){
            insert new_scores;
        }
    }

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        System.debug('starting onAfterUpdate TDTM_Test_Score_Handler');
        Test_Score__c[] new_scores = createTestScores(newList);

        if(new_scores.size() > 0){
            insert new_scores;
        }

    }

}