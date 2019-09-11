/*
*
* @Author Luke Vang (Contractor)
* @Created 4/15/2019
* 
* Description: Test class for ReferenceHelper class
*
*/
@isTest
public class ReferenceHelperTest {
    
 @testSetup
    public static void testSetup(){
        Application_Control__c appControl = new Application_Control__c(
            Application_Start_Status__c=Application_Control__c.Application_Start_Status__c.getDescribe().getPicklistValues()[0].getValue(),
            Active__c=true,
            Allow_Cancel_From__c=Application_Control__c.Allow_Cancel_From__c.getDescribe().getPicklistValues()[0].getValue(),
            Allow_Withdraw_From__c=Application_Control__c.Allow_Withdraw_From__c.getDescribe().getPicklistValues()[0].getValue(),
            Allow_Submit_From__c=Application_Control__c.Allow_Submit_From__c.getDescribe().getPicklistValues()[0].getValue(),
            Cancel_Status__c=Application_Control__c.Cancel_Status__c.getDescribe().getPicklistValues()[0].getValue(),
            Default__c=true,
            URL_Parameter__c ='st',
            Submit_Status__c=Application_Control__c.Submit_Status__c.getDescribe().getPicklistValues()[0].getValue(),
            Withdraw_Status__c=Application_Control__c.Withdraw_Status__c.getDescribe().getPicklistValues()[0].getValue()
        );
        insert appControl;
        
        Account acc = new Account(Name='NewAcc');
        insert acc;
        Contact student = new Contact(LastName='TestStudent');
        
        
        Contact ref1 = new Contact(LastName='Ref1');
        Contact ref2 = new Contact(LastName='Ref2');
        Contact ref3 = new Contact(LastName='Ref3');
 
        insert new List<Contact>{student, ref1, ref2, ref3};
        
        Application__c app = new Application__c(Contact__c=student.Id,Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue());
        insert app;
        
        Map<String,Id> rtMap = new Map<String,Id>();
        for(RecordType rt : [Select Id,DeveloperName from RecordType where sObjectType = 'Requirement_Item__c']){
            rtMap.put(rt.DeveloperName,rt.Id);
        }
        
        Program__c ip = new Program__c(Name='Test');
        insert ip;
        
        Requirement__c req = new Requirement__c(Active__c = true,Name='Test Req',Application_Control__c=appControl.Id);
        insert req;
        Requirement_Item__c riQG = new Requirement_Item__c(Requirement__c=req.Id,Name='Test RI',Active__c = true,RecordTypeId=rtMap.get('Question_Group'));
        Requirement_Item__c riDU = new Requirement_Item__c(Requirement__c=req.Id,Name='Test RI',Active__c = true,Allow_Text_Entry__c = true,RecordTypeId=rtMap.get('Document_Upload'));
        Requirement_Item__c riRO = new Requirement_Item__c(Requirement__c=req.Id,Name='Test RI',Active__c = true,RecordTypeId=rtMap.get('Related_Object'),Related_List_Object__c='Application__c',Related_List_Object_Master__c='Contact',Related_List_Object_Master_Field__c='Contact__c', Holding_Record_Id__c=ip.Id);
        insert new List<Requirement_Item__c>{riQG,riDU,riRO};
            
          
            
        Reference__c reference1 = new Reference__c(Contact__c = ref1.Id, RecordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('Seminary Marriage Family').getRecordTypeId(), Type__c = 'Professional');
        Reference__c reference2 = new Reference__c(Contact__c = ref2.Id, RecordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('Seminary Marriage Family').getRecordTypeId(), Type__c = 'Professional');
        Reference__c reference3 = new Reference__c(Contact__c = ref3.Id, RecordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('Seminary General').getRecordTypeId(), Type__c = 'Personal');
        insert new List<Reference__c>{reference1, reference2, reference3};
            
        Requirement_Response__c response1 = new Requirement_Response__c(Reference__c = reference1.Id, Application__c = app.Id, Requirement_Item__c = riQG.Id);
        Requirement_Response__c response2 = new Requirement_Response__c(Reference__c = reference2.Id, Application__c = app.Id, Requirement_Item__c = riDU.Id);
        Requirement_Response__c response3 = new Requirement_Response__c(Reference__c = reference3.Id, Application__c = app.Id, Requirement_Item__c = riRO.Id);
        insert new List<Requirement_Response__c>{response1, response2, response3};
    }
    
    static testMethod void testGetReference(){
        Set<Id> refIds = new Set<Id>();
        List<Reference__c> references = [SELECT id FROM Reference__c];
        String appId = [SELECT Id FROM Application__c].Id;
        List<Requirement_Item__c> reqItems = [SELECT id FROM Requirement_Item__c];
        
        for(Reference__c ref : references){
            System.assert(ReferenceHelper.getReference(ref.Id) != null);
        }
        
        for(Requirement_Item__c resp : reqItems){
           System.assert(ReferenceHelper.getReference(appId, resp.Id) != null);
        }
        
    }

    static testMethod void testFindReference(){
        Contact ref1 = [SELECT Id FROM Contact WHERE LastName='Ref1'];
        Contact ref2 = [SELECT Id FROM Contact WHERE LastName='Ref2'];
        Contact ref3 = [SELECT Id FROM Contact WHERE LastName='Ref3'];
        Application__c app = [SELECT Id FROM Application__c];
        Reference__c reference = new Reference__c(Contact__c = ref1.Id, RecordTypeId = Schema.SObjectType.Reference__c.getRecordTypeInfosByName().get('Seminary Marriage Family').getRecordTypeId(), Type__c = 'Professional');
        insert reference;
        
        System.assert(ReferenceHelper.findReference(ref1.Id, 'Professional', 'Seminary', 'Professional Reference', app.Id) != null);
        System.assert(ReferenceHelper.findReference(ref2.Id, 'Professional', 'Seminary', 'Second Professional Reference', app.Id) != null);
        System.assert(ReferenceHelper.findReference(ref3.Id, 'Personal', 'Seminary', 'Personal Reference', app.Id) != null);
        
    }
    
    static testMethod void testCreateReference(){
        Contact ref = new Contact(LastName='Ref4');
        insert ref;
       System.assert(ReferenceHelper.createReference(ref.Id, 'Personal', 'Seminary') != null);
       System.assert(ReferenceHelper.createReference(ref.Id, 'Vocational', 'Seminary') != null);
       System.assert(ReferenceHelper.createReference(ref.Id, 'Doctor of Ministry', 'Seminary') != null);
       System.assert(ReferenceHelper.createReference(ref.Id, 'Vocational', 'Seminary') != null);
       System.assert(ReferenceHelper.createReference(ref.Id, 'Ministry', 'Seminary') != null);
       System.assert(ReferenceHelper.createReference(ref.Id, 'Professional', 'Graduate') != null);
       System.assert(ReferenceHelper.createReference(ref.Id, 'Supervisor', 'Graduate') != null);
       System.assert(ReferenceHelper.createReference(ref.Id, 'Supervisor', 'Adult Undergraduate') != null);
       System.assert(ReferenceHelper.createReference(ref.Id, 'Spiritual', 'Adult Undergraduate') != null);
        
    }
}