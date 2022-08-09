/**
 * @File Name          : HP_EM020_Contact.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : Hemdene Ben Hammouda

 * @Last Modified On   : 09-20-2021

 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    24/01/2020   Mohamed Aamer     Initial Version
 **/
public with sharing class HP_EM020_Contact {

	public static Contact getContactByMail(String mail) {
		try {
			List<Contact> contactList = [
				SELECT Id 
				FROM Contact
				WHERE Email = :mail
			];
			return !contactList.isEmpty() && contactList.size() == 1 ? contactList[0] : null;
		} catch (Exception e) {
			return null;
		}
	}

	public static Contact getContactByXdataId(Integer clientXdataId) {
		try {
			List<Contact> contactList = [
				SELECT id, Id_Tiers__c
				FROM Contact
				WHERE Id_Tiers__c = : clientXdataId
							      LIMIT 1
			];
			return contactList[0];
		} catch (Exception e) {
			return null;
		}
	}


	/**
	* @description Dernière modification : HAPP-1770
	* @author Antoine Latour | 17-05-2021 
	* @param HP_EnrolmentRestResourceModel.SecondSave_v0_1 selfcare 
	* @param HP_Souscription__c souscription 
	* @return List<Contact> 
	**/
	public static List<Contact> insertContact(HP_EnrolmentRestResourceModel.SecondSave_v0_1 selfcare, HP_Souscription__c souscription) {

		Boolean hasCoContractant = selfcare.secondContractHolder != null && selfcare.secondContractHolder == true;
		List<Contact> contactList = new List<Contact>();
		
			Contact contractant = new Contact();
			contractant.HP_IsHappe__c = true;
			contractant.Id_Tiers__c = selfcare.xDataId;

		
		if(!String.isBlank(selfcare.salutation.name())) contractant.Salutation = selfcare.salutation.name();
		if(!String.isBlank(selfcare.lastName)) contractant.lastName = selfcare.lastName;
		if(!String.isBlank(selfcare.firstName)) contractant.firstName = selfcare.firstName;
		if(!String.isBlank(selfcare.email)) contractant.email = selfcare.email;
		if(!String.isBlank(selfcare.mobilePhone)) contractant.mobilePhone = ((selfcare.mobilePhone.replaceAll(' ', '').length() == 10) ? ('+33' + selfcare.mobilePhone.replaceAll(' ', '').subString(1)) : selfcare.mobilePhone.replaceAll(' ', ''));
		if(!String.isBlank(selfcare.homePhone)) contractant.Phone = ((selfcare.homePhone.replaceAll(' ', '').length() == 10) ? ('+33' + selfcare.homePhone.replaceAll(' ', '').subString(1)) : selfcare.homePhone.replaceAll(' ', ''));


			contractant.No_Voie__c = souscription.HP_Numero_de_voie_facturation__c;
			contractant.MailingStreet = souscription.HP_Nom_de_rue_facturation__c;
			contractant.MailingPostalCode = souscription.HP_Code_postal_facturation__c;
			contractant.Complement_adresse__c = souscription.HP_Complement_d_adresse_facturation__c;
			contractant.MailingCity = souscription.HP_Nom_de_ville_facturation__c;
			contactList.add(contractant);
			Database.upsert(contractant,Contact.Fields.Id_Tiers__c);
		
		List<Contact> cocontractantList = null;
		Contact cocontractant = new Contact();
	
		if(selfcare.secondContractHolderXDataId != null) {
			cocontractantList = HP_EM020_Contact.loadSMContactList(selfcare.secondContractHolderXDataId);
		}
		if(hasCoContractant && cocontractantList != null && cocontractantList.size() > 0) {
			cocontractant = cocontractantList[0];
			cocontractant.HP_IsHappe__c = true;
			update cocontractant;
			contactList.add(cocontractant);
		}else if(hasCoContractant) {

            if(souscription.HP_CoContractant__r.Id != null && selfcare.secondContractHolderXDataId == null){
                cocontractant.id = souscription.HP_CoContractant__r.Id;
            }
			cocontractant.Salutation = selfcare.secondContractHolderSalutation.name();
			cocontractant.lastName = selfcare.secondContractHolderLastName;
			cocontractant.firstName = selfcare.secondContractHolderFirstName;
			cocontractant.email = selfcare.secondContractHolderEmail;
			
			if(selfcare.secondContractHolderXDataId != null) {
				cocontractant.Id_Tiers__c = selfcare.secondContractHolderXDataId;
				Database.upsert(cocontractant,Contact.Fields.Id_Tiers__c);

			} else {
            Database.upsert(cocontractant);
			}
			contactList.add(cocontractant);
		}

		souscription.HP_Contact__c = contactList[0].Id;
		if(hasCoContractant) {
			souscription.HP_CoContractant__c = contactList[1].Id;
		}

		return contactList;
	}

    @AuraEnabled(cacheable=false)
	public static Contact loadContact(Id contactId){


		return [select Id, salutation, lastName, firstName, Id_Tiers__c, No_Voie__c,phone,HP_Indicatif__c,MailingStreet,
		MailingCity,MailingPostalCode,Complement_adresse__c,HP_Numero_etranger__c,
		 email, mobilephone,HP_OptinMarketing__c,HP_StopEmail__c,HP_StopSMS__c,HP_Shared_URL__c from contact where Id = : contactId];
	}



	public static List<Contact> loadSMContactList(Integer xdataId){
		return [select Id, salutation, lastName, firstName, Id_Tiers__c, No_Voie__c, email, mobilephone from contact where ID_Tiers__c = : xdataId AND HP_isHappe__c = false];
	}
}