<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_Closed_Alert</fullName>
        <description>Case: Closed Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@bethel.edu</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Case_Closed</template>
    </alerts>
    <alerts>
        <fullName>Case_New_Stakeholder</fullName>
        <description>Case: New Stakeholder</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@bethel.edu</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Case_New_Stakeholder</template>
    </alerts>
    <alerts>
        <fullName>Case_Ownership_Change</fullName>
        <description>Case Ownership Change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Ownership_Changed</template>
    </alerts>
    <fieldUpdates>
        <fullName>Case_Change_Owner_to_Advising_Queue</fullName>
        <description>Changes Owner to SSR-Advising Queue</description>
        <field>OwnerId</field>
        <lookupValue>SSR_Advising</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case: Change Owner to Advising Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Case%3A Schedule and Retention Assignment</fullName>
        <actions>
            <name>Case_Change_Owner_to_Advising_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Schedule - Admissions,Retention</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Assign_SSR_Advising__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Assigns new Schedule Request Cases and Retention Cases to the SSR - Advising queue.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
