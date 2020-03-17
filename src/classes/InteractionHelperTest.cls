@isTest
public  class InteractionHelperTest {
	
	@TestSetup
	static void testSetup(){
	  //setup application data

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
			School_College__c = 'Undergraduate',
			Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue(),
			Intended_Program__c =  p3.Id,
			Intended_Term_of_Entry__c = at.Id);
        insert app;

	}

	static testMethod void testCreateInteractionForNewApplication(){
		Application__c app = [SELECT id, Contact__c, School_College__c, Intended_Program__c, Intended_Term_of_Entry__c FROM Application__c];
		//no interactions
		System.assertEquals(0, [SELECT COUNT() FROM Interaction__c]);
		test.startTest();
		InteractionHelper.createInteractionForNewApplication(app);
		test.stopTest();
		//1 new interaction created
		System.assertEquals(1, [SELECT COUNT() FROM Interaction__c]);
	}

	static testMethod void testCreateInteractionForSubmittedApplication(){
		Application__c app = [SELECT id, Contact__c, School_College__c, Intended_Program__c, Intended_Term_of_Entry__c FROM Application__c];
		Opportunity opp = new Opportunity(Name='Test Opp', Application__c = app.Id, Contact__c = app.Contact__c, StageName = 'Applied', Stage_Detail__c = 'App Submitted', CloseDate = Date.today());
		insert opp;
		//no interactions
		System.assertEquals(0, [SELECT COUNT() FROM Interaction__c]);
		test.startTest();
		InteractionHelper.createInteractionForSubmittedApplication(app.Id);
		test.stopTest();
		//1 new interaction created
		System.assertEquals(1, [SELECT COUNT() FROM Interaction__c]);
	}

	static testMethod void testCreateInteractionForChangedApplication(){
		Application__c app = [SELECT id, Contact__c, School_College__c, Intended_Program__c, Intended_Term_of_Entry__c FROM Application__c];
		Opportunity opp = new Opportunity(Name='Test Opp', Application__c = app.Id, Contact__c = app.Contact__c, StageName = 'Applied', Stage_Detail__c = 'App Submitted', CloseDate = Date.today());
		insert opp;
		//no interactions
		System.assertEquals(0, [SELECT COUNT() FROM Interaction__c]);
		test.startTest();
		InteractionHelper.createInteractionForChangedApplication(app);
		test.stopTest();
		//1 new interaction created
		System.assertEquals(1, [SELECT COUNT() FROM Interaction__c]);
	}

	static testMethod void testCreateInteractionForChangedApplications(){
		Application__c app = [SELECT id, Contact__c, School_College__c, Intended_Program__c, Intended_Term_of_Entry__c FROM Application__c];
		Opportunity opp = new Opportunity(Name='Test Opp', Application__c = app.Id, Contact__c = app.Contact__c, StageName = 'Applied', Stage_Detail__c = 'App Submitted', CloseDate = Date.today());
		insert opp;
		//no interactions
		System.assertEquals(0, [SELECT COUNT() FROM Interaction__c]);
		test.startTest();
		InteractionHelper.createInteractionForChangedApplication(new List<Application__c> { app });
		test.stopTest();
		//1 new interaction created
		System.assertEquals(1, [SELECT COUNT() FROM Interaction__c]);
	}

	static testMethod void testGetAcademicTerm(){
		Academic_Term__c term = [SELECT id FROM Academic_Term__c];
		Academic_Term__c result;
		test.startTest();
		result = InteractionHelper.getAcademicTerm(term.Id);
		test.stopTest();
		System.assertEquals(term.Id, result.Id);
	}	

	static testMethod void testGetApplication(){
		Application__c app = [SELECT id FROM Application__c];
		Application__c result;
		test.startTest();
		result = InteractionHelper.getApplication(app.Id);
		test.stopTest();
		System.assertEquals(app.Id, result.Id);
	}

	static testMethod void testGetOpportunityForApplication(){
		Application__c app = [SELECT id, Contact__c, School_College__c, Intended_Program__c, Intended_Term_of_Entry__c FROM Application__c];
		Opportunity opp = new Opportunity(Name='Test Opp', Application__c = app.Id, Contact__c = app.Contact__c, StageName = 'Applied', Stage_Detail__c = 'App Submitted', CloseDate = Date.today());
		insert opp;
		Opportunity result;
		test.startTest();
		result = InteractionHelper.getOpportunityForApplication(app.Id);
		test.stopTest();
		System.assertEquals(opp.Id, result.Id);
	}
}