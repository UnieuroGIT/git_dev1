// 11/2016 Matteo Facchini

@isTest
private class SG_retrVisibility_AND_PicklistValuesTest {

static private void InsertCustomSettings(){
    // Instantiating Custom setting for the system administrator profile
    Config_cs_casePicklistValues__c cs = new Config_cs_casePicklistValues__c();
    cs.SetupOwnerId = userInfo.getProfileId();
    cs.TestPicklist_cs__c = '';
    insert cs;

    Config_cs_casePicklistValues__c csOrg = new Config_cs_casePicklistValues__c();
    csOrg.SetupOwnerId = userInfo.getOrganizationId();
    csOrg.TestPicklist_cs__c = 'A,B,C,D,E,F';
    insert csOrg;
}

 static testmethod void Test_getTestPicklist_SystemAdmin(){
    InsertCustomSettings();

    // Instantiating the controller
    SG_retrieveVisibility_AND_PicklistValues c = new SG_retrieveVisibility_AND_PicklistValues();
    c.m_sobject = (SObject) new Case();

    //c.getTestPicklist();

    //System.assertEquals('System Administrator', c.profileName);

 }

 static testmethod void Test_getTestPicklist_StandardUser(){
    InsertCustomSettings();

    // Instantiating the controller
    SG_retrieveVisibility_AND_PicklistValues c = new SG_retrieveVisibility_AND_PicklistValues();
    
    //c.getTestPicklist();

    //System.assertEquals('Standard User', c.profileName);

 }
}