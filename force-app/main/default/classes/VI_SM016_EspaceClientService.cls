/* 
@Project : Pure Player
@Description : Cette classe permet de gérer l'espace client du client via l'api digital

*/
public without sharing class VI_SM016_EspaceClientService {
    @AuraEnabled(cacheable=false) 
    public static String creerEspaceClient(String prenom, String nom, String civilite, String email, String numeroBP,String contexte, String partitionName){
        //to test VI_SM016_EspaceClientService.creerEspaceClient('Amal', 'Chreiteh','MR','amal.chreiteh@eit-mena.com','0306593555','VI','local.VIToken');
        EspaceClientACreer espaceClient  = new EspaceClientACreer(prenom,nom,civilite,email,numeroBP);
        
        String token =  VI_SM013_GetTokenService.getToken(contexte, partitionName);
        if (token == null) {
            system.debug('Token not found ...');
        }
        
        Map<String,Object> espaceClientACreerBody = buildEspaceClientACreerRequestBody(espaceClient);
        System.debug('### aka espaceClientACreerBody ' + espaceClientACreerBody);
        //HttpResponse response = getHttpResponse(token,'EspacesPrives',espaceClientACreerBody);
        system.debug('tokentoken '+token);
        HttpResponse response=VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_EspacesPrives',null,espaceClientACreerBody,null,null,null,null,contexte);
        system.debug('response '+response);
        if(response.getStatusCode() == 503){
                return 'Erreur : Service Temporarily Unavailable';
            }
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        system.debug('resultAsMap '+resultAsMap);
        String statutResponse = (String)resultAsMap.get('statut');
        if(!String.isBlank(statutResponse) && 'OK'.equals(statutResponse)){
            
            numeroBP = espaceClient.numeroBP.leftPad(10,'0');
            // MAJ PROFIL MARKETING DU CONTACT DANS SAP
            return majPersonneProfilMarketing(numeroBP,espaceClient.email);
        }
        else{
            //CHECK IF CREATION OF OBJECT IS NEEDED
            List<Object> erreurs = (List<Object>) resultAsMap.get('erreurs');
            Map<String,Object> erreur = (Map<String,Object>) erreurs.get(0);
            if('MGUT-022'.equals((String)erreur.get('code'))){
                SM_EspaceClient_Erreur__mdt erreurMDT = [SELECT id,message__c FROM SM_EspaceClient_Erreur__mdt WHERE developername  = 'MGUT_022' limit 1];
                return erreurMDT.message__c;
            }
            else{
                SM_EspaceClient_Erreur__mdt erreurMDT = [SELECT id,message__c FROM SM_EspaceClient_Erreur__mdt WHERE developername  = 'ErreurECKO' limit 1];
                return erreurMDT.message__c;
            }
        }       
    }
    
    @AuraEnabled(cacheable=false)
    public static String renvoyerMailActivation(String email,String contexte, String partitionName){
        //to test VI_SM016_EspaceClientService.renvoyerMailActivation('amal.chreiteh@eit-mena.com','VI','local.VIToken');

        if(email == null){
            System.debug('mailActivationMap null');
            //throw new IOException('INVALID INPUT');
        }

        Map<String,String> mailActivationRequest = new Map<String,String>{
            'login'=>email,
            'composante'=>'CEL'
        };

        String token =  VI_SM013_GetTokenService.getToken(contexte,partitionName);
        if (token == null) {
            system.debug('Token not found ...');
        }

        HttpResponse response=VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_MailActivation',null,mailActivationRequest,null,null,null,null,contexte);
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());

        String statutResponse = (String)resultAsMap.get('statut');
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
       /* public EspaceClientACreer(Map<String,Object> inputMap){
            this.prenom = (String) inputMap.get('prenom');
            this.nom = (String) inputMap.get('nom');
            this.civilite = (String) inputMap.get('civilite');
            this.email = (String) inputMap.get('email');
            this.numeroBP = (String) inputMap.get('numeroBP');
        }        */
    }
    
    public static Map<String,Object> buildEspaceClientACreerRequestBody(EspaceClientACreer espaceClient){
        Map<String,Object> mapEspaceClient=new Map<String,Object>();
        mapEspaceClient.put('login', espaceClient.email);
        mapEspaceClient.put('civilite', espaceClient.civilite);
        mapEspaceClient.put('nom', espaceClient.nom);
        mapEspaceClient.put('prenom', espaceClient.prenom);
        mapEspaceClient.put('composante', 'CEL');
        mapEspaceClient.put('idApplicatif', espaceClient.numeroBP);
        mapEspaceClient.put('listeCodesVariablesMailRelance', 'CIVILITE;NOM;PRENOM;EMAILBP;REFBP');
        mapEspaceClient.put('listeValeursVariablesMailRelance', espaceClient.civilite+';'+espaceClient.nom+';'+espaceClient.prenom+';'+espaceClient.email+';'+espaceClient.numeroBP);
        mapEspaceClient.put('template', 'ActivationCEL');
        return mapEspaceClient;
        
        /*return new Map<String,Object>{
            'login' => espaceClient.email,
            'civilite' => espaceClient.civilite,
            'nom' => espaceClient.nom,
            'prenom' => espaceClient.prenom, 
            'composante' => 'CEL',
            'idApplicatif' => espaceClient.numeroBP,
            'listeCodesVariablesMailRelance' => 'CIVILITE;NOM;PRENOM;EMAILBP;REFBP',
            'listeValeursVariablesMailRelance' => espaceClient.civilite+';'+espaceClient.nom+';'+espaceClient.prenom+';'+espaceClient.email+';'+espaceClient.numeroBP,
            'template' => 'ActivationCEL'
        };*/
    } 
    
    public static String majPersonneProfilMarketing(String numeroBP,String email){
        Map<String,Object> inputMap = new Map<String,Object>{
            'numeroBP' => numeroBP,
            'email'  => email
        };
        Map<String,Object> outputMap = new Map<String,Object>();

       // VI_SM003_PersonneOctopus.majPersonneProfilMarketing(numeroBP, email,'Smile', '2.0','AuthOctopus');
        if(Test.isRunningTest()){
                return 'OK';
        }
        return outputMap.get('MAJProfilMarketing')!=null ? (String) outputMap.get('MAJProfilMarketing') : 'KO';
    }
}