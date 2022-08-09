@isTest
global class SM_AP62_MockConsentement implements HttpCalloutMock {
	 
	
	global HTTPResponse respond(HTTPRequest req) {
		// Create a fake response
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody('{"example":"test"}');
		res.setStatusCode(200);
		return res;
	}
    
    @isTest
	public static List<Object> generateConsentementString() { 
		List<Object> listConsentement= new List<Object>();
		for (Integer i = 0; i < 2; i++) {
			Map<String, Object> consentement = new Map<String, Object>();
			consentement.put('consent', 'true');
			consentement.put('idQuestionnaire', 1);
			consentement.put('idQuestion', i);   
			consentement.put('questionLabel', 'Exemple de question');
			consentement.put('id', '147a5186-c7be-11e8-a6bf-020da0c82017');
			listConsentement.add(consentement);
		}
			// un consentement qui n'a pas d'identifiant
			Map<String, Object> newConsentement = new Map<String, Object>();
			newConsentement.put('consent', 'true');
			newConsentement.put('idQuestionnaire', 1);
			newConsentement.put('idQuestion', 2);   
			newConsentement.put('questionLabel', 'Exemple de question');
			newConsentement.put('id', '');
			listConsentement.add(newConsentement);

		return listConsentement;
	}
   
	@isTest
	public static List<Object> generateConsentement() { 
		List<Object> listConsentement= new List<Object>();
		for (Integer i = 0; i < 2; i++) {
			Map<String, Object> consentement = new Map<String, Object>();
			consentement.put('consent', true);
			consentement.put('idQuestionnaire', 1);
			consentement.put('idQuestion', i);   
			consentement.put('questionLabel', 'Exemple de question');
			consentement.put('id', '147a5186-c7be-11e8-a6bf-020da0c82017');
			listConsentement.add(consentement);
		}
			// un consentement qui n'a pas d'identifiant
			Map<String, Object> newConsentement = new Map<String, Object>();
			newConsentement.put('consent', true);
			newConsentement.put('idQuestionnaire', 1);
			newConsentement.put('idQuestion', 2);   
			newConsentement.put('questionLabel', 'Exemple de question');
			newConsentement.put('id', '');
			listConsentement.add(newConsentement);

		return listConsentement;
	}
	
	@isTest
	public static List<Object> generateConsentementfalse() { 
		List<Object> listConsentement=generateConsentement();
		List<Object> listConsentementfalse=new List<Object>();
		for(Object consentement : listConsentement){
			 Map<String, Object> cons =  (Map<String, Object>) consentement;
			 cons.put('consent', false);
			listConsentementfalse.add(cons);
		}
		 return listConsentementfalse;     
	}
	
}