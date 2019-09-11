<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <actionOverrides>
        <actionName>View</actionName>
        <comment>Action override created by Lightning App Builder during activation.</comment>
        <content>Case_Record_Page_student_success</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>Case</pageOrSobjectType>
    </actionOverrides>
    <actionOverrides>
        <actionName>Tab</actionName>
        <content>Student_Success_Home_Page</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>standard-home</pageOrSobjectType>
    </actionOverrides>
    <actionOverrides>
        <actionName>View</actionName>
        <comment>Action override created by Lightning App Builder during activation.</comment>
        <content>Contact_Record_Page_SSR</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>Contact</pageOrSobjectType>
    </actionOverrides>
    <brand>
        <headerColor>#7A003C</headerColor>
        <logo>bethellogoverticalcolor14</logo>
        <logoVersion>1</logoVersion>
        <shouldOverrideOrgTheme>false</shouldOverrideOrgTheme>
    </brand>
    <description>Productivity Mode. Let&apos;s go!</description>
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>false</isNavPersonalizationDisabled>
    <label>SSR Console</label>
    <navType>Console</navType>
    <setupExperience>service</setupExperience>
    <tabs>standard-home</tabs>
    <tabs>standard-Task</tabs>
    <tabs>standard-report</tabs>
    <tabs>standard-Case</tabs>
    <tabs>standard-Contact</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>SSR_Console_UtilityBar</utilityBar>
    <workspaceConfig>
        <mappings>
            <fieldName>ContactId</fieldName>
            <tab>standard-Case</tab>
        </mappings>
        <mappings>
            <tab>standard-Contact</tab>
        </mappings>
        <mappings>
            <tab>standard-Task</tab>
        </mappings>
        <mappings>
            <tab>standard-home</tab>
        </mappings>
        <mappings>
            <tab>standard-report</tab>
        </mappings>
    </workspaceConfig>
</CustomApplication>
