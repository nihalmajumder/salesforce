/*
* 
* AssignmentRuleWrapperObjects 
* 
* Holds wrapper objects used within assignment rule application
* 
* 
* @Author - Luke Vang
* 
* 
*/ 
public class AssignmentRuleWrapperObjects {

    //wrapper class to hold data structure for combobox
    public class ComboboxWrapper implements Comparable {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String fieldType;
        @AuraEnabled
        public Boolean isReference;
        @AuraEnabled
        public String sobjectType;
	    @AuraEnabled
        public Boolean isCustom;
        @AuraEnabled
        public String fieldValue;
        
        public ComboboxWrapper(String label, String value){
            this.label = label;
            this.value = value;
        }

        public ComboboxWrapper(String label, String value, String fieldType, Boolean isReference, String sobjectType, Boolean isCustom, String fieldValue){
            this.label = label;
            this.value = value;
            this.fieldType = fieldType;
            this.isReference = isReference;
            this.sobjectType = sobjectType;
            this.isCustom = isCustom;
            this.fieldValue = fieldValue;
        }

      
        //make reference fields at the top of the list
        public Integer compareTo(Object compareTo){
            ComboboxWrapper compareToWrapper = (ComboboxWrapper) compareTo;
            if(compareToWrapper.isReference && label > compareToWrapper.label){
                return 1;
            }else if(label > compareToWrapper.label){
                return 1;
            }
            return -1;
        }
    }

    //wrapper for rule entry wrapper
    public class EntryWrapper{
        @AuraEnabled
        public String sobjectType;
        @AuraEnabled
        public String assignmenRuleId;
        @AuraEnabled
        public String id;
        @AuraEnabled
        public Integer order;
        @AuraEnabled
        public String filterLogic;
        @AuraEnabled
        public String assignedTo;
        @AuraEnabled
        public String assignedToName;
        @AuraEnabled
        public Boolean sendEmail;
        @AuraEnabled
        public List<EntryCriteriaWrapper> criteria;
        @AuraEnabled
        public List<String> deleteCriteria;
    }
    
    //wrapper for rule entry criteria wrapper
    public class EntryCriteriaWrapper{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public Integer position;
        @AuraEnabled
        public String field;
        @AuraEnabled
        public String operator;
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String dataType;
        @AuraEnabled
        public String fieldLabel;
        @AuraEnabled
        public String sobjectType;
 
    }


    //wrapper for sobjects
       public class ObjectWrapper implements Comparable {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String apiName;
        
        public ObjectWrapper(String label, String apiName){
            this.label = label;
            this.apiName = apiName;
        }

        
        public Integer compareTo(Object compareTo){
            ObjectWrapper compareToWrapper = (ObjectWrapper) compareTo;
            if(label == compareToWrapper.label) return 0;
            if(label > compareToWrapper.label) return 1;
            return -1;
        }
    }

    public class AssignmentRuleEntryWrapper{
        @AuraEnabled
        public Integer order;
        @AuraEnabled
        public String assignedToId;
        @AuraEnabled
        public String assignedToName;
        @AuraEnabled
        public Boolean sendEmail;
        @AuraEnabled
        public String criteria;
        @AuraEnabled
        public String Id;
        
    }
    

}