@isTest
public class ApplicationChecklistTest {
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
        Application__c app = new Application__c(Contact__c=student.Id,Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue());
        insert app;

        Map<String,Id> rtMap = new Map<String,Id>();
        for(RecordType rt : [Select Id,DeveloperName from RecordType where sObjectType = 'Requirement_Item__c']){
            rtMap.put(rt.DeveloperName,rt.Id);
        }

        Requirement__c req = new Requirement__c(Active__c = true,Name='Test Req',Application_Control__c=appControl.Id);
        insert req;
        Requirement_Item__c riQG = new Requirement_Item__c(Requirement__c=req.Id,Name='Test RI QG',Active__c = true,RecordTypeId=rtMap.get('Question_Group'));
        Requirement_Item__c riDU = new Requirement_Item__c(Requirement__c=req.Id,Name='Test RI DU',Active__c = true,RecordTypeId=rtMap.get('Document_Upload'));
        Requirement_Item__c riRO = new Requirement_Item__c(Requirement__c=req.Id,Name='Test RI RO',Active__c = true,RecordTypeId=rtMap.get('Related_Object'));
        insert new List<Requirement_Item__c>{riQG,riDU,riRO};
    }
    public static TestMethod void checkSuccesses(){
        Application__c app = [Select Id from Application__c limit 1];
        Contact student = [Select Id from Contact limit 1];

        Map<String,Id> riMap = new Map<String,Id>();
        for(Requirement_Item__c ri : [Select Id,RecordType.DeveloperName from Requirement_Item__c]){
            riMap.put(ri.RecordType.DeveloperName,ri.Id);
        }

        Requirement_Response__c rrQG = new Requirement_Response__c(Application__c = app.Id,Requirement_Item__c = riMap.get('Question_Group'), Viewed__c = true);
        Requirement_Response__c rrDU = new Requirement_Response__c(Application__c = app.Id,Requirement_Item__c = riMap.get('Document_Upload'), Viewed__c = true, ValueTextEntry__c='TEST');
        Requirement_Response__c rrRO = new Requirement_Response__c(Application__c = app.Id,Requirement_Item__c = riMap.get('Related_Object'), Viewed__c = true, Has_Child_Requirement__c=true);
        insert new List<Requirement_Response__c>{rrQG,rrDU,rrRO};
        insert new Question_Response__c(Requirement_Response__c=rrQG.Id);

        PageReference pr = Page.ApplicationChecklist;
        pr.getParameters().put('contactId', student.Id);
        pr.getParameters().put('applicationId', app.Id);
        Test.setCurrentPage(pr);
        ApplicationChecklist ac = new ApplicationChecklist();
        ac.init();
        for(RequirementWrapper rw : ac.reqMap.values()){
            System.assertEquals(rw.reqStatus,true);
        }
    }
    public static TestMethod void checkFailures(){
        Application__c app = [Select Id from Application__c limit 1];
        Contact student = [Select Id from Contact limit 1];

        Map<String,Id> riMap = new Map<String,Id>();
        for(Requirement_Item__c ri : [Select Id,RecordType.DeveloperName from Requirement_Item__c]){
            riMap.put(ri.RecordType.DeveloperName,ri.Id);
        }

        Requirement_Response__c rrQG = new Requirement_Response__c(Application__c=app.Id,Requirement_Item__c=riMap.get('Question_Group'));
        Requirement_Response__c rrDU = new Requirement_Response__c(Application__c=app.Id,Requirement_Item__c=riMap.get('Document_Upload'),HasDocument__c=false);
        Requirement_Response__c rrRO = new Requirement_Response__c(Application__c=app.Id,Requirement_Item__c=riMap.get('Related_Object'),Has_Child_Requirement__c=false);
        insert new List<Requirement_Response__c>{rrQG,rrDU,rrRO};
        insert new Question_Response__c(Requirement_Response__c=rrQG.Id,IsRequired__c=true,IsShown__c=true);

        PageReference pr = Page.ApplicationChecklist;
        pr.getParameters().put('contactId', student.Id);
        pr.getParameters().put('applicationId', app.Id);
        Test.setCurrentPage(pr);
        ApplicationChecklist ac = new ApplicationChecklist();
        ac.init();
        for(RequirementWrapper rw : ac.reqMap.values()){
            System.assertEquals(rw.reqStatus,false);
        }
    }
    public static TestMethod void submitApp(){
        Application__c app = [Select Id from Application__c limit 1];
        Contact student = [Select Id from Contact limit 1];
        Application_Control__c appControl = [Select Id,Withdraw_Status__c,Cancel_Status__c,Submit_Status__c from Application_Control__c];
        Map<String,Id> riMap = new Map<String,Id>();
        for(Requirement_Item__c ri : [Select Id,RecordType.DeveloperName from Requirement_Item__c]){
            riMap.put(ri.RecordType.DeveloperName,ri.Id);
        }

        Requirement_Response__c rrQG = new Requirement_Response__c(Application__c=app.Id,Requirement_Item__c=riMap.get('Question_Group'));
        Requirement_Response__c rrDU = new Requirement_Response__c(Application__c=app.Id,Requirement_Item__c=riMap.get('Document_Upload'),ValueTextEntry__c='TEST');
        Requirement_Response__c rrRO = new Requirement_Response__c(Application__c=app.Id,Requirement_Item__c=riMap.get('Related_Object'),Has_Child_Requirement__c=true);
        insert new List<Requirement_Response__c>{rrQG,rrDU,rrRO};
        insert new Question_Response__c(Requirement_Response__c=rrQG.Id);

        PageReference pr = Page.ApplicationChecklist;
        pr.getParameters().put('contactId', student.Id);
        pr.getParameters().put('applicationId', app.Id);
        pr.getParameters().put('at', 'st');
        Test.setCurrentPage(pr);
        ApplicationChecklist ac = new ApplicationChecklist();
        ac.init();
        ac.submit();
        app = [Select id, Application_Status__c from Application__c where Id=:app.Id limit 1];
        System.assertEquals(app.Application_Status__c,appControl.Submit_Status__c);
        Test.startTest();
        ac.init();
        ac.withdrawApp();
        app = [Select id, Application_Status__c from Application__c where Id=:app.Id limit 1];
        System.assertEquals(app.Application_Status__c,appControl.Withdraw_Status__c);
        Test.stopTest();
    }
    public static TestMethod void cancelApp(){
        Application__c app = [Select Id from Application__c limit 1];
        Contact student = [Select Id from Contact limit 1];
        Application_Control__c appControl = [Select Id,Withdraw_Status__c,Cancel_Status__c,Submit_Status__c from Application_Control__c];
        Map<String,Id> riMap = new Map<String,Id>();
        for(Requirement_Item__c ri : [Select Id,RecordType.DeveloperName from Requirement_Item__c]){
            riMap.put(ri.RecordType.DeveloperName,ri.Id);
        }

        Requirement_Response__c rrQG = new Requirement_Response__c(Application__c=app.Id,Requirement_Item__c=riMap.get('Question_Group'));
        Requirement_Response__c rrDU = new Requirement_Response__c(Application__c=app.Id,Requirement_Item__c=riMap.get('Document_Upload'),ValueTextEntry__c='TEST');
        Requirement_Response__c rrRO = new Requirement_Response__c(Application__c=app.Id,Requirement_Item__c=riMap.get('Related_Object'),Has_Child_Requirement__c=true);
        insert new List<Requirement_Response__c>{rrQG,rrDU,rrRO};
        insert new Question_Response__c(Requirement_Response__c=rrQG.Id);

        PageReference pr = Page.ApplicationChecklist;
        pr.getParameters().put('contactId', student.Id);
        pr.getParameters().put('applicationId', app.Id);
        pr.getParameters().put('at', 'st');
        Test.setCurrentPage(pr);
        ApplicationChecklist ac = new ApplicationChecklist();
        ac.init();
        ac.cancelApp();
        app = [Select id, Application_Status__c from Application__c where Id=:app.Id limit 1];
        System.assertEquals(app.Application_Status__c,appControl.Cancel_Status__c);
    }

    public static testmethod void referenceTest(){
        Application__c app = [Select Id from Application__c limit 1];
        app.School_College__c = 'Graduate';
        update app;

        Contact student = [Select Id from Contact limit 1];

        Map<String,Id> riMap = new Map<String,Id>();
        for(Requirement_Item__c ri : [Select Id,RecordType.DeveloperName from Requirement_Item__c]){
            riMap.put(ri.RecordType.DeveloperName,ri.Id);
        }

        Requirement_Item__c riQG = new Requirement_Item__c(Id=riMap.get('Question_Group'));
        riQG.Is_Reference__c = true;
        riQG.Reference_Type__c = 'Professional';
        riQG.School_College__c = 'Graduate';
        riQG.Active__c = true;
        update riQG;
        Question__c q1 = new Question__c(RecordTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('Text').getRecordTypeId(),Name='First Name',Label__c='First Name',Requirement_Item__c=riQG.Id,Active__c=true,Reference_Field__c='First_Name__c',Reference_First_Name_Field__c = true);
        Question__c q2 = new Question__c(RecordTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('Text').getRecordTypeId(),Name='Last Name',Label__c='Last Name',Requirement_Item__c=riQG.Id,Active__c=true,Reference_Field__c='Lastst_Name__c',Reference_Last_Name_Field__c = true);
        Question__c q3 = new Question__c(RecordTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('Email').getRecordTypeId(),External_Email_Field__c=true,Name='Email',Label__c='Email',Requirement_Item__c=riQG.Id,Active__c=true,Reference_Field__c='Email__c');
        Question__c q4 = new Question__c(RecordTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('Address').getRecordTypeId(),Name='Address',Label__c='Address',Requirement_Item__c=riQG.Id,Active__c=true);
        insert new List<Question__c>{q1,q2,q3,q4};

        PageReference pr = Page.ApplicationChecklist;
        pr.getParameters().put('contactId', student.Id);
        pr.getParameters().put('applicationId', app.Id);
        Test.setCurrentPage(pr);
        ApplicationChecklist ac = new ApplicationChecklist();
        ac.init();
        for(RequirementWrapper rw : ac.reqMap.values()){
            System.assertEquals(rw.reqStatus,true);
        }
    }

    public static testmethod void testScoreTest(){
        Application__c app = [Select Id from Application__c limit 1];
        app.School_College__c = 'Graduate';
        update app;
        Contact student = [Select Id from Contact limit 1];
        Test_Score__c score = new Test_Score__c(Contact__c = student.Id, Test_Type__c = 'ACT', RecordTypeId=Schema.SObjectType.Test_Score__c.getRecordTypeInfosByName().get('ACT').getRecordTypeId());
        Requirement__c req = [Select Id from Requirement__c limit 1];

        Map<String,Id> riMap = new Map<String,Id>();
        for(Requirement_Item__c ri : [Select Id,RecordType.DeveloperName from Requirement_Item__c]){
            riMap.put(ri.RecordType.DeveloperName,ri.Id);
        }
        Requirement_Item__c ri = new Requirement_Item__c(Id=riMap.get('Related_Object'));
        ri.Related_List_Object__c = 'Test_Score__c';
        ri.Related_List_Object_Master__c = 'Contact';
        ri.Related_List_Object_Master_Field__c = 'Contact__c';
        ri.Related_List_Where_Clause__c = 'RecordType.Name IN (\'ACT\',\'SAT\')';
        ri.Active__c = true;
        update ri;

        Question__c q1 = new Question__c(Active__c=true,RecordTypeId=Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('Checkbox').getRecordTypeId(),Related_Object_Field__c='Test_Type__c',Picklist_Values__c='SAT;ACT',Name='Type',Requirement_Item__c=ri.Id);
        Question__c q2 = new Question__c(Active__c=true,RecordTypeId=Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('Picklist').getRecordTypeId(),Related_Object_Field__c='Document_Status__c',Picklist_Values__c='Received;Waived;Conditional',Name='Status',Requirement_Item__c=ri.Id);

        insert new List<Question__c>{q1,q2};

        PageReference pr = Page.ApplicationChecklist;
        pr.getParameters().put('contactId', student.Id);
        pr.getParameters().put('applicationId', app.Id);
        Test.setCurrentPage(pr);
        ApplicationChecklist ac = new ApplicationChecklist();
        ac.init();
        for(RequirementWrapper rw : ac.reqMap.values()){
            System.assertEquals(rw.reqStatus,true);
        }
    }

    public static testmethod void documentUploadTest(){
        Application__c app = [Select Id from Application__c limit 1];
        Contact student = [Select Id from Contact limit 1];
        Admissions_Document__c doc = new Admissions_Document__c(Type__c = 'Resume', Contact__c = student.Id);
        insert doc;


        Requirement__c req = [Select Id from Requirement__c limit 1];

        Map<String,Id> riMap = new Map<String,Id>();
        for(Requirement_Item__c ri : [Select Id,RecordType.DeveloperName from Requirement_Item__c]){
            riMap.put(ri.RecordType.DeveloperName,ri.Id);
        }

        Requirement_Item__c ri = new Requirement_Item__c(Id=riMap.get('Document_Upload'));
        ri.Admissions_Document_Type__c = 'Resume';
        update ri;

        PageReference pr = Page.ApplicationChecklist;
        pr.getParameters().put('contactId', student.Id);
        pr.getParameters().put('applicationId', app.Id);
        Test.setCurrentPage(pr);
        ApplicationChecklist ac = new ApplicationChecklist();
        ac.init();
        for(RequirementWrapper rw : ac.reqMap.values()){
            System.assertEquals(rw.reqStatus,true);
        }
    }

}