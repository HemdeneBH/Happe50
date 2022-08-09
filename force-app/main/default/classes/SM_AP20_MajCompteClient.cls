/*@author: MKC
*@Description: Mise à jour du compte Client avec ses coordonnées bancaires
*@CreatedDate: 01/02/2019
*@LastModified: mHA 21/03/2019
*/
global class SM_AP20_MajCompteClient implements vlocity_cmt.VlocityOpenInterface {
  /*@author: MKC
  *@Description: Appel de la méthode associé dans le WS Compte Client
  *@CreatedDate: 01/02/2019
  *@LastModified: mHA 21/03/2019
  */

  global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

	if (methodName.equals('majCompteClient')) {
	  try {
		majCompteClient(inputMap, outMap, options);
	  } catch (Exception e) {
		system.debug(e.getStackTraceString());
		throw e;
	  }
	}
	return true;
  }

  /*@author: MKC
  *@Description: Mise à jour du compte Client avec ses coordonnées bancaires
  *@CreatedDate: 01/02/2019
  *@LastModified: mHA 21/03/2019
  */

  public static void majCompteClient(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

	System.debug('Hello Method');
	System.debug('inputMap :'+inputMap);
	System.debug('idCompteClient :'+ inputMap.get('idCompteClient'));
	Map < String, Object > servicesGestion = (Map < String, Object > ) inputMap.get('ServicesGestion');
	String idCoordonneesBancaires = getSelectedCoordonnees(servicesGestion.get('EditBlock1')); //(String)inputMap.get('idCoordonneesBancaires') ;

	if (idCoordonneesBancaires == null ) {
	  // ca veut dire qu'il ya pas de coordonnées bancaires à mettre à jour !
		return ; // throw new IOException('Pas de coordonnée bancaire selectionnée, la mise à jour du compte client ne peut pas etre effectuée !');
	}

	if (idCoordonneesBancaires.equals('NO_ID_CB')) {
	  outMap.put('error','Pas d\'id coordonnée bancaire, la mise à jour du compte client ne peut pas etre effectuée !');
	  /*throw new IOException('Pas d\'id coordonnée bancaire, la mise à jour du compte client ne peut pas etre effectuée !');*/
	  return;
	}
	// ca veut dire qu'il ya des coordoordonnées bancaires mais aucune n'a été choisi ...
	Map < String, Object > prelevementBlock;
	String prelevement;
	if (String.isNotBlank(String.valueOf(servicesGestion.get('PrelevementBlock'))) ) {
	  prelevementBlock = (Map < String, Object >)servicesGestion.get('PrelevementBlock');
	  if (String.isNotBlank(String.valueOf(prelevementBlock.get('Prelevement')))) {
		prelevement = String.valueOf(prelevementBlock.get('Prelevement'));
	  }
	}
	if (idCoordonneesBancaires.equals('NO_SELECTED_ELEMENT') && prelevement == 'Oui') {
	  outMap.put('error','Attention vous n\'avez pas sélectionné de Coordonnées bancaires');
	  /*throw new IOException();*/
	  return;
	}else if(idCoordonneesBancaires.equals('NO_SELECTED_ELEMENT') && prelevement == 'Non'){
	  return;
	}
	String idCompteClient;
	if (inputMap.get('idCompteClient') != null) {
	  idCompteClient = String.valueOf(inputMap.get('idCompteClient'));
	} else if (((Map < String, Object > ) inputMap.get('ChoixElements')).get('FormulaNumCompteClientFrom360') != null) {
	  idCompteClient = (String)((Map < String, Object > ) inputMap.get('ChoixElements')).get('FormulaNumCompteClientFrom360');
	} else {
	  outMap.put('error','le parametre Numero Compte Contrat est introuvable depuis la vue 360, la mise à jour du compte client ne peut pas etre effectué !');
	  /*throw new IOException('le parametre Numero Compte Contrat est introuvable depuis la vue 360, la mise à jour du compte client ne peut pas etre effectué !');*/
	  return;
	}

	//Context
	gdfsuezComBefChpPivotCompteClient.contextDt octx = initContext('Smile', '6.0');
	SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();

	//   codes.add(canalCodeInput);

	//Port
	gdfsuezBefCalypsoCompteclientV6.Dependency port = new gdfsuezBefCalypsoCompteclientV6.Dependency();
	port.clientCertName_x = octopusCS.certName__c;
    SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'CompteClient' limit 1];
	port.endpoint_x = octopusCS.endpoint__c + suffixs.suffix__c;
	port.inputHttpHeaders_x = new Map < String, String > {
	  'Content-Type' => 'text/xml;charset=utf-8'
	};

	// input
	//
	gdfsuezBefCalypsoCompteclientV6.majCompteClientInputDt majCOmpteClientInput = new gdfsuezBefCalypsoCompteclientV6.majCompteClientInputDt();
	majCOmpteClientInput.compteClient = new gdfsuezComBefCalypsoComptecltV6.CompteClient();
	majCOmpteClientInput.compteClient.idCompteClient = idCompteClient; //'000402627727';
	majCOmpteClientInput.compteClient.coordonneeBancaire = new gdfsuezComBefCalypsoCoordonneesbanc.CoordonneesBancairesAbstract();
	majCOmpteClientInput.compteClient.coordonneeBancaire.idCoordonneesBancaires = idCoordonneesBancaires; //'200377460-02';
	gdfsuezComBefChpPivotCompteClient.retourTraitementMessagesDt response = new gdfsuezComBefChpPivotCompteClient.retourTraitementMessagesDt();

	String responseCode;
	String responseLibelle;

	try {

	  // system.debug('idCompteClient## : ' + (String)((Map < String, Object > ) inputMap.get('ChoixElements')).get('FormulaNumCompteClientFrom360'));

	  system.debug('idCompteClient : ' + idCompteClient);
	  system.debug('idCoordonneesBancaires: ' + idCoordonneesBancaires);

	  if (!Test.isRunningTest()) {
		response = port.MajCompteClient_Http(majCOmpteClientInput, octx);
	  } else {
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoCompteclientV6HttpMock());
		gdfsuezBefCalypsoCompteclientV6.Dependency porttest = new gdfsuezBefCalypsoCompteclientV6.Dependency();
		system.debug('@@ start of mock');
		response = porttest.MajCompteClient_Http(majCOmpteClientInput, octx);
		system.debug('@@ end of mock');

	  }

	  if(response != null && response.retourTraitementMessage != null){

		responseCode = response.retourTraitementMessage[0].code;
		responseLibelle = response.retourTraitementMessage[0].libelle;
		}	



		outMap.put('responseCode',responseCode);
		outMap.put('responseLibelle',responseLibelle);


	}
	

	 

	catch (Exception e) {
		outMap.put('errorMajCompteClient', 'une erreur est survenu au moment de l appel WS : MajCompteClient' + e.getStackTraceString());
	  throw e;
	}
  }

  /*@author: MKC
  *@Description: initialisation du context de l'appel SOAP du WS CompteClient
  *@CreatedDate: 01/02/2019
  *@LastModified: mHA 21/03/2019
  */
  public static gdfsuezComBefChpPivotCompteClient.contextDt initContext(String application, String version) {
	// Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
	gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_system_element osource = new gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_system_element();
	osource.systemId = application;
	gdfsuezComBefChpPivotCompteClient.contextDt octx = new gdfsuezComBefChpPivotCompteClient.contextDt();
	octx.version = version;
	octx.allowCache = false;
	octx.systemPath = new gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_element();
	octx.systemPath.system_x = new gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_system_element[] {
	  osource
	};
	return octx;
  }

  /*@author: MKC
  *@Description: Récupération des coordonnées bancaires sélectionnées
  *@CreatedDate: 01/02/2019
  *@LastModified: mHA 21/03/2019
  */
  public static String getSelectedCoordonnees(Object elemCoordonnetemp) {
	List < Object > listCoordonne = new List < Object > ();
	if (elemCoordonnetemp instanceof Map < String, Object > ) {
	  listCoordonne.add(elemCoordonnetemp);
	} else if (elemCoordonnetemp instanceof List < Object > ) {
	  listCoordonne = (List < Object > ) elemCoordonnetemp;
	}

	if (listCoordonne == null || listCoordonne.size() == 0) {
	  system.debug('## Pas de coordonnées bancaires ..##');
	  return null;
	}
	for (Object coordonne : listCoordonne) {
	  if (((boolean)((Map < String, Object > ) coordonne).get('selectedElement')) == true) {
		String idCB =  (String)((Map < String, Object > ) coordonne).get('idCoordonneeBancaire');
		if (idCB == null) {
		  // pas de id trouvee
		  return 'NO_ID_CB' ;
		}
		return idCB ;
	  }
	}
	return 'NO_SELECTED_ELEMENT';

  }


  public class IOException extends Exception {

  }



}