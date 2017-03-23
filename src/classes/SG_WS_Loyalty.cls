global class SG_WS_Loyalty {
	
     webservice static void CustomerPoint(id loyaltyID, string reqType, string card, string isPromoEnabled, string termId,string respType ) {

		Http http 				= new Http();
		HttpRequest request 	= new HttpRequest();
		string ValueEndpoint 	= '';
		loyalty__c loyalty 		= new loyalty__c(id=loyaltyID);
		//List<Object> response 	= new List<Object>();
		
		
		if(string.isnotBlank(reqType) && string.isnotBlank(card)){
			ValueEndpoint 	= 	'https://____:__/____/pss.cfn.modules.webrequests.WebRequestsServlet?';
			ValueEndpoint 	+= 	'reqType=' 			+ reqType;
			ValueEndpoint 	+=	'&card=' 			+ card;
		
			if(string.isnotBlank(respType))
				ValueEndpoint 	+=	'&respType='		+ respType;
				
			if(string.isnotBlank(isPromoEnabled))	
				ValueEndpoint 	+=	'&isPromoEnabled=' 	+ isPromoEnabled;
				
			if(string.isnotBlank(termId) && isPromoEnabled=='Y')		
				ValueEndpoint 	+=	'&termId=' 			+ termId;
				
			System.debug('ValueEndpoint ' + ValueEndpoint);
			request.setEndpoint(ValueEndpoint);
			request.setMethod('GET');
			HttpResponse Http_resp = http.send(request);
			loyalty.Risposta_JSON__c = Http_resp.getBody();
			
			update loyalty;
			/*string respexample=		'{	"response": ';
			respexample +=				'{';
			respexample +=				'"errorCode": "OK",';
			respexample +=				'"nbrPoints": 67,';
			respexample +=				'"firstName": "MARKO",';
			respexample +=				'"lastName": "KAROVIC",';
			respexample +=				'"cardStatus": "A",';
			respexample +=				'"birthDate": "1985-09-30",';
			respexample +=				'"fidLevels":[';
			respexample +=					'1,';
			respexample +=					'2';
			respexample +=					']';
			respexample +=				'}';
			respexample +=			'}';*/
			
			
			// If the request is successful, parse the JSON response.
			if (Http_resp.getStatusCode() == 200) {
				// Deserialize the JSON string into collections of primitive data types.
				Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(Http_resp.getBody());
			  
				// Cast the values in the 'response' key as a list
				Map<String, Object> response 	= (Map<String, Object>) results.get('response');
				
				List<Object> errorCode 	= (List<Object>) response.get('errorCode');
				List<Object> nbrPoints 	= (List<Object>) response.get('nbrPoints');
				List<Object> firstName 	= (List<Object>) response.get('firstName');
				List<Object> lastName 	= (List<Object>) response.get('lastName');
				List<Object> cardStatus = (List<Object>) response.get('cardStatus');
				List<Object> birthDate 	= (List<Object>) response.get('birthDate');
				Map<String, Object> fidLevels 	= (Map<String, Object>) response.get('fidLevels');
				List<Object> fidLevelsChild 	= (List<Object>) fidLevels.get('fidLevels');
				
				System.debug('response ' + response);
				
				// MSozzi: scrivo la errorlog se error code non e' vuoto
				if(String.isNotBlank((String) errorCode[0]) && !((String) errorCode[0]).equalsIgnoreCase('OK'))
					SG_Mas_Utility.WriteErrorLog(loyaltyID, (String) errorCode[0], 'TestDescription');

				/*for (Object r : response) {
					System.debug(r);
				}*/
			}
			else {
				System.debug('Http_resp.getStatusCode() ' +Http_resp.getStatusCode());
			}
		}
	}
}