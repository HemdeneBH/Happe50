/*author: MHA
*description: recherhce des informations de la zone de distribution
*CreatedDate: 14/12/2018
*LastModified MHA 14/12/2018
*/
global class SM_AP44_ZoneDistributionApiService implements vlocity_cmt.VlocityOpenInterface {
    /*author: MHA
    *description: recherhce des informations de la zone de distribution
    *CreatedDate: 14/12/2018
    *LastModified MHA 14/12/2018
    */
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        if (methodName.equals('callZoneDistribitionByCodeInsee')) {
            try {
                callZoneDistribitionByCodeInsee(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug(e);
                return false;
            }
        }
        return true;
    }
    /*author: MHA
    *description: appel de l'API zone de distribution avec le code INSEE en tant que paramètre d'entrée
    *CreatedDate: 14/12/2018
    *LastModified MHA 14/12/2018
    */
    public static void callZoneDistribitionByCodeInsee(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        Map<String, String> listParameters = new Map<String, String>();
        String codeINSEE;
        String postcode;
        if (inputMap.get('codeINSEE') == null) {
            system.debug('codeINSEE not found ...');
            return;
        } else {
            codeINSEE = String.valueOf(inputMap.get('codeINSEE'));
            listParameters.put('codeInsee', codeINSEE);
        }

        if (inputMap.get('postcode') == null) {
            system.debug('postcode not found ...');
            return;
        } else {
            postcode = String.valueOf(inputMap.get('postcode'));
            listParameters.put('postcode', postcode);
        }

        String token;
        if (!Test.isRunningTest()) {
            token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
        } else {
            token = 'test';
        }

        if (token == null) {
            system.debug('Token not found ...');
            return;
        }

        HttpResponse httpResponse = new HttpResponse();
        httpResponse = getResponse(token, listParameters);
        if (httpResponse != null) {
            Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
            List < Object > listResult = (List < Object > ) resultAsMap.get('_data');

            if (listResult.Size() == 0) {
                system.debug('No data to get the codeINSEE ' + listResult);
                return;
            }
            // methode qui transform les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript
            transformToOutPut(listResult, outMap);
            System.debug('*** output : ' + outMap);
        }

    }

    /*author: MHA
    *description: model de pour l'api zone de  distribution
    *CreatedDate: 14/12/2018
    *LastModified MHA 14/12/2018
    */
    public static void transformToOutPut (List < Object > apiData, Map < String, Object > outMap) {
        /*Map<String, Object > listTemp = new  Map<String, Object > ();*/
        for (Object obj : apiData) {
            Map < String, Object > objectX = (Map < String, Object > ) obj;
            String appartientRegie = String.valueOf(objectX.get('appartientRegie'));
            String libelleTypeEnergie = String.valueOf(objectX.get('libelleTypeEnergie'));
            if (libelleTypeEnergie == 'elec') {
                outMap.put('elec', new zoneDistributionModel(appartientRegie, libelleTypeEnergie));
            } else if (libelleTypeEnergie == 'gaz') {
                outMap.put('gaz', new zoneDistributionModel(appartientRegie, libelleTypeEnergie));
            }
        }
    }

    /*author: MHA
    *description: model de pour l'api zone de  distribution
    *CreatedDate: 14/12/2018
    *LastModified MHA 14/12/2018
    */
    public class zoneDistributionModel {
        public String appartientRegie;
        public String libelleTypeEnergie;
        public zoneDistributionModel(String appartientRegie, String libelleTypeEnergie) {
            this.appartientRegie = appartientRegie;
            this.libelleTypeEnergie = libelleTypeEnergie;
        }
    }

    /*author: MHA
    *description: construction du header
    *CreatedDate: 14/12/2018
    *LastModified MHA 14/12/2018
    */
    public static HttpRequest buildHttpRequestHeaders(String token, Map<String, String> listParameters) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(buildEndPoint(listParameters));
        req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
        if (!Test.isRunningTest()) {
            req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
        }
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Content-Type', 'application/json');
        return req;
    }
    /*author:  HEL
    *description: Contruction du endPoint
    *CreatedDate: 14/12/2018
    *LastModified MHA 21/02/2019
    */
    public static String buildEndPoint(Map<String, String> listParameters) {
        String endPoint = '';
        if (!Test.isRunningTest()) {
            SM_WS_Suffix__mdt suffixes = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Zones_Distribution' limit 1];
            endPoint = 'callout:AuthAPIHour' + suffixes.suffix__c;
            System.debug('@@ request URL is ' + endPoint);
        }

        if (listParameters.size() > 0) {
            endPoint = endPoint + '?';
            Set<String> queryParamsKeys = listParameters.keySet();
            for (String key : queryParamsKeys) {
                endPoint = endPoint + key + '=' + listParameters.get(key) + '&';
            }
            endPoint = endPoint.substring(0, endPoint.length() - 1);

        }
        system.debug('[buildEndPoint]' + endPoint);
        return endPoint;
    }

    /*author: MHA
    *description: appel Http
    *CreatedDate: 14/12/2018
    *LastModified MHA 14/12/2018
    */
    public static HttpResponse sendData(HttpRequest request) {
        Http http = new Http();
        HttpResponse res;
        try {
            if (!Test.isRunningTest()) {
                res = http.send(request);
            } else {
                StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
                mock.setStaticResource('SM_MockTestZoneDistributeur');
                mock.setStatusCode(200);
                mock.setHeader('Content-Type', 'application/json');
                // Set the mock callout mode
                system.debug('sendData mock : ' + mock);
                Test.setMock(HttpCalloutMock.class, mock);
                res = http.send(request);
                System.debug('res' + res);
            }
        } catch (Exception e) {
            system.debug('## [zone distributeur] failed to send data ##');
            return null;
        }
        return res;

    }

    /*author: MHA
    *description: retour de l'échec de l'appel
    *CreatedDate: 14/12/2018
    *LastModified MHA 14/12/2018
    */
    private static Boolean httpResponseFailureDetected(HttpResponse response) {
        return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));

    }

    /*author: MHA
    *description: contruction de l'appel du webService
    *CreatedDate: 14/12/2018
    *LastModified MHA 14/12/2018
    */
    public static HttpResponse getResponse(String token, Map<String, String> listParameters) {


        HttpRequest httpReq = buildHttpRequestHeaders(token, listParameters);
        HttpResponse httpResp = sendData(httpReq);
        if (httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('## [ zone de distribution] error occured when sending data ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            return null;
        }

        return httpResp;

    }
}