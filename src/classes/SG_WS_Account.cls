global class SG_WS_Account { 
	
	webservice static string CreazioneCliente (string idAccount){ //creazione cliente su Hybris e creazione immediata su SF
		string risultato='';
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		SG_Endpoint_Web_Service__c mc = SG_Endpoint_Web_Service__c.getOrgDefaults();
		mc.Creazione_cliente_hybris__c='';
		request.setEndpoint('mc.Creazione_cliente_hybris__c');
		request.setMethod('GET');
		HttpResponse response = http.send(request);
		 if (response.getStatusCode() == 200) {
			Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			List<Object> clienti = (List<Object>) results.get('clienti');
			System.debug('Received the following orders:');
            for (Object esempio :  clienti) {
                System.debug(clienti);
			}	
			risultato='OK';
			}
		else
			risultato='KO';

		return risultato;
	}
}