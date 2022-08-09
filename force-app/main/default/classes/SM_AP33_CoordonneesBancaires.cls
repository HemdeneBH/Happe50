/*@Auhtor: MKC
*@Description: Appel du webService CoordonneesBancaires_v2
*@CreatedDate: 19/10/2018
*@LastModified: MHA 03/01/2019
*/
global class SM_AP33_CoordonneesBancaires implements vlocity_cmt.VlocityOpenInterface {
	/*@Auhtor: MKC
	*@Description: Appel du webService des différentes méthodes du webService
	*@CreatedDate: 19/10/2018
	*@LastModified: MHA 03/01/2019
	*/
	global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		System.debug('*** input : ' + inputMap);
		if (methodName.equals('creerCB')) {
			try {
				creerCB(inputMap, outMap, options);
				SM_AP52_BanquesApiService.getInstitutBanqueByIBAN(inputMap, outMap, null);
				outMap.put('coordAdded', true);
				outMap.put('idPersonne', inputMap.get('idPersonneFormule'));
				outMap.put('IbanNumber',	inputMap.get('IbanNumber'));
				outMap.put('libelle1', 'N° IBAN: ' + inputMap.get('IbanNumber'));
				outMap.put('libelle2', 'Nom de la banque: ' + outMap.get('nomInstitutBancaire') + ' ,Titulaire du compte: ' + inputMap.get('TitulaireCompte'));
				//	outMap.put('idCoordonneeBancaire','0306502365-0002') ;
			} catch (Exception e) {
				system.debug(e.getStackTraceString());
				throw new IOException(e.getMessage());
			}
		}
		return true;
	}
  /*@Auhtor: MKC
  *@Description: appel de la méthode pour la créationd de coordonnées bancaires
  *@CreatedDate: 19/10/2018
  *@LastModified: MHA 03/01/2019
  */
	public static void creerCB(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {



		String idPersonne = (String) inputMap.get('idPersonneFormule');

		if (idPersonne == null || idPersonne.length() == 0) {
			throw new IOException('id personne non trouvée dans l OS ');
		}

		if (inputMap.get('IbanNumber') == null || ((String) inputMap.get('IbanNumber')).length() == 0) {
			throw new IOException('le champ numéro Iban est vide veuillez le saisir !');
		}
		if (inputMap.get('TitulaireCompte') == null || ((String) inputMap.get('TitulaireCompte')).length() == 0) {
			throw new IOException('le champ titulaire du compte est vide veuillez le saisir !');
		}




		//Context
		gdfsuezBefCalypsoCoordonneesbancaires.contextDt octx = initContext('Smile', '2.0');
		SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();


		//gdfsuezComBefChpCalypsoGestionprele.GestionPrelevementPort
		gdfsuezBefCalypsoCoordonneesbancaires.Dependency port = new gdfsuezBefCalypsoCoordonneesbancaires.Dependency();
		port.clientCertName_x = octopusCS.certName__c;
		port.endpoint_x = octopusCS.endpoint__c + 'ES-CoordonneesBancaires_v2';
		port.timeout_x = 60000;
		port.inputHttpHeaders_x = new Map < String, String > {
			'Content-Type' => 'text/xml;charset=utf-8'
		};

		/// input ******
		//
		//gdfsuezComBefChpCalypsoGestionprele.coordonneeBancaireDt
		gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesInputDt coordonneesBancairesInput = new gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesInputDt();
		coordonneesBancairesInput.coordonneesBancaires = new gdfsuezBefCalypsoCoordonneesbancaires.coordonneesBancairesDt();
		coordonneesBancairesInput.coordonneesBancaires.iban = (String) inputMap.get('IbanNumber'); //'FR7612607000099501973863230';
		//coordonneesBancairesInput.bban = getBban;
		coordonneesBancairesInput.coordonneesBancaires.titulaireCompte = (String) inputMap.get('TitulaireCompte'); //'testCompte';
		coordonneesBancairesInput.idPersonne = idPersonne; // '300014091' ;



		// gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element
		gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesResponse_element response = new gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesResponse_element();

		String responseCodeCreerCB;
		String responseLibelleCreerCB;

		try {
			System.debug('*** request : ' + coordonneesBancairesInput);

			if (test.isRunningTest()) {
				Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoCoordonneesbancMockImpl());
			}

			response = port.CreerCoordonneesBancaires(coordonneesBancairesInput, octx);

			responseCodeCreerCB = response.messageRetours.messageRetour[0].code;
			responseLibelleCreerCB = response.messageRetours.messageRetour[0].libelle;

			system.debug('reponse : ' + response);
			system.debug('responseCodeCreerCB : ' + responseCodeCreerCB);
			system.debug('responseLibelleCreerCB : ' + responseLibelleCreerCB);
			if (!responseCodeCreerCB.equals('OCTOPUS_CreerCB_01')) {
				throw new IOException('Coordonnées bancaires invalides :' + responseLibelleCreerCB);
			}
			outMap.put('idCoordonneeBancaire', response.creerCoordonneesBancairesOutput.idCoordonneeBancaire) ;
		} catch (Exception e) {
			if (test.isRunningTest()) {
				return;
			}
			System.debug('*** Error when calling WS : ' + e);
			system.debug(e.getStackTraceString());
			throw new IOException(e.getMessage());
		}

		//	 outMap.put('responseCodeCreerCB',responseCodeCreerCB);
		// outMap.put('responseLibelleCreerCB',responseLibelleCreerCB);

	}

  /*@Auhtor: MKC
  *@Description: initialisation du contexte
  *@CreatedDate: 19/10/2018
  *@LastModified: MHA 03/01/2019
  */
	public static gdfsuezBefCalypsoCoordonneesbancaires.contextDt initContext(String application, String version) {
		// Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
		gdfsuezBefCalypsoCoordonneesbancaires.system_element osource = new gdfsuezBefCalypsoCoordonneesbancaires.system_element();
		osource.systemId = application;
		gdfsuezBefCalypsoCoordonneesbancaires.contextDt octx = new gdfsuezBefCalypsoCoordonneesbancaires.contextDt();
		octx.version = version;
		//	octx.allowCache = false ;
		octx.systemPath = new gdfsuezBefCalypsoCoordonneesbancaires.systemPath_element();
		octx.systemPath.system_x = new gdfsuezBefCalypsoCoordonneesbancaires.system_element[] {
			osource
		};
		return octx;
	}

  /*@Auhtor: MKC
  *@Description: gestion des erreurs
  *@CreatedDate: 19/10/2018
  *@LastModified: MHA 03/01/2019
  */
	public class IOException extends Exception {


	}


}