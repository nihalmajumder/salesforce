/*
*
* @Author Luke Vang (Contractor)
* @Created 4/15/2019
* 
* Description: Test class for AcademicPetitionDecisionForm class
*
*/
@isTest
public class AcademicPetitionDecisionFormTest {

    static Id academicPetitionRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SSR_Academic_Petition').getRecordTypeId();

    static testMethod void testController(){
        //create the case

        Contact c = new Contact(FirstName='First', LastName='Last', Email='test@test.com');

        insert c;

        Case academicPetitionCase = new Case(RecordTypeId = academicPetitionRecTypeId, Status = 'New', Origin = 'Web', ContactId=c.Id);
        insert academicPetitionCase;
        //create the controller to pass into apex class
        ApexPages.currentPage().getParameters().put('id', academicPetitionCase.Id);
        AcademicPetitionDecisionForm controller = new AcademicPetitionDecisionForm();

        AcademicPetitionDecisionForm academicPetitionDecisionForm = new AcademicPetitionDecisionForm();

        // not sure if this is the right thing to do, but call all the functions.
        academicPetitionDecisionForm.getroleOptions();
        academicPetitionDecisionForm.getdecisionOptions();
        academicPetitionDecisionForm.getgradeChangeFactorsOptions();
        academicPetitionDecisionForm.getapprovalDescriptionDependentPicklistOptions();
        academicPetitionDecisionForm.getdenialDescriptionDependentPicklistOptions();

        String str;

        str = academicPetitionDecisionForm.petitionType;
        str = academicPetitionDecisionForm.caseNumber;
        str = academicPetitionDecisionForm.studentInfo;
        str = academicPetitionDecisionForm.createdDate;
        str = academicPetitionDecisionForm.program;
        str = academicPetitionDecisionForm.courseNumber;
        str = academicPetitionDecisionForm.instructor;
        str = academicPetitionDecisionForm.term;
        str = academicPetitionDecisionForm.appealingTheFollowing;
        str = academicPetitionDecisionForm.requestingTheFollowing;
        str = academicPetitionDecisionForm.detailsCircumstances;
        str = academicPetitionDecisionForm.academicHistory;
        str = academicPetitionDecisionForm.priorAcademicProbation;
        str = academicPetitionDecisionForm.howManyTermsProbation;
        str = academicPetitionDecisionForm.priorAcademicDismissal;
        str = academicPetitionDecisionForm.inputsPerspective;
        str = academicPetitionDecisionForm.registrarSummary;
        str = academicPetitionDecisionForm.supportingDocumentation;
        str = academicPetitionDecisionForm.supportingDocumentation2;
        str = academicPetitionDecisionForm.supportingDocumentation3;
        str = academicPetitionDecisionForm.supportingDocumentation4;
        str = academicPetitionDecisionForm.supportingDocumentation5;
        str = academicPetitionDecisionForm.decisionMakerName;
        str = academicPetitionDecisionForm.role;
        str = academicPetitionDecisionForm.decision;
        str = academicPetitionDecisionForm.approvalDescription;
        str = academicPetitionDecisionForm.graceGrantAmount;
        str = academicPetitionDecisionForm.approvalOldGrade;
        str = academicPetitionDecisionForm.approvalNewGrade;
        List<String> lst = academicPetitionDecisionForm.gradeChangeFactors;
        str = academicPetitionDecisionForm.approvalAcademicYear;
        Date dt = academicPetitionDecisionForm.approvalExtensionDate;
        str = academicPetitionDecisionForm.approvalCourseSubstitution;
        str = academicPetitionDecisionForm.denialDescription;
        str = academicPetitionDecisionForm.comments;



        PageReference ref = academicPetitionDecisionForm.save();

        //after save the page should be redirected to a new landing page.
        System.debug(ref.getUrl());
        System.assert(ref.getUrl().contains('/appeals/AcademicPetitionDecisionForm?id=' + academicPetitionCase.Id));
    }

}