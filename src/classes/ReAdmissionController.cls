public class ReAdmissionController {

    public Application_Control__c appControl {get; set;}
    public ReAdmissionRequest request {get; set;}
    public Blob resumeBody {get; set;}
    public String resumeName {get; set;}
    public List<SelectOption> programOptions {get; set;}
    public List<SelectOption> termOptions {get; set;}
    public Case createdCase {get; set;}
    public String caseNumber {get; set;}
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
	
            List<Academic_Term__c> terms = [SELECT Id, Name, Term__r.Term_Description__c FROM Academic_Term__c WHERE ID IN (SELECT Academic_Term__c FROM Intended_Program_Term__c WHERE Intended_Program__r.School_College__c = :request.school AND Intended_Program__r.Active__c = true AND Academic_Term__r.Term__r.hed__Start_Date__c >= TODAY AND Academic_Term__r.Term__r.hed__Start_Date__c <= NEXT_N_DAYS:365) ORDER BY Term__r.hed__Start_Date__c];
            termOptions = new List<SelectOption>();
            termOptions.add(new SelectOption('','--None--'));
            for (Academic_Term__c t : terms) {
                termOptions.add(new SelectOption(t.Term__r.Term_Description__c, t.Term__r.Term_Description__c));
            }
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
                    ReAdmissionHelper.updateContact(request.theContact, theContact);
                    if (request.hasOtherName == 'Yes') {
                        theContact.Former_Last_Name__c = request.otherName;
                    }
                    update theContact;
                    Id theCohortId = ReAdmissionHelper.findCohort(theContact.Id);
                    Case theCase = ReAdmissionHelper.createCase(theContact, request, theCohortId);
                    insert theCase;
                    ReAdmissionHelper.assignCase(theCase);
                    update theCase;
                    this.createdCase = theCase;
                    this.createdCase = [SELECT Id, CaseNumber FROM Case WHERE Id = :theCase.Id];
                    this.caseNumber = this.createdCase.CaseNumber;
                    if (String.isNotBlank(request.employerName)) {
                        ReAdmissionHelper.createEmploymentHistory(theContact, request.employerName, request.employerAddress, request.responsibilities);
                    }

                    if (resumeBody != null) {
                        ReAdmissionHelper.attachDocument(createdCase, resumeBody, resumeName);
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
            if (resumeBody != null) {
                ReAdmissionHelper.attachDocument(createdCase, resumeBody, resumeName);
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
        if (request.program == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Program must not be blank.'));
            isValid = false;
        }
        if (String.isBlank(request.term)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Begin time must not be blank.'));
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
        return isValid;
    }

    public class ReAdmissionRequest {
        public Contact theContact {get; set;}
        public String school {get; set;}
        public String financialAid {get; set;}
        public String hasChanged {get; set;}
        public Id program {get; set;}
        public String term {get; set;}
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
    }

}