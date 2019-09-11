<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_External_Reminder</fullName>
        <description>Email External Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>External_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Application_Email_Templates/External_Response_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Email_External_Response</fullName>
        <description>Email External Response</description>
        <protected>false</protected>
        <recipients>
            <field>External_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Application_Email_Templates/External_Response_Requested</template>
    </alerts>
    <alerts>
        <fullName>Recommender_Email_Alert_For_CAPS</fullName>
        <description>Recommender Email Alert For CAPS</description>
        <protected>false</protected>
        <recipients>
            <field>External_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>adult-undergrad-admissions@bethel.edu</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Application_Email_Templates/Recommender_Email_CAPS</template>
    </alerts>
    <alerts>
        <fullName>Recommender_Email_Alert_For_CAPS_GS</fullName>
        <description>Recommender Email Alert For CAPS/GS</description>
        <protected>false</protected>
        <recipients>
            <field>External_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>graduate-admissions@bethel.edu</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Application_Email_Templates/Recommender_Email_GS</template>
    </alerts>
    <alerts>
        <fullName>Recommender_Email_Alert_For_CAS</fullName>
        <description>Recommender Email Alert For CAS</description>
        <protected>false</protected>
        <recipients>
            <field>External_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>undergrad-admissions@bethel.edu</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Application_Email_Templates/Recommender_Email_CAS</template>
    </alerts>
    <alerts>
        <fullName>Recommender_Email_Alert_For_GS</fullName>
        <description>Recommender Email Alert For GS</description>
        <protected>false</protected>
        <recipients>
            <field>External_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>graduate-admissions@bethel.edu</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Application_Email_Templates/Recommender_Email_GS</template>
    </alerts>
    <alerts>
        <fullName>Recommender_Email_Alert_For_Seminary</fullName>
        <description>Recommender Email Alert For Seminary</description>
        <protected>false</protected>
        <recipients>
            <field>External_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>seminary-admissions@bethel.edu</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Application_Email_Templates/Recommender_Email_Seminary</template>
    </alerts>
    <alerts>
        <fullName>Recommender_Email_Alert_For_Seminary_Ministry</fullName>
        <description>Recommender Email Alert For Seminary Ministry Context</description>
        <protected>false</protected>
        <recipients>
            <field>External_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>seminary-admissions@bethel.edu</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Application_Email_Templates/Recommender_Email_Seminary_Ministry</template>
    </alerts>
    <alerts>
        <fullName>Recommender_Email_Alert_For_Seminary_Vocational</fullName>
        <description>Recommender Email Alert For Seminary Vocational Context</description>
        <protected>false</protected>
        <recipients>
            <field>External_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>seminary-admissions@bethel.edu</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Application_Email_Templates/Recommender_Email_Seminary_Vocational</template>
    </alerts>
</Workflow>
