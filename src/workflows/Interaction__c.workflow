<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Interaction_Set_Mn_to_Minnesota</fullName>
        <field>Mailing_State__c</field>
        <literalValue>Minnesota</literalValue>
        <name>Interaction: Set Mn to Minnesota</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Interaction%3A Set Mn to Minnesota</fullName>
        <actions>
            <name>Interaction_Set_Mn_to_Minnesota</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Interaction__c.Mailing_State__c</field>
            <operation>equals</operation>
            <value>Mn</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
