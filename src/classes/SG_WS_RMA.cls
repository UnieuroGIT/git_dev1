global class SG_WS_RMA { 
	
	webservice static string RichiestaOrdini (string CodRMA){ //metodo per creare su Strike RMA
		string risultato='';
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		SG_Endpoint_Web_Service__c mc = SG_Endpoint_Web_Service__c.getOrgDefaults();
		mc.Creazione_RMA_strike__c='';
		request.setEndpoint('mc.Creazione_RMA_strike__c');
		request.setMethod('GET');
		HttpResponse response = http.send(request);
		 if (response.getStatusCode() == 200) {
			Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			List<Object> RMA = (List<Object>) results.get('RMA');
			System.debug('Received the following RMA:');
           // for (Object esempio : RMA) {
           //    System.debug(RMA);
			//}	
			risultato='OK';
			}
		else
			risultato='KO';

		return risultato;
	}
}