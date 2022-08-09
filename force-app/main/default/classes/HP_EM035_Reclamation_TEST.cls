/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 08-31-2020
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   08-31-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest 

public with sharing class HP_EM035_Reclamation_TEST {
    
    @testSetup static void dataSetup(){
        Account acc = (Account)HP_UTIL_SmartFactory.createSObject('Account','HP_Account' ,new Map<String, Object>{
            'HP_XDataExternalId__c' => 100166,
                'Name' => 'UnitTest',
                'OwnerId' => UserInfo.getUserId()
                },null,null, null);
        insert acc;
        
        Contact acontact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
            'AccountId' => acc.Id,
                'Id_Tiers__c' => 100166,
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
                'HP_Souscription_Digital_Id__c' =>'testGazElec-01',
                'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
                'HP_type_Souscription__c' =>'MOVING_IN',
                'HP_NumberPCE__c' =>'31431211214068',
                'HP_NumPDL__c' =>'31431211214170',
                'HP_Statut__c' =>'SAVE_1',
                'OwnerId' => UserInfo.getUserId()
                }, null);
        insert enrolment;
    }
    
    @isTest 
    public static void notifyAgilabTest() {
        
        Contact cont = [select Id from Contact limit 1]; 
        Case acase = (Case) HP_UTIL_SmartFactory.createSObject('Case',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
            'ContactId' => cont.Id,
            'HP_Energy__c' => 'Electricity',
            'HP_Type__c' => 'HP_Reclamation',
            'RecordTypeId'  => HP_UTIL_RecordType.getRecordTypeId('Case','HP_Mediation_Reclamation')
            }, null
        );
        
        HP_Souscription__c sous = [select Id from HP_Souscription__c limit 1]; 
        Case acase1 = (Case) HP_UTIL_SmartFactory.createSObject('Case',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
            'ContactId' => cont.Id,
            'HP_Energy__c' => 'Electricity',
            
            'RecordTypeId'  => HP_UTIL_RecordType.getRecordTypeId('Case','HP_PrestationDistributeur'),
            
            'HP_Souscription__c' => sous.id
            }, null
        );
        
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
                'reclamation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    null, '',
                    new Map<String, String> {'Content-Type' => 'application/json'}
                )
                };
                    
        // start the tests
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        insert acase;        
        acase.Status = 'CLOSED';
        update acase; 
        
        insert acase1;
        
        HP_EM035_Reclamation.loadReclamationCase(cont.Id);
        Test.stopTest();
    }
}