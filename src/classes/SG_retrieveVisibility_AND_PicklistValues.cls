// 12/16 MatteoFacchini
public class SG_retrieveVisibility_AND_PicklistValues {

    public String m_profileName {get;set;}
    private ID m_profileID;
    public SObject m_sobject {get;set;}
    public String m_fieldAPIName {get;set;}


    // Constructor without parameters
    public SG_retrieveVisibility_AND_PicklistValues(){
        system.debug('retrieveVisibility::Constructor starting.');

        m_profileID = userInfo.getProfileId();
        m_profileName = [select Name from Profile where id =: m_profileID].Name;
        system.debug('retrieveVisibility::Constructor current user profile is ' + m_profileName);

        system.debug('retrieveVisibility::Constructor ending.');
    }

    // Utility method that retrieves a visibility result related to the field specified in the input string
    public Boolean getRetrieveVisibility(){
        system.debug('retrieveVisibility::getRetrieveVisibility starting.');

        // retrieving API name for the Custom setting field
        String CSfieldName = m_fieldAPIName.removeEnd('__c') + '_cs__c';
        
        // instantiating custom setting for the current profile
        Config_cs_caseFieldVisibility__c cs = Config_cs_caseFieldVisibility__c.getInstance(m_profileID);
        Boolean CSfieldValue = (Boolean) cs.get(CSfieldName);
        // if the given field is not populated, then retrieve org defaults
        if(CSfieldValue == null){
            cs = Config_cs_caseFieldVisibility__c.getOrgDefaults();
            CSfieldValue = (Boolean) cs.get(CSfieldName);
        }

        system.debug('retrieveVisibility::getRetrieveVisibility ending.');
        return CSfieldValue;
    }

    // Utility method that retrieves picklist values for the field specified in the input string
    public List<SelectOption> getRetrievePicklistValues(){
        system.debug('selectPicklistValues::retrieveValues starting');
        List<SelectOption> lso = new List<SelectOption>();
        
        // retrieving API name for the Custom setting field
        String CSfieldName = m_fieldAPIName.removeEnd('__c') + '_cs__c';

        // instantiating custom setting for the current profile
        Config_cs_casePicklistValues__c cs = Config_cs_casePicklistValues__c.getInstance(m_profileID);
        String CSfieldValue = (String) cs.get(CSfieldName);
        
        
        
         /* SLanzafame: da sostituire con il cd Case_Field_Visibility_cs__c di tipo lista*/
        
        // extracting picklist values from the given field
        // if the given field is not populated, then retrieve org defaults
        if(String.isBlank(CSfieldValue)){
            cs = Config_cs_casePicklistValues__c.getOrgDefaults();
            CSfieldValue = (String) cs.get(CSfieldName);
        }

        /**********************************************************************/

        List<String> picklistValues = CSfieldValue.split(',',0);
        system.debug('%%' + picklistValues);
        
        for(String pickValue : picklistValues){
            // removing spurious leading or trailing white space characters
            pickValue.trim();
            lso.add(new SelectOption(pickValue, pickValue));
        }

        
        system.debug('selectPicklistValues::retrieveValues ending');
        return lso;
    }

    // returning SObject name
    public String getObjType(){
        return m_sobject.getSObjectType().getDescribe().getName();
    }
}