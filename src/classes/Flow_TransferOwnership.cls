/**
 * Created by bej68982 on 2/24/20.
 */

global class Flow_TransferOwnership {

    //Invocable Variables
    public class TransferOwnershipRequest {
        @InvocableVariable(Label='Request Type' Required=true)
        public String requestType;

        @InvocableVariable(Label='Objects' Required=true)
        public String objectsTypes;

        @InvocableVariable(Label='Old Owner' Required=false)
        public String oldOwnerId;

        @InvocableVariable(Label='New Owner' Required=true)
        public String newOwnerId;

        @InvocableVariable(Label='Program Code(s)' Required=false)
        public String programCodes;
    }

    @InvocableMethod(Label='Transfer Record Ownership')
    public static  List<String> TransferOwnership(List<TransferOwnershipRequest> requests) {
        List<String> results = new List<String>();

        for (TransferOwnershipRequest request : requests) {
            //Declare Variables.
            List<Opportunity> opportunities = new List<Opportunity>();
            List<Case> cases = new List<Case>();
            List<Task> tasks = new List<Task>();
            List<String> programCodeList = new List<String>();

            //Remove whitespace and split program codes into a list.
            if(request.programCodes != null) {
                request.programCodes= request.programCodes.replaceAll('\\s+', '');
                request.programCodes= request.programCodes.replaceAll('\N', '');
                request.programCodes= request.programCodes.replace('\\n', '');
                request.programCodes= request.programCodes.deleteWhitespace();
                programCodeList = request.programCodes.split(',');
            }

            //Get records to transfer ownership of.
            if(request.objectsTypes.containsIgnoreCase('opportunities')){
                opportunities = getOpps(request.oldOwnerId, request.newOwnerId, programCodeList);
            }
            if(request.objectsTypes.containsIgnoreCase('cases')){
                cases = getCases(request.oldOwnerId, request.newOwnerId, programCodeList);
            }
            if(request.objectsTypes.containsIgnoreCase('tasks')){
                tasks = getTasks(request.oldOwnerId, request.newOwnerId, programCodeList);
            }

            //If request type equals "total", only return the sums. If it equals "transfer", actually update the records.
            switch on request.requestType {
                when 'total' {
                    try{
                        Integer totalRecords = opportunities.size() + cases.size() + tasks.size();
                        if(totalRecords != 0){
                            results.add('You are about to transfer ' + totalRecords + ' records. Click NEXT to continue.\N\NOpportunities: ' + opportunities.size() + '\NCases: ' + cases.size() + '\NTasks: ' + tasks.size());
                        }else {
                            results.add('No records found');
                        }
                    } catch(Exception e) {
                        results.add('FLOW ERROR: '+e);
                    }
                }
                when 'transfer' {
                    try{
                        String result = '';
                        if(opportunities.size() > 0){
                            BatchTransferOpportunities myBatchObject = new BatchTransferOpportunities(opportunities,request.newOwnerId);
                            Id batchId = Database.executeBatch(myBatchObject,500);
                            result += '\NBatchTransferOpportunities Job ID: '+String.valueOf(batchId);
                        }
                        if(cases.size() > 0){
                            BatchTransferCases myBatchObject = new BatchTransferCases(cases,request.newOwnerId);
                            Id batchId = Database.executeBatch(myBatchObject,500);
                            result += '\NBatchTransferCases Job ID: '+String.valueOf(batchId);
                        }
                        if(tasks.size() > 0){
                            BatchTransferTasks myBatchObject = new BatchTransferTasks(tasks,request.newOwnerId);
                            Id batchId = Database.executeBatch(myBatchObject,500);
                            result += '\NBatchTransferCases Job ID: '+String.valueOf(batchId);
                        }
                        if(result == ''){
                            result = 'No records found';
                        } else {
                            result = 'You will receive a confirmation email once the transfer jobs have been completed.\N' + result + '\N\NView Apex Jobs Here: '+ URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/setup/AsyncApexJobs/home';
                        }
                        results.add(result);
                    } catch(Exception e) {
                        results.add('FLOW ERROR: '+e);
                    }
                }
                when else {
                    results.add('FLOW ERROR: Please enter a valid Request Type');
                }
            }
        }
        return results;
    }


    public static List<Opportunity> getOpps(String oldOwnerId, String newOwnerId, List<String> programCodes) {
        List<Opportunity> opportunities = new List<Opportunity>();
        if(programCodes.size() > 0  && oldOwnerId == null){
            opportunities = [
                    SELECT
                            Name,Id,OwnerId
                    FROM
                            Opportunity
                    WHERE
                            Academic_Program_Code__c IN :programCodes AND StageName != 'Enrolled' AND StageName != 'File Closed' AND StageName != 'Prospect' AND OwnerId != :newOwnerId
                    LIMIT 10000
            ];
        }else if(programCodes.size() == 0 && oldOwnerId != null){
            opportunities = [
                    SELECT
                            Name,Id,OwnerId
                    FROM
                            Opportunity
                    WHERE
                            OwnerId = :oldOwnerId AND StageName != 'Enrolled' AND StageName != 'File Closed' AND StageName != 'Prospect'
                    LIMIT 10000
            ];
        } else if(programCodes.size() > 0 && oldOwnerId != null){
            opportunities = [
                    SELECT
                            Name,Id,OwnerId
                    FROM
                            Opportunity
                    WHERE
                            OwnerId = :oldOwnerId AND Academic_Program_Code__c IN :programCodes AND StageName != 'Enrolled' AND StageName != 'File Closed' AND StageName != 'Prospect'
                    LIMIT 10000
            ];
        }
        return opportunities;
    }

    public static List<Case> getCases(String oldOwnerId, String newOwnerId, List<String> programCodes) {
        List<Case> cases = new List<Case>();
        if(programCodes.size() > 0  && oldOwnerId == null){
            cases = [
                    SELECT
                            Id,OwnerId
                    FROM
                            Case
                    WHERE
                            Academic_Program_Code__c IN :programCodes AND Status != 'Closed' AND (Owner.UserRole.Name LIKE '%Post-Trad%' OR Owner.UserRole.Name LIKE '%CAS%') AND OwnerId != :newOwnerId
                    LIMIT 10000
            ];
        }else if(programCodes.size() == 0 && oldOwnerId != null){
            cases = [
                    SELECT
                            Id,OwnerId
                    FROM
                            Case
                    WHERE
                            OwnerId = :oldOwnerId AND Status != 'Closed' AND (Owner.UserRole.Name LIKE '%Post-Trad%' OR Owner.UserRole.Name LIKE '%CAS%')
                    LIMIT 10000
            ];
        } else if(programCodes.size() > 0 && oldOwnerId != null){
            cases = [
                    SELECT
                            Id,OwnerId
                    FROM
                            Case
                    WHERE
                            OwnerId = :oldOwnerId AND Academic_Program_Code__c IN :programCodes AND Status != 'Closed' AND (Owner.UserRole.Name LIKE '%Post-Trad%' OR Owner.UserRole.Name LIKE '%CAS%')
                    LIMIT 10000
            ];
        }
        return cases;
    }

    public static List<Task> getTasks(String oldOwnerId, String newOwnerId, List<String> programCodes) {
        List<Task> tasks = new List<Task>();
        if(programCodes.size() > 0  && oldOwnerId == null){
            //Get open Tasks on open Opportunities for specified program codes
            tasks.addAll([
                    SELECT
                            Id,OwnerId
                    FROM
                            Task
                    WHERE
                            WhatId IN (
                                    SELECT
                                            Id
                                    FROM
                                            Case
                                    WHERE
                                            Academic_Program_Code__c IN :programCodes AND Status != 'Closed' AND (Owner.UserRole.Name LIKE '%Post-Trad%' OR Owner.UserRole.Name LIKE '%CAS%')
                            )
                    AND
                            OwnerId IN (
                                    SELECT
                                            Id
                                    FROM
                                            User
                                    WHERE
                                            UserRole.Name LIKE '%Post-Trad%' OR UserRole.Name LIKE '%CAS%'
                            )
                    AND
                            Status != 'Completed'  AND OwnerId != :newOwnerId
                    LIMIT 10000
            ]);
            //Get open Tasks on open Cases for specified program codes
            tasks.addAll([
                    SELECT
                            Id,OwnerId
                    FROM
                            Task
                    WHERE
                            WhatId IN ( SELECT
                                                Id
                                        FROM
                                                Opportunity
                                        WHERE
                                                Academic_Program_Code__c IN :programCodes AND StageName != 'Enrolled' AND StageName != 'File Closed' AND StageName != 'Prospect'
                            )
                    AND
                            OwnerId IN (
                                    SELECT
                                            Id
                                    FROM
                                            User
                                    WHERE
                                            UserRole.Name LIKE '%Post-Trad%' OR UserRole.Name LIKE '%CAS%'
                            )
                    AND
                            Status != 'Completed'  AND OwnerId != :newOwnerId
                    LIMIT 10000
            ]);
        }else if(programCodes.size() == 0 && oldOwnerId != null){
            //Get open Tasks assigned to specified user
            tasks.addAll([
                    SELECT
                            Id,OwnerId
                    FROM
                            Task
                    WHERE
                            OwnerId = :oldOwnerId AND Status != 'Completed'
                    LIMIT 10000
            ]);
        } else if(programCodes.size() > 0 && oldOwnerId != null){
            //Get open Tasks assigned to specified user on open Opportunities for specified program codes
            tasks.addAll([
                    SELECT
                            Id,OwnerId
                    FROM
                            Task
                    WHERE
                            WhatId IN (
                                    SELECT
                                            Id
                                    FROM
                                            Case
                                    WHERE
                                            Academic_Program_Code__c IN :programCodes AND Status != 'Closed' AND (Owner.UserRole.Name LIKE '%Post-Trad%' OR Owner.UserRole.Name LIKE '%CAS%')
                            )
                    AND
                            OwnerId IN (
                                    SELECT
                                            Id
                                    FROM
                                            User
                                    WHERE
                                            UserRole.Name LIKE '%Post-Trad%' OR UserRole.Name LIKE '%CAS%'
                            )
                    AND
                            Status != 'Completed'
                    AND
                            OwnerId = :oldOwnerId
                    LIMIT 10000
            ]);
            //Get open Tasks assigned to specified user on open Cases for specified program codes
            tasks.addAll([
                    SELECT
                            Id,OwnerId
                    FROM
                            Task
                    WHERE
                            WhatId IN ( SELECT
                                                Id
                                        FROM
                                                Opportunity
                                        WHERE
                                                Academic_Program_Code__c IN :programCodes AND StageName != 'Enrolled' AND StageName != 'File Closed' AND StageName != 'Prospect'
                            )
                    AND
                            OwnerId IN (
                                    SELECT
                                            Id
                                    FROM
                                            User
                                    WHERE
                                            UserRole.Name LIKE '%Post-Trad%' OR UserRole.Name LIKE '%CAS%'
                            )
                    AND
                            Status != 'Completed'
                    AND
                            OwnerId = :oldOwnerId
                    LIMIT 10000
            ]);
        }
        return tasks;
    }

    public static String sendEmail(String content, String subject, String body, String filename){
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        Blob csvBlob = Blob.valueOf(content);
        csvAttc.setFileName(filename);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new List<String> {UserInfo.getUserEmail()};
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody(body);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        return 'Success';
    }
}

