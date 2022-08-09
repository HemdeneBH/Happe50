/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-05-2022
 * @last modified by  : Ahmed LAAMIRI
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
      Numero_affaire_distributeur__c = '1234567',
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
      Numero_affaire_distributeur__c = '1234568',
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
     
      Prestation_distributeur__c opsGazNullDate = new Prestation_distributeur__c(Name = 'Gaz',
      Case__c = newCaseGaz.Id,
      Secteur_activite__c = 'Gaz',
      Numero_affaire_distributeur__c = '01234589',
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
      Identifiant_ENGIE__c = '01234589');

     insert opsGazNullDate;

           

     CMN_OPSinfo opsElecFromClient = new CMN_OPSinfo();
     opsElecFromClient.idAffaire = '1234567';
     opsElecFromClient.referenceDemandeur = '1234567';
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
     opsGazFromClient.referenceDemandeur = '1234568';
     opsGazFromClient.statutDernierJalon = 'OK';
     opsGazFromClient.numDernierJalon = 2;
     opsGazFromClient.statutPrestation = 'Clôturée';
     opsGazFromClient.datePrestation = '2018-12-20T16:14:04+01:00';
     opsGazFromClient.creneau = 'jou6';
     opsGazFromClient.civiliteIntervenant = 'MR';
     opsGazFromClient.nomIntervenant = 'test';
     opsGazFromClient.prenomIntervenant = 'test';
     opsGazFromClient.telephoneIntervenant = '7777777777';
     opsGazFromClient.typeEnergie = 'Gaz';
        
  
           
     CMN_OPSinfo opsGazFromClientDateNull = new CMN_OPSinfo();
     opsGazFromClientDateNull.idAffaire = '01234589';
     opsGazFromClientDateNull.referenceDemandeur = '01234589';
     opsGazFromClientDateNull.statutDernierJalon = 'OK';
     opsGazFromClientDateNull.numDernierJalon = 2;
     opsGazFromClientDateNull.statutPrestation = 'Clôturée';
     opsGazFromClientDateNull.datePrestation = '';
     opsGazFromClientDateNull.creneau = 'jou6';
     opsGazFromClientDateNull.civiliteIntervenant = 'MR';
     opsGazFromClientDateNull.nomIntervenant = 'testnull';
     opsGazFromClientDateNull.prenomIntervenant = 'testnull';
     opsGazFromClientDateNull.telephoneIntervenant = '7700000000';
     opsGazFromClientDateNull.typeEnergie = 'Gaz';   


     RestRequest req = new RestRequest(); 	 
		req.requestURI = '/updateOPS';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(JSON.serializePretty(new Map<String, Object>{'OPSinfos' => new List <CMN_OPSinfo> {opsGazFromClientDateNull,opsElecFromClient,opsGazFromClient}}));
        RestContext.request = req;
		RestResponse res = new RestResponse();
        RestContext.response = res;
     	CMN_OPSUpdate.handleOpsInfos();
 
    }

}