/**
 * Created by Luke Vang (Contractor) on 2019-04-18.
 */
@isTest
public class Test_TDTMVirtualTriggerHandler {
	
    /*
     * 
     * This test is used to test methods from the TDTMVirtualTriggerHandler
     * that are not used in the current processes
     * 
     */
    static testMethod void testUnsedTriggerContexts(){
        TDTMVirtualTriggerHandler handler = new TDTMVirtualTriggerHandler();
        handler.onBeforeDelete(null, null, null);
        handler.onBeforeInsert(null, null, null);
        handler.onBeforeUpdate(null, null, null, null, null);
        handler.onAfterDelete(null, null, null);
        handler.onAfterInsert(null, null, null);
        handler.onAfterUndelete(null, null, null);
        handler.onAfterUpdate(null, null, null, null, null);
    }
    
}