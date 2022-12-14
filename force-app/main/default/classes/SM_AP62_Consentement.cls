global class  SM_AP62_Consentement implements vlocity_cmt.VlocityOpenInterface {
    
    
    /************************************************************
*@author Ramata WATH
*@date Mars 2019
*@description Regroupe les appels a l'API creation/consentement creation
*@version 1
*************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options)
    {
        if (methodName == 'sendConsentement')
        {
            sendConsentement(input, output);
        }   
        else if(methodName == 'updateConsentement'){
            updateConsentement (input,output);
        }
        return true;
    }
    
    public Void sendConsentement (Map<String, Object> input, Map<String, Object> output){
        Map < String, Object > retourWS=(Map < String, Object >) input.get('CreerCorrespondance');
        if(retourWS!=null){
            String idPersonne= (String) retourWS.get('idPersonne');      
            system.debug('@@ idBP venant detre cree : '+input);
            List<object> answersMap =(List<object>) input.get('answerModified');           
            
            if(answersMap!=null){
                List<Object> listRetourAPIPostconsentement=new List<Object> ();
                for (Integer i = 0; i < answersMap.size(); i++) {
                    Map<String,Object> Consentement =(Map<String,Object>) answersMap[i];
                    system.debug('@@consent map : '+Consentement.get('idQuestion'));
                    if(Consentement!=null){
                        System.debug('@@ consentement '+Consentement);
                        System.debug('@@ idQuestionnaire '+Consentement.get('idQuestionnaire'));
                        Map<String,Object> mapInput=new Map<String,Object>();
                        mapInput.put('idBusinessPartner',idPersonne);
                        mapInput.put('idQuestionnaire',Consentement.get('idQuestionnaire'));   
                        mapInput.put('idQuestion',Consentement.get('idQuestion')); 
                        mapInput.put('consent',Consentement.get('consent'));  
                        mapInput.put('canal','Telephone');   
                        mapInput.put('application','SMILE'); 
                        System.debug('@@ mapInput for IP ' +mapInput);                                        
                        Map<String, Object> ipOutput = (Map<String,Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService('IP_ConsentementsSubmitAnswer_API', mapInput, new Map<String,Object>());
                        System.debug('@@sendConsentement ipOutput : '+ipOutput); 
                        listRetourAPIPostconsentement.add(ipOutput)  ;                    
                    } 
                }
                output.put('listRetourAPIPostconsentement',listRetourAPIPostconsentement);
                System.debug('@@listRetourAPIPostconsentement : '+listRetourAPIPostconsentement); 
            }
        }
        
        
    }       
    
    
    public Void updateConsentement (Map<String, Object> input, Map<String, Object> output){
        Object idPersonne= input.get('refIdpersonne');
        Object refClientIdBP= input.get('refClientIdBP');
        List<Object> listConsentement=(List<Object>) input.get('consentementResult');  
        system.debug('@@listConsentement : '+listConsentement);
        /* recuperation de la liste des consentement ?? mettre a jour*/
        Map<String,String> mapConsentementByQuestion=new Map<String,String>();
        Map<String,Boolean> mapConsentById=new Map<String,Boolean>();               
        
        if(listConsentement!=null && listConsentement.size()>0){
            for(Object cons : listConsentement){
                Map < String, Object > consentement = (Map < String, Object > ) cons;
                system.debug('@@ consentement ' +consentement);
                String idConsentement = (String) consentement.get('id');
                String idQuestionnaire = String.ValueOf(consentement.get('idQuestionnaire'));
                String idQuestion = String.ValueOf(consentement.get('idQuestion'));
                Boolean consent = (Boolean) consentement.get('consent');
                String keyMap=idQuestionnaire+'_'+idQuestion;
                mapConsentementByQuestion.put(keyMap,idConsentement);
                mapConsentById.put(idConsentement,consent);
                
            }
        }
        /* Recuperation des nouvelles valeurs depuis lOS*/
        List<object> answersMap =(List<object>) input.get('answerModified');
        System.debug(' @@ answersMap ' +answersMap);
        if(answersMap!=null){
            String token;
            if (Test.isRunningTest()) {
                token = 'wadfkoa1234';
            } else {
                token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
            } 
            List<Object> listRetourAPIPostconsentement=new List<Object> ();
            for (Integer i = 0; i < answersMap.size(); i++) {
                Map<String,Object> ConsentementOS =(Map<String,Object>) answersMap[i];  
                if(ConsentementOS!=null){
                    String consentKey=ConsentementOS.get('idQuestionnaire')+'_'+ConsentementOS.get('idQuestion');
                    String idConsentToUpdate=mapConsentementByQuestion.get(consentKey);
                    Boolean existingConsent=mapConsentById.get(idConsentToUpdate);
                    Boolean newConsent= (Boolean) ConsentementOS.get('consent');
                    
                    /* if(!String.isBlank(idConsentToUpdate)) veut dire qu'on a retrouv?? 
                    le consentement modifie par lOS dans la base XDATA*/ 
                    System.debug('@@@@idConsentToUpdate='+idConsentToUpdate);
                    if(!String.isBlank(idConsentToUpdate) && newConsent != existingConsent){                                 
                        Map<String,Object> ipInput = new Map<String,Object>();                                 
                        ipInput.put('idQuestionnaire',(Integer) ConsentementOS.get('idQuestionnaire'));
                        ipInput.put('idQuestion',(Integer) ConsentementOS.get('idQuestion'));
                        ipInput.put('consent',(Boolean) ConsentementOS.get('consent'));
                        ipInput.put('canal','Telephone');
                        ipInput.put('application','SMILE');
                        ipInput.put('idBusinessPartner',refClientIdBP);
                        ipInput.put('idPersonne',idPersonne);
                        System.debug(' @@ ipInput ' +ipInput);
                        System.debug('@@ ConsentementId' +idConsentToUpdate); 
                        /* le PUT a besoin de l'ID consentement dans le path, 
                        lIP vlocity ne semble pas pouvoir prendre un id path dynamique en entree de lIP
                        c'est pour cela que cette partie se fait en code*/                                                                                             
                        HttpResponse retour= buildHttpRequestHeadersPUT(token,ipInput, idConsentToUpdate);
                        //System.debug('@@ retour '+retour);
                        listRetourAPIPostconsentement.add(retour);
                    } else if (String.isBlank(idConsentToUpdate)){
                        // on cr??e un nouvelle r??ponse
                        Map<String,Object> mapInput=new Map<String,Object>();
                        mapInput.put('idBusinessPartner',refClientIdBP);
                        mapInput.put('idQuestionnaire',ConsentementOS.get('idQuestionnaire'));   
                        mapInput.put('idQuestion',ConsentementOS.get('idQuestion')); 
                        mapInput.put('consent',ConsentementOS.get('consent'));  
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
            output.put('listRetourAPIPostconsentement',listRetourAPIPostconsentement);
            System.debug('@@ output '+output);
        }
        
        
    }
    
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
    
    public static HttpResponse sendData(HttpRequest request) {
        Http http = new Http();
        HttpResponse res;
        try {
            res = http.send(request);
            
        } catch (Exception e) {
            system.debug('@@ [consenstement] failed to send data ##');
            return null;
        }
        return res;
        
    }
    
    
}