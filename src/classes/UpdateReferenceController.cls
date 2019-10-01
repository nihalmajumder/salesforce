/**
 * Created by ejc84332 on 2019-07-31.
 */

public with sharing class UpdateReferenceController {

    @AuraEnabled
    public static String updateReferenceResponses(Id referenceId, String firstName, String lastName, String emailAddress, String relationshipToApplicant) {

//        Reference__c update_ref = new Reference__c(Id=referenceId, First_Name__c=)

        Requirement_Response__c[] requirement_responses = [Select Id, Requirement_Item__r.Name from Requirement_Response__c where Reference__c = :referenceId
                                                and Requirement_Item__r.Name like '%Reference'];

//        Question_Response__c[] question_responses = [Select Id, Question_Label__c, ValueText__c, ValueEmail__c from Question_Response__c where Requirement_Response__c in :requirement_responses];
//
//        Question_Response__c[] update_question_responses = new List<Question_Response__c>();



        // this SHOULD only be a list of one
        for (Requirement_Response__c response : requirement_responses){

            if(response.Requirement_Item__r.Name.endsWith('Reference')){
                response.Reference_First_Name__c = firstName;
                response.Reference_Last_Name__c = lastName;
                response.External_Email__c = emailAddress;

                // this is the only requirement response, so just update it.
                update response;
            }

        }

//        for(Question_Response__c response : question_responses){
//            switch on response.ValueText__c{
//                when 'Fist Name' {
//                    response.ValueText__c = firstName;
//                    update_question_responses.add(response);
//                }
//                when 'Last Name' {
//                    response.ValueText__c = lastName;
//                    update_question_responses.add(response);
//                }
//                when 'Email' {
//                    response.ValueEmail__c = emailAddress;
//                    update_question_responses.add(response);
//                }
//                when 'Relationship to Applicant'{
//                    response.ValueText__c = relationshipToApplicant;
//                    update_question_responses.add(response);
//                }
//            }
//            if(update_question_responses.size() > 0){
//                update update_question_responses;
//            }
//        }

        return referenceId;
    }



}