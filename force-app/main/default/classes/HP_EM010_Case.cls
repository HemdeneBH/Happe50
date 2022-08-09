/**
 * @File Name          : HP_EM010_Case.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : Badr Eddine Belkarchi




 * @Last Modified On   : 02-17-2022







 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    16/01/2020   Vincent Albiser     Initial Version
 **/
public with sharing class HP_EM010_Case {

	public static Case createCaseFromAPI(Id contactId, String context, String description, String firstname, String lastname, String email, Id souscription, 
							Id portefeuilleContratId, Id contratId, String pdl, String energie, Boolean clientAide){

		Case c = new Case();
		c.ContactId = contactId;
		c.Description = !String.isBlank(description) && description.length() > 32000 ? description.substring(0,31999) : description;
		switch on context {
            when 'Case offline' {
				c.SuppliedEmail = email;
				c.SuppliedName = firstname + ' ' + lastname;
				c.Origin = 'Chat';
				c.Subject = 'Chat indisponible';
				c.Reason = 'HP_Recontact_Customer';
				c.HP_Type__c = 'HP_ChatIndispo';
				c.RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_CaseRecontact');
				insert c;
			}
			when 'Consentement' { 
				c.Origin = 'Web';
				c.Subject = 'Enregistrements consentements Xdata KO'; 
				c.Reason = 'HP_EnrolmentError';
				c.HP_Type__c = 'HP_ConsentementsDigital';
				c.RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_ContractErrorSave3');
				insert c;
			}
			when 'Anomalie creation xdata Save2' {
				c.Origin = 'Web';
				c.Reason = 'Error souscription';
				c.Subject = 'Erreur souscription : création PDL/coordonnéesBC dans Xdata';
				c.HP_Type__c = 'HP_XDATA_ANOMALIE';
				c.RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_EnrolmentCase');
				c.Status = 'TO_DO';
				c.HP_Souscription__c = souscription;
				c.HP_TECH_ExternalId__c = HP_ExternalIdUtils.createExternalKey(souscription, 'HP_EnrolmentCase');
				Id queueNiveau3Id = HP_Util_QueueManager.getQueueIdByName('HP_Niveau_3');
				if(queueNiveau3Id != null){
					c.OwnerId = queueNiveau3Id;
				}
				Database.upsert(c, Case.Fields.HP_TECH_ExternalId__c);
			}
			when 'Coupure_ReductionPuissance' { 
				c.Origin = 'HP_BILLING';
				c.ContactId = contactId;
				c.Portefeuille_Contrat_Happe__c = portefeuilleContratId;
				c.HP_Contrat__c = contratId;
				c.HP_PDL_PCE__c = pdl;
				c.RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_Facturation');
				c.HP_Type__c = 'HP_Coupure_ReductionPuissance';
				c.Status = 'NEW_CASE';
				c.OwnerId = HP_UTIL_QueueManager.getQueueIdByName('HP_Niveau_1');
				c.HP_Energy__c = energie;
				c.Priority = 'High';
				c.HP_Client_Aide__c = clientAide;
				insert c;
			}
        }

		// upsert c  ;
		return c;
	}


	/**
	 * @description retourne les cases Prestations GRD du contrat
	 * @author Vincent Albiser | 16/01/2020
	 * @param Decimal xDataContractId
	 * @return List<Case>
	 **/
	public static List<Case> getContratCasesPrestation(Integer xDataContractId){
		Id recordTypePrestationId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_PrestationDistributeur');
		List<Case> caseList = [ SELECT
					Id
					FROM Case
					WHERE HP_Contrat__r.HP_Contrat_XdataId__c = :xDataContractId
										    AND RecordTypeId = :recordTypePrestationId];

		return caseList;
	}

	/**
	* @description 
	* @author Antoine Latour | 12-11-2020 
	* @param Id caseId 
	* @return Case 
	**/
	public static Case getMailCaseByCaseId(Id caseId){
		try {
			Id recordTypePrestationId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Mail');
			List<Case> caseList = [ SELECT
					Id, HP_isSentMediatech__c, ContactMobile
					FROM Case
					WHERE Id  = :caseId
											AND RecordTypeId = :recordTypePrestationId LIMIT 1];
			return caseList[0];
		} catch (Exception e) {
			return null;
		}
	}


	/**
	* @description 
	* @author Antoine Latour | 12-11-2020 
	* @param Id caseId 
	* @return List<Case> 
	**/
	public static List<Case> loadCase(Id caseId){
		return [select Id,OwnerId,IsClosed, HP_DateReponseEmailConseiller__c, HP_isHappe__c, HP_TECH_ExternalId__c , HP_Energy__c, Description, ContactId, HP_Souscription__r.HP_Souscription_Digital_Id__c, Etat_du_Case__c from case where Id = : caseId];
	}


	/**
	* @description 
	* @author Antoine Latour | 12-11-2020 
	* @param HP_Souscription__c souscription 
	* @return List<Case> 
	**/
	public static List<Case> getEnrolmentCases(HP_Souscription__c souscription){
		Id recordTypeCaseId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_EnrolmentCase');
		List<Case> caseList = [ SELECT
					Id, HP_TECH_ExternalId__c 
					FROM Case
					WHERE HP_Souscription__c = :souscription.Id
											AND RecordTypeId = :recordTypeCaseId];
		return caseList;
	}
	
	/**
	* @description 
	* @author Antoine Latour | 12-11-2020 
	* @param Integer xdataId 
	* @param Decimal indexElec 
	* @param decimal indexElecHC 
	* @param Decimal indexGaz 
	* @param HP_WRP022_SFResponse response 
	**/
	public static void updateCaseResiliationIndex(Integer xdataId, Decimal indexElec, decimal indexElecHC, Decimal indexGaz, HP_WRP022_SFResponse response) {
		List<Case> caseList = [select Id from Case where HP_Contrat__r.HP_Contrat_XdataId__c =:xdataId and RecordType.DeveloperName = 'HP_ContractCancelationCase'];
		if(caseList.size() == 0) {
			response.code = HP_HttpStatus.BAD_REQUEST;
			response.addError( 'EM010-1', 'Case resiliation doesn\'t exist');
			return;
		}
		Case acase = caseList.get(0);
		acase.HP_index_gaz__c = indexGaz;
		if(indexElecHC == null) {
			acase.HP_index_elec_base__c = indexElec;
		}

		if(indexElecHC != null) {
			acase.HP_index_elec_hp__c = indexElec;
			acase.HP_index_elec_hc__c = indexElecHC;
		}

		update acase;
		response.addInfo( 'EM010-2', 'Case index updated');
	}
	
	/**
	* @description 
	* @author Antoine Latour | 12-11-2020 
	* @param String contactId 
	* @return List<Case> 
	**/
	public static List<Case> loadReclamationCase(String contactId) {
		return [select Id,CaseNumber, toLabel(HP_Motif__c), HP_Numero_de_facture__c, toLabel(Status), 

		Priority, toLabel(HP_Type__c), createdDate, IsClosed from case 

		where contactId = :contactId and recordtype.developerName = 'HP_Mediation_Reclamation'];
	}
	

	/**
	* @description 
	* @author Antoine Latour | 12-11-2020 
	* @param HP_Souscription__c souscription 
	**/
public static void updateXDATAAnomaliesCase(HP_Souscription__c souscription) {
		List<Case> caseList = [ SELECT Id 
			FROM Case 
			WHERE HP_Souscription__c = :souscription.Id AND HP_Type__c = 'HP_XDATA_ANOMALIE' AND Status != 'CLOSED'];

		for(Case c : caseList) {
			c.Status = 'CLOSED';
		}

		if(!caseList.isEmpty())
			Database.update(caseList);
	}

	/**
	* @description 
	* @author Antoine Latour | 12-11-2020 
	* @param Set<Id> idSet 
	* @return Map<Id, Case> 
	**/
	public static Map<Id,Case> createCaseMap(Set<Id> idSet) {
		List<Case> caseList = [select Id, BusinessHoursId,OwnerId, HP_Type__c,HP_Sous_Type__c,HP_Canal__c,Priority,Subject,Origin,RecordType.DeveloperName from Case where Id in : idSet];






		if(caseList.size() > 0) {
            Map<Id,Case> resultMap = new Map<Id,Case>();
            for(Case acase : caseList) {
                resultMap.put(acase.Id, acase);
			}
			return resultMap;
        }
        return null;
	}






	/**
	* @description 
	* @author Antoine Latour | 12-11-2020 
	* @param Map<Id Case> caseMap 
	* @return Map<Id, String> 
	**/
	public static Map<Id, String> getCaseOwnerDeveloperName(Map<Id, Case> caseMap) {
		Map<Id, String> result = new Map<Id, String>();
		Map<Id, Group> mapGroup = HP_Util_QueueManager.getQueueMapById();

		for(Case acase : caseMap.values()) {
			if(mapGroup.containsKey(acase.OwnerId)) {
				result.put(acase.Id, mapGroup.get(acase.OwnerId).DeveloperName);
			}
			else {
				result.put(acase.Id, '');
			}
		}

		return result;
    }

	/**
	* @description 
	* @author Antoine Latour | 12-11-2020 
	* @param Case acase 
	* @return Case 
	**/
	public static Case caseBuilder(Case acase, Id rtId) {
		System.debug('RecordType : ' + rtId);
        Schema.DescribeSObjectResult objetDescr = Schema.SObjectType.Case; 
		Map<Id,Schema.RecordTypeInfo> rtMapById = objetDescr.getRecordTypeInfosById();
        
        switch on rtMapById.get(rtId).getDeveloperName() {
			when 'HP_Chat' {
				acase.Origin = 'Chat';
				acase.Priority = 'Medium';
				acase.Reason = 'Demande Client';
				acase.Status = 'TO_DO';
			}
		}

		return acase;
	}

	/**
	* @description 
	* @author Antoine Latour | 12-11-2020 
	* @param Case acase 
	* @return Case 
	**/
	public static Case escalade(Case acase, Map<String, Id> queueMap) {
		switch on acase.HP_QueueCible__c {
			when 'Niveau 1' {
				acase.Status = 'TO_DO';
				acase.OwnerId = queueMap.get('HP_Niveau_1');
			}
			when 'Niveau 2' {
				String profilName = HP_UTIL_ProfileManager.getCurrentUserProfileName();
				if(profilName.startsWith('HP_Conseiller Niveau 1')) {
					acase.Status = 'Escaladé (happe)';
				}
				else if('HP_Conseiller Niveau 3'.equals(profilName)) {
					acase.Status = 'TO_DO';
				}
				
				acase.OwnerId = queueMap.get('HP_Niveau_2');
			}
			when 'Niveau 3' {
				acase.OwnerId = queueMap.get('HP_Niveau_3');
				acase.Status = 'Escaladé (happe)';
			}
		}
		acase.HP_QueueCible__c = null;
		return acase;
	}

	/**
	* @description 
	* @author Antoine Latour | 12-11-2020 
	* @param Case acase 
	* @return Case 
	**/
	public static List<Case> loadCases(Set<String> subjectSet, Set<String> descriptionSet, Set<String> contactSet, Set<String> emailSet, String rtEmailId) {
		return [SELECT Id, ContactId, Status, Description, Subject, CreatedDate, SuppliedEmail, HP_isHappe__c 
		FROM Case 
		WHERE HP_isHappe__c = True 
		AND RecordTypeId = :rtEmailId
		AND IsClosed = false
		AND ( ContactId in :contactSet OR SuppliedEmail in :emailSet )
		AND ( Subject in : subjectSet)];
	}


	/**
	* @description 
	* @author Antoine Latour | 09-04-2021 
	* @param Map<Id List<Case>> mapListCaseByNewOwner 
	**/
	public static void reaffectCaseToOwner(Map<Id, List<Case>> mapListCaseByNewOwner) {
		List<Case> caseToUpdate = new List<Case>();
		for(Id key : mapListCaseByNewOwner.keySet()) {
			List<Case> caseList = mapListCaseByNewOwner.get(key);
			for(Case c : caseList) {
				c.OwnerId = key;
				caseToUpdate.add(c);
			}
		}




		if(caseToUpdate.size() > 0) Database.update(caseToUpdate);
	}

	/**
	* @description 
	* @author Antoine Latour | 09-04-2021 
	* @param Id rappelRecordTypeId 
	* @param Id souscriptionId 
	* @return Case 
	**/
	public static Case createRappelCaseForSouscription(Id rappelRecordTypeId, Id souscriptionId, Id contactId) {


		Case c = new Case();
		c.HP_Type__c = 'HP_RappelLeadNonSigne';
		c.RecordTypeId = rappelRecordTypeId;
		c.HP_TreatmentDate__c = Date.today();
		c.HP_Souscription__c = souscriptionId;
		c.ContactId = contactId;

		return c;



	}

	/**
	* @description 
	* @author Antoine Latour | 09-04-2021 
	**/

	public static void cancelCases(List<Case> casesList){
		for(Case aCase : casesList) {
			aCase.Status = 'CANCELED';
		}
		Database.update(casesList);
	}

	/**
	* @description 
	* @author Antoine Latour | 09-04-2021 
	**/

	public static void closeCases(List<Case> casesList){
		for(Case aCase : casesList) {
			aCase.Status = 'CLOSED';
		}
		Database.update(casesList);
	}
    
    	/**
	* @description 
	* @author Antoine Latour | 04-10-2021
	* @param Id caseId 
	* @return Case 
	**/
	public static Case getTelephoneCaseByCaseId(Id caseId){
		try {
			Id recordTypePrestationId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone');
			List<Case> caseList = [ SELECT
					Id, HP_isSentMediatech__c, ContactMobile
					FROM Case
					WHERE Id  = :caseId
					AND RecordTypeId = :recordTypePrestationId LIMIT 1];
			return caseList[0];
		} catch (Exception e) {
			return null;
		}
	}
}