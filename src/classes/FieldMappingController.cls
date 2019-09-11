public with sharing class FieldMappingController {
    /*
     * 
     * getFieldMappings
     * 
     * retrieves all field mappings
     * used in field mappings lightning component
     * 
     */ 
    @AuraEnabled(cacheable=true)
    public static string getFieldMappings(){
        List<FieldMappingWrapper> wrapperList = new List<FieldMappingWrapper>();
        Map<String, List<Field_Map__c>> fieldMappings = new Map<String, List<Field_Map__c>>();
        for(Field_Map__c rec :  [SELECT id, Value__c, Map_Name__c 
                                 FROM Field_Map__c 
                                 ORDER BY Map_Name__c ASC]){
                                     if( fieldMappings.get(rec.Map_Name__c) == null){
                                         fieldMappings.put(rec.Map_Name__c, new List<Field_Map__c>{rec});
                                     }else{
                                         fieldMappings.get(rec.Map_Name__c).add(rec);
                                     }
                                 }
        for(String key :  fieldMappings.keySet()){
            FieldMappingWrapper wrapper = new FieldMappingWrapper();
            wrapper.name = key;
            wrapper.fieldMaps.addAll(fieldMappings.get(key));
            wrapperList.add(wrapper);
        }
        return JSON.serialize(wrapperList);
    }
    
    /*
     * 
     * searchFieldMappings
     * 
     * used to search field mappings by filter via key input from user
     * 
     * @param string input - user key input
     * @return String json of field mappings return from filter
     * 
     */ 
    @AuraEnabled(cacheable=true)
    public static string searchFieldMappings(String input){
        input = String.escapeSingleQuotes(input) + '%';
        List<FieldMappingWrapper> wrapperList = new List<FieldMappingWrapper>();
        Map<String, List<Field_Map__c>> fieldMappings = new Map<String, List<Field_Map__c>>();
        for(Field_Map__c rec :   [SELECT id, Value__c, Map_Name__c FROM Field_Map__c 
                                  WHERE (Map_Name__c LIKE: input OR Value__c LIKE: input) ORDER BY Map_Name__c ASC]){
                                      if( fieldMappings.get(rec.Map_Name__c) == null){
                                          fieldMappings.put(rec.Map_Name__c, new List<Field_Map__c>{rec});
                                      }else{
                                          fieldMappings.get(rec.Map_Name__c).add(rec);
                                      }
                                  }
        for(String key :  fieldMappings.keySet()){
            FieldMappingWrapper wrapper = new FieldMappingWrapper();
            wrapper.name = key;
            wrapper.fieldMaps.addAll(fieldMappings.get(key));
            wrapperList.add(wrapper);
        }
        return JSON.serialize(wrapperList);
    }
    
     /*
     * 
     * deleteRecords
     * 
     * Used to delete field map via map name
     * 
     * @param string mapName - name of field ap
     * 
     */ 
    @AuraEnabled
    public static void deleteRecords(String mapName){
        List<Field_Map__c> fieldsMaps = [SELECT id, Map_Name__c 
                                         FROM Field_Map__c 
                                         WHERE Map_Name__c =: mapName];
        delete fieldsMaps;
    }
    
    public class FieldMappingWrapper{
        public String name;
        public List<Field_Map__c> fieldMaps;
        
        public FieldMappingWrapper(){
            this.fieldMaps = new List<Field_Map__c>();
        }
    }
    
}