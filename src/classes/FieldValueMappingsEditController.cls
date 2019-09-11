public class FieldValueMappingsEditController {
    
     /*
     * 
     * searchFieldMappingValues
     * 
     * this method is used to findfield mapping values based on user input
     * 
     * @param input - the key input from user
     * @param mapName - the field map
     * @param sobjectType - the sobject type
     * @return json of field value maps wrapper
     * 
     */
    @AuraEnabled(cacheable=true)
    public static string searchFieldMappingValues(String input, String mapName, String sobjectType){
        input = String.escapeSingleQuotes(input);
        List<FieldValueWrapper> wrappers = new List<FieldValueWrapper>();
        for(Field_Map__c vm : [SELECT id, Map_Name__c, Value__c, (SELECT id, User__c, User__r.Name, SObject_Type__c FROM Field_Map_Values__r WHERE SObject_Type__c =: sobjectType)
                               FROM Field_Map__c WHERE Map_Name__c =: mapName])
        {
            FieldValueWrapper wrapper = new FieldValueWrapper();
            wrapper.mapName = mapName;
            wrapper.value = vm.Value__c;
            
            if(vm.Field_Map_Values__r != null){
                //should only be  user per mapping values
                for(Field_Map_Value__c fvm : vm.Field_Map_Values__r){
                    wrapper.user = fvm.User__r;
                    wrapper.id = fvm.Id;
                    break;
                }
            }
            wrappers.add(wrapper);
            wrappers.sort();
        }
        return JSON.serialize(wrappers);
    }
    
         /*
     * 
     * getFieldMappingValues
     * 
     * this method retrieves field value maps based on field map name
     * 
     * @param mapName - the field map
     * @param sobjectType - the sobject type
     * @return json of field value maps wrapper
     * 
     */
    @AuraEnabled(cacheable=true)
    public static string getFieldMappingValues(String mapName, String sobjectType){
        List<FieldValueWrapper> wrappers = new List<FieldValueWrapper>();
        for(Field_Map__c vm : [SELECT id, Map_Name__c, Value__c, (SELECT id, User__c, User__r.Name, SObject_Type__c FROM Field_Map_Values__r WHERE SObject_Type__c =: sobjectType)
                               FROM Field_Map__c WHERE Map_Name__c =: mapName])
        {
            FieldValueWrapper wrapper = new FieldValueWrapper();
            wrapper.mapName = mapName;
            wrapper.value = vm.Value__c;
            wrapper.fieldMapId = vm.Id;            
            if(vm.Field_Map_Values__r != null){
                //should only be  user per field map value
                for(Field_Map_Value__c fvm : vm.Field_Map_Values__r){
                    wrapper.user = fvm.User__r;
                    wrapper.id = fvm.Id;
                    break;
                }
            }
            wrappers.add(wrapper);
            wrappers.sort();
        }
        return JSON.serialize(wrappers);
    }
    
    public class FieldValueWrapper implements comparable{
        public String mapName;
        public String value;
        public String id;
        public String fieldMapId;
        public User user;
        
        //make reference fields at the top of the list
        public Integer compareTo(Object compareTo){
            FieldValueWrapper compareToWrapper = ( FieldValueWrapper) compareTo;
            if(compareToWrapper.user != null){
                return 1;
            }
            return -1;
        }
    }
    
}