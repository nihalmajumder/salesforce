<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contact_Address_Needs_Cleaning</fullName>
        <field>Cleaned_Address__c</field>
        <literalValue>Needs Cleaning</literalValue>
        <name>Contact: Address Needs Cleaning</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Check_Sync_To_Banner</fullName>
        <field>Sync_to_Banner__c</field>
        <literalValue>1</literalValue>
        <name>Contact: Check Sync To Banner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Update_Mogli_Opt_Out_to_False</fullName>
        <description>Update Mogli Opt Out field when the field &quot;hed__Do_Not_Contact__c&quot; on the Contact changes.</description>
        <field>Mogli_SMS__Mogli_Opt_Out__c</field>
        <literalValue>0</literalValue>
        <name>Contact: Update Mogli Opt-Out to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Update_Mogli_Opt_Out_to_True</fullName>
        <description>Update Mogli Opt Out field when the field &quot;hed__Do_Not_Contact__c&quot; on the Contact changes.</description>
        <field>Mogli_SMS__Mogli_Opt_Out__c</field>
        <literalValue>1</literalValue>
        <name>Contact: Update Mogli Opt-Out to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Delete_Preferred_Email</fullName>
        <field>hed__Preferred_Email__c</field>
        <name>Delete Preferred Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mogli_SMS__UpdateMogliNumber</fullName>
        <description>Update Mogli Number based on value in Mobile field (remove all non-numerical values)</description>
        <field>Mogli_SMS__Mogli_Number__c</field>
        <formula>SUBSTITUTE(
SUBSTITUTE(
SUBSTITUTE(
SUBSTITUTE(MobilePhone, &quot;(&quot;, &quot;&quot;), &quot;)&quot;, &quot;&quot;), &quot; &quot;, &quot;&quot;), &quot;-&quot;, &quot;&quot;)</formula>
        <name>Update Mogli Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mogli_SMS__Update_Mogli_Number_with_WITH_PLUS</fullName>
        <description>Update Mogli Number based on value in Mobile field (remove all non-numerical values) WITH PLUS added to front of Mogli Number</description>
        <field>Mogli_SMS__Mogli_Number__c</field>
        <formula>&quot;+1&quot;&amp; SUBSTITUTE(
       SUBSTITUTE(
        SUBSTITUTE(
         SUBSTITUTE(
          SUBSTITUTE(MobilePhone , &quot;(&quot;, &quot;&quot;),&quot;)&quot;,&quot;&quot;),&quot;-&quot;,&quot;&quot;),&quot; &quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;)</formula>
        <name>Update Mogli Number with WITH PLUS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Alternate_Email_Address</fullName>
        <description>When loading people without emails, we need to give it a fake email address because the Interaction object requires one. After it is processed by the Interaction, go back and delete the data from the Contact or Lead. Leave on Interaction as a reference.</description>
        <field>hed__AlternateEmail__c</field>
        <name>Remove Alternate Email Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Email_Address</fullName>
        <description>When loading people without emails, we need to give it a fake email address because the Interaction object requires one. After it is processed by the Interaction, go back and delete the data from the Contact or Lead. Leave on Interaction as a reference.</description>
        <field>Email</field>
        <name>Remove Email Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>DaScoopComposer__Notify_Groove</fullName>
        <apiVersion>40.0</apiVersion>
        <description>Sends an outbound message to Groove with the record ID and owner ID. This is used for real-time auto-import to Groove Flow.</description>
        <endpointUrl>https://app.grooveapp.com/salesforce/updates</endpointUrl>
        <fields>Id</fields>
        <fields>OwnerId</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>josh-saterdalen@bethel.edu</integrationUser>
        <name>Notify Groove (Managed)</name>
        <protected>true</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Contact%3A Check Sync To Banner</fullName>
        <actions>
            <name>Contact_Check_Sync_To_Banner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If certain fields change, check the &quot;Sync Contact to Banner&quot; checkbox.</description>
        <formula>OR(  				ISCHANGED(Birthdate),  				ISCHANGED(Preferred_First_Name__c), 				ISCHANGED(Phone), 				ISCHANGED(OtherPhone),  				ISCHANGED(MobilePhone),  				ISCHANGED(MailingCity),  				ISCHANGED(MailingCountry),  				ISCHANGED(MailingPostalCode),  				ISCHANGED(MailingStreet),  				ISCHANGED(MailingState),  				ISCHANGED(FirstName),  				ISCHANGED(LastName),  				ISCHANGED(Former_Last_Name__c),  				ISCHANGED(Is_Hispanic__c),  				ISCHANGED(Citizenship__c),  				ISCHANGED(Denomination_Description__c),  				ISCHANGED(hed__Gender__c),  				ISCHANGED(hed__Ethnicity__c),  				ISCHANGED(Suffix),  				ISCHANGED(Email), 				ISCHANGED(hed__AlternateEmail__c),     ISCHANGED(Username__c), 				ISCHANGED(Banner_Id__c) ) &amp;&amp; $User.FirstName != &quot;Bethel&quot; &amp;&amp; $User.LastName != &quot;Integration&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact%3A Maintain Cleaned Address Flag</fullName>
        <actions>
            <name>Contact_Address_Needs_Cleaning</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Users other than Oracle Integration can only set this field to &quot;Overridden&quot; or &quot;Needs Cleaning&quot;.</description>
        <formula>ISCHANGED(Cleaned_Address__c) &amp;&amp; $User.FirstName != &quot;Oracle&quot; &amp;&amp; $User.LastName != &quot;Integration&quot; &amp;&amp; NOT(ISPICKVAL(Cleaned_Address__c, &quot;Overridden&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact%3A Update Address Flag when new Address entered</fullName>
        <actions>
            <name>Contact_Address_Needs_Cleaning</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When someone other than the Jitterbit User updates an address on the Contact, set the &quot;Address Has Been Cleaned&quot; field to &quot;Needs Cleaning&quot;.</description>
        <formula>ISCHANGED(MailingAddress) &amp;&amp;   NOT(ISPICKVAL(Cleaned_Address__c, &quot;Overridden&quot;)) &amp;&amp;  $User.FirstName != &quot;Oracle&quot; &amp;&amp; $User.LastName != &quot;Integration&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact%3A Update Mogli Opt-Out Field to False</fullName>
        <actions>
            <name>Contact_Update_Mogli_Opt_Out_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Contact.hed__Do_Not_Contact__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.hed__Do_Not_Contact__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update Mogli Opt Out field when the field &quot;hed__Do_Not_Contact__c&quot; on the Contact changes.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact%3A Update Mogli Opt-Out Field to True</fullName>
        <actions>
            <name>Contact_Update_Mogli_Opt_Out_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.hed__Do_Not_Contact__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update Mogli Opt Out field when the field &quot;hed__Do_Not_Contact__c&quot; on the Contact changes.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DaScoopComposer__Notify Groove on Contact Created %28Managed%29</fullName>
        <actions>
            <name>DaScoopComposer__Notify_Groove</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>This WF rule can be activated if you want to notify Groove that a new contact was created. That way Groove can e.g. instantly import the contact to a Groove Flow that has auto import enabled (and meets the auto-import rules of that Flow).</description>
        <formula>ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Mogli_SMS__WITH PLUS - onCreateEditWhenMobileNotNull</fullName>
        <actions>
            <name>Mogli_SMS__Update_Mogli_Number_with_WITH_PLUS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.MobilePhone</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Mogli Number based on value in Mobile field (remove all non-numerical values) WITH PLUS added to front of Mogli Number</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Mogli_SMS__onCreateEditWhenMobileNotNull</fullName>
        <actions>
            <name>Mogli_SMS__UpdateMogliNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.MobilePhone</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Mogli Number based on value in Mobile field (and remove all non-numerical values)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Remove %40blackhole email address</fullName>
        <actions>
            <name>Delete_Preferred_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Alternate_Email_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Email_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>contains</operation>
            <value>@blackhole.bethel.edu</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.hed__AlternateEmail__c</field>
            <operation>contains</operation>
            <value>@blackhole.bethel.edu</value>
        </criteriaItems>
        <description>When loading people without emails, we need to give it a fake email address because the Interaction object requires one. After it is processed by the Interaction, go back and delete the data from the Contact or Lead. Leave on Interaction as a reference.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
