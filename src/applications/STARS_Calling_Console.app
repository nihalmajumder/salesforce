<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <brand>
        <headerColor>#0070D2</headerColor>
        <shouldOverrideOrgTheme>false</shouldOverrideOrgTheme>
    </brand>
    <description>Console for STARS Callers</description>
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>true</isNavPersonalizationDisabled>
    <label>STARS Calling Console</label>
    <navType>Console</navType>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Account_Record_Page_Academic_Program</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Account</pageOrSobjectType>
        <recordType>Account.Academic_Program</recordType>
        <type>Flexipage</type>
        <profile>Admin</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Account_Record_Page_Academic_Program</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Account</pageOrSobjectType>
        <recordType>Account.Academic_Program</recordType>
        <type>Flexipage</type>
        <profile>Admissions Profile</profile>
    </profileActionOverrides>
    <setupExperience>service</setupExperience>
    <tabs>standard-Task</tabs>
    <tabs>Cohort__c</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>STARS_Calling_Console_UtilityBar</utilityBar>
    <workspaceConfig>
        <mappings>
            <tab>Cohort__c</tab>
        </mappings>
        <mappings>
            <fieldName>Department__c</fieldName>
            <tab>standard-Task</tab>
        </mappings>
    </workspaceConfig>
</CustomApplication>
