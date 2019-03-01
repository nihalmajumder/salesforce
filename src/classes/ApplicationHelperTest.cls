@isTest
public class ApplicationHelperTest {
	
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

        Contact studentResident = new Contact(LastName='TestLast', FirstName = 'TestFirst', Email = 'TestContact@example.bethel.com', MailingStateCode = 'MN');
        insert studentResident;

        Contact student = new Contact(LastName='TestLast2', FirstName = 'TestFirst2', Email = 'TestContact2@example.bethel.com', MailingStateCode = 'WI');
        insert student;

        List<Application__c> apps = new List<Application__c>();

        Application__c undergrad = new Application__c(
			Contact__c=studentResident.Id,
			School_College__c = 'Undergraduate',
			Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue(),
			Intended_Program__c =  p3.Id,
			Intended_Term_of_Entry__c = at.Id);

            apps.add(undergrad);


        Application__c undergradTransfer = new Application__c(
			Contact__c=student.Id,
			School_College__c = 'Undergraduate',
			Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue(),
			Intended_Program__c =  p3.Id,
            Is_Transfer_Student__c = 'Yes',
			Intended_Term_of_Entry__c = at.Id);

            apps.add(undergradTransfer);

        Application__c undergradIsApplyingForPSEO = new Application__c(
			Contact__c=student.Id,
			School_College__c = 'Undergraduate',
			Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue(),
			Intended_Program__c =  p3.Id,
            Is_Applying_For_PSEO__c = 'Yes',
			Intended_Term_of_Entry__c = at.Id);

            apps.add(undergradIsApplyingForPSEO);


            Application__c adultUndergradCollege = new Application__c(
			Contact__c=studentResident.Id,
            College_Credits_Transferred__c = 'No transfer credits',
			School_College__c = 'Adult Undergraduate',
			Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue(),
			Intended_Program__c =  p3.Id,
			Intended_Term_of_Entry__c = at.Id);

            apps.add(adultUndergradCollege);

            Application__c adultUndergradCollegeCreditsTransferred1to30 = new Application__c(
			Contact__c=studentResident.Id,
            College_Credits_Transferred__c = '1-30 transfer credits',
			School_College__c = 'Adult Undergraduate',
			Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue(),
			Intended_Program__c =  p3.Id,
			Intended_Term_of_Entry__c = at.Id);

            apps.add(adultUndergradCollegeCreditsTransferred1to30);

            Application__c adultUndergradCollegeCreditsTransferred30Plus = new Application__c(
			Contact__c=student.Id,
            College_Credits_Transferred__c = 'More than 30 transfer credits',
			School_College__c = 'Adult Undergraduate',
			Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue(),
			Intended_Program__c =  p3.Id,
			Intended_Term_of_Entry__c = at.Id);

            apps.add(adultUndergradCollegeCreditsTransferred30Plus);

            Application__c graduate = new Application__c(
			Contact__c=student.Id,
			School_College__c = 'Graduate',
			Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue(),
			Intended_Program__c =  p3.Id,
			Intended_Term_of_Entry__c = at.Id);

             apps.add(graduate);

            Application__c seminary = new Application__c(
			Contact__c=student.Id,
			School_College__c = 'Seminary',
			Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue(),
			Intended_Program__c =  p3.Id,
			Intended_Term_of_Entry__c = at.Id);

             apps.add(seminary);

             insert apps;
	  
	}

	static testMethod void testUpdateFilters(){
		List<Application__c> apps = [SELECT Id, School_College__c, Is_Transfer_Student__c, Applicant_Type__c,
            Is_Applying_For_PSEO__c, College_Credits_Transferred__c,
            Student_Type__c, Residency__c, Contact__c, Contact__r.MailingStateCode FROM Application__c];
		ApplicationHelper.updateFilters(apps);

		for(Application__c app : apps){
			            if(app.School_College__c == 'Undergraduate'){
                if(app.Is_Transfer_Student__c == 'Yes'){
                    System.assertEquals('Transfer', app.Applicant_Type__c);
                }else if (app.Is_Applying_For_PSEO__c == 'Yes') {
                     System.assertEquals('PSEO', app.Applicant_Type__c);
                }else {
                    System.assertEquals('Freshman', app.Applicant_Type__c);
                }
            }else if(app.School_College__c == 'Adult Undergraduate'){
                if(app.College_Credits_Transferred__c != null){
                    if (app.College_Credits_Transferred__c == '1-30 transfer credits') {
                       System.assertEquals('Transfer', app.Applicant_Type__c);
                        System.assertEquals('Adult Transfer: Less than 30 Credits', app.Student_Type__c);
                    }
                    else if (app.College_Credits_Transferred__c == 'More than 30 transfer credits') {
                         System.assertEquals('Transfer', app.Applicant_Type__c);
                       System.assertEquals('Adult Transfer: More than 30 Credits', app.Student_Type__c);
                    }
                    else {
                        System.assertEquals('Freshman', app.Applicant_Type__c);
                        System.assertEquals('Adult', app.Student_Type__c);
                    }
                }
            }else if(app.School_College__c == 'Graduate'){
                System.assertEquals('Graduate', app.Applicant_Type__c);
            }

			if(app.Contact__r.MailingStateCode == 'MN'){
                System.assertEquals('Resident',  app.Residency__c);
            }else{
                 System.assertEquals('Non-Resident',  app.Residency__c);
            }
		}

	}

	static testMethod void testUpdateApplicantType(){
		for(Application__c app : [SELECT Id, School_College__c, Is_Transfer_Student__c, Applicant_Type__c,
            Is_Applying_For_PSEO__c, College_Credits_Transferred__c,
            Student_Type__c, Residency__c, Contact__c, Contact__r.MailingStateCode FROM Application__c]){
			
			ApplicationHelper.updateApplicantType(app);

			if(app.School_College__c == 'Undergraduate'){
                if(app.Is_Transfer_Student__c == 'Yes'){
                    System.assertEquals('Transfer', app.Applicant_Type__c);
                }else if (app.Is_Applying_For_PSEO__c == 'Yes') {
                     System.assertEquals('PSEO', app.Applicant_Type__c);
                }else {
                    System.assertEquals('Freshman', app.Applicant_Type__c);
                }
            }else if(app.School_College__c == 'Adult Undergraduate'){
                if(app.College_Credits_Transferred__c != null){
                    if (app.College_Credits_Transferred__c == '1-30 transfer credits') {
                       System.assertEquals('Transfer', app.Applicant_Type__c);
                        System.assertEquals('Adult Transfer: Less than 30 Credits', app.Student_Type__c);
                    }
                    else if (app.College_Credits_Transferred__c == 'More than 30 transfer credits') {
                         System.assertEquals('Transfer', app.Applicant_Type__c);
                       System.assertEquals('Adult Transfer: More than 30 Credits', app.Student_Type__c);
                    }
                    else {
                        System.assertEquals('Freshman', app.Applicant_Type__c);
                        System.assertEquals('Adult', app.Student_Type__c);
                    }
                }
            }else if(app.School_College__c == 'Graduate'){
                System.assertEquals('Graduate', app.Applicant_Type__c);
            }

		}
	}

	static testMethod void testUpdateResidency(){
		for(Application__c app : [SELECT Id, School_College__c, Is_Transfer_Student__c, Applicant_Type__c,
            Is_Applying_For_PSEO__c, College_Credits_Transferred__c,
            Student_Type__c, Residency__c, Contact__c, Contact__r.MailingStateCode FROM Application__c]){
			ApplicationHelper.updateResidency(app, app.Contact__r);

			 if(app.Contact__r.MailingStateCode == 'MN'){
                System.assertEquals('Resident',  app.Residency__c);
            }else{
                 System.assertEquals('Non-Resident',  app.Residency__c);
            }

		}
	}
}