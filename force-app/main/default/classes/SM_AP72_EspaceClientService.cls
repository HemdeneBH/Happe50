/* 
@Project : Smile
@Description : Cette classe permet de gérer l'espace client du client via l'api digital

*/

global class SM_AP72_EspaceClientService {
    
    @AuraEnabled(cacheable=false)
    public static String creerEspaceClient(Map < String, Object > espaceClientACreerMap){
        
        if(espaceClientACreerMap == null){
            System.debug('[SM_AP72_EspaceClientService] : espaceClientACreerMap null');
            throw new IOException('INVALID INPUT');
        }
        EspaceClientACreer espaceClient  = buildEspaceClientACreer(espaceClientACreerMap);
        
        
        
        String token = loadToken();
        
        Map<String,Object> espaceClientACreerBody = buildEspaceClientACreerRequestBody(espaceClient);
        
        HttpResponse response = getHttpResponse(token,'EspacesPrives',espaceClientACreerBody);
        system.debug('response = '+response);
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        
        String statutResponse = (String)resultAsMap.get('statut');
        if(!String.isBlank(statutResponse) && 'OK'.equals(statutResponse)){
            
            String numeroBP = espaceClient.numeroBP.leftPad(10,'0');
            // MAJ PROFIL MARKETING DU CONTACT DANS SAP
            return majPersonneProfilMarketing(numeroBP,espaceClient.email);
        }
        else{
            List<Object> erreurs = (List<Object>) resultAsMap.get('erreurs');
            Map<String,Object> erreur = (Map<String,Object>) erreurs.get(0);
            String codeMessage = (String)erreur.get('code');
            return getMessagefromErrorCode(codeMessage);
        }		
    }
    
    @AuraEnabled(cacheable=false)
    public static String renvoyerMailActivation(Map < String, Object > mailActivationMap){
        
        if(mailActivationMap == null){
            System.debug('[SM_AP72_EspaceClientService] : mailActivationMap null');
            throw new IOException('INVALID INPUT');
        }
        
        Map<String,String> mailActivationRequest = new Map<String,String>{
            'login'=>(String) mailActivationMap.get('email'),
                'composante'=>'CEL',
                'idApplicatif'=>(String) mailActivationMap.get('numeroBP')
                };
                    
                    String token = loadToken();
        
        HttpResponse response = getHttpResponse(token,'MailActivation',mailActivationRequest);
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        
        String statutResponse = (String)resultAsMap.get('statut');
        system.debug('*****resultAsMap******:' + resultAsMap);
        if(!String.isBlank(statutResponse) && 'OK'.equals(statutResponse)){
            return 'OK';
        }
        else{
            List<Object> erreurs = (List<Object>) resultAsMap.get('erreurs');
            Map<String,Object> erreur = (Map<String,Object>) erreurs.get(0);
            SM_EspaceClient_Erreur__mdt erreurMDT = [SELECT id,message__c FROM SM_EspaceClient_Erreur__mdt WHERE developername  = 'RenvoieEmailKO' limit 1];
            return erreurMDT.message__c;
        }
    }
    
    private static String loadToken(){
        String token;
        if(!Test.isRunningTest()){
            token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
        }
        else{
            token = 'wadfkoa5678';
        }
        if (token == null) {
            system.debug('[SM_AP72_EspaceClientService : Token not found ...]');
            throw new IOException('INVALID TOKEN API');
        }
        return token;
    }
    
    private static String majPersonneProfilMarketing(String numeroBP,String email){
        Map<String,Object> inputMap = new Map<String,Object>{
            'numeroBP' => numeroBP,
                'email'  => email
                };
                    Map<String,Object> outputMap = new Map<String,Object>();
        String methodName = 'majPersonneProfilMarketing';
        
        SM_AP61_PersonneOctopus personneOctopusService = new SM_AP61_PersonneOctopus();
        personneOctopusService.invokeMethod(methodName, inputMap, outputMap, null);
        if(Test.isRunningTest()){
            return 'OK';
        }
        return outputMap.get('MAJProfilMarketing')!=null ? (String) outputMap.get('MAJProfilMarketing') : 'KO';
    }
    
    public static Map<String,Object> buildEspaceClientACreerRequestBody(EspaceClientACreer espaceClient){
        return new Map<String,Object>{
            'login' => espaceClient.email,
                'civilite' => espaceClient.civilite,
                'nom' => espaceClient.nom,
                'prenom' => espaceClient.prenom,
                'composante' => 'CEL',
                'idApplicatif' => espaceClient.numeroBP,
                'listeCodesVariablesMailRelance' => 'CIVILITE;NOM;PRENOM;EMAILBP;REFBP',
                'listeValeursVariablesMailRelance' => espaceClient.civilite+';'+espaceClient.nom+';'+espaceClient.prenom+';'+espaceClient.email+';'+espaceClient.numeroBP,
                'template' => 'ActivationCEL'
                };
                    }
    
    public static EspaceClientACreer buildEspaceClientACreer(Map<String,Object> inputMap){
        return new EspaceClientACreer(
            (String) inputMap.get('prenom'),
            (String) inputMap.get('nom'),
            (String) inputMap.get('civilite'),
            (String) inputMap.get('email'),
            (String) inputMap.get('numeroBP')
        );
    }
    public class EspaceClientACreer{
        public String prenom ;
        public String nom ;
        public String civilite ;
        public String email ;
        public String numeroBP ;
        
        public EspaceClientACreer(String prenom, String nom, String civilite, String email, String numeroBP){
            this.prenom = prenom;
            this.nom = nom;
            this.civilite = civilite;
            this.email = email;
            this.numeroBP = numeroBP;
        }
    }
    
    /*@Author: HEL
*@Description : Build the HttpRequest for post method
*@CreatedDate : 09/07/2018
*/
    public static HttpRequest buildHttpRequestHeadersPost(String token,String apiSuffix, Map<String, Object> bodyRequest) {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        String endpointURL = '';
        if (!Test.isRunningTest()) {
            SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = :apiSuffix limit 1];
            endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;
        }
        req.setEndpoint(endpointURL);
        req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
        if(!Test.isRunningTest()){
            req.setHeader('X-Api-Key', MP_Xdata_credentials__c.getInstance('sm_api_key_digital_INT').Value__c);
            req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
            req.setHeader('DIG_ID_CLIENT', MP_Xdata_credentials__c.getInstance('sm_digital_id_client').Value__c);
            req.setHeader('DIG_SECRET_CLIENT', MP_Xdata_credentials__c.getInstance('sm_digital_secret_client').Value__c);
        }
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(bodyRequest));
        system.debug('trame:' + bodyRequest);
        return req;
    }
    
    /*@Author: HEL
*@Description : Envoie de la requete POST
*@CreatedDate : 09/07/2019
*/
    public static HttpResponse getHttpResponse(String token,String apiSuffix, Map<String, Object> bodyRequest) {
        HttpRequest httpReq = buildHttpRequestHeadersPost(token,apiSuffix, bodyRequest);
        HttpResponse httpResp = sendData(httpReq);
        if (httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('[SM_AP72_EspaceClientService:getHttpResponse] error when sending http request');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
        }
        
        return httpResp;
        
    }
    
    /*@Author: HEL
*@Description : Envoie de la requete POST
*@CreatedDate : 09/07/2019
*/
    public static HttpResponse sendData(HttpRequest request) {
        Http http = new Http();
        HttpResponse res;
        try {
            res = http.send(request);
            
        } catch (Exception e) {
            system.debug('[SM_AP72_EspaceClientService:sendData] error when sending http request');
            return null;
        }
        return res;
        
    }
    
    /*@Author: HEL
*@CreatedDate : 09/07/2019
*/
    private static Boolean httpResponseFailureDetected(HttpResponse response) {
        return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));
    }
    
    /*@Author: MERABTI IBRAHIM
*@Description : Récuperer le message d'erreur à partir du code d'erreur
*@CreatedDate : 31/01/2020
*/
    public static String getMessagefromErrorCode(String errorCode){
        // Requêter les messages d'erreurs (le message générique est systématiquement récupéré)
        SM_EspaceClient_Erreur__mdt[] errorMessages = [SELECT id,Label,message__c FROM SM_EspaceClient_Erreur__mdt WHERE (Label =:errorCode OR Label ='ErreurECKO') limit 2];
        
        // Initier les deux variables
        String errorMessage = NULL;
        String genericMessage = NULL;
        
        // Boucler sur les messages récupérés: Si le message qui correspond au code erreur 
        // est trouvé, il sera retourné, sinon c'est le message générique qui sera renvoyé. 
        for(SM_EspaceClient_Erreur__mdt ermg: errorMessages){
            if(ermg.Label ==  errorCode) {
                errorMessage =  ermg.message__c;
                return errorMessage;
            }else if(ermg.Label == 'ErreurECKO'){
                genericMessage = ermg.message__c;
            } 
        }
        
        return genericMessage;
        
    }
    
    public class IOException extends Exception {
    }
}