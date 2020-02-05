/**
 * Created by bej68982 on 1/30/20.
 */

global class Flow_BulkSMS {

    //Invocable Variables
    public class BulkSmsRequest {
        @InvocableVariable(Label='Request Type' Required=true)
        public String requestType;

        @InvocableVariable(Label='Report ID' Required=false)
        public String reportId;

        @InvocableVariable(Label='Campaign ID' Required=false)
        public String campaignId;

        @InvocableVariable(Label='SMS Message' Required=false)
        public String smsMessage;

        @InvocableVariable(Label='Gateway' Required=false)
        public String gateway;

        @InvocableVariable(Label='Term(s)' Required=false)
        public String requestedTerms;

        @InvocableVariable(Label='Stage Detail(s)' Required=false)
        public String stageDetails;

        @InvocableVariable(Label='Initiator' Required=false)
        public String initiator;
    }

    @InvocableMethod(Label='Bulk SMS Request' Description='Sends a SMS for each contact that matches the passed criteria')
    public static  List<String> BulkSMS(List<BulkSmsRequest> requests) {
        List<String> results = new List<String>();
        List<String> termList = new List<String>();
        List<String> stageDetailList = new List<String>();
        List<Contact> contacts = new List<Contact>();

        for(BulkSmsRequest request : requests) {
            switch on request.requestType {
                when 'report' {
                    Event_Log__c log1 = new Event_Log__c(Message__c=request.smsMessage, OwnerId=request.initiator, Gateway__c =request.gateway, Type__c='Report');
                    insert log1;
                    contacts = getContactsFromReport(request.reportId);
                    results.add(CreateSmsRecords(contacts, request.gateway, request.smsMessage, log1));
                }
                when 'funnel' {
                    termList = request.requestedTerms.split(';');
                    stageDetailList = request.stageDetails.split(';');
                    Event_Log__c log2 = new Event_Log__c(Message__c=request.smsMessage, OwnerId=request.initiator, Gateway__c =request.gateway, Type__c='Funnel');
                    insert log2;
                    contacts = getContactsFromFunnel(termList, stageDetailList, request.initiator);
                    results.add(CreateSmsRecords(contacts, request.gateway, request.smsMessage, log2));
                }
                when 'campaign' {
                    Event_Log__c log3 = new Event_Log__c(Message__c=request.smsMessage, OwnerId=request.initiator, Gateway__c =request.gateway, Campaign__c=request.campaignId, Type__c='Campaign');
                    insert log3;
                    contacts = getContactsFromCampaign(request.campaignId);
                    results.add(CreateSmsRecords(contacts, request.gateway, request.smsMessage, log3));
                }
                when 'report total' {
                    results.add(getListOfContacts('report', request.reportId, null, null, null, null));
                }
                when 'funnel total' {
                    stageDetailList = request.stageDetails.split(';');
                    termList = request.requestedTerms.split(';');
                    results.add(getListOfContacts('funnel', null, null, termList, stageDetailList, request.initiator));
                }
                when 'campaign total' {
                    results.add(getListOfContacts('campaign', null, request.campaignId, null, null, null));
                }
                when else {
                    results.add('Please enter a valid Request Type');
                }
            }
        }
        return results;
    }

    public static String CreateSmsRecords(List<Contact> contacts, Id gatewayId, String message, Event_Log__c log) {
        Try{
            List<Mogli_SMS__SMS__c> new_records = new List<Mogli_SMS__SMS__c>();

            //Loop through contacts and create SMS record for each
            for(Contact currentContact : contacts) {
                Mogli_SMS__SMS__c newSmsRecord = new Mogli_SMS__SMS__c(Mogli_SMS__Message__c=message, Mogli_SMS__Phone_Number__c=currentContact.Mogli_SMS__Mogli_Number__c, Mogli_SMS__Gateway__c=gatewayId, Event_Log__c=log.Id, Mogli_SMS__Status__c='Sent Successfully');
                new_records.add(newSmsRecord);
            }

            //Remove Duplicates
            Set<Mogli_SMS__SMS__c> tempSet = new Set<Mogli_SMS__SMS__c>();
            tempSet.addAll(new_records);
            List<Mogli_SMS__SMS__c> dedupedSMS = new List<Mogli_SMS__SMS__c>();
            dedupedSMS.addAll(tempSet);

            //Insert SMS Records
            insert dedupedSMS;

            //Return confirmation message
            return 'Successfully sent '+dedupedSMS.size()+' text messages';
        } catch(Exception e) {
            return 'Error: '+e;
        }
    }

    public static  List<Contact> getContactsFromReport(Id reportId) {
        List<Contact> contacts = new List<Contact>();

        // Get the Report Description
        Reports.ReportDescribeResult reportDescription = Reports.ReportManager.describeReport(reportId);
        // Get the Report Metadata
        Reports.ReportMetadata reportMetadata = reportDescription.getReportMetadata();
        //Get the Report Type
        Reports.ReportType rt = reportMetadata.getReportType();
        //Verify the report returns Contacts
        if(!rt.getType().startsWithIgnoreCase('contacts')) {
            return contacts;
        }

        // Run a report synchronously;
        Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
        results.getAllData();

        // Get the fact map from the report results
        Reports.ReportFactWithDetails factDetails =
                (Reports.ReportFactWithDetails)results.getFactMap().get('T!T');

        //create a list of report rows and populate it with the result rows from fact map
        List<Reports.ReportDetailRow> reportRows = factDetails.getRows();

        //loop through each report detail row and store contact id
        List<Id> contactIds = new List<Id>();
        for(Reports.ReportDetailRow reportRow : reportRows) {
            List<Reports.ReportDataCell> datacells = reportRow.getDataCells();
            Reports.ReportDataCell datacell = datacells[0];
            contactIds.add((id)datacell.getValue());
        }
        contacts = [
                SELECT
                        Name,Id,Mogli_SMS__Mogli_Number__c
                FROM
                        Contact
                WHERE
                        Id IN :contactIds AND Mogli_SMS__Mogli_Number__c != null
        ];

        //Remove Duplicates from Contacts
        Set<Contact> tempSet = new Set<Contact>();
        tempSet.addAll(contacts);
        List<Contact> dedupedContacts = new List<Contact>();
        dedupedContacts.addAll(tempSet);
        return dedupedContacts;
    }

    public static  List<Contact> getContactsFromFunnel(List<String> termList, List<String> stageDetailList, Id initiatorId) {
        List<Opportunity> matchingOpps = new List<Opportunity>();
        List<Id> contact_ids = new List<Id>();
        //Find Opportunities that match the criteria given by the user
        matchingOpps = [
            SELECT
                    Contact__c
            FROM
                    Opportunity
            WHERE
                    Stage_Detail__c IN :stageDetailList AND Academic_Term__r.Name IN :termList AND OwnerId = :initiatorId
        ];
        //Get Contact IDs from each Opportunity
        for(Opportunity o : matchingOpps){
            contact_ids.add(o.Contact__c);
        }
        //Return all matching Contacts
        return [
            SELECT
                    Id, Name, Mogli_SMS__Mogli_Number__c
            FROM
                    Contact
            WHERE
                    Id IN :contact_ids AND Mogli_SMS__Mogli_Number__c != null
        ];
    }

    public static  List<Contact> getContactsFromCampaign(Id campaignId) {
        List<Contact> contacts = [
            SELECT
                    Id, Name, Mogli_SMS__Mogli_Number__c
            FROM
                    Contact
            WHERE
                    Id IN (
                            SELECT
                                    ContactId
                            FROM
                                    CampaignMember
                            WHERE
                            CampaignId = :campaignId AND ContactId != null
                    ) AND Mogli_SMS__Mogli_Number__c != null
        ];
        return contacts;
    }

    public static  String getListOfContacts(String type, Id reportId, ID campaignId, List<String> termList, List<String> stageDetailList, Id initiatorId) {
        String listOfContacts = '';
        List<Contact> returnedContacts = new List<Contact>();
        switch on type {
            when 'campaign'{
                returnedContacts = getContactsFromCampaign(campaignId);
            }
            when 'funnel'{
                returnedContacts = getContactsFromFunnel(termList, stageDetailList, initiatorId);
            }
            when 'report'{
                returnedContacts = getContactsFromReport(reportId);
            }
        }
        if(returnedContacts.size() > 0){
            for(Contact c : returnedContacts){
                listOfContacts = listOfContacts + '\N' + c.Name + ';';
            }
        }else{
            listOfContacts = 'No Contacts Found';
        }
        return listOfContacts;
    }
}