global class SG_WS_Ordini { 

	webservice static string RichiestaOrdini (string CodCliente){ //metodo per richiedere gli ultimi ordini web ad Hybris
		string risultato='';
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		SG_Endpoint_Web_Service__c mc = SG_Endpoint_Web_Service__c.getOrgDefaults();
		mc.Richiesta_ultimi_ordini__c='';
		request.setEndpoint('mc.Richiesta_ultimi_ordini__c');
		request.setMethod('GET');
		HttpResponse response = http.send(request);
		 if (response.getStatusCode() == 200) {
			Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			List<Object> ordini = (List<Object>) results.get('ordini');
			System.debug('Received the following orders:');
            for (Object esempio : ordini) {
                System.debug(ordini);
			}	
			risultato='OK';
			}
		else
			risultato='KO';

		return risultato;
	}

	webservice static string AggiornamentoOrdini (string CodCliente){ //metodo per aggiornare gli ordini web ad Hybris
		string risultato='';
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		SG_Endpoint_Web_Service__c mc = SG_Endpoint_Web_Service__c.getOrgDefaults();
		mc.Aggiornamento_ordine__c='';
		request.setEndpoint('mc.Aggiornamento_ordine__c');
		request.setMethod('GET');
		HttpResponse response = http.send(request);
		 if (response.getStatusCode() == 200) {
			Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			List<Object> ordini = (List<Object>) results.get('ordini');
			System.debug('Received the following orders:');
            for (Object Order : ordini) {
                System.debug(ordini);
			}	
			risultato='OK';
		}
		else
			risultato='KO';	
		return risultato;
	}

}