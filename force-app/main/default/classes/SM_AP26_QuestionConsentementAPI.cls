global class SM_AP26_QuestionConsentementAPI implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        if (methodName.equals('callQuestionConsentement')) {
            try {
                callQuestionConsentement(inputMap, outMap, options);
                // your implementation, use outMap to send response back to OmniScript
            } catch (Exception e) {
                system.debug(e);
                return false;
            }
        }

        return true;
    }

    public static void callQuestionConsentement(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        /*if (inputMap.get('IdBuisnessPartner') == null || String.valueOf(inputMap.get('IdBuisnessPartner')).length() == 0) {
            system.debug('idBusinessPartner is not found ...');
            return;
        }*/

        String token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
        if (token == null) {
            system.debug('Token not found ...');
            return;
        }
        HttpResponse httpResponse = getResponse(token);

        Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
        List < Object > clientAccounts = (List < Object > ) resultAsMap.get('_data');

        if (clientAccounts.Size() == 0) {
            system.debug('No data to get the idBusinessPartner ' + inputMap.get('IdBuisnessPartner'));
            return;
        }
        // methode qui transform les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript
        Map<String, Object> transformedData =  transformDatatoOmniscript(clientAccounts) ;

        outMap.put('questions', transformedData);
    }

    public class QuestionConsentementModel {
        public String id;
        public String idQuestion;
        public String codeQuestion;
        public String libelleQuestion;
        public String detailQuestion;
        /*public String url;*/

        public QuestionConsentementModel(String id, String idQuestion, String codeQuestion, String libelleQuestion, String detailQuestion) {
            this.id = id;
            this.idQuestion = idQuestion;
            this.codeQuestion = codeQuestion;
            this.libelleQuestion = libelleQuestion;
            this.detailQuestion = detailQuestion;
        }


    }

    public static  Map<String, Object> transformDatatoOmniscript(List < Object > apiData) {

        Map < String, Object > transformeDataStructure = new Map < String, Object > ();
        List < Object > listTemp = new List < Object > ();
        QuestionConsentementModel question;
        Integer i = 1;
        for (Object obj : apiData) {
            Map < String, Object > objectX = (Map < String, Object > ) obj;
            question = new QuestionConsentementModel(String.valueOf(objectX.get('id')), String.valueOf(objectX.get('idQuestionnaire')), String.valueOf(objectX.get('codeQuestionnaireQuestion')), String.valueOf(objectX.get('libelleQuestion')), String.valueOf(objectX.get('detailQuestion')));
            transformeDataStructure.put('question'+i, question);
            i++;
        }
        return transformeDataStructure ;
    }

    public static HttpRequest buildHttpRequestHeaders(String token) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        String endpointURL = '';
        
        SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Questions_Consentement' limit 1];
        endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;
        
        req.setEndpoint(endpointURL);
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
            system.debug('## [question] failed to send data ##');
            return null;
        }
        return res;

    }

    private static Boolean httpResponseFailureDetected(HttpResponse response) {
        return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));

    }

    public static HttpResponse getResponse(String token) {


        HttpRequest httpReq = buildHttpRequestHeaders(token);
        HttpResponse httpResp = sendData(httpReq);
        if (httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('## [ question] error occured when sending data ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            return null;
        }

        return httpResp;

    }
}