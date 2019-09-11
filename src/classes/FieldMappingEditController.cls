public with sharing class FieldMappingEditController {
    
    /*
     * 
     * addValue
     * 
     * Used to create new field map
     * 
     * @param string mapName - name of field ap
     * @param string value - value for field map value
     * 
     */ 
    @AuraEnabled
    public static void addValue(String mapName, String value){
        Field_Map__c fieldMap = new Field_Map__c(Map_Name__c = mapName, Value__c = value);
        insert fieldMap;
    }
    
     /*
     * 
     * getValues
     * 
     * Used to retrieve values for a field value map
     * 
     * @param string mapName - name of field ap
     * @return json of field maps, based on mapname
     * 
     */ 
    @AuraEnabled(cacheable=true)
    public static string getValues(String mapName){
        List<Field_Map__c> fieldMap = [SELECT id, Map_Name__c, Value__c 
                                       FROM Field_Map__c WHERE Map_Name__c =: mapName ORDER BY Value__c ASC];
        return JSON.serialize(fieldMap);
    }
    
     /*
     * 
     * searchValues
     * 
     * Used to retrieve values for a field value map via user key input filter on value field
     * 
     * @param string input - user key input
     * @param string mapName - name of field ap
     * @return json of field maps, based on mapname
     * 
     */ 
    @AuraEnabled(cacheable=true)
    public static string searchValues(String input, String mapName){
        input = String.escapeSingleQuotes(input) + '%';
        List<Field_Map__c> fieldMap = [SELECT id, Map_Name__c, Value__c FROM Field_Map__c 
                                       WHERE Value__c LIKE: input AND Map_Name__c =: mapName ORDER BY Value__c ASC];
        return JSON.serialize(fieldMap);
    }
    
}