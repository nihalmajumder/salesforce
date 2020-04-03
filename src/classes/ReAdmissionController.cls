public class ReAdmissionController {

    public Application_Control__c appControl {get; set;}
    public ReAdmissionRequest request {get; set;}
    public transient String resumeBody {get; set;}
    public transient String resumeName {get; set;}
    public List<SelectOption> programOptions {get; set;}
    public List<SelectOption> termOptions {get; set;}
    public List<SelectOption> deliveryFormatOptions {get; set;}
    public Case createdCase {get; set;}
    public String caseNumber {get; set;}
    public Id caseId {get; set;}
    public Boolean resumeUploaded {get; set;}

    public ReAdmissionController() {
        request = new ReAdmissionRequest();
        List <Application_Control__c> acs = [SELECT Id, Hide_Term_Program__c, Application_Start_Status__c, Allow_Cancel_From__c, Allow_Submit_From__c, Allow_Withdraw_From__c, Arrow_Color__c, Button_Color__c, Button_Text_Color__c, Cancel_Status__c, Line_Color__c, Link_Color__c, Logo_Static_Resource__c, Logo_Static_Resource_Path__c, Submit_Status__c, Withdraw_Status__c, Text_Color__c, URL_Parameter__c, Default__c, 	Started_Status_Help_Text__c, Submitted_Status_Help_Text__c FROM Application_Control__c WHERE Active__c = true AND Default__c = true];
        if (!acs.isEmpty()) appControl = acs[0];
        programOptions = new List<SelectOption>();
        this.resumeUploaded = false;
    }

    public PageReference changeSchool() {
        if (request.school != null) {
            List<Program__c> programs = [SELECT Id, Name, Academic_Program__c FROM Program__c WHERE School_College__c = :request.school AND Active__c = true AND Academic_Program__c != null ORDER BY Name ASC];
            programOptions = new List<SelectOption>();
            programOptions.add(new SelectOption('','--None--'));
            for (Program__c p : programs) {
                programOptions.add(new SelectOption(p.Academic_Program__c, p.Name));
            }
	
            List<Academic_Term__c> terms = [SELECT Id, Name, Term__r.Term_Description__c FROM Academic_Term__c WHERE ID IN (SELECT Academic_Term__c FROM Intended_Program_Term__c WHERE Intended_Program__r.School_College__c = :request.school AND Intended_Program__r.Active__c = true AND Academic_Term__r.Term__r.hed__End_Date__c >= TODAY AND Academic_Term__r.Term__r.hed__Start_Date__c <= NEXT_N_DAYS:365) ORDER BY Term__r.hed__Start_Date__c];
            termOptions = new List<SelectOption>();
            termOptions.add(new SelectOption('','--None--'));
            termOptions.add(new SelectOption('As Soon As Possible','As Soon As Possible'));
            for (Academic_Term__c t : terms) {
                termOptions.add(new SelectOption(t.Term__r.Term_Description__c, t.Term__r.Term_Description__c));
            }

            deliveryFormatOptions = new List<SelectOption>();
            deliveryFormatOptions.add(new SelectOption('','--None--'));
            deliveryFormatOptions.add(new SelectOption('Face-to-Face','Face-to-Face'));
            deliveryFormatOptions.add(new SelectOption('Online','Online'));
            deliveryFormatOptions.add(new SelectOption('Blended','Blended'));
        }
        return null;
    }

    public PageReference submit() {
        try {
            Boolean isValid = validate(this.request);
            if (isValid) {
                Contact theContact = ContactHelper.getContactFromBethelId(request.theContact.Banner_Id__c);
                if (theContact == null) {
                    //Interaction__c interaction = InteractionHelper.createInteraction(request.theContact.FirstName, request.theContact.LastName, request.theContact.Email, 'Re-enrollment');
                    //interaction = InteractionHelper.getInteraction(interaction.Id);
                    //if (interaction != null && interaction.Contact__c != null) {
                    //    theContact = ContactHelper.getContact(interaction.Contact__c);
                    //}
                    theContact = new Contact(
                        FirstName = request.theContact.FirstName, 
                        LastName = request.theContact.LastName, 
                        Email = request.theContact.Email
                    );
                    insert theContact;
                    theContact = ContactHelper.getContact(theContact.Id);
                }

                if (theContact != null) {
                    request.theContact.hed__Race__c = request.getRaceString();
                    String data = ReAdmissionHelper.createContactDataString(request, theContact);
                    ReAdmissionHelper.updateContact(request.theContact, theContact);
                    Id theCohortId = ReAdmissionHelper.findCohort(theContact.Id);
                    Case theCase = ReAdmissionHelper.createCase(theContact, request, theCohortId);
                    theCase.Re_enrollment_Answers__c = data;
                    insert theCase;
                    ReAdmissionHelper.assignCase(theCase);
                    update theCase;
                    this.createdCase = theCase;
                    this.createdCase = [SELECT Id, CaseNumber FROM Case WHERE Id = :theCase.Id];
                    this.caseNumber = this.createdCase.CaseNumber;
                    this.caseId = this.createdCase.Id;
                    if (String.isNotBlank(request.employerName)) {
                        ReAdmissionHelper.createEmploymentHistory(theContact, request.employerName, request.employerAddress, request.responsibilities);
                    }

                }
                else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Unable to find or create Contact.'));
                }
            }
        }
        catch (Exception e) {
            System.debug(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getMessage()));
        }
        return null;
    }

    public PageReference upload() {
        try {
            if (resumeBody != null && resumeName != null && caseId != null) {
                Blob data = EncodingUtil.base64Decode(resumeBody.substringAfter(','));
                ReAdmissionHelper.attachDocument(caseId, data, resumeName);
                this.resumeUploaded = true;
            }
        }
        catch (Exception e) {
            System.debug(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getMessage()));
        }
        return null;
    }

    private Boolean validate(ReAdmissionRequest request) {
        Boolean isValid = true;
        if (!request.race.isEmpty()) {
            String concat = '';
            for (String s : request.race) {
                if (String.isBlank(concat)) {
                    concat += s;
                }
                else {
                    concat += ';' + s;
                }
            }
            request.theContact.hed__Race__c = concat;
        }
        if (String.isBlank(request.school)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'School must be selected.'));
            isValid = false;
        }
        if (String.isBlank(request.theContact.FirstName)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'First Name must not be blank.'));
            isValid = false;
        }
        if (String.isBlank(request.theContact.LastName)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Last Name must not be blank.'));
            isValid = false;
        }
        if (String.isBlank(request.theContact.Email)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Email must not be blank.'));
            isValid = false;
        }
        if (String.isBlank(request.theContact.MailingStreet)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Street must not be blank.'));
            isValid = false;
        }
        if (String.isBlank(request.theContact.MailingCity)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'City must not be blank.'));
            isValid = false;
        }
        if (String.isBlank(request.theContact.MailingStateCode)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'State must not be blank.'));
            isValid = false;
        }
        if (String.isBlank(request.theContact.MailingCountryCode)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Country must not be blank.'));
            isValid = false;
        }
        if (String.isBlank(request.theContact.MailingPostalCode)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'PostalCode must not be blank.'));
            isValid = false;
        }
        if (String.isBlank(request.theContact.Banner_Id__c)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Bethel ID# must not be blank.'));
            isValid = false;
        }
        if (String.isBlank(request.hasOtherName)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, '"Are you or have you ever been known by any other name?" must not be blank.'));
            isValid = false;
        }
        if (request.hasOtherName == 'Yes' && String.isBlank(request.otherName)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Other name must not be blank.'));
            isValid = false;
        }
        if (request.theContact.Citizenship__c == 'Not Citizen or Permanent Resident' && String.isBlank(request.theContact.Visa_Type_Code__c)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Intended Visa Status must not be blank.'));
            isValid = false;
        }
        if (request.theContact.Citizenship__c == 'Permanent Resident Alien' && String.isBlank(request.theContact.Alien_Registration_Number__c)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Alien Registration Number must not be blank.'));
            isValid = false;
        }
        if (request.theContact.Citizenship__c == 'Permanent Resident Alien' && request.theContact.Alien_Registration_Number_Date__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Alien Registration Number Date must not be blank.'));
            isValid = false;
        }
        if (request.theContact.Is_Veteran__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, '"Are you a veteran?" must not be blank.'));
            isValid = false;
        }
        if (request.program == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Program must not be blank.'));
            isValid = false;
        }
        if (String.isBlank(request.term)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Begin time must not be blank.'));
            isValid = false;
        }
        if (request.financialAid == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, '"Will you apply for financial aid?" must not be blank.'));
            isValid = false;
        }
        if (String.isBlank(request.hasBusinessOffice)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, '"Do you have a business office or collections hold?" must not be blank.'));
            isValid = false;
        }
        if (String.isBlank(request.hasChanged)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Has information changed must be selected.'));
            isValid = false;
        }
       if (request.school == 'Seminary' && request.compliance != true) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'You must acknowledge that you have read the Affirmation of Faith.'));
            isValid = false;
        }
        if ((request.school == 'Seminary' || request.school == 'Graduate') && String.isBlank(request.whyLeftEssay)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please provide a brief description of the reason you left the program.'));
            isValid = false;
        }
        if ((request.school == 'Seminary' || request.school == 'Graduate') && String.isBlank(request.whyBackEssay)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please provide a brief description of the reason this is the right time for you to return to complete your degree.'));
            isValid = false;
        }
        return isValid;
    }

    public class ReAdmissionRequest {
        public Contact theContact {get; set;}
        public String school {get; set;}
        public String financialAid {get; set;}
        public String hasChanged {get; set;}
        public Id program {get; set;}
        public String whenBegin {get; set;}
        public String term {get; set;}
        public String deliveryFormat {get; set;}
        public String academicRecord {get; set;}
        public String employerName {get; set;}
        public String employerAddress {get; set;}
        public String responsibilities {get; set;}
        public String hasOtherName {get; set;}
        public String otherName {get; set;}
        public String hasBusinessOffice {get; set;}
        public String whyLeftEssay {get; set;}
        public String whyBackEssay {get; set;}
        public List<String> race {get; set;}
        public Boolean compliance {get; set;}

        public ReAdmissionRequest() {
            theContact = new Contact();
            race = new List<String>();
            compliance = false;
        }

        public String getRaceString() {
            String raceString = null;
            if (race != null && !race.isEmpty()) {
                for (String s : race) {
                    if (raceString == null) {
                        raceString = s;
                    }
                    else {
                        raceString = raceString + ';' + s;
                    }
                }
            }
            return raceString;
        }
    }

    public PageReference loadCase() {
        String theId = ApexPages.currentPage().getParameters().get('Id');
        if (theId != null) {
            Case c = ReadmissionHelper.getCase(theId);
            this.request.theContact.FirstName = c.Contact.FirstName;
            this.request.theContact.MiddleName = c.Contact.MiddleName;
            this.request.theContact.LastName = c.Contact.LastName;
            this.request.theContact.Email = c.Contact.Email;
            this.request.theContact.MailingStreet = c.Contact.MailingStreet;
            this.request.theContact.MailingCity = c.Contact.MailingCity;
            this.request.theContact.MailingStateCode = c.Contact.MailingStateCode;
            this.request.theContact.MailingCountryCode = c.Contact.MailingCountryCode;
            this.request.theContact.MailingPostalCode = c.Contact.MailingPostalCode;
            this.request.theContact.HomePhone = c.Contact.HomePhone;
            this.request.theContact.MobilePhone = c.Contact.MobilePhone;
            this.request.theContact.hed__Gender__c = c.Contact.hed__Gender__c;
            this.request.theContact.hed__Race__c = c.Contact.hed__Race__c;
            this.request.theContact.hed__Social_Security_Number__c = c.Contact.hed__Social_Security_Number__c;
            this.request.theContact.hed__WorkPhone__c = c.Contact.hed__WorkPhone__c;
            this.request.theContact.Alien_Registration_Number__c = c.Contact.Alien_Registration_Number__c;
            this.request.theContact.Alien_Registration_Number_Date__c = c.Contact.Alien_Registration_Number_Date__c;
            this.request.theContact.Banner_Id__c = c.Contact.Banner_Id__c;
            this.request.theContact.Citizenship__c = c.Contact.Citizenship__c;
            this.request.theContact.Conviction_Description__c = c.Contact.Conviction_Description__c;
            this.request.theContact.Is_Hispanic__c = c.Contact.Is_Hispanic__c;
            this.request.theContact.Is_Veteran__c = c.Contact.Is_Veteran__c;
            this.request.theContact.Pled_Guilty__c = c.Contact.Pled_Guilty__c;
            this.request.theContact.Visa_Type_Code__c = c.Contact.Visa_Type_Code__c;
            this.request.school = c.School__c;
            this.request.program = c.Program__c;
            this.request.term = c.New_Term__c;
            this.request.deliveryFormat = c.Preferred_Delivery_Format__c;
            this.request.financialAid = c.Financial_Aid__c;
            this.request.hasBusinessOffice = c.Collection_Hold__c;
            this.request.hasChanged= c.Has_Information_Changed__c? 'Yes' : 'No';
            this.request.academicRecord = c.Academic_History__c;
            this.request.whyLeftEssay = c.Why_Left_Essay__c;
            this.request.whyBackEssay = c.Why_Returning_Essay__c;

            if (c.Contact.hed__Race__c != null) {
                for (String s : c.Contact.hed__Race__c.split(';')) {
                    this.request.race.add(s);
                }
            }

            Employment_History__c history = ReadmissionHelper.getEmploymentHistory(c.ContactId);
            if (history != null) {
                this.request.employerName = history.Employer_Name__c;
                this.request.employerAddress = history.Employer_Address__c;
                this.request.responsibilities = history.Responsibilities__c;
            }

            changeSchool();
        }
        return null;
    }

}