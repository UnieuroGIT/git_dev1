global class SG_WS_Tracking { 
	
	webservice static string RichiestaTracking (string idAccount){ //metodo per richiedere il tracking della spedizione a QHD
		string risultato='';
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		SG_Endpoint_Web_Service__c mc = SG_Endpoint_Web_Service__c.getOrgDefaults();
		mc.Tracking_spedizione__c='';
		request.setEndpoint('mc.Tracking_spedizione__c');
		request.setMethod('GET');
		HttpResponse response = http.send(request);
		 if (response.getStatusCode() == 200) {
			Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			List<Object> track = (List<Object>) results.get('track');
			System.debug('Received the following orders:');
            for (Object esempio :  track) {
                System.debug(track);
			}	
			risultato='OK';
			}
		else
			risultato='KO';

		return risultato;
	}
}