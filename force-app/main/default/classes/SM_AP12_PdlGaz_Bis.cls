/*
* @Author: Raouaa Jmour
* @Date: 20/01/2020
* @Description: Classe Apex faisant appel à l'opération lirePdlGaz
*/


global class SM_AP12_PdlGaz_Bis implements vlocity_cmt.VlocityOpenInterface {

    public static SM_UTIL_Cache_Management service = new SM_UTIL_Cache_Management();


    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
			if (methodName.equals('lirePdlGaz')) {
					try {
							lirePdl(inputMap, outMap, options);
					}
					catch (Exception e) {
							system.debug(e.getStackTraceString());
							return false;
					}
			}
			return true;
	}

    public static gdfsuezComBefChpPivot.contextDt initContext(String application, String version) {
			// Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
			gdfsuezComBefChpPivot.system_element osource = new gdfsuezComBefChpPivot.system_element();
			osource.systemId=application;
			gdfsuezComBefChpPivot.contextDt octx = new gdfsuezComBefChpPivot.contextDt();
			octx.version=version;
			//  octx.allowCache = false ;
			octx.systemPath = new gdfsuezComBefChpPivot.systemPath_element();
			octx.systemPath.system_x = new gdfsuezComBefChpPivot.system_element[] {osource};
			return octx;
	}


    public static void lirePdl(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

		    String pceGaz = null ;
		
		    pceGaz = (String) inputMap.get('pce');
		
		    if(pceGaz == null || pceGaz.length() == 0) {
				system.debug('no pce selected ');
				return;
		    }
		


			gdfsuezComBefChpPivot.contextDt octx = initContext('Smile', '2.0');
			gdfsuezBefCalypsoPdlgazV2.Dependency port = new gdfsuezBefCalypsoPdlgazV2.Dependency();
			SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
			port.clientCertName_x = octopusCS.certName__c;
			port.endpoint_x =  octopusCS.endpoint__c+'ES-PDLGaz_v2';
			//  port.endpoint_x = 'https://octopus.ws-ines-rct.engie.com:50001/smile-noprod-gdc/ws/ES-PDLGaz_v2';
			port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};

			gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt input = new  gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt();
			input.online = true;
			input.typeOffre = new gdfsuezComBefChpPivot.listeValeursDt();
			input.typeOffre.code = 'INDUSTRIELLE';  // à externaliser
			input.loginUtilisateur = service.getIdentifiantDistribFromApex();


			gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt_PDLGaz_element element = new gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt_PDLGaz_element();
			element.PDLGaz= new gdfsuezComBefCalypsoPdlgaz.PDLGazAbstract();
			element.PDLGaz.idPDLGaz =  pceGaz; //'21101817097249' ;
			element.recupererDerniersIndexGaz= true;
			element.AutorisationSituationContractuelle= true ; // US SMIL-1842
			input.PDLGaz = element;
			gdfsuezBefCalypsoPdlgazV2.lirePDLGazResponse_element response;

			if(!Test.isRunningTest()) {
					response  = port.LirePDLGaz_Http(input,octx);
			}
			else {
					Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPdlgazV2HttpMock());
					gdfsuezBefCalypsoPdlgazV2.Dependency porttest = new gdfsuezBefCalypsoPdlgazV2.Dependency();
					system.debug('@@ start of mock');
					response = porttest.LirePDLGaz_Http(input, octx);
					system.debug('@@ end of mock');

			}



			gdfsuezBefCalypsoPdlgazV2.PDLGaz_donneesContractuelles_element donneesContractuelles;
			if(response.lirePDLGazOutput != null && response.lirePDLGazOutput.donneesPDL != null && response.lirePDLGazOutput.donneesPDL[0].donneesContractuelles != null ) {
					donneesContractuelles =  response.lirePDLGazOutput.donneesPDL[0].donneesContractuelles;
			}

			gdfsuezBefCalypsoPdlgazV2.PDLGaz_dernieresReleves_element derniersreleve;

			if( response.lirePDLGazOutput != null  && response.lirePDLGazOutput.donneesPDL != null && response.lirePDLGazOutput.donneesPDL[0].dernieresReleves != null ) {
					derniersreleve= response.lirePDLGazOutput.donneesPDL[0].dernieresReleves;
			}

			List<Object> listOfreleves =  null;
			DateTime dateDerniereReleve  = null;
			double dernierIndex ;
		   String natureIndex;
			if(derniersreleve != null) {
					listOfreleves = new List<Object>();
					gdfsuezBefCalypsoPdlgazV2.releve6M_1MDt[] listofReleve = derniersreleve.releve6M_1M;

					if(listofReleve !=null) {
							for(gdfsuezBefCalypsoPdlgazV2.releve6M_1MDt releve : listofReleve ) {
									listOfreleves.add(new Mesures(releve.dateFin,releve.indexFin));
									if(dateDerniereReleve == null) {
											// pour initaliser la date
											dateDerniereReleve = releve.dateFin;
										   dernierIndex = releve.indexFin ;
											//   break ;
									}

									if(releve.dateFin > dateDerniereReleve) {
											dateDerniereReleve = releve.dateFin;
											dernierIndex = releve.indexFin ;
									}
							}
					}
			}else if(response.lirePDLGazOutput != null && response.lirePDLGazOutput.donneesPDL != null  && response.lirePDLGazOutput.donneesPDL[0].derniersIndex != null  && response.lirePDLGazOutput.donneesPDL[0].derniersIndex.index != null){
				for(gdfsuezBefCalypsoPdlgazV2.PDLGaz_derniersIndex_index_element index : response.lirePDLGazOutput.donneesPDL[0].derniersIndex.index) {
					if(dateDerniereReleve == null) {  
						dateDerniereReleve = index.dateIndex;
						dernierIndex = index.valeurIndex ;
						natureIndex =  index.natureIndex != null ?  index.natureIndex.libelleCourt  : null ;
					}else{
						if( index.dateIndex > dateDerniereReleve) {
							dateDerniereReleve = index.dateIndex;
							dernierIndex = index.valeurIndex ;
							natureIndex =  index.natureIndex != null ?  index.natureIndex.libelleCourt  : null ;
									 // ==> dans le contexte de l'us SMIL-1400 recupérer le nature de dernier index pour l'aficher dans la partie recap OPS gaz

						}
					}
					
				}
			}
			Boolean accesReleve;

			if(donneesContractuelles !=null && donneesContractuelles.donneesReleve != null) {
					accesReleve = donneesContractuelles.donneesReleve[0].accesReleve;
			}

			String frequenceReleve = null;
			if(donneesContractuelles !=null && donneesContractuelles.donneesReleve != null && donneesContractuelles.donneesReleve[0].frequenceReleve != null ) {
					frequenceReleve =  donneesContractuelles.donneesReleve[0].frequenceReleve.code;
			}

			Datetime dateMiseHorsService = (donneesContractuelles !=null && donneesContractuelles.donneesReleve != null  && donneesContractuelles.donneesReleve[0].dateMiseHorsService != null) ? donneesContractuelles.donneesReleve[0].dateMiseHorsService : null;

			String valeurIndexMiseHorsService;
			if((donneesContractuelles !=null && donneesContractuelles.donneesReleve != null  && donneesContractuelles.donneesReleve[0].valeurIndexMiseHorsService != null)) {
					try{
							valeurIndexMiseHorsService = String.valueOf(donneesContractuelles.donneesReleve[0].valeurIndexMiseHorsService);
					}
					catch(Exception e) {
					}
			}


			gdfsuezComBefCalypsoPdlgaz.installationDt installation;
			if(response.lirePDLGazOutput != null && response.lirePDLGazOutput.donneesPDL != null) {
					installation =  response.lirePDLGazOutput.donneesPDL[0].installation;
			}
			//system.debug('typeCompteur'+response.lirePDLGazOutput.donneesPDL[0].Gazpar.etatPDL.code);

   
			// <== dans le contexte de l'us SMIL-1400 recupérer le nature de dernier index pour l'aficher dans la partie recap OPS gaz

		   String ftaLibelle ; 
		   if(donneesContractuelles !=null && donneesContractuelles.tarifAcheminement !=null){
		   ftaLibelle =  donneesContractuelles.tarifAcheminement.libelleCourt ;
		   }
	 
			PdlInfo infoPdl = new PdlInfo(accesReleve == null  ? null : accesReleve ? 'Accessible' : 'Non accessible',
										  (donneesContractuelles !=null && donneesContractuelles.statutContractuel !=null) ? donneesContractuelles.statutContractuel : null,
										  dateMiseHorsService,
										  (installation!= null && installation.compteur != null && installation.compteur.etatTechnique != null ) ? installation.compteur.etatTechnique.code : null,
										  (installation!= null && installation.compteur != null) ? installation.compteur.matricule : null,
										  pceGaz,
										  'Gaz',
										  dateDerniereReleve,
										  (installation!= null && installation.compteur != null) ? (installation.compteur.DGI ? 'DGI' : 'Non DGI') : null,
										  (donneesContractuelles !=null && donneesContractuelles.tarifAcheminement !=null) ? donneesContractuelles.tarifAcheminement.code : null,
										  (response.lirePDLGazOutput.donneesPDL[0].Gazpar != null  &&  response.lirePDLGazOutput.donneesPDL[0].Gazpar.etatPDL!= null && response.lirePDLGazOutput.donneesPDL[0].Gazpar.etatPDL.code!= null && response.lirePDLGazOutput.donneesPDL[0].Gazpar.etatPDL.code.equals('3')) ? 'Gazpar' : 'Historique',
										  (response.lirePDLGazOutput.donneesPDL[0].Gazpar != null  &&    response.lirePDLGazOutput.donneesPDL[0].Gazpar.dateRefusTelereleve!=null) ? response.lirePDLGazOutput.donneesPDL[0].Gazpar.dateRefusTelereleve : null,
										  (donneesContractuelles !=null && donneesContractuelles.miseHorsServiceEnCours!=null) ? donneesContractuelles.miseHorsServiceEnCours : null,
										  (response.lirePDLGazOutput.donneesPDL[0].consommationSansFournisseur!=null) ? response.lirePDLGazOutput.donneesPDL[0].consommationSansFournisseur : null,
										  (response.lirePDLGazOutput.donneesPDL[0].dernieresReleves!=null&&response.lirePDLGazOutput.donneesPDL[0].dernieresReleves.dateDerniereTelereleve!=null) ? response.lirePDLGazOutput.donneesPDL[0].dernieresReleves.dateDerniereTelereleve : null,
										  (donneesContractuelles !=null && donneesContractuelles.donneesCoupure.fraude!=null) ? donneesContractuelles.donneesCoupure.fraude : null,frequenceReleve,valeurIndexMiseHorsService,
										  /*dans le cadre de l'us 1824 la valeur CAR_Actuelle à été demandé */ (response.lirePDLGazOutput.donneesPDL[0] != null &&  response.lirePDLGazOutput.donneesPDL[0].CAR != null && response.lirePDLGazOutput.donneesPDL[0].CAR.CAR_Actuelle != null  &&
																												response.lirePDLGazOutput.donneesPDL[0].CAR.CAR_Actuelle.valeurCAR  != null ) ?  String.valueOf(response.lirePDLGazOutput.donneesPDL[0].CAR.CAR_Actuelle.valeurCAR) : null,
										  natureIndex,
										  ftaLibelle
										  );
										 infoPdl.dernierIndex = dernierIndex == null ?  null: String.valueOf(dernierIndex) ;
										 // US FT2-225
										 infoPdl.situationCompteur = (installation != null && installation.compteur != null && installation.compteur.situation != null) ? installation.compteur.situation.libelleCourt.toLowerCase('fr') : null;

			if(listOfreleves != null) {
					outMap.put('mesuresReleve',listOfreleves);
			}
		else {
					system.debug('## empty mesures ##');
			}
			outMap.put('pdlinfo',infoPdl);

	}

    public class PdlInfo {
		  
		public String accessReleve;           // données pdl > donneesContractuelles > donneesReleve > accesReleve
		public String statutContractuel;          // données pdl > donneesContractuelles >statutContractuel
		public Datetime dateMiseHorsService;           // données pdl > donneesContractuelles > donneesReleve > dateMiseHorsService
		public String etatTechnique;          // données  données pdl > installation > compteur > etat technique > code
		public String matricule;             // données pdl > installation > compteur > matricule
		public String idPdl;
		public string pdlType;          // Gaz Elec
		public Datetime dateDerniereReleve;            //données pdl > donneesContractuelles > donneesReleve > dateDerniereReleve //TODO
		public String dgi;
		public String fta;
		public String typeCompteur;
		public DateTime dateRefusTelereleve;
		public Boolean miseHorsServiceEnCours;
		public Boolean consommationSansFournisseur;
		public Datetime dateDerniereTelereleve;
		public Boolean fraude;
		public String frequenceReleve;
		public String valeurIndexMiseHorsService;
		public String CARActuelle;
		public String natureIndex;
		public String ftaLibelle;
		public String dernierIndex;
		public String situationCompteur;                   //donneesPDL . installation . compteur . situation . libelleCourt

		public PdlInfo(String accessReleve,String statutContractuel,Datetime dateMiseHorsService,String etatTechnique,String matricule,String idPdl,
					   string pdlType,Datetime dateDerniereReleve,String dgi,String fta,String typeCompteur,Datetime dateRefusTelereleve,Boolean miseHorsServiceEnCours,
					   Boolean consommationSansFournisseur,Datetime dateDerniereTelereleve,Boolean fraude, String frequenceReleve, String valeurIndexMiseHorsService,String CARActuelle,String natureIndex,String ftaLibelle){

				this.accessReleve  = accessReleve;
				this.statutContractuel  =statutContractuel;
				this.dateMiseHorsService= dateMiseHorsService;
				this.etatTechnique  = etatTechnique;
				this.matricule  = matricule;
				this.idPdl   =idPdl;
				this.pdlType  = pdlType;
				this.dateDerniereReleve = dateDerniereReleve;
				this.dgi = dgi;
				this.fta = fta;
				this.typeCompteur=typeCompteur;
				this.dateRefusTelereleve=dateRefusTelereleve;
				this.miseHorsServiceEnCours=miseHorsServiceEnCours;
				this.consommationSansFournisseur=consommationSansFournisseur;
				this.dateDerniereTelereleve=dateDerniereTelereleve;
				this.fraude=fraude;
				this.frequenceReleve = frequenceReleve;
				this.valeurIndexMiseHorsService = valeurIndexMiseHorsService;
				this.CARActuelle =  CARActuelle;
				this.natureIndex  = natureIndex;
				this.ftaLibelle = ftaLibelle ;
				
		}
	}

	public class Mesures {

		public datetime dateMesure;
		public double mesures;


		public Mesures(datetime dateMesure, double mesures ){
				this.dateMesure = dateMesure;
				this.mesures = mesures;
		}
	}

}