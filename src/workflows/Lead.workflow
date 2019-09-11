<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Mogli_SMS__UpdateMogliNumber</fullName>
        <description>Update Mogli Number based on value in Mobile field (and remove all non-numerical values)</description>
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
        <fullName>Remove_Email_Address_Lead</fullName>
        <description>When loading people without emails, we need to give it a fake email address because the Interaction object requires one. After it is processed by the Interaction, go back and delete the data from the Contact or Lead. Leave on Interaction as a reference.</description>
        <field>Email</field>
        <name>Remove Email Address - Lead</name>
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
        <fullName>DaScoopComposer__Notify Groove on Lead Created %28Managed%29</fullName>
        <actions>
            <name>DaScoopComposer__Notify_Groove</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>This WF rule can be activated if you want to notify Groove that a new lead was created. That way Groove can e.g. instantly import the lead to a Groove Flow that has auto import enabled (and meets the auto-import rules of that Flow).</description>
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
            <field>Lead.MobilePhone</field>
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
        <active>true</active>
        <criteriaItems>
            <field>Lead.MobilePhone</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Mogli Number based on value in Mobile field (and remove all non-numerical values)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Remove %40blackhole email address</fullName>
        <actions>
            <name>Remove_Email_Address_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>contains</operation>
            <value>@blackhole.bethel.edu</value>
        </criteriaItems>
        <description>When loading people without emails, we need to give it a fake email address because the Interaction object requires one. After it is processed by the Interaction, go back and delete the data from the Contact or Lead. Leave on Interaction as a reference.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
