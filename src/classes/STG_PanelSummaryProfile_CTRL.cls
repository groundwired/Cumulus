public with sharing class STG_PanelSummaryProfile_CTRL extends STG_Panel {
    
    /*********************************************************************************************************
    * @description Returns the string Id of the summary profile panel. 
    */
    public override string idPanel() { return 'idPanelSummaryProfile'; }

    /*********************************************************************************************************
    * @description Action Method to save the current settings
    * @return null 
    
    public override PageReference saveSettings() {
        //logic here to take the entered values and save them
        
        return super.saveSettings();
    }

    
	public list<Summary_Profile__c>getCustomSetting(){
        List<Summary_Profile__c>customSettingValue=[SELECT Id, Affiliations_Active__c,Affiliations_Inactive__c,  Email__c, 
		Mailing_Address__c, Max_Affiliations__c, Max_Relationships__c, Phone__c,
		Primary_Affiliation__c, Primary_Contact__c, Relationships_Active__c,Relationships_Inactive__c FROM Summary_Profile__c LIMIT 1];
        //built to be extensible to have multiple profile configurations in a future version
        return customSettingValue;
    }
   */
}