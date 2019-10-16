/**
 * Created by ejc84332 on 2019-07-31.
 */

public with sharing class UpdateReferenceController {

    @AuraEnabled
    public static String updateReferenceResponses(Id referenceId, String firstName, String lastName, String emailAddress, String relationshipToApplicant) {

//        Reference__c update_ref = new Reference__c(Id=referenceId, First_Name__c=)

        Requirement_Response__c[] requirement_responses = [Select Id, Requirement_Item__r.Name from Requirement_Response__c where Reference__c = :referenceId
                                                and Requirement_Item__r.Name like '%Reference'];

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

        return referenceId;
    }



}