/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-16-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-04-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@IsTest
public with sharing class HP_SM045_NoteSatisfaction_TEST {
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
            'OwnerId' => UserInfo.getUserId(),
            'HP_IsHappe__c' => true
        }, null, null, null);
        insert acontact;

    }
    @IsTest
    public static void loadSatTest() {
        HP_SM045_NoteSatisfaction.loadContactWithNoteSatisfaction([select id from contact].Id);
    }

    @IsTest
    public static void noteSatisfactionFromAvisTest() {
        Contact acontact  = [ select Id from Contact limit 1 ];
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
        
        HP_EM041_NoteSatisfaction.noteSatisfactionFromAvis('5','9','870dd7ad','1612540251614_vq8L0Uqvoh',enrolment.Id,acontact.Id, '2021-02-08 09:24:08',DateTime.newInstance(2019, 10, 9, 13, 0, 0),'review','test','test','test');
    }
}