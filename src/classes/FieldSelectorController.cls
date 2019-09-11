/*
* 
* FieldSelectorController
* 
* This controller is used to quuery fields
* belonging to a certain sobjects
* 
* It is used by the FieldSelectorCmp
* 
* @Author - Luke Vang
* 
* 
*/ 
public with sharing class FieldSelectorController {
    
    
    //retrieves fields for select sobject type
    @AuraEnabled(cacheable=true)
    public static String getFields(String sObjectType){
        List<AssignmentRuleWrapperObjects.ComboboxWrapper> fields = new List<AssignmentRuleWrapperObjects.ComboboxWrapper>();
        List<AssignmentRuleWrapperObjects.ComboboxWrapper> referenceFields = new List<AssignmentRuleWrapperObjects.ComboboxWrapper>();
        String result = '';
        
        SObjectType s_object = Schema.getGlobalDescribe().get(sobjectType);
        Map<String,Schema.SObjectField> mfields = s_object.getDescribe().fields.getMap();
        
        for(Schema.SObjectField field: mFields.values()){
            Schema.DescribeFieldResult dfr = field.getDescribe();
            //only retrieve fields that are filterable and accessible
            if(dfr.isAccessible() && dfr.isFilterable() ){
                
                if(dfr.getType() == Schema.DisplayType.REFERENCE){
                    String name = dfr.getName();
                    if(dfr.getName().endsWithIgnoreCase('Id')){
                        name = dfr.getName().removeEnd('Id');
                    }
                    referenceFields.add(new AssignmentRuleWrapperObjects.ComboboxWrapper(dfr.getLabel() + ' >', 
                                                                                         generateRandomString(),
                                                                                         String.valueOf(dfr.getType()), 
                                                                                         true, 
                                                                                         dfr.getReferenceTo().get(0).getDescribe().getName(),
                                                                                         dfr.getReferenceTo().get(0).getDescribe().isCustom(),
                                                                                         name));
                    
                    
                }else{
                    fields.add(new AssignmentRuleWrapperObjects.ComboboxWrapper(dfr.getLabel(),
                                                                                generateRandomString(),
                                                                                String.valueOf(dfr.getType()),
                                                                                false,
                                                                                sObjectType,
                                                                                dfr.isCustom(),
                                                                                dfr.getName()));
                }
            }
        }
        
        
        referenceFields.sort();
        fields.sort();
        
        referenceFields.addAll(fields);
        
        if(!referenceFields.isEmpty()){
            result = JSON.serialize(referenceFields);
        }
        return result;
    }
    
    //generate a random string as an identifier for each
    //field
    //there are very simular field names and values, so a custom identifier is needed
    //to keep them unique from each other
    public static String generateRandomString() {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < 8) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    
}