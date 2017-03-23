global class SG_WS_Paypal { 
	
	webservice static string VerificaRimborso (string idAccount){ //metodo per verificare il rimborso
		string risultato='';
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		SG_Endpoint_Web_Service__c mc = SG_Endpoint_Web_Service__c.getOrgDefaults();
		mc.Verifica_rimborso_paypal__c='';
		request.setEndpoint('mc.Verifica_rimborso_paypal__c');
		request.setMethod('GET');
		HttpResponse response = http.send(request);
		 if (response.getStatusCode() == 200) {
			Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			List<Object> rimborsi = (List<Object>) results.get('rimborsi');
			System.debug('Received the following orders:');
            for (Object esempio :  rimborsi) {
                System.debug(rimborsi);
			}	
			risultato='OK';
			}
		else
			risultato='KO';

		return risultato;
	}
	webservice static string RichiestaRimborso (string idAccount){ //metodo per richiedere il rimborso
		string risultato='';
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		SG_Endpoint_Web_Service__c mc = SG_Endpoint_Web_Service__c.getOrgDefaults();
		mc.Richiesta_rimborso_Paypal__c='';
		request.setEndpoint('mc.Richiesta_rimborso_Paypal__c');
		request.setMethod('GET');
		HttpResponse response = http.send(request);
		 if (response.getStatusCode() == 200) {
			Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			List<Object> rimborsi = (List<Object>) results.get('rimborsi');
			System.debug('Received the following orders:');
            for (Object esempio :  rimborsi) {
                System.debug(rimborsi);
			}	
			risultato='OK';
			}
		else
			risultato='KO';

		return risultato;
	}
	webservice static string AnnullamentoPagamento (string idAccount){ //metodo per annullare il pagamento
		string risultato='';
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		SG_Endpoint_Web_Service__c mc = SG_Endpoint_Web_Service__c.getOrgDefaults();
		mc.Annulla_pagamento_Paypal__c='';
		request.setEndpoint('mc.Annulla_pagamento_Paypal__c');
		request.setMethod('GET');
		HttpResponse response = http.send(request);
		 if (response.getStatusCode() == 200) {
			Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			List<Object> rimborsi = (List<Object>) results.get('rimborsi');
			System.debug('Received the following orders:');
            for (Object esempio :  rimborsi) {
                System.debug(rimborsi);
			}	
			risultato='OK';
			}
		else
			risultato='KO';

		return risultato;
	}
}