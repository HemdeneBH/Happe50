/**
 * @description       : 
 * @author            : Ali AJELLAL
 * @group             : 
 * @last modified on  : 11-13-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-13-2020   Ali AJELLAL   Initial Version
**/
@IsTest
public with sharing class HP_HDL003_Souscription_TEST {

    private enum StaticResource {		
        HP_APIHourCommercialProposition_POST_MOCK,
        HP_APIHourAccessTokenResponse_MOCK,
        HP_SendEmail_Mock
    }

    @testSetup static void dataSetup(){
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
                'Id_Tiers__c' => 100166,
                'HP_IsHappe__c' => true,
                'Salutation'=>'MR',
                'lastName' => 'testnicot',
                'firstName' => 'lenfant',
                'Email'=>'test@email.com',
                'mobilePhone' => '0756543434',
                'Phone' => '0145454545',
                'No_Voie__c' => '22',
                'MailingStreet' => 'rue des bois',
                'MailingPostalCode' => '92160',
                'Complement_adresse__c' => 'REZID',
                'MailingCity' =>'ANTONY'
            },null, null, null);
            insert contact;
    
            HP_Souscription__c enrolment1 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
                'HP_Souscription_Digital_Id__c' =>'testGaz-01',
                'HP_type_Souscription__c' =>'MOVING_IN',
                'HP_NumberPCE__c' =>'31431211214068',
                'HP_Statut__c' =>'SAVE_2',
                'HP_Tech_Is_Apex_Processing__c'=> false,
                'HP_Type_Energie__c' =>'GAS',
                'HP_Contact__c'=> contact.Id,
                'HP_Plan_de_Prix_electrique__c' =>'BASE',
                'HP_EnvoyerNotificationClient__c' => true
            }, null);
            insert enrolment1;
    
    
            HP_Souscription__c enrolment2 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
                'HP_Souscription_Digital_Id__c' =>'testElec-01',
                'HP_type_Souscription__c' =>'MOVING_IN',
                'HP_NumPDL__c' =>'31431211214170',
                'HP_Statut__c' =>'SAVE_3',
                'HP_Tech_Is_Apex_Processing__c'=> false,
                'HP_Type_Energie__c' =>'ELECTRICITY',
                'HP_Contact__c'=> contact.Id,
                'HP_Plan_de_Prix_electrique__c' =>'BASE',
                'HP_EnvoyerNotificationClient__c' => true
            }, null);
            insert enrolment2;
    
            HP_Contrat__c celec =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
            new Map<String, Object>{ 
                'HP_Numero_reference_du_Compteur__c' => '423',
                'HP_Id_Compteur__c' => '31431211214170',
                'HP_Compteur_Base_Plan_Index__c' => 56726,
                'HP_Compteur_Variable_Plan_prix_Index__c' => 34251,
                'HP_Compteur_Plan_Bottom_Price_Index__c' => 78098,
                'HP_Souscription_Digital_Id__c' => enrolment2.HP_Souscription_Digital_Id__c+'ELEC',
                'HP_Proposition_Commerciale_XdataId__c'=>'775949',
                'HP_Type_de_Compteur__c' => 'ELEC',
                'HP_Contrat_XdataId__c' => 100149,
                'HP_Souscription__c'=> enrolment2.id
            }, null);
            insert celec;
    
            HP_Contrat__c cgaz =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
            new Map<String, Object>{ 
                'HP_Numero_reference_du_Compteur__c' => '423',
                'HP_Id_Compteur__c' => '31431211214068',
                'HP_Contrat_XdataId__c' => 100148,
                'HP_Souscription_Digital_Id__c' => enrolment1.HP_Souscription_Digital_Id__c+'GAS',
                'HP_Proposition_Commerciale_XdataId__c'=>'775949',
                'HP_Souscription__c'=> enrolment1.id,
                'HP_Type_de_Compteur__c' => 'GAS',
                'HP_Index_de_Compteur__c'=>2323434
            }, null);
            insert cgaz;
        }   
    }

    @isTest static void updateSouscription_Test() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    null,
                    '{"_data":[{"energie":"Electricité", "idPortefeuilleContrat": 1235,  "idPersonne": 1313, "idPointDeLivraison": 123456}]}',
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
                ),
                'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                                                      StaticResource.HP_APIHourCommercialProposition_POST_MOCK.name(),
                                                      new Map<String, String> { 'Content-Type' => 'application/json'}),
                'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_SendEmail_Mock.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                )
            };
    
            Test.startTest();
                Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
                List<HP_Souscription__c> souscriptions = [select Id,HP_Statut__c,HP_Type_Energie__c,HP_Souscription_Digital_Id__c,HP_type_Souscription__c, HP_Plan_de_Prix_electrique__c from HP_Souscription__c];
                for (HP_Souscription__c s : souscriptions){
                        s.HP_Statut__c = 'CANCEL';
                    }
                update souscriptions;
            Test.stopTest(); 
            System.assert( [SELECT count() FROM EmailMessage] > 0 , 'Send mail succeeded.');
        }    
    }



}