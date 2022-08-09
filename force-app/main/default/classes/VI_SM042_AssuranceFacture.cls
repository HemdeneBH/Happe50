/*
*@Auhtor: Paul Ghoussoub
*@Description: Appel de l'API AssuranceFacture
*@CreatedDate: 19/07/2021
*/

public class VI_SM042_AssuranceFacture {
    private static  User conseiller;	
    private static String VIUserTranquility;
    private static String VIPasswordTranquility;
    static {
        VIUserTranquility = MP_Xdata_credentials__c.getInstance('VI_user_tranquility').Value__c;
        VIPasswordTranquility = MP_Xdata_credentials__c.getInstance('VI_password_tranquility').Value__c;
        conseiller =[Select SAP_Identifier__c from user where Id = :UserInfo.getUserId()]; 	 
    }
    
    
    public static cls_offreList getOffresAvailables(String numeroRue,String rue,String codepostal,String commune,
                                                    String pays,String complement,String batiment,string bpclient,String canal,String idConsomateur,
                                                    String contexte,String partitionName)
    {
        cls_offreList offreARetourner=new cls_offreList();
        String token = '';
        if(!Test.isRunningTest()){
            token = VI_SM013_GetTokenService.getToken(contexte, partitionName); // recuperer token APIHour
        }
        else{
            token = '24';
        }
        Http http = new Http();
        if (token == null) {
            system.debug('Token not found ...');
        }
        Map < String, String > values = new Map < String, String > ();
        values.put('gaia', VIUserTranquility);
        values.put('mdp', VIPasswordTranquility);
        HttpResponse httpResponse;
        if (!Test.isRunningTest()){
            httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_userLoginTranquility',null,values,null,'application/x-www-form-urlencoded','application/json',null,contexte);
        }
        else {
            StaticResourceCalloutMock multimock1 = new StaticResourceCalloutMock();
            multimock1.setStaticResource('VI_TESTGetTokenTranquility');
            multimock1.setStatusCode(200);
            multimock1.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, multimock1);
            httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_userLoginTranquility',null,values,null,'application/x-www-form-urlencoded','application/json',null,contexte);
        }
        
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
        Map<String,Object> beerer = ( Map<String,Object> ) resultAsMap.get('data');
        String tokenTranquility =  (String)  beerer.get('token');
        HttpResponse res;
        Map<String, Object> requestOffreMap =new Map<String, Object>();
        requestOffreMap.put('idConsomateur',idConsomateur);//smile
        requestOffreMap.put('canal',canal);
        Map<String, Object> localAssureMap =new Map<String, Object>();
        localAssureMap.put('numRue',numeroRue);
        localAssureMap.put('rue', rue);
        localAssureMap.put('codePostal',codepostal);
        localAssureMap.put('commune',commune);
        localAssureMap.put('pays',pays);
        localAssureMap.put('complement',complement);
        localAssureMap.put('batiment',batiment);
        requestOffreMap.put('localAssure', localAssureMap);
        requestOffreMap.put('bpClient',bpclient);
        HttpResponse httpResponseTranquility;
        if (!Test.isRunningTest()){
            httpResponseTranquility = VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_tranquilityGetOffresAvailables',null,requestOffreMap,null,'application/json','application/json',tokenTranquility,contexte);
        }
        else {
            StaticResourceCalloutMock multimock2 = new StaticResourceCalloutMock();
            multimock2.setStaticResource('VI_TestGetOffresAvailables');
            multimock2.setStatusCode(200);
            multimock2.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, multimock2);
            httpResponseTranquility = VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_tranquilityGetOffresAvailables',null,requestOffreMap,null,'application/json','application/json',tokenTranquility,contexte);
        }
        
        if(httpResponseTranquility.getBody()!=null){
            string finalreturn= httpResponseTranquility.getBody().replace( 'return' , 'return_x' );
            cls_response retour=parseOffreAvailable(finalreturn);
            if(retour!=null && retour.return_x!=null && retour.return_x.retour!=null && retour.return_x.retour.offreList!=null
               && retour.return_x.retour.offreList.size()>0){
                   for(cls_offreList offre:retour.return_x.retour.offreList){
                       if(offre.idOffre=='AF1'){
                           offreARetourner=offre;
                           break;
                       }
                   }
               }
        }
        system.debug('offreARetourner '+offreARetourner);
        return offreARetourner;
    }
    
    @future(callout=true)
    public static void getResponseAddContratTranquility(String parcoursId,/*String idLocal,String idCompteClient,*/String contexte,String partitionName) {
        VI_Parcours__c selectedParcours=[Select id,VI_Contact__c,VI_NumeroRueRechercheLocal__c,VI_RueRechercheLocal__c,VI_Email_CPV__c,
                                         VI_CodePostalRechercheLocal__c,VI_CommuneRechercheLocal__c,VI_AssuranceFactureCocheeAF__c,VI_Id_Contrat_Assurance__c,
                                         VI_Id_Local__c,VI_idCompteClient__c
                                         from VI_Parcours__c 
                                         where id=:parcoursId limit 1];
        
        
        if(selectedParcours!=null){
            String token = '';
            if(!Test.isRunningTest()){
                token = VI_SM013_GetTokenService.getToken(contexte, partitionName); // recuperer token APIHour
            }
            else{
                token = '24';
            }
            Http http = new Http();
            if (token == null) {
                system.debug('Token not found ...');
            }
            Map < String, String > values = new Map < String, String > ();
            values.put('gaia', VIUserTranquility);
            values.put('mdp', VIPasswordTranquility);
            HttpResponse httpResponse;
            if (!Test.isRunningTest()){
                httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_userLoginTranquility',null,values,null,'application/x-www-form-urlencoded','application/json',null,contexte);
                system.debug('httpResponse '+httpResponse);
            }
            else {
                StaticResourceCalloutMock multimock1 = new StaticResourceCalloutMock();
                multimock1.setStaticResource('VI_TESTGetTokenTranquility');
                multimock1.setStatusCode(200);
                multimock1.setHeader('Content-Type', 'application/json');
                Test.setMock(HttpCalloutMock.class, multimock1);
                httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_userLoginTranquility',null,values,null,'application/x-www-form-urlencoded','application/json',null,contexte);
            }
            Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
            Map<String,Object> beerer = ( Map<String,Object> ) resultAsMap.get('data');
            String tokenTranquility =  (String)  beerer.get('token');
            Map<String,Object> resultAsMapTranquilityTemp=new Map<String,Object>() ;
            
            List<Contact> contacts = [SELECT  reference_client_f__c, LastName, FirstName, Salutation, VI_Contact_Emails__c, 
                                      No_Voie__c, MailingStreet, MailingPostalCode, MailingCity, Complement_adresse__c
                                      FROM Contact 
                                      WHERE Id  =: selectedParcours.VI_Contact__c];
            
            AddContrat services = new AddContrat();
            
            HttpResponse httpResp;
            
            services.refClientIdBP = contacts[0].reference_client_f__c;
            services.numeroVoie = selectedParcours.VI_NumeroRueRechercheLocal__c;
            services.libelleVoie = selectedParcours.VI_RueRechercheLocal__c;
            services.codePostal = selectedParcours.VI_CodePostalRechercheLocal__c;
            services.ville = selectedParcours.VI_CommuneRechercheLocal__c;
            services.complementAdresse = '';
            
            services.servicesEnAttente=new cls_services();       
            services.servicesEnAttente.clientInfos=new cls_clientInfos();
            
            services.servicesEnAttente.clientInfos.refClientIdBP = contacts[0].reference_client_f__c;
            services.servicesEnAttente.formattedEtat = '1';  
            services.servicesEnAttente.idLocal = selectedParcours.VI_Id_Local__c;  
            services.servicesEnAttente.idCompteClient = selectedParcours.VI_idCompteClient__c;  
            services.servicesEnAttente.clientInfos.nom = contacts[0].LastName;
            services.servicesEnAttente.clientInfos.prenom = contacts[0].FirstName;
            services.servicesEnAttente.clientInfos.civilite = contacts[0].Salutation;
            services.servicesEnAttente.clientInfos.email = selectedParcours.VI_Email_CPV__c;
            //client info
            services.servicesEnAttente.clientInfos.clNumeroVoie = contacts[0].No_Voie__c;
            services.servicesEnAttente.clientInfos.clLibelleVoie = contacts[0].MailingStreet;
            services.servicesEnAttente.clientInfos.clCodePostal = contacts[0].MailingPostalCode;
            services.servicesEnAttente.clientInfos.clVille = contacts[0].MailingCity;
            services.servicesEnAttente.clientInfos.clComplementAdresse = contacts[0].Complement_adresse__c;
            //local assure info
            services.servicesEnAttente.clientInfos.numeroVoie = selectedParcours.VI_NumeroRueRechercheLocal__c;
            services.servicesEnAttente.clientInfos.libelleVoie = selectedParcours.VI_RueRechercheLocal__c;
            services.servicesEnAttente.clientInfos.codePostal = selectedParcours.VI_CodePostalRechercheLocal__c;
            services.servicesEnAttente.clientInfos.ville = selectedParcours.VI_CommuneRechercheLocal__c;
            Map<String, Object> serviceMap=fillMapFromService(services.servicesEnAttente,null,false,null);
            
            system.debug('before send');
            HttpResponse httpResponseTranquility = VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_tranquilityAddContrat',null,serviceMap,null,'application/json','application/json',tokenTranquility,contexte);
            System.debug('httpResp'+httpResponseTranquility.getBody());
            if(httpResponseTranquility.getBody()!=null){
                string finalreturn= httpResponseTranquility.getBody().replace( 'return' , 'return_x' );
                cls_response retour=parseOffreAvailable(finalreturn);
                if(retour!=null && retour.return_x!=null && retour.return_x.retour.contrat!=null && retour.return_x.retour.contrat.idContrat!=null){
                    system.debug('retour.return_x.contrat.idContrat '+retour.return_x.retour.contrat.idContrat);
                    VI_Parcours__c parcours=new VI_Parcours__c(id=parcoursId);
                    parcours.VI_Id_Contrat_Assurance__c=retour.return_x.retour.contrat.idContrat;
                    update parcours;
                   }
            }
        }
    }
    
    public static void getResponseEditContratTranquility(String parcoursId,String idLocal,String idCompteClient,String contexte,String partitionName) {
        VI_Parcours__c selectedParcours=[Select id,VI_Contact__c,VI_NumeroRueRechercheLocal__c,VI_RueRechercheLocal__c,VI_Email_CPV__c,
                                         VI_CodePostalRechercheLocal__c,VI_CommuneRechercheLocal__c,VI_AssuranceFactureCocheeAF__c,VI_Id_Contrat_Assurance__c,ownerId 
                                         from VI_Parcours__c 
                                         where id=:parcoursId limit 1];
        
        
        if(selectedParcours!=null){
            String token = '';
            if(!Test.isRunningTest()){
                token = VI_SM013_GetTokenService.getToken(contexte, partitionName); // recuperer token APIHour
            }
            else{
                token = '24';
            }
            Http http = new Http();
            if (token == null) {
                system.debug('Token not found ...');
            }
            Map < String, String > values = new Map < String, String > ();
            values.put('gaia', VIUserTranquility);
            values.put('mdp', VIPasswordTranquility);
            HttpResponse httpResponse;
            if (!Test.isRunningTest()){
                httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_userLoginTranquility',null,values,null,'application/x-www-form-urlencoded','application/json',null,contexte);
                system.debug('httpResponse '+httpResponse);
            }
            else {
                StaticResourceCalloutMock multimock1 = new StaticResourceCalloutMock();
                multimock1.setStaticResource('VI_TESTGetTokenTranquility');
                multimock1.setStatusCode(200);
                multimock1.setHeader('Content-Type', 'application/json');
                Test.setMock(HttpCalloutMock.class, multimock1);
                httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_userLoginTranquility',null,values,null,'application/x-www-form-urlencoded','application/json',null,contexte);
            }
            Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
            Map<String,Object> beerer = ( Map<String,Object> ) resultAsMap.get('data');
            String tokenTranquility =  (String)  beerer.get('token');
            Map<String,Object> resultAsMapTranquilityTemp=new Map<String,Object>() ;
            
            List<Contact> contacts = [SELECT  reference_client_f__c, LastName, FirstName, Salutation, VI_Contact_Emails__c, 
                                      No_Voie__c, MailingStreet, MailingPostalCode, MailingCity, Complement_adresse__c
                                      FROM Contact 
                                      WHERE Id  =: selectedParcours.VI_Contact__c];
            
            AddContrat services = new AddContrat();
            
            HttpResponse httpResp;
            
            services.refClientIdBP = contacts[0].reference_client_f__c;
            services.numeroVoie = selectedParcours.VI_NumeroRueRechercheLocal__c;
            services.libelleVoie = selectedParcours.VI_RueRechercheLocal__c;
            services.codePostal = selectedParcours.VI_CodePostalRechercheLocal__c;
            services.ville = selectedParcours.VI_CommuneRechercheLocal__c;
            services.complementAdresse = '';
            
            services.servicesEnAttente=new cls_services();       
            services.servicesEnAttente.clientInfos=new cls_clientInfos();
            
            services.servicesEnAttente.clientInfos.refClientIdBP = contacts[0].reference_client_f__c;
            services.servicesEnAttente.formattedEtat = '1';  
            services.servicesEnAttente.idLocal = idLocal;//idLocal;  
            services.servicesEnAttente.idCompteClient = idCompteClient;  
            services.servicesEnAttente.clientInfos.nom = contacts[0].LastName;
            services.servicesEnAttente.clientInfos.prenom = contacts[0].FirstName;
            services.servicesEnAttente.clientInfos.civilite = contacts[0].Salutation;
            services.servicesEnAttente.clientInfos.email = selectedParcours.VI_Email_CPV__c;
            //client info
            services.servicesEnAttente.clientInfos.clNumeroVoie = contacts[0].No_Voie__c;
            services.servicesEnAttente.clientInfos.clLibelleVoie = contacts[0].MailingStreet;
            services.servicesEnAttente.clientInfos.clCodePostal = contacts[0].MailingPostalCode;
            services.servicesEnAttente.clientInfos.clVille = contacts[0].MailingCity;
            services.servicesEnAttente.clientInfos.clComplementAdresse = contacts[0].Complement_adresse__c;
            //local assure info
            services.servicesEnAttente.clientInfos.numeroVoie = selectedParcours.VI_NumeroRueRechercheLocal__c;
            services.servicesEnAttente.clientInfos.libelleVoie = selectedParcours.VI_RueRechercheLocal__c;
            services.servicesEnAttente.clientInfos.codePostal = selectedParcours.VI_CodePostalRechercheLocal__c;
            services.servicesEnAttente.clientInfos.ville = selectedParcours.VI_CommuneRechercheLocal__c;
            Map<String, Object> serviceMap=fillMapFromService(services.servicesEnAttente,selectedParcours.VI_Id_Contrat_Assurance__c,true,selectedParcours.OwnerId);
            
            system.debug('before send');
            HttpResponse httpResponseTranquility = VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_tranquilityEditContrat',null,serviceMap,null,'application/json','application/json',tokenTranquility,contexte);
            System.debug('httpResp'+httpResponseTranquility.getBody());
            
        }
    }
        
    public static Map<String, Object> fillMapFromService(cls_services service,String idContrat,Boolean isEdit,String ownerId){
        User currentUser;
        if(!isEdit){
            currentUser=[SELECT id,account.name,account.VI_BP_Conseiller__c
                         FROM user
                         WHERE id=:UserInfo.getUserId() 
                         Limit 1];
        }
        else{
            currentUser=[SELECT id,account.name,account.VI_BP_Conseiller__c
                         FROM user
                         WHERE id=:ownerId
                         Limit 1];
        }
        
        Map<String, Object> serviceMap=new Map<String, Object>();
        Map<String, Object> clientInfosMap=new Map<String, Object>();
        Map<String, Object> paiementModeMap=new Map<String, Object>();
        Map<String, Object> modePrelevementMap=new Map<String, Object>();
        Map<String, Object> clientMap=new Map<String, Object>();
        Map<String, Object> localAssureMap=new Map<String, Object>();
        Map<String, Object> contratMap=new Map<String, Object>();
        Map<String, Object> inputRequestMap=new Map<String, Object>();
        
        
        
        if(service.clientInfos.civilite != null){
            if(service.clientInfos.civilite=='MR'||service.clientInfos.civilite=='MRS'){
                service.clientInfos.civilite='MR'; 
            }else if (service.clientInfos.civilite=='MME'||service.clientInfos.civilite=='MLLE'||service.clientInfos.civilite=='MLLES'||service.clientInfos.civilite=='MMES'){
                service.clientInfos.civilite='MME';  
            }else{
                service.clientInfos.civilite='MR et MME';    
            }            
        }
        if(service.clientInfos.canal=='Email'){
            service.clientInfos.canal='emails';
        }else{
            service.clientInfos.canal='courrier';
        }
        
        modePrelevementMap.put('dPrlv',service.clientInfos.DatePrelevement);
        paiementModeMap.put('libellePaiement','CE');
        paiementModeMap.put('sendingMode','emails');
        
        //Client
        clientMap.put('civilite', service.clientInfos.civilite);
        clientMap.put('prenom', service.clientInfos.prenom);
        clientMap.put('nom', service.clientInfos.nom);
        clientMap.put('bpClient',service.clientInfos.refClientIdBP); // modifier chaque fois pour test
        clientMap.put('numRue', service.clientInfos.clNumeroVoie);
        clientMap.put('rue', service.clientInfos.clLibelleVoie);
        clientMap.put('codePostal',service.clientInfos.codePostal);
        clientMap.put('commune', service.clientInfos.clVille);
        clientMap.put('email',service.clientInfos.email);
        //Local Assure
        localAssureMap.put('numRue',service.clientInfos.numeroVoie);
        localAssureMap.put('rue',service.clientInfos.libelleVoie);
        localAssureMap.put('codePostal',service.clientInfos.codePostal);
        localAssureMap.put('commune',service.clientInfos.ville);
        system.debug('localAssureMap '+localAssureMap);
        
        //Trame Appel Contrat
        contratMap.put('client',clientMap );
        contratMap.put('localAssure',localAssureMap );
        contratMap.put('paiementMode',paiementModeMap );
        contratMap.put('idOffre','AF1' );
        contratMap.put('canal','appentrant' );//partenaire
        contratMap.put('etat',service.formattedEtat);
        contratMap.put('bpConseiller',currentUser.account.VI_BP_Conseiller__c);
        if(idContrat!=null){
            contratMap.put('idContrat',idContrat);
        }
        
        //START DDPCM-1118
        if(service.idLocal!=null){
            system.debug('service.idLocal '+service.idLocal);
            contratMap.put('idLocal',service.idLocal );
        }
        if(service.idCompteClient!=null){
            system.debug('service.idCompteClient '+service.idCompteClient);
            contratMap.put('idCompteClient', service.idCompteClient);
        }
        //END DDPCM-1118
        
        inputRequestMap.put('contrat', contratMap);
        inputRequestMap.put('idConsomateur', 'PartnerCom'); 
        
        
        return inputRequestMap;
        
    }
    
    
    //Wrappers
    public class localAssure{
        public String numRue;
        public String rue;
        public String codePostal;
        public String commune;
        public String complement;
        public String pays;
    }
    
    public class cls_modePaiement{
        public String libellePaiement;
        public String sendingMode;
        public cls_modePrelevement modePrelevement;
    }
    
    public class RequestOffre{
        public localAssure localAssure;
        public String idConsomateur;
        public String bpClient;
    }
    
    public class cls_modePrelevement{
        public String nomTitulaire;
        public String dPrlv;
        public String iban;
        public String domiciliation;
    }
    
    public class ClientIdentity {       
        public String nom;
        public String prenom;
        public String civilite; 
        public String email;
        public String bpClient;
        public String numRue;
        public String rue;
        public String codePostal;
        public String commune;
    }
    
    public class contrat{
        public list <metaValues> metaValues;
        public ClientIdentity client;
        public localAssure localAssure;
        public cls_modePaiement paiementMode;
        public String idOffre;
        public String dateEffet;
        public String bpConseiller;
        public String canal;
        public String etat;
        public String order_id;
        public String commentaire;
        public String idContrat;
    }
    
    public class RequestAddContrat{
        public contrat contrat;
        public String idConsomateur;
    }
    
    public class RequestOffreAvailables{
        public localAssure localAssure;
        public String idConsomateur;
        public String bpClient;
        public integer bpConseiller;
        public String canal;
    }
    
    public class metaValues{
        public String fieldName;
        public String fieldValue;
    }
    
    public class AddContrat{
        public String IdBusinessPartner;	
        public String refClientIdBP;	
        public ClientIdentity contactinfo;
        public cls_services servicesAcceptes;
        public cls_services servicesRefuses;
        public cls_services servicesEnAttente;
        public String numeroVoie;
        public String libelleVoie;
        public String codePostal;
        public String ville;
        public String complementAdresse;
        
        
        
        public cls_modePaiement paiementMode;
    }
    
    public virtual  class cls_services {		
        public String idOffre;	//DEGS0
        public cls_clientInfos clientInfos; 
        public String formattedEtat;
        public String idLocal;
        public String idCompteClient;
    }
    public class cls_clientInfos {
        public String dateEffet;
        public String DatePrelevement;
        public String canal;	//Email
        public String modeDePaiement;	//prelevement
        public cls_iban iban;
        //to remove
        public String refClientIdBP;	//312376423
        public String nom;
        public String prenom;
        public String civilite;
        public String email; // obligatoire pour le parcours digital
        //localAssure
        public string numeroVoie = '';
        public String libelleVoie = '';
        public String codePostal = '';
        public String ville = '';  
        public String complementAdresse = '';
        //client
        public String clNumeroVoie = '';
        public String clLibelleVoie = '';
        public String clCodePostal = '';
        public String clVille = '';
        public String clComplementAdresse = '';
    }
    
    public class cls_iban {
        public String TitulaireCompte;	
        public String Nombanque;	
        public String bic;	
        public String IbanNumber;	
    }
    
    public static AddContrat parse(String json){
        return (AddContrat) System.JSON.deserialize(json, AddContrat.class);
    }
    
    class cls_response{
        public cls_return return_x;
    }
    
    class cls_return {
        public cls_retour retour;
        public cls_messageRetour messageRetour;
    }
    class cls_retour {
        public cls_offreList[] offreList;
        public contrat contrat;
    }
    public class cls_offreList {
        public String idOffre;	//ACP
        public String libelle;	//Aide coup de pouce
        public String prixAn;	//3120.00
        public String prixMois2;	//0.00
        public String prixAn2;	//0.00
        public String prixMois;	//65.00
        public String dateFin;	//2099-12-31
        public String dateDebut;	//2015-08-01
        public boolean action;
        public cls_idContrat idContrat;
        public cls_fieldList[] fieldList;
    }
    class cls_idContrat {
    }
    class cls_fieldList {
    }
    class cls_messageRetour {
        public String code;	//SUCCESS
        public String libelle;	//La demande a été traitée avec succès
        public cls_erreurList erreurList;
    }
    class cls_erreurList {
    }
    public static cls_response parseOffreAvailable(String json){
        return (cls_response) System.JSON.deserialize(json, cls_response.class);
    }
}