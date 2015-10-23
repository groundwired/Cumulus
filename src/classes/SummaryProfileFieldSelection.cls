/**
 * Class: SummaryProfileFieldSelection
 *
 * Copyright: ?
 *
 * Purpose: This class allows for a generic custom field selection interface. In this instance it is used to select fields that will show up on a Summary Profile Page.
 * 
 * Where Referenced: SummaryProfileFieldSelection.component
 *   
 *
 * Change History:
 *
 * Developer         Date                          Description
 * ---------------------------------------------------------------------------------------
 * Drew Piston      2015.10.23   		 Initial Development
 *
 * 
 */


public without sharing class SummaryProfileFieldSelection {
	public String newRecordURLWithPreFill;

	// wrapper for fields on source object
	public List<SummaryProfileSettingsUtility.fieldWrapper> sourceFieldWrappers {get; set;}
	// preselected fields
	public List<SummaryProfileSettingsUtility.fieldWrapper> preselectedSourceFieldWrappers {get; set;}

	// name of the source object (e.g., Contact)
	public String sourceObject {get; set;}

	// Tooling API class
	public SummaryProfileTooling summaryProfileTooling {get; set;}

	// save was successful
	public Boolean renderSaveSuccessful {get; set;}

	// constructor
	public SummaryProfileFieldSelection() {
		renderSaveSuccessful = false;
	}

	// getter that loads everything since the sourceobject component attribute isn't set when the constructor loads
	public Boolean successInit;
	public Boolean getSuccessfulInitiation(){
		if (successInit == null){
			successInit = false;
			try {
				summaryProfileTooling = new summaryProfileTooling();
				loadFieldWrappers();
				successInit = true;
			} catch (Exception e){
				System.debug(LoggingLevel.ERROR, 'ERROR ' + e.getMessage() + e.getStackTraceString());
				return false;
			}
		}
		return successInit;
	}

	public void loadFieldWrappers() {
		// instantiate field wrappers
		sourceFieldWrappers = new List<SummaryProfileSettingsUtility.fieldWrapper>();
		// query tooling api for field definitions
		List<summaryProfileTooling.FieldDefinition> customFieldDefintions = (List<summaryProfileTooling.FieldDefinition>)summaryProfileTooling.getFieldDefinitions(sourceObject);
		// map of api name to field wrapper
		Map<String, SummaryProfileSettingsUtility.fieldWrapper> apiNameToFieldWrapper = new Map<String, SummaryProfileSettingsUtility.fieldWrapper>();
		// loop through field definitions, populate map and sourcefieldwrapper map
		for(summaryProfileTooling.FieldDefinition FieldDefinition : customFieldDefintions){
			// only continue for custom fields (e.g., fields with "__c")
	     	if (FieldDefinition.qualifiedAPIName.contains('__c')){
	     		SummaryProfileSettingsUtility.fieldWrapper fWrap = new SummaryProfileSettingsUtility.fieldWrapper(FieldDefinition.Id, FieldDefinition.qualifiedAPIName, FieldDefinition.label, '', false, sourceObject, 1);
	     		apiNameToFieldWrapper.put(fWrap.apiName, fWrap);
	     		sourceFieldWrappers.add(fWrap);
	     	}
		}	

		// method call that puts the list in alphabetical order
		alphabetizeTheLists();

		// list of fields that have already been selected (and hence are in custom settings)
		preselectedSourceFieldWrappers = new List<SummaryProfileSettingsUtility.fieldWrapper>();
		
		for (SummaryProfileSettingsUtility.fieldWrapper fWrapper : SummaryProfileSettingsUtility.readSummaryProfileCustomFields()){
			if (sourceObject == fWrapper.ObjectName && apiNameToFieldWrapper.get(fWrapper.apiName) != null){
				// set the index variable for all of the pre-selected fields
				fWrapper.theIndex = apiNameToFieldWrapper.get(fWrapper.apiName).theIndex;
				// set "renderme" to false for all preselected fieldwrappers
				apiNameToFieldWrapper.get(fWrapper.apiName).renderMe = false;
				preselectedSourceFieldWrappers.add(fWrapper);
			}
		}
	}

	// property string of semi-colon separated index values of selected field wrappers
	public String sourceIndexStringFromJS {get; set;}

	// method that actually sends selected field wrappers to the utils method (that writes to custom settings)
	public PageReference saveToCustomSetting(){
		// get all the indices from the selected fields wrappers...
		List<String> sourceIndexes = sourceIndexStringFromJS.split(';');

		// ... and then collect them in this list to send to utils method
		List<SummaryProfileSettingsUtility.FieldWrapper> fieldWrappersToSend = new List<SummaryProfileSettingsUtility.FieldWrapper>();

		// translate
		for (Integer i = 0; i < sourceIndexes.size(); i++){
			Integer sourceIndex = Integer.valueOf(sourceIndexes[i]);
			fieldWrappersToSend.add(sourceFieldWrappers[sourceIndex]);
		}

		// call to utils class to create custom settings
		SummaryProfileSettingsUtility.saveSummaryProfileCustomFields(fieldWrappersToSend);
		renderSaveSuccessful = true;
		return null;
	}

	public void alphabetizeTheLists(){
		sourceFieldWrappers = alphabetizeFieldWrappers(sourceFieldWrappers);
	}

	public List<SummaryProfileSettingsUtility.FieldWrapper> alphabetizeFieldWrappers(List<SummaryProfileSettingsUtility.FieldWrapper> theList){
		List<String> labelList = new List<String>();
		Map<String, SummaryProfileSettingsUtility.FieldWrapper> labelMap = new Map<String, SummaryProfileSettingsUtility.FieldWrapper>();
		Integer i = 0; // append a unique integer to each one to handle case where two field names are exactly the same

		for (SummaryProfileSettingsUtility.FieldWrapper fw : theList){
			// add spaces before the integer so isn't alphabetized after spaces (e.g., "Custom" should come before "Custom Object", but "Custom1" would be after "Custom Object2")
			String key = fw.label.toLowerCase() +  '   ' + String.valueOf(i);
			labelList.add(key);
			labelMap.put(key, fw);
			i++;
		}

		labelList.sort();
		List<SummaryProfileSettingsUtility.FieldWrapper> alphabetziedList = new List<SummaryProfileSettingsUtility.FieldWrapper>();
		for (String label : labelList ){
			alphabetziedList.add(labelMap.get(label));
		}
		return alphabetziedList;
	}

}