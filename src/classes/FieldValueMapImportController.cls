public with sharing class FieldValueMapImportController {
    
    @AuraEnabled(cacheable=true)
    public static string getAllSObjects(){
        return FieldValueController.getAllSObjects();
    }
    
    /*
     * 
     * createMappings
     * 
     * this method creates field mappings based off of a picklist fields values
     * 
     * @param mapName - name for new mapping
     * @param objectStr - object type string
     * @param field - picklist field to create field mappings on
     * 
     */ 
    @AuraEnabled
    public static void createMappings(String mapName, String objectStr, String field){
        List<Field_Map__c> fieldMaps = new List<Field_Map__c>();
        Schema.SObjectType sobjectType = Schema.getGlobalDescribe().get(objectStr);
        Schema.DescribeFieldResult dfr = sobjectType.getDescribe().fields.getMap().get(field).getDescribe();
        List<Schema.PicklistEntry> plEntries = dfr.getPicklistValues();
        
        Set<String> existingValues = new Set<String>();
        //find any existing values
        for(Field_Map__c fm : [SELECT id, Map_Name__c, Value__c FROM Field_Map__c WHERE Map_Name__c =: mapName]){
            existingValues.add(fm.Value__c);
        }
        
        // only create different entries and add only active entries
        for(Schema.PicklistEntry pl : plEntries){
            if(pl.isActive() && !existingValues.contains(pl.getValue())){
                fieldMaps.add(new Field_Map__c(Map_Name__c = mapName, Value__c = pl.getValue()));
            }
        }
        
        if(!fieldMaps.isEmpty()){
            System.debug(fieldMaps.size());
            System.debug(fieldMaps);
            insert fieldMaps;
        }
        
    }
    
    
     /*
     * 
     * getPickLists
     * 
     * this method retrieves the picklist of an sobject 
     * 
     * @param objectStr - object type string
     * @string json string of picklist values
     * 
     */ 
    @AuraEnabled(cacheable=true)
    public static string getPickLists(String objectStr){
        List<FieldWrapper> fields = new List<FieldWrapper>();
        Schema.SObjectType sobjectType = Schema.getGlobalDescribe().get(objectStr);
        Map<String, Schema.SObjectField> fieldMap = sobjectType.getDescribe().fields.getMap();
        
        for(Schema.SObjectField sf : fieldMap.values()){
            Schema.DescribeFieldResult dfr = sf.getDescribe();
            if(dfr.isAccessible() && dfr.getType() == Schema.DisplayType.PICKLIST){
                fields.add(new FieldWrapper(dfr.getLabel(), dfr.getName()));
            }
        }
        
        return JSON.serialize(fields);
    }
    
    public class FieldWrapper{
        public String label;
        public String api;
        
        public FieldWrapper(String label, String api){
            this.label = label;
            this.api = api;
        }
    }
    
}