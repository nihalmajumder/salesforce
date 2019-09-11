public class FieldValueController {
    
    static Application_Settings__mdt settings = [SELECT Restricted_Custom_Objects__c, Standard_Objects__c FROM Application_Settings__mdt WHERE DeveloperName =: 'General_Settings'];
    
    //retrieves the restrictied objects
    //to not show to the end user
    static Set<String> restrictedCustomObjects{
        get{
            if(restrictedCUstomObjects == null){
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
     * getAllSObjects
     * 
     * this method retrieves all sobjects related for all field value maps and groups them
     * then returns it to the user as a json object
     * 
     * @return string json object of sobjects related to field value maps
     * 
     */ 
    @AuraEnabled(cacheable=true)
    public static string getAllSObjects(){
        AggregateResult[] arList = [SELECT SObject_Type__c FROM Field_Map_Value__c GROUP BY SObject_Type__c];
        Set<String> sobjectTypes = new Set<String>();
        for( AggregateResult ar : arList ){
            sobjectTypes.add(String.valueOf(ar.get('SObject_Type__c')));
        }
        
        List<ObjectWrapper> wrappers = new List<ObjectWrapper>();
        
        wrappers.addAll(retrieveStandardSObjects(sobjectTypes));
        wrappers.addAll(retrieveCustomSObjects(sobjectTypes));
        wrappers.sort();
        
        
        return JSON.serialize(wrappers);
    }
    
    /*
     * 
     * retrieveCustomSObjects
     * 
     * this method retrieves all custom sobjects
     * 
     * @return List<ObjectWRapper> list of custom objects 
     * 
     */ 
    public static List<ObjectWrapper> retrieveCustomSObjects(Set<String> sobjectTypes) {
        List<ObjectWrapper> objects = new List<ObjectWrapper>();
        
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
                    String apiName = gd.get(key).getDescribe().getName();
                    String label = gd.get(key).getDescribe().getLabel();
                    if(sobjectTypes.contains(apiName)){
                        objects.add(new ObjectWrapper(label, apiName, true));
                    }else{
                        objects.add(new ObjectWrapper(label, apiName, false));
                    }
                }
        }
 
        return objects;
    }

     /*
     * 
     * retrieveStandardSObjects
     * 
     * this method retrieves all standard sobjects listed in custom meta data type
     * 
     * @return List<ObjectWRapper> list of standard objects
     * 
     */ 
    public static List<ObjectWrapper> retrieveStandardSObjects(Set<String> sobjectTypes) {
        List<ObjectWrapper> objects = new List<ObjectWrapper>();
        
        String standardObjects = settings.Standard_Objects__c;
        
        List<String> standardObjectsList = standardObjects.split(',');
        
        for(String obj : standardObjectsList){
            obj = obj.trim();
            
            if(sobjectTypes.contains(obj)){
                objects.add(new ObjectWrapper(obj, obj, true));
            }else{
                objects.add(new ObjectWrapper(obj, obj, false));
            }
        }

        return objects;
    }
    
    public class ObjectWrapper implements Comparable{
        public String label;
        public String apiName;
        public Boolean configured;
        
        public ObjectWrapper(String label, String apiName, Boolean configured){
            this.label = label;
            this.apiName = apiName;
            this.configured = configured;
        }
        
        public Integer compareTo(Object compareTo){
            ObjectWrapper compareToWrapper = (ObjectWrapper) compareTo;
            //both are true
            if(compareToWrapper.configured && configured && label > compareToWrapper.label) {
                return 11;
            }else if(compareToWrapper.configured && configured &&  label < compareToWrapper.label) {
                return 10;
            }else if(compareToWrapper.configured && configured && label > compareToWrapper.label){
                return 9;
            }else if(compareToWrapper.configured && configured && label == compareToWrapper.label){
                return 8;
            }else if(!compareToWrapper.configured && configured && label > compareToWrapper.label) {
                return 7;
            }else if(!compareToWrapper.configured && configured &&  label < compareToWrapper.label) {
                return 6;
            }else if(!compareToWrapper.configured && configured && label > compareToWrapper.label){
                return 5;
            }else if(!compareToWrapper.configured && configured && label == compareToWrapper.label){
                return 4;
            }else if(!compareToWrapper.configured && !configured && label > compareToWrapper.label) {
                return 3;
            }else if(!compareToWrapper.configured && !configured &&  label < compareToWrapper.label) {
                return 2;
            }else if(!compareToWrapper.configured && !configured && label > compareToWrapper.label){
                return 1;
            }else if(!compareToWrapper.configured && !configured && label == compareToWrapper.label){
                return 0;
            }
            return -1;
        }
    }
}