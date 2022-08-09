/** 
 *   @description Méthode utilisée pour l'appel aux webservices "Personne"
 *   @project SMILE
 *   @author Mickaël
 *   @CreatedDate 10/03
 */

global with sharing class SM_AP61_PersonneOctopus implements vlocity_cmt.VlocityOpenInterface {
	private static Map<String,Object> outMapMajPersonne = new Map<String,Object>();

	global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

		System.debug('inputMap: ' + inputMap);
		if (methodName.equals('majPersonne')) {
			try {
				majPersonne(inputMap, outMap, options);
			  } catch (Exception e) {
				system.debug('Exception Message: ' + e.getMessage());
				system.debug('Exception StackTrace: ' + e.getStackTraceString());
				return false;
			}            
		} else if (methodName.equals('creerPersonneCorrespondance')) {
			try {
				creerPersonneCorrespondance(inputMap, outMap, options);
			  } catch (Exception e) {
				system.debug(e.getStackTraceString());
				return false;
			}  
		}
		else if(methodName.equals('majPersonneProfilMarketing')){
			try {
				majPersonneProfilMarketing(inputMap, outMap, options);
			  } catch (Exception e) {
				system.debug(e.getStackTraceString());
				return false;
			}  
		}else if (methodName.equals('majPersonneAdresse')){
	       try {
				majPersonneAdresse(inputMap, outMap, options);
			  } catch (Exception e) {
				  if(!(e instanceof CustomizedException)){
                      e.setMessage('Erreur technique !') ;
				  }
                throw e ;
				system.debug(e.getStackTraceString());
				return false;
			}  

		}            
		
		return true;
	}

	@AuraEnabled
	global static Map<String,Object> invokeMethodLWC(String methodName, Map < String, Object > inputMap, Map < String, Object > options) {
		outMapMajPersonne = new Map<String,Object>();
		if (methodName.equals('majPersonne')) {
			try {
				majPersonneLWC(inputMap, outMapMajPersonne, options);
			  } catch (Exception e) {
				system.debug(e.getStackTraceString());
				outMapMajPersonne.put('Error', e.getMessage());
			}            
		}         
		
		return outMapMajPersonne;
	}

	/**
	 * @description : effectue l'appel à la méthode rechercherContrat. Le traitement est effectué dans les méthodes suivantes.
	 */
	public static gdfsuezComBefChpPivotV8.contextDt initContext(String application, String version){
		 // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
		gdfsuezComBefChpPivotV8.contextDt_systemPath_system_element osource = new gdfsuezComBefChpPivotV8.contextDt_systemPath_system_element();
		osource.systemId=application;
		gdfsuezComBefChpPivotV8.contextDt octx = new gdfsuezComBefChpPivotV8.contextDt();
		octx.version=version;
	  //  octx.allowCache = false ;
		octx.systemPath = new gdfsuezComBefChpPivotV8.contextDt_systemPath_element();
		octx.systemPath.system_x = new gdfsuezComBefChpPivotV8.contextDt_systemPath_system_element[]{osource};
		return octx;
	} 

	private static Contact findContactToUpdate(String idPersonne){
		List<Contact> contactToUpdateList = [SELECT Email,Adresse_Mail_2__c,Adresse_Mail_3__c,EmailPrincipalValue__c,Adresse_Mail_Principale__c FROM Contact WHERE Identifiant_Buisness_Partener__c = :idPersonne LIMIT 1];
		if(contactToUpdateList.isEmpty()){
			System.debug('[SM_AP61_PersonneOctopus:findContactToUpdate] Contact non trouvé id BP = '+idPersonne);
			throw new MajPersonneException('Le contact n\'est pas été trouvé');
		}
		return contactToUpdateList.get(0);
	}

	public class MajPersonneException extends Exception{}

	/**
	 *   @Project : Smile
	 *   @Description Appel à l'opération "MAJPersonne" afin de renseigner le profil marketing
	 *   @CreatedDate : 11/07/2019
	 */
	public static void majPersonneProfilMarketing(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options){

		String idPersonne = (String) inputMap.get('numeroBP');
		String newEmail = (String) inputMap.get('email');
		String selectedEmailLabel = 'Adresse Mail 1';
		if(String.isBlank(newEmail)){
			System.debug('[SM_AP61_PersonneOctopus:majPersonneProfilMarketing] : email non présent');
			throw new MajPersonneException('Nouveau email absent');
		}

		gdfsuezComBefChpPivotV8.contextDt octx = initContext('Smile', '2.0');

		gdfsuezBefCalypsoPersonneV8.PersonnePort port = buildPortWSPersonne() ;

		gdfsuezBefCalypsoPersonneV8.majPersonneInputDt input = new gdfsuezBefCalypsoPersonneV8.majPersonneInputDt();
		input.personne = new gdfsuezComBefCalypsoPersonneV8.Personne();
		input.personne.idPersonne = idPersonne;
		input.personne.profilMarketing = new gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element[]{};
		input.personne.correspondance = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_element();
		gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element profilMarketing = new gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element();
		gdfsuezComBefChpPivotV8.listeValeursDt designation = new gdfsuezComBefChpPivotV8.listeValeursDt();
		designation.code = 'compteEnLigne';
		profilMarketing.designation = designation;
		profilMarketing.valeurDesignation = '3';
		input.personne.profilMarketing.add(profilMarketing);
		List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element> canaux = new List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element>();


		Contact contactToUpdate = findContactToUpdate(idPersonne);
		String newEmailPrefereItem = (newEmail.equals(contactToUpdate.Email)) ? 'Adresse Mail 1' : (newEmail.equals(contactToUpdate.Adresse_Mail_2__c) ? 'Adresse Mail 2' : (newEmail.equals(contactToUpdate.Adresse_Mail_3__c) ? 'Adresse Mail 3' : 'Adresse Mail 1') );
		// Si le contact possède déjà un email dans sa fiche contact
		if(!String.isBlank(contactToUpdate.Adresse_Mail_Principale__c)){
			if(!String.isBlank(contactToUpdate.Email)){
				buildCanalCommunication(canaux,newEmailPrefereItem, contactToUpdate.Email,'Adresse Mail 1', 1);
			}
			if(!String.isBlank(contactToUpdate.Adresse_Mail_2__c)){
				buildCanalCommunication(canaux,newEmailPrefereItem, contactToUpdate.Adresse_Mail_2__c,'Adresse Mail 2', 2);
			}
			if(!String.isBlank(contactToUpdate.Adresse_Mail_3__c)){
				buildCanalCommunication(canaux,newEmailPrefereItem, contactToUpdate.Adresse_Mail_3__c,'Adresse Mail 3', 3);
			}
			// Update email de preference
			contactToUpdate.Adresse_Mail_Principale__c = newEmailPrefereItem;
		}
				// Sinon, si ce sera le premier email à renseigner
		else{
			buildCanalCommunication(canaux,newEmailPrefereItem, newEmail,'Adresse Mail 1', 1);
			// Update email de preference
			contactToUpdate.Adresse_Mail_Principale__c = newEmailPrefereItem;
			contactToUpdate.Email = newEmail;
		}
		input.personne.correspondance.canalCommunication = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element[canaux.size()];
		for(Integer i = 0 ; i < canaux.size() ; i++){
			input.personne.correspondance.canalCommunication[i] = canaux[i];
		}
		gdfsuezComBefChpPivotV8.retourTraitementMessagesDt response;
		try{
			response = port.MajPersonne_Http(input, octx);
		}
		catch(Exception e){
			System.debug('[SM_AP61_PersonneOctopus:majPersonneProfilMarketing] : Error WS MajPersonne_Http');
		}
		if(response != null && response.retourTraitementMessage!= null && response.retourTraitementMessage.size()>0 && 'OCTOPUS_MAJPersonne_01'.equals(response.retourTraitementMessage.get(0).code)){
				// Si MAJ PERSONNE OK -> On mets à jour le contact dans SMILE
				update contactToUpdate;
				outMap.put('MAJProfilMarketing', 'OK');
		}
		else{
				outMap.put('MAJProfilMarketing', 'KO');
		}
	}

	private static void buildCanalCommunication(List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element> canaux, String newEmailPrefereItem, String email, String emailPrefereItem, Integer order){
		gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
		aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
		aCanal.type_x.code = 'INT';
		aCanal.mail = email;
		aCanal.utiliserDePreference = newEmailPrefereItem == emailPrefereItem;
		aCanal.ordre = order;
		canaux.add(aCanal);
	}

	public static gdfsuezBefCalypsoPersonneV8.PersonnePort buildPortWSPersonne(){
		gdfsuezBefCalypsoPersonneV8.PersonnePort port = new gdfsuezBefCalypsoPersonneV8.PersonnePort() ;  
		SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();  
		port.clientCertName_x = octopusCS.certName__c;
		port.endpoint_x =  octopusCS.endpoint__c+'E-Personne_v8';
		System.debug('*** endpoint : ' + port.endpoint_x);
		port.inputHttpHeaders_x = new Map<String, String>{'Content-Type' => 'text/xml;charset=utf-8'};
		return port;
	}

	/**
	 *   @description Appel à l'opération "MAJPersonne" et mise à jour du contact dans Salesforce
	 *   Attention : il faut seulement envoyer les champs qui ont changés
	 *   L'appel au WS ne se fait que si la MAJ du contact a fonctionné dans SF
	 */
	public static void majPersonne(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options){   
		System.debug('*** IN majPersonne'); 

		outMap.put('majPersonneRet', null);
		outMap.put('majContactSF', null);

		gdfsuezComBefChpPivotV8.contextDt octx = initContext('Smile', '2.0'); 

		gdfsuezBefCalypsoPersonneV8.PersonnePort port = buildPortWSPersonne() ;

		// Récupère les params
		Map<String, Object> elements = (Map<String, Object>) inputMap.get('ChoixElements');
		Map<String, Object> adresseElements = (Map<String, Object>) elements.get('AdresseContact');
		Map<String, Object> contactElements = (Map<String, Object>) elements.get('ContactInfo');
		Map<String, Object> telMobileElements = (Map<String, Object>) elements.get('TelMobile');
		Map<String, Object> telFixeElements = (Map<String, Object>) elements.get('TelFixe');
		Map<String, Object> emailsElements = (Map<String, Object>) elements.get('AdresseEmail');

		gdfsuezBefCalypsoPersonneV8.majPersonneInputDt input = new gdfsuezBefCalypsoPersonneV8.majPersonneInputDt();

		Integer correspondanceAdded = 0;

		// Infos persos
		input.personne = new gdfsuezComBefCalypsoPersonneV8.Personne();
		
		// Infos marketing
		Map<String, Object> canauxMkt = (Map<String, Object>) elements.get('ChoixCanal');
		Map<String, Object> stopMkt = (Map<String, Object>) canauxMkt.get('Stop');
		
		// Infos de contact (ZTM = email, TEL = fixe, INT = Email)
		String fixePrefere = (String) telFixeElements.get('updatePrincipalFixe');
		String mobilePrefere = (String) telMobileElements.get('updatePrincipalMobile');
		String emailPrefere = (String) emailsElements.get('updatePrincipalEmail');

		Boolean bRefusFixe = (Boolean) telFixeElements.get('RefusTelFixe');
		Boolean bRefusMobile = (Boolean) telMobileElements.get('RefusTelMobile');
		Boolean bRefusEmail = (Boolean) emailsElements.get('RefusEmail');

		// Besoin de comparer les nouvelles valeurs à celles en base
		String idContact = (String) inputMap.get('ContextId');
		System.debug('**** idContact : ' + idContact);

		Contact aContact = [SELECT Id, Identifiant_Buisness_Partener__c, Complement_adresse__c, Refus_Email__c, Refus_Fixe__c, Refus_Mobile__c, Adresse_Mail_2__c, Adresse_Mail_3__c, Adresse_Mail_Principale__c, Email, Mobile_2__c, Mobile_3__c, Mobile_Principal__c, MobilePhone, MobilePrincipalValue__c, Phone, Tel_fixe_2__c, Tel_fixe_3__c, Tel_Fixe_Principal__c FROM Contact WHERE Id = :idContact];


		input.personne.idPersonne = aContact.Identifiant_Buisness_Partener__c;

		List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element> canaux = new List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element>();

		// ------------------- MOBILE -----------------------
		String data = '';

		if(!bRefusMobile){

			// Mobile 1
			String mobile1 = telMobileElements.containsKey('NewMobile1') ? (String) telMobileElements.get('NewMobile1') : '';
			system.debug('**** mobile 1 : '+mobile1);
			data=formatPhoneNumber(mobile1);
			if(!String.isBlank(data) || !String.isBlank(aContact.MobilePhone)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'ZTM';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.telephone = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = mobilePrefere == 'Mobile 1';
                system.debug('**** mobilePrefere is mobile 1');
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.MobilePhone) ? 1 : null;
				
				canaux.add(aCanal);

				aContact.MobilePhone = data;
			}

			// Mobile 2
			String mobile2 = telMobileElements.containsKey('NewMobile2') ? (String) telMobileElements.get('NewMobile2') : '';
			system.debug('**** mobile 2 : '+mobile2);
			data=formatPhoneNumber(mobile2);
			
			if(!String.isBlank(data) || !String.isBlank(aContact.Mobile_2__c)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'ZTM';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.telephone = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = mobilePrefere == 'Mobile 2';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Mobile_2__c) ? 2 : null;
				
				canaux.add(aCanal);

				aContact.Mobile_2__c = data;
			}
		   

			// Mobile 3
			Map<String, Object> mobile3block = (Map<String, Object>) telMobileElements.get('mobile3Block');
			String mobile3 = mobile3block.containsKey('NewMobile3') ? (String) mobile3block.get('NewMobile3') : '';
			system.debug('**** mobile 3 : '+mobile3);
			data=formatPhoneNumber(mobile3);
			if(!String.isBlank(data) || !String.isBlank(aContact.Mobile_3__c)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'ZTM';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.telephone = !String.isBlank(data) ? data : '';
				aCanal.utiliserDePreference = mobilePrefere == 'Mobile 3';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Mobile_3__c) ? 3 : null;
				
				canaux.add(aCanal);

				aContact.Mobile_3__c = data;
			}
		  
		} else{
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.type_x.code = 'ZTM';
			aCanal.flag = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.flag.code = 'REFUS';

			canaux.add(aCanal);
		}

		aContact.Refus_Mobile__c = bRefusMobile;
		aContact.Mobile_Principal__c = mobilePrefere;

		// ------------------- FIXE -----------------------
		if(!bRefusFixe){

			// Fixe 1
			String fix1 = telFixeElements.containsKey('NewTelFixe1') ? (String) telFixeElements.get('NewTelFixe1') : '';
			system.debug('**** fix 1 : '+fix1);
			data=formatPhoneNumber(fix1);
			if(!String.isBlank(data) || !String.isBlank(aContact.Phone)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'TEL';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.telephone = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = fixePrefere == 'Tel Fixe 1';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Phone) ? 1 : null;
				
				canaux.add(aCanal);

				aContact.Phone = data;
			}

			// Fixe 2
			String fix2 = telFixeElements.containsKey('NewTelFixe2') ? (String) telFixeElements.get('NewTelFixe2') : '';
			system.debug('**** fix 2 : '+fix2);
			data=formatPhoneNumber(fix2);
			if(!String.isBlank(data) || !String.isBlank(aContact.Tel_fixe_2__c)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'TEL';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.telephone = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = fixePrefere == 'Tel Fixe 2';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Tel_fixe_2__c) ? 2 : null;
				
				canaux.add(aCanal);

				aContact.Tel_fixe_2__c = data;
			}

			// Fixe 3
			Map<String, Object> fixe3block = (Map<String, Object>) telFixeElements.get('Fix3Block');
			String fix3 = fixe3block.containsKey('NewTelFixe3') ? (String) fixe3block.get('NewTelFixe3') : '';
			system.debug('**** fix 3 : '+fix3);
			data=formatPhoneNumber(fix3);
			if(!String.isBlank(data) || !String.isBlank(aContact.Tel_fixe_3__c)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'TEL';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.telephone = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = fixePrefere == 'Tel Fixe 3';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Tel_fixe_3__c) ? 3 : null;
				
				canaux.add(aCanal);

				aContact.Tel_fixe_3__c = data;
			}
			
		} else{
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.type_x.code = 'TEL';
			aCanal.flag = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.flag.code = 'REFUS';

			canaux.add(aCanal);
		}

		aContact.Refus_Fixe__c = bRefusFixe;
		aContact.Tel_Fixe_Principal__c = fixePrefere;

		// ------------------- EMAIL -----------------------
		if(!bRefusEmail){

			data = emailsElements.containsKey('NouvelleAdresseMail1') ? (String) emailsElements.get('NouvelleAdresseMail1') : '';
			if(!String.isBlank(data) || !String.isBlank(aContact.Email)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'INT';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.mail = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = emailPrefere == 'Adresse Mail 1';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Email) ? 1 : null;
				
				canaux.add(aCanal);

				aContact.Email = data;
			}

			data = emailsElements.containsKey('NouvelleAdresseMail2') ? (String) emailsElements.get('NouvelleAdresseMail2') : '';
			if(!String.isBlank(data) || !String.isBlank(aContact.Adresse_Mail_2__c)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'INT';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.mail = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = emailPrefere == 'Adresse Mail 2';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Adresse_Mail_2__c) ? 2 : null;
				
				canaux.add(aCanal);

				aContact.Adresse_Mail_2__c = data;
			}

			Map<String, Object> email3block = (Map<String, Object>) emailsElements.get('Email3Block');
			data = email3block.containsKey('NouvelleAdresseMail3') ? (String) email3block.get('NouvelleAdresseMail3') : '';
			if(!String.isBlank(data) || !String.isBlank(aContact.Adresse_Mail_3__c)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'INT';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.mail = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = emailPrefere == 'Adresse Mail 3';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Adresse_Mail_3__c) ? 3 : null;
				
				canaux.add(aCanal);

				aContact.Adresse_Mail_3__c = data;
			}
		} else{
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.type_x.code = 'INT';
			aCanal.flag = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.flag.code = 'REFUS';

			canaux.add(aCanal);
		}

		aContact.Refus_Email__c = bRefusEmail;
		aContact.Adresse_Mail_Principale__c = emailPrefere;

		// Bloc adresse
		gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
		aCanal.adresse = new gdfsuezComBefCalypsoPersonneV8.adresseDt();
		System.debug('*** adresseElements : ' + adresseElements);
		String numVoieToSend='.';
		if(adresseElements.containsKey('NoVoie')){
			numVoieToSend = SM_Adresses_Utilities.formatStringToSAPFormat((String) adresseElements.get('NoVoie'));
			if(String.isBlank(numVoieToSend)){
				numVoieToSend='.';
			}
		}
	   
		aCanal.adresse.nVoie = numVoieToSend;
		aCanal.adresse.libelleVoie = adresseElements.containsKey('Adresse') ? SM_Adresses_Utilities.formatStringToSAPFormat((String) adresseElements.get('Adresse')) : null;
		aCanal.adresse.CP = adresseElements.containsKey('CodePostal') ? SM_Adresses_Utilities.formatStringToSAPFormat((String) adresseElements.get('CodePostal')) : null;
		aCanal.adresse.ville = adresseElements.containsKey('Ville') ? SM_Adresses_Utilities.formatStringToSAPFormat((String) adresseElements.get('Ville')) : null;
		
		if(adresseElements.containsKey('ComplementAdresse')){
			String newComplement = (String) adresseElements.get('ComplementAdresse');
			// 2 cas de figure : la valeur est remplie OU la valeur vient d'être vidée
			
			// 1 : valeur remplie
			if(!String.isBlank(newComplement)){
				aCanal.adresse.complementAdresse = SM_Adresses_Utilities.formatStringToSAPFormat(newComplement);
			} else if(String.isBlank(newComplement) && !String.isBlank(aContact.Complement_adresse__c)){
				aCanal.adresse.complementAdresse = '.' ; // valeur par défaut
			}
			
		}
		aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
		aCanal.type_x.code = 'LET';

		aContact.No_Voie__c = aCanal.adresse.nVoie;
		aContact.MailingStreet = aCanal.adresse.libelleVoie;
		aContact.MailingPostalCode = aCanal.adresse.CP;
		aContact.MailingCity = aCanal.adresse.ville;
		aContact.Complement_adresse__c = aCanal.adresse.complementAdresse;

		canaux.add(aCanal);

		input.personne.correspondance = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_element();
		input.personne.correspondance.canalCommunication = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element[canaux.size()];
		// Récupère les stop marketing
		aContact.DoNotCall = ((Boolean) stopMkt.containsKey('stopPhoning')) ? (Boolean) stopMkt.get('stopPhoning') : false;
		aContact.HasOptedOutOfEmail = ((Boolean) stopMkt.containsKey('stopMailing')) ? (Boolean) stopMkt.get('stopMailing') : false;
		//ADE
		aContact.StopEmailing__c = ((Boolean) stopMkt.containsKey('stopEmailing')) ? (Boolean) stopMkt.get('stopEmailing') : false;
		//aContact.StopSmsing__c = ((Boolean) stopMkt.containsKey('stopSMSing')) ? (Boolean) stopMkt.get('stopSMSing') : false;
		/////////////////////////////////////////SYNCHRO INFOS MARKETING SAP /////////////////////////////////////////////
		//stopPhoning
		input.personne.profilMarketing = new gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element[]{};
		gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element profilMarketing = new gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element();
		gdfsuezComBefChpPivotV8.listeValeursDt designation = new gdfsuezComBefChpPivotV8.listeValeursDt();
		designation.code = 'stopPhoning';
		profilMarketing.designation = designation;
		if(aContact.DoNotCall==true){
		profilMarketing.valeurDesignation = 'true';
		}else{
		profilMarketing.valeurDesignation = 'false';
		}
		input.personne.profilMarketing.add(profilMarketing);
		//stopMailing
		profilMarketing = new gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element();
		 designation = new gdfsuezComBefChpPivotV8.listeValeursDt();
		designation.code = 'stopMailing';
		profilMarketing.designation = designation;
		if(aContact.HasOptedOutOfEmail==true){
			profilMarketing.valeurDesignation = 'true';
		}else{
			profilMarketing.valeurDesignation = 'false';
		}
		input.personne.profilMarketing.add(profilMarketing);
		//stopEmailing
		 profilMarketing = new gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element();
		 designation = new gdfsuezComBefChpPivotV8.listeValeursDt();
		designation.code = 'stopEmailing';
		profilMarketing.designation = designation;
		if(aContact.StopEmailing__c==true){
		profilMarketing.valeurDesignation = 'true';
		}else{
		profilMarketing.valeurDesignation = 'false';
		}
		input.personne.profilMarketing.add(profilMarketing);
		//stopSMSing
	/*	profilMarketing = new gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element();
		designation = new gdfsuezComBefChpPivotV8.listeValeursDt();
		designation.code = 'stopSMSing';
		profilMarketing.designation = designation;
		if(aContact.StopSmsing__c==true){
		profilMarketing.valeurDesignation = '1';
		}else{
		profilMarketing.valeurDesignation = '0';
		}
		input.personne.profilMarketing.add(profilMarketing);*/
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		aContact.Canal_de_preference__c = canauxMkt.containsKey('CanalPreference') ? (String) canauxMkt.get('CanalPreference') : '';
		

		for(Integer i = 0 ; i < canaux.size() ; i++){
			input.personne.correspondance.canalCommunication[i] = canaux[i];
		}

		gdfsuezComBefChpPivotV8.retourTraitementMessagesDt response;
		
		if(!Test.isRunningTest()){
			response  = port.MajPersonne_Http(input,octx);
		}else if(Test.isRunningTest()) {
			Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPersonneV8HttpMock());
			gdfsuezBefCalypsoPersonneV8.PersonnePort porttest = new gdfsuezBefCalypsoPersonneV8.PersonnePort();
			system.debug('@@ start of mock');
			response = porttest.MajPersonne_Http(input, octx);
			system.debug('@@ end of mock');
		}
		if(response != null && response.retourTraitementMessage != null && response.retourTraitementMessage[0] != null){
			outMap.put('majPersonneRet', response.retourTraitementMessage[0].code);
			// On considère qu'un code retour différent de OCTOPUS_MAJPersonne_01 mais avec un type = 'Information' est OK
			String respCode = response.retourTraitementMessage[0].code;
			String typeErr = response.retourTraitementMessage[0].type_x;
			
			// On ne lance la MAJ Salesforce que si celle Octopus a marché
			if(respCode  == 'OCTOPUS_MAJPersonne_01' || typeErr == 'Information'){
				outMap.put('majPersonneRet', 'OCTOPUS_MAJPersonne_01');
				Database.SaveResult updateResult = Database.update(aContact, false);
				outMap.put('majContactSF', updateResult.isSuccess());
				System.debug('**** MAJ Contact SF : ' + updateResult.isSuccess());
			} else{
				outMap.put('text_err_octopus', response.retourTraitementMessage[0].libelle);
			}
		}

		System.debug('*** OUT majPersonne with code : ' + outMap.get('majPersonneRet'));
		System.debug('*** OUT majPersonne with text : ' + outMap.get('text_err_octopus'));
	}

	public static void majPersonneLWC(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options){   
		System.debug('*** IN majPersonne'); 

		outMap.put('majPersonneRet', null);
		outMap.put('majContactSF', null);

		gdfsuezComBefChpPivotV8.contextDt octx = initContext('Smile', '2.0'); 

		gdfsuezBefCalypsoPersonneV8.PersonnePort port = buildPortWSPersonne() ;


		// Récupère les params
		Map<Object, Object> elements = (Map<Object, Object>) inputMap.get('ChoixElements');
		Map<Object, Object> adresseElements = (Map<Object, Object>) elements.get('AdresseContact');
		Map<Object, Object> contactElements = (Map<Object, Object>) elements.get('ContactInfo');
		Map<Object, Object> telMobileElements = (Map<Object, Object>) elements.get('TelMobile');
		Map<Object, Object> telFixeElements = (Map<Object, Object>) elements.get('TelFixe');
		Map<Object, Object> emailsElements = (Map<Object, Object>) elements.get('AdresseEmail');

		gdfsuezBefCalypsoPersonneV8.majPersonneInputDt input = new gdfsuezBefCalypsoPersonneV8.majPersonneInputDt();

		Integer correspondanceAdded = 0;

		// Infos persos
		input.personne = new gdfsuezComBefCalypsoPersonneV8.Personne();
		
		// Infos marketing
		Map<Object, Object> canauxMkt = (Map<Object, Object>) elements.get('ChoixCanal');
		Map<Object, Object> stopMkt = (Map<Object, Object>) canauxMkt.get('Stop');
		
		// Infos de contact (ZTM = email, TEL = fixe, INT = Email)
		String fixePrefere = (String) telFixeElements.get('updatePrincipalFixe');
		String mobilePrefere = (String) telMobileElements.get('updatePrincipalMobile');
		String emailPrefere = (String) emailsElements.get('updatePrincipalEmail');

		Boolean bRefusFixe = (Boolean) telFixeElements.get('RefusTelFixe');
		Boolean bRefusMobile = (Boolean) telMobileElements.get('RefusTelMobile');
		Boolean bRefusEmail = (Boolean) emailsElements.get('RefusEmail');

		// Besoin de comparer les nouvelles valeurs à celles en base
		String idContact = (String) inputMap.get('ContextId');
		System.debug('**** idContact : ' + idContact);

		Contact aContact = [SELECT Id, Identifiant_Buisness_Partener__c, Complement_adresse__c, Refus_Email__c, Refus_Fixe__c, Refus_Mobile__c, Adresse_Mail_2__c, Adresse_Mail_3__c, Adresse_Mail_Principale__c, Email, Mobile_2__c, Mobile_3__c, Mobile_Principal__c, MobilePhone, MobilePrincipalValue__c, Phone, Tel_fixe_2__c, Tel_fixe_3__c, Tel_Fixe_Principal__c FROM Contact WHERE Id = :idContact];


		input.personne.idPersonne = aContact.Identifiant_Buisness_Partener__c;

		List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element> canaux = new List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element>();

		// ------------------- MOBILE -----------------------
		String data = '';

		if(!bRefusMobile){

			// Mobile 1
			String mobile1 = telMobileElements.containsKey('NewMobile1') ? (String) telMobileElements.get('NewMobile1') : '';
			system.debug('**** mobile 1 : '+mobile1);
			data=formatPhoneNumber(mobile1);
			if(!String.isBlank(data) || !String.isBlank(aContact.MobilePhone)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'ZTM';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.telephone = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = mobilePrefere == 'Mobile 1';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.MobilePhone) ? 1 : null;
				
				canaux.add(aCanal);

				aContact.MobilePhone = data;
			}

			// Mobile 2
			String mobile2 = telMobileElements.containsKey('NewMobile2') ? (String) telMobileElements.get('NewMobile2') : '';
			system.debug('**** mobile 2 : '+mobile2);
			data=formatPhoneNumber(mobile2);
			
			if(!String.isBlank(data) || !String.isBlank(aContact.Mobile_2__c)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'ZTM';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.telephone = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = mobilePrefere == 'Mobile 2';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Mobile_2__c) ? 2 : null;
				
				canaux.add(aCanal);

				aContact.Mobile_2__c = data;
			}
		   

			// Mobile 3
			Map<Object, Object> mobile3block = (Map<Object, Object>) telMobileElements.get('mobile3Block');
			String mobile3 = mobile3block.containsKey('NewMobile3') ? (String) mobile3block.get('NewMobile3') : '';
			system.debug('**** mobile 3 : '+mobile3);
			data=formatPhoneNumber(mobile3);
			if(!String.isBlank(data) || !String.isBlank(aContact.Mobile_3__c)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'ZTM';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.telephone = !String.isBlank(data) ? data : '';
				aCanal.utiliserDePreference = mobilePrefere == 'Mobile 3';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Mobile_3__c) ? 3 : null;
				
				canaux.add(aCanal);

				aContact.Mobile_3__c = data;
			}
		  
		} else{
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.type_x.code = 'ZTM';
			aCanal.flag = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.flag.code = 'REFUS';

			canaux.add(aCanal);
		}

		aContact.Refus_Mobile__c = bRefusMobile;
		aContact.Mobile_Principal__c = mobilePrefere;

		// ------------------- FIXE -----------------------
		if(!bRefusFixe){

			// Fixe 1
			String fix1 = telFixeElements.containsKey('NewTelFixe1') ? (String) telFixeElements.get('NewTelFixe1') : '';
			system.debug('**** fix 1 : '+fix1);
			data=formatPhoneNumber(fix1);
			if(!String.isBlank(data) || !String.isBlank(aContact.Phone)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'TEL';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.telephone = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = fixePrefere == 'Tel Fixe 1';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Phone) ? 1 : null;
				
				canaux.add(aCanal);

				aContact.Phone = data;
			}

			// Fixe 2
			String fix2 = telFixeElements.containsKey('NewTelFixe2') ? (String) telFixeElements.get('NewTelFixe2') : '';
			system.debug('**** fix 2 : '+fix2);
			data=formatPhoneNumber(fix2);
			if(!String.isBlank(data) || !String.isBlank(aContact.Tel_fixe_2__c)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'TEL';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.telephone = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = fixePrefere == 'Tel Fixe 2';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Tel_fixe_2__c) ? 2 : null;
				
				canaux.add(aCanal);

				aContact.Tel_fixe_2__c = data;
			}

			// Fixe 3
			Map<Object, Object> fixe3block = (Map<Object, Object>) telFixeElements.get('Fix3Block');
			String fix3 = fixe3block.containsKey('NewTelFixe3') ? (String) fixe3block.get('NewTelFixe3') : '';
			system.debug('**** fix 3 : '+fix3);
			data=formatPhoneNumber(fix3);
			if(!String.isBlank(data) || !String.isBlank(aContact.Tel_fixe_3__c)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'TEL';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.telephone = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = fixePrefere == 'Tel Fixe 3';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Tel_fixe_3__c) ? 3 : null;
				
				canaux.add(aCanal);

				aContact.Tel_fixe_3__c = data;
			}
			
		} else{
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.type_x.code = 'TEL';
			aCanal.flag = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.flag.code = 'REFUS';

			canaux.add(aCanal);
		}

		aContact.Refus_Fixe__c = bRefusFixe;
		aContact.Tel_Fixe_Principal__c = fixePrefere;

		// ------------------- EMAIL -----------------------
		if(!bRefusEmail){

			data = emailsElements.containsKey('NouvelleAdresseMail1') ? (String) emailsElements.get('NouvelleAdresseMail1') : '';
			if(!String.isBlank(data) || !String.isBlank(aContact.Email)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'INT';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.mail = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = emailPrefere == 'Adresse Mail 1';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Email) ? 1 : null;
				
				canaux.add(aCanal);

				aContact.Email = data;
			}

			data = emailsElements.containsKey('NouvelleAdresseMail2') ? (String) emailsElements.get('NouvelleAdresseMail2') : '';
			if(!String.isBlank(data) || !String.isBlank(aContact.Adresse_Mail_2__c)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'INT';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.mail = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = emailPrefere == 'Adresse Mail 2';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Adresse_Mail_2__c) ? 2 : null;
				
				canaux.add(aCanal);

				aContact.Adresse_Mail_2__c = data;
			}

			Map<Object, Object> email3block = (Map<Object, Object>) emailsElements.get('Email3Block');
			data = email3block.containsKey('NouvelleAdresseMail3') ? (String) email3block.get('NouvelleAdresseMail3') : '';
			if(!String.isBlank(data) || !String.isBlank(aContact.Adresse_Mail_3__c)){
				gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
				aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
				aCanal.type_x.code = 'INT';

				// On envoie le téléphone si la valeur n'est pas vide
				aCanal.mail = !String.isBlank(data) ? data : null;
				aCanal.utiliserDePreference = emailPrefere == 'Adresse Mail 3';
				// On envoie l'ordre que dans le cas d'une suppression / mise à jour
				aCanal.ordre = !String.isBlank(aContact.Adresse_Mail_3__c) ? 3 : null;
				
				canaux.add(aCanal);

				aContact.Adresse_Mail_3__c = data;
			}
		} else{
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.type_x.code = 'INT';
			aCanal.flag = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.flag.code = 'REFUS';

			canaux.add(aCanal);
		}

		aContact.Refus_Email__c = bRefusEmail;
		aContact.Adresse_Mail_Principale__c = emailPrefere;

		// Bloc adresse
		gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
		aCanal.adresse = new gdfsuezComBefCalypsoPersonneV8.adresseDt();
		System.debug('*** adresseElements : ' + adresseElements);
		String numVoieToSend='.';
		if(adresseElements.containsKey('NoVoie')){
			numVoieToSend = SM_Adresses_Utilities.formatStringToSAPFormat((String) adresseElements.get('NoVoie'));
			if(String.isBlank(numVoieToSend)){
				numVoieToSend='.';
			}
		}
	   
		aCanal.adresse.nVoie = numVoieToSend;
		aCanal.adresse.libelleVoie = adresseElements.containsKey('Adresse') ? SM_Adresses_Utilities.formatStringToSAPFormat((String) adresseElements.get('Adresse')) : null;
		aCanal.adresse.CP = adresseElements.containsKey('CodePostal') ? SM_Adresses_Utilities.formatStringToSAPFormat((String) adresseElements.get('CodePostal')) : null;
		aCanal.adresse.ville = adresseElements.containsKey('Ville') ? SM_Adresses_Utilities.formatStringToSAPFormat((String) adresseElements.get('Ville')) : null;
		
		if(adresseElements.containsKey('ComplementAdresse')){
			String newComplement = (String) adresseElements.get('ComplementAdresse');
			// 2 cas de figure : la valeur est remplie OU la valeur vient d'être vidée
			
			// 1 : valeur remplie
			if(!String.isBlank(newComplement)){
				aCanal.adresse.complementAdresse = SM_Adresses_Utilities.formatStringToSAPFormat(newComplement);
			} else if(String.isBlank(newComplement) && !String.isBlank(aContact.Complement_adresse__c)){
				aCanal.adresse.complementAdresse = '.' ; // valeur par défaut
			}
			
		}

		if(adresseElements.containsKey('Chez')){
			String chez = (String) adresseElements.get('Chez');
			aCanal.adresse.chez = chez;
		}
		aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
		aCanal.type_x.code = 'LET';

		aContact.No_Voie__c = aCanal.adresse.nVoie;
		aContact.MailingStreet = aCanal.adresse.libelleVoie;
		aContact.MailingPostalCode = aCanal.adresse.CP;
		aContact.MailingCity = aCanal.adresse.ville;
		aContact.Complement_adresse__c = aCanal.adresse.complementAdresse;

		canaux.add(aCanal);



		input.personne.correspondance = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_element();
		input.personne.correspondance.canalCommunication = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element[canaux.size()];


		// Récupère les stop marketing
		aContact.DoNotCall = ((Boolean) stopMkt.containsKey('stopPhoning')) ? (Boolean) stopMkt.get('stopPhoning') : false;
		aContact.HasOptedOutOfEmail = ((Boolean) stopMkt.containsKey('stopMailing')) ? (Boolean) stopMkt.get('stopMailing') : false;
		//ADE
		aContact.StopEmailing__c = ((Boolean) stopMkt.containsKey('stopEmailing')) ? (Boolean) stopMkt.get('stopEmailing') : false;
		//aContact.StopSmsing__c = ((Boolean) stopMkt.containsKey('stopSMSing')) ? (Boolean) stopMkt.get('stopSMSing') : false;
		/////////////////////////////////////////SYNCHRO INFOS MARKETING SAP /////////////////////////////////////////////
		//stopPhoning
		input.personne.profilMarketing = new gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element[]{};
		gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element profilMarketing = new gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element();
		gdfsuezComBefChpPivotV8.listeValeursDt designation = new gdfsuezComBefChpPivotV8.listeValeursDt();
		designation.code = 'stopPhoning';
		profilMarketing.designation = designation;
		if(aContact.DoNotCall==true){
		profilMarketing.valeurDesignation = 'true';
		}else{
		profilMarketing.valeurDesignation = 'false';
		}
		input.personne.profilMarketing.add(profilMarketing);
		//stopMailing
		profilMarketing = new gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element();
		 designation = new gdfsuezComBefChpPivotV8.listeValeursDt();
		designation.code = 'stopMailing';
		profilMarketing.designation = designation;
		if(aContact.HasOptedOutOfEmail==true){
		profilMarketing.valeurDesignation = 'true';
		}else{
		profilMarketing.valeurDesignation = 'false';
		}
		input.personne.profilMarketing.add(profilMarketing);
		//stopEmailing
		 profilMarketing = new gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element();
		 designation = new gdfsuezComBefChpPivotV8.listeValeursDt();
		designation.code = 'stopEmailing';
		profilMarketing.designation = designation;
		if(aContact.StopEmailing__c==true){
		profilMarketing.valeurDesignation = 'true';
		}else{
		profilMarketing.valeurDesignation = 'false';
		}
		input.personne.profilMarketing.add(profilMarketing);
		//stopSMSing
		/*profilMarketing = new gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element();
		designation = new gdfsuezComBefChpPivotV8.listeValeursDt();
		designation.code = 'stopSMSing';
		profilMarketing.designation = designation;
		if(aContact.StopSmsing__c==true){
		profilMarketing.valeurDesignation = '1';
		}else{
		profilMarketing.valeurDesignation = '0';
		}
		input.personne.profilMarketing.add(profilMarketing);*/
		////////////////////////////////////////////////////////////////////////////////////////////////////////////

		aContact.Canal_de_preference__c = canauxMkt.containsKey('CanalPreference') ? (String) canauxMkt.get('CanalPreference') : '';

		for(Integer i = 0 ; i < canaux.size() ; i++){
			input.personne.correspondance.canalCommunication[i] = canaux[i];
		}

		gdfsuezComBefChpPivotV8.retourTraitementMessagesDt response;
		
		if(!Test.isRunningTest()){
			response  = port.MajPersonne_Http(input,octx);
		}else if(Test.isRunningTest()) {
			Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPersonneV8HttpMock());
			gdfsuezBefCalypsoPersonneV8.PersonnePort porttest = new gdfsuezBefCalypsoPersonneV8.PersonnePort();
			system.debug('@@ start of mock');
			response = porttest.MajPersonne_Http(input, octx);
			system.debug('@@ end of mock');
		}
		if(response != null && response.retourTraitementMessage != null && response.retourTraitementMessage[0] != null){
			outMap.put('majPersonneRet', response.retourTraitementMessage[0].code);
			// On considère qu'un code retour différent de OCTOPUS_MAJPersonne_01 mais avec un type = 'Information' est OK
			String respCode = response.retourTraitementMessage[0].code;
			String typeErr = response.retourTraitementMessage[0].type_x;
			
			// On ne lance la MAJ Salesforce que si celle Octopus a marché
			if(respCode  == 'OCTOPUS_MAJPersonne_01' || typeErr == 'Information'){
				outMap.put('majPersonneRet', 'OCTOPUS_MAJPersonne_01');
				Database.SaveResult updateResult = Database.update(aContact, false);
				outMap.put('majContactSF', updateResult.isSuccess());
				System.debug('**** MAJ Contact SF : ' + updateResult.isSuccess());
			} else{
				outMap.put('text_err_octopus', response.retourTraitementMessage[0].libelle);
			}
		}

		System.debug('*** OUT majPersonne with code : ' + outMap.get('majPersonneRet'));
		System.debug('*** OUT majPersonne with text : ' + outMap.get('text_err_octopus'));
	}
	
	/**
	 *   @description Appeler depuis l'IP NewContact. Cette méthode permet de créer dynamiquement les correspondances
	 */
	public static void creerPersonneCorrespondance(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options){   
		System.debug('*** IN creerPersonneCorrespondance');
		
		System.debug('*** Params');
		
		for(String aKey : inputMap.keySet()){
			System.debug(aKey + ' - ' + inputMap.get(aKey));
		}

		String mail1 = (String) inputMap.get('mail1');
		String mail2 = (String) inputMap.get('mail2');
		String mail3 = (String) inputMap.get('mail3');
		String tel1 = (String) inputMap.get('tel1');
		String tel2 = (String) inputMap.get('tel2');
		String tel3 = (String) inputMap.get('tel3');
		String mobile1 = (String) inputMap.get('mobile1');
		String mobile2 = (String) inputMap.get('mobile2');
		String mobile3 = (String) inputMap.get('mobile3');
		String prenom = (String) inputMap.get('prenom');
		String nom = (String) inputMap.get('nom');
		String civilite = (String) inputMap.get('civilite');
		String numvoie = (String) inputMap.get('num_rue');
		String street = (String) inputMap.get('rue');
		String ville = (String) inputMap.get('ville');
		String cp = (String) inputMap.get('cp');
		String cplt = (String) inputMap.get('cplt');
		String chez = (String) inputMap.get('chez');
		
		String emailPrefere = (String) inputMap.get('mailPrefere');
		String telPrefere = (String) inputMap.get('telPrefere');
		String mobilePrefere = (String) inputMap.get('mobilePrefere');

		Boolean refusEmail = (Boolean) inputMap.get('refusEmail');
		Boolean refusFixe = (Boolean) inputMap.get('refusFixe');
		Boolean refusMobile = (Boolean) inputMap.get('refusMobile');
		
		System.debug('*** ' + mail1);
		System.debug('*** ' + mail2);
		System.debug('*** ' + mail3);
		System.debug('*** ' + tel1);
		System.debug('*** ' + tel2);
		System.debug('*** ' + tel3);
		System.debug('*** ' + mobile1);
		System.debug('*** ' + mobile2);
		System.debug('*** ' + mobile3);
		System.debug('*** ' + emailPrefere);
		System.debug('*** ' + telPrefere);
		System.debug('*** ' + mobilePrefere);
		System.debug('*** ' + refusEmail);
		System.debug('*** ' + refusFixe);
		System.debug('*** ' + refusMobile);
		System.debug('***chez ' + chez);
		
		// Init
		gdfsuezComBefChpPivotV8.contextDt octx = initContext('Smile', '2.0'); 

		gdfsuezBefCalypsoPersonneV8.PersonnePort port = buildPortWSPersonne();
				
		gdfsuezBefCalypsoPersonneV8.creerPersonneInputDt input = new gdfsuezBefCalypsoPersonneV8.creerPersonneInputDt();
		input.personne = new gdfsuezComBefCalypsoPersonneV8.Personne();
		input.personne.prenom = prenom;
		input.personne.nom = nom;
		input.personne.civilite = new gdfsuezComBefChpPivotV8.listeValeursDt();
		input.personne.civilite.code = civilite;
		
		input.personne.correspondance = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_element();
		
		List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element> canaux = new List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element>();

		if(!String.isBlank(mail1)){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			if(emailPrefere == 'Adresse Mail 1'){
				aCanal.utiliserDePreference = true;
			}
			
			aCanal.mail = mail1;
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'INT';
			
			canaux.add(aCanal);
		}
		  
		if(!String.isBlank(mail2)){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			if(emailPrefere == 'Adresse Mail 2'){
				aCanal.utiliserDePreference = true;
			}
			
			aCanal.mail = mail2;
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'INT';
			
			canaux.add(aCanal);
		}
		
		if(!String.isBlank(mail3)){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			if(emailPrefere == 'Adresse Mail 3'){
				aCanal.utiliserDePreference = true;
			}
			
			aCanal.mail = mail3;
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'INT';
			
			canaux.add(aCanal);
		}

		// On passe le refus si la case refus est cochée
		if(refusEmail){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			aCanal.flag = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.flag.code = 'REFUS';
			
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'INT';
			
			canaux.add(aCanal);
		}
		// On passe le refus mail si les 3 sont vides
		else if(String.isBlank(mail1) && String.isBlank(mail2) && String.isBlank(mail3)){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			aCanal.flag = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.flag.code = 'AUCUN';
			
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'INT';
			
			canaux.add(aCanal);
		}

        if(!String.isBlank(mobile1)){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			if(mobilePrefere == 'Mobile 1'){
				aCanal.utiliserDePreference = true;
			}
			
			aCanal.telephone = mobile1;
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'ZTM';
			
			canaux.add(aCanal);
		}
		
		if(!String.isBlank(mobile2)){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			if(mobilePrefere == 'Mobile 2'){
				aCanal.utiliserDePreference = true;
			}
			
			aCanal.telephone = mobile2;
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'ZTM';
			
			canaux.add(aCanal);
		}
		
		if(!String.isBlank(mobile3)){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			if(mobilePrefere == 'Mobile 3'){
				aCanal.utiliserDePreference = true;
			}
			
			aCanal.telephone = mobile3;
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'ZTM';
			
			canaux.add(aCanal);
		}
		
		// On passe le refus mobile si la case refus est cochée
		if(refusMobile){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			aCanal.flag = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.flag.code = 'REFUS';
			
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'ZTM';
			
			canaux.add(aCanal);
		}
		// On passe le refus mobile si les 3 sont vides
		else if(String.isBlank(mobile1) && String.isBlank(mobile2) && String.isBlank(mobile3)){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			aCanal.flag = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.flag.code = 'AUCUN';
			
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'ZTM';
			
			canaux.add(aCanal);
		}

        if(!String.isBlank(tel1)){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			if(telPrefere == 'Tel Fixe 1'){
				aCanal.utiliserDePreference = true;
			}
			
			aCanal.telephone = tel1;
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'TEL';
			
			canaux.add(aCanal);
		}
		
		if(!String.isBlank(tel2)){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			if(telPrefere == 'Tel Fixe 2'){
				aCanal.utiliserDePreference = true;
			}
			
			aCanal.telephone = tel2;
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'TEL';
			
			canaux.add(aCanal);
		}
		
		if(!String.isBlank(tel3)){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			if(telPrefere == 'Tel Fixe 3'){
				aCanal.utiliserDePreference = true;
			}
			
			aCanal.telephone = tel3;
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'TEL';
			
			canaux.add(aCanal);
		}
		
		// On passe le refus tel si la case refus est cochée
		if(refusFixe){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			aCanal.flag = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.flag.code = 'REFUS';
			
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'TEL';
			
			canaux.add(aCanal);
		}
		// On passe le refus tel si les 3 sont vides
		else if(String.isBlank(tel1) && String.isBlank(tel2) && String.isBlank(tel3)){
			gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
			
			aCanal.flag = new gdfsuezComBefChpPivotV8.listeValeursDt();
			aCanal.flag.code = 'AUCUN';
			
			aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt(); 
			aCanal.type_x.code = 'TEL';
			
			canaux.add(aCanal);
		}

        input.personne.correspondance.canalCommunication = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element[canaux.size()];
		
		for(Integer i = 0 ; i < canaux.size() ; i++){
			input.personne.correspondance.canalCommunication[i] = canaux[i];
		}
		
		input.personne.adresse = new gdfsuezComBefCalypsoPersonneV8.adresseDt();
		String numVoieToSend='.';
		if(!String.isBlank(numvoie)){
			numVoieToSend = SM_Adresses_Utilities.formatStringToSAPFormat(numvoie);
			if(String.isBlank(numVoieToSend)){
				numVoieToSend='.';
			}
		}
		input.personne.adresse.nVoie = numVoieToSend;
		input.personne.adresse.libelleVoie = !String.isBlank(street) ? SM_Adresses_Utilities.formatStringToSAPFormat(street) : null;
		input.personne.adresse.CP = !String.isBlank(cp) ? SM_Adresses_Utilities.formatStringToSAPFormat(cp) : null;
		input.personne.adresse.ville = !String.isBlank(ville) ? SM_Adresses_Utilities.formatStringToSAPFormat(ville) : null;
		input.personne.adresse.complementAdresse = !String.isBlank(cplt) ? SM_Adresses_Utilities.formatStringToSAPFormat(cplt) : null; 
		input.personne.adresse.pays = new gdfsuezComBefChpPivotV8.listeValeursDt();
		input.personne.adresse.pays.code = 'FR';
		input.personne.adresse.chez = !String.isBlank(chez) ? SM_Adresses_Utilities.formatStringToSAPFormat(chez) : null;

		system.debug('@@ chez ' + input.personne.adresse.chez);

		gdfsuezBefCalypsoPersonneV8.creerPersonneResponse_element response;
		
		try {
			if(!Test.isRunningTest()){
				response  = port.CreerPersonne_Http(input,octx);
			}else if(Test.isRunningTest()) {
				Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPersonneV8HttpMock());
				gdfsuezBefCalypsoPersonneV8.PersonnePort porttest = new gdfsuezBefCalypsoPersonneV8.PersonnePort();
				system.debug('@@ start of mock');
				response = porttest.CreerPersonne_Http(input, octx);
				system.debug('@@ end of mock');
			}
			
			if (response != null) {
				outMap.put('connectionOctopus', 'OK');
			}

			if(response != null && response.messageRetours != null && response.messageRetours.retourTraitementMessage != null && response.messageRetours.retourTraitementMessage[0] != null){
				// creerPersonneRetour_code
				if (response.messageRetours.retourTraitementMessage[0].code != '') {
					outMap.put('creerPersonneRetour_code', response.messageRetours.retourTraitementMessage[0].code);
				} else {
					outMap.put('creerPersonneRetour_code', 'NOK');
				}
				// creerPersonneRetour_libelle
				if (response.messageRetours.retourTraitementMessage[0].libelle != '') {
					outMap.put('creerPersonneRetour_libelle', response.messageRetours.retourTraitementMessage[0].libelle);
				} else {
					outMap.put('creerPersonneRetour_libelle', 'NOK');
				}
				// creerPersonneRetour_type
				if (response.messageRetours.retourTraitementMessage[0].libelle != '') {
					outMap.put('creerPersonneRetour_type', response.messageRetours.retourTraitementMessage[0].type_x);
				} else {
					outMap.put('creerPersonneRetour_type', 'NOK');
				}
			}
			
			// La connexion a réussi et on a un bon message rero
			if ( response != null 
			&& response.creerPersonneOutput != null 
			&& response.creerPersonneOutput.personne != null) {
				outmap.put('idPersonne', response.creerPersonneOutput.personne.idPersonne);
			}
			// La connexion a réussi  
			else {
				outMap.put('idPersonne', '');
			}

			System.debug('**** response ' + response);
			System.debug('**** idPersonne ' + outMap.get('idPersonne'));
			System.debug('**** creerPersonneRetour_code' + outMap.get('creerPersonneRetour_code'));
			System.debug('**** creerPersonneRetour_libelle' + outMap.get('creerPersonneRetour_libelle'));
			System.debug('**** creerPersonneRetour_type' + outMap.get('creerPersonneRetour_type'));
			System.debug('**** connectionOctopus' + outMap.get('connectionOctopus'));
		} catch(Exception e) {
			outMap.put('idPersonne', '');
			outMap.put('connectionOctopus', 'NOK');
			outMap.put('creerPersonneRetour_code', '');
			outMap.put('creerPersonneRetour_libelle', '');
			outMap.put('creerPersonneRetour_type', '');
			//outMap.put('exceptionMessage', e.getMessage());
		}
		System.debug('*** OUT creerPersonneCorrespondance');
	}
	 
	private static String formatPhoneNumber(String phone){
		if(phone != null && phone.length() > 9){
		String phoneNumber='+33' + (phone.substring(phone.length()-9, phone.length()));
		system.debug('****** '+phoneNumber);
		return phoneNumber;
		}
		return '';
	}
    
    
       private void majPersonneAdresse(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        
        
        boolean updateChez = Boolean.valueOf(inputMap.get('updateChez')) ;
		system.debug('updateChez'+updateChez);
		 boolean updateComplement = Boolean.valueOf(inputMap.get('updateComplement')) ;
		system.debug('updateComplement'+updateComplement);
		 boolean updateAdresse = Boolean.valueOf( inputMap.get('updateAdresse')) ;
		system.debug('updateAdresse'+updateAdresse);
        System.debug('idContact'+inputMap.get('ContextId'));
        System.debug('ComplementAdresse'+inputMap.get('ComplementAdresse'));
        System.debug('libelleVoie'+inputMap.get('libelleVoie'));
        System.debug('CodePostal'+inputMap.get('CodePostal'));
        System.debug('Ville'+inputMap.get('Ville'));
        System.debug('NoVoie'+inputMap.get('NoVoie'));
        System.debug('getIdBP'+inputMap.get('getIdBP'));
        
        List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element> canaux = new List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element>();
        
        
        gdfsuezComBefChpPivotV8.contextDt octx = initContext('Smile', '2.0'); 
        
        gdfsuezBefCalypsoPersonneV8.PersonnePort port = buildPortWSPersonne();
        
        gdfsuezBefCalypsoPersonneV8.majPersonneInputDt input = new gdfsuezBefCalypsoPersonneV8.majPersonneInputDt();
        
        input.personne = new gdfsuezComBefCalypsoPersonneV8.Personne();
        input.personne.idPersonne =  (String) inputMap.get('getIdBP') ;
        // Bloc adresse
        gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element aCanal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
        aCanal.adresse = new gdfsuezComBefCalypsoPersonneV8.adresseDt();
        
        if(updateAdresse){
        String noVoie = SM_Adresses_Utilities.formatStringToSAPFormat((String) inputMap.get('NoVoie')) ;
        aCanal.adresse.nVoie =  String.isBlank(noVoie) ? null : noVoie ;
        
        
        String libelleVoie = SM_Adresses_Utilities.formatStringToSAPFormat((String) inputMap.get('libelleVoie')) ;
        aCanal.adresse.libelleVoie = String.isBlank(libelleVoie) ? null :libelleVoie;
        
        String codePostal = SM_Adresses_Utilities.formatStringToSAPFormat((String) inputMap.get('CodePostal')) ;
        aCanal.adresse.CP = String.isBlank(codePostal) ? null  : codePostal ;
        
        
        String ville = SM_Adresses_Utilities.formatStringToSAPFormat((String) inputMap.get('Ville')) ;
        aCanal.adresse.ville = String.isBlank(ville) ? null : ville ; 
		
		}

		 if(updateChez){
        String chez = SM_Adresses_Utilities.formatStringToSAPFormat((String) inputMap.get('chez')) ;
		system.debug('chez'+chez);
        aCanal.adresse.chez = String.isBlank(chez) ? null : chez ; 
		 }


		if(updateComplement){
        if(inputMap.containsKey('ComplementAdresse')){
            String newComplement = (String) inputMap.get('ComplementAdresse');
            // 2 cas de figure : la valeur est remplie OU la valeur vient d'être vidée
            
            // 1 : valeur remplie
            aCanal.adresse.complementAdresse = '.' ;
            if(!String.isBlank(newComplement)){				
                newComplement =  SM_Adresses_Utilities.formatStringToSAPFormat(newComplement);
                if(!String.isBlank(newComplement)){
                    aCanal.adresse.complementAdresse = newComplement ;
                }			
            }
        }
		}
        aCanal.type_x = new gdfsuezComBefChpPivotV8.listeValeursDt();
        aCanal.type_x.code = 'LET';
        
        
        input.personne.correspondance = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_element();
        input.personne.correspondance.canalCommunication = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element[1];
        input.personne.correspondance.canalCommunication[0] = aCanal ;
        
        gdfsuezComBefChpPivotV8.retourTraitementMessagesDt response;
        
        if(!Test.isRunningTest()){
            response  = port.MajPersonne_Http(input,octx);
        } 
        
        if(response != null && response.retourTraitementMessage != null && response.retourTraitementMessage[0] != null){
            outMap.put('majPersonneRet', response.retourTraitementMessage[0].code);
            // On considère qu'un code retour différent de OCTOPUS_MAJPersonne_01 mais avec un type = 'Information' est OK
            String respCode = response.retourTraitementMessage[0].code;
            String typeErr = response.retourTraitementMessage[0].type_x;
            
            // On ne lance la MAJ Salesforce que si celle Octopus a marché
            if(respCode  == 'OCTOPUS_MAJPersonne_01' || typeErr == 'Information'){
                
                
                Map<String,Object> ElementsToSerialize = new Map<String,Object>() ;
                ElementsToSerialize.put( 'idContact',(String)inputMap.get('ContextId')) ;	
                ElementsToSerialize.put( 'No_Voie__c',aCanal.adresse.nVoie) ;		
                ElementsToSerialize.put( 'MailingStreet', aCanal.adresse.libelleVoie ) ;		
                ElementsToSerialize.put( 'MailingPostalCode', aCanal.adresse.CP) ;		
                ElementsToSerialize.put( 'MailingCity', aCanal.adresse.ville) ;
                ElementsToSerialize.put( 'Complement_adresse__c', aCanal.adresse.complementAdresse) ;
				ElementsToSerialize.put( 'Chez', aCanal.adresse.chez) ;
				
                
                string jsonString = JSON.serializePretty(ElementsToSerialize);	
                updateCaseAsych(jsonString);
                
            } else{
                throw new CustomizedException('Erreur lors de la mise à jour de la fiche client. : '+response.retourTraitementMessage[0].libelle) ;
            }
            system.debug('test '+respCode) ;
        }
    }
    @future
    public static void updateCaseAsych(String elements){
        
        try{
            
            Map<String,Object> wrapper = (Map<String,Object>) SYSTEM.JSON.deserializeUntyped(elements);
            String idContact = (String) wrapper.get('idContact') ;
            String  No_Voie = (String) wrapper.get( 'No_Voie__c');
            String  MailingStreet = (String) wrapper.get( 'MailingStreet');
            String  MailingPostalCode = (String) wrapper.get( 'MailingPostalCode');
            String  MailingCity = (String) wrapper.get( 'MailingCity');
            String  Complement_adresse = (String) wrapper.get( 'Complement_adresse__c');
			String  chez = (String) wrapper.get( 'Chez');
			
            
            
            
            if(idContact== null) {
                system.debug(' no id contact...');
                return;
            }
            
            
            Contact aContact = [SELECT Id, Identifiant_Buisness_Partener__c, Complement_adresse__c, Refus_Email__c, Refus_Fixe__c, Refus_Mobile__c, Adresse_Mail_2__c, Adresse_Mail_3__c, Adresse_Mail_Principale__c, Email, Mobile_2__c, Mobile_3__c, Mobile_Principal__c, MobilePhone, MobilePrincipalValue__c, Phone, Tel_fixe_2__c, Tel_fixe_3__c, Tel_Fixe_Principal__c FROM Contact WHERE Id = :idContact];
            
            
            if(!String.isBlank(No_Voie))
            aContact.No_Voie__c = No_Voie;
		    if(!String.isBlank(MailingStreet))
            aContact.MailingStreet = MailingStreet;
			if(!String.isBlank(MailingPostalCode))
            aContact.MailingPostalCode = MailingPostalCode;
			if(!String.isBlank(MailingCity))
            aContact.MailingCity = MailingCity;
			if(!String.isBlank(Complement_adresse))
            aContact.Complement_adresse__c = Complement_adresse;
			if(!String.isBlank(chez))
			aContact.Chez__c = chez ;
            
            
            Database.SaveResult updateResult = Database.update(aContact, false);
            System.debug('**** MAJ Contact SF : ' + updateResult.isSuccess());
            
        }catch(Exception e){
            System.debug('error occured: '+e.getMessage()) ;
            System.debug('error occured: '+e.getStackTraceString()) ;
        }
        
        
    }
    
    
    
    public class CustomizedException extends  Exception{
        
    }
    
    
    
}