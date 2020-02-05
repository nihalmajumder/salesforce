global class TDTMCaseTriggerHandler extends TDTMVirtualTriggerHandler {

    global override void onAfterUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {
        List<Task> tasks = new List<Task>();
        Id readmissionRecordId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SSR_Readmission').getRecordTypeId();
        for (SObject s : newList){
            Case c = (Case)s;
            if (c.RecordTypeId == readmissionRecordId) {
                if (c.Status == 'Reactivate and Register') {
                    Case oldCase = (Case) oldMap.get(c.Id);
                    if (oldCase.Status != 'Reactivate and Register') {
                        tasks.addAll(createReadmissionTasks(c));
                    }
                }
            }
        }

        if (!tasks.isEmpty()) {
            insert tasks;
        }
    }

    private Task createTask(Case c, String subject, String description){
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

    private List<Task> createReadmissionTasks(Case c) {
        List<Task> tasks = new List<Task>();
        tasks.add(createTask(c, 'Rebuild file', 'Rebuild the student file if the original file was purged from the record archive.'));
        tasks.add(createTask(c, 'Updates to name and address', 'Updates to name or address should be sent to registrar-data@bethel.edu.'));
        tasks.add(createTask(c, 'Reactivation and registration', 'SSA: Complete the following information...\nTerm\nProgram\nCatalog Year\nCohort\nSubstitutions and waivers\nIs the file being recreated (Y/N)\nFirst term registration requests'));
        tasks.add(createTask(c, 'Student Experience - Re-enrollment', 'SSA: Complete the following information...\nStarting term\nAcademic progress\nAcademic progress'));
        return tasks;

    }

}