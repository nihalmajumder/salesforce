public class SchemaExtractorSchemaData {
	private static final String XML_HEADER = '<?xml version="1.0" encoding="UTF-8"?><?mso-application progid="Excel.Sheet"?>';
	private static final String END_WORKSHEET_TAG = '</Worksheet>';
	private static final String END_WORKBOOK_TAG = '</Workbook>';
	private static final Integer WORKSHEET_NAME_LIMIT = 31;
	
	public String xmlHeader {get; private set;}
	public String endWorkSheetTag {get; private set;}
	public String endWorkBookTag {get; private set;}
	public String fileName {get; private set;}
	public String author {get; private set;}
	public String createdDate {get; private set;}
	public String mapDocDate {get; private set;}
	public String mapDocTitle {get; private set;}
	public String version {get; private set;}
	public Boolean isDataSummaryEnabled {get; private set;}
	public List<SObjectData> standardObjects {get; private set;}
	public List<SObjectData> customObjects {get; private set;}
	public List<Worksheet> worksheet {get; private set;}
	
	public SchemaExtractorSchemaData(String fileName, 
									 String author, 
									 String createdDate,
									 String mapDocDate, 
									 String mapDocTitle,
									 String version, 
									 Boolean isDataSummaryEnabled, 
									 List<SObjectData> standardObjects, 
									 List<SObjectData> customObjects, 
									 List<Worksheet> worksheet) {
		this.xmlHeader = XML_HEADER;
		this.endWorkSheetTag = END_WORKSHEET_TAG;
		this.endWorkBookTag = END_WORKBOOK_TAG;
		this.fileName = fileName;
		this.author = author;
		this.createdDate = createdDate;
		this.mapDocDate = mapDocDate;
		this.mapDocTitle = mapDocTitle;
		this.version = version;
		this.isDataSummaryEnabled = isDataSummaryEnabled;
		this.standardObjects = standardObjects;
		this.customObjects = customObjects;
		this.worksheet = worksheet;
	}

	public class SObjectData {
		public String name {get; private set;}
		public String description {get; private set;}
		
		public SObjectData(String name, String description) {
			this.name = name;
			this.description = description;
		}
	}
	
	public class Worksheet {
		public String name {get; private set;}
		public Integer expandedRowCount {get; private set;}
		public List<SObjectFields> schemaFields {get; private set;}
		
		public Worksheet(String name, Integer expandedRowCount, List<SObjectFields> schemaFields) {
			this.name = name.length() > WORKSHEET_NAME_LIMIT
						? name.substring(0,WORKSHEET_NAME_LIMIT)
						: name;
			this.expandedRowCount = expandedRowCount;
			this.schemaFields = schemaFields;
		}
	}
	
	public class SObjectFields {
		public String label {get; private set;}
		public String apiName {get; private set;}
		public String fieldType {get; private set;}
		public String validation {get; private set;}
		public String picklistValues {get; private set;}
		public String fieldRowHeight {get; private set;}
		public String description {get; private set;}
		
		public SObjectFields(String label,
						     String apiName,
						     String fieldType,
						     String validation,
						     String picklistValues, 
						     Integer picklistCount,
						     String description) {
			this.label = label.escapeXml();
			this.apiName = apiName;
			this.fieldType = fieldType;
			this.validation = validation;
			this.picklistValues = picklistValues;
			this.fieldRowHeight = (picklistCount == 0) ? '13.0' : Decimal.valueOf(picklistCount * 13).toPlainString() + '.0';
			this.description = description;
		}
	}
	
}