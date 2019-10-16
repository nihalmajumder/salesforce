<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Date_Completed_Today_s_Date</fullName>
        <field>Date_Completed__c</field>
        <formula>TODAY()</formula>
        <name>Date Completed: Today&apos;s Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Task%3A Update Date Completed when Closed</fullName>
        <actions>
            <name>Date_Completed_Today_s_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Email</field>
            <operation>notEqual</operation>
            <value>josh-saterdalen@bethel.edu</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
