/**
 * Created by bej68982 on 3/25/20.
 */

@IsTest
private class TDTM_Case_AssignmentTest {

    @IsTest
    static void testChangingOwner() {
        // first retrieve default HEDA trigger handlers
        List<hed.TDTM_Global_API.TdtmToken> tokens = hed.TDTM_Global_API.getTdtmConfig();
        // Create our trigger handler using the constructor
        tokens.add(new hed.TDTM_Global_API.TdtmToken('TDTM_Case_Assignment', 'Case', 'BeforeUpdate', 5.00));
        // Pass trigger handler config to set method for this test run
        hed.TDTM_Global_API.setTdtmConfig(tokens);

        Id ssr_re_enrollment_record_type = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SSR - Re-enrollment').getRecordTypeId();

        //Create Users
        User old_owner = BethelTestDataFactory.createTestUser(BethelTestDataFactory.getStandardProfile().Id, 'old', 'test');
        insert old_owner;

        User new_owner = BethelTestDataFactory.createTestUser(BethelTestDataFactory.getStandardProfile().Id, 'new', 'test');
        insert new_owner;

        //Create Re-enrollment Case
        Case testCase = new Case(RecordTypeId = ssr_re_enrollment_record_type, OwnerId=old_owner.Id, Type = 'readmission', Status = 'New');
        insert testCase;

        Test.startTest();

        testCase.OwnerId = new_owner.Id;
        update testCase;

        Test.stopTest();

        Case updatedTestCase = [SELECT Id, Status, OwnerId FROM Case WHERE Id = :testCase.Id];
        System.assert(updatedTestCase.Status == 'Review');
    }
}