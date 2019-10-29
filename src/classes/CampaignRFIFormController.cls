/**
 * Created by ejc84332 on 2019-08-08.
 */

public with sharing class CampaignRFIFormController {


    public Interaction__c interaction {get; set;}
    public Campaign rfi_campaign {get; set;}
    public String campaign_school {get; set;}
    public String grad_year {get; set;}
    public String program {get; set;}
    public String school {get; set;}
    public Boolean show_popup {get; set;}
    public String current_page {get; set;}

    public CampaignRFIFormController(ApexPages.StandardController controller) {

        String campaign_id = ApexPages.currentPage().getParameters().get('CampaignId');
        rfi_campaign = [SELECT Id, RFI_Version__c, Source_Type__c, Source_Detail__c, School__c, RFI_Attributes__c FROM Campaign WHERE Id=:campaign_id];
        campaign_school = rfi_campaign.School__c;
        show_popup = false;
        current_page = ApexPages.currentPage().getUrl();
        interaction = new Interaction__c(Mailing_Country__c='United States',
                                        Interaction_Source__c='Webform',
                                        Campaign__c=campaign_id,
                                        Campaign_Member_Status__c='Responded',
                                        Preferred_Phone__c='Mobile',
                                        Lead_Source__c=rfi_campaign.Source_Type__c,
                                        Source_Detail__c=rfi_campaign.Source_Detail__c,
                                        Interaction_Status__c='Imported' // set to imported at first, so we can change to new and process in a @future method
        );
        if(rfi_campaign.RFI_Attributes__c != null) {

            if (rfi_campaign.RFI_Attributes__c.contains('Legacy')) {
                interaction.Is_Legacy__c = 'Yes';
            }

            if (rfi_campaign.RFI_Attributes__c.contains('Military / Veteran')) {
                // interaction.Is_Legacy__c = 'Yes';
            }
        }
    }

    public List<SelectOption> getPrograms() {

        System.debug('--------------------------------');
        System.debug(school);
        System.debug('--------------------------------');

//        Program__c[] programs = [select Id, Name from Program__c where School_College__c = :school and Active__c=true];

        List<SelectOption> stOptions = new List<SelectOption>();

        if(school == null){
            stOptions.add(new SelectOption('None','--None--'));
        }else{
            Program__c[] programs =  [select Id, Name from Program__c where School_College__c=:school and Active__c=true order by Name asc];


            for(Program__c program : programs){
                stOptions.add(new SelectOption(program.Id, program.Name));
            }
        }

        return stOptions;
    }

    public List<SelectOption> getGrad_years() {
        List<SelectOption> stOptions = new List<SelectOption>();
        stOptions.add(new SelectOption('None','--None--'));

        for( Integer year = System.today().year()-2; year < System.today().year()+10; year++   ){
            String yr = String.valueOf(year);
            stOptions.add(new SelectOption(yr, yr));
        }

        return stOptions;
    }

    public List<SelectOption> getSchoolOptions() {

        List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption('Graduate', 'Graduate School - for professionals interested in a masters or doctoral degree.'));
        options.add(new SelectOption('Seminary', 'Seminary - for those who are interested in ministry or theological study.'));
        options.add(new SelectOption('Adult Undergraduate', 'Adult Undergraduate - for working adults interested in completing their undergrad degree.'));

        return options;

    }

    public PageReference reloadPage(){
        PageReference page = new PageReference('/admissions/CampaignRFIForm?CampaignId='+rfi_campaign.Id);

        page.setRedirect(true);
        return page;


    }

    @Future
    private static void update_interaction(Id int_id){
        Interaction__c i = [Select Id, Interaction_Status__c from Interaction__c where Id=:int_id];
        if(i.Interaction_Status__c != 'New'){
            i.Interaction_Status__c='New';
            update i;
        }

    }

    public void save(){

        try{

//            if(rfi_campaign.School__c=='CAS'){
//                interaction.School_College__c = 'Undergraduate';
//                interaction.High_School_Graduation_Year__c = grad_year;
//            }else{
//                interaction.Academic_Program__c = program;
//                interaction.School_College__c = school;
//            }


//            insert interaction;
            // just for testing, redirect to the interaction

//            update_interaction(interaction.Id);
//
//            PageReference home = new PageReference('https://bethel-university--partial.lightning.force.com/'+interaction.Id);
//            home.setRedirect(true);
//            return home;
            show_popup = true;


        }

        catch (Exception ex) {
            ApexPages.addMessages(ex);
            system.debug(ex);
//            return null;
        }
    }

}