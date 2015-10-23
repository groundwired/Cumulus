/*
* Utility class to save and write settings for customizing the donor profile
*/
public with sharing class SummaryProfileSettingsUtility {
	
	//method to save fields to custom setting, list custom setting
	public static void saveSummaryProfileCustomFields(List<fieldWrapper> custFields) {
		//delete all custom fields settings
		List<Summary_Profile_Custom_Fields__c> custFieldsSettings = [select id from Summary_Profile_Custom_Fields__c];
		delete custFieldsSettings;
		
		//now insert the new ones
		Integer orderIndex = 0;
		List<Summary_Profile_Custom_Fields__c> listOfCustomFields = new List<Summary_Profile_Custom_Fields__c>();
		for (fieldWrapper fw : custFields) {
			String csName = orderIndex+fw.objectName.left(3)+fw.apiName;
			Summary_Profile_Custom_Fields__c sc = new Summary_Profile_Custom_Fields__c(Name=csName.left(255),
													Object_Name__c = fw.objectName, Field_Name__c=fw.apiName,
													Order__c=orderIndex, Column__c=fw.column);
			orderIndex++;	
			listOfCustomFields.add(sc);
		}
		insert listOfCustomFields;
												 
	}
	
	//read the summary profile custom settings and return field wrappers
	public static List<fieldWrapper> readSummaryProfileCustomFields() {
		//List<Summary_Profile_Custom_Fields__c> spcf = Summary_Profile_Custom_Fields__c.getall().values();
		//use soql so we can order them more easily
		List<Summary_Profile_Custom_Fields__c> spcf = [select name, Object_Name__c, Field_Name__c, Order__c, Column__c
													from Summary_Profile_Custom_Fields__c order by Order__c];	
		List<fieldWrapper> fieldWrappers = new List<fieldWrapper>();
		for (Summary_Profile_Custom_Fields__c cf : spcf) {
			String label = getFieldLabel(cf.Object_Name__c, cf.Field_Name__c);
			Integer col = (cf.Column__c == null ? 0 : (Integer)cf.Column__c);
			fieldWrapper fw = new fieldWrapper('', cf.Field_Name__c, label, '', true, cf.Object_Name__c, col);
			fieldWrappers.add(fw);	
		}
		System.debug('DEBUG>>> '+fieldWrappers);
		return fieldWrappers;
	}
	
	//returns the label for a given field on a given object
	public static String getFieldLabel(String objName, String fieldName) {
		//to do describe the object and get the label of the specified field
		Map<String, Schema.SObjectType> GlobalMap = Schema.getGlobalDescribe();
		Schema.DescribeSObjectResult obj = GlobalMap.get(objName).getDescribe();
		Schema.DescribeFieldResult fieldDesc = obj.Fields.getMap().get(fieldName).getDescribe();		
		//System.debug(fieldDesc.getLabel());
		return fieldDesc.getLabel();
	}
	
	public class fieldWrapper{
		public String idString {get; set;} // id of field, used when target of prefill and for pre-existing buttons
		public String idStringSource {get; set;} // id of the source, used for pre-existing buttons
		public String apiName {get; set;} // api name of field, used when source of prefill
		public String apiNameForCorrespondingId {get; set;} // api name of corresponding id, used when source of prefill for lookup
		public String label {get; set;} // user friendly label
		public String labelFull {get; set;} // user friendly label
		public String sourceField {get; set;} // set by user as the specific source -- this is the api name
		public String sourceFieldForId {get; set;} // corresponding api name of lookup field for sourcefield
		public Integer theIndex {get; set;}
		public Boolean isStandard {get; set;}
		public Boolean renderMe {get; set;} // only render target wrappers if they aren't part of an existing button
		public String objectName {get; set;}
		public Integer column {get; set;} 

		public fieldWrapper(String idStringParam, String apiNameParam, String labelParam, 
								String apiNameForCorrespondingIdParam, Boolean isStandardParam, String objName,
								Integer col){
			idString = idStringParam;
			apiName = apiNameParam;
			label = labelParam.length() > 27 ? labelParam.left(24) + '...' : labelParam;
			labelFull = apiNameParam;
			apiNameForCorrespondingId = apiNameForCorrespondingIdParam;
			isStandard = isStandardParam;
			renderMe = true;
			objectName = objName;
			column = col;
		}
	}
	
}