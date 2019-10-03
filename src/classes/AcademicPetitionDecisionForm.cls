/**
 * Created by phg49389 on 2019-04-29.
 */

public class AcademicPetitionDecisionForm {

    private Case editCase {get; set;}

    public AcademicPetitionDecisionForm(){
        String caseId = ApexPages.currentPage().getParameters().get('id');
        Case[] c = [
                SELECT Id, ContactId, Petition_Type__c, CaseNumber, Created_Date_Formatted__c,
                        Petition_Program__c, Course_Number__c, Instructor__c, Term_of_registration__c, I_am_appealing_the_following__c,
                        I_am_requesting_the_following__c, Details_of_circumstances__c, Academic_History__c,
                        Prior_Academic_Probation__c, If_yes_how_many_terms__c, Prior_Academic_Dismissal__c,
                        Inputs_perspective__c, Registrar_Summary__c, Decision_Maker_Name__c, Role__c, Decision__c,
                        Approval_Description__c, grace_grant_amount__c, approval_old_grade__c, approval_new_grade__c,
                        grade_change_factors__c, approval_academic_year__c, approval_extension_date__c,
                        approval_course_substitution__c, Denial_Description__c, Decision_Submitted__c,
                        Supporting_Documentation__c, Supporting_Documentation2__c, Supporting_Documentation3__c,
                        Supporting_Documentation4__c, Supporting_Documentation5__c
                FROM Case WHERE Id = :caseId
        ];
        editCase = c[0];
    }

    /*
        Setters and Getters
    */
    // Read-only fields that are read by the Decision Maker
    public String petitionType{
        get{
            return editCase.Petition_Type__c;
        }
        // Although it's read-only, petitionType needs a setter so that it can be used as a hidden input field
        set;
    }
    public String caseNumber{
        get{
            return editCase.CaseNumber;
        }
    }
    public String studentInfo{
        get{
            Contact student = [SELECT Id, FirstName, LastName, Banner_Id__c FROM Contact WHERE Id = :editCase.ContactId];
            return String.format('{0} {1}, {2}',
                    new List<Object> {student.FirstName, student.LastName, student.Banner_Id__c});
        }
    }
    public String createdDate{
        get{
            return editCase.Created_Date_Formatted__c;
        }
    }
    public String program{
        get{
            String pp = editCase.Petition_Program__c;
            return pp;
        }
    }
    public String courseNumber{
        get{
            String cn = editCase.Course_Number__c;
            return cn;
        }
    }
    public String instructor{
        get{
            String instructor = editCase.Instructor__c;
            return instructor;
        }
    }
    public String term{
        get{
            String term = editCase.Term_of_registration__c;
            return term;
        }
    }
    public String appealingTheFollowing{
        get{
            return editCase.I_am_appealing_the_following__c;
        }
    }
    public String requestingTheFollowing{
        get{
            return editCase.I_am_requesting_the_following__c;
        }
    }
    public String detailsCircumstances{
        get{
            return editCase.Details_of_circumstances__c;
        }
    }
    public String academicHistory{
        get{
            return editCase.Academic_History__c;
        }
    }
    public String priorAcademicProbation{
        get{
            return editCase.Prior_Academic_Probation__c;
        }
    }
    public String howManyTermsProbation{
        get{
            return editCase.If_yes_how_many_terms__c;
        }
    }
    public String priorAcademicDismissal{
        get{
            return editCase.Prior_Academic_Dismissal__c;
        }
    }
    public String inputsPerspective{
        get{
            return editCase.Inputs_perspective__c;
        }
    }
    public String registrarSummary{
        get{
            return editCase.Registrar_Summary__c;
        }
    }

    public String supportingDocumentation{
        get{
            return editCase.Supporting_Documentation__c;
        }
    }

    public String supportingDocumentation2{
        get{
            return editCase.Supporting_Documentation2__c;
        }
    }

    public String supportingDocumentation3{
        get{
            return editCase.Supporting_Documentation3__c;
        }
    }

    public String supportingDocumentation4{
        get{
            return editCase.Supporting_Documentation4__c;
        }
    }

    public String supportingDocumentation5{
        get{
            return editCase.Supporting_Documentation5__c;
        }
    }

    // Read/write fields that are used in the form submitted by the Decision Maker
    public String decisionMakerName{
        get{
            return editCase.Decision_Maker_Name__c;
        }
        set{
            editCase.Decision_Maker_Name__c = value;
        }
    }
    public String role{
        get{
            // This trick lets the selectList make the disabled "--None--" option the default
            if (editCase.Role__c == null){
                return 'None';
            }
            else {
                return editCase.Role__c;
            }
        }
        set{
            editCase.Role__c = value;
        }
    }
    public String decision{
        get{
            // This trick lets the selectList make the disabled "--None--" option the default
            if (editCase.Decision__c == null){
                return 'None';
            }
            else {
                return editCase.Decision__c;
            }
        }
        set{
            editCase.Decision__c = value;
        }
    }
    public String approvalDescription{
        get{
            // This trick lets the selectList make the disabled "--None--" option the default
            if (editCase.Approval_Description__c == null){
                return 'None';
            }
            else {
                return editCase.Approval_Description__c;
            }
        }
        set{
            editCase.Approval_Description__c = value;
        }
    }
    public String graceGrantAmount{
        get{
            return editCase.grace_grant_amount__c;
        }
        set{
            editCase.grace_grant_amount__c = value;
        }
    }
    public String approvalOldGrade{
        get{
            return editCase.approval_old_grade__c;
        }
        set{
            editCase.approval_old_grade__c = value;
        }
    }
    public String approvalNewGrade{
        get{
            return editCase.approval_new_grade__c;
        }
        set{
            editCase.approval_new_grade__c = value;
        }
    }
    public List<String> gradeChangeFactors{
        // This field gets stored internally as a String of semicolon-separated Strings.
        // In order to interface with the "apex:selectList multiple=true", it has to be
        // converted to and from an Array of Strings
        get {
            if (editCase.grade_change_factors__c == null){
                return new List<String>();
            }
            else{
                return editCase.grade_change_factors__c.split(';');
            }
        }
        set {
            Integer valueSize = value.size();
            if (valueSize > 0){
                String newValue = '';
                for(Integer i = 0; i < valueSize; i++){
                    newValue += value[i];
                    if (i < valueSize - 1){
                        newValue += ';';
                    }
                }
                editCase.grade_change_factors__c = newValue;
            }
            else {
                editCase.grade_change_factors__c = null;
            }
        }
    }
    public String approvalAcademicYear{
        get{
            return editCase.approval_academic_year__c;
        }
        set{
            editCase.approval_academic_year__c = value;
        }
    }
    public Date approvalExtensionDate{
        get{
            return editCase.approval_extension_date__c;
        }
        set{
            editCase.approval_extension_date__c = value;
        }
    }
    public String approvalCourseSubstitution{
        get{
            return editCase.approval_course_substitution__c;
        }
        set{
            editCase.approval_course_substitution__c = value;
        }
    }
    public String denialDescription{
        get{
            // This trick lets the selectList make the disabled "--None--" option the default
            if (editCase.Denial_Description__c == null){
                return 'None';
            }
            else {
                return editCase.Denial_Description__c;
            }
        }
        set{
            editCase.Denial_Description__c = value;
        }
    }
    public String comments{
        get{
            return '';
        }
//        set{
//            editCase.Comments__c = '';
//        }
    }

    /*
        Methods that get SelectOption Lists from picklist fields
        Sourced from https://salesforce.stackexchange.com/a/190969
    */
    public List<SelectOption> getroleOptions() {
        // do a field describe of the picklist field
        Schema.DescribeFieldResult describeResult = Case.Role__c.getDescribe();

        // get the picklist values from this describe result
        List<Schema.PicklistEntry> entries = describeResult.getPicklistValues();

        // list of options to be returned to the VF page
        List<SelectOption> optionsToReturn = new List<SelectOption>();

        if (editCase.Role__c == null){
            // Make the default first option "--None--" but make it disabled so that it can't be submitted
            optionsToReturn.add(new SelectOption('None', '--None--', true));
        }

        for (Schema.PicklistEntry pEntry : entries) {
            if (pEntry.isActive()) {
                optionsToReturn.add(new SelectOption(pEntry.getValue(), pEntry.getLabel()));
            }
        }

        return optionsToReturn;
    }
    public List<SelectOption> getdecisionOptions() {
        // do a field describe of the picklist field
        Schema.DescribeFieldResult describeResult = Case.Decision__c.getDescribe();

        // get the picklist values from this describe result
        List<Schema.PicklistEntry> entries = describeResult.getPicklistValues();

        // list of options to be returned to the VF page
        List<SelectOption> optionsToReturn = new List<SelectOption>();

        if (editCase.Decision__c == null){
            // Make the default first option "--None--" but make it disabled so that it can't be submitted
            optionsToReturn.add(new SelectOption('None', '--None--', true));
        }

        for (Schema.PicklistEntry pEntry : entries) {
            if (pEntry.isActive()) {
                optionsToReturn.add(new SelectOption(pEntry.getValue(), pEntry.getLabel()));
            }
        }

        return optionsToReturn;
    }
    public List<SelectOption> getgradeChangeFactorsOptions() {
        // do a field describe of the picklist field
        Schema.DescribeFieldResult describeResult = Case.grade_change_factors__c.getDescribe();

        // get the picklist values from this describe result
        List<Schema.PicklistEntry> entries = describeResult.getPicklistValues();

        // list of options to be returned to the VF page
        List<SelectOption> optionsToReturn = new List<SelectOption>();

        for (Schema.PicklistEntry pEntry : entries) {
            if (pEntry.isActive()) {
                optionsToReturn.add(new SelectOption(pEntry.getValue(), pEntry.getLabel()));
            }
        }

        return optionsToReturn;
    }

    public List<SelectOption> getapprovalDescriptionDependentPicklistOptions(){
        Map<Object, List<String>> dependencies = getDependentPicklistValues(Case.Approval_Description__c);

        // Return an empty list if no values are valid for the current value of the controlling field
        if (!dependencies.keySet().contains(editCase.Petition_Type__c)){
            return new List<SelectOption>();
        }

        List<String> validOptionLabels = dependencies.get(editCase.Petition_Type__c);

        // do a field describe of the picklist field
        Schema.DescribeFieldResult describeResult = Case.Approval_Description__c.getDescribe();

        // get the picklist values from this describe result
        List<Schema.PicklistEntry> entries = describeResult.getPicklistValues();

        // list of options to be returned to the VF page
        List<SelectOption> optionsToReturn = new List<SelectOption>();

        if (editCase.Approval_Description__c == null){
            // Make the default first option "--None--" but make it disabled so that it can't be submitted
            optionsToReturn.add(new SelectOption('None', '--None--', true));
        }

        for (Schema.PicklistEntry pEntry : entries) {
            if (pEntry.isActive() && validOptionLabels.contains(pEntry.getLabel())) {
                optionsToReturn.add(new SelectOption(pEntry.getValue(), pEntry.getLabel()));
            }
        }

        return optionsToReturn;
    }
    public List<SelectOption> getdenialDescriptionDependentPicklistOptions(){
        Map<Object, List<String>> dependencies = getDependentPicklistValues(Case.Denial_Description__c);

        // Return an empty list if no values are valid for the current value of the controlling field
        if (!dependencies.keySet().contains(editCase.Petition_Type__c)){
            return new List<SelectOption>();
        }

        List<String> validOptionLabels = dependencies.get(editCase.Petition_Type__c);

        // do a field describe of the picklist field
        Schema.DescribeFieldResult describeResult = Case.Denial_Description__c.getDescribe();

        // get the picklist values from this describe result
        List<Schema.PicklistEntry> entries = describeResult.getPicklistValues();

        // list of options to be returned to the VF page
        List<SelectOption> optionsToReturn = new List<SelectOption>();

        if (editCase.Denial_Description__c == null){
            // Make the default first option "--None--" but make it disabled so that it can't be submitted
            optionsToReturn.add(new SelectOption('None', '--None--', true));
        }

        for (Schema.PicklistEntry pEntry : entries) {
            if (pEntry.isActive() && validOptionLabels.contains(pEntry.getLabel())) {
                optionsToReturn.add(new SelectOption(pEntry.getValue(), pEntry.getLabel()));
            }
        }

        return optionsToReturn;
    }

    /*
        Proper methods
     */
    // Sourced from: https://developer.salesforce.com/forums/?id=906F00000008y8HIAQ
    private void sleep(Integer milliseconds){
        // Num milliseconds since Jan 1 1970
        Long startingTime = System.now().getTime();
        while (System.now().getTime() - startingTime < milliseconds)  {
            // Do nothing until desired delay has passed
        }
    }

    // Update the Case object in the backend and redirect to view the decision submitted
    public PageReference save() {
        editCase.Decision_Submitted__c = true;
        update editCase;

        PageReference redirectURL = new PageReference('/appeals/AcademicPetitionDecisionForm?id=' + editCase.Id);
        redirectURL.setRedirect(true);

        // Sleep for one second to make sure that the Case has time to update before re-rendering the page
        sleep(1000);

        return redirectURL;
    }

    /*
        Sourced from https://glyntalkssalesforce.blogspot.com/2018/08/dependent-picklist-values-in-apex.html

        Takes in one dependent field reference as argument, finds the field that controls its dependencies,
        and returns a list of what values the dependent field can have based on the controlling field's value.
        Sadly, does not return what the controlling field is. You have to either know it or figure it out.
     */
    private static Map<Object, List<String>> getDependentPicklistValues( Schema.SObjectField dependentField ){
        Schema.DescribeFieldResult depend = dependentField.getDescribe();
        Schema.SObjectField controllingField = depend.getController();
        if ( controllingField == null ) {
            return null;
        }
        Schema.DescribeFieldResult control = controllingField.getDescribe();
        List<Schema.PicklistEntry> controlEntries =
                (   control.getType() == Schema.DisplayType.BOOLEAN
                        ?   null
                        :   control.getPicklistValues()
                );

        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<Object, List<String>> dependentPicklistValues = new Map<Object, List<String>>();
        for ( Schema.PicklistEntry entry : depend.getPicklistValues() ) {
            if ( entry.isActive() ) {
                List<String> base64chars = String.valueOf(
                        ((Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')
                ).split('');
                if (base64chars.size() < 2){
                    // If size == 1, then this value does not have a controlling field value associated with it
                    continue;
                }
                for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                    Object controlValue =
                            (   controlEntries == null
                                    ?   (Object) (index == 1)                              // Originally ".getLabel()"
                                    :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                            );
                    Integer bitIndex = index / 6;
                    Integer bitShift = 5 - Math.mod(index, 6);
                    if (controlValue == null || (base64map.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0 ){
                        continue;
                    }
                    if (!dependentPicklistValues.containsKey(controlValue)) {
                        dependentPicklistValues.put(controlValue, new List<String>());
                    }                                   // Originally ".getLabel()"
                    dependentPicklistValues.get(controlValue).add(entry.getLabel());
                }
            }
        }
        return dependentPicklistValues;
    }
}