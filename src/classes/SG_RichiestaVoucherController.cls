public class SG_RichiestaVoucherController {

   	public static Richiesta_voucher__c Richiesta;
   	
   	public SG_RichiestaVoucherController() {
      	Richiesta = [select r.Valore__c, r.Valido_per_gli_store__c, r.Tipo_Voucher__c, r.Testo_promozione__c, r.Stato__c, r.Spedizione_gratuita__c, r.Sconto__c, r.Restrizioni__c, 
    					r.RecordTypeId, r.Priorit__c, r.OwnerId, r.Numero_totale_utilizzi__c, r.Numero_massimo_utilizzi_per_utente__c, r.Numero_Voucher_da_generare__c, 
    					r.Name, r.Id, r.Descrizione__c, r.Currency__c, r.Codice_promozione__c 
    					From Richiesta_Voucher__c r where r.id=:ApexPages.currentPage().getParameters().get('ID')];
   	}

  
     
   	public PageReference  RichiestaVoucher(){
   		/*prendo il nome del recordtype */
   		string RT = [select id, DeveloperName from recordtype where id= :Richiesta.RecordTypeId].DeveloperName;
   			
   		//id NewRT = [select id, DeveloperName from recordtype where DeveloperName = :RT + '_chiuso'].id;
   		/*se lo stato della richiesta è NUOVO o ERRORE procedo con la richiesta*/
   		if(Richiesta.stato__c == 'N' || Richiesta.stato__c == 'E'){
	   		Richiesta.stato__c = 'I'; //modifico lo stato in IN ELABORAZIONE
	   		update Richiesta;
	   		/*chiamo il WS per mandare la richiesta e agganciare al record la lista di vouchers*/
	    	string result = SG_WS_Voucher.RichiestaVoucher(Richiesta);
	    	/*se la risposta è OK cambio lo stato in CHIUSO e il RT in _Chiuso in modo tale che il layout nos possa essere più modificato*/
	    	if(result == 'OK'){
		    	Richiesta.stato__c 		= 'C';
		    	richiesta.RecordTypeId	= [select id, DeveloperName from recordtype where DeveloperName = :RT + '_chiuso'].id;
	    	}
		    else
		    	Richiesta.stato__c = 'E';
		    	
		    update Richiesta;
   		}
   		//ritorno al dettaglio della pagina
	    PageReference VoucherDetail = new PageReference('/' + ApexPages.currentPage().getParameters().get('ID'));
	    return VoucherDetail;

   	}
    
}