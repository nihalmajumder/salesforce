global class SystemExceptionLogger {
  // Constants that define the Exception Level picklist values
  public static final String EXCEPTION_LEVEL_INFO = 'INFO';
  public static final String EXCEPTION_LEVEL_WARNING = 'WARNING';
  public static final String EXCEPTION_LEVEL_CRITICAL = 'CRITICAL';
  
  // constants that define the default values for exception parameters
  private static final String DEFAULT_PROCESS_NAME = 'System Exception Logger';
  private static final String DEFAULT_SOURCE_APPLICATION = 'SystemExceptionLogger';
  private static final Integer SUPPORT_DATA_MAX_FIELD_LENGTH = 32768;
  private static final String DEFAULT_CONFIGURATION = 'Default';
  private static final String SUPPORT_DATA_STORED_AS_ATTACHMENT = 'See Attachment';
  private static final String ATTACHMENT_NAME = 'System Exception Logger Attachment';
  private static final Map<String,System_Exception_Logger_Configuration__c> LOGGER_CONFIG_MAP = 
                System_Exception_Logger_Configuration__c.getAll();

  private static Object last_component_exception;
  public static Object component_exception_object { get; set; }
  public static String component_source_application { get; set; }
  public static String component_process_name { get; set; } 
  public static String component_exception_level { get; set; }
  public static String component_support_data { get; set; }
  public static String component_object_name { get; set; }
  public static String component_object_reference { get; set; }
  
  public static Boolean log_entry {  get;
                     set {
                      if(value &&
                        (last_component_exception == null || 
                          (last_component_exception != null && 
                            component_exception_object != last_component_exception))) { 
                        last_component_exception = component_exception_object;
    System.debug(LoggingLevel.ERROR,'last_component_exception = ' + last_component_exception);
                           insertSystemExceptionLogEntryFromComponent();
                         }    
                     }
  }
  
  /** 
   * Method: insertSystemExceptionLogEntry()
   *
   * Inserts a System_Exception_Log__c record. The exception parameter
   * is used to provide the details oof the exception being logged. 
   * If there is an eception caught while inserting the exception 
   * information. A nested exception will be logged.
   */
  public static System_Exception_Log__c insertSystemExceptionLogEntry(Exception e,
                           String sourceApplication,
                           String processName, 
                           String exceptionLevel,
                           String supportData,
                           String objectName,
                           String objectReference,
                           Boolean storeDataAsAttachment) {
    System_Exception_Log__c log;
    try {
      // trim field
      if(supportData.length() > SUPPORT_DATA_MAX_FIELD_LENGTH) {
        supportData = supportData.substring(0,SUPPORT_DATA_MAX_FIELD_LENGTH);
      }
      // create log entry
      System_Exception_Log__c logEntry = new System_Exception_Log__c (
          Name = processName,
          Source_Application__c = sourceApplication,
          Exception_Cause__c = constructCauseString(e),
          Exception_Type__c = e.getTypeName(),
          Exception_Level__c = exceptionLevel,
          Exception_Message__c =   constructMessageString(e),
          Exception_Line_Number__c = e.getLineNumber(),
          Exception_Stack_Trace__c = constructStackTraceString(e),
          Dml_Exception_Type__c = getDmlType(e),
          Object_Name__c = objectName,
          Object_Reference__c = objectReference,
          Support_Data__c = (storeDataAsAttachment)
                    ? SUPPORT_DATA_STORED_AS_ATTACHMENT
                    : supportData,
          Exception_Run_As_User__c = UserInfo.getUserId());           
      System.debug(LoggingLevel.ERROR,'Inserting : ' + logEntry);
      insert logEntry;
      if(storeDataAsAttachment) {
        storeSupportDataAsAttachment(logEntry.Id, supportData);
      }
      System.debug(LoggingLevel.ERROR,'Insert successful');
      log = logEntry;
    } catch (Exception ex) {
      // initialize the cause for the new exception
      ex.initCause(e);
      // create log entry using this class as the source and process name
      // this will always be a DML exception
      System_Exception_Log__c exLogEntry = new System_Exception_Log__c (
          Name = DEFAULT_PROCESS_NAME,
          Source_Application__c = DEFAULT_SOURCE_APPLICATION,
          Exception_Cause__c = constructCauseString(ex),
          Exception_Type__c = ex.getTypeName(),
          Exception_Level__c = EXCEPTION_LEVEL_CRITICAL,
          Exception_Message__c =   constructMessageString(ex),
          Exception_Line_Number__c = ex.getLineNumber(),
          Exception_Stack_Trace__c = constructStackTraceString(ex),
          Dml_Exception_Type__c = getDmlType(ex),
          Object_Name__c = 'System_Exception_Log__c',
          Object_Reference__c = '',
          Support_Data__c = (storeDataAsAttachment)
                    ? SUPPORT_DATA_STORED_AS_ATTACHMENT
                    : supportData,
          Exception_Run_As_User__c = UserInfo.getUserId());  
      
      try {             
        insert exLogEntry;
        if(storeDataAsAttachment) {
          storeSupportDataAsAttachment(exLogEntry.Id, supportData);
        }
        log = exLogEntry;
      } catch (Exception exc) {
        // There is nothing that can be done at this point. If an exception
        // occurs than it is most likely due to a DML not allowed condition
        // exc.setMessage('Internal exception error - possible configuration problem. ' + exc.getMessage());
        // throw(exc);
        System.debug(LoggingLevel.ERROR,'Insert failed last try: ' + exc);
        if(isRethrowExceptionEnabled(sourceApplication)) {
          throw exc;
        }        
      } 
    }
    return log;
  }  

  /** 
   * Method: insertSystemExceptionLogEntry()
   *
   * Inserts a System_Exception_Log__c record. The exception parameter
   * is used to provide the details oof the exception being logged. 
   * If there is an eception caught while inserting the exception 
   * information. A nested exception will be logged.
   */
  public static System_Exception_Log__c insertSystemExceptionLogEntry(Exception e,
                                     String sourceApplication,
                                     String processName, 
                                     String exceptionLevel,
                                     String supportData,
                                     String objectName,
                                     String objectReference) {
    return insertSystemExceptionLogEntry(e, 
                       sourceApplication, 
                       processName, 
                       exceptionLevel, 
                       '', 
                       objectName, 
                       objectReference, 
                       false);
    
  }
  /**
   * Method: insertSystemExceptionLogEntry()
   *
   * This overridden method simply calls insertSystemExceptionLogEntry
   * with empty strings set for the support data field. 
   *
   */
  public static System_Exception_Log__c insertSystemExceptionLogEntry(Exception e,
                                     String sourceApplication,
                                     String processName, 
                                     String exceptionLevel,
                                     String objectName,
                                     String objectReference) {
    return insertSystemExceptionLogEntry(e, 
                       sourceApplication, 
                       processName, 
                       exceptionLevel, 
                       '', 
                       objectName, 
                       objectReference, 
                       false);
  }

  /**
   * Method: insertSystemExceptionLogEntry()
   *
   * This overridden method simply calls insertSystemExceptionLogEntry
   * with empty strings set for the object name and object reference 
   * fields.
   *
   */
  public static System_Exception_Log__c insertSystemExceptionLogEntry(Exception e,
                                     String sourceApplication,
                                     String processName, 
                                     String exceptionLevel,
                                     String supportData) {
    return insertSystemExceptionLogEntry(e, 
                         sourceApplication, 
                         processName, 
                         exceptionLevel, 
                         supportData, 
                         '', 
                         '', 
                         false);
  }
  
  /**
   * Method: insertSystemExceptionLogEntry()
   *
   * This overridden method simply calls insertSystemExceptionLogEntry
   * with empty strings set for the object name and object reference 
   * fields.
   *
   */
  public static System_Exception_Log__c insertSystemExceptionLogEntry(Exception e,
                                     String sourceApplication,
                                     String processName, 
                                     String exceptionLevel,
                                     String supportData,
                                     Boolean storeDataAsAttachment) {
    return insertSystemExceptionLogEntry(e, 
                       sourceApplication, 
                       processName, 
                       exceptionLevel, 
                       supportData, 
                       '', 
                       '', 
                       storeDataAsAttachment);
  }
  
  /**
   * Method: insertSystemExceptionLogEntry()
   *
   * This overridden method simply calls insertSystemExceptionLogEntry
   * with empty strings set for the object name, object reference and
   * support data fields.
   */
  public static System_Exception_Log__c insertSystemExceptionLogEntry(Exception e,
                                     String sourceApplication,
                                     String processName, 
                                     String exceptionLevel) {
    return insertSystemExceptionLogEntry(e, 
                       sourceApplication, 
                       processName, 
                       exceptionLevel, 
                       '', 
                       '', 
                       '', 
                       false);
  }

  /**
   * Method: constructStackTraceString()
   *
   * This method iterates through the Exception causes to build a 
   * single cause string.
   */
   private static String constructStackTraceString(Exception e) {
    String stackTrace = e.getStackTraceString();
    if(stackTrace != null && stackTrace.length() > SUPPORT_DATA_MAX_FIELD_LENGTH) {
      stackTrace = stackTrace.substring(0,SUPPORT_DATA_MAX_FIELD_LENGTH);
    }
    return stackTrace; 
   }
    
  /**
   * Method: constructCauseString()
   *
   * This method iterates through the Exception causes to build a 
   * single cause string.
   */
  private static String constructCauseString(Exception e) {
    String cause = '';
    // get initial exception cause
    Exception causeException = e.getCause();
    while(causeException != null) {
      // append each cause string found
      cause += causeException.getStackTraceString() + '\nMessage: ' + constructMessageString(causeException);
      causeException = causeException.getCause();
    }
    // trim cause
    if(cause.length() > SUPPORT_DATA_MAX_FIELD_LENGTH) {
      cause = cause.substring(0,SUPPORT_DATA_MAX_FIELD_LENGTH);
    }
    return cause;
  }
  
  /**
   * Method: constructMessageString()
   *
   * This method build the exception message. If the exception is a 
   * DmlException, this method iterates through the DmlException and 
   * builds the message containing all DML failures.
   */
  private static String constructMessageString(Exception e) {
    String message = '';
    if(e.getTypeName().equals('System.DmlException')) {
         for(Integer i=0; i<e.getNumDml(); i++) {
           message += '[' + e.getDmlType(i) + '] ' +
                  e.getDmlMessage(i) + '\n' + 
                 'DML Field Names: ' + e.getDmlFieldNames(i) + '\n' + 
                 'DML Fields: ' + e.getDmlFields(i) + '\n' +
                 'DML Id: ' + e.getDmlId(i) + '\n' +
                 'DML Index: ' + e.getDmlIndex(i) + '\n\n';
      }
    } else {
      message = e.getMessage();
    }
    // trim message
    if(message.length() > SUPPORT_DATA_MAX_FIELD_LENGTH) {
      message = message.substring(0,SUPPORT_DATA_MAX_FIELD_LENGTH);
    }
    return message;
  }

  /**
   * Method: getDmlType()
   *
   * This method retirve the DML Exception type if a System.DmlException 
   * was thrown. If there is more than one DML exception, the type will 
   * be set to 'Multiple'.
   */
  public static String getDmlType(Exception e) {
    String dmlType = '';
    if(e.getTypeName().equals('System.DmlException')) {
      if(e.getNumDml() > 1) {
        dmlType = 'Multiple';
      } else {
        dmlType = e.getDmlType(0).name();
      }
    }
    return dmlType;
  }
  
  /**
   * Method: setComponentExceptionParameters()
   *
   * This method set the comonent attributes. This method is to be used when 
   * an entry log is to be made from within a constructor or getter method call'.
   * DML operations are not allowed in those situations, this is a work around
   */
  public static void setComponentExceptionParameters(
              Object a_component_exception_object,
              String a_component_source_application,
              String a_component_process_name,
              String a_component_exception_level,
              String a_component_support_data,
              String a_component_object_name,
              String a_component_object_reference)
  {
    System.debug('Exception Parameters Being Set');
    component_exception_object = a_component_exception_object;
    component_source_application = a_component_source_application;
    component_process_name = a_component_process_name;
    component_exception_level = a_component_exception_level;
    component_support_data = a_component_support_data;
    component_object_name = a_component_object_name;
    component_object_reference = a_component_object_reference;
  }

  /**
   * Method: setComponentExceptionParameters()
   *
   * This overridden method simply calls insertSystemExceptionLogEntry
   * with an empty string set for the support data field.
   *
   */
  public static void setComponentExceptionParameters(
              Object a_component_exception_object,
              String a_component_source_application,
              String a_component_process_name,
              String a_component_exception_level,
              String a_component_object_name,
              String a_component_object_reference)
  {
      setComponentExceptionParameters(a_component_exception_object,
                      a_component_source_application,
                      a_component_process_name,
                      a_component_exception_level,
                      '',
                      a_component_object_name,
                      a_component_object_reference);    
  }
  
  /**
   * Method: setComponentExceptionParameters()
   *
   * This overridden method simply calls insertSystemExceptionLogEntry
   * with empty strings set for the object name and object reference 
   * fields.
   *
   */
  public static void setComponentExceptionParameters(
              Object a_component_exception_object,
              String a_component_source_application,
              String a_component_process_name,
              String a_component_exception_level,
              String a_component_support_data)
  {
      setComponentExceptionParameters(a_component_exception_object,
                      a_component_source_application,
                      a_component_process_name,
                      a_component_exception_level,
                      a_component_support_data,
                      '',
                      '');    
    
  }

  /**
   * Method: setComponentExceptionParameters()
   *
   * This overridden method simply calls insertSystemExceptionLogEntry
   * with empty strings set for the support data, object name and 
   * object reference fields.
   *
   */
  public static void setComponentExceptionParameters(
              Object a_component_exception_object,
              String a_component_source_application,
              String a_component_process_name,
              String a_component_exception_level)
  {
      setComponentExceptionParameters(a_component_exception_object,
                      a_component_source_application,
                      a_component_process_name,
                      a_component_exception_level,
                      '',
                      '',
                      '');    
    
  }
  
  /**
   * Method: insertSystemExceptionLogEntryFromComponent()
   *
   * This method should be called from a component controller to insert
   * the System_Exception_Log__c record. this method calls the
   * insertSystemExceptionLogEntry using the componemt attributes.
   *
   */
  public static void insertSystemExceptionLogEntryFromComponent() {
    System.debug(LoggingLevel.ERROR,'In = insertSystemExceptionLogEntryFromComponent');
    System.debug(LoggingLevel.ERROR,'Last e = ' + last_component_exception);
    System.debug(LoggingLevel.ERROR,'This e = ' + component_exception_object);
      Exception e = (Exception)component_exception_object;
      System.debug(LoggingLevel.ERROR,'Component Exception = ' + e);
      insertSystemExceptionLogEntry(e,
                      component_source_application,
                      component_process_name,
                      component_exception_level,
                      component_support_data,
                      component_object_name,
                      component_object_reference);    
  }
  
  @TestVisible
  private static Boolean isRethrowExceptionEnabled(String sourceApplication) {
    System_Exception_Logger_Configuration__c config = LOGGER_CONFIG_MAP.get(sourceApplication);
    if(config == null) {
      config = LOGGER_CONFIG_MAP.get(DEFAULT_CONFIGURATION);
    }
    if(config == null) {
      return false;
    }
    return config.ReThrow_Exception__c;
  }
  
  private static void storeSupportDataAsAttachment(Id logEntryId, String supportData) {
    Blob pdfBlob = Blob.toPdf(supportData); 
    Attachment attachment = new Attachment (
                    Name = ATTACHMENT_NAME,
                    ParentId = logEntryId,
                    Body = pdfBlob
                    );
    insert attachment;
  }  
}