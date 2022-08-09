public virtual class SM_AP41_PrestaServiceElecCommon {
    public SM_AP41_PrestaServiceElecCommon() {

    }



	public static SM_UTIL_Cache_Management service = new SM_UTIL_Cache_Management();
	public final Map < String, Object > causedByCodeMap = new Map < String, String > {
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
				public  Map<Integer, String> frenchDates ;
	            public  Map<String, String> frenchDays ;
	



{
    System.debug('ok 1') ;
               frenchDates = new Map<Integer, String>();
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

                
                 frenchDays = new Map<String, String>();
                frenchDays.put('Monday', 'Lundi');
                frenchDays.put('Tuesday', 'Mardi');
                frenchDays.put('Wednesday', 'Mercredi');
                frenchDays.put('Thursday', 'Jeudi');
                frenchDays.put('Friday', 'Vendredi');
                frenchDays.put('Saturday', 'Samedi');
                frenchDays.put('Sunday', 'Dimanche');
                System.debug('ok 2') ;

}

	//Parameters
	//contant the elemnts names in the omniscripts (moveIn , CreateOPS) 
	public final  String ChoixElements = 'ChoixElements' ;
	public final  String chooseSellingOption = 'chooseSellingOption' ;
	public final  String Emmenagement ='Emménagement' ;
	public final  String ChangementDeFournisseur ='Changement de fournisseur';
	public final  String OffreChoisis = 'OffreChoisis' ;
	public final  String ChoixElements1 ='ChoixElements1' ;
	public final  String PrestationElec  = 'PrestationElec' ; 
	public final  String BlocIntervention = 'BlocIntervention' ; 
	public final  String InfoRecollementElec = 'InfoRecollementElec';
	public final  String AutoreleveElec = 'AutoreleveElec' ; 
	public final  String informationsDePrestation = 'Informations de prestation' ;
	public final  String ContactInfo = 'ContactInfo'; 
	public final  String TelMobile = 'TelMobile' ;
	public final  String AdresseEmail ='AdresseEmail' ;
	public final  String AdresseContact ='AdresseContact' ;
	public final  String refClientIdBP ='refClientIdBP' ;
	public final  String selectedPDLVal ='selectedPDLVal' ;
	public final  String DateEffetSouhaite ='DateEffetSouhaite' ;
	public final  String DemandeUrgenteElec = 'DemandeUrgenteElec' ;
	public final  String OrigineDemande1 ='OrigineDemande1';
	public final  String isBillingAddressSameAsLiving = 'isBillingAddressSameAsLiving' ;
	public final  String IsSelectedIntervention = 'IsSelectedIntervention';
	public final  String ServicesGestion = 'ServicesGestion';
	public final  String PrelevementBlock = 'PrelevementBlock' ;
	public final  String pdlElecInfo =  'pdlElecInfo' ;
	public final  String getEmailPrincipale  = 'getEmailPrincipale' ;
	public final  String AddressIndication ='AddressIndication' ; 
	public final  String ComplementAdresse  = 'ComplementAdresse' ;
	public final  String  ftaCode =  'ftaCode' ;
	public final  String ChoixProcedureRepriseIndexAutoItv = 'ChoixProcedureRepriseIndexAutoItv' ;
	public final  String demandeElecTransmise = 'demandeElecTransmise' ;
	public final  String HP =  'HP';
	public final  String HC =  'HC' ;
	public final  String WE ='WE' ;
	public final  String mapConsoByTypeComptage =  'mapConsoByTypeComptage';
	public final  String PSE_CODE_retour = 'PSE_CODE_retour' ;
	public final  String Base = 'Base' ;
	public  final  String idPrestationDistributeurElec  ='idPrestationDistributeurElec' ;
    public final  String SetChoixProcedureElecParDefaut  ='SetChoixProcedureGazParDefaut' ;
	public final  String Recollement  ='Recollement' ;




	/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: init context
*/
	public  gdfsuezComBefChpPSEPivot.contextDt initContext(String application, String version) {
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

	

				



	public  gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_autoReleve_element handleAutoreleve(Map < String, Object > autoreleveElec) {
		
		gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_autoReleve_element autoReleve = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_autoReleve_element();
		autoReleve.dateAutoreleve = datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
		autoReleve.programmationFournisseur = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_autoReleve_programmationFournisseur_element();
		autoReleve.programmationFournisseur.calendrier = new gdfsuezComBefChpPSEPivot.listeValeursDt();
		autoReleve.programmationFournisseur.calendrier.code = autoreleveElec.get(Base) == null ? 'HPHC' : 'BASE';
		
		system.debug('bloccc autrelevee==>>'+autoreleveElec);
		
		if (autoreleveElec.get(Base) == null) {
			// dans le cas d'un hp hc  deux mesures index a rajouter dans la requete
			
			
			if(autoreleveElec.get(HP) == null || autoreleveElec.get(HC) == null) {
				throw new IOException('AutoReleve : veuillez renseigner l\'index base ou HP HC  ');
			}
			
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


	public  void switchToRecollement(Map<String,Object> inputMap, Map<String,Object> outMap){
				Map<String,Object> old = (Map<String,Object> ) inputMap.get(PrestationElec);
				old.put('NavigationMode', Recollement);
				outMap.put(PrestationElec,old);
	} 


	public class IOException extends Exception {
		
	}
	

}