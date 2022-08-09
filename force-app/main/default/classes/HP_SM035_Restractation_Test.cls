/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 


 * @last modified on  : 06-14-2021


 * @last modified by  : Hemdene Ben Hammouda
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   08-03-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@IsTest
public with sharing class HP_SM035_Restractation_Test {
    @testSetup 
    static void dataSetup(){
        Account acc = (Account)HP_UTIL_SmartFactory.createSObject('Account','HP_Account' ,new Map<String, Object>{
            'HP_XDataExternalId__c' => 100166,
            'Name' => 'UnitTest',
            'OwnerId' => UserInfo.getUserId()
        },null,null, null);
        insert acc;
        
            Contact acontact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
                'AccountId' => acc.Id,
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
			Datetime contDate = DateTime.Now().AddDays(20);
            HP_Souscription__c souscription = new HP_Souscription__c(
                HP_Contact__c = acontact.Id,
         
                OwnerId = UserInfo.getUserId(),
                HP_DigitalDateSave3__c = System.now(),
                HP_Date_Origine__c = System.now(),
                HP_Souscription_Digital_Id__c = 'test123D',
                HP_Date_de_Contractualisation__c = date.newinstance(contDate.year(), contDate.month(), contDate.day())
            );

            insert souscription;

            HP_Contrat__c cont = new HP_Contrat__c(
                OwnerId = UserInfo.getUserId(),
                HP_Contrat_XdataId__c = 123,
                HP_Proposition_Commerciale_XdataId__c = '123',
                HP_Souscription__c = souscription.Id,
                HP_Souscription_Digital_Id__c = 'test123D',
                HP_Type_de_Compteur__c = 'ELEC'
           );

            insert cont;
        
        Prestation_distributeur__c pres = new Prestation_distributeur__c(
                RecordTypeId = Schema.SObjectType.Prestation_distributeur__c.getRecordTypeInfosByDeveloperName().get('HP_PrestationDistributeur').getRecordTypeId(),
                HP_Contrat__c = cont.Id,
                OwnerId = UserInfo.getUserId(),
                Statut__c = 'Annulé',
                    Numero_affaire_distributeur__c = ' 11111111',
                Date_de_prestation__c = date.newinstance(contDate.year(), contDate.month(), contDate.day())
            );

            insert pres;
    }

    @IsTest
    public static void retractationProcessTest() {
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                   'HP_APIHourAccessTokenResponse_MOCK',
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),

            'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204,
                                                  null,
                                                  '{"codeStatutPropositionCommercialeHeader": "H0002"}',
                                                  new Map<String, String> { 'Content-Type' => 'application/json'}
                                                  ),
            'piset/0.2/contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204,
                                                  null,
                                                  '{"codeStatutCrm": "H0101"}',
                                                  new Map<String, String> { 'Content-Type' => 'application/json'}
                                                  )
        };

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        Map<String, Object> result = HP_SM035_Restractation.processRestractionProcess([select Id from HP_Souscription__c limit 1].Id);
        
        System.debug('@@@ result 1 ' + result);
        for(String key : result.keyset()) {
            System.debug('@@@ Key ' + key + '  :  ' + result.get(key));
        }
       
        Test.stopTest();
         System.assertEquals(result.get('processEndResult'), 'AVEC_FRAIS', 'Erreur assertion !!');
    }

    @IsTest
    public static void retractationConfirmationTest() {
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                   'HP_APIHourAccessTokenResponse_MOCK',
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),

            'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204,
                                                  null,
                                                  '{"codeStatutPropositionCommercialeHeader": "H0002"}',
                                                  new Map<String, String> { 'Content-Type' => 'application/json'}
                                                  ),
            'piset/0.2/contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400,
                                                  null,
                                                  '',
                                                  new Map<String, String> { 'Content-Type' => 'application/json'}
                                                  ),
            '/propositions/modifier' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204,
                                                null,
                                                '{"codeStatutCrm": "H0101"}',
                                                new Map<String, String> { 'Content-Type' => 'application/json'}
                                                )
        };

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));

        Map<String, Object> result = HP_SM035_Restractation.confirmRetractation([select Id from HP_Souscription__c limit 1].Id, true, true, true, null);

        System.debug('@@@ result 2 ' + result);
        Test.stopTest();
        System.assertEquals(result.get('resultAPI'), false, 'Erreur assertion !!');
    }
}