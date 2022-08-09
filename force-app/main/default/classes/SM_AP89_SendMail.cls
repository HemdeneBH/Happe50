/*
* @Author: Lahoucine Ikerchalene
* @Date: 19/05/2020
* @Description: Class permitting to send a mail with le Web service CorrespondanceV2
*/
public with sharing class SM_AP89_SendMail {
    
    private static SM_WS_Suffix__mdt MEDIATOR = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Correspondance_v2' limit 1];
    public static final String VERSION2 = '2.0';
    public static final String CONTEXT = 'Smile';
    public static final String ID_APPLICATION_CODE = 'HUBEONE';
    public static final String ID_APPLICATION_WORDING = 'HUBEONE';
    public static final String SEND_MODE_CODE = 'ASYN';
    public static final String SEND_MODE_WORDING = 'mode asynchrone';
    public static final String ID_FORMULAIRE_CODE = 'C_CONFIRM_MODIF_DONNEES_PERSO';
    public static final String ID_FORMULAIRE_WORDING = 'C_CONFIRM_MODIF_DONNEES_PERSO';
    public static final String TNS = 'envoyerCorrespondance';

    @InvocableMethod
    public static void sendingMail_1(List<Id> contactsToTreat_Ids) {
        sendingMail_2(contactsToTreat_Ids);
    }

    @future(callout = true)
    public static void sendingMail_2(List<Id> contactsToTreat_Ids) {
        String numMobile_Contact = '';
        gdfsuezComBefChpPivot_CorrespV2.contextDt octx = initContext(CONTEXT, VERSION2); 
        
        gdfsuezBefCalypsoCorrespondanceV2.Dependency port = buildPortWSCorrespondance() ;
        
        List<Contact> contacts_To_SendSMS = [Select id, Identifiant_Buisness_Partener__c, Salutation, LastName
                                                    ,FirstName, No_Voie__c, MailingStreet, MailingPostalCode, MailingCity
                                                    ,MailingCountry
                                             From Contact 
                                             Where id in:contactsToTreat_Ids];
        
        //Date today = date.today();
        //String todayString = today.format();
        
        Datetime today = Datetime.now();
        String todayString = today.format('YYYYMMdd');


        for(Contact cont : contacts_To_SendSMS) {
            
            gdfsuezBefCalypsoCorrespondanceV2.envoyerCorrespondanceInputDt input = new gdfsuezBefCalypsoCorrespondanceV2.envoyerCorrespondanceInputDt();

            /*
            // idFormulaire
            input.idFormulaire = new gdfsuezComBefChpPivot_CorrespV2.listeValeursDt();
            input.idFormulaire.libelleCourt = 'SECURISATIONSMILE';
            input.idFormulaire.code = 'SECURISATIONSMILE';

            // canalCommunication
            input.canalCommunication = new gdfsuezComBefChpPivot_CorrespV2.listeValeursDt();
            input.canalCommunication.code = 'SMS';
            input.canalCommunication.libelleCourt = 'sms';

            // Date de la modification
            gdfsuezBefCalypsoCorrespondanceV2.coupleCodeValeurDt dateModifEmail = new gdfsuezBefCalypsoCorrespondanceV2.coupleCodeValeurDt();
            dateModifEmail.code = new gdfsuezComBefChpPivot_CorrespV2.listeValeursDt();
            dateModifEmail.code.code = 'DATE';
            dateModifEmail.valeur = todayString;

            // Liste des coupleCodeValeur
            input.listeCoupleCodeValeur = new gdfsuezBefCalypsoCorrespondanceV2.listeCoupleCodeValeurDt();
            input.listeCoupleCodeValeur.coupleCodeValeur = new List<gdfsuezBefCalypsoCorrespondanceV2.coupleCodeValeurDt>();
            input.listeCoupleCodeValeur.coupleCodeValeur.add(dateModifEmail);

            // modeEnvoi
            input.modeEnvoi = new gdfsuezComBefChpPivot_CorrespV2.listeValeursDt();
            input.modeEnvoi.code = 'ASYN';
            input.modeEnvoi.libelleCourt = 'mode synchrone';

            // numeroTel
            input.numeroTel = '0660530419';

            // idApplication
            input.idApplication = new gdfsuezComBefChpPivot_CorrespV2.listeValeursDt();
            input.idApplication.code = 'CABESTANDIGITAL';
            input.idApplication.libelleCourt = 'CABESTANDIGITAL';
            
            gdfsuezComBefChpPivot_CorrespV2.messageRetoursDt response = port.EnvoyerCorrespondance_Http(input, octx);
            System.debug('========================'+response);
            */

            String body =
            '<?xml version="1.0" encoding="UTF-8"?>'
            +'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
                +'<soap:Body>'
                    +'<ns2:envoyerCorrespondance xmlns:ns2="http://gdfsuez/bef/calypso/Correspondance/v2">'
                        +'<envoyerCorrespondanceInput>'
                            +'<idFormulaire>'
                                +'<libelleCourt>' + ID_FORMULAIRE_WORDING + '</libelleCourt>'
                                +'<code>' + ID_FORMULAIRE_CODE + '</code>'
                            +'</idFormulaire>'
                            +'<canalCommunication>'
                                +'<code>COURRIER</code>'
                            +'</canalCommunication>'
                            +'<listeCoupleCodeValeur>'
                                /*
                                +'<coupleCodeValeur>'
                                    +'<code>'
                                        +'<code>TECH.SAPID</code>'
                                    +'</code>'
                                    +'<valeur>123456_SAP_ID</valeur>'
                                +'</coupleCodeValeur>'
                                */
                                +'<coupleCodeValeur>'
                                    +'<code>'
                                        +'<code>ID_PERSONNE</code>'
                                    +'</code>'
                                    +'<valeur>' + cont.Identifiant_Buisness_Partener__c + '</valeur>'
                                +'</coupleCodeValeur>'
                                +'<coupleCodeValeur>'
                                    +'<code>'
                                        +'<code>CIVILITE</code>'
                                    +'</code>'
                                    +'<valeur>' + cont.Salutation + '</valeur>'
                                +'</coupleCodeValeur>'
                                +'<coupleCodeValeur>'
                                    +'<code>'
                                        +'<code>NOM</code>'
                                    +'</code>'
                                    +'<valeur>' + cont.LastName + '</valeur>'
                                +'</coupleCodeValeur>'
                                +'<coupleCodeValeur>'
                                    +'<code>'
                                        +'<code>PRENOM</code>'
                                    +'</code>'
                                    +'<valeur>' + cont.FirstName + '</valeur>'
                                +'</coupleCodeValeur>'
                                +'<coupleCodeValeur>'
                                    +'<code>'
                                        +'<code>NUM_RUE</code>'
                                    +'</code>'
                                    +'<valeur>' + cont.No_Voie__c + '</valeur>'
                                +'</coupleCodeValeur>'
                                +'<coupleCodeValeur>'
                                    +'<code>'
                                        +'<code>RUE</code>'
                                    +'</code>'
                                    +'<valeur>' + cont.MailingStreet + '</valeur>'
                                +'</coupleCodeValeur>'
                                +'<coupleCodeValeur>'
                                    +'<code>'
                                        +'<code>CODE_POSTAL</code>'
                                    +'</code>'
                                    +'<valeur>' + cont.MailingPostalCode + '</valeur>'
                                +'</coupleCodeValeur>'
                                +'<coupleCodeValeur>'
                                    +'<code>'
                                        +'<code>VILLE</code>'
                                    +'</code>'
                                    +'<valeur>' + cont.MailingCity + '</valeur>'
                                +'</coupleCodeValeur>'
                                +'<coupleCodeValeur>'
                                    +'<code>'
                                        +'<code>PAYS</code>'
                                    +'</code>'
                                    +'<valeur>FRANCE</valeur>'
                                +'</coupleCodeValeur>'
                                +'<coupleCodeValeur>'
                                    +'<code>'
                                        +'<code>GEN_FILLIN_DATE_011</code>'
                                    +'</code>'
                                    +'<valeur>' + todayString + '</valeur>'
                                +'</coupleCodeValeur>'
                            +'</listeCoupleCodeValeur>'
                            +'<modeEnvoi>'
                                +'<libelleCourt>' + SEND_MODE_WORDING + '</libelleCourt>'
                                +'<code>' + SEND_MODE_CODE + '</code>'
                            +'</modeEnvoi>'
                            +'<idApplication>'
                                +'<libelleCourt>' + ID_APPLICATION_WORDING + '</libelleCourt>'
                                +'<code>' + ID_APPLICATION_CODE + '</code>'
                            +'</idApplication>'
                        +'</envoyerCorrespondanceInput>'
                        +'<context>'
                            +'<version>' + VERSION2 + '</version>'
                            +'<systemPath>'
                                +'<system>'
                                    +'<systemId>' + CONTEXT + '</systemId>'
                                +'</system>'
                            +'</systemPath>'
                            +'<allowCache>false</allowCache>'
                        +'</context>'
                    +'</ns2:envoyerCorrespondance>'
                +'</soap:Body>'
            +'</soap:Envelope>';

            System.debug('Requete');
            System.debug(body);

            String endpoint = port.endpoint_x;
            System.debug('endpoint: ' + endpoint);

            Http http = new Http();
            HttpRequest request = new HttpRequest();

            request.setEndpoint(endpoint);            
            
            //SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();

            //request.setClientCertificateName(octopusCS.certName__c);// Certificat Octopus
            request.setClientCertificateName(Label.SM_CL_OctopusCertificate);// Certificat Octopus
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml; charset=UTF-8');
            request.setHeader('SOAPAction', 'tns:'+TNS);
            request.setTimeout(60000);
            request.setBody(body);

            HttpResponse res;
            if (!Test.isRunningTest()) {
                res = http.send(request);
                system.debug('Reponse');
                system.debug(res.getBody());
            } else {
                res = SM_AP86_SendSMS_Mock.respond(request);
            }
        }
    }

    /**
	 * @description : effectue l'appel à la méthode rechercherContrat. Le traitement est effectué dans les méthodes suivantes.
	 */
	public static gdfsuezComBefChpPivot_CorrespV2.contextDt initContext(String application, String version){
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        gdfsuezComBefChpPivot_CorrespV2.contextDt_systemPath_system_element osource = new gdfsuezComBefChpPivot_CorrespV2.contextDt_systemPath_system_element();
        osource.systemId = application;
        
        gdfsuezComBefChpPivot_CorrespV2.contextDt octx = new gdfsuezComBefChpPivot_CorrespV2.contextDt();
        octx.version = version;
        octx.systemPath = new gdfsuezComBefChpPivot_CorrespV2.contextDt_systemPath_element();
        octx.systemPath.system_x = new gdfsuezComBefChpPivot_CorrespV2.contextDt_systemPath_system_element[]{osource};
        return octx;
    }

    public static gdfsuezBefCalypsoCorrespondanceV2.Dependency buildPortWSCorrespondance(){
		gdfsuezBefCalypsoCorrespondanceV2.Dependency port = new gdfsuezBefCalypsoCorrespondanceV2.Dependency() ;  
		SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();  
		port.clientCertName_x = octopusCS.certName__c;
		port.endpoint_x =  octopusCS.endpoint__c + MEDIATOR.suffix__c;
		System.debug('*** endpoint : ' + port.endpoint_x);
		port.inputHttpHeaders_x = new Map<String, String>{'Content-Type' => 'text/xml;charset=utf-8'};
		return port;
    }
    
}