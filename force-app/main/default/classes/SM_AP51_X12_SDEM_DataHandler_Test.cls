/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-16-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-10-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
   global class SM_AP51_X12_SDEM_DataHandler_Test {





    @isTest static void updateOPS() {



     Case newCaseElec = new Case(status = 'En attente',Sous_statut__c='Retour client');
     insert newCaseElec;

     Case newCaseGaz = new Case(status = 'En attente',Sous_statut__c='Retour client');
     insert newCaseGaz;

     Prestation_distributeur__c opsElec = new Prestation_distributeur__c(Name = 'Elec',
      Case__c = newCaseElec.Id,
      Secteur_activite__c = 'Elec',
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
      Identifiant_ENGIE__c = '123456');
     insert opsElec;



     Prestation_distributeur__c opsGaz = new Prestation_distributeur__c(Name = 'Gaz',
      Case__c = newCaseGaz.Id,
      Secteur_activite__c = 'Gaz',
      Numero_affaire_distributeur__c = '12345679',
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
      Identifiant_ENGIE__c = '123457');

     insert opsGaz;

     CMN_OPSinfo opsElecFromClient = new CMN_OPSinfo();
     opsElecFromClient.idAffaire = '1234567';
     opsElecFromClient.referenceDemandeur = '';
     opsElecFromClient.statutDernierJalon = 'OK';
     opsElecFromClient.numDernierJalon = 2;
     opsElecFromClient.statutPrestation = 'Terminé';
     opsElecFromClient.datePrestation = '2018-12-20T16:14:04+01:00';
     opsElecFromClient.creneau = 'jou';
     opsElecFromClient.civiliteIntervenant = 'MR';
     opsElecFromClient.nomIntervenant = 'test';
     opsElecFromClient.prenomIntervenant = 'test';
     opsElecFromClient.telephoneIntervenant = '7777777777';
     opsElecFromClient.typeEnergie = 'Elec';





     CMN_OPSinfo opsGazFromClient = new CMN_OPSinfo();
     opsGazFromClient.idAffaire = '1234568';
     opsGazFromClient.referenceDemandeur = '';
     opsGazFromClient.statutDernierJalon = 'OK';
     opsGazFromClient.numDernierJalon = 2;
     opsGazFromClient.statutPrestation = 'Clôturée';
        opsGazFromClient.datePrestation = '2018-1220T16:14:04+01:00';
        opsGazFromClient.creneau = 'jou6';
     opsGazFromClient.civiliteIntervenant = 'MR';
     opsGazFromClient.nomIntervenant = 'test';
     opsGazFromClient.prenomIntervenant = 'test';
     opsGazFromClient.telephoneIntervenant = '7777777777';
     opsGazFromClient.typeEnergie = 'Gaz';


     RestRequest req = new RestRequest(); 	 
		req.requestURI = '/updateOPS';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(JSON.serializePretty(new Map<String, Object>{'OPSinfos' => new List < CMN_OPSinfo> {
         opsElecFromClient,
         opsGazFromClient
        }}));
        RestContext.request = req;

     CMN_OPSUpdate.handleOpsInfos();


    }







   }