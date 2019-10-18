<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Opportunity</fullName>
        <description>Update Date Accepted if the status changed and Date Accepted is currently blank.</description>
        <field>Date_Accepted__c</field>
        <formula>IF( 
					ISBLANK( Date_Accepted__c ) &amp;&amp; 
     TEXT(StageName) = &quot;Accepted&quot;,        
					NOW(), 
				 Date_Accepted__c
	)</formula>
        <name>Opportunity: Date Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Admissions_Integration_Code</fullName>
        <field>Admission_Integration_Code__c</field>
        <formula>CASE(Status_Text__c, 
&quot;Inquired:Inquired&quot;, &quot;IN&quot;, 
&quot;Inquired:Pre-Applied&quot;, &quot;PA&quot;, 
&quot;Inquired:App Started&quot;, &quot;IN&quot;, 
&quot;Applied:App Submitted&quot;, &quot;AP&quot;, 
&quot;Applied:App Completed&quot;, &quot;AP&quot;, 
&quot;Accepted:Accepted&quot;, &quot;AC&quot;, 
&quot;Wait Listed:Wait Listed&quot;, &quot;WT&quot;,
&quot;Confirmed:Fee Paid&quot;, &quot;FP&quot;, 
&quot;Confirmed:Fee Waived&quot;, &quot;FW&quot;, 
&quot;Confirmed:Registered&quot;, 
   IF(PRIORVALUE(Admission_Integration_Code__c) = &quot;FP&quot;,&quot;FP&quot;,
      IF(PRIORVALUE(Admission_Integration_Code__c) = &quot;FW&quot;,&quot;FW&quot;,&quot;XX&quot;)
   ),
&quot;Confirmed:Ready to Enroll&quot;, &quot;FW&quot;,
&quot;Enrolled:Enrolled&quot;,
IF(PRIORVALUE(Admission_Integration_Code__c) = &quot;FP&quot;,&quot;FP&quot;,
      IF(PRIORVALUE(Admission_Integration_Code__c) = &quot;FW&quot;,&quot;FW&quot;,&quot;XX&quot;)
   ),
&quot;File Closed:Inquired - File Closed&quot;, &quot;TE&quot;,
&quot;File Closed:Pre-Applied - File Closed&quot;, &quot;PB&quot;,
&quot;File Closed:App Started - File Closed&quot;, &quot;TE&quot;,
&quot;File Closed:App Submitted - File Closed&quot;, &quot;AB&quot;,
&quot;File Closed:App Completed - File Closed&quot;, &quot;AB&quot;,
&quot;File Closed:Wait Listed - File Closed&quot;, &quot;WD&quot;,
&quot;File Closed:Accepted - File Closed&quot;, &quot;CN&quot;,
&quot;File Closed:Rejected - App Submitted - File Closed&quot;, &quot;RJ&quot;,
&quot;File Closed:Rejected - App Completed - File Closed&quot;, &quot;RJ&quot;,
&quot;File Closed:Fee Paid - File Closed&quot;, &quot;FF&quot;,
&quot;File Closed:Fee Waived - File Closed&quot;, &quot;FF&quot;,
&quot;File Closed:Registered - File Closed&quot;, &quot;FF&quot;,
&quot;File Closed:Confirmed - File Closed&quot;, &quot;FF&quot;,
&quot;File Closed:Unknown - File Closed&quot;, &quot;XX&quot;,
&quot;File Closed:Rejected - App Started - File Closed&quot;, &quot;RJ&quot;,
&quot;XX&quot;
)</formula>
        <name>Opportunity: Admissions Integration Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Application_Submitted_Date</fullName>
        <description>Sets the Application Submitted Date to Today</description>
        <field>Application_Submitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>Opportunity: Application Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Clear_Banner_App_Number</fullName>
        <field>Banner_Application_Number__c</field>
        <name>Opportunity: Clear Banner App Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Clear_Date_File_Closed</fullName>
        <field>Date_File_Closed__c</field>
        <name>Opportunity: Clear Date File Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Clear_Withdrawal_Detail</fullName>
        <field>Withdrawal_Detail__c</field>
        <name>Opportunity: Clear Withdrawal Detail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Clear_Withdrawal_Reason</fullName>
        <field>Withdrawal_Reason__c</field>
        <name>Opportunity: Clear Withdrawal Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Date_App_Completed</fullName>
        <description>Update Date App Completed if the Opportunity Status changed to that and Date App Completed is blank.</description>
        <field>Date_App_Completed__c</field>
        <formula>IF( 
					ISBLANK( Date_App_Completed__c ) &amp;&amp; 
     TEXT(StageName) = &quot;Applied&quot; &amp;&amp;
				 TEXT(Stage_Detail__c) = &quot;App Completed&quot;,
				
					NOW(), 
				 Date_App_Completed__c
	)</formula>
        <name>Opportunity: Date App Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Date_App_Started</fullName>
        <description>Update Date App Started on the Opportunity if the Status changes to App Started and Date App Started is blank</description>
        <field>Date_App_Started__c</field>
        <formula>IF( 
					ISBLANK( Date_App_Started__c ) &amp;&amp; 
     TEXT(StageName) = &quot;Inquired&quot; &amp;&amp;
				 TEXT(Stage_Detail__c) = &quot;App Started&quot;,
				
					NOW(), 
				 Date_App_Started__c
	)</formula>
        <name>Opportunity: Date App Started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Date_App_Submitted</fullName>
        <description>Update Date App Submitted on the Opportunity if the Status is App Submitted and Date App Submitted is currently blank.</description>
        <field>Date_App_Submitted__c</field>
        <formula>IF( 
					ISBLANK( Date_App_Submitted__c ) &amp;&amp; 
     TEXT(StageName) = &quot;Applied&quot; &amp;&amp;
				 TEXT(Stage_Detail__c) = &quot;App Submitted&quot;,
				
					NOW(), 
				 Date_App_Submitted__c
	)</formula>
        <name>Opportunity: Date App Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Date_Confirmed</fullName>
        <description>Update Date Confirmed if the status updates to Confirmed and Date Confirmed is currently blank.</description>
        <field>Date_Confirmed__c</field>
        <formula>IF( 
					ISBLANK( Date_Confirmed__c ) &amp;&amp; 
     TEXT(StageName) = &quot;Confirmed&quot;,
				
					NOW(), 
				 Date_Confirmed__c
	)</formula>
        <name>Opportunity: Date Confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Date_File_Closed</fullName>
        <description>Update Date File Closed on Opportunity when the status changes to this File Closed, and the date field was previously blank.</description>
        <field>Date_File_Closed__c</field>
        <formula>IF( 
					ISBLANK( Date_File_Closed__c ) &amp;&amp; 
     TEXT(StageName) = &quot;File Closed&quot;,   
        
					NOW(), 
				 Date_File_Closed__c
	)</formula>
        <name>Opportunity: Date File Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Date_Inquired</fullName>
        <description>Update Date Inquired on Opportunity if status is Inquire and Date Inquired is currently blank</description>
        <field>Date_Inquired__c</field>
        <formula>IF( 
					ISBLANK( Date_Inquired__c ) &amp;&amp; 
     TEXT(StageName) = &quot;Inquired&quot;,
				
					NOW(), 
				 Date_Inquired__c
	)</formula>
        <name>Opportunity: Date Inquired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_First_Recruitment_Program</fullName>
        <description>Sets the First Recruitment Program to the Recruitment Program Name.</description>
        <field>First_Recruitment_Program__c</field>
        <formula>Recruitment_Program__r.Name</formula>
        <name>Opportunity: First Recruitment Program</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Key_Set_Based_on_Career</fullName>
        <description>For UG, sets key to Contact ID + Opportunity Career + Term ID, for GR, Contact ID + Opportunity Career + ((Academic. Program ID.Recruitment Program ID or Academic Program ID) or Recruitment Program ID) + Term ID.</description>
        <field>Opportunity_Key__c</field>
        <formula>CASESAFEID(Contact__r.Id) + &quot;.&quot; + TEXT(School_College__c) + &quot;.&quot; + Academic_Term__r.Name</formula>
        <name>Opportunity Key: Set Based on Career</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Mark_Sync_Opp_to_Banner</fullName>
        <description>Mark the checkbox so the Opportunity will be updated in Banner.</description>
        <field>Sync_Opportunity_to_Banner__c</field>
        <literalValue>1</literalValue>
        <name>Opportunity: Mark Sync Opp to Banner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Name_Set_to_Last_Term</fullName>
        <description>Sets the Opportunity Name to Contact Last Name - Term Name</description>
        <field>Name</field>
        <formula>Contact__r.LastName</formula>
        <name>Opportunity Name - Set to Last - Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Rename_if_Term_Changes</fullName>
        <field>Name</field>
        <formula>Contact__r.LastName + &quot;, &quot; + Contact__r.FirstName + &quot; - &quot; + Academic_Term__r.Name</formula>
        <name>Opportunity: Rename if Term Changes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Set_First_Inquiry_Source</fullName>
        <description>Sets the First Inquiry Source field to the LeadSource.</description>
        <field>First_Inquiry_Source__c</field>
        <formula>TEXT(LeadSource)</formula>
        <name>Opportunity: Set First Inquiry Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Set_Inquiry_Date</fullName>
        <description>Sets the Inquiry Date field to CreatedDate.</description>
        <field>Inquiry_Date__c</field>
        <formula>CreatedDate</formula>
        <name>Opportunity: Set Inquiry Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Stage_Modified_Date</fullName>
        <field>Stage_Modified_Date__c</field>
        <formula>NOW()</formula>
        <name>Opportunity: Stage Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Student_Type_BUILD</fullName>
        <field>Student_Type__c</field>
        <literalValue>BUILD</literalValue>
        <name>Opportunity: Student Type: BUILD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Student_Type_PSEO</fullName>
        <field>Student_Type__c</field>
        <literalValue>PSEO</literalValue>
        <name>Opportunity: Student Type: PSEO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Student_Type_Transfer</fullName>
        <field>Student_Type__c</field>
        <literalValue>Transfer</literalValue>
        <name>Opportunity: Student Type: Transfer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Sync_Opp_to_Banner_Date</fullName>
        <field>Sync_Opportunity_to_Banner_Date__c</field>
        <formula>TODAY()</formula>
        <name>Opportunity: Sync Opp to Banner Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Uncheck_Process_Assignments</fullName>
        <description>Checked by a PB if the Opportunity Assignment Rules need to be calculated.</description>
        <field>Process_Assignments__c</field>
        <literalValue>0</literalValue>
        <name>Opportunity: Uncheck Process Assignments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Set_to_Applicant</fullName>
        <description>Sets Record Type to Applicant.</description>
        <field>RecordTypeId</field>
        <lookupValue>Applicant_Opportunity</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type: Set to Applicant</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Set_to_Inquiry</fullName>
        <description>Sets Record Type to Inquiry Opportunity</description>
        <field>RecordTypeId</field>
        <lookupValue>Inquiry_Opportunity</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type: Set to Inquiry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Opportunity%3A Admissions Integration Code</fullName>
        <actions>
            <name>Opportunity_Admissions_Integration_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Mark Sync Opportunity to Banner</fullName>
        <actions>
            <name>Opportunity_Mark_Sync_Opp_to_Banner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Sync_Opp_to_Banner_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When applicable change was made to the opportunity record that needs to be sync&apos;d to Banner, set a checkbox and date field.</description>
        <formula>OR (     				ISNEW(),    				ISCHANGED(Academic_Program__c),     				ISCHANGED(School_College__c),    				ISCHANGED(Admit_Type__c),     				ISCHANGED(Cohort__c),    				ISCHANGED(Secondary_Cohort__c),    				ISCHANGED(StageName),     				ISCHANGED(Stage_Detail__c),     				ISCHANGED(Admission_Type__c),     				ISCHANGED(Withdrawal_Reason__c),    				ISCHANGED(Attributes__c)  ) &amp;&amp;   $User.FirstName != &quot;Oracle&quot; &amp;&amp; $User.LastName != &quot;Integration&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A PA Tasks - App Started</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Academic_Program_Code__c</field>
            <operation>equals</operation>
            <value>2-MS-PASG</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Applied</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Stage_Detail__c</field>
            <operation>equals</operation>
            <value>App Started</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_App_Started__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>PA has its own workflow because they need to be delayed by an hour. This is because we load them and they progress through the statuses as we load.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>App_Started_Call</name>
                <type>Task</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3A PA Tasks - App Submitted</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Academic_Program_Code__c</field>
            <operation>equals</operation>
            <value>2-MS-PASG</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Applied</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Stage_Detail__c</field>
            <operation>equals</operation>
            <value>App Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_App_Submitted__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>PA has its own workflow because they need to be delayed by an hour. This is because we load them and they progress through the statuses as we load.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Applied_Thank_You_Call</name>
                <type>Task</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3A PA Tasks - Inquired</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Academic_Program_Code__c</field>
            <operation>equals</operation>
            <value>2-MS-PASG</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Inquired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_Inquired__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>PA has a seperate workflow because the task creation is delayed. It is delayed because we load PA Apps and they often move statuses as we load.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Welcome_Call_1</name>
                <type>Task</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3A Remove Withdrawal Reason at positive status</fullName>
        <actions>
            <name>Opportunity_Clear_Date_File_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Clear_Withdrawal_Detail</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Clear_Withdrawal_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Inquired,Applied,Wait Listed,Accepted,Confirmed,Enrolled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Withdrawal_Reason__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_File_Closed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Remove text from Withdrawal Reason if the Opportunity moves from File Closed back to Open.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Rename if Term Changed</fullName>
        <actions>
            <name>Opportunity_Clear_Banner_App_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Rename_if_Term_Changes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Academic_Term__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Set Applicant Record Type</fullName>
        <actions>
            <name>Record_Type_Set_to_Applicant</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the record type to Applicant</description>
        <formula>ISCHANGED(StageName) &amp;&amp; ISPICKVAL(StageName, &quot;Applied&quot;) &amp;&amp; RecordType.Name &lt;&gt; &quot;Applicant_Opportunity&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Set Application Submitted Date</fullName>
        <actions>
            <name>Opportunity_Application_Submitted_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Application Submitted Date to Today when the Stage is changed to Applied.</description>
        <formula>ISCHANGED(StageName) &amp;&amp; ISPICKVAL(StageName, &quot;Applied&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Set BUILD Student Type</fullName>
        <actions>
            <name>Opportunity_Student_Type_BUILD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Academic_Program_Code__c</field>
            <operation>equals</operation>
            <value>1-CRT-BAS</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Set First Inquiry Source</fullName>
        <actions>
            <name>Opportunity_Set_First_Inquiry_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the First Inquiry Source field when it is blank.</description>
        <formula>ISBLANK( First_Inquiry_Source__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Set First Recruitment Program</fullName>
        <actions>
            <name>Opportunity_First_Recruitment_Program</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the First Recruitment Program field when it is blank.</description>
        <formula>ISBLANK( First_Recruitment_Program__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Set Inquiry Date</fullName>
        <actions>
            <name>Opportunity_Set_Inquiry_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Inquiry_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Sets the Inquiry Date if the Opportunity is created or edited and the Inquiry Date is blank.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Set Inquiry Record Type</fullName>
        <actions>
            <name>Record_Type_Set_to_Inquiry</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the record type to Inquiry based on Stage.</description>
        <formula>ISCHANGED(StageName) &amp;&amp; ISPICKVAL(StageName, &quot;Inquired&quot;) &amp;&amp; RecordType.Name &lt;&gt; &quot;Inquiry_Opportunity&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Set PSEO Student Type</fullName>
        <actions>
            <name>Opportunity_Student_Type_PSEO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(
ISPICKVAL(Application__r.Is_Applying_For_PSEO__c, &apos;Yes&apos;),
OR(
ISPICKVAL(Application__r.When_College_Credits_Earned__c, &quot;During High School (PSEO, AP, CLEP, IB, other)&quot;),
ISPICKVAL(Application__r.When_College_Credits_Earned__c, &quot;&quot;)
),
NOT(ISPICKVAL(Student_Type__c, &quot;New Student Previous PSEO&quot;))
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Set Transfer Student Type</fullName>
        <actions>
            <name>Opportunity_Student_Type_Transfer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(
				NOT(ISPICKVAL(Student_Type__c, &quot;New Student Previous PSEO&quot;)), 
    
				OR(
								 AND(
													TEXT(School_College__c) = &apos;Undergraduate&apos;,
													OR(
																	TEXT(Application__r.When_College_Credits_Earned__c) = &apos;After High School graduation&apos;,
																	TEXT(Application__r.When_College_Credits_Earned__c) = &apos;Both during and after High School&apos;
																	
													)
			     ),
								AND(
												TEXT(School_College__c) = &apos;Adult Undergraduate&apos;,
												OR( 				
																TEXT(Application__r.College_Credits_Transferred__c) = &apos;1-30 transfer credits&apos;, 				
																TEXT(Application__r.College_Credits_Transferred__c) = &apos;More than 30 transfer credits&apos;	
												)
								)
				)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Status Timestamp Updates</fullName>
        <actions>
            <name>Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Date_App_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Date_App_Started</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Date_App_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Date_Confirmed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Date_File_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Date_Inquired</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Stage_Modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the DateTime fields on the Opportunity when the Opportunity is saved and the Stage field is changed. Not sure if its best to have all the field updates in one workflow or if they should each have their own. My guess is all in one is more efficient.</description>
        <formula>ISNEW()||ISCHANGED(StageName) || ISCHANGED(Stage_Detail__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Tasks - Accepted</fullName>
        <actions>
            <name>Accepted_Congrats_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Stage_Detail__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_Confirmed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_Accepted__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ActSix__c</field>
            <operation>notEqual</operation>
            <value>Applicant,Finalist,Scholar</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Academic_Program_Code__c</field>
            <operation>notEqual</operation>
            <value>2-MS-PASG</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_Accepted__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Tasks - App Completed</fullName>
        <actions>
            <name>App_Complete_Review</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Applied</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Stage_Detail__c</field>
            <operation>equals</operation>
            <value>App Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_Accepted__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_App_Completed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ActSix__c</field>
            <operation>notEqual</operation>
            <value>Applicant,Finalist,Scholar</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Academic_Program_Code__c</field>
            <operation>notEqual</operation>
            <value>2-MS-PASG</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_App_Completed__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Workflow to create a task to followup with a student after their application is moved to App Completed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Tasks - App Started</fullName>
        <actions>
            <name>App_Started_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Inquired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Stage_Detail__c</field>
            <operation>equals</operation>
            <value>App Started</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_App_Submitted__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_App_Started__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.School_College__c</field>
            <operation>notEqual</operation>
            <value>Undergraduate</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Academic_Program_Code__c</field>
            <operation>notEqual</operation>
            <value>2-MS-PASG</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_App_Started__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Create tasks for Counselors to followup with students once they start their application.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Tasks - App Submitted</fullName>
        <actions>
            <name>Applied_Thank_You_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Applied</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Stage_Detail__c</field>
            <operation>equals</operation>
            <value>App Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_App_Submitted__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_App_Completed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ActSix__c</field>
            <operation>notEqual</operation>
            <value>Applicant,Finalist,Scholar</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Academic_Program_Code__c</field>
            <operation>notEqual</operation>
            <value>2-MS-PASG</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_App_Submitted__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Workflow rule to create a Task to followup with a student after they have submitted their Application.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Tasks - Confirmed</fullName>
        <actions>
            <name>Confirmed_Enrollment</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_Confirmed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ActSix__c</field>
            <operation>notEqual</operation>
            <value>Applicant,Finalist,Scholar</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Academic_Program_Code__c</field>
            <operation>notEqual</operation>
            <value>2-MS-PASG</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_Confirmed__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Workflow to create a Task for counselor to follow up with student after they have been confirmed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Tasks - Inquired</fullName>
        <actions>
            <name>Welcome_Call_1</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Inquired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_App_Started__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_App_Submitted__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.School_College__c</field>
            <operation>notEqual</operation>
            <value>Undergraduate</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Academic_Program_Code__c</field>
            <operation>notEqual</operation>
            <value>2-MS-PASG</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Stage_Detail__c</field>
            <operation>equals</operation>
            <value>Inquired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Term_Start_Date_255__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_Inquired__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Create CSG tasks when a new Inquired opportunity is created or set to Inquired status.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Tasks - Inquired - Program Changed</fullName>
        <actions>
            <name>Welcome_Call_1_Opportunity_Program_Change</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>AND(    
    NOT(ISNEW()),    
    ISCHANGED(Academic_Program__c), 
    Academic_Program_Code__c &lt;&gt; &apos;2-MS-PASG&apos;,
    TEXT(StageName) = &apos;Inquired&apos;,
    ISNULL(Date_App_Started__c),
    Term_Start_Date_255__c &gt;= TODAY(),
    $User.LastName = &quot;Master&quot;,
    $User.FirstName = &quot;Web&quot; 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Uncheck Process Assignments</fullName>
        <actions>
            <name>Opportunity_Uncheck_Process_Assignments</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Process_Assignments__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Checked by a PB if the Opportunity assignments should run. Hopefully this doesn&apos;t trigger everything again.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Update Name</fullName>
        <actions>
            <name>Opportunity_Name_Set_to_Last_Term</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Updates Opportunity Name to Contact Last - Term Name</description>
        <formula>Name &lt;&gt; Contact__r.LastName</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Update Opportunity Key</fullName>
        <actions>
            <name>Opportunity_Key_Set_Based_on_Career</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Opportunity Key based on the Career, Recruitment Program or Academic Program, and Term, according to the formula used in the Opportunity Key field on the Interactions object.</description>
        <formula>AND( 				
    Opportunity_Key__c &lt;&gt; CASESAFEID(Contact__r.Id) + &quot;.&quot; + TEXT(School_College__c) + &quot;.&quot; + Academic_Term__r.Name, 				
     Is_Cloned__c = False
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Accepted_Congrats_Call</fullName>
        <assignedToType>owner</assignedToType>
        <description>Congrats you&apos;re accepted!</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Accepted: Congrats Call</subject>
    </tasks>
    <tasks>
        <fullName>App_Complete_Review</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>App Complete: Review</subject>
    </tasks>
    <tasks>
        <fullName>App_Started_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>App Started Call</subject>
    </tasks>
    <tasks>
        <fullName>Applied_Thank_You_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Applied - Thank You Call</subject>
    </tasks>
    <tasks>
        <fullName>Confirmed_Enrollment</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Confirmed Enrollment</subject>
    </tasks>
    <tasks>
        <fullName>Welcome_Call_1</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Welcome Call 1</subject>
    </tasks>
    <tasks>
        <fullName>Welcome_Call_1_Opportunity_Program_Change</fullName>
        <assignedTo>e-jameson+neworg@bethel.edu</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Welcome Call 1 (Opportunity Program Change)</subject>
    </tasks>
</Workflow>
