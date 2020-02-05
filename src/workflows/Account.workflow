<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Account_Set_owner_to_Webmaster</fullName>
        <field>OwnerId</field>
        <lookupValue>webmaster+neworg@bethel.edu</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Account: Set owner to Webmaster</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account%3A Change owner if created by Applicant</fullName>
        <actions>
            <name>Account_Set_owner_to_Webmaster</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Applicant Community Login User</value>
        </criteriaItems>
        <description>Used to update the Owner when Applicants create Accounts via Interactions. This happens during the &quot;Family Member&quot; automation flow.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account%3A Change owner if created by SMS Site Guest User</fullName>
        <actions>
            <name>Account_Set_owner_to_Webmaster</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>SMS Site Guest User</value>
        </criteriaItems>
        <description>Used to update the Owner when an Account is created via the &quot;Interaction Creation from Mogli&quot; Flow.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
