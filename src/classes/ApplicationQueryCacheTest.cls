@isTest
public with sharing class ApplicationQueryCacheTest {
    
    @testSetup
    static void testSetup(){
        
        Account account = new Account(name ='ApplicationQueryTest') ;
        insert account; 
        
        Contact contact = new Contact(LastName ='testAppQuery', AccountId = account.Id);
        insert contact;
            
            User user = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Applicant Community Login User'].Id,
                LastName = 'querytest',
                Email = 'appquerytest@example.com',
                Username = 'appquerytest@example.com',
                CompanyName = 'none',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                IsActive = true,
                LocaleSidKey = 'en_US',
                ContactId = contact.Id
            );
        
        System.runAs(new User(Id = UserInfo.getUserId())){
            insert user;
        }
        
    }
    
    static testMethod void testGetUser(){
        Id userId = [SELECT id FROM User WHERE Username =: 'appquerytest@example.com'].Id;
        User result = ApplicationQueryCache.getUser(userId);
        System.assertEquals(userId, result.Id);
    }
    
    static testMethod void testGetContact(){
        Id userId = [SELECT id FROM User WHERE Username =: 'appquerytest@example.com'].Id;
        Id contactId = [SELECT id FROM Contact].Id;
        Id result = ApplicationQueryCache.getContactId(userId);
        System.assertEquals(contactId, result);
    }
    
    
}