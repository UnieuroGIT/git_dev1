public with sharing class SG_CaseOverrideEdit_Controller {
    
    // 01/2017 Matteo Facchini

    public Case m_case;
    private ApexPages.StandardController m_stdc;
    private List<FieldInstance> fieldInstances;
    private integer m_index;

    // The constructor retrieves case and profile information
    public SG_CaseOverrideEdit_Controller(ApexPages.StandardController stdc){
        system.debug('retrieveFieldVisibility_new::Constructor starting.');

        // Extracting fields to create the dynamic section
        Map<String,Schema.SObjectField> fieldsMap = Case.SObjectType.getDescribe().fields.getMap();
        List<String> fieldAPINames = new List<String>();
        for(String fieldAPIName : fieldsMap.keySet())
            fieldAPINames.add(fieldAPIName);
        stdc.addFields(fieldAPINames);

        m_case = (Case) stdc.getRecord();
        m_stdc = stdc;

        m_index = 0;
        fieldInstances = new List<FieldInstance>();

        system.debug('retrieveFieldVisibility_new::Constructor ending.');
    }

    // method that returns a dynamic section based on Case Picklist Values and Case Field Visibility custom settings
    private Component.Apex.PageBlockSection retrieveFields(boolean isInputField){
        // Creating section
        Component.Apex.PageBlockSection dynSect = new Component.Apex.PageBlockSection();
        dynSect.columns = 2;

        // resetting fieldInstances
        fieldInstances = new List<FieldInstance>();
        m_index = 0;

        // loading custom settings based on the new value of Motivo_di_Contatto__c
        for(Case_Field_Visibility_cs__c cfv : [select API_name_cs__c, Motivo_di_contatto_cs__c, Ordinamento_cs__c, Required_cs__c from Case_Field_Visibility_cs__c where Motivo_di_contatto_cs__c =: m_case.Motivo_di_contatto__c order by Ordinamento_cs__c]){
            fieldInstances.add(new FieldInstance(cfv.API_name_cs__c,cfv.Ordinamento_cs__c,cfv.Required_cs__c));
        }
        
        // creating a column and filling it with an input field or an output field depending on the value of
        // 'isInputField'. In addition, if the field is a picklist, field values are retrieved via a custom setting
        for(FieldInstance currentField : fieldInstances){
            Component.Apex.PageBlockSectionItem item = new Component.Apex.PageBlockSectionItem();
            
            // creating output label
            Component.Apex.OutputLabel optlb = new Component.Apex.OutputLabel();
            optlb.value = Schema.SobjectType.Case.fields.getMap().get(currentField.m_fieldAPIName).getDescribe().getLabel();
            optlb.for = 'ID-' + currentField.m_fieldAPIName;
            
            item.childComponents.add(optlb);
            
            if(Schema.SobjectType.Case.fields.getMap().get(currentField.m_fieldAPIName).getDescribe().isRestrictedPicklist() && isInputField){
                
                Component.Apex.SelectList sl = new Component.Apex.SelectList();
                sl.expressions.value = '{!' + currentField.m_getField + '}';
                sl.id = 'ID-' + currentField.m_fieldAPIName;
                sl.size = 1;

                Component.Apex.SelectOptions sop = new Component.Apex.SelectOptions();
                sop.expressions.value = '{!PickVal' + String.valueOf(m_index) + '}';
                sl.childComponents.add(sop);

                item.childComponents.add(sl);
                
            }else if(!Schema.SobjectType.Case.fields.getMap().get(currentField.m_fieldAPIName).getDescribe().isRestrictedPicklist() && isInputField){
                Component.Apex.InputField inptf = new Component.Apex.InputField();
                inptf.expressions.value = '{!' + currentField.m_getField + '}';
                inptf.id = 'ID-' + currentField.m_fieldAPIName;
                inptf.required = currentField.m_required;
                item.childComponents.add(inptf);
            }else{
                Component.Apex.OutputField outptf = new Component.Apex.OutputField();
                outptf.expressions.value = '{!' + currentField.m_getField + '}';
                outptf.id = 'ID-' + currentField.m_fieldAPIName;
                item.childComponents.add(outptf);
            }
        
            dynSect.childComponents.add(item);
            m_index = m_index + 1;
        }
        
        return dynSect;
    }

    // Overload of the save method
    public PageReference SaveInConsole(){
        // When we insert a new case, it's the Javascript script that handles the page reload.
        // Otherwise, issues rise in the Salesforce Console and the page is not refreshed correctly
        if(m_case.id == null){
            insert m_case;
            return null;
        }
        // When we update an existing case, we can keep the usual behavior
        else
            return m_stdc.save();
    }

    public class FieldInstance{

        public String m_fieldAPIName;
        public String m_getField;
        public Decimal m_ordinamento;
        public Boolean m_required;
        private ID m_profileID;

        // Constructor
        public FieldInstance(String fAPI, Decimal Ord, Boolean Req){
            this.m_fieldAPIName = fAPI;
            this.m_getField     = 'Case.' + fAPI;
            this.m_ordinamento  = Ord;
            this.m_required     = Req;
            this.m_profileID    = userInfo.getProfileId(); 
        }

        // Utility method that retrieves picklist values for the field specified in the input string
        public List<SelectOption> getRetrievePicklistValues(){

            List<SelectOption> lso = new List<SelectOption>();
        
            // retrieving API name for the Custom setting field
            String CSfieldName = this.m_fieldAPIName.removeEnd('__c') + '_cs__c';

            // instantiating custom setting for the current profile
            Config_cs_casePicklistValues__c cs = Config_cs_casePicklistValues__c.getInstance(this.m_profileID);
            String CSfieldValue = (String) cs.get(CSfieldName);
        
            // extracting picklist values from the given field
            // if the given field is not populated, then retrieve org defaults
            if(String.isBlank(CSfieldValue)){
                cs = Config_cs_casePicklistValues__c.getOrgDefaults();
                CSfieldValue = (String) cs.get(CSfieldName);
            }

            List<String> picklistValues = CSfieldValue.split(',',0);
        
            for(String pickValue : picklistValues){
                // removing spurious leading or trailing white space characters
                pickValue.trim();
                lso.add(new SelectOption(pickValue, pickValue));
            }

            return lso;
        }
        
    }

    
    // method used to produce an input field.
    // BAD DESIGN REASON: the apex:dynamiccomponent creates issues when inserted in an apex:component
    public Component.Apex.PageBlockSection getPrintInputFields(){return retrieveFields(true);}

    // method used to produce an output field.
    // BAD DESIGN REASON: the apex:dynamiccomponent creates issues when inserted in an apex:component
    public Component.Apex.PageBlockSection getPrintOutputFields(){return retrieveFields(false);}
    

    // methods used to populate picklists based on the custom setting
    // BAD DESIGN REASON: encapsulation is needed to prevent failures due to the concurrent computation of the VF page.
    // However, I did not found a way to call 'getRetrievePicklistValues' feeding it with an argument (in VF). In addition, 
    // it is not possible to use neither VF variables nor VF components inside the apex:dynamiccomponent. 
    // The only solution I could find was hardcoding field changes in different functions.
    public List<SelectOption> getPickVal0(){ return fieldInstances[0].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal1(){ return fieldInstances[1].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal2(){ return fieldInstances[2].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal3(){ return fieldInstances[3].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal4(){ return fieldInstances[4].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal5(){ return fieldInstances[5].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal6(){ return fieldInstances[6].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal7(){ return fieldInstances[7].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal8(){ return fieldInstances[8].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal9(){ return fieldInstances[9].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal10(){ return fieldInstances[10].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal11(){ return fieldInstances[11].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal12(){ return fieldInstances[12].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal13(){ return fieldInstances[13].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal14(){ return fieldInstances[14].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal15(){ return fieldInstances[15].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal16(){ return fieldInstances[16].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal17(){ return fieldInstances[17].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal18(){ return fieldInstances[18].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal19(){ return fieldInstances[19].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal20(){ return fieldInstances[20].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal21(){ return fieldInstances[21].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal22(){ return fieldInstances[22].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal23(){ return fieldInstances[23].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal24(){ return fieldInstances[24].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal25(){ return fieldInstances[25].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal26(){ return fieldInstances[26].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal27(){ return fieldInstances[27].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal28(){ return fieldInstances[28].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal29(){ return fieldInstances[29].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal30(){ return fieldInstances[30].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal31(){ return fieldInstances[31].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal32(){ return fieldInstances[32].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal33(){ return fieldInstances[33].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal34(){ return fieldInstances[34].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal35(){ return fieldInstances[35].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal36(){ return fieldInstances[36].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal37(){ return fieldInstances[37].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal38(){ return fieldInstances[38].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal39(){ return fieldInstances[39].getRetrievePicklistValues();}
    public List<SelectOption> getPickVal40(){ return fieldInstances[40].getRetrievePicklistValues();}
}