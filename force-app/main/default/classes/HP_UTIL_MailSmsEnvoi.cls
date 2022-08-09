/**
 * @File Name          : HP_UTIL_MailSmsEnvoi.cls
 * @Description        : Classe générique d'envoi des mails et SMS via Octopus -> Cabestan
 * @Author             : Mohamed Aamer
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 18/06/2020 à 14:32:01
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    22/01/2020   Mohamed Aamer     Initial Version
**/
public with sharing class HP_UTIL_MailSmsEnvoi {

    public static void envoiSync(Map<String, String> inputMap){
        envoiOctopus(inputMap);
    }

	public static void envoiAsync(Map<String, String> inputMap){
        HP_UTIL_MailSmsEnvoi_QUEUEABLE mailJob = new HP_UTIL_MailSmsEnvoi_QUEUEABLE(inputMap);
        Id jobId = System.enqueueJob(mailJob);
	}    
    
    private static void envoiOctopus(Map<String, String> inputMap){

        gdfsuezComBefChpPivot.contextDt context = initContext(HP_Constantes.WS_ES_CORRESPONDANCE_CONTEXT, HP_Constantes.WS_ES_CORRESPONDANCE_VERSION);
		HP_GfsuezBefCalypsoCorrespondanceV2.Dependency port = new HP_GfsuezBefCalypsoCorrespondanceV2.Dependency();
		port.endpoint_x = HP_OctopusUtils.END_POINT+HP_Constantes.WS_ES_CORRESPONDANCE_NAME;
		port.inputHttpHeaders_x = new Map<String, String> {HP_OctopusUtils.CONTENT_TYPE => HP_OctopusUtils.CHARSET};

		HP_GfsuezBefCalypsoCorrespondanceV2.envoyerCorrespondanceInputDt parametres = new HP_GfsuezBefCalypsoCorrespondanceV2.envoyerCorrespondanceInputDt();
		HP_GfsuezBefCalypsoCorrespondanceV2.coupleCodeValeurDt coupleValue;
		HP_GfsuezBefCalypsoCorrespondanceV2.listeCoupleCodeValeurDt listeCoupleCodeValeur = new HP_GfsuezBefCalypsoCorrespondanceV2.listeCoupleCodeValeurDt();
		gdfsuezComBefChpPivot.listeValeursDt idFormulaire = new gdfsuezComBefChpPivot.listeValeursDt();
		gdfsuezComBefChpPivot.listeValeursDt canalCommunication = new gdfsuezComBefChpPivot.listeValeursDt();
		gdfsuezComBefChpPivot.listeValeursDt modeEnvoi = new gdfsuezComBefChpPivot.listeValeursDt();
		gdfsuezComBefChpPivot.listeValeursDt idApplication = new gdfsuezComBefChpPivot.listeValeursDt();
        Map<String, String> coupleValueMap = new Map<String, String>();

        idFormulaire.code               = inputMap.get('idFormulaireCode');
        idFormulaire.libelleCourt       = inputMap.get('idFormulaireLibCourt');
        canalCommunication.code         = inputMap.get('canalCommunicationCode');

        parametres.idFormulaire = idFormulaire;
		parametres.canalCommunication = canalCommunication;

        switch on inputMap.get('idFormulaireCode') {

            when 'SF52' { // Mail - Modifications personnelles

                //root XML
                parametres.email                = inputMap.get('email');
                canalCommunication.libelleCourt = inputMap.get('canalCommunicationLibCourt');
                
                //valeurs
                coupleValueMap.put('EMAIL', inputMap.get('email'));
                coupleValueMap.put('idClient', String.valueOf(Decimal.valueOf(inputMap.get('idClient')).intValue()));
                coupleValueMap.put('OBJET', (inputMap.get('objet') == null ? 'Confirmation de la modification de vos informations personnelles' : inputMap.get('objet')));
                System.debug('@@ contenu ' + inputMap.get('contenu'));
                coupleValueMap.put('CONTENU', inputMap.get('contenu'));
            }
            when 'SMS1' { // SMS - Modifications personnelles

                //root XML
                parametres.numeroTel            = inputMap.get('numMobile');

                //valeurs
                coupleValueMap.put('GSM', inputMap.get('numMobile'));
                coupleValueMap.put('CONTENU', inputMap.get('contenu'));
            }
            when 'SF12','SF13' {
                //root XML
                parametres.email                = inputMap.get('email');
                canalCommunication.libelleCourt = inputMap.get('canalCommunicationLibCourt');
                
                //valeurs
                coupleValueMap.put('EMAIL', inputMap.get('email'));
                coupleValueMap.put('idClient', String.valueOf(Decimal.valueOf(inputMap.get('idClient')).intValue()));
                coupleValueMap.put('NOM', inputMap.get('NOM'));
                coupleValueMap.put('PRENOM', inputMap.get('PRENOM'));
                coupleValueMap.put('CIVILITEHAPPE', inputMap.get('CIVILITEHAPPE'));
                if(inputMap.containsKey('typedemande'))    {coupleValueMap.put('typedemande', inputMap.get('typedemande'));}
                if(inputMap.containsKey('norue'))          {coupleValueMap.put('norue', inputMap.get('norue'));}
                if(inputMap.containsKey('rue'))            {coupleValueMap.put('rue', inputMap.get('rue'));}
                if(inputMap.containsKey('energie'))        {coupleValueMap.put('energie', inputMap.get('energie'));}
                if(inputMap.containsKey('typecomptage'))   {coupleValueMap.put('typecomptage', inputMap.get('typecomptage'));}
                if(inputMap.containsKey('adressecomp1'))   {coupleValueMap.put('adressecomp1', inputMap.get('adressecomp1'));}
                if(inputMap.containsKey('adresseCP'))      {coupleValueMap.put('adresseCP', inputMap.get('adresseCP'));}
                if(inputMap.containsKey('ville'))          {coupleValueMap.put('ville', inputMap.get('ville'));}
                if(inputMap.containsKey('indexresile'))    {coupleValueMap.put('indexresile', inputMap.get('indexresile'));}
            }
            when 'SF20','SF21' {
                //root XML
                parametres.email                = inputMap.get('email');
                canalCommunication.libelleCourt = inputMap.get('canalCommunicationLibCourt');
                
                //valeurs
                coupleValueMap.put('EMAIL', inputMap.get('email'));

                coupleValueMap.put('idclient', String.valueOf(Decimal.valueOf(inputMap.get('idClient')).intValue()));

                coupleValueMap.put('NOM', inputMap.get('NOM'));
                coupleValueMap.put('PRENOM', inputMap.get('PRENOM'));
                coupleValueMap.put('CIVILITEHAPPE', inputMap.get('CIVILITEHAPPE'));
                if(inputMap.containsKey('typedemande'))    {coupleValueMap.put('typedemande', inputMap.get('typedemande'));}
                if(inputMap.containsKey('norue'))          {coupleValueMap.put('norue', inputMap.get('norue'));}
                if(inputMap.containsKey('rue'))            {coupleValueMap.put('rue', inputMap.get('rue'));}
                if(inputMap.containsKey('energie'))        {coupleValueMap.put('energytype', inputMap.get('energie'));}
                if(inputMap.containsKey('typecomptage'))   {coupleValueMap.put('typecomptage', inputMap.get('typecomptage'));}
                if(inputMap.containsKey('adressecomp1'))   {coupleValueMap.put('adressecomp1', inputMap.get('adressecomp1'));}
                if(inputMap.containsKey('adresseCP'))      {coupleValueMap.put('adresseCP', inputMap.get('adresseCP'));}
                if(inputMap.containsKey('ville'))          {coupleValueMap.put('ville', inputMap.get('ville'));}
                if(inputMap.containsKey('indexresile'))    {coupleValueMap.put('INDEXRESILE', inputMap.get('indexresile'));}
            }          
        }

        if(coupleValueMap!=null && !coupleValueMap.isEmpty()) {
            listeCoupleCodeValeur.coupleCodeValeur = new List<HP_GfsuezBefCalypsoCorrespondanceV2.coupleCodeValeurDt>();
                for (String key : coupleValueMap.keySet()) {
                    coupleValue = new HP_GfsuezBefCalypsoCorrespondanceV2.coupleCodeValeurDt();
                    coupleValue.code =  new gdfsuezComBefChpPivot.listeValeursDt();
                    coupleValue.code.code = key;
                    coupleValue.valeur = coupleValueMap.get(key);
                    listeCoupleCodeValeur.coupleCodeValeur.add(coupleValue);
                }
            parametres.listeCoupleCodeValeur = listeCoupleCodeValeur;
        }

        // Balise modeEnvoi
		modeEnvoi.code          = 'ASYN';
		modeEnvoi.libelleCourt  = 'mode asynchrone';
		parametres.modeEnvoi    = modeEnvoi;

		// Balise idApplication
		idApplication.libelleCourt  = 'CABESTANHAPPE';
		idApplication.code          = 'CABESTANHAPPE';
		parametres.idApplication    = idApplication;

        //CALLOUT
		System.debug('envoyerCorrespondance input : ' + parametres);
		gdfsuezComBefChpPivot.messageRetoursDt response = port.EnvoyerCorrespondance_Http(parametres,context);
        System.debug('envoyerCorrespondance Response: '+ response);
        
        //DML (obligatoirement après le callout) Tracer l'envoi du sms dans activity timeline Salesforce 

        switch on inputMap.get('idFormulaireCode') {

            when 'SF52' {
                if(inputMap.get('idClient') != null) {
                    Contact currentContact = HP_EM020_Contact.getContactByXdataId(Integer.valueOf(inputMap.get('idClient')));
                    System.debug('currentContact: ' + currentContact);
                    if (currentContact != null) {
                        String code = 'SF52';
                        HP_EM019_EmailMessage.createEmailMessage(inputMap.get('email'), Integer.valueOf(inputMap.get('idClient')), code, inputMap.get('contenu'));
                    }
                }
            }
            when 'SMS1' {
                        
                Contact currentContact = HP_EM020_Contact.getContactByXdataId(Integer.valueOf(inputMap.get('idClient')));
                System.debug('currentContact: ' + currentContact);
                if (currentContact != null) {
                    HP_EM022_SMSMessage.createSMSMessage(currentContact.Id);
                }
            }
        }        
    }
    
	private static gdfsuezComBefChpPivot.contextDt initContext(String application, String version){
		gdfsuezComBefChpPivot.system_element osource = new gdfsuezComBefChpPivot.system_element();
		osource.systemId = application;
		gdfsuezComBefChpPivot.contextDt octx = new gdfsuezComBefChpPivot.contextDt();
		octx.version = version;
		octx.systemPath = new gdfsuezComBefChpPivot.systemPath_element ();
		octx.systemPath.system_x = new gdfsuezComBefChpPivot.system_element[] {osource};
		return octx;
	}
}