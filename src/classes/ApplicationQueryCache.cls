/*
 * 
 * 
 * test - ApplicationQueryCacheTest
 * 
 */ 
public with sharing class ApplicationQueryCache {

    public static Map<Id, User> userCache = new Map<Id, User>();

	public static User getUser(Id userId) {
        User u = userCache.get(userId);
        if (u == null) {
            u = [SELECT Id, ContactId FROM User WHERE Id = :userId];
            userCache.put(userId, u);
        }
        return u;
	}

    public static Id getContactId(Id userId) {
        Id theContactId = null;
        User u = getUser(userId);
        if (u != null) {
            theContactId = u.ContactId;
        }
        return theContactId;
    }
}