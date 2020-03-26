/**
 * Created by jps26784 on 3/23/20.
 */

global class SandboxPostRefreshScript_Full implements SandboxPostCopy {

    private String instance;

    public SandboxPostRefreshScript_Full() {
        // get Sandbox org instance; refreshing can move us to a new instance
        instance = [SELECT Id,InstanceName FROM Organization LIMIT 1].InstanceName.toLowerCase();
    }

    global void runApexClass(System.SandboxContext context) {
        System.debug('Org ID: ' + context.organizationId());
        System.debug('Sandbox ID: ' + context.sandboxId());
        System.debug('Sandbox Name: ' + context.sandboxName());

        validateUsers();
        updateBethelSettings();
        updateApplicationSettings();

    }

    public void validateUsers() {
        // find users who have Sandbox User checked
        List<User> usersToActivate = new List<User>([SELECT Id, Email FROM User WHERE Sandbox_User__c=TRUE AND IsActive=TRUE]);

        // clean these users' email addresses
        for (User u : usersToActivate) {
            u.Email = u.Email.replaceAll('\\.invalid','');
        }

        // find users to DO NOT have Sandbox User checked; we want to ignore anyone without a FederationId to begin with
        List<User> usersToInvalidate = new List<User>([SELECT Id, FederationIdentifier FROM User WHERE Sandbox_User__c=FALSE AND IsActive=TRUE AND (NOT Profile.Name LIKE '%community%') AND FederationIdentifier!=NULL]);

        // invalidate the FederationId
        for (User u : usersToInvalidate) {
            u.FederationIdentifier = u.FederationIdentifier + '.invalid';
        }

        update usersToActivate;
        update usersToInvalidate;
    }

    public void updateBethelSettings() {
        // our Full Sandbox MyDomain
        String domain = 'https://bethel-university--full.lightning.force.com';

        // update the Custom Setting "Bethel Settings" for Full
        List<Bethel_Settings__c> bethelSettings = new List<Bethel_Settings__c>([SELECT Id, Instance_URL__c, Community_URL_Appeals__c FROM Bethel_Settings__c LIMIT 1]);
        bethelSettings[0].Community_URL_Appeals__c = ('https://full-bethelu.'+instance+'.force.com/');
        bethelSettings[0].Instance_URL__c = domain;

        update bethelSettings;
    }

    public void updateApplicationSettings() {
        // update the EASY Custom Settings "Application Settings" with applicant profile/permission set Ids
        // update Admissions Community URL
        List<Application_Setting__c> applicationSettings = new List<Application_Setting__c>([SELECT Id, Community_Profile_Ids__c, Community_URL__c, Permission_Set_Id__c FROM Application_Setting__c LIMIT 1]);

        applicationSettings[0].Community_URL__c = ('https://full-bethel-univ.'+instance+'.force.com/admissions');
        // finds new Ids for this Perm Set and Profile in the refreshed Sandbox
        applicationSettings[0].Permission_Set_Id__c = [SELECT Id FROM PermissionSet WHERE Name = 'Application_Community'].Id;
        applicationSettings[0].Community_Profile_Ids__c = [SELECT Id FROM Profile WHERE Name='Applicant Community Login User'].Id;

        update applicationSettings;
    }

}