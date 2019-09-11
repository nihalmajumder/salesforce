public with sharing class FieldValueMappingsController {
    
    /*
     * 
     * createNewMapValues
     * 
     * this method creates new field map values for a field map
     * 
     * @param mapName - the name of the map
     * @param sobjectType - sobject type for new map value
     * 
     */
    @AuraEnabled    
    public static void createNewMapValues(String mapName, String sobjectType){
        List<Field_Map_Value__c> fieldValueMaps = new List<Field_Map_Value__c>();
        
        for(Field_Map__c fm : [SELECT id, Map_Name__c FROM Field_Map__c WHERE Map_Name__c =: mapName]){
            fieldValueMaps.add(new Field_Map_Value__c(Field_Map__c = fm.Id, SObject_Type__c = sobjectType));
        }
        
        if(!fieldValueMaps.isEmpty()){
            insert fieldValueMaps;
        }
    }
    
    /*
     * 
     * getFieldMappingsBySObjectType
     * 
     * this method finds the field mappings based on an sobject type
     * 
     * @param sobjectType - the sobject type
     * @return json of field mappings
     * 
     */
    @AuraEnabled(cacheable=true)
    public static string getFieldMappingsBySObjectType(String sobjectType){
        List<FieldMappingWrapper> wrapperList = new List<FieldMappingWrapper>();
        Map<String, List<Field_Map__c>> fieldMappings = new Map<String, List<Field_Map__c>>();
        for(Field_Map__c rec :  [SELECT id, Value__c, Map_Name__c, 
            (SELECT id, SObject_Type__c FROM Field_Map_Values__r WHERE SObject_Type__c =: sobjectType) 
            FROM Field_Map__c ORDER BY Map_Name__c ASC]){
            if( fieldMappings.get(rec.Map_Name__c) == null){
                fieldMappings.put(rec.Map_Name__c, new List<Field_Map__c>{rec});
            }else{
                fieldMappings.get(rec.Map_Name__c).add(rec);
            }
        }
        for(String key :  fieldMappings.keySet()){
            FieldMappingWrapper wrapper = new FieldMappingWrapper();
            wrapper.name = key;
            
            for(Field_Map__c fm : fieldMappings.get(key)){
                if(!fm.Field_Map_Values__r.isEmpty()){
                    if(!wrapper.configured){
                        wrapper.configured = true;
                        break;
                    }
                }
            }
            
            wrapper.fieldMaps.addAll(fieldMappings.get(key));
            wrapperList.add(wrapper);
        }
        return JSON.serialize(wrapperList);
    }
    
    
    /*
     * 
     * searchFieldMappings
     * 
     * this method is used to find field mappings based on user key input
     * 
     * @param input - the key input from user
     * @param sobjectType - the sobject type
     * @return json of field mappings
     * 
     */
    @AuraEnabled(cacheable=true)
    public static string searchFieldMappings(String input, String sobjectType){
        input = String.escapeSingleQuotes(input) + '%';
        List<FieldMappingWrapper> wrapperList = new List<FieldMappingWrapper>();
        Map<String, List<Field_Map__c>> fieldMappings = new Map<String, List<Field_Map__c>>();
        for(Field_Map__c rec :  [SELECT id, Value__c, Map_Name__c, (SELECT id, SObject_Type__c FROM Field_Map_Values__r) 
            FROM Field_Map__c WHERE Map_Name__c LIKE: input ORDER BY Map_Name__c ASC]){
            if( fieldMappings.get(rec.Map_Name__c) == null){
                fieldMappings.put(rec.Map_Name__c, new List<Field_Map__c>{rec});
            }else{
                fieldMappings.get(rec.Map_Name__c).add(rec);
            }
        }
        for(String key :  fieldMappings.keySet()){
            FieldMappingWrapper wrapper = new FieldMappingWrapper();
            wrapper.name = key;
            
            for(Field_Map__c fm : fieldMappings.get(key)){
                if(!fm.Field_Map_Values__r.isEmpty()){
                    if(!wrapper.configured){
                        wrapper.configured = true;
                        break;
                    }
                }
            }
            
            wrapper.fieldMaps.addAll(fieldMappings.get(key));
            wrapperList.add(wrapper);
        }
        return JSON.serialize(wrapperList);
    }
    
    public class FieldMappingWrapper{
        public String name;
        public List<Field_Map__c> fieldMaps;
        public Boolean configured;
        
        public FieldMappingWrapper(){
            configured = false;
            this.fieldMaps = new List<Field_Map__c>();
        }
    }
}