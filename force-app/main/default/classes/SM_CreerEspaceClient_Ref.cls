global class SM_CreerEspaceClient_Ref implements vlocity_cmt.VlocityOpenInterface{

    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

	  try {
			    creerEpaceClient(inputMap, outMap, options);
			} catch (Exception e) {
				system.debug(e);
				return false;
		}
		
		return true;
	}
    
    global static void creerEpaceClient(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options){
        Map < String, Object > espaceClientCreationMap = new Map < String, Object >();
        Object contactEmail;
        Contact contactToUpdate;
        contactToUpdate = new Contact();
        if(!String.isBlank(String.valueOf(inputMap.get('emailConnexion')))){
            contactEmail = inputMap.get('emailConnexion');
            contactToUpdate.id = (String)inputMap.get('ContextId');
            contactToUpdate.Email = (String)contactEmail;
            contactToUpdate.Adresse_Mail_Principale__c = 'Adresse Mail 1';
        }else{
            contactEmail = inputMap.get('email');
            // to update the primary email
            contactToUpdate.id = (String)inputMap.get('ContextId');
            contactToUpdate.Email = (String)contactEmail;
            contactToUpdate.Adresse_Mail_Principale__c = (String)inputMap.get('principalemail');
            System.debug('### emailPrincipale '+contactToUpdate.Adresse_Mail_Principale__c);
        }
        System.debug('### aka contactEmail ' + contactEmail);
        Object contactcivilite = inputMap.get('civilite');
        Object contactnom = inputMap.get('nom');
        Object contactprenom = inputMap.get('prenom');
        Object idbp = inputMap.get('refClientIdBP');
        String ibBpStr = (String)idbp;
        String IbpTruncate = ibBpStr.removeStart('0');
        espaceClientCreationMap.put('prenom',contactprenom);
        espaceClientCreationMap.put('nom',contactnom);
        espaceClientCreationMap.put('civilite',contactcivilite);
        espaceClientCreationMap.put('email',contactEmail);
        espaceClientCreationMap.put('numeroBP',IbpTruncate);
        string responseCreerEspaceClient = SM_AP72_EspaceClientService.creerEspaceClient(espaceClientCreationMap);
        
        if( responseCreerEspaceClient != 'OK' ) {
            
            SM_AP61_PersonneOctopus.majEmailPreferePersonne(IbpTruncate,(String)contactEmail,contactToUpdate.Adresse_Mail_Principale__c);
           //update contactToUpdate;
        }
        update contactToUpdate;
        outMap.put('creerEspaceClientResp',responseCreerEspaceClient);
        system.debug('## responseCreerEspaceClient '+responseCreerEspaceClient);
        
    }
}