<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Campaign_Check_Migration_Time_Fixed</fullName>
        <field>Start_Time__c</field>
        <formula>Start_Time__c - (5/24)</formula>
        <name>Campaign: Check Migration Time Fixed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Key_Set_to_ID</fullName>
        <description>Sets the Campaign Key field on Campaign to the Salesforce ID.</description>
        <field>Campaign_Key__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>Campaign Key: Set to ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Update_Appointment_name</fullName>
        <field>Name</field>
        <formula>TEXT(Type)</formula>
        <name>Campaign: Update Appointment name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Update_Visit_Name</fullName>
        <description>updates Visit name when created/edited</description>
        <field>Name</field>
        <formula>text(Type) &amp; &quot; - &quot; &amp;  Contact__r.Preferred_Name_Calculated__c &amp; &quot; &quot; &amp; Contact__r.LastName</formula>
        <name>Campaign: Update Visit Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Campaign%3A Clean Appointment Name</fullName>
        <actions>
            <name>Campaign_Update_Appointment_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Appointment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Type</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>updates Appointment name to be consistent with others</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Campaign%3A Clean Visit name</fullName>
        <actions>
            <name>Campaign_Update_Visit_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Visit</value>
        </criteriaItems>
        <description>makes Visit Campaign types consistent</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Campaign%3A Update Campaign Key</fullName>
        <actions>
            <name>Campaign_Key_Set_to_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Campaign_Key__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Updates the Campaign Key on Campaign when it is blank.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Campaign%3A subtract 5 hours</fullName>
        <actions>
            <name>Campaign_Check_Migration_Time_Fixed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Visit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Migration_Time_Fixed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>corrects visits start time from 05/10/19 migration</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
