@isTest
public class TestFieldValueMapEditUserCmpCntrler {
    
    @testSetup
    static void testSetup(){
        TestUtility.setupTestData();
    }
    
    static testMethod void testGetUserInfo(){
        Field_Map_Value__c fmv = [SELECT id, User__c FROM Field_Map_Value__c Limit 1];
       	test.startTest();
        String userInfo = FieldValueMapEditUserCmpController.getUserInfo(fmv.Id);
        test.stopTest();
        fmv = (Field_Map_Value__c) JSON.deserialize(userInfo, Field_Map_Value__c.class);
        System.assert(fmv != null);
        System.assert(fmv.User__c != null);
    }
    
    static testMethod void testUpdateValueMap(){
        Field_Map_Value__c fmv = [SELECT id, User__c, Field_Map__c FROM Field_Map_Value__c Limit 1];
        Integer count = [SELECT COUNT() FROM Field_Map_Value__c];
        test.startTest();
        FieldValueMapEditUserCmpController.updateValueMap(null, UserInfo.getUserId(), fmv.Field_Map__c, 'Account'); // creates a new field value map record
        FieldValueMapEditUserCmpController.updateValueMap(fmv.Id, UserInfo.getUserId(), fmv.Field_Map__c, 'Account'); // updates an existing field value map recod
        test.stopTest();
        //we should have create 1 new field value map, so count  + 1
        System.assertEquals(count + 1, [SELECT COUNT() FROM Field_Map_Value__c]);
        
    }

}