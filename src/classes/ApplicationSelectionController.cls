public class ApplicationSelectionController {
    
    /*
* 
* getApps
* 
* returns a list of available applications
* to the app selection component
* 
*/ 
    @AuraEnabled
    public static List<Application_Settings__mdt> getApps(){
        return [SELECT  MasterLabel, Avatar_Abr__c, Description__c, Icon_Name__c, Component_Name__c, AuraId__c
                FROM Application_Settings__mdt 
                WHERE DeveloperName != 'General_Settings' ORDER BY MasterLabel ASC];
    }
}