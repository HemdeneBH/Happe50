/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   02-10-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest 
public with sharing class HP_BAT016_SouscriptionPerimee_TEST {
    @testSetup static void dataSetup(){
         
        Account acc = (Account)HP_UTIL_SmartFactory.createSObject('Account','HP_Account' ,new Map<String, Object>{
            'HP_XDataExternalId__c' => 100166,
            'Name' => 'UnitTest',
            'OwnerId' => UserInfo.getUserId()
        },null,null, null);
        insert acc;
        
            Contact acontact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
                'AccountId' => acc.Id,
                'Id_Tiers__c' => 204833,
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
            
            HP_Offre__c offreGaz = (HP_Offre__c)HP_UTIL_SmartFactory.createSObject('HP_Offre__c', null, new Map<String, Object>{
                'offreCode__c' => 'GITR2_H',
                'offreId__c'=> 435
                
            }, null, null, null);
            insert offreGaz;
    
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
                'HP_DigitalDateSave2__c'  =>DateTime.newInstance(2019, 10, 9, 13, 0, 0),
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
                'HP_Souscription_Digital_Id__c' =>'testGazElec-01',
                'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
                'HP_type_Souscription__c' =>'MOVING_IN',
                'HP_NumberPCE__c' =>'31431211214068',
                'HP_NumPDL__c' =>'31431211214170',
                'HP_Statut__c' =>'SAVE_2',
                'OwnerId' => UserInfo.getUserId()
            }, null);
            insert enrolment;
            Datetime dt = Datetime.now().addDays(-50);
            Test.setCreatedDate(enrolment.Id, dt);
            HP_Porte_Feuille_Contrat__c porteFeuille = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
                'HP_Contact__c' => acontact.id,
                'Xdata_Id__c' => '254164',
                'HP_Souscription_Digital_Id__c'=>'testGazElec-01',
                'OwnerId' => UserInfo.getUserId()
            }, null, null, null);
            insert porteFeuille;
            
            HP_Contrat__c contract =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
            new Map<String, Object>{ 
                'HP_Numero_reference_du_Compteur__c' => '423',
                'HP_Id_Compteur__c' => '31431211214068',
                'HP_Porte_Feuille_Contrat__c' => porteFeuille.Id,
                'HP_Contrat_XdataId__c' => 100148,
                'HP_Souscription_Digital_Id__c' => enrolment.HP_Souscription_Digital_Id__c+'GAS',
                'HP_Proposition_Commerciale_XdataId__c'=>'775949',
                'HP_Souscription__c'=> enrolment.id,
                'HP_Type_de_Compteur__c' => 'GAS',
                'OwnerId' => UserInfo.getUserId()
            }, null);
            insert contract;
    }

    @isTest static void testBatchScheduler(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                  'HP_APIHourAccessTokenResponse_MOCK',
                                                  new Map<String, String> {'Content-Type' => 'application/json'}),

           'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                 null, 'OK',
                                                 new Map<String, String> { 'Content-Type' => 'application/json;charset=UTF-8'})
       };
       final String jobName = 'HP_BAT016_SouscriptionPerimee';
       final String cronExp = '0 0 23 ? * * *';
        Test.startTest();

        Test.setMock(HttpCalloutMock.class,new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_BAT016_SouscriptionPerimee.launchNewScheduler(cronExp,jobName);

        Test.stopTest();  
    }

    @isTest static void testBatch(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                  'HP_APIHourAccessTokenResponse_MOCK',
                                                  new Map<String, String> {'Content-Type' => 'application/json'}),

           'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                 null, 'OK',
                                                 new Map<String, String> { 'Content-Type' => 'application/json;charset=UTF-8'})
       };

        Test.startTest();

        Test.setMock(HttpCalloutMock.class,new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_BAT016_SouscriptionPerimee.execute();

        Test.stopTest();  
    }
}