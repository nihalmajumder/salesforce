// EJ: Work in progress. Haven't tested much yet.

@isTest
public class BethelTestDataFactory {


    public static Profile getStandardProfile(){
        return [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
    }



    public static User createTestUser(Id profID, String fName, String lName) {
        String orgId = userInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  firstname = fName,
                lastName = lName,
                email = uniqueName + '@test' + orgId + '.org',
                Username = uniqueName + '@test' + orgId + '.org',
                EmailEncodingKey = 'ISO-8859-1',
                Alias = uniqueName.substring(18, 23),
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                ProfileId = profId);
//                UserRoleId = roleId
        return tuser;
    }

    public Account findOrCreateBethelAccount(){

        Id ed_institution = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Educational Institution').getRecordTypeId();
        Account bethel_account;
        bethel_account = [SELECT Id, Name FROM Account WHERE Name='Bethel University' AND RecordTypeId=:ed_institution];
        if(bethel_account == null){
            bethel_account = new Account(RecordTypeId=ed_institution, Name='Bethel University');
        }

        return bethel_account;

    }

    public static List<Account> createAccountsWithOpps(Integer numAccts, Integer numOppsPerAcct) {
        List<Account> accts = new List<Account>();

        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;

        List<Opportunity> opps = new List<Opportunity>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];
            // For each account just inserted, add opportunities
            for (Integer k=0;k<numOppsPerAcct;k++) {
                opps.add(new Opportunity(Name=acct.Name + ' Opportunity ' + k,
                        StageName='Prospecting',
                        CloseDate=System.today().addMonths(1),
                        AccountId=acct.Id));
            }
        }
        // Insert all opportunities for all accounts.
        insert opps;

        return accts;
    }

    public static List<Program__c> createPrograms() {

        List<Program__c> programs = new List<Program__c>();

        programs.add(new Program__c(Name='Undecided', Program_Name_on_Application__c='Undecided'));
        programs.add(new Program__c(Name='Computer Science, BS', Program_Name_on_Application__c='Computer Science'));
        programs.add(new Program__c(Name='Cert/Theological Studies', Program_Name_on_Application__c='Theological Studies Certificate'));
        programs.add(new Program__c(Name='Master of Arts in Strategic Leadership: Management Concentration', Program_Name_on_Application__c='Strategic Leadership (M.A.)'));

        insert programs;
        return programs;
    }

    public static List<Academic_Term__c> createTerms(Integer numYears) {
        List<Academic_Term__c> terms = new List<Academic_Term__c>();

        // create some terms for the next 2 years.
        Integer year = System.today().year();

        for (Integer i=0; i<numYears; i++){
            String str_year = String.valueOf(year+i);
            terms.add(new Academic_Term__c(Name='Fall '+ str_year + ' - CAPS/GS'));
            terms.add(new Academic_Term__c(Name='Spring '+ str_year + ' - CAPS/GS'));
            terms.add(new Academic_Term__c(Name='Summer '+ str_year + ' - CAPS/GS'));

            terms.add(new Academic_Term__c(Name='Fall '+ str_year + ' - SEM'));
            terms.add(new Academic_Term__c(Name='Spring '+ str_year + ' - SEM'));
            terms.add(new Academic_Term__c(Name='Summer '+ str_year + ' - SEM'));

            terms.add(new Academic_Term__c(Name='Fall '+ str_year + ' - CAS'));
            terms.add(new Academic_Term__c(Name='Spring '+ str_year + ' - CAS'));
            terms.add(new Academic_Term__c(Name='Summer '+ str_year + ' - CAS'));

        }
        System.debug('CREATING TERMS');
        System.debug(terms);
        insert terms;
        return terms;
    }

    public static List<Account> createHighSchoolAccounts(){

        List<Account> schools = new List<Account>();

        Id ed_institution = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Educational Institution').getRecordTypeId();

        schools.add(new Account(Name='White Bear Lake Area High Sch', RecordTypeId=ed_institution, Type='High School', CEEB_Code__c='242683'));
        schools.add(new Account(Name='Roseville Area High School', RecordTypeId=ed_institution, Type='High School', CEEB_Code__c='242215'));

        insert schools;
        return schools;


    }


//    public static List<Account> createInteractions(Integer numInteractions) {
//        List<Interaction__c> interactions = new List<Interaction__c>();
//
//        for(Integer i=0;i<numInteractions;i++) {
//            Interaction__c i = new Interaction__c(Name='TestAccount' + i);
//            interactions.add(i);
//        }
//        insert interactions;
//
//        List<Opportunity> opps = new List<Opportunity>();
//        for (Integer j=0;j<numAccts;j++) {
//            Account acct = accts[j];
//            // For each account just inserted, add opportunities
//            for (Integer k=0;k<numOppsPerAcct;k++) {
//                opps.add(new Opportunity(Name=acct.Name + ' Opportunity ' + k,
//                StageName='Prospecting',
//                CloseDate=System.today().addMonths(1),
//                AccountId=acct.Id));
//            }
//        }
//        // Insert all opportunities for all accounts.
//        insert opps;
//
//        return accts;
//    }
}