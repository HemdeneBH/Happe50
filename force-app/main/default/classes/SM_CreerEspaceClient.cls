global class SM_CreerEspaceClient implements vlocity_cmt.VlocityOpenInterface{

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
        system.debug('## creerEpaceClient ENTRY');
        Map < String, Object > espaceClientCreationMap = new Map < String, Object >();
        Map < String, Object > contactInfos = (map<String,Object>)inputMap.get('ContactInfo');
        Object contactEmail;
        Contact contactToUpdate;
        if(contactInfos.get('email') == null || contactInfos.get('email') == ''){
            Map < String, Object > serviceGestion = (map<String,Object>)inputMap.get('ServicesGestion');
            system.debug('## serviceGestion :'+serviceGestion);
            contactEmail = serviceGestion.get('emailConnexion');
            system.debug('## mail '+contactEmail);
            system.debug('## mail2 '+ (String)contactEmail);
            contactToUpdate = new Contact();
            contactToUpdate.id = (String)inputMap.get('ContextId');
            contactToUpdate.Email = (String)contactEmail;
            contactToUpdate.Adresse_Mail_Principale__c = 'Adresse Mail 1';
        }else{
            contactEmail = contactInfos.get('email');
        }
       
        Object contactcivilite = contactInfos.get('civilite');
        //Object contactmobile = contactInfos.get('mobile');
        Object contactnom = contactInfos.get('nom');
        Object contactprenom = contactInfos.get('prenom');
        Object idbp = inputMap.get('refClientIdBP');
        String ibBpStr = (String)idbp;
        String IbpTruncate = ibBpStr.removeStart('0');
        espaceClientCreationMap.put('prenom',contactprenom);
        espaceClientCreationMap.put('nom',contactnom);
        espaceClientCreationMap.put('civilite',contactcivilite);
        espaceClientCreationMap.put('email',contactEmail);
        espaceClientCreationMap.put('numeroBP',IbpTruncate);
        string responseCreerEspaceClient = SM_AP72_EspaceClientService.creerEspaceClient(espaceClientCreationMap);
        system.debug('## Contactemail'+contactInfos.get('email'));
        if( (responseCreerEspaceClient == 'OK') && (contactInfos.get('email') == null || contactInfos.get('email') == '')) {
            system.debug('## Update launched');
            system.debug('## contactToUpdate '+contactToUpdate);
            update contactToUpdate;
        }
        outMap.put('creerEspaceClientResp',responseCreerEspaceClient);
        system.debug('## responseCreerEspaceClient '+responseCreerEspaceClient);
        
    }
}