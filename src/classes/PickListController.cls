/*
*
* Controller for pick list lightning component
*
*
* @Author - Luke Vang
* @Test Class - PickListControllerTest
*/
public with sharing class PickListController {
    
    /*
     * 
     * getPicklistValues
     * 
     * this method retrieves picklist values for a sobject type and it's picklist field
     * 
     * @param field - the picklist field
     * @param sobjectType - the sobjectType
     * @return json string of picklist values
     * 
     */ 
    @AuraEnabled
    public static string getPicklistValues(String field, String sobjectType){
        Map<String, Schema.SObjectField> mFields = Schema.getGlobalDescribe().get(sobjectType).getDescribe().fields.getMap();
        List<PickListWrapper> wrapperList = new List<PickListWrapper>();

        String theField = field;
        if (field.indexOf('.') != -1) {
            theField = field.substringAfterLast('.');
        }
        Schema.SObjectField pickListValues = mFields.get(theField);
        
        if(pickListValues.getDescribe().getType() == Schema.DisplayType.BOOLEAN){
            
            wrapperList.add(new PicklistWrapper('True', 'True', false));
            wrapperList.add(new PicklistWrapper('False', 'False', false));   
        }else{
            List<Schema.PicklistEntry> plEntries  = pickListValues.getDescribe().getPicklistValues();
            for(Schema.PicklistEntry ple : plEntries){
                if(ple.isDefaultValue()){
                    wrapperList.add(new PicklistWrapper(ple.getLabel(), ple.getValue(), true));
                }else{
                    wrapperList.add(new PicklistWrapper(ple.getLabel(), ple.getValue(), false));
                }
            }
        }
        
        return JSON.serialize(wrapperList);
    }
    
    public class PickListWrapper{
        public String label;
        public String value;
        public Boolean checked;
        
        public PickListWrapper(String label, String value, Boolean checked){
            this.label = label;
            this.value = value;
            this.checked = checked;
        }
    }
    
}