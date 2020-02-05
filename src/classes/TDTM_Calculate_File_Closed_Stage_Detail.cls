/**
 * Created by ejc84332 on 2019-03-28.
 */

global class TDTM_Calculate_File_Closed_Stage_Detail extends TDTMVirtualTriggerHandler {

    global override void onBeforeUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        Opportunity[] process = new List<Opportunity>();
        for(SObject o : newList) {
            Opportunity opp = (Opportunity) o;
            Opportunity old_opp = (Opportunity) oldMap.get(opp.Id);
            String old_stage = old_opp.StageName;
            if (opp.StageName == 'File Closed' && old_stage != 'File Closed') {
                //process.add(opp);

                String old_status_text = old_opp.Status_Text__c;

                Boolean rejected = opp.Reject__c;

                List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
                String profileName = PROFILE[0].Name;

                if (rejected) {
                    opp.Stage_Detail__c = 'Rejected - ' + old_status_text.split(':')[1] + ' - File Closed';
                } else if (old_status_text == 'Enrolled:Enrolled' && profileName == 'System Administrator') {
                    opp.Stage_Detail__c = 'Confirmed - File Closed';
                } else {
                    opp.Stage_Detail__c = old_status_text.split(':')[1] + ' - File Closed';
                }
            }
        }
    }
}