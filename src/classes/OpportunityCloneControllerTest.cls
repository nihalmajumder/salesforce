@isTest
public class OpportunityCloneControllerTest {

    @TestSetup
    static void testSetup(){

        //create application data
        Application_Control__c appControl = new Application_Control__c(
            Application_Start_Status__c=Application_Control__c.Application_Start_Status__c.getDescribe().getPicklistValues()[0].getValue(),
            Active__c=true,
            Allow_Cancel_From__c=Application_Control__c.Allow_Cancel_From__c.getDescribe().getPicklistValues()[0].getValue(),
            Allow_Withdraw_From__c=Application_Control__c.Allow_Withdraw_From__c.getDescribe().getPicklistValues()[0].getValue(),
            Allow_Submit_From__c=Application_Control__c.Allow_Submit_From__c.getDescribe().getPicklistValues()[0].getValue(),
            Cancel_Status__c=Application_Control__c.Cancel_Status__c.getDescribe().getPicklistValues()[0].getValue(),
            Default__c=true,
            URL_Parameter__c ='st',
            Submit_Status__c=Application_Control__c.Submit_Status__c.getDescribe().getPicklistValues()[0].getValue(),
            Withdraw_Status__c=Application_Control__c.Withdraw_Status__c.getDescribe().getPicklistValues()[0].getValue()
        );
        insert appControl;

        Academic_Term__c at = new Academic_Term__c(Name = 'test', Activate_Application_Date__c = Date.TODAY().addDays(-2), End_Application_Date__c = Date.TODAY().addDays(2));
        insert at;

        Academic_Term__c at2 = new Academic_Term__c(Name = 'test 2', Activate_Application_Date__c = Date.TODAY().addDays(3), End_Application_Date__c = Date.TODAY().addDays(7));
        insert at2;

        Academic_Term__c at3 = new Academic_Term__c(Name = 'test 3', Activate_Application_Date__c = Date.TODAY().addDays(12), End_Application_Date__c = Date.TODAY().addDays(24));
        insert at3;

        Program__c p1 = new Program__c(Name = 'test1', Number_of_Applications_Limit__c = 'One Application', Applicant_Type__c = Program__c.Applicant_Type__c.getDescribe().getPicklistValues()[0].getValue());
        insert p1;

        Intended_Program_Term__c ipt = new Intended_Program_Term__c(Academic_Term__c = at.Id, Activate_Application_Date__c = Date.TODAY().addDays(-1), End_Application_Date__c = Date.TODAY().addDays(-1), Applicant_Type__c = Intended_Program_Term__c.Applicant_Type__c.getDescribe().getPicklistValues()[0].getValue());
        insert ipt;
        Intended_Program_Term__c ipt2 = new Intended_Program_Term__c(Academic_Term__c = at2.Id, Activate_Application_Date__c = Date.TODAY().addDays(2), End_Application_Date__c = Date.TODAY().addDays(2), Applicant_Type__c = Intended_Program_Term__c.Applicant_Type__c.getDescribe().getPicklistValues()[0].getValue());
        insert ipt2;

        Account acc = new Account(Name='NewAcc');
        insert acc;

        Contact student = new Contact(LastName='TestLast', FirstName = 'TestFirst', Email = 'TestContact@example.bethel.com');
        insert student;

        Application__c app = new Application__c(
            Contact__c=student.Id,
            School_College__c = 'Graduate',
            Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue(),
            Intended_Program__c =  p1.Id,
            Intended_Term_of_Entry__c = at.Id);
        insert app;

        Opportunity opp = new Opportunity(Name='Test Opp', Application__c = app.Id, Academic_Program__c = p1.Id, Academic_Term__c = at.Id, School_College__c = 'Graduate',
            Contact__c = app.Contact__c, StageName = 'Applied', Stage_Detail__c = 'App Submitted', CloseDate = Date.today());
        insert opp;

        Application__c app2 = new Application__c(
                Contact__c=student.Id,
                School_College__c = 'Graduate',
                Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue(),
                Intended_Program__c =  p1.Id,
                Intended_Term_of_Entry__c = at3.Id);
        insert app2;

        Opportunity opp2 = new Opportunity(Name='Test Opp Two', Application__c = app2.Id, Academic_Program__c = p1.Id, Academic_Term__c = at3.Id, School_College__c = 'Graduate',
                Contact__c = app.Contact__c, StageName = 'File Closed', Stage_Detail__c = 'App Submitted - File Closed', CloseDate = Date.today());
        insert opp2;

    }

    static testMethod void cloneOpportunityTest() {
        Opportunity opp = [SELECT Id FROM Opportunity where Name='Test Opp'];

        Opportunity newOpp = null;

        Test.startTest();
        newOpp = OpportunityCloneController.cloneOpportunity(opp.Id);
        Test.stopTest();

        System.assert(newOpp != null);
        System.assertEquals(null, newOpp.Application__c);
        System.assertEquals('File Closed', newOpp.StageName);
        System.assertEquals('ST - Switching Terms', newOpp.Withdrawal_Reason__c);
        System.assertEquals('App Submitted - File Closed', newOpp.Stage_Detail__c);
        System.assert(newOpp.Opportunity_Key__c.endsWith('.Cloned'));

    }

    static testMethod void cloneClosedOpportunityTest() {
        Opportunity opp = [SELECT Id FROM Opportunity where Name='Test Opp Two'];

        Opportunity newOpp = null;

        opp.StageName = 'File Closed';
        opp.Stage_Detail__c = 'App Submitted - File Closed';
        update opp;

        Test.startTest();
        newOpp = OpportunityCloneController.cloneOpportunity(opp.Id);
        Test.stopTest();

        System.assert(newOpp != null);
        System.assertEquals(null, newOpp.Application__c);
        System.assertEquals('File Closed', newOpp.StageName);
        System.assertEquals('ST - Switching Terms', newOpp.Withdrawal_Reason__c);
        System.assertEquals('App Submitted - File Closed', newOpp.Stage_Detail__c);
        System.assert(newOpp.Opportunity_Key__c.endsWith('.Cloned'));

    }

    static testMethod void updateApplicationTest() {
        Opportunity opp = [SELECT Id, Name, Academic_Term__c, Application__c, Application__r.Intended_Term_of_Entry__c FROM Opportunity where Name='Test Opp'];
        Academic_Term__c at = [SELECT Id FROM Academic_Term__c WHERE Name = 'test 2'];
        opp.Academic_Term__c = at.Id;
        update opp;

        Test.startTest();
        OpportunityCloneController.updateApplication(opp.Id);
        Test.stopTest();

        Opportunity oppUpdate = [SELECT Id, Name, Academic_Term__c, Application__c, Application__r.Intended_Term_of_Entry__c FROM Opportunity where Id=:opp.Id];
        System.assertEquals(at.Id, oppUpdate.Academic_Term__c);
        System.assertEquals(oppUpdate.Academic_Term__c, oppUpdate.Application__r.Intended_Term_of_Entry__c);
    }

}