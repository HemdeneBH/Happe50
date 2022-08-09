global class SM_AP06_MandatsApiService implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        if (methodName.equals('callMandats')) {
            try {
                callMandats(inputMap, outMap, options);
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

    public static void callMandats(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        if (inputMap.get('IdBusinessPartner') == null || String.valueOf(inputMap.get('IdBusinessPartner')).length() == 0) {
            system.debug('id buisness partner not found ...');
            return;
        }
        //vérification taille
        //author MHA
        Integer size = String.valueOf(inputMap.get('IdBusinessPartner')).length();
        String idBP = String.valueOf(inputMap.get('IdBusinessPartner'));
        if(size <10){
            Integer difference = 10 -size;
            for(Integer i = 0; i<difference; i++ ){
                idBP = '0'+idBP;
            }
        }
        HttpResponse httpResponse = new HttpResponse();
        if(Test.isRunningTest()){
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SM_MocKTestMandat');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            // Set the mock callout mode
            Test.setMock(HttpCalloutMock.class, mock);
            httpResponse = getResponse(idBP);
        }else{
            httpResponse = getResponse((String)idBP);
        }

        System.debug('inputMap :IdBusinessPartner = '+ (String)idBP);
        if(httpResponse != null){
            Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
            List < Object > listeMandats = (List < Object > ) resultAsMap.get('_data');

            if (listeMandats.Size() == 0) {
                system.debug('No data to get the buisness partner ' + idBP);
                return;
            }
            // methode qui transform les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript
            Map<String, Object> transformedData =  transformDatatoOmniscript(listeMandats) ;

            outMap.put('data1', transformedData);
        }

}

    public class MandatsModel {
        public String idMandat;
        public String valueChb1;
        public String status;
        public String url;

        public MandatsModel(String idMandat, String valueChb1, String status, String url) {
            this.idMandat = idMandat;
            this.valueChb1 = valueChb1;
            this.status = status;
            this.url = url;
        }
    }

    public static  Map<String, Object> transformDatatoOmniscript(List < Object > apiData) {

        Map < String, Object > transformeDataStructure = new Map < String, Object > ();
        List < Object > listTemp = new List < Object > ();
        for (Object obj : apiData) {
            Map < String, Object > objectX = (Map < String, Object > ) obj;
            String idMandat = String.valueOf(objectX.get('id'));
            Map<String, Object> docInputMap = new Map<String, Object>{'idMandat' => idMandat};
            Map<String,Object>docOutputMap = new Map<String,Object>();
            SM_AP36_DocumentApiService.callMandats(docInputMap,docOutputMap,null);
            List<Object>docMap=  (List<Object>)docOutputMap.get('data1');
            System.debug('@docmap1'+docMap);
            String url= '';
            if(docMap != null){
                System.debug('@docMap: '+docMap);
                Map<String,Object> docMapValue1 = (Map<String,Object>)docMap[0];
                System.debug('@docMapValue1: '+docMapValue1);
                if(docMapValue1.get('url') != null){
                url = String.valueOf(docMapValue1.get('url'));
                }
                
            }
            /*listTemp.add(new MandatsModel(String.valueOf(objectX.get('id')), 'mandat ' + ((String) objectX.get('dateModification')).substring(0,10), (String) objectX.get('statut'), 'https://particuliers.engie.fr/'));*/
            String dateSign ='';
            if(objectX.get('dateSignature') != null){
                dateSign = ((String) objectX.get('dateSignature')).substring(0,10);
            }
            listTemp.add(new MandatsModel(String.valueOf(objectX.get('id')), 'mandat ' + dateSign, (String) objectX.get('statut'), url));

        }
        transformeDataStructure.put('resultdata1', listTemp);
        return transformeDataStructure ;


}


    public static String buildRequestParams(String idBuisnessPartner) {
        return '?idBusinessPartner=' + (String)idBuisnessPartner + '&sort=dateSignature,desc';
    }

    public static HttpResponse getResponse(String idBuisnessPartner) {

        String endpointParams = buildRequestParams(idBuisnessPartner);
        HttpResponse httpResp = CalloutManager.sendRequest('Mandats', endpointParams, 'GET', CalloutManager.Scope.READ,null,null);
        if (CalloutManager.httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('## [ mandats] error occured when sending data ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            return null;
        }

        return httpResp;
    }
    
    
    
    public static void sendDuplicata(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        
        String ContextId = '';
        String id_SAP = '';
        String IdBusinessPartner = '';
        String prenomContact = '';
        String nomContact = '';
        String civiliteContact = '';
        String emailContact = '';
        String adresseContact = '';
        
        String getUrlMandats = '';
        String urlsMandats = '';        
        
        String getDateMandats = '';
        String datesMandats = '';
        
        ContextId = String.valueOf(inputMap.get('ContextId')); 
        id_SAP = String.valueOf(inputMap.get('id_SAP'));
        IdBusinessPartner = String.valueOf(inputMap.get('IdBusinessPartner'));
        
          if(IdBusinessPartner != null && IdBusinessPartner.startsWith('0')){
            IdBusinessPartner = IdBusinessPartner.substring(IdBusinessPartner.length()-9, IdBusinessPartner.length());
        }
        system.debug('****** '+IdBusinessPartner);
        //********* ContactInfo
        Map < String, Object > ContactFields = (Map < String, Object > ) inputMap.get('ContactFields');
        
        if(inputMap.get('getUrlMandats') != null){
            getUrlMandats = String.valueOf(inputMap.get('getUrlMandats'));
        }
        
        //**********
        if(inputMap.get('getDateMandats') != null){
            getDateMandats = String.valueOf(inputMap.get('getDateMandats'));
        }
        prenomContact = String.valueOf(ContactFields.get('Prenom'));
        nomContact = String.valueOf(ContactFields.get('Nom'));
        civiliteContact = String.valueOf(ContactFields.get('Civilite'));
        emailContact = String.valueOf(ContactFields.get('Email'));
        adresseContact = String.valueOf(ContactFields.get('Adresse'));        
        // Date
        String dateValue = system.today().format();
        //urlsMandats
        if(getUrlMandats.length() > 0){
            urlsMandats = getUrlMandats.substring(1,getUrlMandats.length() - 1);
        }     
        // date Mandat
        if(getDateMandats.length() > 0){
            datesMandats = getDateMandats.substring(1,getDateMandats.length() - 1);
        }
      //  String[] datesMandatsList;
        String[] datesMandatsList = datesMandats.split(',');
        
        // ****** Mandat ****
        if(urlsMandats.length() > 0){
            Integer j = 0;
            String dateDuplicataMandatValue ='';
            String[] urlsMandatsList = urlsMandats.split(',');
        
            for(String urlsMandatsInput : urlsMandatsList){
                //
                if(datesMandatsList.get(j).length() > 10){
                dateDuplicataMandatValue = (datesMandatsList.get(j)).substring(datesMandatsList.get(j).length() -10, (datesMandatsList.get(j)).length());
                }
                else {
                    dateDuplicataMandatValue = '';
                }
                //
                Map < String, Object > inputIPMandat = new Map < String, Object >();
            
                inputIPMandat.put('idPersonne',IdBusinessPartner);
                inputIPMandat.put('idResponsable',id_SAP);
                inputIPMandat.put('urlArchifage',urlsMandatsInput);
                inputIPMandat.put('emailInput',emailContact);
                inputIPMandat.put('CiviliteValeur',civiliteContact);
                inputIPMandat.put('AdresseValeur',adresseContact);
                inputIPMandat.put('EmailValeur',emailContact);
                inputIPMandat.put('NomValeur',nomContact);
                inputIPMandat.put('PrenomValeur',prenomContact);
                inputIPMandat.put('RefValeur',IdBusinessPartner);
                inputIPMandat.put('DateValeur',dateValue);
                inputIPMandat.put('TypeValeur','Mandat');
                inputIPMandat.put('DateDuplicataValeur',dateDuplicataMandatValue);
                j++;
            
              if(!Test.isRunningTest()){              
                  system.debug('Start Run IP Mandat'); 
                vlocity_cmt.IntegrationProcedureService.runIntegrationService('IP_SM_Correspondance_WS', inputIPMandat, options);
                  system.debug('End Run IP Mandat'); 
             }                
            }
        }        
    }
}