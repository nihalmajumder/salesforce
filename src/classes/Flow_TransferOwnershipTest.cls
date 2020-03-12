/**
 * Created by bej68982 on 2/26/20.
 */

@IsTest
private class Flow_TransferOwnershipTest {

    @IsTest
    static void testTransferOwnership() {
        //Get User Role
        List<UserRole> roleList = [SELECT Id,Name FROM UserRole WHERE Name LIKE '%CAS%'];
        UserRole r = roleList[0];
        System.debug('BENTEST'+r.Name);

        //Get Profile
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

        //Get Program Record Type
        RecordType recordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND Name = 'Academic Program'];

        //Get Users
        List<User> usersList = [SELECT Id FROM User WHERE UserRole.Name LIKE '%CAS%'];
        User testOldUser = usersList[0];
        User testNewUser = usersList[1];

        // Create an Contact
        Contact testContact = new Contact(FirstName='First', LastName='Last', Email='test@test.com', Mogli_SMS__Mogli_Number__c = '+12222222222');
        insert testContact;

        //Create Academic Program Account
        Account testAccount = new Account(Program_Code__c = '123abc', Name = 'Test Program', RecordTypeId = recordType.Id);
        insert testAccount;

        //Create Program
        Program__c testProgram = new Program__c(Program_Code__c = '123abc', Active__c = true, Academic_Program__c = testAccount.Id);
        insert testProgram;

        // Create an Opportunity
        Opportunity testOpportunity = new Opportunity(Contact__c = testContact.Id, OwnerId=testOldUser.Id, StageName='Inquired', Stage_Detail__c = 'App Started', Name = 'Test Opp', CloseDate=System.today(), Academic_Program__c = testProgram.Id);
        insert testOpportunity;

        // Create a Task
        Task testTask = new Task(Status = 'Open', OwnerId=testOldUser.Id, WhatId = testOpportunity.Id);
        insert testTask;

        //Create a Case
        Case testCase = new Case(Status = 'New', OwnerId=testOldUser.Id, Program__c = testAccount.Id);
        insert testCase;

        List<Flow_TransferOwnership.TransferOwnershipRequest> listOfRequests = new List<Flow_TransferOwnership.TransferOwnershipRequest>();

        String oldUserId = String.valueOf(testOldUser.Id);
        String newUserId = String.valueOf(testNewUser.Id);

        //Test Getting Total Sum
        Flow_TransferOwnership.TransferOwnershipRequest request1 = new Flow_TransferOwnership.TransferOwnershipRequest();
        request1.requestType = 'total';
        request1.objectsTypes = 'opportunities;cases;tasks';
        request1.oldOwnerId = oldUserId;
        request1.newOwnerId = newUserId;
        request1.programCodes = '123abc,456def';
        listOfRequests.add(request1);

        //Test Transferring Records
        Flow_TransferOwnership.TransferOwnershipRequest request2 = new Flow_TransferOwnership.TransferOwnershipRequest();
        request2.requestType = 'transfer';
        request2.objectsTypes = 'opportunities;cases;tasks';
        request2.oldOwnerId = oldUserId;
        request2.newOwnerId = newUserId;
        request2.programCodes = '123abc,456def';
        listOfRequests.add(request2);

        Test.startTest();
        Flow_TransferOwnership.TransferOwnership(listOfRequests);
        Test.stopTest();
        List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE OwnerId = :newUserId];
        List<Case> cases = [SELECT Id FROM Case WHERE OwnerId = :newUserId];
        List<Task> tasks = [SELECT Id FROM Task WHERE OwnerId = :newUserId];
        System.debug('BENTEST: Opportunities: '+opps.size()+' - Cases: '+cases.size()+' - Tasks: '+tasks.size());
        System.debug('BENTEST: Opps: '+opps);
        System.debug('BENTEST: Cases: '+cases);
        System.debug('BENTEST: Tasks: '+tasks);
        Integer NumberOfOwnedRecords = opps.size() + cases.size() + tasks.size();
        System.assert(NumberOfOwnedRecords > 3);
    }
}