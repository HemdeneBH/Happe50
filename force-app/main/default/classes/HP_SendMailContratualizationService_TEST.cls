/**
 * @description  : 
 * @author       : Vincent Albiser
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   09-12-2020   Vincent Albiser   Initial Version
**/
@isTest
public with sharing class HP_SendMailContratualizationService_TEST {

    private enum StaticResource {		
        HP_APIHourAccessTokenResponse_MOCK,
        HP_SendEmail_Mock
    }

 
    //only test invocable method 

    @testSetup 
    static void dataSetup(){

        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
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
            'MailingCity' =>'ANTONY'
        }, null, null, null);
        insert contact;

        HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Canal_de_vente__c'  => 'Vente Online',
            'HP_Contact__c'=>contact.Id,
            'HP_Classe_de_la_consommation_Gaz__c'  => 'B0',
            'HP_Code_Gaz_Produit__c'  => 'GITR2_H',
            'HP_Code_Electrique_Produit__c'  => 'EITR2_H',
            'HP_Code_postal__c'  => '92160',
            'HP_code_Postal_Insee__c'  => '92002',
            'HP_Date_de_Contractualisation__c'  => Date.newInstance(2019, 12, 22),
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
            'HP_Statut__c' =>'SAVE_1'
		}, null);
        insert enrolment;

        HP_Contrat__c contrat =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
        new Map<String, Object>{ 
            'HP_Numero_reference_du_Compteur__c' => '423',
            'HP_Id_Compteur__c' => '31431211214170',
            'HP_Compteur_Base_Plan_Index__c' => 56726,
            'HP_Compteur_Variable_Plan_prix_Index__c' => 34251,
            'HP_Compteur_Plan_Bottom_Price_Index__c' => 78098,
            'HP_Contrat_XdataId__c' => 100148,
            'HP_Souscription_Digital_Id__c' => enrolment.HP_Souscription_Digital_Id__c+'ELEC',
            'HP_Proposition_Commerciale_XdataId__c'=>'775949',
            'HP_Souscription__c'=> enrolment.id,
            'HP_Type_de_Compteur__c' => 'ELEC'
        }, null);
        insert contrat;

        HP_Souscription__c enrolment2 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Souscription_Digital_Id__c' =>'testElec-01',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumPDL__c' =>'31431211214170',
            'HP_Statut__c' =>'SAVE_3',
            'HP_Tech_Is_Apex_Processing__c'=> false,
            'HP_Type_Energie__c' =>'ELECTRICITY',
            'HP_Contact__c'=> contact.Id,
            'HP_Plan_de_Prix_electrique__c' =>'BASE'
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
    }

    @IsTest static void sendMailViaCabestan_TEST(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_SendEmail_Mock.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            List<HP_SendMailContratualizationService.ObjectToSend> senderlist = new List<HP_SendMailContratualizationService.ObjectToSend>();
            HP_SendMailContratualizationService.ObjectToSend sender = new HP_SendMailContratualizationService.ObjectToSend(
                null,
                'user@example.com',
                100166,
                'testnicot',
                'MR',
                'lenfant',
                'Emménagement',
                '12',
                'Gaz',
                null,
                'rue',
                'rue',
                '75000',
                'Paris'
            );
            senderlist.add(sender);
            HP_SendMailContratualizationService.sendMailViaCabestan(senderlist);
        Test.stopTest();
        System.assert([SELECT count() FROM EmailMessage] > 0 , 'EmailMessage created in SF');
    }


    @IsTest static void sendMailViaCabestanSyncDUAL_TEST(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_SendEmail_Mock.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));

            HP_Contrat__c celec = [SELECT id,HP_Souscription__r.HP_Contact__r.Email, HP_Souscription__r.HP_Contact__r.Id_Tiers__c, HP_Souscription__r.HP_Contact__r.Lastname, HP_Souscription__r.HP_Contact__r.Salutation, HP_Souscription__r.HP_Contact__r.Firstname,HP_Souscription__r.HP_Type_Energie__c FROM HP_Contrat__c WHERE HP_Contrat_XdataId__c = 100148  LIMIT 1];
            HP_WRP022_SFResponse response = new HP_WRP022_SFResponse(200);
            HP_SendMailContratualizationService.sendMailViaCabestanSync('SF12', celec, response);
        Test.stopTest();
        System.assert([SELECT count() FROM EmailMessage] == 0 , 'EmailMessage created in SF');

    }


    
    @IsTest static void sendMailViaCabestanSyncElec_TEST(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_SendEmail_Mock.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));

            HP_Contrat__c celec = [SELECT id,HP_Type_de_Compteur__c,HP_Souscription__r.HP_Plan_de_Prix_electrique__c,  HP_Souscription__r.HP_Contact__r.Email, HP_Souscription__r.HP_Contact__r.Id_Tiers__c, HP_Souscription__r.HP_Contact__r.Lastname, HP_Souscription__r.HP_Contact__r.Salutation, HP_Souscription__r.HP_Contact__r.Firstname,HP_Souscription__r.HP_Type_Energie__c FROM HP_Contrat__c  WHERE HP_Contrat_XdataId__c = 100149 LIMIT 1];
            HP_WRP022_SFResponse response = new HP_WRP022_SFResponse(200);
            HP_SendMailContratualizationService.sendMailViaCabestanSync('SF12', celec, response);
        Test.stopTest();
        System.assert([SELECT count() FROM EmailMessage] == 0 , 'EmailMessage created in SF');

    }
}