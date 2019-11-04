<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>User_Update_Last_Login_Custom</fullName>
        <description>Sets Last Login (Custom) to Today when a user logs in.</description>
        <field>Last_Login_Custom__c</field>
        <formula>TODAY()</formula>
        <name>User: Update Last Login (Custom)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>User%3A ContactID Changed</fullName>
        <active>false</active>
        <formula>ISCHANGED(ContactId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>User%3A Update Last Login %28Custom%29</fullName>
        <actions>
            <name>User_Update_Last_Login_Custom</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User.LastLoginDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>On user login, update their Last Login (Custom) field with todays date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
