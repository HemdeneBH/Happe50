/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: SM_AP30_PrestationGaz
*/
global class SM_AP30_PrestationGaz implements vlocity_cmt.VlocityOpenInterface {
	
	//parameters
	public static SM_UTIL_Cache_Management service = new SM_UTIL_Cache_Management();
	
    public final static String SetChoixProcedureGazParDefaut  ='SetChoixProcedureGazParDefaut' ;
	public final static String Recollement  ='Recollement' ;


	/* liste des types de prestations */
	public static final List < PrestationVente > listPret = new List < PrestationVente > ();
	private static Map<Integer, String> frenchDates = new Map<Integer, String>();
	private static Map<String, String> frenchDays = new Map<String, String>();
	static {
		// intialiser la les codes prestations
		intialiseCodesPrestation();
		initialiseFrenchDates();
		initialiseFrenchDays();
	}
	public static void initialiseFrenchDates(){
		
		frenchDates.put(1, 'Janvier');
		frenchDates.put(2, 'Février');
		frenchDates.put(3, 'Mars');
		frenchDates.put(4, 'Avril');
		frenchDates.put(5, 'Mai');
		frenchDates.put(6, 'Juin');
		frenchDates.put(7, 'Juillet');
		frenchDates.put(8, 'Aout');
		frenchDates.put(9, 'Septembre');
		frenchDates.put(10, 'Octobre');
		frenchDates.put(11, 'Novembre');
		frenchDates.put(12, 'Décembre');
		
	}
	public static void initialiseFrenchDays(){
		frenchDays.put('Monday', 'Lundi');
		frenchDays.put('Tuesday', 'Mardi');
		frenchDays.put('Wednesday', 'Mercredi');
		frenchDays.put('Thursday', 'Jeudi');
		frenchDays.put('Friday', 'Vendredi');
		frenchDays.put('Saturday', 'Samedi');
		frenchDays.put('Sunday', 'Dimanche');
	}
	
	/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: invoke method for vlocity
*/
	global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		
		if (methodName.equals('creerPrestationGazOnline')) {
			try {
			  
		// actionName par default Créer le premier appel .
				// => dans le cadre de l'us-681 
				String actionName = 'CREER' ; // 
				if(!String.isBlank((String) inputMap.get('actionName'))){
					actionName = (String)inputMap.get('actionName') ;
					system.debug('actionName :'+actionName);
				}
				 // => dans le cadre de l'us-681 
				// system.debug('input'+inputMap);
			 creerPrestationGazOnline(inputMap, outMap, options, actionName ,null,null);
			} 
			catch (Exception e) {
				if (!(e instanceOf IOException)) {
					system.debug(e.getStackTraceString());
					system.debug(e.getMessage());
					// exception non géré
					e.setMessage('Erreur technique est survenue !');
				}
				// remonter l'erreur à l'IP
				 outMap.put('raisedExceptionGaz',e.getMessage());
				 setChoixProcedureSelectable(outMap);
				 //throw e;
			}
		} 
		else if (methodName.equals('creerPrestationGaz')) {
			try {
				creerPrestationGaz(inputMap, outMap, options);
			} 
			catch (Exception e) {
				system.debug(e.getStackTraceString());
				return false;
			}
		} 
		else if (methodName.equals('lirePrestationGazOnline')) {
			try {
				lirePrestationGazOnline(inputMap, outMap, options);
			} 
			catch (Exception e) {
				system.debug(e.getStackTraceString());
				return false;
			}
		} 
		else if (methodName.equals('updatePrestationGaz')) {
			try {
				updatePrestationGaz(inputMap, outMap, options, 'REPLANIFIER_OPS');
			} catch (Exception e) {
				system.debug(e.getStackTraceString());
				return false;
			}
		}
		 else if (methodName.equals('annulerPrestationGaz')) {
			try {
				annulerPrestationGaz(inputMap, outMap, options);
			} catch (Exception e) {
				system.debug(e.getStackTraceString());
				return false;
			}
		}
		else if(methodName.equals('lirePrestationGaz')) {
			try{
				// à appeler pour recuprer les details de la prestation après la creation (Utilisé dans l'etape recap de l'OS Creation OPS)
				lirePrestationGaz(inputMap, outMap, options);
			}catch(Exception e ) {
				if(!Test.isRunningTest()) {
					if( !(e instanceof IOexception)) {
						// exception non géré
						system.debug(e.getStackTraceString());
						system.debug(e.getMessage());
						e.setMessage('Lire prestation Gaz : Erreur technique !');
					}
					throw e;
				}
			}
			
		} 
		else if(methodName.equals('rechercherPrestationGaz')) {
			rechercherPrestationGaz(inputMap, outMap, options);
		}
		else if(methodName.equals('lirePrestationGazList')) {
			try {
				lirePrestationGazList(inputMap, outMap, options);
			} catch(Exception e) {
				System.debug(e.getStackTraceString());
				System.debug(e.getMessage());
			}
		}
		return true;
	}
	
	/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: Une methode qui permet de chercher dans la liste de prestations et retourner le premier element qui correspond à l'element en entrée
*/
	public static PrestationVente getCodePrestation(PrestationVente prestation) {
		for (PrestationVente prestat: listPret) {
			if (prestat.equals(prestation)) {
				return prestat;
			}
		}
		return null;
	}
	
	/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: init context
*/
	public static gdfsuezComBefChpPivotPrestaGaz.contextDt initContext(String application, String version) {
		// Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
		gdfsuezComBefChpPivotPrestaGaz.contextDt_systemPath_system_element osource = new gdfsuezComBefChpPivotPrestaGaz.contextDt_systemPath_system_element();
		osource.systemId = application;
		gdfsuezComBefChpPivotPrestaGaz.contextDt octx = new gdfsuezComBefChpPivotPrestaGaz.contextDt();
		octx.version = version;
		//  octx.allowCache = false ;
		octx.systemPath = new gdfsuezComBefChpPivotPrestaGaz.contextDt_systemPath_element();
		octx.systemPath.system_x = new gdfsuezComBefChpPivotPrestaGaz.contextDt_systemPath_system_element[] {
			osource
				};
					return octx;
	}
	
	/*
* @Author: 
* @Date: 13/02/2019
* @Description: buildeCodePrestation
*/
	 public static PrestationVente buildeCodePrestation(Map < String, Object > objetOps, Map < String, Object > pdlinfo, String context, String origineDemande, boolean interventionObligatoire,
													   Boolean repriseMHS, Map < String, Object > inputMap,boolean autoreleveSelected) {
		
		try {
			
			PrestationVente prestation = new PrestationVente();
			
			prestation.Situation_de_vente = context ;
			
			
			prestation.Secteur_d_activite = 'Gaz';
			prestation.Type_de_compteur = (String) pdlinfo.get('typeCompteur') != null ? (String) pdlinfo.get('typeCompteur') : 'Empty';
			prestation.Date_Refus_telereleve = (String) pdlinfo.get('dateRefusTelereleve') != null ? (String) pdlinfo.get('dateRefusTelereleve') : 'Empty';
			prestation.Etat_compteur = pdlinfo.get('etatTechnique') == null ? 'Empty' : (((String) pdlinfo.get('etatTechnique')).equals('non_coupe') ? 'non coupe' : (String) pdlinfo.get('etatTechnique'));
				prestation.MHs_en_cours = pdlinfo.get('miseHorsServiceEnCours') == null ? 'False' : String.valueOf(pdlinfo.get('miseHorsServiceEnCours'));
			prestation.Fraude = pdlinfo.get('fraude') == null ? 'False' : String.valueOf(pdlinfo.get('fraude'));
			
			prestation.DGI = pdlinfo.get('dgi') == null ? 'False' : String.valueOf(((String) pdlinfo.get('dgi')).equals('DGI'));
			
			prestation.ConsommationSansfournisseur = pdlinfo.get('consommationSansFournisseur') == null ? 'False' : String.valueOf(pdlinfo.get('consommationSansFournisseur'));
			prestation.Etat_PDL_PCE = pdlinfo.get('statutContractuel') == null ? 'Empty' : String.valueOf(pdlinfo.get('statutContractuel'));
			
			prestation.Date_du_jour_Prestation_distributeur_telereleve_sup_5 = pdlinfo.get('dateDerniereTelereleve') == null ? 'False' : String.valueOf(Date.valueOf((String) pdlinfo.get('dateDerniereTelereleve')).daysBetween(System.now().date()) > 5);
			
			//RJM 18/02/2020 Modification de la valeur du champ 'Urgent' (FT2-364)
            prestation.Urgent = String.valueOf(origineDemande);
			//			
			prestation.Choix_de_la_procedure_Autoreleve_ou_Gaz_Autoreleve_Obligatoire = String.valueOf(autoreleveSelected);
			
			prestation.Choix_de_la_procedure_egal_Reprise_d_index_MHS = String.valueOf(repriseMHS) ;
			prestation.Choix_de_la_procedure_Intervention_OU_Gaz_Intervention_obligatoire_coche_sur_OPS = interventionObligatoire == null ? 'Empty' : String.valueOf(interventionObligatoire);
			return prestation;
		} catch (Exception e) {
			system.debug(e);
			system.debug(e.getStackTraceString());
			return null;
		}
	
	  }
	/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: vlocity invoking method creerPrestationGaz
*/
	public void creerPrestationGaz(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		System.debug('**** IN creerPrestationGaz');
		System.debug('*** Input params : ' + inputMap);
		
		Map < String, Object > elements1 = (Map < String, Object > ) inputMap.get('ChoixElements1');
		Map < String, Object > elementsGaz = (Map < String, Object > ) inputMap.get('PrestationGaz');
		Map < String, Object > recolGaz = (Map < String, Object > ) elementsGaz.get('InfoRecollementGaz');
		System.debug('*** recolGaz : ' + recolGaz);
		
		String idPrestation = recolGaz != null ? (String) recolGaz.get('numAffaireDistrib') : null;
		String pce = (String)((Map < String, Object > ) inputMap.get('pdlinfo')).get('idPdl')  ;
		String codePresta = recolGaz != null ? (String) recolGaz.get('Prestation') : null;
		String idBp = inputMap != null ? (String) inputMap.get('refClientIdBP') : null;
		String idContrat =  (String) inputMap.get('idContrat');
		Boolean isBillingAddressSameAsLiving = ((String)((Map < String, Object > ) elements1.get('Address')).get('isBillingAddressSameAsLiving')).equals('Oui');
		Map < String, Object > elements = (Map < String, Object > ) inputMap.get('ChoixElements');
		Map < String, Object > adressContact = (Map < String, Object > ) elements.get('AdresseContact');
		System.debug('*** idPrestation : ' + idPrestation);
		System.debug('*** pce : ' + pce);
		System.debug('*** codePresta : ' + codePresta);
		System.debug('*** idBp : ' + idBp);
		System.debug('*** idContrat : ' + idContrat);
		
		if (String.isBlank(idPrestation) || String.isBlank(pce) || String.isBlank(codePresta) || String.isBlank(idBp) || String.isBlank(idContrat)) {
			System.debug('*** 1 or more fields required empty');
			return;
		}
		
		gdfsuezComBefChpPivotPrestaGaz.contextDt octx = initContext('Smile', '2.0');
		
		gdfsuezBefCalypsoPrestaGaz.Dependency port = new gdfsuezBefCalypsoPrestaGaz.Dependency();
		SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
		port.clientCertName_x = octopusCS.certName__c;
		//port.endpoint_x = octopusCS.endpoint__c + 'ES-PrestationServiceGaz_v2';
		port.endpoint_x =  'callout:AuthOctopus/ES-PrestationServiceGaz_v2';
		System.debug('*** endpoint : ' + port.endpoint_x);
		port.inputHttpHeaders_x = new Map < String, String > {
			'Content-Type' => 'text/xml;charset=utf-8'
				};
					
					gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOfflineInputDt input = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOfflineInputDt();
		
		// Type offre
		input.typeoffre = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.typeoffre.code = 'INDUSTRIELLE';
		
		// Donnees générales
		input.donneesGenerales = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOfflineInputDt_donneesGenerales_element();
		input.donneesGenerales.typePrestationService = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.donneesGenerales.idPrestationServiceDistributeur = idPrestation;
		input.donneesGenerales.typePrestationService.code = 'Z002';
		input.donneesGenerales.idPDLGaz = pce;
		input.donneesGenerales.idPersonne = idBp;
		input.donneesGenerales.idContrat =  (String) inputMap.get('idContrat');
		input.donneesGenerales.idPersonneResponsable =  service.getIdentifiantSAPFromApex() ;//'143030';
		
		input.donneesGenerales.codePrestation = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.donneesGenerales.codePrestation.code = codePresta;
		
		gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOfflineResponse_element response;
		
		if (!Test.isRunningTest()) {
			response = port.CreerPrestationServiceGazOffline_Http(input, octx);
		} else {
			Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPrestaGazHttpMock());
			gdfsuezBefCalypsoPrestaGaz.Dependency porttest = new gdfsuezBefCalypsoPrestaGaz.Dependency();
			system.debug('@@ start of mock');
			response = porttest.CreerPrestationServiceGazOffline_Http(input, octx);
			system.debug('@@ end of mock');
		}
		
		System.debug('**** response : ' + response);
		System.debug('**** response code : ' + response.messageRetours.retourTraitementMessage[0].code);
		
		outMap.put('recol_gaz_ret', response.messageRetours.retourTraitementMessage[0].code);
		if('OCTOPUS_CreerPrestationServiceGazOffline_01'.equals(response.messageRetours.retourTraitementMessage[0].code)){
			Map<String,Object> ElementsToSerialize = new Map<String,Object>() ;
			ElementsToSerialize.put( 'id', (String) ((Map<String,Object>) inputMap.get('PrestationDistriGaz')).get('id')) ;     
			ElementsToSerialize.put( 'idPrestationServiceFournisseur', null) ;      
			ElementsToSerialize.put( 'idPrestationServiceDistributeur', idPrestation) ;     
			ElementsToSerialize.put( 'dateSouhaite', null) ;        
			string jsonString = JSON.serializePretty(ElementsToSerialize);      
			updateOPS(jsonString) ;
		}
		outMap.put( 'addresseConcernee', !isBillingAddressSameAsLiving ? ((String) elements1.get('selectedAdrConsFormula')) : (string) adressContact.get('NoVoie') +' '+ (string) adressContact.get('BillingAddress'));
		outMap.put('idPrestationDistributeurGaz',idPrestation);
		
		System.debug('**** OUT creerPrestationGaz');
	}
	
	/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: vlocity invoking method lirePrestationGazOnline
*/
	public void lirePrestationGazOnline(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		System.debug('**** IN lirePrestationGazOnline');
		
		System.debug('*** Params');
		
		for (String aKey: inputMap.keyset()) {
			System.debug(aKey + ' : ' + inputMap.get(aKey));
		}
		
		String idPrestationDistributeur = String.valueOf(inputMap.get('idPrestationDistributeur'));
		String idPrestationFournisseur = String.valueOf(inputMap.get('idPrestationFournisseur'));
		//idPrestationDistributeur = 'W00005B7';
		String typeCard = String.valueOf(inputMap.get('TypeCard'));
		String typeUser= String.valueOf(inputMap.get('TypeUser'));
		
		
		system.debug('@SM AP30 : idPrestationDistributeur : ' + idPrestationDistributeur);
		system.debug('@SM AP30 : TypeCard : ' + typeCard);
		
		if (String.isBlank(idPrestationDistributeur) || typeCard != 'GAZ') {
			System.debug('*** 1 or more fields required empty');
			return;
		}
		
		gdfsuezComBefChpPivotPrestaGaz.contextDt octx = initContext('Smile', '2.0');
		
		gdfsuezBefCalypsoPrestaGaz.Dependency port = new gdfsuezBefCalypsoPrestaGaz.Dependency();
		SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
		port.clientCertName_x = octopusCS.certName__c;
		port.endpoint_x = octopusCS.endpoint__c + 'ES-PrestationServiceGaz_v2';
		//port.endpoint_x = 'callout:AuthOctopus/ES-PrestationServiceGaz_v2';
		System.debug('*** endpoint : ' + port.endpoint_x);
		port.inputHttpHeaders_x = new Map < String, String > {
			'Content-Type' => 'text/xml;charset=utf-8'
				};
					
					gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt input = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt();
		
		input.online = true;
		
		
		// Donnees générales
		input.prestationServiceGaz = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt_prestationServiceGaz_element[1];
		input.prestationServiceGaz[0] = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt_prestationServiceGaz_element();
		input.prestationServiceGaz[0].idPrestationServiceDistributeur = idPrestationDistributeur;
		system.debug('input'+input);
		if(typeUser == 'Client') {
			input.loginUtilisateur = 'Digital_001_A040000001_DGP_SC@engie.com';
			input.typeOffre = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
			input.typeOffre.code = 'INDUSTRIELLE';
			input.prestationServiceGaz[0].idPrestationServiceFournisseur = idPrestationFournisseur;
		}
		else{
			input.loginUtilisateur = service.getIdentifiantDistribFromApex();
		}
		system.debug('input'+input);

		gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazResponse_element response;
		
		if (!Test.isRunningTest()) {
			response = port.LirePrestationServiceGaz_Http(input, octx);
		} 
		else {
			Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPrestaGazHttpMock());
			gdfsuezBefCalypsoPrestaGaz.Dependency porttest = new gdfsuezBefCalypsoPrestaGaz.Dependency();
			system.debug('@@ start of mock');
			response = porttest.LirePrestationServiceGaz_Http(input, octx);
			system.debug('@@ end of mock');
		}
		
		System.debug('**** response : ' + response);
		System.debug('**** response code : ' + response.messageRetours.retourTraitementMessage[0].code);
		
		outMap.put('code_retour_ops', response.messageRetours.retourTraitementMessage[0].code);
		
		if (response != null && response.lirePrestationServiceGazOutput != null && response.lirePrestationServiceGazOutput.prestationServiceLire.size() > 0) {
			outMap.putAll(transformDataFromReadOnline(inputMap, response.lirePrestationServiceGazOutput.prestationServiceLire[0]));
		}
		outMap.putAll(inputMap);
		
		System.debug('**** OUT lirePrestationGazOnline');
		
	}
	
	/*
* @Author: 
* @Date: 13/02/2019
* @Description: transformDataFromReadOnline
*/
	public static Map < String, Object > transformDataFromReadOnline(Map<String, Object> input, gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazOutputDt_prestationServiceLire_element response) {
		Map < String, Object > newOutputMap = new Map < String, Object > ();
		String typeUser= String.valueOf(input.get('TypeUser'));
		
		// Date prevue
		if (response.interventions != null && response.interventions.intervention != null && response.interventions.intervention.size() > 0) {
			
			String comments = response.interventions.intervention[0].commentaireIntervention;
			newOutputMap.put('commentaires', comments);
			
			
			String commentaireOffline =  (String) input.get('commentaires');
		 system.debug('commentaireOffline' + commentaireOffline );
			if (!String.isBlank(commentaireOffline ) && commentaireOffline .contains('PNO')) {
				newOutputMap.put('presence', '2');
			}
			else if (!String.isBlank(commentaireOffline ) && commentaireOffline .contains('PO')) {
				newOutputMap.put('presence', '1');
			}
			else if (!String.isBlank(commentaireOffline ) && commentaireOffline .contains('WSKO')) {
				newOutputMap.put('presence', '0');
			}
			
			if (response.interventions.intervention[0].planification != null) {
				
				gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazOutputDt_prestationServiceLire_interventions_intervention_planification_element node = response.interventions.intervention[0].planification;
				
				Datetime datetimePrevue = node.datePrevue;
				String heureDebut  = node.heureDebut;
				String heureFin  = node.heureFin;
				String interventionOPS = '';
				newOutputMap.put('datetimePrevue', datetimePrevue);
				
				if (Date.today().addDays(2) >= dateTimePrevue && dateTimePrevue > Date.today()) {
					newOutputMap.put('moins48h', '1');
				}
				else{
					newOutputMap.put('moins48h', '0');
				}
				
				//newOutputMap.put('datePrevue',  String.valueOf(datetimePrevue));
				if(datetimePrevue != null) {
					newOutputMap.put('datePrevue',String.valueOf(datetimePrevue.year()+'/'+datetimePrevue.month()+'/'+datetimePrevue.day()));
                }
				/*if(typeUser == 'Client') {
					newOutputMap.put('datePrevue',  String.valueOf(datetimePrevue));
				}
				else if(datetimePrevue != null) {
					
					if (Date.today().addDays(2) >= dateTimePrevue && dateTimePrevue > Date.today()) {
						newOutputMap.put('ops_48h', '1');
					}
					String day = String.valueOf(datetimePrevue.day());
					String month = String.valueOf(datetimePrevue.month());
					String year = String.valueOf(dateTimePrevue.year());
					
					if (datetimePrevue.day() < 10) {
						day = '0' + day;
					}
					if (datetimePrevue.month() < 10) {
						month = '0' + month;
					}
					newOutputMap.put('datePrevue', day + '/' + month + '/' + year);
				}*/
				
				//Définir avec ou sans intervention par rapport au valeur heureDebut et heureFin  , OMH 11/01/19
				if(!String.isBlank(heureDebut) && !String.isBlank(heureFin)) {
					interventionOPS = 'true';
				}
				newOutputMap.put('heureFin', heureFin);
				newOutputMap.put('heureDebut', heureDebut);
				newOutputMap.put('intervention', interventionOPS);
				
				if (node.creneauHoraire != null) {
					System.debug('*** CRENEAU : ' + node.creneauHoraire);
					newOutputMap.put('creneauRetenu', node.creneauHoraire.libelleCourt);
					newOutputMap.put('creneauRetenuCode', node.creneauHoraire.code);
				}
			}
			
		}
		
		newOutputMap.put('refExterne', response.idPrestationServiceDistributeur);
		newOutputMap.put('refInterne', response.idPrestationServiceFournisseur);
		
		String codeLibelle = '';
		
		if (response.donneesGenerales != null && response.donneesGenerales.donneesPDL != null) {
			
			//OMH 22/02 SMIL-2020
			if(typeUser =='client'){
				//codeLibelle = response.donneesGenerales.typePrestationService.code;
				codeLibelle = response.donneesGenerales.codePrestation.libelleCourt;
				System.debug('codelibelleGaz '+codeLibelle);
				if(codeLibelle.contains('MES')){
					newOutputMap.put('libelle', 'Mise en service dans votre nouveau logement');
				}
				else if(codeLibelle.contains('RES') || codeLibelle.contains('Résil')){
					newOutputMap.put('libelle', 'Coupure dans votre ancien logement');
				}
				else{
					newOutputMap.put('libelle', '');
				}
				
			}
			
			newOutputMap.put('pdl', response.donneesGenerales.donneesPDL.idPDLGaz);
			newOutputMap.put('idContrat' , response.donneesGenerales.idContrat);
		}
		
		newOutputMap.put('montant', (String) input.get('fraisPrestation'));
		
		System.debug('*** Return map : ' + newOutputMap);
		return newOutputMap;
	}
	
	/*
	* @Author: Omar MOHAMAD
	* @Date: 19/07/2019
	* @Description: vlocity invoking method annulerPrestationGaz
	*/
	public void annulerPrestationGaz(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		System.debug('*** IN annulerPrestationGaz');
		
		
		
		String idPrestationF = (String) inputMap.get('idF');
		String idPrestationD = (String) inputMap.get('idD');
		 
		outMap.put('updOps_code', '');
		
		if (String.isBlank(idPrestationF) || String.isBlank(idPrestationD)) {
			outMap.put('updOps_code', 'ERR_IDFD');
			System.debug('*** idPrestationF ou idPrestationD manquant');
			return;
		}
		
	   

		 gdfsuezComBefChpPivotPrestaGaz.contextDt octx = initContext('Smile', '2.0');
		
		gdfsuezBefCalypsoPrestaGaz.Dependency port = new gdfsuezBefCalypsoPrestaGaz.Dependency();
		SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
		port.clientCertName_x = octopusCS.certName__c;
		port.endpoint_x = octopusCS.endpoint__c + 'ES-PrestationServiceGaz_v2';
		System.debug('*** endpoint : ' + port.endpoint_x);
		port.inputHttpHeaders_x = new Map < String, String > {
			'Content-Type' => 'text/xml;charset=utf-8'
				};
	
		gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazInputDt input = new gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazInputDt();
		
		input.online = true;
		input.loginUtilisateur = service.getIdentifiantDistribFromApex();
		
		// Donnees générales
		input.typeOffre = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.typeOffre.code = 'INDUSTRIELLE';
		
		input.idPrestationServiceDistributeur = idPrestationD;
		input.idPrestationServiceFournisseur = idPrestationF;
		//input.idPrestationServiceDistributeur = '656565';
		//input.idPrestationServiceFournisseur = '65656565';
		
		input.action = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.action.code = 'ANNULER_OPS';
	   
		gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazResponse_element response;
		
		system.debug('input'+input);
		if (!Test.isRunningTest()) {
			try{
                response = port.ModifierPrestationServiceGaz_Http(input, octx);
            }
            catch (Exception e) {
                outMap.put('code_retour_ops', 'WSGazKO');
            	throw new IOException('Erreur Technique');
            }
		} else {
			Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPrestaGazHttpMock());
			gdfsuezBefCalypsoPrestaGaz.Dependency porttest = new gdfsuezBefCalypsoPrestaGaz.Dependency();
			system.debug('@@ start of mock');
			response = porttest.ModifierPrestationServiceGaz_Http(input, octx);
			system.debug('@@ end of mock');
		}
	   
		system.debug('code_retour_ops'+response.messageRetours.retourTraitementMessage[0].code);
		outMap.put('code_retour_ops', response.messageRetours.retourTraitementMessage[0].code);
		
		String code_retour_ops = response.messageRetours.retourTraitementMessage[0].code;
		if(code_retour_ops == 'OCTOPUS_ModifierPrestationServiceGaz_02' || code_retour_ops =='OCTOPUS_ModifierPrestationServiceGaz_99'){
			outMap.put('errorWS', true);
		}

		outMap.put('priseEnCompteDistributeurGaz',response.modifierPrestationServiceGazOutput.priseEnCompteDistributeur);
		
		system.debug('priseEnCompteDistributeurGaz'+response.modifierPrestationServiceGazOutput.priseEnCompteDistributeur);

		if(response.messageRetours.retourTraitementMessage[0].causedBy.libelle != null){
			outMap.put('info_distrib', response.messageRetours.retourTraitementMessage[0].causedBy.libelle);
			system.debug('causedBy'+  response.messageRetours.retourTraitementMessage[0].causedBy.libelle );
		}
		else{
			outMap.put('info_distrib','empty');
		}
	}
		
	/*
	* @Author: Mohamed Kchaou
	* @Date: 13/02/2019
	* @Description: vlocity invoking method updatePrestationGaz
	*/
	public void updatePrestationGaz(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options, String theActionCode) {
		System.debug('*** IN updatePrestationGaz');
		
		String typeUser= String.valueOf(inputMap.get('TypeUser'));
		
		Map < String, Object > opsUpdate = (Map < String, Object > ) inputMap.get('OPSUpdate');
		String nom = (String) opsUpdate.get('LastName');
		String prenom = (String) opsUpdate.get('FirstName');
		String civilite = (String) opsUpdate.get('Civility');
		String tel = (String) opsUpdate.get('PhoneNumber');
		String creneau = (String) opsUpdate.get('Creneau');
		String datePrevue = (String) opsUpdate.get('DateEffetSouhaite');
		String comments = (String) opsUpdate.get('EGDComment');
		/*String idPrestationF = (String) inputMap.get('idF');
		String idPrestationD = (String) inputMap.get('idD');*/
		String actionName = (String) inputMap.get('actionName');
		if(String.isBlank(comments)){
			comments = '-';
		}
	
		String idPrestationF = '';
		String idPrestationD = '';
		if(typeUser == 'Client'){
			
			idPrestationF= (String) opsUpdate.get('idF');
			idPrestationD = (String) opsUpdate.get('idD');   
		}
		else{
			idPrestationF = (String) inputMap.get('idF');
			idPrestationD = (String) inputMap.get('idD'); 
		}
		
		System.debug(opsUpdate);
		//idPrestationD = 'W00005B7';
		outMap.put('updOps_code', '');
		
		if (String.isBlank(nom)) {
			outMap.put('updOps_code', 'ERR_NAME');
			System.debug('*** Le nom pas rempli -> retourne une erreur');
			return;
		}
		
		gdfsuezComBefChpPivotPrestaGaz.contextDt octx = initContext('Smile', '2.0');
		
		gdfsuezBefCalypsoPrestaGaz.Dependency port = new gdfsuezBefCalypsoPrestaGaz.Dependency();
		SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
		port.clientCertName_x = octopusCS.certName__c;
		port.endpoint_x = octopusCS.endpoint__c + 'ES-PrestationServiceGaz_v2';
		System.debug('*** endpoint : ' + port.endpoint_x);
		port.inputHttpHeaders_x = new Map < String, String > {
			'Content-Type' => 'text/xml;charset=utf-8'
				};
	
		gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazInputDt input = new gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazInputDt();
		
		input.online = true;
		if(typeUser == 'Client') {
			input.loginUtilisateur = 'Digital_001_A040000001_DGP_SC@engie.com';
		}
		else{
			input.loginUtilisateur = service.getIdentifiantDistribFromApex();
		}
		
		system.debug('loginUtilisateur : '+input.loginUtilisateur);
		
		// Donnees générales
		input.typeOffre = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.typeOffre.code = 'INDUSTRIELLE';
		
		input.dateRdv = new gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazInputDt_dateRdv_element();
		System.debug(datePrevue);
		
		if(!String.isBlank(datePrevue)) {
			//Correction a tester pour selfcare
			Integer TimeZoneValue = Integer.valueOf(datePrevue.substringBetween('T', ':'));
			input.dateRdv.date_x = Datetime.newInstanceGmt(Integer.valueOf(datePrevue.substring(0,4)), Integer.valueOf(datePrevue.substring(5,7)), Integer.valueOf(datePrevue.substring(8,10)),TimeZoneValue,0,0);  
			//input.dateRdv.date_x = Datetime.newInstanceGmt(Integer.valueOf(datePrevue.substring(0, 4)), Integer.valueOf(datePrevue.substring(5, 7)), Integer.valueOf(datePrevue.substring(8, 10)));
		}
		
		input.dateRdv.creneauHoraire = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.dateRdv.creneauHoraire.code = creneau;
		
		input.contactIntervention = new gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazInputDt_contactIntervention_element();
		input.contactIntervention.identiteContact = new gdfsuezBefCalypsoPrestaGaz.identiteContactDt();
		input.contactIntervention.identiteContact.nom = nom;
		input.contactIntervention.identiteContact.prenom = prenom;
		System.debug('civilite'+ civilite);
		input.contactIntervention.identiteContact.civilite = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.contactIntervention.identiteContact.civilite.code = civilite;
		
		input.contactIntervention.coordonneesContact = new gdfsuezBefCalypsoPrestaGaz.coordonneesContactDt();
		input.contactIntervention.coordonneesContact.telephone = tel;
		
		input.contactIntervention.accesLocal = new gdfsuezBefCalypsoPrestaGaz.contactInterventionDt_accesLocal_element();
		input.contactIntervention.accesLocal.complement = comments;
		
		input.idPrestationServiceDistributeur = idPrestationD;
		input.idPrestationServiceFournisseur = idPrestationF;
		
		  //code accepterRdv if theActionCode = Accepter
		 System.debug('theActionCode '+ theActionCode);

		if(theActionCode == 'ACCEPTER'){
			system.debug('outMap '+outMap);
			input.dateRdv.heureDebut =  String.ValueOf(outMap.get('heureDebutModif'));
			input.dateRdv.heureFin = String.ValueOf(outMap.get('heureFinModif')); 
			system.debug('creneau '+ outMap.get('heureDebutModif') +outMap.get('heureFinModif'));
			System.debug('theActionCode accepted '+ theActionCode);
			input.accepterRdv = new gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazInputDt_accepterRdv_element();
			input.accepterRdv.optionExpress = False;
		}
		
		System.debug('theActionCode '+ actionName);
	   /*  if( 'NAVIGUER_PREC'.equals(actionName)   || 'NAVIGUER_SUIV'.equals(actionName) ){
			system.debug('NAVIGUER_PREC outMap '+outMap);
			input.dateRdv.heureDebut =  String.ValueOf(inputMap.get('heureDebutModif'));
			input.dateRdv.heureFin = String.ValueOf(inputMap.get('heureFinModif')); 
			system.debug('creneau '+ inputMap.get('heureDebutModif') +inputMap.get('heureFinModif'));
			System.debug('theActionCode accepted '+ theActionCode);
			input.accepterRdv = new gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazInputDt_accepterRdv_element();
			input.accepterRdv.optionExpress = False;
		}*/
		 
		if(!String.isBlank(actionName) && theActionCode != 'ACCEPTER'){
			theActionCode = actionName;
		}
		
		
		input.action = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		system.debug('theActionCode '+ theActionCode);
		input.action.code = theActionCode;
		
		gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazResponse_element response;
		
		if (!Test.isRunningTest()) {
			response = port.ModifierPrestationServiceGaz_Http(input, octx);
		} else {
			Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPrestaGazHttpMock());
			gdfsuezBefCalypsoPrestaGaz.Dependency porttest = new gdfsuezBefCalypsoPrestaGaz.Dependency();
			system.debug('@@ start of mock');
			response = porttest.ModifierPrestationServiceGaz_Http(input, octx);
			system.debug('@@ end of mock');
		}
		
		System.debug('**** response : ' + response.modifierPrestationServiceGazOutput);
		System.debug('**** response code : ' + response.messageRetours.retourTraitementMessage[0].code);
		System.debug('*** response.modifierPrestationServiceGazOutput : ' + response.modifierPrestationServiceGazOutput);
		System.debug('*** response.modifierPrestationServiceGazOutput.tableauDeCharges : ' + response.modifierPrestationServiceGazOutput.tableauDeCharges);
		
		if(typeUser == 'Client'){
			outMap.put('tableauDeCharge', response.modifierPrestationServiceGazOutput.tableauDeCharges);  
		}
		else{
			outMap.put('tableauDeChargeGaz', response.modifierPrestationServiceGazOutput.tableauDeCharges);  
		}
	   
		 /*if(response.messageRetours.retourTraitementMessage[0].causedBy != null){
			outMap.put('info_distrib', response.messageRetours.retourTraitementMessage[0].causedBy.libelle);
			//system.debug('causedBy'+  response.messageRetours.retourTraitementMessage[0].causedBy.libelle );
		}*/
							
		outMap.put('code_retour_ops', response.messageRetours.retourTraitementMessage[0].code);
		
		system.debug('planif ' +response.modifierPrestationServiceGazOutput.planificationIntervention);
		system.debug('dateDemandee ' +response.modifierPrestationServiceGazOutput.dateDemandee);
		
		if( response.modifierPrestationServiceGazOutput.planificationIntervention != null){
			
			outMap.put('datePrevueModif', response.modifierPrestationServiceGazOutput.planificationIntervention.datePrevue);

			String heureDebutModif = response.modifierPrestationServiceGazOutput.planificationIntervention.heureDebut;
			String heureFinModif = response.modifierPrestationServiceGazOutput.planificationIntervention.heureFin;
			
            if(theActionCode == 'ACCEPTER' ){
                if(String.isNotBlank(heureDebutModif) && String.isNotBlank(heureFinModif) ){
                    outMap.put('heureDebutModif', String.valueOf(heureDebutModif.substring(0,2)));
                    outMap.put('heureFinModif', String.valueOf(heureFinModif.substring(0,2)));
                }
                else
                {
                    outMap.put('heureDebutModif', '');
                    outMap.put('heureFinModif','');
                }
                 
            }
			else{
				outMap.put('heureDebutModif', heureDebutModif);
				outMap.put('heureFinModif', heureFinModif);
			}            
			system.debug('outmap' + outMap);
		}        
		system.debug('outmap' + outMap);
		
		if(!String.isBlank(theActionCode) && theActionCode != 'ACCEPTER' && outMap.get('code_retour_ops') == 'OCTOPUS_ModifierPrestationServiceGaz_07') {
			updatePrestationGaz(inputMap, outMap, options, 'ACCEPTER');
		}
		
		
		System.debug('*** OUT updatePrestationGaz');
	}
	
	public class IOException extends Exception {
		
	}
	
	
	/**
*
Cette classe represente un modele de prestation
*
* @param  url  an absolute URL giving the base location of the image
* @param  name the location of the image, relative to the url argument
* @return      the image at the specified URL
* @see         Image
*/
	Public class PrestationVente {
		
		public string Situation_de_vente;
		public string Secteur_d_activite;
		public string Type_de_compteur;
		public string Date_Refus_telereleve;
		public string Etat_compteur;
		public string MHs_en_cours;
		public string Fraude;
		public string DGI;
		public string ConsommationSansfournisseur;
		public string Etat_PDL_PCE;
		public string Date_du_jour_Prestation_distributeur_telereleve_sup_5;
		public string Urgent;
		//  public string Express;
		public string Choix_de_la_procedure_Autoreleve_ou_Gaz_Autoreleve_Obligatoire;
		public string Choix_de_la_procedure_egal_Reprise_d_index_MHS;
		public string Choix_de_la_procedure_Intervention_OU_Gaz_Intervention_obligatoire_coche_sur_OPS;
		public string Code_prestation;
		public string Libelle_code_prestation;
		
		
		// **********************//
		//
		public boolean Should_Test_Situation_de_vente = true;
		public boolean Should_Test_Secteur_d_activite = true;
		public boolean Should_Test_Type_de_compteur = true;
		public boolean Should_Test_Date_Refus_telereleve = true;
		public boolean Should_Test_Etat_compteur = true;
		public boolean Should_Test_MHs_en_cours = true;
		public boolean Should_Test_Fraude = true;
		public boolean Should_Test_DGI = true;
		public boolean Should_Test_ConsommationSansfournisseur = true;
		public boolean Should_Test_Etat_PDL_PCE = true;
		public boolean Should_Test_Date_du_jour_Prestation_distributeur_telereleve_sup_5 = true;
		public boolean Should_Test_Urgent = true;
		//  public boolean Should_Test_Express= true ;
		public boolean Should_Test_Choix_de_la_procedure_Autoreleve_ou_Gaz_Autoreleve_Obligatoire = true;
		public boolean Should_Test_Choix_de_la_procedure_egal_Reprise_d_index_MHS = true;
		public boolean Should_Test_Choix_de_la_procedure_Intervention_OU_Gaz_Intervention_obligatoire_coche_sur_OPS = true;
		
		//*******************
		
		
		/** surcharge de la methode toString()
*

* @return  String  revoi la representation sous forme de chaine de carachtere de l'instance de l'objet
* @see
*/
		override public String toString() {
			return 'Situation_de_vente=' + Situation_de_vente + ',' +
				'Secteur_d_activite=' + Secteur_d_activite + ',' +
				' Type_de_compteur=' + Type_de_compteur + ',' +
				' Date_Refus_telereleve=' + Date_Refus_telereleve + ',' +
				' Etat_compteur=' + Etat_compteur + ',' +
				' MHs_en_cours=' + MHs_en_cours + ',' +
				'Fraude=' + Fraude + ',' +
				'DGI=' + DGI + ',' +
				'Etat_PDL_PCE=' + Etat_PDL_PCE + ',' +
				'Date_du_jour_Prestation_distributeur_telereleve_sup_5=' + Date_du_jour_Prestation_distributeur_telereleve_sup_5 + ',' +
				'Urgent=' + Urgent + ',' +
				//    'Express='+ Express  +','+
				'Choix_de_la_procedure_Autoreleve_ou_Gaz_Autoreleve_Obligatoire=' + Choix_de_la_procedure_Autoreleve_ou_Gaz_Autoreleve_Obligatoire + ',' +
				'Choix_de_la_procedure_egal_Reprise_d_index_MHS=' + Choix_de_la_procedure_egal_Reprise_d_index_MHS + ',' +
				'Choix_de_la_procedure_Intervention_OU_Gaz_Intervention_obligatoire_coche_sur_OPS=' + Choix_de_la_procedure_Intervention_OU_Gaz_Intervention_obligatoire_coche_sur_OPS + ',' +
				'Code_prestation=' + Code_prestation + ',' +
				'Libelle_code_prestation=' + Libelle_code_prestation;
		}
		
		
		public PrestationVente() {
		}
		
		public PrestationVente(string Situation_de_vente,
							   string Secteur_d_activite,
							   string Type_de_compteur,
							   string Date_Refus_telereleve,
							   string Etat_compteur,
							   string MHs_en_cours,
							   string Fraude,
							   string DGI,
							   string ConsommationSansfournisseur,
							   string Etat_PDL_PCE,
							   string Date_du_jour_Prestation_distributeur_telereleve_sup_5,
							   string Urgent,
							   //   string Express,
							   string Choix_de_la_procedure_Autoreleve_ou_Gaz_Autoreleve_Obligatoire,
							   string Choix_de_la_procedure_egal_Reprise_d_index_MHS,
							   string Choix_de_la_procedure_Intervention_OU_Gaz_Intervention_obligatoire_coche_sur_OPS,
							   string Code_prestation,
							   string Libelle_code_prestation) {
								   
								   
								   this.Situation_de_vente = Situation_de_vente;
								   this.Secteur_d_activite = Secteur_d_activite;
								   this.Type_de_compteur = Type_de_compteur;
								   this.Date_Refus_telereleve = Date_Refus_telereleve;
								   this.Etat_compteur = Etat_compteur;
								   this.MHs_en_cours = MHs_en_cours;
								   this.Fraude = Fraude;
								   this.DGI = DGI;
								   this.ConsommationSansfournisseur = ConsommationSansfournisseur;
								   this.Etat_PDL_PCE = Etat_PDL_PCE;
								   this.Date_du_jour_Prestation_distributeur_telereleve_sup_5 = Date_du_jour_Prestation_distributeur_telereleve_sup_5;
								   this.Urgent = Urgent;
								   // this.Express= Express  ;
								   this.Choix_de_la_procedure_Autoreleve_ou_Gaz_Autoreleve_Obligatoire = Choix_de_la_procedure_Autoreleve_ou_Gaz_Autoreleve_Obligatoire;
								   this.Choix_de_la_procedure_egal_Reprise_d_index_MHS = Choix_de_la_procedure_egal_Reprise_d_index_MHS;
								   this.Choix_de_la_procedure_Intervention_OU_Gaz_Intervention_obligatoire_coche_sur_OPS = Choix_de_la_procedure_Intervention_OU_Gaz_Intervention_obligatoire_coche_sur_OPS;
								   this.Code_prestation = Code_prestation;
								   this.Libelle_code_prestation = Libelle_code_prestation;
								   
							   }
		
		/**
* cette methode     permet de specifier la liste des champs à tester , dans le cas que la valeur est egal à NA  faut ignorer le test .
* @return  PrestationVente  renvoi l'instance courantant de l'objet
* @see
*/
		
		public PrestationVente BuildWhatFieldShouldBeTested() {
			
			
			
			if (Situation_de_vente.equals('NA')) {
				Should_Test_Situation_de_vente = false;
			}
			
			if (Secteur_d_activite.equals('NA')) {
				Should_Test_Secteur_d_activite = false;
			}
			if (Type_de_compteur.equals('NA')) {
				Should_Test_Type_de_compteur = false;
			}
			if (Date_Refus_telereleve.equals('NA')) {
				Should_Test_Date_Refus_telereleve = false;
			}
			if (Etat_compteur.equals('NA')) {
				Should_Test_Etat_compteur = false;
			}
			if (MHs_en_cours.equals('NA')) {
				Should_Test_MHs_en_cours = false;
			}
			if (Fraude.equals('NA')) {
				Should_Test_Fraude = false;
			}
			if (DGI.equals('NA')) {
				Should_Test_DGI = false;
			}
			if (ConsommationSansfournisseur.equals('NA')) {
				Should_Test_ConsommationSansfournisseur = false;
			}
			if (Etat_PDL_PCE.equals('NA')) {
				Should_Test_Etat_PDL_PCE = false;
			}
			if (Date_du_jour_Prestation_distributeur_telereleve_sup_5.equals('NA')) {
				Should_Test_Date_du_jour_Prestation_distributeur_telereleve_sup_5 = false;
			}
			if (Urgent.equals('NA')) {
				Should_Test_Urgent = false;
			}
			//  if(Express.equals('NA')){Should_Test_Express =false;}
			if (Choix_de_la_procedure_Autoreleve_ou_Gaz_Autoreleve_Obligatoire.equals('NA')) {
				Should_Test_Choix_de_la_procedure_Autoreleve_ou_Gaz_Autoreleve_Obligatoire = false;
			}
			if (Choix_de_la_procedure_egal_Reprise_d_index_MHS.equals('NA')) {
				Should_Test_Choix_de_la_procedure_egal_Reprise_d_index_MHS = false;
			}
			if (Choix_de_la_procedure_Intervention_OU_Gaz_Intervention_obligatoire_coche_sur_OPS.equals('NA')) {
				Should_Test_Choix_de_la_procedure_Intervention_OU_Gaz_Intervention_obligatoire_coche_sur_OPS = false;
			}
			return this;
			
		}
		
		
		/**
* Cette methode  permet de comparer si le model en entré correspond ou pas à un element de la matrice des prestations
*
* @param  objects   prestation

* @return  boolean  true si la pretation construite en entrée est egal à l'objet PrestationVente courant , false sinon
* @see
*/
		public boolean equals(PrestationVente objects) {
			
			if (objects == null) {
				return false;
			}
			return ((!Should_Test_Situation_de_vente) || Situation_de_vente.equalsIgnoreCase(objects.Situation_de_vente)) &&
				((!Should_Test_Etat_PDL_PCE) || Etat_PDL_PCE.equalsIgnoreCase(objects.Etat_PDL_PCE)) &&
				((!Should_Test_Secteur_d_activite) || Secteur_d_activite.equalsIgnoreCase(objects.Secteur_d_activite)) &&
				((!Should_Test_Type_de_compteur) || Type_de_compteur.equalsIgnoreCase(objects.Type_de_compteur)) &&
				((!Should_Test_Date_Refus_telereleve) || Date_Refus_telereleve.equalsIgnoreCase(objects.Date_Refus_telereleve)) &&
				((!Should_Test_Etat_compteur) || Etat_compteur.equalsIgnoreCase(objects.Etat_compteur)) &&
				((!Should_Test_MHs_en_cours) || MHs_en_cours.equalsIgnoreCase(objects.MHs_en_cours)) &&
				((!Should_Test_Fraude) || Fraude.equalsIgnoreCase(objects.Fraude)) &&
				((!Should_Test_DGI) || DGI.equalsIgnoreCase(objects.DGI)) &&
				((!Should_Test_ConsommationSansfournisseur) || ConsommationSansfournisseur.equalsIgnoreCase(objects.ConsommationSansfournisseur)) &&
				((!Should_Test_Date_du_jour_Prestation_distributeur_telereleve_sup_5) || Date_du_jour_Prestation_distributeur_telereleve_sup_5.equalsIgnoreCase(objects.Date_du_jour_Prestation_distributeur_telereleve_sup_5)) &&
				(!Should_Test_Urgent || Urgent.equalsIgnoreCase(objects.Urgent)) &&
				//    ( (!Should_Test_Express )    || Express.equalsIgnoreCase(objects.Express)) &&
				((!Should_Test_Choix_de_la_procedure_Autoreleve_ou_Gaz_Autoreleve_Obligatoire) || Choix_de_la_procedure_Autoreleve_ou_Gaz_Autoreleve_Obligatoire.equalsIgnoreCase(objects.Choix_de_la_procedure_Autoreleve_ou_Gaz_Autoreleve_Obligatoire)) &&
				((!Should_Test_Choix_de_la_procedure_egal_Reprise_d_index_MHS) || Choix_de_la_procedure_egal_Reprise_d_index_MHS.equalsIgnoreCase(objects.Choix_de_la_procedure_egal_Reprise_d_index_MHS)) &&
				((!Should_Test_Choix_de_la_procedure_Intervention_OU_Gaz_Intervention_obligatoire_coche_sur_OPS) || Choix_de_la_procedure_Intervention_OU_Gaz_Intervention_obligatoire_coche_sur_OPS.equalsIgnoreCase(objects.Choix_de_la_procedure_Intervention_OU_Gaz_Intervention_obligatoire_coche_sur_OPS));
		}
		
	}
	
	public static String calculerOptionPrestation(Map < String, Object > inputMap, Map < String, Object > PrestationDistriGaz, Map < String, Object > pdlinfo, boolean interventionObligatoire, boolean choixProcedureAutoReleve ,boolean telereleve,String contexte,String mhsEncours,String choixDeProcedure) {
		try {

			if(interventionObligatoire)
			return '1';

			if(mhsEncours.equalsIgnoreCase('true')){
              
			  if(choixDeProcedure.equals('Autorelève'))
                return '9';

              if(choixDeProcedure.equals('Intervention'))
                return '1';

			}
			
	        if (((boolean) inputMap.get('GazAbsenceindexdepuis5jours'))  || telereleve )  
			return '12' ; 
			
			if(choixProcedureAutoReleve  && contexte.equals('Emménagement') )
			 return '2' ; 
			
			if(choixProcedureAutoReleve  && contexte.equals('Changement de fournisseur') ) 
			return '3' ;
			
			if(((boolean) PrestationDistriGaz.get('reprisedernierIndex')) == true && ((String) PrestationDistriGaz.get('Index')).equals(pdlinfo.get('valeurIndexMiseHorsService')))
			return '4' ;
			
			if(((boolean) PrestationDistriGaz.get('reprisedernierIndex')) == true && !((String) PrestationDistriGaz.get('Index')).equals(pdlinfo.get('valeurIndexMiseHorsService')))
			return '9' ;
             
			return null;
		} catch (Exception e) {
			throw new IOException('Probleme survenue au moment du calcul d\'option prestation');
		}
	}
	
	
	/**
* Une methode qui permet d'initialiser les codes prestations depuis le customMetaData SM_CalculPrestationMatrice__mdt
*
* @return  List<PrestationVente> renvoi la liste des Prestations trouvées  dans le Custom metaData SM_CalculPrestationMatrice__mdt et les mappant en une liste de  model PrestationVente
* @see
*/
	public static List < PrestationVente > intialiseCodesPrestation() {
		system.debug('##initialise##');
		listPret.clear();
		
		SM_CalculPrestationMatrice__mdt[] listOfRecords = [SELECT Situation_de_vente__c, Secteur_activite__c,
														   Type_de_compteur__c, Date_refus_telereleve__c,
														   Etat_compteur__c, MHs_en_cours__c, Fraude__c,
														   DGI__c, ConsommationSansfournisseur__c, Etat_PDL_PCE__c, Telereleve_sup_5__c,
														   Urgent__c, Express__c, Proc_Autorel_ou_Autorel_Oblig__c, Choix_Proc_Egal_Repri_MHS__c,
														   Choix_Proc_intev_ou_gaz_interv_ops__c, Code_prestation__c, Libelle_code_prestation__c FROM SM_CalculPrestationMatrice__mdt
														  ];
		
		if (listOfRecords == null) {
			system.debug('##No records##');
			return null;
		}
		
		for (SM_CalculPrestationMatrice__mdt record: listOfRecords) {
			listPret.add(new PrestationVente(record.Situation_de_vente__c, record.Secteur_activite__c, record.Type_de_compteur__c, record.Date_refus_telereleve__c,
											 record.Etat_compteur__c,
											 record.MHs_en_cours__c, record.Fraude__c, record.DGI__c, record.ConsommationSansfournisseur__c, record.Etat_PDL_PCE__c, record.Telereleve_sup_5__c,
											 record.Urgent__c, record.Proc_Autorel_ou_Autorel_Oblig__c, record.Choix_Proc_Egal_Repri_MHS__c,
											 record.Choix_Proc_intev_ou_gaz_interv_ops__c, record.Code_prestation__c, record.Libelle_code_prestation__c)
						 .BuildWhatFieldShouldBeTested());
		}
		//  system.debug(listPret);
		system.debug('##end of initialise##');
		return listPret;
		/*
// liste des prestation
listPret.add(new PrestationVente('Emmenagement','Gaz','Gazpar','NA','coupe','False','NA','True','NA','NA','NA','NA','NA','NA','NA','NA','200110','Gaz:MES avec retablissement').BuildWhatFieldShouldBeTested()) ;

*/
		
	}
	
	/**
* Une methode qui permet de creeer une prestation dans SAP en mode online
*
* @param  inputMap  la liste des parametres d'entrées de l'omniscript
* @param  outMap  la liste des parametres de sorties de l'omniscript
@param  options  les options passées dans l'omniscript
* @return  Void
* @see
*/
	public static void creerPrestationGazOnline(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options,String action,String dateDebut,String dateFin) {
		
			System.debug('**** IN creerPrestationGaz');
			System.debug('*** Input params : ' + Json.serialize(inputMap));
			String DateEffetSouhaiteGaz = (String) inputMap.get('DateEffetSouhaiteGaz')  ;   //  InformationsdeprestationGaz.get('DateEffetSouhaiteGaz') 
            system.debug('DateEffetSouhaiteGaz '+DateEffetSouhaiteGaz);
			String pce = (String)((Map < String, Object > ) inputMap.get('pdlinfo')).get('idPdl')  ;
             system.debug('pce '+pce);
		     String choixProcedure ;
			 if(!String.isBlank((String)inputMap.get('choixProcedure'))){
			 choixProcedure=(String) inputMap.get('choixProcedure')  ; // ChoixElements.chooseSellingOption
			 system.debug('choixProcedure '+choixProcedure);
			 }else{
             choixProcedure = (String) inputMap.get('repriseMHS') ;
			 }
	    
			String choixProcedureMHS = (String) inputMap.get('repriseMHS') ;
        system.debug('choixProcedureMHS '+choixProcedureMHS);
			String idBp = inputMap != null ? (String) inputMap.get('refClientIdBP') : null;
        system.debug('idBp '+idBp);
		        Map<String,Object>	PrestationDistriGaz = (Map<String,Object>) inputMap.get('PrestationDistriGaz')  ;
		system.debug('PrestationDistriGaz '+PrestationDistriGaz);
			boolean choixProcedureIntevention = ((boolean) inputMap.get('InterventionGazObligatoire')) == true|| (choixProcedure != null &&  choixProcedure.equals('Intervention')) ;
		system.debug('choixProcedureIntevention '+choixProcedureIntevention);	
        Boolean  choixProcedureAutoReleve =   ((boolean) inputMap.get('autoreleveObligatoire')) == true ||(((boolean) PrestationDistriGaz.get('autoreleveFacultative')) &&    choixProcedure != null &&  choixProcedure.equals('Autorelève'))  ;
		system.debug('choixProcedureAutoReleve '+choixProcedureAutoReleve);	
        String  CreaneauGaz = (String)  inputMap.get('CreaneauGaz') ;
		system.debug('CreaneauGaz '+CreaneauGaz);

        String 	idContrat = (String) inputMap.get('idContrat')  ;
		system.debug('idContrat '+idContrat);
        Map<String,Object> contactInfos = (Map<String,Object>) inputMap.get('contactInfos')  ;
		system.debug('contactInfos '+contactInfos);
			String context = (String) inputMap.get('contexte')  ;
		system.debug('context '+context);
        Map<String,Object> BlockInterventionGaz = (Map<String,Object>) inputMap.get('BlockInterventionGaz')  ;
		system.debug('BlockInterventionGaz '+BlockInterventionGaz);
        String natureDemande = context.equals('Emménagement') ? 'MES' : context.equals('Changement de fournisseur')	? 'CHF' :'' ; // (!String.isBlank((String) elements.get('chooseSellingOption')) && ((String) elements.get('chooseSellingOption')).equals('Emménagement')) ? 'MES' : (!String.isBlank((String) elements.get('chooseSellingOption')) && ((String) elements.get('chooseSellingOption')).equals('Changement de fournisseur')) ? 'CHF' : ''; // MES /CFN
			//(((Map<String,Object>)((Map<String,Object>)inputMap.get('PrestationGaz')).get('InformationsdeprestationGaz')).get('DemandeUrgente')  != null &&
							//						   ((String) ((Map<String,Object>)((Map<String,Object>)inputMap.get('PrestationGaz')).get('InformationsdeprestationGaz')).get('DemandeUrgente')).equals('Engie') ) ? 'ENGIE' :  'CLIENT';
		system.debug('natureDemande '+natureDemande);
        Map<String,Object> coordonneContact = (Map<String,Object>) inputMap.get('coordonneContact')  ;    // element.TelMobile
		
        system.debug('coordonneContact '+coordonneContact);
        String IndexGaz = String.isBlank(String.valueOf(inputMap.get('IndexGaz'))) ? null : String.valueOf(inputMap.get('IndexGaz')) ;    // blockAut
		system.debug('IndexGaz '+IndexGaz);
        String CAR = String.valueOf(inputMap.get('CAR')) ;     
		
        system.debug('CAR '+CAR);
        String origineDemande = (String ) inputMap.get('origineDemande') ;  // (!String.isBlank((String) elements.get('chooseSellingOption')) && ((String) elements.get('chooseSellingOption')).equals('Emménagement')) ? 'MES' : (!String.isBlank((String) elements.get('chooseSellingOption')) && ((String) elements.get('chooseSellingOption')).equals('Changement de fournisseur')) ? 'CHF' : ''; // MES /CFN
		system.debug('origineDemande '+origineDemande);	
        String selectedAdrConsFormula  = (String) inputMap.get('selectedAdrConsFormula'); // choixElecment.selectedAdrConsFormula		
		system.debug('selectedAdrConsFormula '+selectedAdrConsFormula);
        Map<String,Object> selectedAdresseElements  = fillSelectedAdressElements(inputMap) ;  //  ChoixElements1.get('postcodeValue')   ChoixElements1.get('libelleVoieValue')   ChoixElements1.get('nVoieValue') (String)ChoixElements1.get('cityValue')   l'adresse selectionnée
		system.debug('selectedAdresseElements '+selectedAdresseElements);
        Map<String,Object>  adressContact = (Map<String,Object>) inputMap.get('adressContact');  // elements.get('AdresseContact'); info du contact sur la fiche contact 
		system.debug('adressContact '+adressContact);
        boolean  demandeUrgent = (boolean) inputMap.get('demandeUrgent');      //InformationsdeprestationGaz.get('DemandeUrgente')
		system.debug('demandeUrgent '+demandeUrgent);
        Boolean isBillingAddressSameAsLiving =  (boolean) inputMap.get('isBillingAddressSameAsLiving').equals('Oui') ; // ((String)((Map < String, Object > ) ChoixElements1.get('Address')).get('isBillingAddressSameAsLiving')).equals('Oui');
		system.debug('isBillingAddressSameAsLiving '+isBillingAddressSameAsLiving);
        boolean repriseMHS =   choixProcedureMHS == null ? false :  choixProcedureMHS.equals('Reprise MHS')  ;//prestationGazStep.get('ChoixProcedureGAZMHS') == null ? 'Empty' : String.valueOf(prestationGazStep.get('ChoixProcedureGAZMHS') != null && ((String) prestationGazStep.get('ChoixProcedureGAZMHS')).equals('Reprise MHS'));
		system.debug('repriseMHS '+repriseMHS);
        Map < String, Object > pdlinfo = (Map < String, Object > ) inputMap.get('pdlinfo');	
		system.debug('pdlinfo '+pdlinfo);
        boolean  telereleve = (boolean) PrestationDistriGaz.get('telereleveObligatoire'); // US SMIL-2721
           system.debug('telereleve '+telereleve);
        String  actionName = (String) inputMap.get('actionName'); // US SMIL-2721
           system.debug('actionName '+actionName);
        String  mhsEncours = pdlinfo.get('miseHorsServiceEnCours') == null ? 'False' : String.valueOf(pdlinfo.get('miseHorsServiceEnCours')); 
       system.debug('mhsEncours '+mhsEncours);
		if (String.isBlank(pce) || String.isBlank(idBp) ) {
			System.debug('*** 1 or more fields required empty');
			throw new IOException('Veuillez saisir les elements qui manquent !') ;
            }

			if (String.isBlank(DateEffetSouhaiteGaz)) {
			System.debug('*** 1 or more fields required empty');
			throw new IOException('La date d\'effet souhaité est vide veuillez la saisir !') ;
            }

        // check sur le creneau ne doit pas vide 
		if(choixProcedureIntevention){
            if(String.isBlank(CreaneauGaz)){
            throw new IOException('Veuillez saisir le créneau souhaité !') ;  
            }
        }

		
		
		gdfsuezComBefChpPivotPrestaGaz.contextDt octx = initContext('Smile', '2.0');
		
		gdfsuezBefCalypsoPrestaGaz.Dependency port = new gdfsuezBefCalypsoPrestaGaz.Dependency();
		
		//port.endpoint_x = SM_OCTOPUS__c.getOrgDefaults().endpoint__c + 'ES-PrestationServiceGaz_v2';
		port.endpoint_x =  'callout:AuthOctopus/ES-PrestationServiceGaz_v2';
		System.debug('*** endpoint : ' + port.endpoint_x);
		port.inputHttpHeaders_x = new Map < String, String > {
			'Content-Type' => 'text/xml;charset=utf-8'
				};
					
					gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt input = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt();
		
	
		
		input.action = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.action.code = action; // premier appel
		// Type offre
		input.typeoffre = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.typeoffre.code = 'INDUSTRIELLE';
		
		// Donnees générales
		input.donneesGenerales = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_donneesGenerales_element();
		input.donneesGenerales.typePrestationService = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.donneesGenerales.typePrestationService.code = 'Z002';
		input.donneesGenerales.idPDLGaz = pce;
		input.donneesGenerales.idPersonne = idBp;
		String idContract = (String) inputMap.get('idContrat');
		input.donneesGenerales.idContrat = idContract ;
		input.donneesGenerales.idPersonneResponsable =  service.getIdentifiantSAPFromApex() ;//'143030';


		//RJM 18/02/2020 Passage de l'input 'OrigineDemande' au lieu de 'demandeUrgent' (FT2-364)
		PrestationVente prestation = buildeCodePrestation(PrestationDistriGaz, pdlinfo, context, origineDemande, choixProcedureIntevention, repriseMHS, inputMap,choixProcedureAutoReleve);
		//
        system.debug('input prestation =>' + prestation);
		if (prestation == null) {
			if(!Test.isRunningTest())
				throw new IOException('probleme technique survenu au moment de la construction du code prestation');
		}
		prestation = getCodePrestation(prestation);
		if (prestation == null) {
			if(!Test.isRunningTest())
				throw new IOException('aucun code prestation trouvé dans la matrice de calcul de prestation par rapport rapport aux parametres choisis dans l OS ');
		}
		system.debug('output prestation =>' + prestation);
		input.donneesGenerales.codePrestation = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.donneesGenerales.codePrestation.code =  prestation == null ? null : prestation.Code_prestation; //getCodePrestation(prestation);
		input.donneesGenerales.natureDemande = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.donneesGenerales.natureDemande.code = natureDemande ;
		
		input.donneesGenerales.optionPrestation = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.donneesGenerales.optionPrestation.code = calculerOptionPrestation(inputMap, PrestationDistriGaz, pdlinfo, choixProcedureIntevention, choixProcedureAutoReleve,telereleve,context,mhsEncours,choixProcedure);
		input.donneesGenerales.origineDemande =   origineDemande ;
		
		
		// input.donneesGenerales.online = true;
		input.donneesGenerales.loginUtilisateur = service.getIdentifiantDistribFromApex();
		
		// dateRdv
		
		input.dateRdv = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_dateRdv_element();
		input.dateRdv.date_x = Datetime.valueOf(DateEffetSouhaiteGaz+ ' 00:00:00').addDays(1).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
		
		if(action.equals('ACCEPTER') || 'PROPOSER'.equals(action) || 'NAVIGUER_PREC'.equals(action)   || 'NAVIGUER_SUIV'.equals(action)  ) {
			
			input.dateRdv.heureDebut = dateDebut;
			input.dateRdv.heureFin = dateFin;
		}
		
		
		// Utilisateur final: selon US-1444 il faut renseigner la balise utilisateur final  doit dans le premier appel (action CREER)
		//  06/02/19
		if(action.equals('CREER')) {
			input.utilisateurFinal = fillUtilisateurFinal(contactInfos);
		}
		
		//  contact  Courrier
		
		// Utilisateur courrier : selon US-1444 il faut renseigner la balise contact courrier  doit dans le premier appel (action CREER)
		//  06/02/19
		if(action.equals('CREER')) {
			input.contactCourrier = fillcontactCourrier(contactInfos,coordonneContact,selectedAdresseElements,adressContact,isBillingAddressSameAsLiving,choixProcedureIntevention,BlockInterventionGaz);
		}    




		
		// la balise contact intervention :  selon US-1444 il faut renseigner la balise contact courrier  doit dans le premier appel (action CREER)
		if(action.equals('CREER') || action.equals('PROPOSER') ) {
			input.contactIntervention = fillContactIntervention(BlockInterventionGaz,choixProcedureIntevention,contactInfos,coordonneContact);
		}
		if(!action.equals('CREER')) {
			// la balise contact idPrestationServiceDistributeur :  selon US-1444 il faut renseigner la balise idPrestation distributeur  doit etre  dans tout les  appels sauf le premier  (action CREER)
			input.donneesGenerales.idPrestationServiceDistributeur  = (String)inputMap.get('idPrestationServiceDistributeuGaz');
			// idPrestation
		}
		
		if (choixProcedureIntevention) {
			
			if( !String.isBlank(CreaneauGaz)) {
				input.dateRdv.creneauHoraire = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
				input.dateRdv.creneauHoraire.code = CreaneauGaz ;
			}
			
			
		}
		// cahngement de fournisseur
		//
		//
		
		if (context.equals('Changement de fournisseur') && !action.equals('ABANDONNER_OPS')) { // ajout de la condition !action.equals('ABANDONNER_OPS') dans le cadre de l'us  SMIL-682
			input.changementFournisseur = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_changementFournisseur_element();
			if (pdlinfo.get('fta') != null) {
				input.changementFournisseur.tarifAcheminement = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
				input.changementFournisseur.tarifAcheminement.code = (String) pdlinfo.get('fta');
			} else {
				throw new IOException('Tarif acheminement non trouvé,  la prestation gaz ne peut etre créee ! ');
			}
			if (pdlinfo.get('frequenceReleve') != null) {
				input.changementFournisseur.frequenceReleve = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
				input.changementFournisseur.frequenceReleve.code = (String) pdlinfo.get('frequenceReleve');
			} else {
				throw new IOException('frequenceReleve non trouvé,  la prestation gaz ne peut etre créee ! ');
			}
			input.changementFournisseur.offreHistorique = false;
			
			Date todayDate = Date.today();
            String octopusDateFormat = String.valueOf(todayDate).subString(0,10)+'T00:00:00';
			if(PrestationDistriGaz.get('indexCalcule') != null && ((boolean) PrestationDistriGaz.get('indexCalcule')) == true  )  {
				  // input.changementFournisseur.indexReleve =  new gdfsuezBefCalypsoPrestaGaz.indexDt();
				  // input.changementFournisseur.indexReleve.valeurIndex    =    String.valueOf(IndexGaz);
				   
				   //input.changementFournisseur.indexReleve.dateIndex =  octopusDateFormat ;// String.valueOf(todayDate).subString(0,10)+'T00:00:00';
			   }else if(!telereleve ){ // la structure index releve ne doit pas etre envoyer dans le cas d'un compteur telereleve
				   input.changementFournisseur.indexReleve =  new gdfsuezBefCalypsoPrestaGaz.indexDt();
				   input.changementFournisseur.indexReleve.valeurIndex   =PrestationDistriGaz.get('Index') != null ?  String.valueOf(PrestationDistriGaz.get('Index')): null ;
			  	   input.changementFournisseur.indexReleve.dateIndex =  octopusDateFormat ;// String.valueOf(todayDate).subString(0,10)+'T00:00:00';

			   }
			input.changementFournisseur.CAR =  new gdfsuezBefCalypsoPrestaGaz.CARDt();
			input.changementFournisseur.CAR.valeurCAR = CAR ;
			
			
			if(  IndexGaz != null  && ( telereleve   || ((boolean) inputMap.get('GazAbsenceindexdepuis5jours')) ) ){ // SMIL 1559
				input.changementFournisseur.indexClient =  new gdfsuezBefCalypsoPrestaGaz.indexDt();
				input.changementFournisseur.indexClient.valeurIndex    =    String.valueOf(IndexGaz);			
				input.changementFournisseur.indexClient.dateIndex =  octopusDateFormat; // String.valueOf(todayDate).subString(0,10)+'T00:00:00';
			}
		}
		
		if (context.equals('Emménagement') && !action.equals('ABANDONNER_OPS')) { // ajout de la condition !action.equals('ABANDONNER_OPS') dans le cadre de l'us  SMIL-682
			// mise ne service
			input.miseEnService = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_miseEnService_element();
			
			
			if(pdlinfo.get('fta') != null ) {
				input.miseEnService.tarifAcheminement = new  gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
				input.miseEnService.tarifAcheminement.code = (String) pdlinfo.get('fta');
			}else {
				throw new IOException('Tarif acheminement non trouvé,  la prestation gaz ne peut etre créee ! ');
			}
			
			
			
			if(pdlinfo.get('frequenceReleve') != null) {
				input.miseEnService.frequenceReleve = new  gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
				input.miseEnService.frequenceReleve.code = (String) pdlinfo.get('frequenceReleve');
			}else {
				throw new IOException('Frequence releve non trouvé, le la prestation gaz ne peut etre créee ! ');
			}
			
			
			input.miseEnService.offreHistorique = false;
			input.miseEnService.TICGN = false;
			// recupération de la CAr depuis le parcours 
			input.miseEnService.CAR =  new gdfsuezBefCalypsoPrestaGaz.CARDt();
			input.miseEnService.CAR.valeurCAR = String.valueOf(CAR);
			if( !telereleve &&  IndexGaz!= null &&
			  ( choixProcedureAutoReleve )
			  )  { // US 1264
				  input.miseEnService.indexReleve =  new gdfsuezBefCalypsoPrestaGaz.indexDt();
				  input.miseEnService.indexReleve.valeurIndex  =  String.valueOf(IndexGaz);
				  Date todayDate = Date.today();
				  input.miseEnService.indexReleve.dateIndex =   String.valueOf(todayDate).subString(0,10)+'T00:00:00';
			  }
			
			
			if(IndexGaz != null && 
			   (
			   ((PrestationDistriGaz.get('absenceindexdepuis5Jours') != null) &&  ((boolean) PrestationDistriGaz.get('absenceindexdepuis5Jours')))
				|| 
				(pdlinfo.get('consommationSansFournisseur') != null  && ((boolean) pdlinfo.get('consommationSansFournisseur'))) 
				||
				telereleve
			   )
			   ){
				   input.miseEnService.indexClient =  new gdfsuezBefCalypsoPrestaGaz.indexDt();
				   input.miseEnService.indexClient.valeurIndex    =    IndexGaz;
				   Date todayDate = Date.today();
				   input.miseEnService.indexClient.dateIndex =   String.valueOf(todayDate).subString(0,10)+'T00:00:00';                                                                                                                                 
				}
			
		}
		//
		//
		// accepter RDV
		//
		input.accepterRdv = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_accepterRdv_element();
		input.accepterRdv.optionExpress = False;
		
		
		
		gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazResponse_element response;
		
		if (!Test.isRunningTest()) {
			response = port.CreerPrestationServiceGaz_Http(input, octx);
		} else {
			Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPrestaGazHttpMock());
			gdfsuezBefCalypsoPrestaGaz.Dependency porttest = new gdfsuezBefCalypsoPrestaGaz.Dependency();
			system.debug('@@ start of mock');
			response = porttest.CreerPrestationServiceGaz_Http(input, octx);
			system.debug('@@ end of mock');
		}
		
		
		if (response.messageRetours != null && response.messageRetours.retourTraitementMessage != null && response.messageRetours.retourTraitementMessage[0].code != null &&
			  (!response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceGaz_01')) &&
			  (!response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceGaz_02')) && 
			 (!response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceGaz_04')) && 
			 (!response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceGaz_03'))  
			) {
                	 setChoixProcedureSelectable(outMap);
																																		 // US-879
																																		// switchToRecollement(inputMap,outMap);
																																	 }
		
		
		// US-1014
		if(response.creerPrestationServiceGazOutput != null &&  response.creerPrestationServiceGazOutput.prestationServiceDistributeurCree
		   &&   response.creerPrestationServiceGazOutput.prestationServiceFournisseurCree  &&   response.messageRetours.retourTraitementMessage != null &&
		   response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceGaz_01') || response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceGaz_02') ) {
			   try{
				   DateTime dT = Datetime.valueOf(DateEffetSouhaiteGaz+ ' 00:00:00');
				   Date dateSouhaite = date.newinstance(dT.year(), dT.month(), dT.day());
				   Map<String,Object> ElementsToSerialize = new Map<String,Object>() ;
				   ElementsToSerialize.put( 'id', (String) ((Map<String,Object>) PrestationDistriGaz).get('id') );
				   ElementsToSerialize.put( 'idPrestationServiceFournisseur', response.creerPrestationServiceGazOutput.idPrestationServiceFournisseur) ;
				   ElementsToSerialize.put( 'idPrestationServiceDistributeur', response.creerPrestationServiceGazOutput.idPrestationServiceDistributeur) ;
				   ElementsToSerialize.put( 'dateSouhaite', dateSouhaite) ;                                      
				   string jsonString = JSON.serializePretty(ElementsToSerialize);     
				   updateOPS(jsonString);     
				   
				   // les elements à mettre dans l'etape recap  SMIL-802
				   updateToRecap(isBillingAddressSameAsLiving,response,selectedAdrConsFormula,adressContact,inputMap,outMap,DateEffetSouhaiteGaz);
				   
				   updateMessage(telereleve,choixProcedure,response,outMap);
			   }catch(Exception e){
				   system.debug('Erreur survenue lors de la mise a jour des elements du recap'+e);
				   system.debug(e.getStackTraceString());   
			   }
				   
			   
		   }else if (response.messageRetours.retourTraitementMessage != null &&  response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceGaz_03') ) {
			   // cadre de l'us SMIL-1444  06/02/2019
			   // rappeler le ws creerPrestationServiceGaz avec l'action ACCEPTER
			   inputMap.put('idPrestationServiceDistributeuGaz',response.creerPrestationServiceGazOutput.idPrestationServiceDistributeur);
			   creerPrestationGazOnline(inputMap, outMap, options,'ACCEPTER',response.creerPrestationServiceGazOutput.planificationIntervention.heureDebut,
										response.creerPrestationServiceGazOutput.planificationIntervention.heureFin);
			   return ;
		   }else if(response.messageRetours.retourTraitementMessage != null &&  response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceGaz_04'))
		   { // selon l'us SMIL_1237 le retour octopus avec un code _04 contiendra le tableau de charge 
			  outMap.put('tableauDeChargeGaz', response.creerPrestationServiceGazOutput.tableauDeCharges);
			  outMap.put('idPrestationServiceDistributeuGaz',response.creerPrestationServiceGazOutput.idPrestationServiceDistributeur);       
		   }else{
			   String causedBy = '' ;
             if(response.messageRetours.retourTraitementMessage != null &&  response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceGaz_07')
			 && response.messageRetours.retourTraitementMessage[0].causedBy.libelle.contains('DEM_COH05') 
			 ){
             causedBy = 'La Date Demandée pour votre mise en service est uniquement possible sur la période entre J+1 et J+15 jours';
			 }else{
			 causedBy = response.messageRetours.retourTraitementMessage[0].causedBy.libelle ;
			 } 
			  outMap.put('CausedByGaz',causedBy ); 
		   }        
		
		System.debug('**** response : ' + response);
		System.debug('**** response code : ' + response.messageRetours.retourTraitementMessage[0].code);
		outMap.put('code_retour_creer_ops_gaz', response.messageRetours.retourTraitementMessage[0].code);
		
	}
	
		public static void updateMessage(boolean telereleve,String choixProcedure,gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazResponse_element  response, Map<String,Object>  outMap){
		String message ='';
		if(response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceGaz_02')){
			if(telereleve){
			message = 'OPS télérelevée. La demande de prestation a bien été créée chez le distributeur.\n' ; 
			}else if(choixProcedure.equals('Autorelève')){
		    message = 'OPS créée.' ;   
			}else{
			message = 'En attente retour gestionnaire réseau. Le client sera directement contacté par Grdf.' ;   
			}
		}else{
			message = 'OPS créée.';  
		}
			outMap.put('PSGOnlineOKMSG',message) ;  
	}
	
	
	public static void  updateToRecap(Boolean  isBillingAddressSameAsLiving, gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazResponse_element response  ,
									  String selectedAdrConsFormula, Map<String,Object> adressContact, Map<String,Object> inputMap, Map<String,Object>  outMap,String DateEffetSouhaiteGaz ){
										  
										  try{
											  outMap.put('idPrestationDistributeurGaz',response.creerPrestationServiceGazOutput.idPrestationServiceDistributeur);
											  outMap.put('idPrestationFournisseurGaz',response.creerPrestationServiceGazOutput.idPrestationServiceFournisseur);
											  outMap.put( 'addresseConcernee', !isBillingAddressSameAsLiving ? selectedAdrConsFormula:  adressContact.get('NoVoie') +' '+ (string) adressContact.get('BillingAddress'));
											  Datetime dateSouhaiteDateTime =  Datetime.valueOf(DateEffetSouhaiteGaz+' 23:00:00.000Z');     // provisoire
											  outMap.put('dateinteventionSouhaiteGaz',frenchDays.get(dateSouhaiteDateTime.format('EEEE'))+' '+dateSouhaiteDateTime.day()+' '+frenchDates.get(dateSouhaiteDateTime.month())+' '+dateSouhaiteDateTime.year());
											  
											  
                                              if(response.creerPrestationServiceGazOutput.planificationIntervention != null && 
                                                 response.creerPrestationServiceGazOutput.planificationIntervention.heureDebut != null &&
                                                 response.creerPrestationServiceGazOutput.planificationIntervention.heureFin != null ){
                                                     outMap.put('creneauHoraireGazCode', '('+response.creerPrestationServiceGazOutput.planificationIntervention.heureDebut.substring(0, 5) 
                                                                +' - '+response.creerPrestationServiceGazOutput.planificationIntervention.heureFin.substring(0, 5) +')');
                                                     outMap.put('creneauHeureDebut',response.creerPrestationServiceGazOutput.planificationIntervention.heureDebut.substring(0, 5));
                                                     outMap.put('creneauHeureFin',response.creerPrestationServiceGazOutput.planificationIntervention.heureFin.substring(0, 5));
                                                     
                                                 }
										  }catch(Exception e){
											  system.debug('Erreur survenue lors de la mise a jour des elements du recap'+e);
											  system.debug(e.getStackTraceString());   
											  
										  }
										  
									  }

	
	
	public static void switchToRecollement(Map < String, Object > inputMap, Map < String, Object > outMap) {
		
		/*
Si CreerPSG retourne que Omega est KO alors on a en sortie les éléments suivant
Le libellé ne contient pas l'Id du PCE recherché
OU
Le retour de CreerPSG ne contient le code retour suivant: OCTOPUS_CreerPrestationServiceGaz_01
OU
La balise source dans le retour ne contient pas Octopus
Effectuer les actions suivantes:
Le champ Mode de navigation bascule en recollement
**/
		
		Map < String, Object > old = new Map<String,Object>() ;//(Map < String, Object > ) inputMap.get('PrestationGaz');
		old.put('NavigationModeGaz', 'Recollement');
		outMap.put('PrestationGaz', old);
		
		
	}
	
	/*
Description détailléeSi la demande est recevable on a le retour suivant en sortie de creerPSG:Le retour de CreerPSG contiendra :o Code Octopus : OCTOPUS_CreerPrestationServiceGaz_01 OU OCTOPUS_CreerPrestationServiceGaz_02Le booleen prestationServiceDistributeurCree est alimenté à TrueLe booleen prestationServiceFournisseurCree est alimenté à true

les actions suivantes sont effectuées:

Mise à jour de l'OPSStatut: En coursDate: Date renseignée dans l'OSNumro d'affaire : IdPrestationServiceDistributeurIdentifiant ENGIE: IdPrestationServiceFournisseur

Le message de confirmation suivant est affiché:"OPS créée."
*/
	@future
	public static void  updateOPS(String elements){
		try{
			Map<String,Object> wrapper = (Map<String,Object>) SYSTEM.JSON.deserializeUntyped(elements);
			String id = (String) wrapper.get('id') ;
			String  idPrestationServiceDistributeur = (String) wrapper.get( 'idPrestationServiceDistributeur');
			String  idPrestationServiceFournisseur = (String) wrapper.get( 'idPrestationServiceFournisseur');
			Date  dateEffet = wrapper.get( 'dateSouhaite') == null ? null : Date.valueOf((String)wrapper.get( 'dateSouhaite'));
			
			if(id== null) {
				system.debug('## could not found id OPS ## ');
				return;
			}          
			
			system.debug('id'+id);
			Prestation_distributeur__c acc = [SELECT Id, Name,Numero_affaire_distributeur__c,Statut__c,Date_de_prestation__c,Identifiant_ENGIE__c FROM Prestation_distributeur__c WHERE Id =: id  ];
			acc.Numero_affaire_distributeur__c   =idPrestationServiceDistributeur;
			acc.Statut__c = 'En cours';
			acc.Date_de_prestation__c   = dateEffet;
			acc.Identifiant_ENGIE__c = idPrestationServiceFournisseur;
			//   acc.Creneau__c = creaneau ;
			update acc;
		}catch(Exception e) {
			system.debug('##catched##'+e);
		}
		
	}

	
	/**
US-802 method qui invoque le service lire Pretation Gaz pour recuperer les details de l'ops et les afficher dans l'os à l'étape recap .

*/
	public void lirePrestationGaz(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		System.debug('**** IN lirePrestationGaz');
		
		
		System.debug('*** Params');
		
		 String idPrestationDistributeur = inputMap.get('idPrestationDistributeurGaz') == null ? null : String.valueOf(inputMap.get('idPrestationDistributeurGaz'));
         String idPrestationFournisseurGaz =   inputMap.get('idPrestationFournisseurGaz') == null ? null : String.valueOf(inputMap.get('idPrestationFournisseurGaz'));
     
			if(String.isBlank(idPrestationDistributeur) &&  String.isBlank(idPrestationFournisseurGaz)){
			if(!Test.isRunningTest()){
				throw new  IOexception('ne peut pas trouver l id prestation distributeur' );
			}
		}
		
		gdfsuezComBefChpPivotPrestaGaz.contextDt octx = initContext('Smile', '2.0');
		
		gdfsuezBefCalypsoPrestaGaz.Dependency port = new gdfsuezBefCalypsoPrestaGaz.Dependency();
		SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
		port.clientCertName_x = octopusCS.certName__c;
		port.endpoint_x = octopusCS.endpoint__c + 'ES-PrestationServiceGaz_v2';
		System.debug('*** endpoint : ' + port.endpoint_x);
		port.inputHttpHeaders_x = new Map < String, String > {
			'Content-Type' => 'text/xml;charset=utf-8'
				};
					
					gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt input = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt();
		
			input.online = true;
		input.loginUtilisateur = service.getIdentifiantDistribFromApex();
	    input.typeOffre = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt() ;
		input.typeOffre.code = 'INDUSTRIELLE';
		// Donnees générales
		input.prestationServiceGaz = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt_prestationServiceGaz_element[1];
		input.prestationServiceGaz[0] = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt_prestationServiceGaz_element();
		input.prestationServiceGaz[0].idPrestationServiceDistributeur = idPrestationDistributeur;
		input.prestationServiceGaz[0].idPrestationServiceFournisseur = idPrestationFournisseurGaz;

		gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazResponse_element response;
		
		if (!Test.isRunningTest()) {
			response = port.LirePrestationServiceGaz_Http(input, octx);
		} else {
			Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPrestaGazHttpMock());
			gdfsuezBefCalypsoPrestaGaz.Dependency porttest = new gdfsuezBefCalypsoPrestaGaz.Dependency();
			system.debug('@@ start of mock');
			response = porttest.LirePrestationServiceGaz_Http(input, octx);
			system.debug('@@ end of mock');
		}
		
		System.debug('**** response : ' + response);
		System.debug('**** response code : ' + response.messageRetours.retourTraitementMessage[0].code);
		
		getDetailsFromResponseAndExposeItToOS(response,outMap,inputMap);
	}
	
	public void lirePrestationGazList(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		System.debug('**** IN lirePrestationGazList');
		
		Map<String, Object> elecOps = (Map<String, Object>) inputMap.get('RechercherPrestaGaz');
		Map<String, Object> opsList = (Map<String, Object>) elecOps.get('ops');
		
		Map<String, Object> opsOut = new Map<String, Object>();
		
		// Il faut appeler l'IP existante pour chaque PDL présent en entrée
		map<string, object> inputGaz = new map<string, object>();
		inputGaz.put('TypeCard', 'GAZ');
		
		String typeUser= String.valueOf(inputMap.get('TypeUser'));
		inputGaz.put('TypeUser',typeUser);
		
		
		System.debug('*** ' + (Set<String>) opsList.keyset());
		
		for(String gazPdl : (Set<String>) opsList.keySet()) {
			Map<String, Object> ops = (Map<String, Object>) opsList.get(gazPdl);
			
				String idDistrib = (String) ops.get('idPrestationServiceDistrib');
				inputGaz.put('idPrestationDistributeur', idDistrib);
				String idFournisseur= (String) ops.get('idPrestationServiceFournisseur');
				inputGaz.put('idPrestationFournisseur', idFournisseur);
				
				Map<String, Object> gazOutput = new Map<String, Object>();
				  lirePrestationGazOffline(inputGaz, gazOutput, options);
				inputGaz.put('commentaires', gazOutput.get('commentaires'));
				lirePrestationGazOnline(inputGaz, gazOutput, options);
				
				opsOut.put(gazPdl, gazOutput);
		   
			System.debug('*** gazOutput : ' + gazOutput);
		}
		
		outMap.put('ops', opsOut);
		
		System.debug('**** OUT lirePrestationGazList');
	}
	
	/*
	* @Author: 
	* @Date: 11/02/2019
	* @Description: Rechercher PrestationElec method called by omniscript
	*/ 
	public void lirePrestationGazOffline(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		System.debug('**** IN lirePrestationGazOffline');
		System.debug('*** Params : ' + inputMap);
			   String idFournisseurGaz= String.valueOf(inputMap.get('idPrestationFournisseur'));
 
	   
		// Il faut appeler l'IP existante pour chaque PDL présent en entrée
		map<string, object> inputGaz = new map<string, object>();
		Map<String, Object> ipOutput =new map<string, object>();
		Map<String, Object> fieldsOutput =new map<string, object>();
					

				inputGaz.put('idFournisseurGaz', idFournisseurGaz);
				if(!Test.isRunningTest()){
					ipOutput = (Map<String,Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService('IP_SM_LirePrestationGAZ_SOAP', inputGaz, options);  
				}
				else{
					ipOutput = (Map<String, Object>) inputMap.get('lirePrestationGaz');
				}
				
				try{
					
					fieldsOutput = (Map<String, Object>) ipOutput.get('LirePrestationGAZResult');
					
				} catch(Exception e){
					
				}

		system.debug('fieldsOutput '+fieldsOutput );
		
		if( fieldsOutput != null && fieldsOutput.containsKey('commentaireIntervention')){
				outMap.put('commentaires', fieldsOutput.get('commentaireIntervention'));

		}
		else{
				outMap.put('commentaires', 'WSKO');

		}
		System.debug('**** OUT lirePrestationGazOffline');
	}

	
	public void rechercherPrestationGaz(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		System.debug('**** IN rechercherPrestationGaz');
		
		System.debug('*** Params : ' + inputMap);
		String idBp = String.valueOf(inputMap.get('idBp'));
		Map<String, Object> contratIn = (Map<String, Object>) inputMap.get('WSContrat');

		
		Set<String> gaz = (Set<String>) contratIn.get('gaz');
		System.debug('*** gaz : ' + gaz);
		
		Map<String, Object> opsOut = new Map<String, Object>();

		Boolean fromSelfcare = (Boolean) inputMap.get('origineSelfcare');
		
		// Il faut appeler l'IP existante pour chaque PDL présent en entrée
		map<string, object> inputGaz = new map<string, object>();
		Map<String, Object> ipOutput =new map<string, object>();

		
		if(gaz != null){
			for(String gazPdl : gaz) {
				inputGaz.put('PDLGAZIdentifier', gazPdl);
				inputGaz.put('origineSelfcare', fromSelfcare);
				inputGaz.put('PersonneGAZIdentifier',idBp);
				System.debug('*** ' + gazPdl);
				if(!Test.isRunningTest()){
					ipOutput = (Map<String,Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService('IP_SM_RecherchePrestationGaz_SOAP', inputGaz, options);
				}
				else{
					ipOutput = (Map<String, Object>) inputMap.get('RecherchePrestationGaz');
				}
				try{
					/*Map<String, Object> fieldsOutput = new Map<String, Object>();
					fieldsOutput.put(gazPdl, ipOutput.get('RecherchePrestationGAZResult'));*/
					Map<String, Object> fieldsOutput = (Map<String, Object>) ipOutput.get('RecherchePrestationGAZResult');
					System.debug('*** ' + fieldsOutput);
					opsOut.put(gazPdl, fieldsOutput);
				} catch(Exception e){
					
				}            
			}
		}
		
		outMap.put('ops', opsOut);
		
		System.debug('**** OUT rechercherPrestationGaz');
	}
	
	/*
l'objective de cette methode est de récupérer la liste des champs à afficher dans l'étape recap
*/
public static void getDetailsFromResponseAndExposeItToOS(gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazResponse_element responseElement, Map<String,Object>  outMap,Map<String,Object> inputMap){
	if(responseElement == null  || responseElement.lirePrestationServiceGazOutput == null ||  responseElement.lirePrestationServiceGazOutput.prestationServiceLire == null  ||
		responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].donneesGenerales == null ) {
			throw new IOException('Certains elements du web service LirePrestationGaz n\'ont pas pu etre lu !');
		}

	
	
	// partie commune pour le recollement et pour le mode Online 
	PrestationDetails prestationDetails = new PrestationDetails();        
	prestationDetails.typePrestationService     =  responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].donneesGenerales.codePrestation   == null ? null :
	responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].donneesGenerales.codePrestation.libelleCourt;      
	prestationDetails.statutPrestationService =    responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].donneesGenerales.statutPrestationService == null ? null :
	'( Statut : '+responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].donneesGenerales.statutPrestationService.libelleCourt+' )';
	prestationDetails.referenceDistributeur =  responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].idPrestationServiceDistributeur == null ? null : 'Ref Distributeur : '+responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].idPrestationServiceDistributeur;
	prestationDetails.referenceFournisseur =  responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].idPrestationServiceFournisseur == null ? null : 'Ref Fournisseur : '+responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].idPrestationServiceFournisseur;
	Map<String,Object> PrestationGaz =    ((Map<String,Object>)inputMap.get('PrestationGaz')) ;
	if(((String)PrestationGaz.get('NavigationModeGaz')).equals('Online')) {
		// online
   
	if( responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].donneesGenerales.optionUrgente != null &&
	responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].donneesGenerales.optionUrgente
	){
    prestationDetails.MESUrgente = 'Une MES Express/Urgente a été demandée. veuillez basculer sur un appel à acheminement.'  ;
	}
	prestationDetails.index = (integer) ((Map<String,Object>)((Map<String,Object>) inputMap.get('PrestationGaz')).get('BlockAutoreleveGaz')).get('IndexGaz') == null ? null :   'Index fourni : '+ (integer) ((Map<String,Object>)((Map<String,Object>) inputMap.get('PrestationGaz')).get('BlockAutoreleveGaz')).get('IndexGaz');
	prestationDetails.indexValue =(integer) ((Map<String,Object>)((Map<String,Object>) inputMap.get('PrestationGaz')).get('BlockAutoreleveGaz')).get('IndexGaz') == null ? null : String.valueOf(((Map<String,Object>)((Map<String,Object>) inputMap.get('PrestationGaz')).get('BlockAutoreleveGaz')).get('IndexGaz'))  ;
    String comments = '' ;
	
	Map<String,Object>	PrestationDistriGaz = (Map<String,Object>) inputMap.get('PrestationDistriGaz')  ;
    boolean  telereleve = (boolean) PrestationDistriGaz.get('telereleveObligatoire'); // US SMIL-2721
	system.debug('telereleve'+telereleve) ;
	String ChoixProcedureGaz =  !String.isBlank((String)PrestationGaz.get('ChoixProcedureGaz')) ?  String.valueOf(PrestationGaz.get('ChoixProcedureGaz')) : !String.isBlank((String)PrestationGaz.get('ChoixProcedureGAZMHS')) ?    String.valueOf(PrestationGaz.get('ChoixProcedureGAZMHS'))  : null ;		
	system.debug('ChoixProcedureGaz'+ChoixProcedureGaz) ;
	 if(!String.isBlank(ChoixProcedureGaz) && ChoixProcedureGaz.equals('Intervention')  && !telereleve){	
	 comments = (String)inputMap.get('CommentairePrestationGazFormula') ;
			
			if(!String.isBlank(comments)){
				if(comments.equalsIgnoreCase('PO')){
					comments ='Presence obligatoire';
				}
				else if(comments.equalsIgnoreCase('PNO')){
					comments ='Presence non obligatoire';
				}
				}
	   }
		
        prestationDetails.prixOPS =  responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].solde == null ? null :
        responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].solde.fraisPrestation == null ?  null :
        String.valueOf(responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].solde.fraisPrestation)+' € TTC' ;            
        prestationDetails.dateSOuhaite =String.valueOf(inputMap.get('dateinteventionSouhaiteGaz'));
        prestationDetails.creneau  = String.valueOf(inputMap.get('creneauHoraireGazCode'));
        prestationDetails.creneauHeureDebutValue = String.valueOf(inputMap.get('creneauHeureDebut'));
        prestationDetails.creneauHeureFinValue = String.valueOf(inputMap.get('creneauHeureFin'));        
        prestationDetails.presenceObligatoire    =  comments;
	}
	
	
	outMap.put('lirePrestationGazDetails',prestationDetails);
	//system.debug('lirePrestationGazDetails' + outMap);
}
	
	public static gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_contactIntervention_element fillContactIntervention(Map<String,Object> BlockInterventionGaz,boolean choixProcedureIntevention,Map<String,Object> contactInfos,Map<String,Object>coordonneContact ){
		
		if(!choixProcedureIntevention){
			// la balise contact interventon est obligatoire quelqu soit le mode intervention / autoreleve evolution suite aux retours test gaz
			fillBLockIntervention(BlockInterventionGaz,choixProcedureIntevention,contactInfos,coordonneContact);         
		}else {
            // dans le cas d'une intervention on check que les champs obligatoire dans le block intervention 
        
		checkNotEmptyFields(BlockInterventionGaz) ;
	
        }
		gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_contactIntervention_element contactIntervention;
		if(!String.isBlank( (String) BlockInterventionGaz.get('NomGaz') ) ||  !String.isBlank( (String) BlockInterventionGaz.get('PrenomGaz') )  ) {
			if(contactIntervention == null) {
				contactIntervention  = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_contactIntervention_element();
			}
			contactIntervention.identiteContact = new gdfsuezBefCalypsoPrestaGaz.identiteContactDt();
			contactIntervention.identiteContact.nom = (String) BlockInterventionGaz.get('NomGaz') == null ? null : (String) BlockInterventionGaz.get('NomGaz');
			contactIntervention.identiteContact.prenom = (String) BlockInterventionGaz.get('PrenomGaz') == null ? null :  (String) BlockInterventionGaz.get('PrenomGaz');
		}
		if(!String.isBlank((String) BlockInterventionGaz.get('CiviliteGaz'))) {
			if(contactIntervention == null) {
				contactIntervention  = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_contactIntervention_element();
			}
			contactIntervention.identiteContact.civilite = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
			contactIntervention.identiteContact.civilite.code = (String) BlockInterventionGaz.get('CiviliteGaz');
		}
		if(!String.isBlank((String) BlockInterventionGaz.get('telephoneGaz'))) {
			if(contactIntervention == null) {
				contactIntervention  = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_contactIntervention_element();
			}
			contactIntervention.coordonneesContact = new gdfsuezBefCalypsoPrestaGaz.coordonneesContactDt();
			contactIntervention.coordonneesContact.telephone = ((String) BlockInterventionGaz.get('telephoneGaz')).replace(' ', '');
		}
		
		if(!String.isBlank((String)BlockInterventionGaz.get('CommentairePrestationGaz'))) {
			if(contactIntervention == null) {
				contactIntervention  = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_contactIntervention_element();
			}
			contactIntervention.commentaireIntervention =  (String)BlockInterventionGaz.get('CommentairePrestationGaz'); 
			
		}
        
		
		return contactIntervention;
		
		
		
		
	}
	
		
	
	public static void fillBLockIntervention(Map<String,Object> BlockInterventionGaz ,boolean interventionObligatoire,Map<String,Object> contactInfos,Map<String,Object> coordonneContact){
		
		BlockInterventionGaz.put('NomGaz', (String) contactInfos.get('Nom'));
		BlockInterventionGaz.put('PrenomGaz',(String) contactInfos.get('Prenom'));
		BlockInterventionGaz.put('CiviliteGaz',  (String) contactInfos.get('Civilite'));
		BlockInterventionGaz.put('telephoneGaz', getTelephone( interventionObligatoire , BlockInterventionGaz , coordonneContact )) ;
	}
	
	
	
public static gdfsuezBefCalypsoPrestaGaz.contactCourrierDt fillcontactCourrier(Map<String,Object> contactInfos, Map<String,Object> coordonneContact,
																				   Map<String,Object>  ChoixElements1,Map<String,Object> adressContact,boolean isBillingAddressSameAsLiving ,boolean interventionObligatoire,Map<String,Object> blockIntervention){
																					   gdfsuezBefCalypsoPrestaGaz.contactCourrierDt contactCourrier = new gdfsuezBefCalypsoPrestaGaz.contactCourrierDt();
																					   contactCourrier.identiteContact = new gdfsuezBefCalypsoPrestaGaz.identiteContactDt();
																					   contactCourrier.identiteContact.nom = (String) contactInfos.get('Nom');
																					   contactCourrier.identiteContact.prenom = (String) contactInfos.get('Prenom');
																					   contactCourrier.identiteContact.civilite = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
																					   contactCourrier.identiteContact.civilite.code = (String) contactInfos.get('Civilite');
																					   
																					   contactCourrier.coordonneesContact = new gdfsuezBefCalypsoPrestaGaz.coordonneesContactDt();
																					   
																					   String telephone = getTelephone(interventionObligatoire,blockIntervention,coordonneContact) ;
																					   
																						   
																						   
																					   
																					   contactCourrier.coordonneesContact.telephone = telephone ;
																					   
																					   contactCourrier.adressePostale = new gdfsuezComBefChpCommunadressePrestaGaz.adresseCommunDt();
																					   
																					   contactCourrier.adressePostale.cp = !isBillingAddressSameAsLiving ? ((String)ChoixElements1.get('postcodeValue')) : (string) adressContact.get('CodePostal');
																					   contactCourrier.adressePostale.libelleVoie = !isBillingAddressSameAsLiving ? ((String)ChoixElements1.get('libelleVoieValue'))  : (string) adressContact.get('Adresse');
																					   contactCourrier.adressePostale.nVoie = !isBillingAddressSameAsLiving ? ((String)ChoixElements1.get('nVoieValue')) : (string) adressContact.get('NoVoie');
																					   contactCourrier.adressePostale.pays = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
																					   contactCourrier.adressePostale.pays.code = 'FR';
																					   contactCourrier.adressePostale.ville = !isBillingAddressSameAsLiving ? ((String)ChoixElements1.get('cityValue')) : (String) adressContact.get('Ville');
																					   
																					   
																					   
																					   
																					   return contactCourrier;
																					   
																				   }
	
	public static String getTelephone(boolean interventionObligatoire ,Map<String,Object> blockIntervention ,Map<String,Object> coordonneContact ){
		String telephone ;
		try{
			if(interventionObligatoire){
				if(blockIntervention.get('telephoneGaz') != null ){
					telephone =   ((String) blockIntervention.get('telephoneGaz')).replace(' ', '');
				}
			}else {
				if(coordonneContact.get('principalMobileValue') != null ){
					telephone =   ((String) coordonneContact.get('principalMobileValue')).replace(' ', '');  
				}else{
					return '0000000000';
				}
				
				// autoreleve 
			}
		}catch(Exception e ){
			system.debug('error occured'+e.getStackTraceString());
		}
		return  telephone ;
	}
	public static gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_utilisateurFinal_element fillUtilisateurFinal(Map<String,object> contactInfos ){
		gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_utilisateurFinal_element utilisateurFinal = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_utilisateurFinal_element();
		utilisateurFinal.categorie = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		utilisateurFinal.categorie.code = 'RES' ;
		utilisateurFinal.nom = (String) contactInfos.get('Nom');
		utilisateurFinal.prenom = (String) contactInfos.get('Prenom');
		utilisateurFinal.civilite = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		utilisateurFinal.civilite.code = (String) contactInfos.get('Civilite');
		return utilisateurFinal;
	}
	
	public class PrestationDetails {
		public String typePrestationService;
		public String statutPrestationService;
		public String dateSOuhaite;
		public String creneau;
		public String presenceObligatoire;
		public String MESUrgente;
		public String prixOPS;
		public String referenceDistributeur;          // GRDF ERDF selon le cas
		public String referenceFournisseur;  
		public String index;          // TODO base hp hc
        public String indexValue;
		public String creneauHeureDebutValue;
		public String creneauHeureFinValue;
		
	}
	

	public static void setChoixProcedureSelectable(Map<String,Object> outMap){
        outMap.put('SetChoixProcedureGazParDefaut', 'Recollement') ;
	} 

	public static Map<String,Object> fillSelectedAdressElements(Map<String,Object> inputMap){
		Map<String,Object> elements = new  Map<String,Object>() ;
		elements.put('postcodeValue', inputMap.get('postcodeValue')) ;
		elements.put('libelleVoieValue', inputMap.get('libelleVoieValue')) ;
		elements.put('nVoieValue', inputMap.get('nVoieValue')) ;
		elements.put('cityValue', inputMap.get('cityValue')) ;
		return elements ;
	} 

	public static void checkNotEmptyFields(Map<String,Object> BlockInterventionGaz){
			if(String.isBlank( (String) BlockInterventionGaz.get('NomGaz')) ||
          String.isBlank((String) BlockInterventionGaz.get('telephoneGaz')) ||
          String.isBlank( (String) BlockInterventionGaz.get('PrenomGaz')) ||   String.isBlank((String) BlockInterventionGaz.get('CiviliteGaz')) ){
              throw new IOException('Veuillez remplir les champs manquants dans le block intervention !') ;
          }
	} 
}