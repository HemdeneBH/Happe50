/**
 * @File Name          : HP_PersonneController.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda







 * @Last Modified On   : 03-25-2022












 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/12/2019   Mohamed Aamer     Initial Version
**/
public with sharing class HP_PersonneController {
    @AuraEnabled(cacheable=true)
	public static String ecrirePersonne(String infosPersonneJson) {
		String infosToSend = JSON.serialize((Object)JSON.deserializeUntyped(infosPersonneJson));
		String idXdataPersonne = HP_PersonneService.ecrirePersonne(infosToSend);
		return idXdataPersonne;
	}

	@AuraEnabled(cacheable=true)
	public static Map<String, Object> loadPersonne(String personneId) {
		return HP_PersonneService.loadPersonne(personneId);
	}

	/**
    * @description charger les doublons
    * @author Slimene Belhaj Ali | 20/01/2020
    * @return list de contact 
    **/
	@AuraEnabled(cacheable=true)
	public static List<Contact> loadContactDoublonsList(Map<String,Object> currentContact) {
		return HP_PersonneService.loadContactDoublonsList(currentContact);
	}

	@AuraEnabled
	public static String mergeClientWithConsentement(Map<String, Object> client, String indicateur, List<Map<String, Object>> concentementList) {


		for (String key : client.keySet()) {
			System.debug('*****key : ' + key);
			System.debug('*******value : ' + client.get(key));
		}
		String idcont = null;
		String idXdataPersonne = null;
		Map<String, Object> clientToPersist = new Map<String, Object>();
		for (String key : client.keySet()) {
			if( !'numeroEtranger'.equals(key) ){
				clientToPersist.put(key,client.get(key));
			}
		}
		if(clientToPersist.get('id') != null) {
			idcont = (String)clientToPersist.get('id');
			clientToPersist.remove('id');
			idXdataPersonne = String.valueOf([select Id_Tiers__c from Contact where Id = :idcont].Id_Tiers__c);
			System.debug('@@@ idXdataPersonne : '+idXdataPersonne);
			Integer result = HP_CALL001_XDATA.updatePersonne(idXdataPersonne, JSON.serialize(clientToPersist));
			System.debug('@@@ result : '+result);
		} else {
			idXdataPersonne = HP_PersonneService.ecrirePersonne(JSON.serialize(clientToPersist));

		}

		for(Map<String, Object> item : concentementList) {
			item.put('idPersonne' , Integer.valueOf(idXdataPersonne));
		}
		System.debug('@@@ concentementList : '+concentementList);
		HP_CALL001_XDATA.sendConsentResponses(JSON.serialize(concentementList));
		String mp = (String)client.get('numeroMobile');
		if(mp != null && mp .length() == 10) {
			mp = '+33' + mp.substring(1);
		}

		String p = (String)client.get('numeroFixe');
		if(p != null && p.length() == 10) {
			p = '+33' + p.substring(1);
		}
		Contact cont = new Contact(firstName = (String)client.get('prenom'),
		lastName = (String)client.get('nom'),
		Salutation = (String)client.get('civilite'),
		Phone = p,
		Email = (String)client.get('email'),
		No_Voie__c = (String)client.get('numVoie'),
		MailingStreet = (String)client.get('voie'),
		MailingPostalCode = (String)client.get('codePostal'),
		MailingCity = (String)client.get('ville'),
		Complement_adresse__c = (String)client.get('complementAdresse'),
		Id_Tiers__c = Integer.valueOf(idXdataPersonne),

		HP_Numero_etranger__c = (String)client.get('numeroEtranger'),
		HP_StopEmail__c= (Boolean)client.get('stopEmail'),
		HP_StopSMS__c = (Boolean)client.get('stopSms'),
		HP_OptinMarketing__c = (Boolean)client.get('optinMarketing'),
		MobilePhone = mp);




		if(idcont != null) {
			cont.Id = idcont;


		}
		upsert cont;
        return cont.Id;
    }
	

		/**
    * @description charger les doublons
    * @author Ali AJELLAL | 15/03/2021
    * @return xdata id, nom, prénom et email
    **/
	@AuraEnabled(cacheable=true)
	public static List<Map<String, Object>>   getPersonneXdataId(String email) {
		return  HP_PersonneService.getPersonneXdataId(email);
	}
}