public class SG_CaseExtendedController {

    public Case m_case;
    private ApexPages.StandardController m_stdc;
	public String PageUrl {get;set;}
	public List<String> allCaseFields = new List<String>();

	public pageReference redirectCase(){
		pageReference ref = new PageReference('/'+m_case.Id+'?nooverride=1');
		ref.setRedirect(false);
		return ref;
	}

    // The constructor retrieves case and profile information
    public SG_CaseExtendedController(ApexPages.StandardController stdc){
        m_case = (Case) stdc.getRecord();
        m_stdc = stdc;
    }

	public List<String> getallCaseFields (){
        Map<String, Schema.SobjectField> fields = m_case.getSObjectType().getDescribe().fields.getMap();
        for (String s : fields.keySet()) {
	        if (fields.get(s).getDescribe().isAccessible()) {
				System.debug(s);
				allCaseFields.add(s);
			}
        }
		System.debug(allCaseFields);
		return allCaseFields;
	}

	public string RenderResult {
		get {
			return 'true';
		}
	}

    // Overload of the save method
    public PageReference SaveInConsole(){
        // When we insert a new case, it's the Javascript script that handles the page reload.
        // Otherwise, issues rise in the Salesforce Console and the page is not refreshed correctly
		if(m_case.id == null){
			//m_case.Subject = 'Subject From Controller';
			insert m_case;
			PageReference pr = new PageReference('/'+m_case.id);
			//pr.getParameters().put('key','value');
			pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
			//return pr;
			return null;
		}
        // When we update an existing case, we can keep the usual behavior
        else
            return m_stdc.save();
    }
}