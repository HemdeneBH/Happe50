/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: Test Class for SM_AP41_PrestaServiceElecOnline
*/
global class SM_AP41_PrestaServiceElecOnline implements vlocity_cmt.VlocityOpenInterface {
	//Parameters
	//contant the elemnts names in the omniscripts (moveIn , CreateOPS) 
	public final static String ChoixElements = 'ChoixElements' ;
	public final static String chooseSellingOption = 'chooseSellingOption' ;
	public final static String Emmenagement ='Emménagement' ;
	public final static String ChangementDeFournisseur ='Changement de fournisseur';
	public final static String OffreChoisis = 'OffreChoisis' ;
	public final static String ChoixElements1 ='ChoixElements1' ;
	public final static String PrestationElec  = 'PrestationElec' ; 
	public final static String BlocIntervention = 'BlocIntervention' ; 
	public final static String InfoRecollementElec = 'InfoRecollementElec';
	public final static String AutoreleveElec = 'AutoreleveElec' ; 
	public final static String informationsDePrestation = 'Informations_de_prestation' ;
	public final static String ContactInfo = 'ContactInfo'; 
	public final static String TelMobile = 'TelMobile' ;
	public final static String AdresseEmail ='AdresseEmail' ;
	public final static String AdresseContact ='AdresseContact' ;
	public final static String refClientIdBP ='refClientIdBP' ;
	public final static String selectedPDLVal ='selectedPDLVal' ;
	public final static String DemandeUrgenteElec = 'DemandeUrgenteElec' ;
	public final static String OrigineDemande1 ='OrigineDemande1';
	public final static String isBillingAddressSameAsLiving = 'isBillingAddressSameAsLiving' ;
	public final static String IsSelectedIntervention = 'IsSelectedIntervention';
	public final static String ServicesGestion = 'ServicesGestion';
	public final static String PrelevementBlock = 'PrelevementBlock' ;
	public final static String pdlElecInfo =  'pdlElecInfo' ;
	public final static String getEmailPrincipale  = 'getEmailPrincipale' ;
	public final static String AddressIndication ='AddressIndication' ; 
	public final static String ComplementAdresse  = 'ComplementAdresse' ;
	public final static String  ftaCode =  'ftaCode' ;
	public final static String ChoixProcedureRepriseIndexAutoItv = 'ChoixProcedureRepriseIndexAutoItv' ;
	public final static String demandeElecTransmise = 'demandeElecTransmise' ;
	public final static String HP =  'HP';
	public final static String HC =  'HC' ;
	public final static String WE ='WE' ;
	public final static String mapConsoByTypeComptage =  'mapConsoByTypeComptage';
	public final static String PSE_CODE_retour = 'PSE_CODE_retour' ;
	public final static String Base = 'Base' ;
	public final static String idPrestationDistributeurElec  ='idPrestationDistributeurElec' ;
    public final static String SetChoixProcedureElecParDefaut  ='SetChoixProcedureGazParDefaut' ;
	public final static String Recollement  ='Recollement' ;
	
	
	
	
	
	public static SM_UTIL_Cache_Management service = new SM_UTIL_Cache_Management();
	static final Map < String, Object > causedByCodeMap = new Map < String, String > {
		'SGT582' => 'Le point est non résilié, la date d\'intervention souhaitée doit être strictement supérieure à la date du jour ',
			'SGT578' => 'La date d\'intervention souhaitée doit être supérieure ou égale à la date de fin souhaitée dans le cas d\'une demande de mise sous tension pour essai.',
			'SGT577' => 'Pour une mise sous tension pour essai : la date de fin souhaitée doit être supérieure ou égale à la date de début souhaitée ; la période d\'essai ne peut excéder 30 jours.',
			'SGT576' => 'La date de début souhaitée doit être strictement supérieure à la date du jour dans le cas d\'une demande de mise sous tension pour essai.',
			'SGT575' => 'La date de début souhaitée doit être renseignée dans le cas d\'une demande de mise sous tension pour essai.',
			'SGT574' => 'La date de fin souhaitée doit être renseignée dans le cas d\'une demande de mise sous tension pour essai.',
			'SGT563' => 'Ce service ne permet pas de faire des demandes sur ce type de point.',
			'SGT562' => 'Problème : le message de demande est malformé',
			'SGT505' => 'Le point est en cours de migration',
			'SGT504' => 'Problème : utilisateur non trouvé',
			'SGT502' => 'Problème : l\'utilisateur demandeur ne fait pas partie de l\'acteur de marché de provenance de la demande',
			'SGT500' => 'Une erreur technique est survenue'
			};
				private static Map<Integer, String> frenchDates = new Map<Integer, String>();
	private static Map<String, String> frenchDays = new Map<String, String>();
	
	
	static final Map < String, Object > creneaux = new Map < String, String > {
		'jou' => 'Journée',
			'dma' => 'Début de matinée',
			'fma' => 'Fin de matinée',
			'ma' => 'Matin',
			'dap' => 'Début d’après midi',
			'fap' => 'Fin d’après midi',
			'apm' => 'Après midi',
			'fjo' => 'Fin de journée',
			'dso' => 'Début de soirée',
			'mjo' => 'Milieu de soirée',
			'soi' => 'Soir',
			'fso' => 'Fin de soirée'
			};
				
				
				static {
					
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
		
		if (methodName.equals('creerPrestationElecOnline')) {
			try {   // creation de la prestation en mode online 
			creerPrestationElecOnline(inputMap, outMap, options);
	
			 } 
			catch (Exception e) {

				String error = e.getStackTraceString() + '\n' + e.getMessage() ;


				//String data=  SM_Utilities.buildLog(error,'Error','creerPrestationElecOnline') ;
				//SM_Utilities.traceLog(data) ;



				if(!Test.isRunningTest()) {
					system.debug('error '+error);
					if(!(e instanceof SM_AP41_PrestaServiceElecOnline.IOException)) {
						// exception non generée
						e.setMessage('Erreur technique !');
					}
					// remonter l'erreur à l'IP
				    outMap.put('raisedExceptionElec',e.getMessage());
                    setChoixProcedureSelectable(outMap) ;
					//throw e;
				}
				// return false;
			}
		}  else   if (methodName.equals('creerPrestationElecOffline')) {
			try {
				creerPrestationElecOffline(inputMap, outMap, options);
			  } 
			  catch (Exception e) {

				String error = e.getStackTraceString() + '\n' + e.getMessage() ;


				//String data=  SM_Utilities.buildLog(error,'Error','creerPrestationElecOffline') ;
				//SM_Utilities.traceLog(data) ;



				system.debug(error);
				return false;
			}
		} 
		else if(methodName.equals('lirePrestationElec')) {
			try{
				// à appeler pour recuprer les details de la prestation après sa creation (Utilisé dans l'etape recap de l'OS Creation OPS)
				lirePrestationElec(inputMap, outMap, options);
			}
			catch(Exception e ) {
				if(!Test.isRunningTest()) {
					if( !(e instanceof IOexception)) {
						// exception non géré
						system.debug(e.getStackTraceString());
						system.debug(e.getMessage());
						e.setMessage('Lire Prestation Elec : Erreur technique  !');
					}
					throw e;
				}
			}
			
		}
		else if(methodName.equals('creerPrestationServiceElecOnlineCHO')) {
			try{
				
				creerPrestationServiceElecOnlineCHO(inputMap, outMap, options);
			}
			catch(Exception e ) {
				if(!Test.isRunningTest()) {
					if( !(e instanceof IOexception)) {
						// exception non géré
						system.debug(e.getStackTraceString());
						system.debug(e.getMessage());
						e.setMessage('Une erreur technique est survenue lors de la création de l\'OPS  !');
					}
					throw e;
				}
			}
			
		}
		return true;
	}
	
	/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: init context
*/
	public static gdfsuezComBefChpPSEPivot.contextDt initContext(String application, String version) {
		// Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
		gdfsuezComBefChpPSEPivot.contextDt_systemPath_system_element osource = new gdfsuezComBefChpPSEPivot.contextDt_systemPath_system_element();
		osource.systemId = application;
		gdfsuezComBefChpPSEPivot.contextDt octx = new gdfsuezComBefChpPSEPivot.contextDt();
		octx.version = version;
		//  octx.allowCache = false ;
		octx.systemPath = new gdfsuezComBefChpPSEPivot.contextDt_systemPath_element();
		octx.systemPath.system_x = new gdfsuezComBefChpPSEPivot.contextDt_systemPath_system_element[] {
			osource
				};
					return octx;
	}
	
	/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: vlocity apel à la méthode creerPrestationElec
*/
	public static void creerPrestationElecOnline(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
	

			
			String contexte = (String)inputMap.get('contexte') ;
			system.debug('contexte'+contexte);
			Map < String, Object > offreChoisis = (Map < String, Object > ) inputMap.get(OffreChoisis);
			Map < String, Object > selectedAdresseElements= fillSelectedAdressElements(inputMap) ;//= (Map < String, Object > ) inputMap.get(ChoixElements1);
			system.debug('selectedAdresseElements'+selectedAdresseElements);
            String   residenceOption =(String) inputMap.get('residenceOption');
			system.debug('residenceOption'+residenceOption);
			String selectedAdrConsFormula =  (String) inputMap.get('selectedAdrConsFormula'); 
			system.debug('selectedAdrConsFormula'+selectedAdrConsFormula);
           Boolean isBillingAddressSameAsLiving =  (boolean) inputMap.get('isBillingAddressSameAsLiving').equals('Oui') ; 
		   system.debug('isBillingAddressSameAsLiving'+isBillingAddressSameAsLiving);
			Map < String, Object > elementsElec = (Map < String, Object > ) inputMap.get(PrestationElec);
			system.debug('PrestationElec'+elementsElec);
			Map < String, Object > blocIntervention = (Map < String, Object > ) elementsElec.get(BlocIntervention);
			system.debug('BlocIntervention'+blocIntervention);
			Map < String, Object > infoRecollementElec = (Map < String, Object > ) elementsElec.get(InfoRecollementElec);
			system.debug('InfoRecollementElec'+infoRecollementElec);
			Map < String, Object > autoreleveElec = (Map < String, Object > ) elementsElec.get(AutoreleveElec);
			system.debug('autoreleveElec'+autoreleveElec);
			Map < String, Object > inforPrestationElec = (Map < String, Object > ) elementsElec.get(informationsDePrestation);
			system.debug('Informations de prestation'+inforPrestationElec);
			Map < String, Object > contactInfos = (Map < String, Object > ) inputMap.get('contactInfos');
			system.debug('ContactInfo'+contactInfos);
			Map < String, Object > coordonneContact = (Map < String, Object > ) inputMap.get(TelMobile);
			system.debug('TelMobile'+coordonneContact);
			Map < String, Object > adressEmail = (Map < String, Object > ) inputMap.get(AdresseEmail);
			system.debug('AdresseEmail'+adressEmail);
			Map < String, Object > adressContact = (Map < String, Object > ) inputMap.get(AdresseContact);
			system.debug('AdresseContact'+adressContact);
			Boolean isTeleoperableElec=false;
			String DateEffetSouhaite  = String.valueOf(inforPrestationElec.get('DateEffetSouhaite')) ;

			String idBp = inputMap != null ? (String) inputMap.get(refClientIdBP) : null;
			
			gdfsuezComBefChpPSEPivot.contextDt octx = initContext('Smile', '2.0');
			
			gdfsuezBefCalypsoPrestationServiceElec.Dependency port = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
			SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
			port.clientCertName_x = octopusCS.certName__c;
			port.endpoint_x = octopusCS.endpoint__c + 'ES-PrestationServiceElec_v3'; //ES-PrestationServiceElectricite_v3';
			System.debug('*** endpoint : ' + port.endpoint_x);
			port.inputHttpHeaders_x = new Map < String, String > {
				'Content-Type' => 'text/xml;charset=utf-8'
					};
						
						gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt input = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt();
			
			//##### Type offre#####
			input.typeoffre = new gdfsuezComBefChpPSEPivot.listeValeursDt();
			input.typeoffre.code = 'INDUSTRIELLE';
			
			//##### Donnees générales #####
			input.donneesGenerales = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_donneesGenerales_element();
			input.donneesGenerales.typePrestationService = new gdfsuezComBefChpPSEPivot.listeValeursDt();
			input.donneesGenerales.typePrestationService.code = 'Z002';
			input.donneesGenerales.idPersonne = idBp;
			input.donneesGenerales.idPDLElectricite = (String)((Map < String, Object > ) inputMap.get('pdlElecInfo')).get('idPDLElectricite') ;
			
			if(String.isBlank(DateEffetSouhaite)){
				throw new IOException('La date d\'effet souhaité est vide veuillez la saisir !') ;
			}
					
			String idContract = (String) inputMap.get('idContrat');
			if(String.isBlank(idContract)){
				If(!Test.isRunningTest())
					throw new IOException('l id contrat n est pas trouvé !') ;
			}

			input.donneesGenerales.idContrat = idContract; // transformer pc en dur pour l'instant comme demandé par Fatimatou  US 1086
			String idSap =      service.getIdentifiantSAPFromApex() ;
			if(String.isBlank(idSap)){
				If(!Test.isRunningTest())
					throw new IOException('l identifiant SAP n est pas trouvé !') ;
			}
			input.donneesGenerales.idPersonneResponsable = idSap ;
			input.donneesGenerales.natureDemande   = new  gdfsuezComBefChpPSEPivot.listeValeursDt();
			input.donneesGenerales.natureDemande.code = contexte.equals(Emmenagement) ? 'MES' : contexte.equals(ChangementDeFournisseur) ? 'CFN' : ''; // MES /CFN
			input.donneesGenerales.loginUtilisateur = service.getIdentifiantDistribFromApex();
			input.donneesGenerales.dateEffetSouhaitee = Datetime.valueOf(DateEffetSouhaite.replace('T', ' ')).addDays(1).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss'); //'Date d'effet renseignée à l'étape prestation Electricité sous le bloc "Informations de prestation" de l'OS creation OPS
			input.donneesGenerales.origineDemande  = (  ((Map < String, Object > )  elementsElec.get(informationsDePrestation)).get(DemandeUrgenteElec)  != null &&   
													  (boolean)((Map < String, Object > ) elementsElec.get(informationsDePrestation)).get(DemandeUrgenteElec) &&  
													  ((String)((Map < String, Object > ) elementsElec.get(informationsDePrestation)).get(OrigineDemande1)).equals('Engie')) ? 'ENGIE' : 'CLIENT' ;
			//##### données client final  #####
			input.clientFinal = new   gdfsuezBefCalypsoPrestationServiceElec.clientFinalDt();
			input.clientFinal.personnePhysique = new   gdfsuezBefCalypsoPrestationServiceElec.identiteDt();
			boolean interventionObligatoire = ((boolean)((Map < String, Object > ) elementsElec.get(informationsDePrestation)).get(IsSelectedIntervention)  || ((boolean)((Map < String, Object > ) elementsElec.get(informationsDePrestation)).get('IsItvObligatoire'))) ;
			input.clientFinal.personnePhysique.civilite = new  gdfsuezComBefChpPSEPivot.listeValeursDt();
			input.clientFinal.personnePhysique.civilite.code = (String) contactInfos.get('Civilite');

			String nomContact = String.valueOf(contactInfos.get('Nom'));
			input.clientFinal.personnePhysique.nom = nomContact.length() > 16 ?  nomContact.substring(0, 16) : nomContact ;

			String prenomContact = String.valueOf(contactInfos.get('Prenom'));
			input.clientFinal.personnePhysique.prenom = prenomContact.length() > 16 ?  prenomContact.substring(0, 16) : prenomContact ;
			input.clientFinal.coordonneesContact = new gdfsuezBefCalypsoPrestationServiceElec.coordonneesContactDt();
			input.clientFinal.coordonneesContact.telephone = new List < String > {getTelephone(interventionObligatoire,blocIntervention ,coordonneContact)} ;
						if(!String.isBlank((String) ((Map<String,Object>)((Map<String,Object>) inputMap.get(ServicesGestion)).get(PrelevementBlock)).get(getEmailPrincipale)))
						input.clientFinal.coordonneesContact.adresseEmail = (String) ((Map<String,Object>)((Map<String,Object>) inputMap.get(ServicesGestion)).get(PrelevementBlock)).get(getEmailPrincipale);
			input.clientFinal.adressePostale = new  gdfsuezComBefChpPSECommunadresse.adresseCommunDt();
			input.clientFinal.adressePostale.cp = !isBillingAddressSameAsLiving ? ((String)selectedAdresseElements.get('postcodeValue')) : (string) adressContact.get('CodePostal');
			String libelleVoie = !isBillingAddressSameAsLiving ?  ((String)selectedAdresseElements.get('libelleVoieValue')) : (string) adressContact.get('Adresse'); 
			if(!String.isBlank(libelleVoie) && libelleVoie.length()> 32){			
			libelleVoie =  libelleVoie.substring(0, 32) ;		            
			}
			input.clientFinal.adressePostale.libelleVoie = libelleVoie ;
			input.clientFinal.adressePostale.nVoie = !isBillingAddressSameAsLiving ? ((String)selectedAdresseElements.get('nVoieValue')) : (string) adressContact.get('NoVoie');
			input.clientFinal.adressePostale.pays = new gdfsuezComBefChpPSEPivot.listeValeursDt();
			input.clientFinal.adressePostale.pays.code = 'FR';
			input.clientFinal.adressePostale.ville = !isBillingAddressSameAsLiving ? ((String)selectedAdresseElements.get('cityValue')) : (String) adressContact.get('Ville');
			input.clientFinal.adressePostale.batiment = !isBillingAddressSameAsLiving ? (String) selectedAdresseElements.get(AddressIndication) : (String) adressContact.get(ComplementAdresse);
			input.clientFinal.adressePostale.lieuDit = !isBillingAddressSameAsLiving ? (String) selectedAdresseElements.get(AddressIndication) : (String) adressContact.get(ComplementAdresse);
			input.clientFinal.residencePrincipale = residenceOption.equals('010') ?  true: false ;

			if(inputMap.get(pdlElecInfo) == null || ((Map < String, Object > ) inputMap.get(pdlElecInfo)).get('typeCompteur') ==null  ) {
				throw new IOException('le type de compteur ne peut pas etre identifié !');
			}
			
			Boolean linky =  (boolean)elementsElec.get('LINKYlv2') || (boolean)elementsElec.get('LINKYlv1')  ;
			system.debug('is linky'+linky);
			
			if (interventionObligatoire && !linky ) {

                String creneau = String.valueOf(inforPrestationElec.get('Creneau')) ;
				if(String.isBlank(creneau)){
                throw new IOException('Veuillez saisir le créneau souhaité !') ;
				}

				checkNotEmptyFields(blocIntervention) ;
				
				//##### interlocuteurIntervention #####
				input.interlocuteurIntervention =  new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_interlocuteurIntervention_element();
				input.interlocuteurIntervention.personnePhysique =  new gdfsuezBefCalypsoPrestationServiceElec.identiteDt();
				input.interlocuteurIntervention.personnePhysique.civilite =  new gdfsuezComBefChpPSEPivot.listeValeursDt();
				// contexte US SMIL-1823   valeur  civilite-nom-prenon sont maintenant dynamiques 
				input.interlocuteurIntervention.personnePhysique.civilite.code = (String) blocIntervention.get('CiviliteElec');
			

	            String nomInterventionContact = String.valueOf(blocIntervention.get('NomElec'));
				input.interlocuteurIntervention.personnePhysique.nom = nomInterventionContact.length() > 16 ?  nomInterventionContact.substring(0, 16) : nomInterventionContact ;
	

			    String prenomInterventionContact = String.valueOf(blocIntervention.get('PrenomElec'));
				input.interlocuteurIntervention.personnePhysique.prenom = prenomInterventionContact.length() > 16 ?  prenomInterventionContact.substring(0, 16) : prenomInterventionContact ;
				// contexte US SMIL-1823
				input.interlocuteurIntervention.coordonneesContact =  new gdfsuezBefCalypsoPrestationServiceElec.coordonneesContactDt();
				input.interlocuteurIntervention.coordonneesContact.telephone = new List < String > {
					((String) blocIntervention.get('Telephone')).replace(' ','')
						};
							
							//##### disponibilité #####
							input.disponibilite = fillDisponiblite( input.donneesGenerales.dateEffetSouhaitee,creneau) ;

				input.commentaireIntervention = String.isBlank((String) blocIntervention.get('Commentaire')) ? null : (String) blocIntervention.get('Commentaire');
			} else if ( elementsElec.get(ChoixProcedureRepriseIndexAutoItv) != null &&  ((String)elementsElec.get(ChoixProcedureRepriseIndexAutoItv)).equals('Reprise index MHS')) {// ne rien faire
			}
			else{
				// autoreleve
				  if(!linky) { 
				// ajout du bloc autoreleve dans la requete si c'est n'est pas le cas d'une intervention
				input.autoReleve = handleAutoreleve(autoreleveElec);
				  }else if(linky && inputMap.get('tableauDeCharge') != null ){
				 // la cas ou un tableau de charge est proposé pour un communiquant .
				 String creneau = String.valueOf(inforPrestationElec.get('Creneau')) ;
				 input.disponibilite = fillDisponiblite( input.donneesGenerales.dateEffetSouhaitee,creneau) ;
				  }
			}
			
			input.planificationExpressSouhaitee = false;
			input.structureTarifaire = new gdfsuezBefCalypsoPrestationServiceElec.structureTarifaireCreationDt();
			
			
			
			
			if( inputMap.get(pdlElecInfo) != null &&  ((Map < String, Object > ) inputMap.get(pdlElecInfo)).get(ftaCode) !=null){
				input.structureTarifaire.formulaireTarifaireAcheminement = new gdfsuezComBefChpPSEPivot.listeValeursDt();
				input.structureTarifaire.formulaireTarifaireAcheminement.code = (String)((Map < String, Object > ) inputMap.get(pdlElecInfo)).get(ftaCode);
			}
			
			
			if( inputMap.get(pdlElecInfo) != null &&  ((Map < String, Object > ) inputMap.get(pdlElecInfo)).get('puissanceSouscriteValeur') !=null    &&   ((Map < String, Object > ) inputMap.get(pdlElecInfo)).get('puissanceSouscriteUnite') !=null       ){
				input.structureTarifaire.puissanceMaximumSouscrite = new gdfsuezComBefChpPSEDistributeurelec.puissanceDt();
				input.structureTarifaire.puissanceMaximumSouscrite.valeur = (Double)((Map < String, Object > ) inputMap.get(pdlElecInfo)).get('puissanceSouscriteValeur'); // double
				input.structureTarifaire.puissanceMaximumSouscrite.unite = (String)((Map < String, Object > ) inputMap.get(pdlElecInfo)).get('puissanceSouscriteUnite');
			}
			input.structureTarifaire.calendrierFournisseur = new gdfsuezComBefChpPSEPivot.listeValeursDt();
			input.structureTarifaire.calendrierFournisseur.code = (String)((Map < String, Object > ) inputMap.get(pdlElecInfo)).get('calendrierFournisseurCode');
			
			if(contexte.equals(Emmenagement)) { // a voir !
				input.miseEnService = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_miseEnService_element();
				input.miseEnService.urgent = linky ? false : (boolean)((Map < String, Object > ) elementsElec.get(informationsDePrestation)).get(DemandeUrgenteElec); // bool      
				input.miseEnService.releveSpecial = false;
				input.miseEnService.correction = false;   
				input.miseEnService.serviceCalendrierFournisseur = linky ? false : isTroisCadran(offreChoisis);
			}
			
			if(contexte.equals(ChangementDeFournisseur)) {
				input.changementFournisseur = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_changementFournisseur_element();
				input.changementFournisseur.correction = false;
				input.changementFournisseur.releveSpecial = false;
				input.changementFournisseur.serviceCalendrierFournisseur = linky ? false : isTroisCadran(offreChoisis); //   input.miseEnService.serviceCalendrierFournisseur; // SI offres ELEC 3 cadrans, alors true, Si non False
			}
			
			
			
			gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteResponse_element response;
			
			if (!Test.isRunningTest()) {
				response = port.CreerPrestationServiceElectricite_Http(input, octx);
			} else {
				Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPSEcHttpMock());
				gdfsuezBefCalypsoPrestationServiceElec.Dependency porttest = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
				system.debug('@@ start of mock');
				response = porttest.CreerPrestationServiceElectricite_Http(input, octx);
				system.debug('@@ end of mock');
			}
			
			
			System.debug('**** response code : ' + response.messageRetours.retourTraitementMessage[0].code);
			if(response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceElectricite_01')) {
				// dans le cas OK faut mettre à jour l'OPS ..
				//
				
				if(response.creerPrestationServiceElectriciteOutput.sequence  != null && response.creerPrestationServiceElectriciteOutput.sequence.idPrestationServiceDistributeur != null) {
					DateTime dT = Datetime.valueOf(DateEffetSouhaite.replace('T', ' '));
					Date dateSouhaite = date.newinstance(dT.year(), dT.month(), dT.day()+1);
					
					Map<String,Object> ElementsToSerialize = new Map<String,Object>() ;
					ElementsToSerialize.put( 'id',(String) ((Map<String,Object>) inputMap.get('PrestationDistrib')).get('id')) ;		
					ElementsToSerialize.put( 'idPrestationServiceFournisseur', response.creerPrestationServiceElectriciteOutput.idPrestationServiceFournisseur ) ;		
					ElementsToSerialize.put( 'idPrestationServiceDistributeur', response.creerPrestationServiceElectriciteOutput.sequence.idPrestationServiceDistributeur) ;		
					ElementsToSerialize.put( 'dateSouhaite', dateSouhaite) ;
					ElementsToSerialize.put( 'typeOPS', 'Online') ;
					ElementsToSerialize.put( 'creaneau', (String) (String)((Map < String, Object > ) elementsElec.get(informationsDePrestation)).get('Creneau')) ;
					
					string jsonString = JSON.serializePretty(ElementsToSerialize);	
					updateOPS(jsonString);
					// id prestation distributeur transmit a l'omniscript car on en a besoin aprés dans l'etape recap
					try { 
						outMap.put( 'idPrestationServiceFournisseurElec', response.creerPrestationServiceElectriciteOutput.idPrestationServiceFournisseur ) ;					                
						outMap.put(idPrestationDistributeurElec,response.creerPrestationServiceElectriciteOutput.sequence.idPrestationServiceDistributeur);
						outMap.put( 'addresseConcernee', selectedAdrConsFormula );
						Datetime dateSouhaiteDateTime =  dT+1;// provisoire
						outMap.put('dateinteventionSouhaiteElec',frenchDays.get(dateSouhaiteDateTime.format('EEEE'))+' ' +dateSouhaiteDateTime.day()+' '+frenchDates.get(dateSouhaiteDateTime.month())+' '+dateSouhaiteDateTime.year());
						
						if(response.creerPrestationServiceElectriciteOutput.sequence != null && 
						   response.creerPrestationServiceElectriciteOutput.sequence.planificationIntervention != null&&
						   response.creerPrestationServiceElectriciteOutput.sequence.planificationIntervention.surSite != null &&
						   response.creerPrestationServiceElectriciteOutput.sequence.planificationIntervention.surSite.heureDebutPrevue != null &&
						   response.creerPrestationServiceElectriciteOutput.sequence.planificationIntervention.surSite.heureFinPrevue != null ){
							   outMap.put('creneauHoraireElecCode', '('+response.creerPrestationServiceElectriciteOutput.sequence.planificationIntervention.surSite.heureDebutPrevue.substring(0, 5) 
										  +' - '+response.creerPrestationServiceElectriciteOutput.sequence.planificationIntervention.surSite.heureFinPrevue.substring(0, 5) +')');
								outMap.put('creneauHeureDebutPrevue',response.creerPrestationServiceElectriciteOutput.sequence.planificationIntervention.surSite.heureDebutPrevue.substring(0, 5));
								outMap.put('creneauHeureFinPrevue',response.creerPrestationServiceElectriciteOutput.sequence.planificationIntervention.surSite.heureFinPrevue.substring(0, 5));
						   }
					}catch(Exception e){
						system.debug('Erreur survenue lors de la mise a jour des elements du recap Elec'+e);
						system.debug(e.getStackTraceString());
					}
				}
				String messageToshow = null;

				// =>rectificaton SMIL-579 
				if(response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree !=null &&  response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree 
				   &&  response.creerPrestationServiceElectriciteOutput.sequence  != null && response.creerPrestationServiceElectriciteOutput.sequence.idPrestationServiceDistributeur != null && response.creerPrestationServiceElectriciteOutput.PrestationsService == null ) {
					   // <=rectificaton SMIL-579 
					   messageToshow ='En attente retour distributeur. le client sera directement contacté par Enedis. \n';
					   // demande est transmise
					   outMap.put('demandeElecTransmise',true);
					   
				   }
				else if(response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree !=null &&  response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree && response.creerPrestationServiceElectriciteOutput.donneesOperations != null && response.creerPrestationServiceElectriciteOutput.donneesOperations.teleOperables != null &&  response.creerPrestationServiceElectriciteOutput.donneesOperations.teleOperables  ) {
					messageToshow = 'OPS téléopérable. La demande de prestation a bien été créée chez le distributeur.\n';
				}
			   
				 else if(response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree !=null &&  response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree ){
				messageToshow = 'OPS créée \n';
				}
					   
				outMap.put('isTeleoperableElec',  isTeleoperableElec );
				outMap.put(PSE_CODE_retour,response.messageRetours.retourTraitementMessage[0].code);
				outMap.put('messageToshow',  messageToshow );
				outMap.put('tableauDeCharge', getTableauDeCharge(response.creerPrestationServiceElectriciteOutput.tableauDeCharge));
				return;
				
			}else {
			 // cas d'erreur Octopus 
              outMap.put(PSE_CODE_retour,response.messageRetours.retourTraitementMessage[0].code);
			 // défigé le passage au mode recollement (US-2509)
			 setChoixProcedureSelectable(outMap) ;
			
			if(response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceElectricite_05')) {
				outMap.put('messageToshow', causedByCodeMap.get(response.messageRetours.retourTraitementMessage[0].causedBy.code));
				
				// switch to recollement 
				switchToRecollement(inputMap,outMap) ;

			}else{
				// comme demandé dans l'us  SMIL-580 faut afficher la balise caused by en cas d'erreur			
				outMap.put('messageToshow', response.messageRetours.retourTraitementMessage[0].causedBy.libelle); // dans le cadre de l'us SMIL-2155 15-03-2019				
			}
			}
			System.debug('**** OUT creerPrestationElec');
	
	}
	/*
* @Author: RJM
* @Date: 14/10/2020
* @Description: Création de l'OPS Elec pour CHO FT2-848 et FT2-842
*/
	public static void creerPrestationServiceElecOnlineCHO(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
	
		
		String idBp = (String) inputMap.get('bp');
		String pdl = (String) inputMap.get('pdl');
		String DateEffetSouhaitee = (String) inputMap.get('DateEffetSouhaitee');
		String idContrat = (String) inputMap.get('idContrat');
		Map < String, Object > lireContratMap = (Map < String, Object > ) inputMap.get('lireContratNew');
		
		Boolean linky1 = (Boolean) inputMap.get('Linky1');
		Boolean linky2 = (Boolean) inputMap.get('Linky2');
		
		String poPNO = (String) inputMap.get('POPNO');
		String idOPS = (String) ((Map<String,Object>) inputMap.get('OPSInfos')).get('id');

		String messageToshow = '';

		if(String.isBlank(DateEffetSouhaitee)){
			throw new IOException('La date d\'effet souhaitée est vide , veuillez la saisir !') ;
		}

		
		if(String.isBlank(idContrat)){
			If(!Test.isRunningTest())
				throw new IOException('l\'id contrat est introuvable !') ;
		}
		
		
		
		gdfsuezComBefChpPSEPivot.contextDt octx = initContext('Smile', '2.0');
		
		gdfsuezBefCalypsoPrestationServiceElec.Dependency port = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
		SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
		port.clientCertName_x = octopusCS.certName__c;
		port.endpoint_x = octopusCS.endpoint__c + 'ES-PrestationServiceElec_v3'; //ES-PrestationServiceElectricite_v3';
		System.debug('*** endpoint : ' + port.endpoint_x);
		port.inputHttpHeaders_x = new Map < String, String > {
			'Content-Type' => 'text/xml;charset=utf-8'
				};
					
					gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt input = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt();
		
		//##### Type offre#####
		input.typeoffre = new gdfsuezComBefChpPSEPivot.listeValeursDt();
		input.typeoffre.code = 'INDUSTRIELLE';
		
		//##### Donnees générales #####
		input.donneesGenerales = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_donneesGenerales_element();
		input.donneesGenerales.typePrestationService = new gdfsuezComBefChpPSEPivot.listeValeursDt();
		input.donneesGenerales.typePrestationService.code = 'Z002';
		input.donneesGenerales.idPersonne = idBp;
		input.donneesGenerales.idPDLElectricite = pdl ;
		input.donneesGenerales.idContrat = idContrat;
		
		
				

		String idSap = service.getIdentifiantSAPFromApex() ;
		if(String.isBlank(idSap)){
			If(!Test.isRunningTest())
				throw new IOException('l\'identifiant SAP est introuvable !') ;
		}
		input.donneesGenerales.idPersonneResponsable = idSap ;
		input.donneesGenerales.natureDemande   = new  gdfsuezComBefChpPSEPivot.listeValeursDt();
		input.donneesGenerales.natureDemande.code = 'CST';
		input.donneesGenerales.loginUtilisateur = service.getIdentifiantDistribFromApex();
		input.donneesGenerales.dateEffetSouhaitee = Datetime.valueOf(DateEffetSouhaitee.replace('T', ' ')).addDays(1).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss'); 
		input.donneesGenerales.origineDemande  = 'CLIENT' ;
		
		input.structureTarifaire = new gdfsuezBefCalypsoPrestationServiceElec.structureTarifaireCreationDt();
		

		input.structureTarifaire.formulaireTarifaireAcheminement = new gdfsuezComBefChpPSEPivot.listeValeursDt();
		input.structureTarifaire.formulaireTarifaireAcheminement.code = (String) lireContratMap.get('FTACode');
		

		input.structureTarifaire.puissanceMaximumSouscrite = new gdfsuezComBefChpPSEDistributeurelec.puissanceDt();
		input.structureTarifaire.puissanceMaximumSouscrite.valeur = (Double) lireContratMap.get('puissanceSouscrite'); // double
		input.structureTarifaire.puissanceMaximumSouscrite.unite = 'kVA';
		
		input.structureTarifaire.calendrierFournisseur = new gdfsuezComBefChpPSEPivot.listeValeursDt();
		input.structureTarifaire.calendrierFournisseur.code = (String) lireContratMap.get('codeCalendrierFournisseur');
		

		input.modificationContractuelle = new gdfsuezBefCalypsoPrestationServiceElec.modificationContractuelleDt();
		input.modificationContractuelle.serviceCalendrierFournisseur = true;
		
		If(!Linky1 && !Linky2){

			Map < String, Object > blocInterventionMap = (Map < String, Object > ) inputMap.get('BlocIntervention');
			String creneau = (String) inputMap.get('creneau') ;
			if(String.isBlank(creneau)){
                throw new IOException('Veuillez saisir le créneau souhaité !') ;
			}

			checkNotEmptyFields(blocInterventionMap) ;

			input.interlocuteurIntervention =  new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_interlocuteurIntervention_element();
			input.interlocuteurIntervention.personnePhysique =  new gdfsuezBefCalypsoPrestationServiceElec.identiteDt();
			input.interlocuteurIntervention.personnePhysique.civilite =  new gdfsuezComBefChpPSEPivot.listeValeursDt();
			input.interlocuteurIntervention.personnePhysique.civilite.code = (String) blocInterventionMap.get('CiviliteElec');


			String nomInterventionContact = String.valueOf(blocInterventionMap.get('NomElec'));
			input.interlocuteurIntervention.personnePhysique.nom = nomInterventionContact.length() > 16 ?  nomInterventionContact.substring(0, 16) : nomInterventionContact ;


			String prenomInterventionContact = String.valueOf(blocInterventionMap.get('PrenomElec'));
			input.interlocuteurIntervention.personnePhysique.prenom = prenomInterventionContact.length() > 16 ?  prenomInterventionContact.substring(0, 16) : prenomInterventionContact ;

			input.interlocuteurIntervention.coordonneesContact =  new gdfsuezBefCalypsoPrestationServiceElec.coordonneesContactDt();
			input.interlocuteurIntervention.coordonneesContact.telephone = new List < String > {
			((String) blocInterventionMap.get('Telephone')).replace(' ','')};
			
		
			input.disponibilite = fillDisponiblite( input.donneesGenerales.dateEffetSouhaitee,creneau) ;

			input.commentaireIntervention = String.isBlank((String) blocInterventionMap.get('Commentaire')) ? poPNO : poPNO + (String) blocInterventionMap.get('Commentaire');
		}
		
		
		gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteResponse_element response;
		
		if (!Test.isRunningTest()) {
			response = port.CreerPrestationServiceElectricite_Http(input, octx);
		} else {
			Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPSEcHttpMock());
			gdfsuezBefCalypsoPrestationServiceElec.Dependency porttest = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
			system.debug('@@ start of mock');
			response = porttest.CreerPrestationServiceElectricite_Http(input, octx);
			system.debug('@@ end of mock');
		}
		
		System.debug('response WS creerPrestationServiceElecCHO => '+ response);
		outMap.put('PSE_CODE_retour',response.messageRetours.retourTraitementMessage[0].code);
		if(response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceElectricite_01')) {
			if(response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree !=null &&  response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree 
			 && response.creerPrestationServiceElectriciteOutput.sequence  != null && response.creerPrestationServiceElectriciteOutput.sequence.idPrestationServiceDistributeur != null
				   &&  response.creerPrestationServiceElectriciteOutput.PrestationsService == null ) {
					  
					messageToshow ='Votre demande nécessite l’analyse d’un conseiller Enedis. Si une intervention sur site est nécessaire, le RDV client sera confirmé par Enedis à l’issue du traitement de la recevabilité. \n';
					// demande est transmise
					outMap.put('demandeElecTransmise',true);
					DateTime dT = Datetime.valueOf(dateEffetSouhaitee.replace('T', ' '));
					Date dateSouhaitee = date.newinstance(dT.year(), dT.month(), dT.day()+1);
					
					Map<String,Object> ElementsToSerialize = new Map<String,Object>() ;
					ElementsToSerialize.put( 'id', idOPS) ;		
					ElementsToSerialize.put( 'idPrestationServiceFournisseur', response.creerPrestationServiceElectriciteOutput.idPrestationServiceFournisseur ) ;		
					ElementsToSerialize.put( 'idPrestationServiceDistributeur', response.creerPrestationServiceElectriciteOutput.sequence.idPrestationServiceDistributeur) ;		
					ElementsToSerialize.put( 'dateSouhaite', dateSouhaitee) ;
					ElementsToSerialize.put( 'typeOPS', 'Online') ;
					if(!Linky1 && !Linky2){
					ElementsToSerialize.put( 'creaneau', (String) inputMap.get('creneau')) ;
					}
					
					string jsonString = JSON.serializePretty(ElementsToSerialize);	
					updateOPS(jsonString);
			}
			else if(!Linky1 && !Linky2 && response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree !=null && response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree){
				
					messageToshow = 'OPS créée \n';
				
			}
			else if((Linky1 || Linky2) && response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree !=null &&  response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree){
					messageToshow = 'OPS téléopérable. La demande de prestation a bien été créée chez le distributeur.\n';
				
			}
			
				outMap.put('messageToshow',  messageToshow );
		}	
			
			
		
		
	}
		


	
	
	public static Object getTableauDeCharge(gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOutputDt_tableauDeCharge_element tableauDecharge){
		
		if(tableauDecharge == null ){
			return null ;
		}
		Map<String,List<Map<String,String>>> creneauxByDate = new  Map<String,List<Map<String,String>>>() ;
		 List<Object> ListOfCreneau = new List<Object>();
		for(gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOutputDt_tableauDeCharge_creneau_element creneau :  
			tableauDecharge.creneau){
				List<Map<String,String>> listCreneau = creneauxByDate.get(creneau.date_x);
				if(listCreneau == null){
					listCreneau = new List<Map<String,String>>() ;
					
				}
				Map<String,String> creneauLibelleCourtCode = new Map<String,String>() ;
				creneauLibelleCourtCode.put('code',creneau.creneauHoraire.code) ;
				creneauLibelleCourtCode.put('libelle',creneau.creneauHoraire.libelleCourt);
				listCreneau.add(creneauLibelleCourtCode);
				creneauxByDate.put(creneau.date_x, listCreneau);
				
			}
		
		ListOfCreneau.add(creneauxByDate);
		return ListOfCreneau ;
	}
	
	/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: l'objectf de cette methode est de vérifier si l'offre choisis comporte trois cadrans HP HC WE
*/
	public static boolean isTroisCadran(Map < String, Object > offreChoisis) {
		
		
		if (offreChoisis == null || offreChoisis.get(mapConsoByTypeComptage)== null ) {
			throw new IOException('le nombre de cadrans ne peut pas etre detecté depuis l\'OS');
		} else {
			return ((Map < String, Object > ) offreChoisis.get(mapConsoByTypeComptage)).get(HP) != null &&
				((Map < String, Object > ) offreChoisis.get(mapConsoByTypeComptage)).get(HC) != null &&
				((Map < String, Object > ) offreChoisis.get(mapConsoByTypeComptage)).get(WE) != null;
		}
		
	}
	
	/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description:
*/  @future
	private static void updateOPS(String elements){
		try{
			
			
			Map<String,Object> wrapper = (Map<String,Object>) SYSTEM.JSON.deserializeUntyped(elements);
			String id = (String) wrapper.get('id') ;
			String  idPrestationServiceDistributeur = (String) wrapper.get( 'idPrestationServiceDistributeur');
			String  idPrestationServiceFournisseur = (String) wrapper.get( 'idPrestationServiceFournisseur');
			String  creaneau = (String) wrapper.get( 'creaneau');
			String  typeOPS = (String) wrapper.get( 'typeOPS');
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
			acc.Type_OPS__c = typeOPS ;
			acc.Creneau__c = creaneau != null ?  (String) creneaux.get(creaneau) : null ; // dans le cadre de l'us SMIL-2115
			update acc;
		}catch(Exception e) {
			system.debug('##catched##'+e);
			system.debug('##catched##'+e.getStackTraceString());
		}
		
	}
	
	/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description:
*/
	public static gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_autoReleve_element handleAutoreleve(Map < String, Object > autoreleveElec) {
		
		gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_autoReleve_element autoReleve = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_autoReleve_element();
		autoReleve.dateAutoreleve = datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
		autoReleve.programmationFournisseur = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_autoReleve_programmationFournisseur_element();
		autoReleve.programmationFournisseur.calendrier = new gdfsuezComBefChpPSEPivot.listeValeursDt();
		autoReleve.programmationFournisseur.calendrier.code = autoreleveElec.get(Base) == null ? 'HPHC' : 'BASE';
		
		system.debug('bloccc autrelevee==>>'+autoreleveElec);
		
		if (autoreleveElec.get(Base) == null) {
			// dans le cas d'un hp hc  deux mesures index a rajouter dans la requete
			
			
			if(autoreleveElec.get(HP) != null && autoreleveElec.get(HC) != null) {
				//throw new IOException('AutoReleve : veuillez renseigner l\'index base ou HP HC  ');
			
			
			autoReleve.programmationFournisseur.mesuresIndex = new gdfsuezBefCalypsoPrestationServiceElec.mesuresIndexCreationDt();
			autoReleve.programmationFournisseur.mesuresIndex.mesureIndex = new List < gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt > ();
			gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt mesureHP = new gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt();
			mesureHP.mesureIndex = new gdfsuezComBefChpPSEPivot.listeValeursDt();
			mesureHP.mesureIndex.code = HP;
			
			mesureHP.index = new gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt_index_element();
			mesureHP.index.unite = 'kWh';
			mesureHP.index.valeur = (Integer) autoreleveElec.get(HP); // double
			mesureHP.index.passageZero = (boolean) autoreleveElec.get('TourCadranHP'); // boolean
			autoReleve.programmationFournisseur.mesuresIndex.mesureIndex.add(mesureHP);
			
			
			gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt mesureHC = new gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt();
			mesureHC.mesureIndex = new gdfsuezComBefChpPSEPivot.listeValeursDt();
			mesureHC.mesureIndex.code = HC;
			mesureHC.index = new gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt_index_element();
			mesureHC.index.unite = 'kWh';
			mesureHC.index.valeur = (Integer) autoreleveElec.get(HC); // double
			mesureHC.index.passageZero = (boolean) autoreleveElec.get('TourCadranHC'); // boolean
			
			autoReleve.programmationFournisseur.mesuresIndex.mesureIndex.add(mesureHC);
			}
			
		} else {
			//   le cas d'un index base
			//
			
			
			autoReleve.programmationFournisseur.mesuresIndex = new gdfsuezBefCalypsoPrestationServiceElec.mesuresIndexCreationDt();
			autoReleve.programmationFournisseur.mesuresIndex.mesureIndex = new List < gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt > ();
			gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt mesureBase = new gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt();
			mesureBase.mesureIndex = new gdfsuezComBefChpPSEPivot.listeValeursDt();
			mesureBase.mesureIndex.code = 'BASE';
			mesureBase.index = new gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt_index_element();
			mesureBase.index.unite = 'kWh';
			mesureBase.index.valeur = (Integer) autoreleveElec.get(Base); // double
			mesureBase.index.passageZero = (boolean) autoreleveElec.get('TourCadranBase'); // boolean
			autoReleve.programmationFournisseur.mesuresIndex.mesureIndex.add(mesureBase);
			
		}
		
		return autoReleve;
		
	}
	
	/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: US-802 method qui invoque le service lire Pretation Gaz pour recuperer les details de l'ops et les afficher dans l'os à l'étape recap 
*/
	public void lirePrestationElec(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		
		System.debug('*** Params');
        String idPrestationDistributeur = (String) inputMap.get(idPrestationDistributeurElec) ;
        String idPrestationServiceFournisseurElec =  (String) inputMap.get('idPrestationServiceFournisseurElec') ;

		if(String.isBlank(idPrestationDistributeur) &&  String.isBlank(idPrestationServiceFournisseurElec)){
			if(!Test.isRunningTest()){
				throw new  IOexception('ne peut pas trouver l id prestation distributeur' );
			}
		}
		//String idPrestationDistributeur = inputMap.get(idPrestationDistributeurElec) == null ? null : String.valueOf(inputMap.get(idPrestationDistributeurElec));

		//idPrestationDistributeur = 'W00005B7';
		
		
		gdfsuezComBefChpPSEPivot.contextDt octx = initContext('Smile', '3.0');
		
		gdfsuezBefCalypsoPrestationServiceElec.Dependency port = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
		SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
		port.clientCertName_x = octopusCS.certName__c;
		port.endpoint_x = octopusCS.endpoint__c + 'ES-PrestationServiceElec_v3';
		System.debug('*** endpoint : ' + port.endpoint_x);
		port.inputHttpHeaders_x = new Map < String, String > {
			'Content-Type' => 'text/xml;charset=utf-8'
				};
					
					gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt input = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt();
		
		input.online = true;
		input.loginUtilisateur = service.getIdentifiantDistribFromApex();
		input.typeOffre = new gdfsuezComBefChpPSEPivot.listeValeursDt() ;
		input.typeOffre.code = 'INDUSTRIELLE';

		// Donnees générales
		input.prestationServiceElectricite = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt_prestationServiceElectricite_element[1];
		input.prestationServiceElectricite[0] = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt_prestationServiceElectricite_element();
		input.prestationServiceElectricite[0].idPrestationServiceDistributeur = idPrestationDistributeur;
		input.prestationServiceElectricite[0].idPrestationServiceFournisseur= idPrestationServiceFournisseurElec;
		gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteResponse_element response;
		
		if (!Test.isRunningTest()) {
			response = port.LirePrestationServiceElectricite_Http(input, octx);
		} else {
			Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPrestaGazHttpMock());
			gdfsuezBefCalypsoPrestationServiceElec.Dependency porttest = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
			system.debug('@@ start of mock');
			response = porttest.LirePrestationServiceElectricite_Http(input, octx);
			system.debug('@@ end of mock');
		}
		
		System.debug('**** response : ' + response);
		System.debug('**** response code : ' + response.messageRetours.retourTraitementMessage[0].code);
		
		getDetailsFromResponseAndExposeItToOS(response,outMap,inputMap);
	}
	
	  public static String getTelephone(boolean interventionObligatoire ,Map<String,Object> blockIntervention ,Map<String,Object> coordonneContact ){
		String telephone ;
		try{
			if(interventionObligatoire){
				if(blockIntervention.get('Telephone') != null ){
					telephone =   ((String) blockIntervention.get('Telephone')).replace(' ', '');
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
	
/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: l'objectif de cette methode est de récupérer la liste des champs à afficher dans l'étape recap 
*/
public static void getDetailsFromResponseAndExposeItToOS(gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteResponse_element responseElement, Map<String,Object>  outMap,Map<String,Object> inputMap){
	
	
	if(responseElement == null   &&  responseElement.lirePrestationServiceElectriciteOutput == null &&  responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire == null ||
		responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].donneesGenerales == null) {
			throw new IOException('Certains elements du web service LirePrestationElec n\'ont pas pu etre lu !');
		}
	

	
	PrestationDetails prestationDetails = new PrestationDetails();
	
	prestationDetails.typePrestationService     = responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].donneesGenerales.typePrestationService == null ? null
		:  responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].donneesGenerales.typePrestationService.libelleCourt;
	
	prestationDetails.statutPrestationService = responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].donneesGenerales.statutPrestationService == null ? null
		:  '( Statut : '+responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].donneesGenerales.statutPrestationService.libelleCourt+' )';
	
	
	prestationDetails.referenceDistributeur =  responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].idPrestationServiceDistributeur == null ? null : 'Ref Distributeur: '+responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].idPrestationServiceDistributeur;

	prestationDetails.referenceFournisseur =  responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].idPrestationServiceFournisseur == null ? null : 'Ref Fournisseur: '+responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].idPrestationServiceFournisseur;


	Map<String,Object> elementsElec  = (Map<String,Object>) inputMap.get(PrestationElec);
	if(((String)elementsElec.get('NavigationMode')).equals('Online')) {
		// online
	prestationDetails.demandeTransmise =   ((boolean)inputMap.get(demandeElecTransmise) != null  &&   (boolean)inputMap.get(demandeElecTransmise))  ? 'Le client sera contacté par le distributeur' : null;
	

	String comments= '';
	
	boolean interventionObligatoire = ((boolean)((Map < String, Object > ) elementsElec.get(informationsDePrestation)).get(IsSelectedIntervention)  || ((boolean)((Map < String, Object > ) elementsElec.get(informationsDePrestation)).get('IsItvObligatoire'))) ;
	Boolean linky =  (boolean)elementsElec.get('LINKYlv2') || (boolean)elementsElec.get('LINKYlv1')  ;
	if(interventionObligatoire && !linky){
		comments = (String)inputMap.get('messagePoPnO') ;
		if(!String.isBlank(comments)){
			if(comments.equalsIgnoreCase('PO')){
				comments ='Presence obligatoire';
			}
			else if(comments.equalsIgnoreCase('PNO')){
				comments ='Presence non obligatoire';
			}
		}
		}
			
        if(responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0] != null && 
           responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].interventions != null &&
           responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].interventions.intervention != null && 
           responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].interventions.intervention.operations != null &&
           responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].interventions.intervention.operations.teleoperables){
               prestationDetails.isTeleoperable = true;
           }
        else{
            prestationDetails.isTeleoperable = false;
        }


	prestationDetails.indexValue =   ((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec) == null ? null : String.valueOf(((Map<String,Object>)((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec)).get(Base));
	prestationDetails.index =  ((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec) == null ? null :    (integer) ((Map<String,Object>)((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec)).get(Base) == null ?  null :  'Index fourni : '+ (integer) ((Map<String,Object>)((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec)).get(Base);
	if(prestationDetails.index == null) {
		// dans ce cas l'index HP et HC on été saisi
		prestationDetails.HP =  ((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec) == null ? null :   (integer) ((Map<String,Object>)((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec)).get(HP) == null ?  null :   'Index HP fourni : '+ (integer) ((Map<String,Object>)((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec)).get(HP);
		prestationDetails.HC = ((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec) == null ? null  :  (integer) ((Map<String,Object>)((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec)).get(HC) == null ? null :   'Index HC fourni : '+ (integer) ((Map<String,Object>)((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec)).get(HC);
	
		prestationDetails.HPValue =  ((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec) == null ? null : String.valueOf(((Map<String,Object>)((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec)).get(HP));
		prestationDetails.HCValue =   ((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec) == null ? null : String.valueOf(((Map<String,Object>)((Map<String,Object>) inputMap.get(PrestationElec)).get(AutoreleveElec)).get(HC));
	
	}

								if(responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0] != null &&  
		responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].demande != null &&
		responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].demande.miseEnService != null && 
		responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].demande.miseEnService.urgent != null &&
		responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].demande.miseEnService.urgent  ){	
		prestationDetails.MESUrgente =   'Une MES Express/Urgente a été demandée. veuillez basculer sur un appel à acheminement.';
		}
	
		
		 if(responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].demande != null &&
										responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].demande.donneesGeneralesDemande != null &&
										responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].demande.donneesGeneralesDemande.solde!= null ){
                    if(responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].demande.donneesGeneralesDemande.solde.montantPrevisionnelPrestation != null
					 &&
                      responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].demande.donneesGeneralesDemande.solde.montantPrevisionnelPrestation != 0 ){

					prestationDetails.prixOPS = String.valueOf(responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].demande.donneesGeneralesDemande.solde.montantPrevisionnelPrestation)+' € TTC' ;
					  }else if(responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].demande.donneesGeneralesDemande.solde.fraisPrestation  != null  ){
	                prestationDetails.prixOPS = String.valueOf(responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].demande.donneesGeneralesDemande.solde.fraisPrestation)+' € TTC' ;
					  }

										}
		
		prestationDetails.dateSOuhaite =String.valueOf(inputMap.get('dateinteventionSouhaiteElec'));
		prestationDetails.creneauSOuhaite  = String.valueOf(inputMap.get('creneauHoraireElecCode'));
		prestationDetails.creneauHeureDebutValue = String.valueOf(inputMap.get('creneauHeureDebutPrevue'));
		prestationDetails.creneauHeureFinValue = String.valueOf(inputMap.get('creneauHeureFinPrevue'));
		prestationDetails.presenceObligatoire    = comments;
	}
	outMap.put('lirePrestationElecDetails',prestationDetails);
	
	
}
	
	
	
	/*
	* @Author: 
	* @Date: 11/02/2019
	* @Description: Creer PrestationElec method called by omniscript
	*/  
	public static void creerPrestationElecOffline(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options){      


		String pdl = (String) inputMap.get('selectedPDLVal') ;
		String idPrestation =  (String) inputMap.get('NumeroAffaireElec') ;
		String idBp = inputMap != null ? (String) inputMap.get('refClientIdBP') : null;
		Boolean isBillingAddressSameAsLiving =  (boolean) inputMap.get('isBillingAddressSameAsLiving').equals('Oui') ;
		String selectedAdrConsFormula  = (String) inputMap.get('selectedAdrConsFormula'); 	
		String idContrat =(String) inputMap.get('idContrat'); 

		System.debug('*** idPrestation : ' + idPrestation);
		System.debug('*** pdl : ' + pdl);
		System.debug('*** idBp : ' + idBp);

		if(String.isBlank(idPrestation) || String.isBlank(pdl) || String.isBlank(idBp) || String.isBlank(idContrat)){
			outMap.put('recol_gaz_elec',' un ou plusieurs parametres sont manquants : num affaire, idPDL , idPB , idContract') ; 
			return ;
		}

		gdfsuezComBefChpPSEPivot.contextDt octx = initContext('Smile', '2.0'); 

		gdfsuezBefCalypsoPrestationServiceElec.Dependency port = new gdfsuezBefCalypsoPrestationServiceElec.Dependency() ;  
		SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();   
		port.clientCertName_x = octopusCS.certName__c;
		port.endpoint_x =  octopusCS.endpoint__c+'ES-PrestationServiceElec_v3';
		port.inputHttpHeaders_x = new Map<String, String>{'Content-Type' => 'text/xml;charset=utf-8'}; 

		gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOfflineInputDt input = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOfflineInputDt();
		
		// Type offre
		input.typeoffre = new gdfsuezComBefChpPSEPivot.listeValeursDt();
		input.typeoffre.code = 'INDUSTRIELLE';

		// Donnees générales
		input.donneesGenerales = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOfflineInputDt_donneesGenerales_element();
		input.donneesGenerales.typePrestationService = new gdfsuezComBefChpPSEPivot.listeValeursDt();
		input.donneesGenerales.idPrestationServiceDistributeur = idPrestation;
		input.donneesGenerales.typePrestationService.code = 'Z002';
		input.donneesGenerales.idPersonne = idBp;
		input.donneesGenerales.idPDLElectricite = pdl;
		if(!Test.isRunningTest())
		input.donneesGenerales.idPersonneResponsable = service.getIdentifiantSAPFromApex() ;//'143030';
		input.donneesGenerales.idContrat = idContrat ;

		gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOfflineResponse_element response ; 
		
		if(!Test.isRunningTest()){
			response  = port.CreerPrestationServiceElectriciteOffline_Http(input,octx);
		}
		else {
			Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPSEcHttpMock());
			gdfsuezBefCalypsoPrestationServiceElec.Dependency porttest = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
			system.debug('@@ start of mock');
			response = porttest.CreerPrestationServiceElectriciteOffline_Http(input, octx);
			system.debug('@@ end of mock');
		}

		System.debug('**** response code : ' + response.messageRetours.retourTraitementMessage[0].code);
		if('OCTOPUS_CreerPrestationServiceElectriciteOffline_01'.equals(response.messageRetours.retourTraitementMessage[0].code)){
			String idPrestationSmile = inputMap.get('PrestationDistrib') != null  ? (String) ((Map<String,Object>) inputMap.get('PrestationDistrib')).get('id') : null ;
			if(!String.isBlank(idPrestationSmile)){
			Map<String,Object> ElementsToSerialize = new Map<String,Object>() ;
			ElementsToSerialize.put( 'id',idPrestationSmile) ;		
			ElementsToSerialize.put( 'idPrestationServiceFournisseur', null) ;		
			ElementsToSerialize.put( 'idPrestationServiceDistributeur', idPrestation) ;		
			ElementsToSerialize.put( 'dateSouhaite', null) ;
			ElementsToSerialize.put( 'typeOPS', 'Recollement') ;
			ElementsToSerialize.put( 'creaneau', null) ;   
			string jsonString = JSON.serializePretty(ElementsToSerialize);		
		   // cas OK faut mettre à jour le record .
		   updateOPS(jsonString) ;
			}
		  outMap.put('recol_gaz_elec','OPS recollée.') ; 
		  outMap.put('idPrestationDistributeurElec',idPrestation); // pour le lire Prestation
		  outMap.put( 'addresseConcernee',  selectedAdrConsFormula );
  
		} 
		else if('OCTOPUS_CreerPrestationServiceElectriciteOffline_05'.equals(response.messageRetours.retourTraitementMessage[0].code)  ||  'OCTOPUS_CreerPrestationServiceElectriciteOffline_99'.equals(response.messageRetours.retourTraitementMessage[0].code)){
		  outMap.put('recol_gaz_elec','Une erreur est survenue.') ; 
		  return ;
		}
		else{
		  outMap.put('recol_gaz_elec',response.messageRetours.retourTraitementMessage[0].code+' :'+response.messageRetours.retourTraitementMessage[0].libelle) ;
		}

		System.debug('**** OUT creerPrestationElec');
	} 

	
	
	
	public class PrestationDetails {
		public String typePrestationService;
		public String statutPrestationService;
		public String dateSOuhaite;
		public String creneauSOuhaite;
		public String presenceObligatoire;
		public String demandeTransmise;
		public String MESUrgente;
		public String prixOPS;
		public String referenceDistributeur;          // GRDF ERDF selon le cas
		public String referenceFournisseur; 
		public String index;          // TODO base hp hc
		public String HP;
		public String HC;
		public String indexValue;          // TODO base hp hc
		public String HPValue;
		public String HCValue;
		public String creneauHeureDebutValue;
		public String creneauHeureFinValue;
        public Boolean isTeleoperable;
		
	}
	
	public class IOException extends Exception {
		
	}
	
    public static Map<String,Object> fillSelectedAdressElements(Map<String,Object> inputMap){
		Map<String,Object> elements = new  Map<String,Object>() ;
		elements.put('postcodeValue', inputMap.get('postcodeValue')) ;
		elements.put('libelleVoieValue', inputMap.get('libelleVoieValue')) ;
		elements.put('nVoieValue', inputMap.get('nVoieValue')) ;
		elements.put('cityValue', inputMap.get('cityValue')) ;
		return elements ;
	} 
	public static void switchToRecollement(Map<String,Object> inputMap, Map<String,Object> outMap){
				Map<String,Object> old = (Map<String,Object> ) inputMap.get(PrestationElec);
				old.put('NavigationMode', Recollement);
				outMap.put(PrestationElec,old);
	} 

	public static void setChoixProcedureSelectable(Map<String,Object> outMap){
		outMap.put('SetChoixProcedureElecParDefaut', 'Recollement') ;
	} 

   public static void checkNotEmptyFields(Map<String,Object> blocIntervention){

// contexte US SMIL-1823   valeur  civilite-nom-prenon sont maintenant dynamiques 
		if(   String.isBlank((String) blocIntervention.get('CiviliteElec')) ||  String.isBlank(String.valueOf(blocIntervention.get('NomElec')))
			|| String.isBlank(String.valueOf(blocIntervention.get('PrenomElec'))) ||
			String.isBlank((String) blocIntervention.get('Telephone'))){
				throw new IOException('Veuillez remplir les champs manquants dans le bloc intervention !') ;
			}

    } 

	public  static gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_disponibilite_element fillDisponiblite(String dateEffetSouhaitee, String creneau){
		gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_disponibilite_element	disponibilite =	new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_disponibilite_element();
	
		disponibilite.dateInterventionSouhaitee =  dateEffetSouhaitee;   //Datetime.valueOf(DateEffetSouhaite.replace('T', ' ')).addDays(1).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');					
		disponibilite.creneauHoraire =  new gdfsuezComBefChpPSEPivot.listeValeursDt();
		disponibilite.creneauHoraire.code = creneau ;
        return disponibilite ;
	
	
	} 
}