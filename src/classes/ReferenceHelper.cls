public inherited sharing class ReferenceHelper {
    public static Map<Id, Reference__c> referenceCacheMap = new Map<Id, Reference__c>();
    public static Map<Id, Requirement_Response__c> requirementResponseCacheMap = new Map<Id, Requirement_Response__c>();

    public static Reference__c getReference(Id theId) {
        Reference__c reference = null;
        List<Reference__c> references = [
            SELECT 
                Ability_To_Accomplish_Goals__c, Ability_To_Lead__c, Academic_Ability__c, Academic_Competence__c, Academic_Studies__c, Additional_Comments__c,
                Areas_Of_Growth__c, Business_City__c ,Business_Name__c, Business_State__c, Christian_Faith_And_Commitment__c, City__c, Comfortable_With_Position__c,
                Comment_On_Abilities__c, Comment_On_Christian_Commitment__c, Comment_On_InterculturalSkills__c, Comment_On_Interpersonal_Skills__c, 
                Comment_On_Scholastic_Skills__c, Comment_On_Strengths__c, Comment_On_Weaknesses__c, Comment_On_Work__c, Communication_Skills__c, 
                Communication_Verbal_Written_Skills__c, Conflict_Management_Skills__c, Contact__c, Country__c, Creative_Solutions__c, Creativity__c, Date_Received__c,
                Decision_Making_Ability__c, Decision_Making__c, Demonstrate_Faith__c, Email__c, Fifteen_Hours_Commitment_Comment__c, Fifteen_Hours_Commitment__c,
                First_Name__c, Flexibility__c, Four_Year_Commitment__c, How_Long__c, How_Responsible__c, How_Well__c, Id, Initiative_And_Perserverance__c,
                Integrity__c, Intensive_Commitment_Comment__c, Intensive_Commitment__c, Intercultural_Competence__c, Interpersonal_Skills__c, Is_Seminary_Next_Step__c,
                Last_Name__c, Leadership_Comments__c, Leadership_Potential__c, Leadership_Skills__c, Leadership__c, Mentorship_Comments__c, Mentorship__c, Name, Oral_Communication_Skills__c,
                Personal_Maturity__c, Phone__c, Plans_Of_Support__c, PostalCode__c, React_To_Criticism__c, Readiness_For_Ministry__c, Recommend__c, Relationship__c,
                Research_Projects__c, Responsibility__c, Self_Confidence__c, Signature_Date__c, Signature__c, State__c, Street__c, Strengths_And_Weaknesses__c,
                Three_Year_Commitment_Comment__c, Three_Year_Commitment__c, Title_Role__c, Type__c, Waive_Rights__c, Workload_Commitment_Comment__c, Workload_Commitment__c,
                Written_Communication_Skills__c, Applicant_Name__c, Applicant_Email__c
            FROM 
                Reference__c
            WHERE 
                Id = :theId
        ];
        if (!references.isEmpty()) {
            reference = references[0];
        }
        return reference;
    }

    public static List<Reference__c> getReferences(Id contactId, String typeName, String college) {
        List<Reference__c> references = null;
        Id recordTypeId = getRecordTypeId(typeName, college);
        if (contactId != null && recordTypeId != null) {
            references = [
                SELECT 
                    Ability_To_Accomplish_Goals__c, Ability_To_Lead__c, Academic_Ability__c, Academic_Competence__c, Academic_Studies__c, Additional_Comments__c,
                    Areas_Of_Growth__c, Business_City__c ,Business_Name__c, Business_State__c, Christian_Faith_And_Commitment__c, City__c, Comfortable_With_Position__c,
                    Comment_On_Abilities__c, Comment_On_Christian_Commitment__c, Comment_On_InterculturalSkills__c, Comment_On_Interpersonal_Skills__c, 
                    Comment_On_Scholastic_Skills__c, Comment_On_Strengths__c, Comment_On_Weaknesses__c, Comment_On_Work__c, Communication_Skills__c, 
                    Communication_Verbal_Written_Skills__c, Conflict_Management_Skills__c, Contact__c, Country__c, Creative_Solutions__c, Creativity__c, Date_Received__c,
                    Decision_Making_Ability__c, Decision_Making__c, Demonstrate_Faith__c, Email__c, Fifteen_Hours_Commitment_Comment__c, Fifteen_Hours_Commitment__c,
                    First_Name__c, Flexibility__c, Four_Year_Commitment__c, How_Long__c, How_Responsible__c, How_Well__c, Id, Initiative_And_Perserverance__c,
                    Integrity__c, Intensive_Commitment_Comment__c, Intensive_Commitment__c, Intercultural_Competence__c, Interpersonal_Skills__c, Is_Seminary_Next_Step__c,
                    Last_Name__c, Leadership_Comments__c, Leadership_Potential__c, Leadership_Skills__c, Leadership__c, Mentorship_Comments__c, Mentorship__c, Name, Oral_Communication_Skills__c,
                    Personal_Maturity__c, Phone__c, Plans_Of_Support__c, PostalCode__c, React_To_Criticism__c, Readiness_For_Ministry__c, Recommend__c, Relationship__c,
                    Research_Projects__c, Responsibility__c, Self_Confidence__c, Signature_Date__c, Signature__c, State__c, Street__c, Strengths_And_Weaknesses__c,
                    Three_Year_Commitment_Comment__c, Three_Year_Commitment__c, Title_Role__c, Type__c, Waive_Rights__c, Workload_Commitment_Comment__c, Workload_Commitment__c,
                    Written_Communication_Skills__c, Applicant_Name__c, Applicant_Email__c
                FROM 
                    Reference__c
                WHERE 
                    Contact__c = :contactId AND Type__c = :typeName AND RecordTypeId = :recordTypeId
                ORDER BY LastModifiedDate DESC
            ];
        }
        return references;
    }

    public static Reference__c getReference(Id appId, Id requirementItemId) {
        Reference__c ref = null;
        Requirement_Response__c response = requirementResponseCacheMap.get(requirementItemId);
        if (response != null) {
            if (response.Application__c != appId) {
                response = null;
            }
        }
        if (response == null) {
            List<Requirement_Response__c> responses = [
                SELECT 
                    Id, Application__c, Requirement_Item__c, Reference__c
                FROM
                    Requirement_Response__c
                WHERE
                    Application__c = :appId AND Requirement_Item__c = :requirementItemId
            ];
            if (!responses.isEmpty()) {
                response = responses[0];
                requirementResponseCacheMap.put(requirementItemId, response);
            }
        }
        if (response != null && response.Reference__c != null) {
            ref = referenceCacheMap.get(response.Reference__c);
            if (ref == null) {
                ref = getReference(response.Reference__c);
                referenceCacheMap.put(response.Reference__c, ref);
            }
        }
        return ref;
    }

    public static Reference__c createReference(Id contactId, String typeName, String college) {
        Reference__c ref = new Reference__c(Contact__c = contactId, Type__c = typeName);
        Id recordTypeId = getRecordTypeId(typeName, college);
        if (recordTypeId != null) {
            ref.RecordTypeId = recordTypeId;
        }
        insert ref;
        ref = getReference(ref.Id);
        return ref;
    }

    public static Reference__c findReference(Id contactId, String typeName, String college, String name) {
        Reference__c reference = null;
        List<Reference__c> references = getReferences(contactId, typeName, college);
        if (references != null && !references.isEmpty()) {
            if (typeName.equals('Professional') && name.contains('Second Professional Reference')) {
                if (references.size() > 1) {
                    reference = references[1];
                }
                else {
                    reference = createReference(contactId, typeName, college);
                }
            }
            else {
                reference = references[0];
            }
        }
        else {
            reference = createReference(contactId, typeName, college);
        }
        return reference;
    }

    public static Id getRecordTypeId(String typeName, String college) {
        Id recordTypeId = null;
        if (college.equals('Adult Undergraduate')) {
            if (typeName.equals('Professional') || typeName.equals('Supervisor')) {
                recordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('Grad Nursing').getRecordTypeId();
            }
            else if (typeName.equals('Spiritual')) {
                recordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('CAPS Spiritual').getRecordTypeId();
            }
        }
        else if (college.equals('Graduate')) {
            if (typeName.equals('Nursing Professional') || typeName.equals('Supervisor')) {
                recordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('Grad Nursing').getRecordTypeId();
            }
            else if (typeName.equals('Professional')) {
                recordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('Grad General').getRecordTypeId();
            }
        }
        else if (college.equals('Seminary')) {
            if (typeName.equals('Pastoral') || typeName.equals('Personal') || typeName.equals('Supervisor')) {
                recordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('Seminary General').getRecordTypeId();
            }
            else if (typeName.equals('Doctor of Ministry')) {
                recordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('Doctor of Ministry Context Form').getRecordTypeId();
            }
            else if (typeName.equals('Ministry')) {
                recordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('InMinistry Context Form').getRecordTypeId();
            }
            else if (typeName.equals('Professional')) {
                recordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('Seminary Marriage Family').getRecordTypeId();
            }
            else if (typeName.equals('Vocational')) {
                recordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('MATL Ministry Form').getRecordTypeId();
            }
        }
        return recordTypeId;
    }

}