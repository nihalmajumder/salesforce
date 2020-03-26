global class SendEmailToCaseOwnerAction {
    @InvocableMethod(label='Send Email To Case Owner')
    global static void sendEmail(List<SendEmailActionRequest> requests) {
        try {
            Set<String> emailTemplateNames = new Set<String>();
            Set<Id> recordIds = new Set<Id>();

            for (SendEmailActionRequest request : requests) {
                emailTemplateNames.add(request.templateName);
                recordIds.add(request.recordId);
            }

            Map<String, EmailTemplate> templateMap = new Map<String, EmailTemplate>();
            for (EmailTemplate t : [SELECT Id, DeveloperName, Body, Subject FROM EmailTemplate WHERE DeveloperName IN :emailTemplateNames]) {
                templateMap.put(t.DeveloperName, t);
            }

            Map<Id, Case> caseMap = new Map<Id, Case>();
            for (Case c : [SELECT Id, OwnerId, Owner.Email, ContactId FROM Case WHERE Id IN :recordIds]) {
                caseMap.put(c.Id, c);
            }

            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
            for (SendEmailActionRequest request : requests) {
                Case c = caseMap.get(request.recordId);
                EmailTemplate template = templateMap.get(request.templateName);
                if (c != null && template != null) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(template.Id);
                    mail.setSaveAsActivity(false);
                    mail.setTargetObjectId(c.ContactId);
                    mail.setTreatTargetObjectAsRecipient(false);
                    mail.setToAddresses(new List<String>{c.Owner.Email});
                    mail.setWhatId(c.Id); 
                    messages.add(mail);
                }
            }
            if (!messages.isEmpty()) {
                List<Messaging.SendEmailResult> resultMail = Messaging.sendEmail(messages);
            }
        }
        catch (Exception e) {
            System.debug(e);
        }
    }

    global class SendEmailActionRequest {
        @InvocableVariable(required=true)
        global Id recordId;

        @InvocableVariable(required=true)
        global String templateName;
    }

}