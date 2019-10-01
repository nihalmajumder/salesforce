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

    public CampaignRFIFormController(ApexPages.StandardController controller) {

        String campaign_id = ApexPages.currentPage().getParameters().get('CampaignId');
        rfi_campaign = [SELECT Id, RFI_Version__c, Source_Type__c, Source_Detail__c, School__c FROM Campaign WHERE Id=:campaign_id];
        campaign_school = rfi_campaign.School__c;
        interaction = new Interaction__c(Mailing_Country__c='United States',
                                        Interaction_Source__c='Webform',
                                        Campaign__c=campaign_id,
                                        Campaign_Member_Status__c='Responded',
                                        Lead_Source__c=rfi_campaign.Source_Type__c,
                                        Source_Detail__c=rfi_campaign.Source_Detail__c
        );

    }

    public List<SelectOption> getPrograms() {

        System.debug('--------------------------------');
        System.debug(school);
        System.debug('--------------------------------');

//        Program__c[] programs = [select Id, Name from Program__c where School_College__c = :school and Active__c=true];

        Intended_Program_Term__c[] itps =  [select Id, Intended_Program__r.Name, Intended_Program__c,
                Academic_Term__r.Term_Description__c from Intended_Program_Term__c
                where School_College__c=:school and Intended_Program__r.Active__c=true
                order by Intended_Program__r.Name asc];

        List<SelectOption> stOptions = new List<SelectOption>();
        for(Intended_Program_Term__c ipt : itps){
            stOptions.add(new SelectOption(ipt.Intended_Program__c, ipt.Intended_Program__r.Name));
        }
        return stOptions;
    }

    public List<SelectOption> getSchools() {
        List<SelectOption> stOptions = new List<SelectOption>();
        stOptions.add(new SelectOption('None','--None--'));
        stOptions.add(new SelectOption('Graduate','Graduate'));
        stOptions.add(new SelectOption('Adult Undergraduate','Adult Undergraduate'));
        stOptions.add(new SelectOption('Seminary','Seminary'));
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


    public PageReference save(){

        try{

            if(rfi_campaign.School__c=='CAS'){
                interaction.School_College__c = 'Undergraduate';
                interaction.High_School_Graduation_Year__c = grad_year;
            }else{
                interaction.Academic_Program__c = program;
                interaction.School_College__c = school;
            }


            insert interaction;
            // just for testing, redirect to the interaction
            PageReference home = new PageReference('https://bethel-university--partial.lightning.force.com/'+interaction.Id);
            home.setRedirect(true);
            return home;
        }

        catch (Exception ex) {
            ApexPages.addMessages(ex);
            system.debug(ex);
            return null;
        }
    }

}