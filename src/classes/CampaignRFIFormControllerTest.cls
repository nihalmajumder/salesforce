/**
 * Created by ejc84332 on 2019-08-15.
 */

@isTest
public with sharing class CampaignRFIFormControllerTest {

    static Id recTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Events_and_Conferences').getRecordTypeId();

    static testMethod void testController(){

        Campaign rfi_campaign = new Campaign(RecordTypeId = recTypeId, Name='RFI Campaign Name', RFI_Version__c='Post-Trad', Source_Type__c='Event & Visits', Source_Detail__c='Other', School__c='CAS', RFI_Attributes__c='Legacy');

        insert rfi_campaign;
        //create the controller to pass into apex class
        ApexPages.currentPage().getParameters().put('CampaignId', rfi_campaign.Id);

        ApexPages.StandardController sc = new ApexPages.StandardController(rfi_campaign);
        CampaignRFIFormController controller = new CampaignRFIFormController(sc);

        // not sure if this is the right thing to do, but call all the functions.CampaignRFIFormControllerTest
        controller.getSchoolOptions();
        controller.getGrad_years();
        controller.getPrograms();

        controller.save();

        //after save the page should be redirected to a new landing page.
//        System.debug(ref.getUrl());

    }


}