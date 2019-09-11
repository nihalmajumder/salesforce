<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <actionOverrides>
        <actionName>Tab</actionName>
        <content>CAS_Admissions_Home_Page</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>standard-home</pageOrSobjectType>
    </actionOverrides>
    <brand>
        <headerColor>#0069AA</headerColor>
        <logo>bethellogoverticalcolor2</logo>
        <logoVersion>1</logoVersion>
        <shouldOverrideOrgTheme>false</shouldOverrideOrgTheme>
    </brand>
    <description>Personalized home for CAS Admissions employees.</description>
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>false</isNavPersonalizationDisabled>
    <label>CAS Admissions</label>
    <navType>Standard</navType>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Campaign_Record_Page_Event</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Campaign</pageOrSobjectType>
        <recordType>Campaign.Event_Campaign_Record</recordType>
        <type>Flexipage</type>
        <profile>Admissions - CAS</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Campaign_Record_Page_Event</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Campaign</pageOrSobjectType>
        <recordType>Campaign.Event_Campaign_Record</recordType>
        <type>Flexipage</type>
        <profile>Admissions - Post-Trad</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Campaign_Record_Page_Event</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Campaign</pageOrSobjectType>
        <recordType>Campaign.Event_Campaign_Record</recordType>
        <type>Flexipage</type>
        <profile>ITS - Analyst</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Campaign_Record_Page_Event</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Campaign</pageOrSobjectType>
        <recordType>Campaign.Event_Campaign_Record</recordType>
        <type>Flexipage</type>
        <profile>Admin</profile>
    </profileActionOverrides>
    <tabs>standard-home</tabs>
    <tabs>standard-Task</tabs>
    <tabs>standard-report</tabs>
    <tabs>standard-Opportunity</tabs>
    <tabs>standard-Contact</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>CAS_Admissions_UtilityBar</utilityBar>
</CustomApplication>
