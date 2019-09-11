/**
 * Created by ejc84332 on 2019-05-07.
 * Test is: OpportunityHelperTest.lightningWebComponentsTest
 */

public with sharing class InternalChecklistRequirements {
    @AuraEnabled(Cacheable=true)
    public static List<Question_Response__c> getInternalQuestions(String applicationID){
        return [

                SELECT Id, Question_Label__c, ValueText__c, IsComplete__c from Question_Response__c where IsShown__c = TRUE and Requirement_Response__c in (

                        SELECT Id from Requirement_Response__c where Application__c=:applicationID and Requirement_Item__r.Name like '%Prerequisites%'

                )

        ];
    }
}