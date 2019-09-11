public class FieldValueMapEditUserCmpController {
    
    /*
     * 
     * getUserInfo
     * 
     * retrieves the user from a field value map based on id passed in
     * 
     * @param string recordId - id of field value map record
     * @return String json of field value map
     * 
     */ 
    @AuraEnabled(cacheable=true)
    public static string getUserInfo(String recordId){
        Field_Map_Value__c fmv = [SELECT User__c, User__r.Name FROM Field_Map_Value__c WHERE id =: recordId];
        return JSON.serialize(fmv);
    }	
    
    
     /*
     * 
     * updateValueMap
     * 
     * retrieves the user from a field value map based on id passed in
     * 
     * @param string recordId - id of field value map record
     * @param string userId - user id to assign to field value map
     * @param string fieldMapId - id of parent field map
     * @param sobjectType - sobject type for field value map
     * 
     */ 
    @AuraEnabled
    public static void updateValueMap(String recordId, String userId, String fieldMapId, String sobjectType){
        if(String.isEmpty(recordId)){
            Field_Map_Value__c fmv = new Field_Map_Value__c(Field_Map__c = fieldMapId, User__c = userId, SObject_Type__c = sobjectType);
            insert fmv;
        }else{
            Field_Map_Value__c fmv = new Field_Map_Value__c(Id = recordId, User__c = userId);
            update fmv;
        }
    }
    
}