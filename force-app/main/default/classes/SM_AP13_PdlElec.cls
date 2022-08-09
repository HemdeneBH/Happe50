/*
* @Author: Mohamed Kchaou
* @Date: 11/02/2019
* @Description: Class for omniscript call of PDLElec
*/
global class SM_AP13_PdlElec implements vlocity_cmt.VlocityOpenInterface {

	public static SM_UTIL_Cache_Management service = new SM_UTIL_Cache_Management();

	/*
	* @Author: Mohamed Kchaou
	* @Date: 11/02/2019
	* @Description: invoke method called by omniscript
	*/
	global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

		if (methodName.equals('lirePdlElec')) {
			try {
				lirePdl(inputMap, outMap, options);
			} catch (Exception e) {
				system.debug('## error occured during calling lirepdlElec ##');
				system.debug(e);
				system.debug(e.getStackTraceString());
				return false;
			}
		}
		return true;
	}

	/*
	* @Author: Mohamed Kchaou
	* @Date: 11/02/2019
	* @Description: init context
	*/
	public static gdfsuezComBefChpPivot.contextDt initContext(String application, String version) {
		// Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
		gdfsuezComBefChpPivot.system_element osource = new gdfsuezComBefChpPivot.system_element();
		osource.systemId = application;
		gdfsuezComBefChpPivot.contextDt octx = new gdfsuezComBefChpPivot.contextDt();
		octx.version = version;
		//  octx.allowCache = false ;
		octx.systemPath = new gdfsuezComBefChpPivot.systemPath_element();
		octx.systemPath.system_x = new gdfsuezComBefChpPivot.system_element[] {
			osource
		};
		return octx;
	}

	/*
	* @Author: Mohamed Kchaou
	* @Date: 11/02/2019
	* @Description: method calling lirePDL
	*/
	public static void lirePdl(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

		Map < String, Object > elements = (Map < String, Object > ) inputMap.get('ChoixElements1');
		if (elements == null && inputMap.get('pdlElecInfo') == null) {
			system.debug('no element names with choix elements in omniscript...');
			system.debug('inputs' + inputMap);
			return;
		}
		String pdlElc = null;
		
		if(elements != null){
		pdlElc  = (String) elements.get('selectedPDLVal');
		}
		if (pdlElc == null || pdlElc.length() == 0) {
			if(inputMap.get('pdlElecInfo') == null ){ // essaye de recupérer dans le cas de reprise
				system.debug('no selected pce val ');
				system.debug('inputs elements ' + elements);
				return;
			}else{
				pdlElc = (String)((Map < String, Object > ) inputMap.get('pdlElecInfo')).get('idPDLElectricite') ;
			}
		}
		gdfsuezComBefChpPivot.contextDt octx = initContext('Smile', '3.0');
		SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
		gdfsuezBefCalypsoPdlelectriciteV3.Dependency port = new gdfsuezBefCalypsoPdlelectriciteV3.Dependency();
		port.clientCertName_x = octopusCS.certName__c;
		port.endpoint_x = octopusCS.endpoint__c + 'ES-PDLElec_v3';
		port.inputHttpHeaders_x = new Map < String, String > {
			'Content-Type' => 'text/xml;charset=utf-8'
		};

		gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteInputDt input = new gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteInputDt();
		input.historiqueConsommations = true;
		input.online = true;
		input.typeOffre = new gdfsuezComBefChpPivot.listeValeursDt();
		input.typeOffre.code = 'INDUSTRIELLE';
		input.loginUtilisateur = service.getIdentifiantDistribFromApex();

		// dans le cadre de l'us ...
		//
		//

		//
		gdfsuezBefCalypsoPdlelectriciteV3.PDLElectricite_element element = new gdfsuezBefCalypsoPdlelectriciteV3.PDLElectricite_element();
		element.PDLElectricite = new gdfsuezComBefCalypsoPdlelectricite.PDLElectriciteAbstract();
		element.PDLElectricite.idPDLElectricite = pdlElc; //'01199999844520' ;

		// => dans le cadre de l'us SMIL-1842
		element.accordFournisseurNonTitulaire = new gdfsuezBefCalypsoPdlelectriciteV3.accordFournisseurNonTitulaire_element();
		element.accordFournisseurNonTitulaire.autorisationClient = true;

		// <='us SMIL-1842

		input.PDLElectricite = new gdfsuezBefCalypsoPdlelectriciteV3.PDLElectricite_element[] {
			element
		};



		gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteResponse_element response;


		if (!Test.isRunningTest()) {
			response = port.LirePDLElectricite(input, octx);
		} else {
			Test.setMock(WebServiceMock.class, new SM_AP13_PdlElecMock());
			gdfsuezBefCalypsoPdlelectriciteV3.Dependency porttest = new gdfsuezBefCalypsoPdlelectriciteV3.Dependency();
			system.debug('@@ start of mock');
			response = porttest.LirePDLElectricite(input, octx);
			system.debug('@@ end of mock');
		}
		String idPDLElectricite = null;
		String secteurActivite = 'Elec';
		String situationContractuelle = null;
		String typeCompteur = null;
		String niveauOuvertureServices = null;
		String index;
		String statut = 'A initier';
		String matricule;
		String etatPdl; // etat alimentation
		datetime dateMHS;
		datetime dateDernierIndex;
		Integer numbreCadrans;
		String acessibilite;
		boolean autoreleve;
		String hc;
		String hp;
		String etatCompteur;
		String periodeDeDeploiement ;
		 String natureIndex;
		datetime dateDerniereModificationFormuleTarifaireAcheminement ;
		if (response != null && response.lirePDLElectriciteOutput != null) {
			if (response.lirePDLElectriciteOutput.donneesPDL != null) {
				idPDLElectricite = response.lirePDLElectriciteOutput.donneesPDL[0].idPDLElectricite;
				if (response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].sIContractuel != null) {
					situationContractuelle = response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].sIContractuel.code;
				}

				if(response.lirePDLElectriciteOutput.donneesPDL[0].donneesGenerales != null &&   response.lirePDLElectriciteOutput.donneesPDL[0].donneesGenerales[0] != null  &&
				response.lirePDLElectriciteOutput.donneesPDL[0].donneesGenerales[0].dateDerniereModificationFormuleTarifaireAcheminement != null ){
                dateDerniereModificationFormuleTarifaireAcheminement =  response.lirePDLElectriciteOutput.donneesPDL[0].donneesGenerales[0].dateDerniereModificationFormuleTarifaireAcheminement  ;
				}

				if (response.lirePDLElectriciteOutput.donneesPDL != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage != null &&
						response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage != null
				   ) {

					if (response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur[0] != null) {
						acessibilite = response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur[0].accessibilite ? 'Accessible' : 'Non accesssible';
						matricule = response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur[0].matricule;
						numbreCadrans = response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur[0].modeleCompteur.nbCadrans;
			   
						
						
					}
					   
					   if(response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur  != null &&
						  response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur[0].periodeDeploiementLinky != null){
							  periodeDeDeploiement= response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur[0].periodeDeploiementLinky  ;
						  }
					   
					   
					   
					if (response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.typeComptage != null) {
						typeCompteur = response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.typeComptage.code;
						if (typeCompteur != null) {
							if (!typeCompteur.equals('LINKY') && !typeCompteur.equals('Inconnu')) {
								typeCompteur = 'Historique'; // vu avec fatimatou si type de compteur est different de Linky et Inconnu faut prendre la valeur Historique
							}
						}
					}
				}

				Datetime dateDernierIndexReleve ;
				String natureIndexReleve ;
				String natureIndexReleveCode ;
				String indexBaseReleve ;
				String indexHPReleve ;
				String indexHCReleve ;
				// => dans le cadre de l'us SMIL-1982
				if (response.lirePDLElectriciteOutput.donneesPDL[0].derniersIndexReleves != null && response.lirePDLElectriciteOutput.donneesPDL[0].derniersIndexReleves[0].programmationFournisseur != null &&
					response.lirePDLElectriciteOutput.donneesPDL[0].derniersIndexReleves[0].programmationFournisseur.mesuresIndex != null  &&
					response.lirePDLElectriciteOutput.donneesPDL[0].derniersIndexReleves[0].programmationFournisseur.mesuresIndex.mesureIndex != null ) {
						dateDernierIndexReleve = response.lirePDLElectriciteOutput.donneesPDL[0].derniersIndexReleves[0].date_x;
						natureIndexReleve =   response.lirePDLElectriciteOutput.donneesPDL[0].derniersIndexReleves[0].nature.libelleCourt;
						natureIndexReleveCode =   response.lirePDLElectriciteOutput.donneesPDL[0].derniersIndexReleves[0].nature.code;
						for(gdfsuezComBefCalypsoPdlelectricite.mesureIndex_element mesureIndex :  response.lirePDLElectriciteOutput.donneesPDL[0].derniersIndexReleves[0].programmationFournisseur.mesuresIndex.mesureIndex){
							if(mesureIndex.mesureIndex != null &&  mesureIndex.mesureIndex.code != null &&  mesureIndex.mesureIndex.code.equals('BASE')){
								indexBaseReleve = String.valueOf(mesureIndex.indexes[0].index.valeur);                             
							}else if(mesureIndex.mesureIndex != null &&  mesureIndex.mesureIndex.code != null &&  mesureIndex.mesureIndex.code.equals('HP')){
								indexHPReleve = String.valueOf(mesureIndex.indexes[0].index.valeur);
							}else if(mesureIndex.mesureIndex != null &&  mesureIndex.mesureIndex.code != null &&  mesureIndex.mesureIndex.code.equals('HC')){
								indexHCReleve = String.valueOf( mesureIndex.indexes[0].index.valeur);
							}
						}
					} 
				

				Datetime dateDernierIndexPublies ;
				String natureIndexPublies ;
				String natureIndexCodePublies ;
				String indexBasePublies ;
				String indexHPPublies ;
				String indexHCPublies ;
				if ( response.lirePDLElectriciteOutput.donneesPDL[0].historiqueMesures != null && response.lirePDLElectriciteOutput.donneesPDL[0].historiqueMesures.derniersIndexPublies != null 
							   && response.lirePDLElectriciteOutput.donneesPDL[0].historiqueMesures.derniersIndexPublies.programmationFournisseur != null &&
							   response.lirePDLElectriciteOutput.donneesPDL[0].historiqueMesures.derniersIndexPublies.programmationFournisseur.mesuresIndex != null  &&
							   response.lirePDLElectriciteOutput.donneesPDL[0].historiqueMesures.derniersIndexPublies.programmationFournisseur.mesuresIndex.mesureIndex != null ) {
								   if(dateDernierIndex == null ||  response.lirePDLElectriciteOutput.donneesPDL[0].historiqueMesures.derniersIndexPublies.date_x >  dateDernierIndex) {
									dateDernierIndexPublies = response.lirePDLElectriciteOutput.donneesPDL[0].historiqueMesures.derniersIndexPublies.date_x;
									   natureIndexPublies =   response.lirePDLElectriciteOutput.donneesPDL[0].historiqueMesures.derniersIndexPublies.nature.libelleCourt;
								   	   natureIndexCodePublies =   response.lirePDLElectriciteOutput.donneesPDL[0].historiqueMesures.derniersIndexPublies.nature.code;
						
								   for(gdfsuezComBefCalypsoPdlelectricite.mesureIndex_element mesureIndex :  response.lirePDLElectriciteOutput.donneesPDL[0].historiqueMesures.derniersIndexPublies.programmationFournisseur.mesuresIndex.mesureIndex){
									   if(mesureIndex.mesureIndex != null &&  mesureIndex.mesureIndex.code != null &&  mesureIndex.mesureIndex.code.equals('BASE')){
										   indexBasePublies = String.valueOf(mesureIndex.indexes[0].index.valeur);                             
									   }else if(mesureIndex.mesureIndex != null &&  mesureIndex.mesureIndex.code != null &&  mesureIndex.mesureIndex.code.equals('HP')){
										   indexHPPublies = String.valueOf(mesureIndex.indexes[0].index.valeur);
									   }else if(mesureIndex.mesureIndex != null &&  mesureIndex.mesureIndex.code != null &&  mesureIndex.mesureIndex.code.equals('HC')){
										   indexHCPublies = String.valueOf( mesureIndex.indexes[0].index.valeur);
									   }
								   }
								   }
							   }
				
				   // <= dans le cadre de l'us FT2-409
				
                IndexInfo indexObject  = getIndex( dateDernierIndexReleve , natureIndexReleve 
                                                  , natureIndexReleveCode ,
                                                  indexBaseReleve ,
                                                  indexHPReleve ,
                                                  indexHCReleve , dateDernierIndexPublies , natureIndexPublies, natureIndexCodePublies,  indexBasePublies, indexHPPublies, indexHCPublies ) ;
                
                index =  indexObject.index ;
                hp	=indexObject.hp ;
                hc  =      indexObject.hc ;
                dateDernierIndex	=  indexObject.dateDernierIndex ;
                natureIndex	=  indexObject.natureIndex ;
				
				if (response.lirePDLElectriciteOutput.donneesPDL[0].donneesGenerales != null && response.lirePDLElectriciteOutput.donneesPDL[0].donneesGenerales[0].niveauOuvertureServices != null) {
					niveauOuvertureServices = response.lirePDLElectriciteOutput.donneesPDL[0].donneesGenerales[0].niveauOuvertureServices.code;
					if (niveauOuvertureServices != null) {
						if (niveauOuvertureServices.equals('0')) {
							niveauOuvertureServices = 'Niveau 0';
						} else if (niveauOuvertureServices.equals('1')) {
							niveauOuvertureServices = 'Niveau 1';
						} else if (niveauOuvertureServices.equals('2')) {
							niveauOuvertureServices = 'Niveau 2';
						} else {
							niveauOuvertureServices = 'Inconnu';
						}

					}

				}

				if (response.lirePDLElectriciteOutput.donneesPDL[0].donneesGenerales != null && response.lirePDLElectriciteOutput.donneesPDL[0].donneesGenerales[0].etatContractuel != null) {
					etatPdl = response.lirePDLElectriciteOutput.donneesPDL[0].donneesGenerales[0].etatContractuel.libelleCourt;
				}
				// dans le contexte de US  SMIL-1987 =>
				etatCompteur = 'non coupe' ; // si balises non remonté 
				if (response.lirePDLElectriciteOutput.donneesPDL[0].situationAlimentation != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationAlimentation[0].etatAlimentation != null &&  !String.isBlank(response.lirePDLElectriciteOutput.donneesPDL[0].situationAlimentation[0].etatAlimentation.code)  ) {
					if(response.lirePDLElectriciteOutput.donneesPDL[0].situationAlimentation[0].etatAlimentation.code.equals('ALIM')){
					etatCompteur = 'non coupe' ;
					}
					if( ! response.lirePDLElectriciteOutput.donneesPDL[0].situationAlimentation[0].etatAlimentation.code.equals('LIMI') && ! response.lirePDLElectriciteOutput.donneesPDL[0].situationAlimentation[0].etatAlimentation.code.equals('ALIM')     ){
					etatCompteur = 'coupe' ;
					}
					if( response.lirePDLElectriciteOutput.donneesPDL[0].situationAlimentation[0].etatAlimentation.code.equals('LIMI')){
					 etatCompteur ='non coupe' ;  
					}
					if( response.lirePDLElectriciteOutput.donneesPDL[0].situationAlimentation[0].etatAlimentation.code.equals('NRAC')){
					 etatCompteur ='première MES' ;  
					}
				}
				// <=  dans le contexte de US  SMIL-1987 



				if (response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle != null  &&  response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0] != null ) {
					dateMHS = response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].dateFin;
				}


				/*SMIL-1083 START*/
				String puissancelimitee = null;
				if (response.lirePDLElectriciteOutput.donneesPDL[0].situationAlimentation != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationAlimentation[0].limitation != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationAlimentation[0].limitation.puissanceLimitee != null) {
					puissancelimitee = String.valueOf(response.lirePDLElectriciteOutput.donneesPDL[0].situationAlimentation[0].limitation.puissanceLimitee.valeur);
				}
				/*SMIL-1083 END*/

				/*SMIL-649 START*/
				String ftaCode;
				String ftaLibelle;
				String calendrierFournisseurCode;
				String calendrierFournisseurLibelleCourt;
				Integer puissanceSouscriteValeur;
				String puissanceSouscriteUnite;
				if (response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.formuleTarifaireAcheminement != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.formuleTarifaireAcheminement.libelleCourt != null) {
					ftaLibelle = response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.formuleTarifaireAcheminement.libelleCourt;
				}
				if (response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.formuleTarifaireAcheminement != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.formuleTarifaireAcheminement.code != null) {
					ftaCode = response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.formuleTarifaireAcheminement.code;
				}
				if (response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.calendrierFournisseur != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.calendrierFournisseur.code != null) {
					calendrierFournisseurCode = response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.calendrierFournisseur.code;
				}
				if (response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.calendrierFournisseur != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.calendrierFournisseur.libelleCourt != null) {
					calendrierFournisseurLibelleCourt = response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.calendrierFournisseur.libelleCourt;
				}
				if (response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.puissanceSouscriteMax != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.puissanceSouscriteMax.valeur != null) {
					puissanceSouscriteValeur = response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].StructureTarifaire.puissanceSouscriteMax.valeur;
				}
				if (response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.puissanceSouscriteMax != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.puissanceSouscriteMax.unite != null) {
					puissanceSouscriteUnite = response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].structureTarifaire.puissanceSouscriteMax.unite;
				}

				/*SMIL-649 END*/

				/*SMIL-787 START*/
				Integer numRoues;
				if (response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur[0] != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur[0].modeleCompteur != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur[0].modeleCompteur.nbRoues != null) {
					numRoues = response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur[0].modeleCompteur.nbRoues;
				}
				/*SMIL-787 END*/

				// => SMILE-1824 recupérer la CAE par cadran et global
				gdfsuezComBefCalypsoPdlelectricite.cAEParCadran_element cAEParCadran;
				gdfsuezComBefChpDistributeurelectric.quantiteSansDecimalDt cAEGlobale;
				Integer cAE_HP;
				Integer cAE_HC;
				Integer cAE_WE;

				if (response.lirePDLElectriciteOutput.donneesPDL[0].historiqueMesures != null && response.lirePDLElectriciteOutput.donneesPDL[0].historiqueMesures.consommations != null ) {
					cAEParCadran  = response.lirePDLElectriciteOutput.donneesPDL[0].historiqueMesures.consommations.cAEParCadran;
					// mise en place  de la récupération de CAE HP, HC et WE
					if (cAEParCadran != null && cAEParCadran.cadran != null) {
						List<gdfsuezComBefCalypsoPdlelectricite.cadran_element>cadrans = cAEParCadran.cadran;
						for (gdfsuezComBefCalypsoPdlelectricite.cadran_element cadran : cadrans) {
							String codeCadran = String.valueOf(cadran.codeCadran.code);
							Integer valueCadran = Integer.valueOf(cadran.cAE.valeur);
							String uniteCadran = String.valueOf(cadran.cAE.unite);
							if (codeCadran == 'HC') {
								cAE_HC = valueCadran;
							}
							if (codeCadran == 'HP') {
								cAE_HP = valueCadran;
							}
							if (codeCadran == 'WE') {
								cAE_WE = valueCadran;
							}
						}
					}


					cAEGlobale  = response.lirePDLElectriciteOutput.donneesPDL[0].historiqueMesures.consommations.cAEGlobale;
				}
				// <=  SMILE-1824 recupérer la CAE par cadran et global
				// => dans le contexe de l'us 1300 recupérer la nautre index
			   
				String perimetre;

				perimetre = 'PDL hors périmètre';
				if (response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].contratID != null &&
						response.lirePDLElectriciteOutput.donneesPDL[0].situationContractuelle[0].contratID.equals('GRD-F006')) {
					perimetre = 'PDL dans le périmètre';
				}
				// <== SMIL-1300


				autoReleve = processAutoReleve(response.lirePDLElectriciteOutput.donneesPDL[0], inputMap, etatPdl, typeCompteur, situationContractuelle, niveauOuvertureServices);
				pdlInfo pdlElecInfo = new pdlInfo(idPDLElectricite, secteurActivite, situationContractuelle, typeCompteur,
												  niveauOuvertureServices, index, statut, matricule, etatPdl, dateMHS,
												  dateDernierIndex, numbreCadrans, numRoues, acessibilite, autoreleve,
												  hp, hc, etatCompteur, puissancelimitee, ftaCode, ftaLibelle,
												  calendrierFournisseurCode, calendrierFournisseurLibelleCourt,
												  puissanceSouscriteValeur, puissanceSouscriteUnite, cAEParCadran,
												  cAE_HP, cAE_HC, cAE_WE, cAEGlobale, natureIndex, perimetre);
				pdlElecInfo.periodeDeDeploiement = periodeDeDeploiement ;
                pdlElecInfo.dateDerniereModificationFormuleTarifaireAcheminement = dateDerniereModificationFormuleTarifaireAcheminement ;
				// US FT2-225	
				pdlElecInfo.situationCompteur = (response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur[0] != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur[0].localisation != null && response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur[0].localisation.libelleCourt != null) ? response.lirePDLElectriciteOutput.donneesPDL[0].situationComptage[0].dispositifComptage.compteurs.compteur[0].localisation.libelleCourt.toLowerCase('fr') : null;
				system.debug('## pdlElecInfo' + pdlElecInfo);
				system.debug('##response##' + response);
				outMap.put('pdlElecInfo', pdlElecInfo);
			}

		}
	}

	/*
	* @Author: Mohamed Kchaou
	* @Date: 11/02/2019
	* @Description: static method to processAutoReleve called in lirePDL
	*/
	private static boolean processAutoReleve(gdfsuezComBefCalypsoPdlelectricite.PDLElectricite pdlElec, Map < String, Object > inputMap, String etatAli, String typeCompteur, String siContractuel, String niveauOuvertureServices) {
		boolean situation = (inputMap.get('chooseSellingOption') != null && ((String) inputMap.get('chooseSellingOption')).equals('Mise en Service / Emménagement')) ? true : false;
		boolean etatAliBool = (etatAli != null && etatAli.equals('non coupe')) ? true : false;
		boolean etatContractuel = (pdlElec.donneesGenerales[0] != null && pdlElec.donneesGenerales[0].etatContractuel != null && pdlElec.donneesGenerales[0].etatContractuel.code != null && pdlElec.donneesGenerales[0].etatContractuel.code.equals('SERVC')) ? true : false;
		boolean typeComptage = ((typeCompteur != null && !typeCompteur.equals('LINKY')) || (siContractuel != null && !siContractuel.equals('GINKO')) || (niveauOuvertureServices != null && !niveauOuvertureServices.equals('Niveau 1') && !niveauOuvertureServices.equals('Niveau 2'))) ? true : false;
		return situation && etatAliBool && etatContractuel && typeComptage;
	}


public class IndexInfo{
   public String  index  ;
	public	String  hp ;
    public    String    hc ;
	public	Datetime	 dateDernierIndex  ;
	public	String	 natureIndex  ;

}
	public class PdlInfo {

		public String idPDLElectricite = null;
		public String secteurActivite;
		public String situationContractuelle = null;
		public String typeCompteur = null;
		public String niveauOuvertureServices = null;
		public String index;
		public String statut;
		public String matricule;
		public String etatPdl;
		public datetime dateMHS;
		public datetime dateDernierIndex;
		public Integer numbreCadrans;
		public Integer numRoues;
		public String acessibilite;
		public String indexHp;
		public String indexHC;
		boolean autoreleve;
		String etatCompteur;
		Public String puissancelimitee;
		public String ftaCode;
		public String ftaLibelle;
		public String calendrierFournisseurCode;
		public String calendrierFournisseurLibelleCourt;
		public Integer puissanceSouscriteValeur;
		public String puissanceSouscriteUnite;
		public gdfsuezComBefCalypsoPdlelectricite.cAEParCadran_element cAEParCadran;
		public Integer cAE_HP;
		public Integer cAE_HC;
		public Integer cAE_WE;
		public gdfsuezComBefChpDistributeurelectric.quantiteSansDecimalDt cAEGlobale;
		public String natureIndex;
		public String perimetre;
		public String periodeDeDeploiement ;
		public String typeComptageDifferencie;
		public Datetime dateDerniereModificationFormuleTarifaireAcheminement ;
	    public String situationCompteur;     //donneesPDL . situationComptage . dispositifComptage . compteurs . compteur . localisation . libelleCourt

		public PdlInfo(String idPDLElectricite, String secteurActivite, String situationContractuelle, String typeCompteur,
					   String niveauOuvertureServices, string index, String statut, String matricule, string etatPdl, datetime dateMHS, datetime dateDernierIndex, Integer numbreCadrans, Integer numRoues, String acessibilite, boolean autoreleve,  String indexHp,
					   String indexHC, String etatCompteur, String puissancelimitee, String ftaCode, String ftaLibelle, String calendrierFournisseurCode, String calendrierFournisseurLibelleCourt, Integer puissanceSouscriteValeur, String puissanceSouscriteUnite,
					   gdfsuezComBefCalypsoPdlelectricite.cAEParCadran_element cAEParCadran, Integer cAE_HP, Integer cAE_HC, Integer cAE_WE, gdfsuezComBefChpDistributeurelectric.quantiteSansDecimalDt cAEGlobale, String natureIndex, String perimetre) {
			this.idPDLElectricite = idPDLElectricite;
			this.secteurActivite = secteurActivite;
			this.situationContractuelle = situationContractuelle;
			this.typeCompteur = typeCompteur;
			this.niveauOuvertureServices = niveauOuvertureServices;
			this.index = index;
			this.statut = statut;
			this.matricule = matricule;
			this.etatPdl = etatPdl;
			this.dateMHS = dateMHS;
			this.dateDernierIndex = dateDernierIndex;
			this.numbreCadrans = numbreCadrans;
			this.numRoues = numRoues;
			this.acessibilite = acessibilite;
			this.autoreleve = autoreleve;
			this.indexHC = indexHC;
			this.indexHp = indexHp;
			this.etatCompteur = etatCompteur;
			this.puissancelimitee = puissancelimitee;
			this.ftaCode = ftaCode;
			this.ftaLibelle = ftaLibelle;
			this.calendrierFournisseurCode = calendrierFournisseurCode;
			this.calendrierFournisseurLibelleCourt = calendrierFournisseurLibelleCourt;
			this.puissanceSouscriteValeur = puissanceSouscriteValeur;
			this.puissanceSouscriteUnite = puissanceSouscriteUnite;
			this.cAEParCadran = cAEParCadran;
			this.cAE_HP = cAE_HP;
			this.cAE_HC = cAE_HC;
			this.cAE_WE = cAE_WE;
			this.cAEGlobale = cAEGlobale;
			this.natureIndex = natureIndex;
			this.perimetre = perimetre;
			if('DISCO'.equalsIgnoreCase(situationContractuelle)){
				switch on numbreCadrans {
				   when 1 {
					   this.typeComptageDifferencie='Simple';
				   }
				   when 2 {
					   this.typeComptageDifferencie='Double';
				   }
					when 3 {
					   this.typeComptageDifferencie='Triple';
				   }
				   when else {
					   this.typeComptageDifferencie='Inconnu';
				   }
				}	
			}
			else if ('GINKO'.equalsIgnoreCase(situationContractuelle) && calendrierFournisseurCode!=null){
				//system.debug('@@ calendrierFournisseurCode '+calendrierFournisseurCode);
				List<SM_TranscoTypeComptage__mdt> trancoList= [select MasterLabel 
														from  SM_TranscoTypeComptage__mdt 
														where DeveloperName=:calendrierFournisseurCode];
				if(trancoList!=null && trancoList.size()>0){
					this.typeComptageDifferencie=trancoList[0].MasterLabel;
				}
				
			}
		}
	}

    
    
    public static SM_AP13_PdlElec.IndexInfo  getIndex(Datetime dateDernierIndexReleve, String natureIndexReleve, String natureIndexReleveCode, String indexBaseReleve, String indexHPReleve, String indexHCReleve, Datetime dateDernierIndexPublies, String natureIndexPublies, String natureIndexCodePublies, String indexBasePublies, String indexHPPublies, String indexHCPublies){
        
        SM_AP13_PdlElec.IndexInfo index= new SM_AP13_PdlElec.IndexInfo() ;
        // <= dans le cadre de l'us FT2-409
        if(natureIndexCodePublies != null && natureIndexReleveCode != null){
            
            if(natureIndexCodePublies.equalsIgnoreCase('REEL') && natureIndexReleveCode.equalsIgnoreCase('REEL')){
                if(dateDernierIndexPublies >= dateDernierIndexReleve){
                    index.index =indexBasePublies ;
                    index.hp = indexHPPublies ;
                    index.hc = indexHCPublies ;
                    index.dateDernierIndex = dateDernierIndexPublies ;
                    index.natureIndex = natureIndexPublies ;
                }else{
                    index.index =indexBaseReleve ;
                    index.hp = indexHPReleve ;
                    index.hc = indexHCReleve ;
                    index.dateDernierIndex = dateDernierIndexReleve ;
                    index.natureIndex = natureIndexReleve ;
                }
            }else if(natureIndexCodePublies.equalsIgnoreCase('REEL')){
                index.index =indexBasePublies ;
                index.hp = indexHPPublies ;
                index.hc = indexHCPublies ;
                index.dateDernierIndex = dateDernierIndexPublies ;
                index.natureIndex = natureIndexPublies ;
            }else if(natureIndexReleveCode.equalsIgnoreCase('REEL')) {
                index.index =indexBaseReleve ;
                index.hp = indexHPReleve ;
                index.hc = indexHCReleve ;
                index.dateDernierIndex = dateDernierIndexReleve ;
                index.natureIndex = natureIndexReleve ;
            }else{
                
                if(dateDernierIndexPublies >= dateDernierIndexReleve){
                    index.index =indexBasePublies ;
                    index.hp = indexHPPublies ;
                    index.hc = indexHCPublies ;
                    index.dateDernierIndex = dateDernierIndexPublies ;
                    index.natureIndex = natureIndexPublies ;
                }else{
                    index.index =indexBaseReleve ;
                    index.hp = indexHPReleve ;
                    index.hc = indexHCReleve ;
                    index.dateDernierIndex = dateDernierIndexReleve ;
                    index.natureIndex = natureIndexReleve ;
                }
                
            }
            
        }else if(natureIndexReleve != null){
            index.index =indexBaseReleve ;
            index.hp = indexHPReleve ;
            index.hc = indexHCReleve ;
            index.dateDernierIndex = dateDernierIndexReleve ;
            index.natureIndex = natureIndexReleve ;	
        }else if(natureIndexPublies != null ){
            index.index =indexBasePublies ;
            index.hp = indexHPPublies ;
            index.hc = indexHCPublies ;
            index.dateDernierIndex = dateDernierIndexPublies ;
            index.natureIndex = natureIndexPublies ;
        }
        
        return index ;
    } 
}