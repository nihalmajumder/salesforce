/**
 * Created by ejc84332 on 2019-05-04.
 */


global class TDTM_Opportunity_Stage_Back extends TDTMVirtualTriggerHandler {

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        Id[] app_ids = new List<Id>();
        Application__c[] update_apps = new List<Application__c>();

        for (SObject s : newList) {
            Opportunity new_opp = (Opportunity) s;
            app_ids.add(new_opp.Application__c);
        }

        Map<ID, Application__c> related_apps = new Map<ID, Application__c>([Select Id, Application_Status__c from Application__c where Id in :app_ids]);


        // find Opportunites that moved Stages from File Closed to Applied
        for (SObject s : newList) {
            Opportunity new_opp = (Opportunity) s;
            Opportunity old_opp = (Opportunity) oldMap.get(new_opp.Id);
            Application__c app = related_apps.get(new_opp.Application__c);

            // if this opportunity doens't have a related app, we don't need to match the status
            if(app == null){
                continue;
            }

            // Get applications related to Opportunities whose stage changed.
            if (new_opp.StageName != old_opp.StageName || new_opp.Stage_Detail__c != old_opp.Stage_Detail__c) {

                switch on new_opp.Status_Text__c {
                    when 'Prospect:Prospect', 'Inquired:Inquired', 'Inquired:Pre-Applied', 'Inquired:App Started' {
                        if (app.Application_Status__c != 'Started') {
                            app.Application_Status__c = 'Started';
                            update_apps.add(app);
                        }
                    }
                    when 'Applied:App Submitted' {
                        if (app.Application_Status__c != 'Submitted') {
                            app.Application_Status__c = 'Submitted';
                            update_apps.add(app);
                        }
                    }
                    when 'Applied:App Completed', 'Accepted:Accepted', 'Confirmed:Fee Paid', 'Confirmed:Fee Waived', 'Confirmed:Registered', 'Enrolled:Enrolled' {
                        if (app.Application_Status__c != 'Completed') {
                            app.Application_Status__c = 'Completed';
                            update_apps.add(app);
                        }
                    }
                    when else {
                        if (new_opp.StageName == 'File Closed' && app.Application_Status__c != 'Cancelled') {
                            app.Application_Status__c = 'Cancelled';
                            update_apps.add(app);
                        }
                    }
                }
            }
        } // end for loop

        if (update_apps.size() > 0) {
            update update_apps;
        }

    }
}