global class SG_WS_Prodotti { 
	
	webservice static string DisponibilitHybris (string ProdCode){ //metodo verifica disponibilit� prodotto su Hybris
		string risultato='';
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		SG_Endpoint_Web_Service__c mc = SG_Endpoint_Web_Service__c.getOrgDefaults();
		mc.Disponibilita_prodotti_hybris__c='';
		request.setEndpoint('mc.Disponibilita_prodotti_hybris__c');
		request.setMethod('GET');
		HttpResponse response = http.send(request);
		 if (response.getStatusCode() == 200) {
			Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			List<Object> prodotti = (List<Object>) results.get('prodotti');
			System.debug('Received the following orders:');
            for (Object esempio :  prodotti) {
                System.debug(prodotti);
			}	
			risultato='OK';
			}
		else
			risultato='KO';

		return risultato;
	}

	webservice static string DisponibilitStrike (string ProdCode){ //metodo verifica disponibilit� prodotto su Hybris
	string risultato='';
	Http http = new Http();
	HttpRequest request = new HttpRequest();
	SG_Endpoint_Web_Service__c mc = SG_Endpoint_Web_Service__c.getOrgDefaults();
	mc.Disponibilita_prodotti_strike__c='';
	request.setEndpoint('mc.Disponibilita_prodotti_strike__c');
	request.setMethod('GET');
	HttpResponse response = http.send(request);
		 if (response.getStatusCode() == 200) {
			Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			List<Object> prodotti = (List<Object>) results.get('prodotti');
			System.debug('Received the following orders:');
            for (Object esempio :  prodotti) {
                System.debug(prodotti);
			}	
			risultato='OK';
			}
		else
			risultato='KO';

		return risultato;
	}
}