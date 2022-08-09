/* 
@Project : Smile
@Description : Cette classe permet de gérer l'espace client du client via l'api digital

*/

global class SM_AP72_EspaceClientService {
    
    // addtional headers to add to the digital api request headers
    public static Map<String, String> additionalHeaders = new Map<String, String>{
        'X-Api-Key' => (!Test.isRunningTest())? MP_Xdata_credentials__c.getInstance('sm_api_key_digital_INT').Value__c :'',
        'DIG_ID_CLIENT' => (!Test.isRunningTest())? MP_Xdata_credentials__c.getInstance('sm_digital_id_client').Value__c:'',
        'DIG_SECRET_CLIENT' => (!Test.isRunningTest())? MP_Xdata_credentials__c.getInstance('sm_digital_secret_client').Value__c:''
    };    

    @AuraEnabled(cacheable=false)
    public static String creerEspaceClient(Map < String, Object > espaceClientACreerMap){
        
        if(espaceClientACreerMap == null){
            System.debug('[SM_AP72_EspaceClientService] : espaceClientACreerMap null');
            throw new IOException('INVALID INPUT');
        }
        EspaceClientACreer espaceClient  = buildEspaceClientACreer(espaceClientACreerMap);
        
        
        Map<String,Object> espaceClientACreerBody = buildEspaceClientACreerRequestBody(espaceClient);
        System.debug('### aka espaceClientACreerBody ' + espaceClientACreerBody);
        HttpResponse response = getResponse('EspacesPrives',espaceClientACreerBody);
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
                    
        HttpResponse response = getResponse('MailActivation',mailActivationRequest);
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
    
    public static String majPersonneProfilMarketing(String numeroBP,String email){
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
        System.debug('### aka EMAIL ' + inputMap.get('email'));
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
*@Description : Envoie de la requete POST
*@CreatedDate : 09/07/2019
*/
    public static HttpResponse getResponse(String apiSuffix, Map<String, Object> bodyRequest) {
        system.debug(JSON.serialize(bodyRequest));
        HttpResponse httpResp = CalloutManager.sendRequest(apiSuffix, null, 'POST', CalloutManager.Scope.WRITE, JSON.serialize(bodyRequest), additionalHeaders);
        if (CalloutManager.httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('[SM_AP72_EspaceClientService:getResponse] error when sending http request');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
        }
        
        return httpResp;
        
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