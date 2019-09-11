/*
 * Name    : SFDCMultiSelectListController
 * Date    : February 11, 2012 
 * Description:
 * 
 * History : Jim Casazza 
 *      
 */
 /**
  *
  * This class provides the controller to the multi select list 
  * component. The componenet provides a multi select list similar
  * tp the Salesforce.com multi select list using the <apex:inputField>
  * tag on a picklist field with multiple set to true.
  *
  * This class controls 
  * 
  */
public class SFDCMultiSelectListController {
	// private constant to define label 
   	private static final String AVAILABLE_SOBJECT_LABEL = 'Available';
	private static final String SELECTED_SOBJECT_LABEL = 'Chosen';
	
	public List<SelectOption> optionList{set; get;}
	public String chosenOptions {get; set;}
	
  /** 
   * Default Constructor
   *
   */
	public SFDCMultiSelectListController() {  
		System.debug('In SFDCMultiSelectListController selected Values = ' + chosenOptions);
	}
	
	public List<SelectOption> getAvailableOptionList() {
		return convertToSFDCMultipleSelectOption(optionList,AVAILABLE_SOBJECT_LABEL, false);
	}
	
	public List<SelectOption> getChosenOptionList() {
		return convertToSFDCMultipleSelectOption(optionList,SELECTED_SOBJECT_LABEL,true);
	}
	
  	private List<SelectOption> convertToSFDCMultipleSelectOption(List<SelectOption> selectOptions, String optGroupLabel, Boolean selected) {
  		Integer listCount = 0;
  		Set<String> selectedValuesSet = new Set<String>();
  		if(this.chosenOptions != null) {
  			selectedValuesSet.addAll(this.chosenOptions.split(';'));
  		}
	  	List<SelectOption> sfdcMultipleSelectOption = new List<SelectOption>();
	    SelectOption startOptionGroupTag = new SelectOption('', '<optgroup label=\'' + optGroupLabel + '\'>');
		startOptionGroupTag.setEscapeItem(false);
		sfdcMultipleSelectOption.add(startOptionGroupTag);
	  	for(SelectOption selectOption : selectOptions) {
	  		if((selected && selectedValuesSet.contains(selectOption.getValue())) || 
	  		  (!selected && !selectedValuesSet.contains(selectOption.getValue()))) {
				sfdcMultipleSelectOption.add(new SelectOption(listCount.format(), selectoption.getLabel()));
	  		  }
			++listCount;
		}		
		SelectOption endOptionGroupTag = new SelectOption('', '</optgroup>');
		endOptionGroupTag.setEscapeItem(false);
		sfdcMultipleSelectOption.add(endOptionGroupTag);
		return sfdcMultipleSelectOption;
  	}	
  	
  	public List<String> getSelectedValues() {
  		List<String> options;
  		if(chosenOptions != null) {
  			options = chosenOptions.split(';');
  		}
  		return options;
  	}
  	
  	public void setSelectedValues(List<String> values) {
  		if(values.size() > 0) {
  			chosenOptions = values.get(0);
  		}
  	}
  	
  	public PageReference updateSelectedValues() {
  		System.debug('In updateSelectedValues selected values = ' + chosenOptions);
  		return null;
  	}
}