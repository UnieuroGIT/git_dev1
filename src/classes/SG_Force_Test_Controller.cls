public class SG_Force_Test_Controller {

	public string idNegozio {get; set;}

	public List<Case> listacasi{get; Set;}

	public SG_Force_Test_Controller(ApexPages.StandardController stc){
	idNegozio = ApexPages.currentPage().getParameters().get('idNegozio');
	System.debug(idNegozio);
	listacasi= [select Id, CaseNumber, Subject, Status, CreatedDate, OwnerId, Numero_Case__c, IdNegozio__c from Case where IdNegozio__c=:idNegozio];
	}
}