/*
 * 
 * AssignmentRulesObjectTabController
 * 
 * this class is used for the assignment rules object tab lightning component
 * it contains logic that will return all the supported standard objects
 * 
 */ 
public with sharing class AssignmentRulesObjectTabController {
	
    static Application_Settings__mdt settings = [SELECT Restricted_Custom_Objects__c, Standard_Objects__c FROM Application_Settings__mdt WHERE DeveloperName =: 'General_Settings'];

    static Set<String> restrictedCustomObjects{
        get{
            if(restrictedCustomObjects == null){
                restrictedCustomObjects = new Set<String>();
                List<String> objs = settings.Restricted_Custom_Objects__c.split(',');
                for(String obj : objs){
                    obj = obj.trim();
                    restrictedCustomObjects.add(obj);
                }
                
            }
            return restrictedCustomObjects;
        }

        set{}
    } 

       /*
* 
* this method is used to retrieve a list of custom sobjects
* 
* @return - json of custom sobjects
* 
*/     
    @AuraEnabled(cacheable=true)
    public static String retrieveCustomSObjects() {
        List<AssignmentRuleWrapperObjects.ObjectWrapper> objects = new List<AssignmentRuleWrapperObjects.ObjectWrapper>();
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for (String key : gd.keySet()) {
            if (!restrictedCustomObjects.contains(gd.get(key).getDescribe().getName()) &&
                gd.get(key).getDescribe().isCreateable() &&
                gd.get(key).getDescribe().isAccessible() &&
                gd.get(key).getDescribe().isQueryable() &&
                gd.get(key).getDescribe().isUpdateable() &&
                !gd.get(key).getDescribe().isDeprecatedAndHidden() &&
                !gd.get(key).getDescribe().isCustomSetting() &&
                gd.get(key).getDescribe().isSearchable() &&
                gd.get(key).getDescribe().isCustom() &&
                (gd.get(key).getDescribe().getName().countMatches('__') < 2)){
                    objects.add(new AssignmentRuleWrapperObjects.ObjectWrapper(gd.get(key).getDescribe().getLabel(), gd.get(key).getDescribe().getName()));
                }
        }
        if(!objects.isEmpty()){
            objects.sort();
        }
        
        String mapJSON = JSON.serialize(objects);
        return mapJSON;
    }

    /*
* 
* this method is used to retrieve a list of standard sobjects
* 
* @return - json of standard sobjects
* 
*/     
    @AuraEnabled(cacheable=true)
    public static String retrieveStandardSObjects() {
        List<AssignmentRuleWrapperObjects.ObjectWrapper> objects = new List<AssignmentRuleWrapperObjects.ObjectWrapper>();
        
       String standardObjects = settings.Standard_Objects__c;

       List<String> standardObjectsList = standardObjects.split(',');

       for(String obj : standardObjectsList){
           obj = obj.trim();
           objects.add(new AssignmentRuleWrapperObjects.ObjectWrapper(obj, obj));
       }
        if(!objects.isEmpty()){
            objects.sort();
        }
        String mapJSON = JSON.serialize(objects);
        return mapJSON;
    }

}