/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_SystemExceptionLogger {
  
    @testSetup
    static void setup() {
        List<System_Exception_Logger_Configuration__c> l_configSettingsList =
            new List<System_Exception_Logger_Configuration__c>();
        l_configSettingsList.add( new System_Exception_Logger_Configuration__c(
            Name = 'System Exception Log Test 1',
            Exception_Level_Config__c = true,
            ReThrow_Exception__c = true));
        l_configSettingsList.add( new System_Exception_Logger_Configuration__c(
            Name = 'System Exception Log Test 2',
            Exception_Level_Config__c = true,
            ReThrow_Exception__c = false));
        insert l_configSettingsList;
    }

    /**
     * This test method is used to test the overridden method:
     *      insertSystemExceptionLogEntry(Exception e,
   *                      String sourceApplication,
   *                      String processName, 
   *                      String exceptionLevel,
   *                      String supportData) 
     *
     * The is expected behavior is to have a record created in the 
     * System_Exception_Log__c object.
     *
     */
    static testMethod void insertSystemExceptionLogEntrySupportDataOverrideTest() {
      String supportData = 'This string represents data supporting the cause of the exception';
        try {
          // execute to throw a null pointer exception
          String testString = null;
          testString.contains('test');
        } catch (Exception e) {
          SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'System Exception Log Test 1', 'Test Process', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, supportData);
        try {
          //validate the exception was logged to the System_Exception_Log__c object
          System_Exception_Log__c logRecord = [SELECT Support_Data__c 
                              FROM System_Exception_Log__c
                              WHERE Name = 'Test Process'];       
          System.assertEquals(supportData,logRecord.Support_Data__c);
        } catch (Exception ex ) {
          // an exception should not have occurred - set the assertion to false
          System.assert(false);
        }
        }
    }

    /**
     * This test method is used to catch a null pointer exception and log the system
     * exception using the SystemExceptionnLogger. 
     *
     * The is expected behavior is to have a record created in the 
     * System_Exception_Log__c object.
     *
     */
    static testMethod void insertSystemExceptionLogEntryOverrideNullPointerTest() {
      String testString;
        try {
          // execute to throw a null pointer exception
          testString = null;
          testString.contains('test');
        } catch (Exception e) {
          // log the exception
          String supportData = 'The test string  = ' + testString;
          SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'System Exception Log Test 1', 'Test Process', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, supportData);
          try {
            //validate the exception was logged to the System_Exception_Log__c object
            System_Exception_Log__c logRecord = [SELECT Source_Application__c 
                                FROM System_Exception_Log__c
                                WHERE Name = 'Test Process'];       
            System.assertEquals('System Exception Log Test 1',logRecord.Source_Application__c);
          } catch (Exception ex ) {
            // an exception should not have occurred - set the assertion to false
            System.assert(false);
          }
        }
    }
    
    /**
     * This test method is used to catch a null pointer exception, setthe support data 
     * and exception message string to a length > 32768 characters and log the system
     * exception using the SystemExceptionLogger. 
     *
     * The is expected behavior is to have a record created in the 
     * System_Exception_Log__c object.
     *
     */
    static testMethod void insertSystemExceptionLogEntryStringLimitTest() {
      String testString;
        try {
          // execute to throw a null pointer exception
          testString = null;
          testString.contains('test');
        } catch (Exception e) {
          // log the exception
          String supportData = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
          for(Integer i=0; i<10; i++) { 
            supportData += supportData;
          }
          e.setMessage(e.getMessage() + supportData);
          SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'System Exception Log Test 1', 'Test Process', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, supportData);
          try {
            //validate the exception was logged to the System_Exception_Log__c object
            System_Exception_Log__c logRecord = [SELECT Support_Data__c, Exception_Message__c
                                FROM System_Exception_Log__c
                                WHERE Name = 'Test Process'];       
            System.assertEquals(32768,logRecord.Support_Data__c.length());
            System.assertEquals(32768,logRecord.Exception_Message__c.length());
           } catch (Exception ex ) {
            // an exception should not have occurred - set the assertion to false
            System.assert(false);
          }
        }
    }

    /**
     * This test method is used to catch DML exception and log the system
     * exception using the SystemExceptionnLogger. 
     *
     * The is expected behavior is to have a record created in the 
     * System_Exception_Log__c object.
     *
     */
    static testMethod void insertSystemExceptionLogEntryAllDmlExceptionTest() {
       try {
          // execute to throw a DML exception
           Account account= new Account();
           insert account;
           System.assert(false);
       } catch (Exception e) {
         // log the exception
          SystemExceptionLogger.insertSystemExceptionLogEntry(e,'System Exception Log Test 1', 'Test Account Process', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, 'Account', false);
          try {
            //validate the exception was logged to the System_Exception_Log__c object
            System_Exception_Log__c logRecord = [SELECT Dml_Exception_Type__c 
                                FROM System_Exception_Log__c
                                WHERE Name = 'Test Account Process'];
            System.assert(logRecord.Dml_Exception_Type__c != null);
          } catch (Exception ex) {
            // an exception should not have occurred - set the assertion to false
            System.assert(false);
          }         
       } 
    }

    /**
     * This test method is used to catch a null pointer exception and have 
     * the log method fail and log the nested exception. This test wil set 
     * one of the System_Exception_Log__c field values to a length greater
     * that the field length defined. When an exception occurs, the insert 
     * to  the System_Exception_Log__c will fail. A nested exception will 
     * be created and logged. 
     *
     * The is expected behavior is to have a nested exception record created 
     * in the System_Exception_Log__c object.
     *
     */
    static testMethod void insertSystemExceptionLogEntryInternalExceptionTest() {
        // set the sourceApplication string length greater than the field length
        String sourceApplication = 'This is a very long source application name to cause the insertion to failed because the length exceeds forty characters';
        boolean stackTraceFound = false;
        try {
          // execute to throw a internal DML exception
          String testString = null;
          testString.contains('test');
          System.assert(false);
        } catch (Exception e) {
          // validate the exception was logged to the System_Exception_Log__c object
          // the exception logged Source application is not the same as the original
          SystemExceptionLogger.insertSystemExceptionLogEntry(e, sourceApplication, 'Test', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL);
          try {        
            List<System_Exception_Log__c> logRecords = [SELECT Exception_Stack_Trace__c,
                                       Exception_Cause__c,
                                       Source_Application__c, 
                                       Exception_Level__c
                                  FROM System_Exception_Log__c
                                  WHERE Name = 'System Exception Logger'];
            System.debug('logRecords = ' + logRecords);
            for(System_Exception_Log__c logRecord : logRecords) {
              if(logRecord.Exception_Cause__c.contains('Test_SystemExceptionLogger')) {
                 System.assertEquals('SystemExceptionLogger',logRecord.Source_Application__c);
                System.assertEquals('CRITICAL',logRecord.Exception_Level__c); 
                stackTraceFound = true;              
              }
            }
            if(!stackTraceFound) {
              System.assert(false);
            }
          } catch (Exception ex) {
            // an exception should not have occurred - set the assertion to false
            System.assert(false);
          }
        }
    }
    
  static testMethod void setComponentExceptionParametersTest() {
    try{
      String test;
      Integer length = test.length();
    } catch (Exception e) {
      SystemExceptionLogger.setComponentExceptionParameters(e,'System Exception Log Test 1', 'Test Account Process', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, 'Account', null);
      System.assertEquals('Test Account Process', SystemExceptionLogger.component_process_name);
      SystemExceptionLogger.setComponentExceptionParameters(e,'System Exception Log Test 2', 'Test Account Process 2', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, 'Support Data');
      System.assertEquals('Test Account Process 2', SystemExceptionLogger.component_process_name);
      System.assertEquals('Support Data', SystemExceptionLogger.component_support_data);
       SystemExceptionLogger.setComponentExceptionParameters(e,'Test_SystemExceptionLogger', 'Test Account Process 3', SystemExceptionLogger.EXCEPTION_LEVEL_WARNING);
      System.assertEquals('Test Account Process 3', SystemExceptionLogger.component_process_name);
      System.assertEquals(SystemExceptionLogger.EXCEPTION_LEVEL_WARNING, SystemExceptionLogger.component_exception_level);
      Boolean isLogEntrySet = SystemExceptionLogger.log_entry;
      SystemExceptionLogger.log_entry = true;
          try {
            //validate the exception was logged to the System_Exception_Log__c object
            System_Exception_Log__c logRecord = [SELECT Source_Application__c 
                                FROM System_Exception_Log__c
                                WHERE Name = 'Test Account Process 3'];       
            System.assertEquals('Test_SystemExceptionLogger',logRecord.Source_Application__c);
          } catch (Exception ex ) {
            // an exception should not have occurred - set the assertion to false
            System.assert(false);
          }
    }
  }
    
    static testMethod void isRethrowExceptionEnabledTest() {
      System.assertEquals(true,SystemExceptionLogger.isRethrowExceptionEnabled('System Exception Log Test 1'));
      System.assertEquals(false,SystemExceptionLogger.isRethrowExceptionEnabled('System Exception Log Test 2'));
      System.assertEquals(false,SystemExceptionLogger.isRethrowExceptionEnabled('Test 3'));
    }

    static testMethod void storeSupportDataAsAttachmentTest() {
      String testString;
        try {
          // execute to throw a null pointer exception
          testString = null;
          testString.contains('test');
        } catch (Exception e) {
          // log the exception
          String supportData = 'The test string  = ' + testString;
          SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'System Exception Log Test 1', 'Test Process', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, supportData, true);
          try {
            //validate the exception was logged to the System_Exception_Log__c object
            Attachment attachRecord = [SELECT Id FROM Attachment];       
            System.assert(true);
          } catch (Exception ex ) {
            // an exception should not have occurred - set the assertion to false
            System.assert(false);
          }
        }
    }

    static testMethod void logObjectReferenceTest() {
      String testString;
        try {
          // execute to throw a null pointer exception
          testString = null;
          testString.contains('test');
        } catch (Exception e) {
          // log the exception
          String supportData = 'The test string  = ' + testString;
           try {
            SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'System Exception Log Test 1', null, SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, 'object', 'reference');
            System.assert(true);
          } catch (Exception ex ) {
            // an exception should not have occurred - set the assertion to false
            System.assert(false);
          }
        }
    }
 }