@isTest
public class TestLookupController {
    
    @TestSetup
    static void testSetup(){
        
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 25; i++){
            accounts.add(new Account(Name = 'Test Account ' + i, BillingPostalCode = '55127', BillingState='Minnesota', website='www.google.com'));
        }
        accounts.add(new Account(Name = 'Search for this', BillingPostalCode = '55127', BillingState='Minnesota', NumberOfEmployees = 2));
        insert accounts;
    }
    
    
    static testMethod void testRunLookup(){
        List<LookupController.LookupWrapper> wrapperForMultiRecs;
        List<LookupController.LookupWrapper> wrapperForSingleRec;
        
        String testJsonMulti = '{"name":"Account","api":"Account","icon":"standard:account","selected":true,"nameField":"Name","fieldsToFilterByInput":["Name","BillingPostalCode"],"fieldsToValues":[{"Field":"website","Value":"www.google.com","dataType":"string"}],"fieldsToDisplay":["BillingPostalCode","BillingState"],"input":"Test"}';
        String testJsonSingle =  '{"name":"Account","api":"Account","icon":"standard:account","selected":true,"nameField":"Name","fieldsToFilterByInput":["Name","BillingPostalCode"],"fieldsToValues":[{"Field":"NumberOfEmployees","Value":"2","dataType":"Integer"}],"fieldsToDisplay":["BillingPostalCode","BillingState"],"input":"Search"}';
        
        test.startTest();
        
        String result =  LookupController.runLookup(testJsonMulti);
        
        wrapperForMultiRecs = ( List<LookupController.LookupWrapper>) JSON.deserialize(result, List<LookupController.LookupWrapper>.class);
        
        result =  LookupController.runLookup(testJsonSingle);
      
        wrapperForSingleRec = ( List<LookupController.LookupWrapper>) JSON.deserialize(result, List<LookupController.LookupWrapper>.class);
        
        test.stopTest();
        
        System.assertEquals(5, wrapperForMultiRecs.size());
        System.assertEquals(1, wrapperForSingleRec.size());
        
        for(LookupController.LookupWrapper wr :  wrapperForMultiRecs){
            System.assert(wr.name.contains('Test Account'));
        }
        
        System.assertEquals('Search for this', wrapperForSingleRec[0].name);
        
    }

}