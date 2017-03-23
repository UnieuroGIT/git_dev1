public class Case_OverridePageEdit {

    
    private String m_profileName {get;set;}
    private ID m_profileID;

    // The constructor stores profile ID and profile Name of the user that is using the Visualforce page
    public Case_OverridePageEdit(ApexPages.StandardController stdc){
        system.debug('Case_selectPicklistValues::Constructor starting.');

        m_profileID = userInfo.getProfileId();
        m_profileName = [select Name from Profile where id =: m_profileID].Name;
        system.debug('Case_selectPicklistValues::Constructor current user profile is ' + m_profileName);

        system.debug('Case_selectPicklistValues::Constructor ending.');
    }

    // Utility method that retrieves picklist values for the field specified in the input string
    private List<SelectOption> retrievePicklistValues(String fieldLabel){
        system.debug('Case_selectPicklistValues::retrieveValues starting');
        String CSfieldName = fieldLabel + '_cs__c';

        // instantiating custom setting for the current profile
        Config_cs_casePicklistValues__c cs = Config_cs_casePicklistValues__c.getInstance(m_profileID);
        String CSfieldValue = (String) cs.get(CSfieldName);
        List<SelectOption> lso = new List<SelectOption>();
        
        // extracting picklist values from the given field
        // if the given field is not populated, then retrieve org defaults
        if(String.isBlank(CSfieldValue)){
            cs = Config_cs_casePicklistValues__c.getOrgDefaults();
            CSfieldValue = (String) cs.get(CSfieldName);
        }

        List<String> picklistValues = CSfieldValue.split(',',0);
        system.debug('%%' + picklistValues);
        
        for(String pickValue : picklistValues){
            // removing spurious leading or trailing white space characters
            pickValue.trim();
            lso.add(new SelectOption(pickValue, pickValue));
        }

        system.debug('Case_selectPicklistValues::retrieveValues ending');
        return lso;
    }

    // Utility method that retrieves a visibility result related to the field specified in the input string
    private Boolean retrieveVisibility(String fieldLabel){
        system.debug('Case_selectPicklistValues::getTestFieldVisibility starting.');
        String CSfieldName = fieldLabel + '_cs__c';
        
        
        /* SLanzafame: da sostituire con il cd Case_Field_Visibility_cs__c di tipo lista*/
        
        // instantiating custom setting for the current profile
        Config_cs_caseFieldVisibility__c cs = Config_cs_caseFieldVisibility__c.getInstance(m_profileID);
        Boolean CSfieldValue = (Boolean) cs.get(CSfieldName);
        // if the given field is not populated, then retrieve org defaults
        if(CSfieldValue == null){
            cs = Config_cs_caseFieldVisibility__c.getOrgDefaults();
            CSfieldValue = (Boolean) cs.get(CSfieldName);
        }

        system.debug('Case_selectPicklistValues::getTestFieldVisibility ending.');
        
        /**********************************************************************/
        
        
        return CSfieldValue;
    }

    // getTestPicklist retrieves the list of picklist values for the field TestPicklist
    public List<SelectOption> getTestPicklist_Values(){
        return retrievePicklistValues('TestPicklist');
    }

    // returns the visibility of the field Field1
    public Boolean getTestFieldVisibility_Field1(){
        return retrieveVisibility('Field1');
    }

    // returns the visibility of the field Field2
    public Boolean getTestFieldVisibility_Field2(){
        return retrieveVisibility('Field2');
}
}