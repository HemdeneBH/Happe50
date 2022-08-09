/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   03-02-2021   Antoine Latour   Initial Version
**/
@isTest
   global class  HP_EM007_PrestationDistributeur_TEST {

	@testSetup static void dataSetup(){

		Id hpRecordTypeId = Schema.SObjectType.Prestation_distributeur__c.getRecordTypeInfosByDeveloperName().get('HP_PrestationDistributeur').getRecordTypeId();

		List<Case> caseList = new List<Case>();
		Case newCaseElec = new Case(status = 'HP_Pending');
		caseList.add(newCaseElec);
		Case newCaseGaz = new Case(status = 'HP_Pending');
		caseList.add(newCaseGaz);
		insert caseList;
  
		List<Prestation_distributeur__c> prestaList = new List<Prestation_distributeur__c>();
		Prestation_distributeur__c opsElec = new Prestation_distributeur__c(Name = 'Elec',
		Case__c = newCaseElec.Id,
		Secteur_activite__c = 'Elec',
		Numero_PDL_PCE__c = '011111111111111',
		Numero_affaire_distributeur__c = '12345678',
		Telephone_intervention__c = '06666666666',
		Statut_dernier_jalon__c = 'En attente',
		Nom_contact_d_intervention__c = 'test test',
		Date_statut_prestation__c = Date.valueOf('2018-01-01'),
		Creneau__c = 'Journée',
		Prenom_contact_d_intervention__c = 'test',
		Civilite_interlocuteur_intervention__c = 'MR',
		Numero_dernier_jalon__c = 1,
		Statut__c = 'En cours',
		Date_de_prestation__c = Date.valueOf('2018-01-01'),
		Identifiant_ENGIE__c = '123456', 
		RecordTypeId = hpRecordTypeId);
		prestaList.add(opsElec);
  
		Prestation_distributeur__c opsGaz = new Prestation_distributeur__c(Name = 'Gaz',
		Case__c = newCaseGaz.Id,
		Secteur_activite__c = 'Gaz',
		Numero_affaire_distributeur__c = '12345679',
		Numero_PDL_PCE__c = '011111111111112',
		Telephone_intervention__c = '06666666666',
		Statut_dernier_jalon__c = 'En cours',
		Nom_contact_d_intervention__c = 'test test',
		Date_statut_prestation__c = Date.valueOf('2018-01-01'),
		Creneau__c = 'Journée',
		Prenom_contact_d_intervention__c = 'test',
		Civilite_interlocuteur_intervention__c = 'MR',
		Numero_dernier_jalon__c = 1,
		Statut__c = 'Terminé',
		Date_de_prestation__c = Date.valueOf('2018-01-01'),
		Identifiant_ENGIE__c = '123457',
		RecordTypeId = hpRecordTypeId);
		prestaList.add(opsGaz);
		insert prestaList;
	 }

   @isTest static void updatePrestationsDistributeur() {
		List<Prestation_distributeur__c> listPresta = HP_EM007_PrestationDistributeurManager.loadPrestationsDistributeurFromListIdAffaire(new Set<String>{'12345678', '12345679'});

		Test.startTest();
		Database.SaveResult[] srList = HP_EM007_PrestationDistributeurManager.updatePrestationsDistributeur(listPresta);
		Test.stopTest();

		System.assert(srList[0].success);
		System.assert(srList[1].success);
    }

	@isTest static void loadPrestationsDistributeurFromListIdAffaire() {
		Test.startTest();
		List<Prestation_distributeur__c> listPresta = HP_EM007_PrestationDistributeurManager.loadPrestationsDistributeurFromListIdAffaire(new Set<String>{'12345678', '12345679'});
		Test.stopTest();
		System.assert(listPresta.size() == 2);
	}

	
	@isTest static void isExistBussinessNum() {
		Test.startTest();
		boolean elecExist = HP_EM007_PrestationDistributeurManager.isExistBussinessNum('12345678', '');
		boolean gazExist = HP_EM007_PrestationDistributeurManager.isExistBussinessNum('12345679', '');
		Test.stopTest();

		System.assert(!elecExist);
		System.assert(gazExist);
	}
	
	
	@isTest static void loadPrestationDistrubuteurToCardService() {
		Test.startTest();
		Prestation_Distributeur__c prestaElec = HP_EM007_PrestationDistributeurManager.loadPrestationDistrubuteurToCardService('011111111111111');
		Prestation_Distributeur__c prestaGaz = HP_EM007_PrestationDistributeurManager.loadPrestationDistrubuteurToCardService('011111111111112');
		Test.stopTest();

		System.assert(prestaElec != null);
		System.assert(prestaGaz != null);
    }

	@isTest static void loadPrestationDistributeur() {
		Test.startTest();
		Prestation_Distributeur__c prestation = HP_EM007_PrestationDistributeurManager.loadPrestationDistributeur('12345678');
		Test.stopTest();
		System.assert(prestation != null);
    }


}