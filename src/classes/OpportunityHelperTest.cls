/**
* Created by Luke Vang ( Contractor ) on 2019-02-28.
*/
@isTest
public class OpportunityHelperTest {

    @TestSetup
    static void testSetup(){

       //create trigger handler record
         hed__Trigger_Handler__c handler = new hed__Trigger_Handler__c();
         handler.Name = 'TDTM_Opportunity_Create_Case_On_Confirm';
         handler.hed__Class__c = 'TDTM_Opportunity_Create_Case_On_Confirm';
         handler.hed__Object__c = 'Opportunity';
         handler.hed__Trigger_Action__c = 'AfterUpdate';
         handler.hed__Active__c = true;
         handler.hed__Load_Order__c = 1;

         insert handler;

        handler = new hed__Trigger_Handler__c();
        handler.Name = 'TDTM_Documents_Missing_All';
        handler.hed__Class__c = 'TDTM_Documents_Missing_All';
        handler.hed__Object__c = 'Opportunity';
        handler.hed__Trigger_Action__c = 'BeforeUpdate';
        handler.hed__Active__c = true;
        handler.hed__Load_Order__c = 2;

        insert handler;

        handler = new hed__Trigger_Handler__c();
        handler.Name = 'TDTM_Documents_Missing_AD';
        handler.hed__Class__c = 'TDTM_Documents_Missing_AD';
        handler.hed__Object__c = 'Test_Score__c';
        handler.hed__Trigger_Action__c = 'AfterInsert;AfterUpdate;AfterDelete';
        handler.hed__Active__c = true;
        handler.hed__Load_Order__c = 1;

        insert handler;

        handler = new hed__Trigger_Handler__c();
        handler.Name = 'TDTM_Application_Internal_Requirements';
        handler.hed__Class__c = 'TDTM_Application_Internal_Requirements';
        handler.hed__Object__c = 'Application__c';
        handler.hed__Trigger_Action__c = 'AfterUpdate';
        handler.hed__Active__c = true;
        handler.hed__Load_Order__c = 2;

        insert handler;


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

        Program__c p1 = new Program__c(Name = 'test1', Number_of_Applications_Limit__c = 'One Application', Applicant_Type__c = Program__c.Applicant_Type__c.getDescribe().getPicklistValues()[0].getValue());
        Program__c p2 = new Program__c(Name = 'test2', Number_of_Applications_Limit__c = 'One Application Per Term', Hide_Applicant_Type__c = Program__c.Hide_Applicant_Type__c.getDescribe().getPicklistValues()[0].getValue());
        Program__c p3 = new Program__c(Name = 'test3', Number_of_Applications_Limit__c = 'One Application Per Program', Hide_Student_Type__c = Program__c.Hide_Student_Type__c.getDescribe().getPicklistValues()[0].getValue());
        Program__c p4 = new Program__c(Name = 'test4', Hide_Citizenship__c = Program__c.Hide_Citizenship__c.getDescribe().getPicklistValues()[0].getValue());
        Program__c p5 = new Program__c(Name = 'test5');
        insert new List<Program__c>{p1, p2, p3, p4, p5};

        Intended_Program_Term__c ipt = new Intended_Program_Term__c(Academic_Term__c = at.Id, Activate_Application_Date__c = Date.TODAY().addDays(-1), End_Application_Date__c = Date.TODAY().addDays(-1), Applicant_Type__c = Intended_Program_Term__c.Applicant_Type__c.getDescribe().getPicklistValues()[0].getValue());
        insert ipt;

        Account acc = new Account(Name='NewAcc');
        insert acc;

        Contact student = new Contact(LastName='TestLast', FirstName = 'TestFirst', Email = 'TestContact@example.bethel.com');
        insert student;

        Application__c app = new Application__c(
            Contact__c=student.Id,
            School_College__c = 'Graduate',
            Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue(),
            Intended_Program__c =  p3.Id,
            Intended_Term_of_Entry__c = at.Id);
        insert app;

        Opportunity opp = new Opportunity(Name='Test Opp', Application__c = app.Id, Academic_Program__c = p3.Id, Academic_Term__c = at.Id, School_College__c = 'Graduate',
            Contact__c = app.Contact__c, StageName = 'Applied', Stage_Detail__c = 'App Submitted', CloseDate = Date.today());
        insert opp;

        Test_Score__c ts = new Test_Score__c(Test_Type__c='ACT', Contact__c=student.Id);
        insert ts;

        Admissions_Document__c ad = new Admissions_Document__c(Contact__c=student.Id);
        insert ad;

        Education_History__c eh = new Education_History__c(Contact__c=student.Id);
        insert eh;

    }

    static testMethod void testCreateCaseOnConfirmedPROVISIONALTYPE(){
        Opportunity opp = [SELECT id, StageName, School_College__c, Admission_Type__c  FROM Opportunity];
        System.assertEquals(0, [SELECT COUNT() FROM Case WHERE Subject LIKE 'Provisional Acceptance%']);
        opp.StageName = 'Applied';
        opp.Stage_Detail__c = 'App Completed';
        update opp;
        opp.StageName = 'Accepted';
        opp.Stage_Detail__c = 'Accepted';
        update opp;
        Test.startTest();
        opp.StageName = 'Confirmed';
        opp.Stage_Detail__c = 'Registered';
        opp.Admission_Type__c = 'Provisional';
        opp.School_College__c = 'Graduate';
        update opp;
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM Case WHERE Subject LIKE 'Provisional Acceptance%']);
    }

    static testMethod void testCreateCaseOnConfirmedCONDITIONALTYPE(){
        Opportunity opp = [SELECT id, StageName, School_College__c, Admission_Type__c  FROM Opportunity];
        System.assertEquals(0, [SELECT COUNT() FROM Case WHERE Subject LIKE 'Conditional Acceptance%']);
        opp.StageName = 'Applied';
        opp.Stage_Detail__c = 'App Completed';
        update opp;
        opp.StageName = 'Accepted';
        opp.Stage_Detail__c = 'Accepted';
        update opp;
        Test.startTest();
        opp.StageName = 'Confirmed';
        opp.Stage_Detail__c = 'Registered';
        opp.Admission_Type__c = 'Conditional';
        opp.School_College__c = 'Graduate';
        update opp;
        Test.stopTest();
        System.debug([SELECT COUNT() FROM Case]);
        System.assertEquals(1, [SELECT COUNT() FROM Case WHERE Subject LIKE 'Conditional Acceptance%']);
    }

    static testMethod void testCreateCaseOnConfirmedPROVISIONALANDCONDITIONALTYPE(){
        Opportunity opp = [SELECT id, StageName, School_College__c, Admission_Type__c  FROM Opportunity];
        System.assertEquals(0, [SELECT COUNT() FROM Case WHERE  (Subject LIKE 'Conditional Acceptance%' OR Subject LIKE 'Provisional Acceptance%')]);
        opp.StageName = 'Applied';
        opp.Stage_Detail__c = 'App Completed';
        update opp;
        opp.StageName = 'Accepted';
        opp.Stage_Detail__c = 'Accepted';
        update opp;
        Test.startTest();
        opp.StageName = 'Confirmed';
        opp.Stage_Detail__c = 'Registered';
        opp.Admission_Type__c = 'Conditional and Provisional';
        opp.School_College__c = 'Graduate';
        update opp;
        Test.stopTest();
        System.assertEquals(2, [SELECT COUNT() FROM Case WHERE (Subject LIKE 'Conditional Acceptance%' OR Subject LIKE 'Provisional Acceptance%')]);
    }

    static testMethod void getOpportunitiesForApplicationTest() {
        Application__c app = [SELECT Id FROM Application__c];

        List<Opportunity> opps = null;
        Test.startTest();
        opps = OpportunityHelper.getOpportunitiesForApplication(app.Id);
        Test.stopTest();

        System.assert(opps != null);
        System.assertEquals(1, opps.size());
    }

    static testMethod void getOpportunitiesWithCouselorForApplicationTest() {
        Application__c app = [SELECT Id FROM Application__c];

        List<Opportunity> opps = null;
        Test.startTest();
        opps = OpportunityHelper.getOpportunitiesWithCouselorForApplication(app.Id);
        Test.stopTest();

        System.assert(opps != null);
        System.assertEquals(1, opps.size());
    }

    static testMethod void getOpportunitiesForKeysTest() {
        Opportunity opp = [SELECT id, StageName, Stage_Detail__c, School_College__c, Admission_Type__c, Opportunity_Key__c  FROM Opportunity];

        Map<String, Opportunity> opps = null;
        Test.startTest();
        opps = OpportunityHelper.getOpportunitiesForKeys(new Set<String>{opp.Opportunity_Key__c});
        Test.stopTest();

        System.assert(opps != null);
        System.assertEquals(1, opps.size());
        System.assert(opps.get(opp.Opportunity_Key__c) != null);
    }

    static testMethod void updateOpportunityStatusAppCompletedTest(){
        Opportunity opp = [SELECT id, StageName, Stage_Detail__c, School_College__c, Admission_Type__c  FROM Opportunity];
        Application__c app = [SELECT Id FROM Application__c];

        Test.startTest();
        OpportunityHelper.updateOpportunityStatusAppCompleted(app.Id);
        Test.stopTest();

        Opportunity updatedOpp = [SELECT id, StageName, Stage_Detail__c, School_College__c, Admission_Type__c  FROM Opportunity];
        System.assert(updatedOpp != null);
        System.assertEquals('Applied', updatedOpp.StageName);
        System.assertEquals('App Completed', updatedOpp.Stage_Detail__c);

    }

    static testMethod void updateTestScore(){

        Test_Score__c ts = [Select Id, Contact__c from Test_Score__c];

        Test.startTest();
        Test_Score__c ts_conditional = new Test_Score__c(Test_Type__c='ACT', Contact__c=ts.Contact__c, Document_Status__c = 'Conditional');
        insert ts_conditional;

        System.debug('-------------------------------------');
        System.debug(ts);
        System.debug(ts.Contact__c);
        List<Opportunity> opportunities = [SELECT Id, Documents_Missing__c, StageName, Stage_Detail__c, Contact__c FROM Opportunity WHERE StageName = 'Applied' AND Contact__c = :ts.Contact__c];
        System.debug(opportunities);
        System.debug('-------------------------------------');

        ts.Document_Status__c = 'Conditional';

        update ts;

        delete ts;
    }

    static testMethod void updateAdmissionsDocument(){

        Admissions_Document__c ad = [Select Id, Contact__c from Admissions_Document__c];

        Test.startTest();
        Admissions_Document__c ad_conditional = new Admissions_Document__c(Contact__c=ad.Contact__c);
        insert ad_conditional;

        System.debug('-------------------------------------');
        System.debug(ad);
        System.debug(ad.Contact__c);
        List<Opportunity> opportunities = [SELECT Id, Documents_Missing__c, StageName, Stage_Detail__c, Contact__c FROM Opportunity WHERE StageName = 'Applied' AND Contact__c = :ad.Contact__c];
        System.debug(opportunities);
        System.debug('-------------------------------------');

        ad.Status__c = 'Conditional';

        update ad;

        delete ad;
    }

    static testMethod void updateEdHistory(){
        Education_History__c eh = [select Id, Contact__c from Education_History__c];
        Test.startTest();
        Education_History__c eh_conditional = new Education_History__c(Contact__c=eh.Contact__c);
        insert eh_conditional;
        List<Opportunity> opportunities = [SELECT Id, Documents_Missing__c, StageName, Stage_Detail__c, Contact__c FROM Opportunity WHERE StageName = 'Applied' AND Contact__c = :eh.Contact__c];

        eh.Document_Status__c = 'Conditional';

        update eh;

        delete eh;

    }


    static testMethod  void updateApplicationRequirements(){
        Application__c app = [Select Id, GPA_30_Prerequisite__c from Application__c];
        app.Application_Status__c = 'Submitted';
        app.GPA_30_Prerequisite__c = 'Conditional';
        update app;


    }



}