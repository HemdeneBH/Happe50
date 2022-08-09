global class SM_AP04_FacturesApiService implements vlocity_cmt.VlocityOpenInterface  {

    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        System.debug('*** inputMap in invoke : ' + inputMap);
        if (methodName.equals('callFacture')) {
            try {
                callFacture(inputMap, outMap, options);
                // your implementation, use outMap to send response back to OmniScript
            } catch (Exception e) {
                system.debug(e);
                return false;
            }
        }
        
        if (methodName.equals('sendDuplicata')) {
            try {
                sendDuplicata(inputMap, outMap, options);
                // your implementation, use outMap to send response back to OmniScript
            } catch (Exception e) {
                system.debug(e);
                return false;
            }
        }

        return true;
    }
	
    // Le paramètre "excludeSomeBillsType" permet d'exclure les factures portant le code type contenu dans la variable "billTypeToExclude"
	@AuraEnabled(cacheable=false)
    public static Map < String, Object > callFactureLWC(Map < String, Object > inputMap) {
        Map < String, Object > outMap  = new Map<String, Object>();
        Map<String, Object> transformedData;
        // '05', '07', '08'
        List<String> billTypeToExclude = System.Label.SM_CL39_CodeTypeToExclude.split(',');
            
		System.debug('*** inputMap : ' + inputMap);
        if (inputMap.get('IdBusinessPartner') == null || String.valueOf(inputMap.get('IdBusinessPartner')).length() == 0) {
            system.debug('id buisness partner not found ...');
            return outMap;
        }
        if (inputMap.get('IdPortefeuilleContrat') == null || String.valueOf(inputMap.get('IdPortefeuilleContrat')).length() == 0) {
            system.debug('IdPortefeuilleContrat not found ...');
            return outMap;
        }
        String token;
        if(!Test.isRunningTest()){
            token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
        }else{
            token = 'test';
        }

        if (token == null) {
            system.debug('Token not found ...');
            return outMap;
        }

        //vérification taille
        //author MHA
        String idPC = String.valueOf(inputMap.get('IdPortefeuilleContrat'));
        Integer size = String.valueOf(inputMap.get('IdBusinessPartner')).length();
        String idBP = String.valueOf(inputMap.get('IdBusinessPartner'));
        if (size < 10) {
            Integer difference = 10 - size;
            for (Integer i = 0; i < difference; i++ ) {
                idBP = '0' + idBP;
            }
        }
        HttpResponse httpResponse = new HttpResponse();
        if(Test.isRunningTest()){
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SM_MockTestFacture');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            // Set the mock callout mode
            Test.setMock(HttpCalloutMock.class, mock);
            httpResponse = getResponse(token, idBP,idPC);
        }else{
            httpResponse = getResponse(token, (String)idBP,idPC);
        }
        if(httpResponse != null){
            Map < String, Object > resultAsMap = ( Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
            List < Object > listFacture = (List < Object > ) resultAsMap.get('_data');
	
            if (listFacture.Size() == 0) {
                system.debug('No data to get the buisness partner ' + idBP);
                return outMap;
            } else {
                // FT3-12...
                // Exclure certains type de factures pour l'historique de facturation
            	if (inputMap.get('excludeSomeBillsType') == true) {
                    Integer i = 0;
                    while (i < listFacture.size())
                    {
                        Map < String, Object > factMap = ( Map< String, Object > ) listFacture.get(i);
                        if(billTypeToExclude.contains( (String) factMap.get('codeTypeCalcul')) || String.isNotBlank((String)factMap.get('referenceAnnulation')))
                        {
                            listFacture.remove(i);
                        }else
                        {
                            i++;
                        }
                    }   
            	}
            }
            
            // methode qui transforme les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript
                                    
            outMap.put('data', listFacture);
            System.debug('*** output : ' + outMap);
        }
		return outMap;
        //  system.debug('@@ outMap' +outMap);
    }

	public static void callFacture(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        System.debug('*** inputMap : ' + inputMap);
        if (inputMap.get('IdBusinessPartner') == null || String.valueOf(inputMap.get('IdBusinessPartner')).length() == 0) {
            system.debug('id buisness partner not found ...');
            return;
        }
        String token;
        if(!Test.isRunningTest()){
            token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
        }else{
            token = 'test';
        }

        if (token == null) {
            system.debug('Token not found ...');
            return;
        }

        //vérification taille
        //author MHA
        Integer size = String.valueOf(inputMap.get('IdBusinessPartner')).length();
        String idBP = String.valueOf(inputMap.get('IdBusinessPartner'));
        if (size < 10) {
            Integer difference = 10 - size;
            for (Integer i = 0; i < difference; i++ ) {
                idBP = '0' + idBP;
            }
        }
        HttpResponse httpResponse = new HttpResponse();
        if(Test.isRunningTest()){
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SM_MockTestFacture');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            // Set the mock callout mode
            Test.setMock(HttpCalloutMock.class, mock);
            httpResponse = getResponse(token, idBP,'');
        }else{
            httpResponse = getResponse(token, (String)idBP,'' );
        }
        if(httpResponse!= null){
            Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
            List < Object > listFacture = (List < Object > ) resultAsMap.get('_data');

            if (listFacture.Size() == 0) {
                system.debug('No data to get the buisness partner ' + idBP);
                return;
            }
            // methode qui transform les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript
            Map<String, Object> transformedData =  transformDatatoOmniscript(listFacture) ;
            //outMap=new Map < String, Object >();
            outMap.put('data', transformedData);
            System.debug('*** output : ' + outMap);
        }
        //  system.debug('@@ outMap' +outMap);
    }

    public class FactureModel {
        public String idFacture;
        public String valueChb;
        public String url;
        public String montant;
       
        public FactureModel(String idFacture, String valueChb, String montant, String url) {
            this.idFacture = idFacture;
            this.valueChb = 'Facture du ' + valueChb;
            this.montant = '€' + montant;
            this.url = url;
        }
    }

    public static  Map<String, Object> transformDatatoOmniscript(List < Object > apiData) {

        Map < String, Object > transformeDataStructure = new Map < String, Object > ();
        List < Object > listTemp = new List < Object > ();
        for (Object obj : apiData) {
            Map < String, Object > objectX = (Map < String, Object > ) obj;
            String refAnnulation = String.valueOf(objectX.get('referenceAnnulation'));
            if(String.isBlank(refAnnulation)){
            String idFacture = String.valueOf(objectX.get('id'));
            String montant = String.valueOf(((Decimal) objectX.get('montantTotal')).format());
            String dateComptable = ((String) objectX.get('dateComptable')).substring(0, 10);
            dateComptable = dateComptable.substring(8, 10) + '/' + dateComptable.substring(5, 7) + '/' + dateComptable.substring(0, 4);
            Map<String,Object> docInputMap = new Map<String,Object>{'idFacture' => idFacture};
            Map<String,Object>docOutputMap = new Map<String,Object>();
            SM_AP36_DocumentApiService.callFacture(docInputMap,docOutputMap,null);
            List<Object>docMap = new List<Object>();
            if(Test.isRunningTest()){
                docMap.add(new Map<String,Object>{'url' => 'https://particuliers.engie.fr/'});
            }else{
                docMap=  (List<Object>)docOutputMap.get('data');
            }
            String url;
            if(docMap != null){

                System.debug('@docMap: '+docMap);
                Map<String,Object> docMapValue1 = (Map<String,Object>)docMap[0];
                System.debug('@docMapValue1: '+docMapValue1);
                url = String.valueOf(docMapValue1.get('url'));
            }
            /*listTemp.add(new FactureModel(idFacture, dateComptable , montant, 'https://particuliers.engie.fr/'));*/
            listTemp.add(new FactureModel(idFacture, dateComptable , montant, url));
        }
        }
        transformeDataStructure.put('resultdata', listTemp);
        return transformeDataStructure ;
    }


    public static HttpRequest buildHttpRequestHeaders(String token, String idBuisnessPartner,String idPortefeuilleContrat) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        String endpointURL = '';
        if (!Test.isRunningTest()) {
            SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Factures' limit 1];
            endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;
        }

        if(!String.isBlank(idPortefeuilleContrat) ){
            req.setEndpoint(endpointURL + '?size=100&idBusinessPartner=' + idBuisnessPartner 
            +'&idPortefeuilleContrat='+idPortefeuilleContrat +'&sort=dateComptable,desc');
        }
        else{
            req.setEndpoint(endpointURL + '?size=100&idBusinessPartner=' + idBuisnessPartner 
            +'&sort=dateComptable,desc');
        }
        req.setEndpoint(endpointURL + '?size=100&idBusinessPartner=' + idBuisnessPartner 
        +'&idPortefeuilleContrat='+idPortefeuilleContrat +'&sort=dateComptable,desc');
        req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
        req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Content-Type', 'application/json');
        return req;
    }

    public static HttpResponse sendData(HttpRequest request) {
        Http http = new Http();
        HttpResponse res;
        try {
            res = http.send(request);

        } catch (Exception e) {
            system.debug('## [Factures] failed to send data ##');
            return null;
        }
        return res;
    }

    private static Boolean httpResponseFailureDetected(HttpResponse response) {
        return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));
    }

    public static HttpResponse getResponse(String token, String idBuisnessPartner,string idPortefeuilleContrat) {

        HttpRequest httpReq = buildHttpRequestHeaders(token, idBuisnessPartner,idPortefeuilleContrat);
        HttpResponse httpResp = sendData(httpReq);
        if (httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('## [ factures] error occured when sending data ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            return null;
        }
        return httpResp;
    }    
    
    
   
    public static void sendDuplicata(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        
        Map < String, Object > outMapFacture = new Map < String, Object >();
        Map < String, Object > outMapMandat = new Map < String, Object >();
        
        String ContextId = '';
        String id_SAP = '';
        String IdBusinessPartner = '';
        String prenomContact = '';
        String nomContact = '';
        String civiliteContact = '';
        String emailContact = '';
        String adresseContact = '';
        
        String getUrlFactures = '';
        String urlsFactures = '';
        
        
        String getDateFactures = '';
        String datesFactures = '';

        ContextId = String.valueOf(inputMap.get('ContextId'));
        
        id_SAP = String.valueOf(inputMap.get('id_SAP'));
        
        IdBusinessPartner =String.valueOf(inputMap.get('IdBusinessPartner'));
        
        if(IdBusinessPartner != null && IdBusinessPartner.startsWith('0')){
            IdBusinessPartner = IdBusinessPartner.substring(IdBusinessPartner.length()-9, IdBusinessPartner.length());
        }
        system.debug('****** '+IdBusinessPartner);
        //********* ContactInfo
        Map < String, Object > ContactFields = (Map < String, Object > ) inputMap.get('ContactFields');
        
        if(inputMap.get('getUrlFactures') != null){
            getUrlFactures = String.valueOf(inputMap.get('getUrlFactures'));
        }

        //***** DateFactures
        if(inputMap.get('getDateFactures') != null){
            getDateFactures = String.valueOf(inputMap.get('getDateFactures'));
        }        

        prenomContact = String.valueOf(ContactFields.get('Prenom'));
        nomContact = String.valueOf(ContactFields.get('Nom'));
        civiliteContact = String.valueOf(ContactFields.get('Civilite'));
        emailContact = String.valueOf(ContactFields.get('Email'));
        adresseContact = String.valueOf(ContactFields.get('Adresse'));
        
        // Date
        String dateValue = system.today().format();

        if(getUrlFactures.length() > 0){
            urlsFactures = getUrlFactures.substring(1,getUrlFactures.length() - 1);
        }
        //date Facture
        if(getDateFactures.length() > 0){
            datesFactures = getDateFactures.substring(1,getDateFactures.length() - 1);
        }        
        String[] datesFacturesList = datesFactures.split(',');
        
        // ***** Factures ******
        if(urlsFactures.length() > 0){
            Integer i = 0;
            String dateDuplicataValue ='';
            String[] urlsFacturesList = urlsFactures.split(',');
            
            for(String urlsFacturesInput : urlsFacturesList){
                //
                if(datesFacturesList.get(i).length() > 10){
                dateDuplicataValue = (datesFacturesList.get(i)).substring(datesFacturesList.get(i).length() -10, (datesFacturesList.get(i)).length());
                }
                else {
                    dateDuplicataValue = '';
                }
                //

                Map < String, Object > inputIPFacture = new Map < String, Object >();
                inputIPFacture.put('idPersonne',IdBusinessPartner);
                inputIPFacture.put('idResponsable',id_SAP);
                inputIPFacture.put('urlArchifage',urlsFacturesInput);
                inputIPFacture.put('emailInput',emailContact);
                inputIPFacture.put('CiviliteValeur',civiliteContact);
                inputIPFacture.put('AdresseValeur',adresseContact);
                inputIPFacture.put('EmailValeur',emailContact);
                inputIPFacture.put('NomValeur',nomContact);
                inputIPFacture.put('PrenomValeur',prenomContact);
                inputIPFacture.put('RefValeur',IdBusinessPartner);
                inputIPFacture.put('DateValeur',dateValue);
                inputIPFacture.put('TypeValeur','Facture');
                inputIPFacture.put('DateDuplicataValeur',dateDuplicataValue);
                i++;
             
              if(!Test.isRunningTest()){
                  system.debug('Start Run IP '); 
                  vlocity_cmt.IntegrationProcedureService.runIntegrationService('IP_SM_Correspondance_WS', inputIPFacture, options);
                  system.debug('End Run IP');                  
             }                
            }
        }    
}    
}