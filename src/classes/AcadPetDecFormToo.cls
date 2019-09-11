/**
 * Created by phg49389 on 2019-03-21.
 */

/* This class is written to extend the StandardController and overwrite Case.save()
 * so that it doesn't send users to the raw Case page in Salesforce, but instead redirects
 * to a landing page. */
public with sharing class AcadPetDecFormToo {
    private Case academicPetitionCase { get; private set; }

    public AcadPetDecFormToo(ApexPages.StandardController stdController) {
        this.academicPetitionCase = (Case)stdController.getRecord();
    }
    

    public PageReference save() {
        academicPetitionCase.Decision_Submitted__c = true;
        // This command fetches the user-submitted values and updates the appropriate DB values
        update academicPetitionCase;

        PageReference redirectURL = new PageReference('/appeals/AcadPetDecFormToo?id=' + academicPetitionCase.Id);
        redirectURL.setRedirect(true);

        return redirectURL;
    }
}