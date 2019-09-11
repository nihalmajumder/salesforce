/*
* 
* LookupController
*
* Controller for lookup lightning component
* used to query for sobjects based on user input
*
* @Author - Luke Vang
* @Test - LookupControllerTest
* 
*/
public class LookupController {
    
    static final Integer MAX = 5;
    
   
    //search is limited to 5, the user should filter down to what they want
    //can increase if needed, but the user should have an idea on how what they want
    @AuraEnabled
    public static String runLookup(String input){
        List<LookupWrapper> wrappers = new List<LookupWrapper>();
        
        LookupSearchWrapper inputWrapper = (LookupSearchWrapper) JSON.deserialize(input, LookupSearchWrapper.class);
 
        String query = 'SELECT id, ' + inputWrapper.nameField + ', ' + String.join(inputWrapper.fieldsToDisplay,', ')
            + ' FROM ' + inputWrapper.api + ' WHERE ';
        
        if(inputWrapper.fieldsToValues != null){
            for(Field2Value f2v : inputWrapper.fieldsToValues){
                if(f2v.dataType.equalsIgnoreCase('string')){
                    query += f2v.field + ' = ' + '\'' + f2v.value + '\'' + ' AND ';
                }else{
                    query += f2v.field + ' = ' + f2v.value  + ' AND ';
                }
            }
            query += ' ( ';
        }
        
        if(inputWrapper.fieldsToFilterByInput != null){
            for(String field : inputWrapper.fieldsToFilterByInput){
                query += field + ' LIKE ' +  '\'' + inputWrapper.input + '%\'' + ' OR ';
            }
            query = query.trim();
            if(query.endsWith('OR')) { query = query.removeEnd('OR');}
            query += ' ) ';
            query += ' LIMIT ' + MAX;
            
        }
        
        List<SObject> results = Database.query(query);
        
        for(SObject sobj : results){
            LookupWrapper wrapper = new LookupWrapper();
            wrapper.fields = '';
            for(String field : inputWrapper.fieldsToDisplay){
                wrapper.fields += sobj.get(field) != null ? String.valueOf(sobj.get(field)) : ' ';
                wrapper.fields += ', ';
            }
            wrapper.fields = wrapper.fields.trim();
            if(wrapper.fields.endsWith(',')) { wrapper.fields = wrapper.fields.removeEnd(','); }
            wrapper.name = String.valueOf(sobj.get(inputWrapper.nameField));
            wrapper.id = String.valueOf(sobj.get('Id'));
            wrappers.add(wrapper);
        }
        return JSON.serialize(wrappers);
    }
    
    public class LookupSearchWrapper{
        public String nameField;
        public List<String> fieldsToFilterByInput;
        public List<String> fieldsToDisplay;
        public List<Field2Value> fieldsToValues;
        public String input;
        public String api;
    }
    
    //wrapper to hold field => values, like active = true, type = something, 
    //basically any filter that isn't effected by the input of the user
    public class Field2Value{
        public String field;
        public String value;
        public String dataType;
    }
    
    //lookup wrapper class
    public class LookupWrapper{
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String fields;
        @AuraEnabled
        public String id;
    }
    
}