/**
 * Created by ejc84332 on 2019-02-19.
 */

global class TDTM_Create_Case_Tasks {

    global override void onAfterInsert(List<SObject> newList, Map<Id, SObject> newMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        // if a new case is assigned directly to a User, not a Queue, create the Tasks.
        Case[] create_case_tasks = new List<Case>();

        for(SObject s : newList){
            Case c = (Case)s;

            if (c.type == 'Retention' || c.type == 'Schedule - Admissions'){
                // these get assigned to a User for a second, and then a workflow assings to a Queue.
                // because of this we don't want to assign the Tasks to a User when they are first created.
                System.debug('Skipping Case');
                System.debug(c.type);
                continue;
            }

            // IDs start with 005 if they are a User
            System.debug('CASE OWNER');
            System.debug(c.Owner);
            System.debug(c.OwnerId);
            Database.DMLOptions opts = c.getOptions();
            System.debug(opts);
            System.debug(opts.assignmentRuleHeader);
            if(opts.assignmentRuleHeader.useDefaultRule == null && String.valueOf(c.OwnerId).startsWith('005')){
                create_case_tasks.add(c);
            }
        }
        insert create_tasks(create_case_tasks);
    }

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        Map<Id, String> ssr_queues = new Map<Id, String>();

        for(Group g : [SELECT Id, Name FROM Group WHERE Name LIKE '%SSR%' AND Type = 'Queue']){
            ssr_queues.put(g.Id, g.Name);
        }

        Map<Id, String> its_queues = new Map<Id, String>();

        for(Group g : [SELECT Id, Name FROM Group WHERE Name LIKE '%ITS%' AND Type = 'Queue']){
            its_queues.put(g.Id, g.Name);
        }

        Case[] moved_cases = new List<Case>();

        for(SObject s : newList){

            Case new_case = (Case)s;
            Case old_case = (Case)oldMap.get(new_case.Id);

            //the new owner a User (User Ids start with 005)
            Boolean case_id_is_user = String.valueOf(new_case.OwnerId).startsWith('005');
            Boolean case_was_ssr_queue = ssr_queues.get(old_case.OwnerId) != null;
            Boolean case_was_its_queue = its_queues.get(old_case.OwnerId) != null;

            System.debug('MOVED CASES');
            System.debug(new_case);
            System.debug(old_case);
            System.debug(case_id_is_user);
            System.debug(case_was_ssr_queue);

            if(case_id_is_user && (case_was_ssr_queue || case_was_its_queue)){
                System.debug('MOVED FROM QUEUE TO USER, CREATE TASKS: ' + new_case.Id);
                moved_cases.add(new_case);
            }
        }

        insert create_tasks(moved_cases);
    }

    private Task[] create_tasks(Case[] case_list){

        Case[] process_cases = [SELECT Id, Type, ContactId, OwnerId, Origin, SSR_Tasks_Created__c,
                CreatedDate, RecordType.Name FROM CASE WHERE Id IN :case_list];

        System.debug('CREATE TASKS FOR CASES');
        System.debug(case_list);
        Task[] ret_tasks = new List<Task>();
        // Create tasks in reverse order so the 'task 1' is at the top (sorted by newest on the Layout)
        for(Case c : process_cases){

            // set this field to true so the TDTM will filter it next time.
            c.SSR_Tasks_Created__c = true;

            System.debug('CASE RECORD TYPE');
            System.debug(c.RecordType.Name);

            if(c.RecordType.Name == 'ITS - Create/Edit Program'){
                ret_tasks.addAll(create_new_program_tasks(c));
            }
            else if(c.RecordType.Name == 'SSR - Academic Petition'){
                ret_tasks.addAll(create_petition_tasks(c));
            }else if(c.RecordType.Name == 'SSR - Commencement'){
                ret_tasks.addAll(create_commencement_tasks(c));
            }else if(c.RecordType.Name == 'SSR - Student Success Case'){

                switch on c.Type {
                    when 'Retention' {
                        ret_tasks.addAll(create_retention_tasks(c));
                    }
                    when 'Success Coaching' {
                        ret_tasks.addAll(create_success_coaching_tasks(c));
                    }

                    when 'Schedule - Admissions' {
                        ret_tasks.addAll(create_schedule_tasks(c));
                    }

                    when 'Provisional Acceptance' {
                        ret_tasks.addAll(create_provisional_tasks(c));
                    }

                    when 'Conditional Acceptance' {
                        ret_tasks.addAll(create_conditional_tasks(c));
                    }
                }
            }
        }

        update process_cases;

        return ret_tasks;
    }

    private Task[] create_retention_tasks(Case c){
        Task[] ret_tasks = new List<Task>();
        ret_tasks.add(create_task(c, 'Task 3: Within 7 days after second term ends'));
        ret_tasks.add(create_task(c, 'Task 2: Within 7 days after first term ends'));
        ret_tasks.add(create_task(c, 'Task 1: Within 14 - 28 days after the first course starts'));
        return ret_tasks;
    }

    private Task[] create_commencement_tasks(Case c){
        Task[] ret_tasks = new List<Task>();
        ret_tasks.add(create_task(c, 'Assign Case to commencement manager, or close if not approved'));
        ret_tasks.add(create_task(c, 'Collect any program-specific approvals and attach to Case'));
        ret_tasks.add(create_task(c, 'Review degree evaluation to verify completion of degree requirements', add_business_days(Date.today(), 5)));
        ret_tasks.add(create_task(c, 'Review commencement form to verify completion and accuracy', add_business_days(Date.today(), 5)));
        return ret_tasks;
    }

    private Task[] create_petition_tasks(Case c){
        Task[] ret_tasks = new List<Task>();
        ret_tasks.add(create_task(c, 'Submit Case for review and decision', add_business_days(Date.today(), 7)));
        ret_tasks.add(create_task(c, 'Confirm communication of decision, close Case', add_business_days(Date.today(), 10)));
        ret_tasks.add(create_task(c, 'Solicit and groove input to Case; complete Advisor-provided Context', add_business_days(Date.today(), 3)));
        ret_tasks.add(create_task(c, 'Confirm receipt of academic petition to student', add_business_days(Date.today(), 1)));
        ret_tasks.add(create_task(c, 'Review academic petition to verify completion and accuracy', add_business_days(Date.today(), 1)));
        return ret_tasks;
    }

    private Task[] create_schedule_tasks(Case c){
        Task[] ret_tasks = new List<Task>();
        ret_tasks.add(create_task(c, 'Schedule Ready for Distribution to Applicant', add_business_days(c.CreatedDate.date(), 1)));
        ret_tasks.add(create_task(c, 'Create Schedule', add_business_days(c.CreatedDate.date(), 1)));
        return ret_tasks;
    }

    private Task[] create_success_coaching_tasks(Case c){
        Task[] ret_tasks = new List<Task>();
        ret_tasks.add(create_task(c, '05: First Class Check-In', add_business_days(Date.today(), 7)));
        ret_tasks.add(create_task(c, '04: Registration Call & Email', add_business_days(Date.today(), 7)));
        ret_tasks.add(create_task(c, '03: Orientation Check-In', add_business_days(Date.today(), 7)));
        ret_tasks.add(create_task(c, '02: Welcome/Office Introduction', add_business_days(Date.today(), 7)));
        ret_tasks.add(create_task(c, '01: Student Resource Setup', add_business_days(Date.today(), 7)));
        return ret_tasks;
    }

    private Task[] create_provisional_tasks(Case c){
        Task[] ret_tasks = new List<Task>();
        ret_tasks.add(create_task(c, 'Review reasons for provisional admission; audit schedule to ensure success is attainable; conduct advising conversations as needed.'));
        ret_tasks.add(create_task(c, 'Send email "Provisional Task: Advising and support for provisional admission"', 'This email replaces Retention Task 1. Due 14 - 28 days after the start of class'));
        return ret_tasks;
    }

    private Task[] create_conditional_tasks(Case c){
        Task[] ret_tasks = new List<Task>();
        ret_tasks.add(create_task(c, 'Follow up on remaining items', Date.today().addDays(30)));
        return ret_tasks;
    }

    private Task[] create_new_program_tasks(Case c){
        Task[] ret_tasks = new List<Task>();
        ret_tasks.add(create_task(c, 'Update Zapier automations'));
        ret_tasks.add(create_task(c, 'Update Wufoo RFI Forms'));
        ret_tasks.add(create_task(c, 'Transfer programs for existing apps if needed'));
        ret_tasks.add(create_task(c, 'Add EASY Requirements'));
        ret_tasks.add(create_task(c, 'Assign Counselor'));
        ret_tasks.add(create_task(c, 'Create program and terms'));
        ret_tasks.add(create_task(c, 'Create academic account and program group'));
        return ret_tasks;
    }

    private Task create_task(Case c, String subject, Date due_date){
        Task t = new Task();
        t.OwnerId = c.OwnerId;
        t.Origin__c = c.Origin;
        t.Subject = subject;
        t.Status = 'Open';
        t.Priority = 'Normal';
        t.WhatId = c.Id;
        t.ActivityDate = due_date;
        t.WhoId = c.ContactId;
        return t;
    }

    private Task create_task(Case c, String subject, String description){
        Task t = new Task();
        t.OwnerId = c.OwnerId;
        t.Origin__c = c.Origin;
        t.Subject = subject;
        t.Description = description;
        t.Status = 'Open';
        t.Priority = 'Normal';
        t.WhatId = c.Id;
        t.WhoId = c.ContactId;
        return t;
    }

    private Task create_task(Case c, String subject){
        Task t = new Task();
        t.OwnerId = c.OwnerId;
        t.Origin__c = c.Origin;
        t.Subject = subject;
        t.Status = 'Open';
        t.Priority = 'Normal';
        t.WhatId = c.Id;
        t.WhoId = c.ContactId;
        return t;
    }

    public static Boolean is_weekend_day(Date dateParam){
        Boolean result     = false;
        System.debug('dateParam = '+dateParam);
        //Recover the day of the week
        Date startOfWeek   = dateParam.toStartOfWeek();
        System.debug('startOfWeek = '+startOfWeek);
        Integer dayOfWeek  = dateParam.day() - startOfWeek.day();
        System.debug('dayOfWeek = '+dayOfWeek);
        result = dayOfWeek == 0 || dayOfWeek == 6 ? true : false;
        System.debug('result = '+result);
        return result;
    }


    public static Date add_business_days(Date StartDate, Integer BusinessDaysToAdd ){
        //Add or decrease in BusinessDaysToAdd days
        Date finalDate = StartDate;
        System.debug('finaldate = '+finalDate);
        Integer direction = BusinessDaysToAdd < 0 ? -1 : 1;
        System.debug('direction = '+direction);
        while(BusinessDaysToAdd != 0)
        {
            finalDate = finalDate.addDays(direction);
            System.debug('BusinessDaysToAdd = '+BusinessDaysToAdd);
            System.debug('finaldate = '+finalDate);
            if (!is_weekend_day(finalDate))
            {
                BusinessDaysToAdd -= direction;

            }
        }

        return finalDate;
    }

}