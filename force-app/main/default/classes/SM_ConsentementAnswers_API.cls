global class SM_ConsentementAnswers_API implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        if (methodName.equals('apiConsentementAnswers')) {
            apiConsentementAnswers(inputMap, outMap, options);
        }
        return false;
    }
    
     public static void apiConsentementAnswers(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        String idPersonne =  String.valueOf(inputMap.get('idPersonne'));
           System.debug('*** idPersonne : ' + idPersonne);
            getConsentementAnswersData(idPersonne);
        }
    
    @AuraEnabled(cacheable=false)
    public static Map < String, Object > getConsentementAnswersData(String idPersonne) {
        Map < String, Object > outMap = new Map < String, Object >();
        System.debug('*** idPersonne : ' + idPersonne);
        HttpResponse httpResponse = new HttpResponse();    
        
        String token;
        if(!Test.isRunningTest()){
            token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
        }else{
            token = 'test';
        }

        if (token == null) {
            system.debug('Token not found ...');
            return null;
        }
        
        httpResponse = getResponse(token, idPersonne);
        Map<String, Object> transformedData  = new Map<String, Object>();
        if(httpResponse!= null){
            Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
            List < Object > listConsentementAnswers = (List < Object > ) resultAsMap.get('_data');
            
            if (listConsentementAnswers.Size() == 0) {
                system.debug('No data to get the idPersonne ' + idPersonne);
                return null;
            }
            outMap.put('Result', listConsentementAnswers);
        }
        System.debug('*** outMap : ' + outMap);
        return outMap;
        
    }
    

    public static HttpResponse getResponse(String token, String idPersonne) {

        HttpRequest httpReq = buildHttpRequestHeaders(token, idPersonne);
        HttpResponse httpResp = sendData(httpReq);
        if (httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('##  error occured when sending data ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            return null;
        }
        return httpResp;
    }
    
    public static HttpRequest buildHttpRequestHeaders(String token, String idPersonne) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        String endpointURL = '';
        if (!Test.isRunningTest()) {
        	endpointURL = 'callout:AuthAPIHour' +'/api/apiset/0.1/consentements';
        }
        req.setEndpoint(endpointURL + '?idPersonne=' + idPersonne);
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
            system.debug('##  failed to send data ##');
            return null;
        }
        return res;
    }
    
    private static Boolean httpResponseFailureDetected(HttpResponse response) {
        return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));
    }

    @AuraEnabled(cacheable=false)
    public static Map < String, Object > updateConsentement (Map<String, Object> inputMap){
        Map<String, Object> output = new Map<String, Object>();
        Object idPersonne= inputMap.get('idpersonne');
        Object refClientIdBP= inputMap.get('idBusinessPartner');
        List<Object> listConsentement=(List<Object>) inputMap.get('consentementResult');  
        system.debug('@@listConsentement : '+listConsentement);
        /* recuperation de la liste des consentement à mettre a jour*/
        if(listConsentement!=null && listConsentement.size()>0){
            /* Recuperation des nouvelles valeurs depuis lOS*/
            // List<object> answersMap =(List<object>) input.get('answerModified');  
            // if(listConsentement!=null){
            String token;
            if (Test.isRunningTest()) {
                token = 'wadfkoa1234';
            } else {
                token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
            } 
            List<Object> listRetourAPIPostconsentement=new List<Object> ();
            for (Integer i = 0; i < listConsentement.size(); i++) {
                System.debug('@@ boucle for..... ');                            
                Map<Object,Object> ConsentementOS =(Map<Object,Object>) listConsentement[i];  
                if( ConsentementOS!=null ){
                    System.debug('@@ ConsentementOS not null OK ');                            
                    String consentKey=ConsentementOS.get('idQuestionnaire')+'_'+ConsentementOS.get('idQuestion');
                    String idConsentToUpdate = (String) ConsentementOS.get('id');

                    Boolean newConsent;
                    String tempNewConsent = (String) ConsentementOS.get('consentNew');
                    if(tempNewConsent != null && tempNewConsent.equals('true')) {
                        newConsent = true;
                    } else if(tempNewConsent != null && tempNewConsent.equals('false')) {
                        newConsent = false;
                    }
                    System.debug('@@ idConsentToUpdate-->'+idConsentToUpdate);                            
                    System.debug('@@ tempNewConsent-->'+tempNewConsent);                            
                    if(!String.isBlank(idConsentToUpdate) && !String.isBlank(tempNewConsent)){ 
                        System.debug('@@ update consentement reponse ');                            
                        Map<String,Object> ipInput = new Map<String,Object>();
                        System.debug('@@ idQuestion----> '+ConsentementOS.get('idQuestion')    );                          
                        ipInput.put('idQuestionnaire', ConsentementOS.get('idQuestionnaire'));
                        ipInput.put('idQuestion', ConsentementOS.get('idQuestion'));
                        ipInput.put('consent',newConsent);
                        ipInput.put('canal','Telephone');
                        ipInput.put('application','SMILE');
                        ipInput.put('idBusinessPartner',refClientIdBP);
                        ipInput.put('idPersonne',idPersonne);
                        System.debug(' @@ ipInput ' +ipInput);
                        System.debug('@@ ConsentementId' +idConsentToUpdate); 
                        /* le PUT a besoin de l'ID consentement dans le path, 
                        lIP vlocity ne semble pas pouvoir prendre un id path dynamique en entree de lIP
                        c'est pour cela que cette partie se fait en code*/   
                        System.debug('@@ ipInput ' + ipInput);                            
                        HttpResponse retour= buildHttpRequestHeadersPUT(token,ipInput, idConsentToUpdate);
                        System.debug('@@ retour '+retour);
                        listRetourAPIPostconsentement.add(retour);
                    } else if (String.isBlank(idConsentToUpdate)){
                        // on crée un nouvelle réponse
                        Map<String,Object> mapInput=new Map<String,Object>();
                        mapInput.put('idBusinessPartner',refClientIdBP);
                        mapInput.put('idQuestionnaire', ConsentementOS.get('idQuestionnaire'));
                        mapInput.put('idQuestion', ConsentementOS.get('idQuestion'));
                        mapInput.put('consent',newConsent);  
                        mapInput.put('canal','Telephone');   
                        mapInput.put('application','SMILE'); 
                        System.debug('@@ mapInput for IP ' +mapInput);                                        
                        Map<String, Object> ipOutput = (Map<String,Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService('IP_ConsentementsSubmitAnswer_API', mapInput, new Map<String,Object>());
                        System.debug('@@sendConsentement ipOutput : '+ipOutput); 
                        System.debug('@@sendConsentement info : '+ipOutput.get('info')); 
                        listRetourAPIPostconsentement.add(ipOutput);
                        
                    }
                }
            }
            // output.put('listRetourAPIPostconsentement',listRetourAPIPostconsentement);
            // System.debug('@@ output '+output);
        }
        System.debug('@@ output '+output);
        return output;
    }

    // public static HttpResponse buildHttpRequestHeadersPUT(String token,Map<String, Object> bodyRequest, String idAnswer) {
       
    //     HttpRequest req = new HttpRequest();
    //     req.setMethod('PUT');
    //     String endpointURL = '';       
    //     SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Consentements' limit 1];
    //     if(suffixs!=null){
    //         endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;
    //     }      
    //     System.debug('@@ endpointURL / idAnswer '+endpointURL + '/' + idAnswer);
    //     req.setEndpoint(endpointURL + '/' + idAnswer);
    //     req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
    //     req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);       
    //     req.setHeader('Authorization', 'Bearer ' + token);
    //     req.setHeader('Content-Type', 'application/json');
    //     req.setBody(JSON.serialize(bodyRequest));
    //     HttpResponse httpResp = sendData(req);
    //     System.debug('@@ httpResp '+httpResp);
    //     return httpResp ;
    // }
    public static HttpResponse buildHttpRequestHeadersPUT(String token,Map<String, Object> bodyRequest, String idAnswer) {
        
        HttpRequest req = new HttpRequest();
        req.setMethod('PUT');
        String endpointURL = '';       
        SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Consentements' limit 1];
        if(suffixs!=null){
            endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;
        }      
        System.debug('@@ endpointURL idAnswer '+endpointURL + '/' + idAnswer);
        req.setEndpoint(endpointURL + '/' + idAnswer);
        req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
        req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);       
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(bodyRequest));
        HttpResponse httpResp = sendData(req);
        return httpResp ;
    }
}