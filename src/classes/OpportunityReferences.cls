/**
 * Created by phg49389 on 2019-04-16.
 */

public with sharing class OpportunityReferences {
    @AuraEnabled(Cacheable=true)
    public static List<Reference__c> getReferences(String applicationID){
        return [SELECT Reference__c.Id, Reference__c.Type__c, Reference__c.First_Name__c, Reference__c.Last_Name__c FROM Reference__c WHERE Reference__c.Id IN (SELECT Requirement_Response__c.Reference__c FROM Requirement_Response__c WHERE Requirement_Response__c.Application__r.Id = :applicationID)];
    }
}