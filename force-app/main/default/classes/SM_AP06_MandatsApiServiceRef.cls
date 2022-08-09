global with sharing class SM_AP06_MandatsApiServiceRef implements vlocity_cmt.VlocityOpenInterface  {

    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        if (methodName.equals('callMandats')) {
            try {
                
                //outMap.put('dataMandat', JSON.deserializeUntyped(mandatList));

                callMandats(inputMap, outMap, options);
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

            outMap.putAll(transformedData);
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
            listTemp.add(new ListWrapper(String.valueOf(objectX.get('id')), dateSign, (String) objectX.get('statut'), url));

        }
        transformeDataStructure.put('dataMandat', listTemp);
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

}