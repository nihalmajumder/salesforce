public class SchemaExtractorController {
	private static final String FIELD_OPTION_ALL = 'All Fields';
	private static final String FIELD_OPTION_STANDARD = 'Standard Only';
	private static final List<String>EXTRACT_FORMAT_OPTIONS = new List<String>{'Microsoft Excel','Microsoft Word'};
	private static final Integer EXPANDED_ROW_OFFSET = 2;
	private static final String EXTERNAL_ID_TEXT = '<B xmlns="http://www.w3.org/TR/REC-html40">[External ID]</B>';
	private static final String EXTERNAL_ID_UNIQUE_TEXT = '<B xmlns="http://www.w3.org/TR/REC-html40">[External ID / Unique]</B>';
	private static final String UNIQUE_TEXT = '<B xmlns="http://www.w3.org/TR/REC-html40">[Unique]</B>';
	private static final String REQUIRED_STRING = 'Field is required';
	private static final String AVAILABLE_SOBJECT_LABEL = 'Available sObjects';
	private static final String SELECTED_SOBJECT_LABEL = 'sObjects to Extract';
	private static final Integer PICKLIST_ENTRY_LOOKUP_MAX = 100;
	private static final Integer SOBJECT_SELECTION_MAX = 100;
	
	private Map<String, Schema.SObjectType> sObjectMap;
	private Integer picklistEntryLookupCount;
	
	public List<SelectOption> availableSObjects {get; set;}
	public List<SelectOption> availableFormatOptions {get; set;}
	public List<SelectOption> selectedSObjects {get; set;}
	public List<String> sObjectsToExtract {get; set;}
	public String strsObjectsToExtract {get; set;}
	public String fileName {get; set;}
	public DateTime documentDate {get; set;}
	public String documentTitle {get; set;}
	public String documentVersion {get; set;}
	public String extractorFormat {get; set;}
	public String fieldOptions {get; set;}
	public Boolean isNonUpdatableFieldsEnabled  {get; set;}
	public Boolean isDataSummaryEnabled {get; set;}
	public Boolean isPicklistValueDisplayEnabled {get; set;}
	public Boolean isApiNameSortEnabled {get; set;}
	public SchemaExtractorSchemaData schemaModel {get; set;}
	
	public SchemaExtractorController() {
		this.availableSObjects = new List<SelectOption>();
		SelectOption startAvailableOptionGroupTag = new SelectOption('', '<optgroup label=\'' + AVAILABLE_SOBJECT_LABEL + '\'>');
		startAvailableOptionGroupTag.setEscapeItem(false);
		this.availableFormatOptions = new List<SelectOption>();
		this.sObjectsToExtract = new List<String>();
		this.sObjectMap = Schema.getGlobalDescribe();
		List<String> sortedObjects = new List<String>();
		sortedObjects.addAll(this.sObjectMap.keySet());
		sortedObjects.sort();
		for(String sObjectName : sortedObjects) {
			if(!sObjectName.endsWith('__Share') && !sObjectName.endsWith('__History') && !sObjectName.endsWith('__mdt')) {
				this.availableSObjects.add(new SelectOption(sObjectName,this.sObjectMap.get(sObjectName).getDescribe().getName()));
			}
		}		
		SelectOption endAvailableOptionGroupTag = new SelectOption('', '</optgroup>');
		endAvailableOptionGroupTag.setEscapeItem(false);
		for(String formatOption : EXTRACT_FORMAT_OPTIONS) {
			this.availableFormatOptions.add(new SelectOption(formatOption,formatOption));
			
		}
		this.selectedSObjects = new List<SelectOption>();
		SelectOption startSelectedOptionGroupTag = new SelectOption('', '<optgroup label=\'' + SELECTED_SOBJECT_LABEL + '\'>');
		startSelectedOptionGroupTag.setEscapeItem(false);
		SelectOption endSelectedOptionGroupTag = new SelectOption('', '</optgroup>');
		endSelectedOptionGroupTag.setEscapeItem(false);
		
		this.extractorFormat = 'Microsoft Excel';
	}
	
	public PageReference processExtractor() {
		this.picklistEntryLookupCount = 0;
		this.sObjectsToExtract = this.strsObjectsToExtract != null ? this.strsObjectsToExtract.split(';') : new List<String>();
		if(this.sObjectsToExtract.size() > SOBJECT_SELECTION_MAX) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please limit the number of Salesforce object to 100 to avoid Excel limitations.'));
			return null;
		}
		List<SchemaExtractorSchemaData.SObjectFields> schemaFields;
		List<SchemaExtractorSchemaData.SObjectData> standardObjects = new List<SchemaExtractorSchemaData.SObjectData>();
		List<SchemaExtractorSchemaData.SObjectData> customObjects = new List<SchemaExtractorSchemaData.SObjectData>();
		List<SchemaExtractorSchemaData.Worksheet> worksheets = new List<SchemaExtractorSchemaData.Worksheet>();
		String author = UserInfo.getName();
		String createdDate = datetime.now().format('yyyy-MM-dd hh:mm:ss').replace(' ', 'T');
		for(String selectedSObject : this.sObjectsToExtract) {
			DescribeSObjectResult sObjectResult = this.sObjectMap.get(selectedSObject).getDescribe();
			Map<String, Schema.SObjectField> sObjectFields = sObjectResult.fields.getMap();
			String objectName = generateWorksheetName(sObjectResult.getName());
			SchemaExtractorSchemaData.SObjectData sObjectData = 
				new SchemaExtractorSchemaData.SObjectData(objectName, objectName);
			if(sObjectResult.isCustom()) {
				customObjects.add(sObjectData);
			} else {
				standardObjects.add(sObjectData);
			}
			schemaFields = isApiNameSortEnabled ? processFieldsSorted(sObjectFields) : processFieldsUnSorted(sObjectFields);				
			SchemaExtractorSchemaData.Worksheet worksheet = 
				new SchemaExtractorSchemaData.Worksheet(objectName, schemaFields.size() + EXPANDED_ROW_OFFSET, schemaFields);
			worksheets.add(worksheet);
		}
		this.schemaModel = new SchemaExtractorSchemaData (this.fileName,
														  author,
														  createdDate,
														  createdDate,
														  this.documentTitle,
														  this.documentVersion,
														  this.isDataSummaryEnabled,
														  standardObjects,
														  customObjects,
														  worksheets);	
		PageReference pageRef = Page.SchemaExtractorDefaultExcelWorkbook;
		return pageRef;
	}
	
	private List<SchemaExtractorSchemaData.SObjectFields> processFieldsUnsorted(Map<String, Schema.SObjectField> sObjectFields) {
		SchemaExtractorSchemaData.SObjectFields field;
		List<SchemaExtractorSchemaData.SObjectFields> schemaFields = new List<SchemaExtractorSchemaData.SObjectFields>();
		for(Schema.sObjectField sObjectField : sObjectFields.values()) {
			if((field = retrieveSObjectField(sObjectField)) != null) {
				schemaFields.add(field);
			}
		}	
		return schemaFields;		 
	}
	
	private List<SchemaExtractorSchemaData.SObjectFields> processFieldsSorted(Map<String, Schema.SObjectField> sObjectFields) {
		SchemaExtractorSchemaData.SObjectFields field;
		List<SchemaExtractorSchemaData.SObjectFields> schemaFields = new List<SchemaExtractorSchemaData.SObjectFields>();
		List<String> sortedSObjects = new List<String>();
		sortedSObjects.addAll(sObjectFields.keySet());
		sortedSObjects.sort();
		for(String fieldName : sortedSObjects) {
			Schema.sObjectField sObjectField = sObjectFields.get(fieldName);
			if((field = retrieveSObjectField(sObjectField)) != null) {
				schemaFields.add(field);
			}
		}	
		return schemaFields;	 		
	}
	
	private SchemaExtractorSchemaData.SObjectFields retrieveSObjectField(Schema.sObjectField sObjectField) {
		SchemaExtractorSchemaData.SObjectFields field = null;
		DescribeFieldResult fieldResult = sObjectField.getDescribe();
		if(this.isNonUpdatableFieldsEnabled || fieldResult.isCreateable() || fieldResult.isUpdateable() || fieldresult.isDefaultedOnCreate()) {
			List<Schema.PicklistEntry> picklistEntries = retrievePicklistEntries(fieldResult);
			field = new SchemaExtractorSchemaData.SObjectFields(fieldResult.getLabel(),
															    fieldResult.getName(),
															    determineFieldType(fieldResult),
															    determineRequiredField(fieldResult),
																retrievePicklistValues(picklistEntries), 
																picklistEntries.size(),
																fieldResult.getLabel());
		}
		return field;
	}
	
	private String determineRequiredField(DescribeFieldResult fieldResult) {
		String required = '';
		if(fieldResult.isCreateable() && !fieldResult.isNillable() && !fieldresult.isDefaultedOnCreate()) {
			required = REQUIRED_STRING;
		}
		return required;
	}
	
	private List<Schema.PicklistEntry> retrievePicklistEntries(DescribeFieldResult fieldResult) {
		List<Schema.PicklistEntry> picklistEntries = new List<Schema.PicklistEntry>();
		if(this.isPicklistValueDisplayEnabled) {
			if(this.picklistEntryLookupCount < PICKLIST_ENTRY_LOOKUP_MAX) {
				picklistEntries = fieldResult.getPicklistValues();
				++this.picklistEntryLookupCount;
			} 
		}		
		return picklistEntries;
	}

	private String determineFieldType(DescribeFieldResult fieldResult) {
		Schema.DisplayType fieldDisplayType = fieldResult.getType();
		String fieldType = fieldDisplayType.name().toLowerCase();
		if(fieldType.equalsIgnoreCase('TextArea') || fieldType.equalsIgnoreCase('String') ||
		   fieldType.equalsIgnoreCase('Phone') || fieldType.equalsIgnoreCase('Email') ||
		   fieldType.equalsIgnoreCase('URL')) {
		   	fieldType += '(' + fieldResult.getLength() + ')';
		}
		if(fieldType.equalsIgnoreCase('Reference')) {
			fieldType += fieldResult.getReferenceTo();
		}
		if(fieldType.equalsIgnoreCase('Double')) {
			fieldType += '(' + fieldResult.getPrecision() + ','+ fieldResult.getScale() + ')';
		}
		if(fieldResult.isExternalID() && fieldResult.isUnique()) {
			fieldType += EXTERNAL_ID_UNIQUE_TEXT;
		} else {
			if(fieldResult.isExternalID()) {
				fieldType += EXTERNAL_ID_TEXT;
			} else {
				if(fieldResult.isUnique()) {
					fieldType += UNIQUE_TEXT;
				}
			}
		}
		return fieldType;	
	}
	
	private String retrievePicklistValues(List<Schema.PicklistEntry> picklistEntries) {
		String picklistValues = '';
		for(Schema.PicklistEntry entry : picklistEntries) {
			picklistValues += entry.getValue() + (entry.isDefaultValue() ? '(Default)' : '') + '&#13;';
		}
		return picklistValues;
	}
	
	private String generateWorksheetName(String objName) {
		String objNameOrig = objName;
		Integer customIndex = objName.indexOf('__');
		String afterIndex = objName.substring(customIndex + 2);
		return (afterIndex.length() > 1) ? afterIndex : objNameOrig;		
	}
}