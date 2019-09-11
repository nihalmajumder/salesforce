@isTest
public class ApplicationCheckBatchTest {
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
        
        Contact student = new Contact(LastName='TestStudent', FirstName = 'TestFirst', Email = 'TestContact@example.bethel.com');
        insert student;
        Application__c app = new Application__c(Contact__c=student.Id,Application_Status__c='Submitted');
        insert app;

        Contact student2 = new Contact(LastName='TestStudentSecond', FirstName = 'TestFirstSecond', Email = 'TestContactSecond@example.bethel.com');
        insert student2;
        Application__c app2 = new Application__c(Contact__c=student2.Id,Application_Status__c='Submitted');
        insert app2;

        Requirement__c req = new Requirement__c(Active__c = true,Name='Test Req',Application_Control__c=appControl.Id);
        insert req;
        Requirement_Item__c riQG = new Requirement_Item__c(Requirement__c=req.Id,Name='Test RI QG',Active__c = true,RecordTypeId=Schema.SObjectType.Requirement_Item__c.getRecordTypeInfosByName().get('Question Group').getRecordTypeId());
        Requirement_Item__c riDU = new Requirement_Item__c(Requirement__c=req.Id,Name='Test RI DU',Active__c = true,RecordTypeId=Schema.SObjectType.Requirement_Item__c.getRecordTypeInfosByName().get('Document Upload').getRecordTypeId());
        Requirement_Item__c riRO = new Requirement_Item__c(Requirement__c=req.Id,Name='Test RI RO',Active__c = true,RecordTypeId=Schema.SObjectType.Requirement_Item__c.getRecordTypeInfosByName().get('Related Object').getRecordTypeId());
        insert new List<Requirement_Item__c>{riQG,riDU,riRO};
	}

    static testMethod void batchTest() {

        test.startTest();
        List<Application__c> apps = [SELECT Id, Application_Status__c FROM Application__c];
        ApplicationCheckBatch batchObject = new ApplicationCheckBatch(apps);
        Database.executeBatch(batchObject);
        test.stopTest();

        List<Application__c> apps2 = [SELECT Id, Application_Status__c FROM Application__c];
        System.assertEquals('Completed', apps2[0].Application_Status__c);
        System.assertEquals('Completed', apps2[1].Application_Status__c);

    }
}