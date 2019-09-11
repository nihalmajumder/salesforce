/**
 * Created by ejc84332 on 2019-03-30.
 */

@IsTest
private class Test_TDTM_Create_Case_Tasks {

//private static Interaction__c select_int(String int_id){
//return [SELECT Id, All_Academic_Interests__c, Academic_Program__r.Id, Secondary_Academic_Program__c FROM Interaction__c WHERE Id = :int_id];
//}

    @IsTest
    static void test_create_case_tasks() {

        // first retrieve default HEDA trigger handlers
        List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();
        // Create our trigger handler using the constructor
        tokens.add(new hed.TDTM_Global_API.TdtmToken('TDTM_Create_Case_Tasks', 'Case', 'AfterInsert;AfterUpdate', 2.00));
        // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);

        // have to do this to ssr_record_type to get the assignment rules working?
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = false;

        Id petition_record_type = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SSR - Academic Petition').getRecordTypeId();
        Id commencement_record_type = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SSR - Commencement').getRecordTypeId();
        Id ssr_record_type = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SSR - Student Success Case').getRecordTypeId();
        Id its_program_record_type = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ITS - Create/Edit Program').getRecordTypeId();

        User test_user = BethelTestDataFactory.createTestUser(BethelTestDataFactory.getStandardProfile().Id, 'test', 'test');
        insert test_user;

        Case[] case_list = new List<Case>();
        case_list.add(new Case(recordTypeId = petition_record_type));
        case_list.add(new Case(recordTypeId = commencement_record_type));
        case_list.add(new Case(recordTypeId = its_program_record_type));
        case_list.add(new Case(recordTypeId = ssr_record_type, Type = 'Provisional Acceptance'));
        case_list.add(new Case(recordTypeId = ssr_record_type, Type = 'Retention', Assign_SSR_Advising__c=true));
        case_list.add(new Case(recordTypeId = ssr_record_type, Type = 'Schedule - Admissions', Assign_SSR_Advising__c=true));
        case_list.add(new Case(recordTypeId = ssr_record_type, Type = 'Conditional Acceptance', OwnerId=test_user.Id));
        case_list.add(new Case(recordTypeId = ssr_record_type, Type = 'Success Coaching'));
        for (Case c : case_list) {
            c.setOptions(dmo);
        }
        insert case_list;

        Test.startTest();
        for (Case c : case_list) {
            c.OwnerId = test_user.Id;
        }
        update case_list;
        for (Case c : case_list) {
            Task[] tasks = [SELECT Id FROM Task WHERE WhatId = :c.Id];
            if(tasks.isEmpty()){
                System.debug(c.Subject);
                System.debug('---------------------------------------------------');
                System.debug(its_program_record_type);
                System.debug(Schema.SObjectType.Case.getRecordTypeInfosByName().get('ITS - Create/Edit Program').getRecordTypeId());
                System.debug(c);
                System.debug(tasks);
                System.debug('---------------------------------------------------');

            }
            System.assert(!tasks.isEmpty());
        }
        Test.stopTest();
    }
}