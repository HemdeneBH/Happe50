/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-08-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   02-24-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/


@isTest
global with sharing class HP_WS013_PortailDevis_TEST {

   
    @testSetup static void dataSetup(){
        Contact acontact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
            'Id_Tiers__c' => 100166,
            'HP_IsHappe__c' => true,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'email' => 'user@example.com',
            'mobilePhone' => '0756543434',
            'Phone' => '0145454545',
            'No_Voie__c' => '22',
            'MailingStreet' => 'rue des bois',
            'MailingPostalCode' => '92160',
            'Complement_adresse__c' => 'REZID',
            'MailingCity' =>'ANTONY',
            'OwnerId' => UserInfo.getUserId()
        }, null, null, null);
        insert acontact;

    }

	@isTest static void  souscriptionDevis() {
        Contact acontact =[select id from Contact limit 1];
        HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Canal_de_vente__c'  => 'Vente Online',
            'HP_Contact__c'=> acontact.Id,
            'HP_Classe_de_la_consommation_Gaz__c'  => 'B0',
            'HP_Code_Gaz_Produit__c'  => 'GITR2_H',
            'HP_Code_Electrique_Produit__c'  => 'EITR2_H',
            'HP_Code_postal__c'  => '92160',
            'HP_code_Postal_Insee__c'  => '92002',
            'HP_Date_de_Contractualisation__c'  => System.today().addDays(1),
            'HP_Date_Origine__c'  =>DateTime.newInstance(2019, 10, 9, 13, 0, 0),
            'HP_Energie_Verte__c'  => false,
            'HP_Estimation_Consommation_electrique__c'  => 6000,
            'HP_Estimation_Consommation_gaz__c'  => 13000,
            'HP_Jour_de_facturation__c' => 16,
            'HP_Lien_enregistrement__c' =>'test.fr',
            'HP_Methode_de_paiement__c' =>'BANK_CARD',
            'HP_Montant_de_la_facturation_electrique__c' =>58,
            'HP_Montant_de_la_facturation_gaz__c' =>120,
            'HP_Predecesseur__c' =>'Dupont',
            'HP_Nom_de_rue__c' =>'rue des bois',
            'HP_Nom_de_ville__c' =>'ANTONY',
            'HP_Numero_de_voie__c' =>'15 ter',
            'HP_Periode_de_facturation__c' =>'BIMONTHLY',
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_Puissance_Compteur_electrique__c' =>6,
            'HP_Souscription_Digital_Id__c' =>'1234567891234',
            'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',
            'HP_NumPDL__c' =>'31431211214170',
            'HP_Statut__c' =>'SAVE_1',
            'OwnerId' => UserInfo.getUserId()
        }, null);
        insert enrolment;

        HP_WRP039_Devis.Request req = new HP_WRP039_Devis.Request('1234567891234');
    
        RestRequest reqHttp = new RestRequest();
        RestResponse resHttp = new RestResponse();
    
        reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
        RestContext.request = reqHttp;
        RestContext.response = resHttp;
   
        Test.startTest();
        HP_WS013_PortailDevis.souscriptionDevis();
        Test.stopTest();
    }

    @isTest static void  souscriptionDevisStatutSave2() {
        Contact acontact =[select id from Contact limit 1];
        HP_Souscription__c enrolmentSave2 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Canal_de_vente__c'  => 'Vente Online',
            'HP_Contact__c'=> acontact.Id,
            'HP_Classe_de_la_consommation_Gaz__c'  => 'B0',
            'HP_Code_Gaz_Produit__c'  => 'GITR2_H',
            'HP_Code_Electrique_Produit__c'  => 'EITR2_H',
            'HP_Code_postal__c'  => '92160',
            'HP_code_Postal_Insee__c'  => '92002',
            'HP_Date_de_Contractualisation__c'  => System.today().addDays(1),
            'HP_Date_Origine__c'  =>DateTime.newInstance(2019, 10, 9, 13, 0, 0),
            'HP_Energie_Verte__c'  => false,
            'HP_Estimation_Consommation_electrique__c'  => 6000,
            'HP_Estimation_Consommation_gaz__c'  => 13000,
            'HP_Jour_de_facturation__c' => 16,
            'HP_Lien_enregistrement__c' =>'test.fr',
            'HP_Methode_de_paiement__c' =>'BANK_CARD',
            'HP_Montant_de_la_facturation_electrique__c' =>58,
            'HP_Montant_de_la_facturation_gaz__c' =>120,
            'HP_Predecesseur__c' =>'Dupont',
            'HP_Nom_de_rue__c' =>'rue des bois',
            'HP_Nom_de_ville__c' =>'ANTONY',
            'HP_Numero_de_voie__c' =>'15 ter',
            'HP_Periode_de_facturation__c' =>'BIMONTHLY',
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_Puissance_Compteur_electrique__c' =>6,
            'HP_Souscription_Digital_Id__c' =>'123456',
            'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',
            'HP_NumPDL__c' =>'31431211214170',
            'HP_Statut__c' =>'SAVE_2',
            'OwnerId' => UserInfo.getUserId()
        }, null);
        insert enrolmentSave2;
        HP_WRP039_Devis.Request req = new HP_WRP039_Devis.Request('123456');
    
        RestRequest reqHttp = new RestRequest();
        RestResponse resHttp = new RestResponse();
    
        reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
        RestContext.request = reqHttp;
        RestContext.response = resHttp;
   
        Test.startTest();
        HP_WS013_PortailDevis.souscriptionDevis();
        Test.stopTest();
    }

    @isTest static void  souscriptionDevisEmptyId() {

        HP_WRP039_Devis.Request req = new HP_WRP039_Devis.Request(' ');
    
        RestRequest reqHttp = new RestRequest();
        RestResponse resHttp = new RestResponse();
    
        reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
        RestContext.request = reqHttp;
        RestContext.response = resHttp;
   
        Test.startTest();
        HP_WS013_PortailDevis.souscriptionDevis();
        Test.stopTest();
    }

    @isTest static void  souscriptionDevisIdAlphanumerique() {

        HP_WRP039_Devis.Request req = new HP_WRP039_Devis.Request('azerty');
    
        RestRequest reqHttp = new RestRequest();
        RestResponse resHttp = new RestResponse();
    
        reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
        RestContext.request = reqHttp;
        RestContext.response = resHttp;
   
        Test.startTest();
        HP_WS013_PortailDevis.souscriptionDevis();
        Test.stopTest();
    }
}