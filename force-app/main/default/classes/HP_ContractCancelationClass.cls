/**
 * @File Name          : HP_ContractCancelationClass.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 08-17-2020
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    13/12/2019   mouhamadoune.coulybaly@external.engie.com     Initial Version
**/

public with sharing class HP_ContractCancelationClass {

	@AuraEnabled public String assetId {get;set;}
	@AuraEnabled public String assetName {get;set;}
	@AuraEnabled public String productName {get; set;}
	@AuraEnabled public String contractNumber{get; set;}
	@AuraEnabled public String status {get; set;}
	@AuraEnabled public String pdl{get; set;}
	@AuraEnabled public String pce {get; set;}
	@AuraEnabled public String businessNumber {get; set;}
	@AuraEnabled public String xdataExternalId {get; set;}

	public static final Integer PRESTATION_ALREADY_EXISTS = 2;
	public static final Integer ALL_IS_OK = 1;
	public static final String ELECTRICITY = 'Electricity';
	public static final String ELEC = 'Elec';
	public static final String GAZ ='gaz';
	public static final String GAS ='Gas';
	public static final String SF21 = 'SF21';
	public static final String CONFIRM = 'Confirmation demande résiliation';
	public static final String INDEX_RESIL = 'indexresile';

	@AuraEnabled
	public static Object getCancelationCase( Decimal idContract){
		List<Case> cases = HP_SLCT_Case.getCancelationCase(idContract);
		if(!cases.isEmpty()){
			return (Object)JSON.deserializeUntyped(JSON.serialize(cases.get(0)));
		}
		else{
			return null;
		}
	}

	@AuraEnabled
	public static Integer createPrestation(Date prestationDate, String businessNumber, String caseId, String caseSourceStr, String pdlPce, Decimal idContract, Decimal contactId, String energy, Decimal indexHP, Decimal indexHC, Decimal indexEnergy, Decimal indexGas,
	String codeStatutContratCRM,String statutContrat) {
		Id caserRecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_ContractCancelationCase');
		String energyType = '';
		energy = (energy.equals(GAZ))? GAS:ELECTRICITY;
		String energie = (energy.equals(GAS))?'gaz':'electricite'; // Electricité ou Gaz
		energyType = (energy.equals(GAS))?'Gaz':ELEC;
		Integer verifyDuplicateValue = 0;
		if(!HP_EM007_PrestationDistributeurManager.isExistBussinessNum(businessNumber, pdlPce)){
			verifyDuplicateValue = PRESTATION_ALREADY_EXISTS;
		}

		else{
			Boolean isIndexKnown = (indexGas!= null || indexHC != null || indexHP!= null);
			String indexResil = isIndexKnown == true?'true':'false';
			Contact contact = [SELECT Id_Tiers__c, Email, firstname,  lastname, title FROM Contact WHERE Id_Tiers__c =:contactId][0];
			if(caseId == null){
				Case caseCancellation = scheduleCase(contactId, caserRecordTypeId, caseSourceStr, energy, indexEnergy,indexHC, indexGas, idContract, HP_SLCT_Case.Status.CLOSED.name(), Date.today(), prestationDate);
				managePrestationAndNotify(contactId, prestationDate, businessNumber, caseCancellation.Id, pdlPce, idContract, energyType, energie, indexResil);
				verifyDuplicateValue = ALL_IS_OK;
			}
			else {
				Case caseToSchedule = new Case(id = caseId, Status = HP_SLCT_Case.Status.CLOSED.name());
				update caseToSchedule;
				managePrestationAndNotify(contactId, prestationDate, businessNumber, caseId, pdlPce, idContract, energyType, energie, indexResil);
				verifyDuplicateValue = ALL_IS_OK;
			}
		}
	return verifyDuplicateValue;
	}

	/**
	* @description: Gere la creation des prestation et les notification ainsi que l'envoi des mails
	* @author Colince FOTSO | 21/01/2020
	* @param Decimal contactId
	* @param Date prestationDate
	* @param String businessNumber
	* @param String caseId
	* @param String pdlPce
	* @param Decimal idContract
	* @param String energyType
	* @param String energie
	* @param String indexResil
	* @return void
	**/
	public static void managePrestationAndNotify(Decimal contactId, Date prestationDate, String businessNumber, String caseId, String pdlPce, Decimal idContract, String energyType, String energie, String indexResil){
		Contact contact = [SELECT Id_Tiers__c, Email, firstname,  lastname, salutation FROM Contact WHERE Id_Tiers__c =:contactId][0];
		if(contact!=null){
		System.debug('@@@@@Befor Presta');
		createPrestation(prestationDate, businessNumber, caseId, pdlPce,energyType,contact.Id);
		System.debug('@@@@@After Presta');
		
		HP_SM010_SendMailWhenCancellation.sendMailViaCabestanAsync(
					contact.email,
					String.valueOf(contact.Id_Tiers__c),
					contact.salutation,
					contact.lastname,
					contact.firstname,
					energie,
					SF21,
					CONFIRM,
					INDEX_RESIL,
					indexResil
				);
		}
	}

	private static String getResilationDate(Integer contractid, Date prestationDate) {
		if(prestationDate != null) {
			DateTime currentDate = prestationDate;
			return currentDate.format('dd/MM/yyyy');
		}
		String exId = 'CONTRACT_CANCELATION/' + contractid;
		List<Case> caseList = [select HP_EffectiveDate__c from Case where HP_TECH_ExternalId__c = :exId and HP_EffectiveDate__c != null];
		DateTime currentDate =  System.now();
		if(caseList.size() > 0) {
			currentDate = caseList.get(0).HP_EffectiveDate__c;
		}
		return currentDate.format('dd/MM/yyyy');
	}

	@AuraEnabled
	public static Integer scheduleCancelationCase(Decimal contactId, String caseId, Date threatmentDate, Decimal indexHP, Decimal indexHC, Decimal indexGas, String caseSourceStr,String energy,Decimal indexEnergy, Decimal idContract, String assetId,Date resilDate){
		System.debug('@@@ caseSourceStr ' + caseSourceStr);
		HP_Contrat__c HP_Contrat = null;
		try{
			HP_Contrat = HP_EM023_Contrat.loadContratByXdataId(idContract.intValue());
		} catch(Exception e) {
		/*	HP_Contrat = new HP_Contrat__c();
			HP_Contrat.HP_Contrat_XdataId__c = idContract.intValue();
			HP_Contrat.HP_Type_de_Compteur__c = (energy == 'gaz' ? 'GAS' : 'ELEC');
			insert HP_Contrat;*/
		}
		
		Id caseRecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_ContractCancelationCase');
		Integer verifyDuplicateValue = 0;
		if(caseId == null){
			String Hp_Tech_ExternalId = HP_CancelationCaseUtils.buildCaseExternalId((Integer)idContract);
			energy = (energy.equals(GAZ))? GAS:ELECTRICITY;
			Case caseCancellation = scheduleCase(contactId, caseRecordTypeId, caseSourceStr, energy, indexEnergy,indexHC, indexGas, idContract, HP_SLCT_Case.Status.TO_DO.name(), threatmentDate, resilDate);
			verifyDuplicateValue = ALL_IS_OK;
		}
		else{
			Case caseToSchedule = new Case(id = caseId, HP_TreatmentDate__c = threatmentDate, 	HP_EffectiveDate__c = resilDate, Status = 'TO_DO', HP_Contrat__c = HP_Contrat == null ? null : HP_Contrat.Id);
			checkEnergyType(caseToSchedule,energy,indexEnergy,indexHC);
			update caseToSchedule;
			verifyDuplicateValue = ALL_IS_OK;
		}
		return verifyDuplicateValue;
	}

	public static void createPrestation(Date prestationDate, String businessNumber, String caseId, String pdlPce, String energyType,Id contactId){
		Id prestationRecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Prestation_distributeur__c', 'HP_PrestationDistributeur');
		Prestation_distributeur__c prestation = new Prestation_distributeur__c();
			prestation.Contact__c = contactId;
			prestation.RecordTypeId = prestationRecordTypeId;
			prestation.Name = businessNumber;
			prestation.Numero_affaire_distributeur__c = businessNumber;
			if(prestationDate != null){
				prestation.Date_de_prestation__c = prestationDate;
			}
			prestation.Case__c = caseId;
			prestation.Type_OPS__c ='Recollement';
			prestation.Statut__c =	'En cours';
			prestation.Situation_de_vente__c = 'Resiliation';
			prestation.Numero_PDL_PCE__c = pdlPce;
			prestation.Secteur_activite__c = energyType;

		insert prestation;
	}

	public static Case scheduleCase(Decimal contactId, String caseRecordTypeid, String caseSourceStr, String energy, Decimal indexEnergy, Decimal indexHC, Decimal indexGas, Decimal idContract, String status, Date threatmentDate, 	Date resilDate){
		HP_Contrat__c HP_Contrat = null;
		try {
			HP_Contrat = HP_EM023_Contrat.loadContratByXdataId(idContract.intValue());
		} catch(Exception e) {
			/*HP_Porte_Feuille_Contrat__c ptf = new HP_Porte_Feuille_Contrat__c();
			HP_Contrat = new HP_Contrat__c();
			HP_Contrat.HP_Contrat_XdataId__c = idContract.intValue();
			HP_Contrat.HP_Souscription_Digital_Id__c = 'K'+System.now().getTime(); 
			HP_Contrat.HP_Type_de_Compteur__c = (energy == 'gaz' ? 'GAS' : 'ELEC');
			//insert HP_Contrat;*/
		}
		
		String Hp_Tech_ExternalId = HP_CancelationCaseUtils.buildCaseExternalId((Integer)idContract);
		Contact contact = [SELECT Id_Tiers__c FROM Contact WHERE Id_Tiers__c =:contactId][0];
		Boolean shouldntDoAgilabTreatment = status == 'CLOSED';
		Case casePresta = new Case(
			HP_Source__c = caseSourceStr,
			HP_TECH_ExternalId__c = HP_CancelationCaseUtils.buildCaseExternalId((Integer)idContract),
			Contact = new Contact(Id_Tiers__c = contact.Id_Tiers__c),
			Status = status,
			RecordTypeId = caseRecordTypeid,


			HP_Type__c = 'CONTRACT_CANCELATION',
			HP_Energy__c = energy,
			Origin = 'HP_CRM',
			HP_EffectiveDate__c = resilDate,
			HP_TreatmentDate__c = threatmentDate,
			HP_Contrat__c = HP_Contrat == null? null : HP_Contrat.Id,
			HP_ResiliationAgilabTraitement__c = shouldntDoAgilabTreatment,
			HP_ResiliationModifierStatutAgilab__c=false,
			HP_ResiliationModifierStatutXdata__c=false
		);
		checkEnergyType(casePresta,energy,indexEnergy,indexHC);

		Database.upsert(casePresta, Case.Fields.HP_TECH_ExternalId__c);

		return casePresta;
	}

	public static void checkEnergyType(Case caseR, String energy, Decimal indexEnergy, Decimal indexHC) {
		System.debug('@@@@ energy ' +energy);
		System.debug('@@@@ indexEnergy ' +indexEnergy);
		System.debug('@@@@ indexHC ' +indexHC);
		if (energy == 'gaz' || energy == 'gas') {
			caseR.HP_index_gaz__c = indexEnergy;
			caseR.HP_index_elec_base__c = null;
		} else {
			if (indexHC != null) {
				caseR.HP_index_elec_hp__c = indexEnergy;
				caseR.HP_index_elec_hc__c = indexHC;
				caseR.HP_index_elec_base__c = null;
				caseR.HP_index_gaz__c = null;
			} else {
				caseR.HP_index_elec_base__c = indexEnergy;
				caseR.HP_index_elec_hc__c = null;
				caseR.HP_index_elec_hp__c = null;
			}
		}
	}

}