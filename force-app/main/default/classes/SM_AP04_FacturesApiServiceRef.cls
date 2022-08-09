/**
 * @description       : 
 * @author            : AE
 * @group             : 
 * @last modified on  : 08-23-2021
 * @last modified by  : AE
**/
global with sharing class SM_AP04_FacturesApiServiceRef  implements vlocity_cmt.VlocityOpenInterface  {

    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        System.debug('*** inputMap in invoke : ' + inputMap);

        if (methodName.equals('callFacture')) {
            try {
                
                //outMap.put('dataFacture', JSON.deserializeUntyped(factureList));

                callFacture(inputMap, outMap, options);
                // your implementation, use outMap to send response back to OmniScript
            } catch (Exception e) {
                system.debug(e);
                return false;
            }
        }

        return true;

    }
    // AE FT2-1530 correction de la liste affiché de factures
	public static void callFacture(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        System.debug('*** inputMap : ' + inputMap);
        if (inputMap.get('IdBusinessPartner') == null || String.valueOf(inputMap.get('IdBusinessPartner')).length() == 0) {
            system.debug('id buisness partner not found ...');
            return;
        }
        // AE FT2-1530 ajout de l'IDPorteFeuilleContrat
        if (inputMap.get('IdPortefeuilleContrat') == null || String.valueOf(inputMap.get('IdPortefeuilleContrat')).length() == 0) {
            system.debug('IdPortefeuilleContrat not found ...');
            return;
        }
        
        //vérification taille
        //author MHA
        Integer size = String.valueOf(inputMap.get('IdBusinessPartner')).length();
        String idBP = String.valueOf(inputMap.get('IdBusinessPartner'));
        String idPC = String.valueOf(inputMap.get('IdPortefeuilleContrat'));
        system.debug('IdBusinessPartner');
        system.debug(idBP);
        system.debug('IdPortefeuilleContrat');
        system.debug(idPC);
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
            httpResponse = getResponse(idBP,'');
        }else{
            httpResponse = getResponse((String)idBP, idPC);
        }
        if(httpResponse!= null){
            Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
            List < Object > listFacture = (List < Object > ) resultAsMap.get('_data');

            if (listFacture.Size() == 0) {
                system.debug('No data to get the buisness partner ' + idBP);
                //outMap.put(new Map<String, Object>());
                return;
            }
            // methode qui transform les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript
            Map<String, Object> transformedData =  transformDatatoOmniscript(listFacture) ;
            //outMap=new Map < String, Object >();
            outMap.putAll(transformedData);
            System.debug('*** output : ' + outMap);
        }
        //  system.debug('@@ outMap' +outMap);
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
            listTemp.add(new ListWrapper(idFacture, dateComptable , montant, url));
        }
        }
        transformeDataStructure.put('dataFacture', listTemp);
        return transformeDataStructure ;
    }

    public static HttpResponse getResponse(String idBuisnessPartner,string idPortefeuilleContrat) {

        String endpointParams = buildRequestParams(idBuisnessPartner,idPortefeuilleContrat);
        HttpResponse httpResp = CalloutManager.sendRequest('Factures', endpointParams, 'GET', CalloutManager.Scope.READ,null,null);
        if (CalloutManager.httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('## [ factures] error occured when sending data ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            httpResp = null;
        }
        return httpResp;
    }   

    public static String buildRequestParams(String idBuisnessPartner,String idPortefeuilleContrat) {
        String endpointParameters = '';
        if(!String.isBlank(idPortefeuilleContrat) ){
            endpointParameters += '?size=100&idBusinessPartner=' + idBuisnessPartner 
            +'&idPortefeuilleContrat='+idPortefeuilleContrat +'&sort=dateComptable,desc';
        }
        else{
            endpointParameters += '?size=100&idBusinessPartner=' + idBuisnessPartner 
            +'&sort=dateComptable,desc';
        }
        return endpointParameters;
    }
}