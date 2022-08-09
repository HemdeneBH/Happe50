/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 02-15-2022
 * @last modified by  : Badr Eddine Belkarchi
**/

/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 02-15-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
@isTest
public with sharing class HP_EM024_PorteFeuilleContrat_TEST {
    private enum StaticResource {
		HP_APIHourAccessTokenResponse_MOCK
    }
    
    @TestSetup 
	private static void insertTestData() {
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object>{
                'LastName' => 'Test Lastname',
                'Email' => 'test@gmail.com',
                'Id_Tiers__c' => 195464
            }, null, null, null);
            insert contact;

            HP_Porte_Feuille_Contrat__c porteFeuille = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
                'HP_Contact__c' => contact.id,
                'Xdata_Id__c' => '1222',
                'HP_Souscription_Digital_Id__c'=>'testGazElec-01'
            }, null, null, null);
            insert porteFeuille;
        }
    }

    @isTest static void createPorteFeuilleContratXdata_TEST() {
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(), 
                    new Map<String, String> {'Content-Type' => 'application/json'}),
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 'HP_APIHourAccessTokenResponse_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'}),
            'portefeuilles-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, null,
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'})
        };

        HP_ContractPortfolio contractPortfolio = new HP_ContractPortfolio(1763871,1896358,179638);
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        Test.startTest();
        HP_EM024_PorteFeuilleContrat.createPorteFeuilleContratXdata(contractPortfolio);
        Test.stopTest();
    }

    @isTest static void updatePorteFeuilleContratXdata_TEST() {
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(), 
                    new Map<String, String> {'Content-Type' => 'application/json'}),
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 'HP_APIHourAccessTokenResponse_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'}),
            'portefeuilles-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, null,
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'})
        };

        HP_ContractPortfolio contractPortfolio = new HP_ContractPortfolio(1763871,1896358,179638);
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        Test.startTest();
        HP_EM024_PorteFeuilleContrat.updatePorteFeuilleContratXdata('1763871',contractPortfolio);
        Test.stopTest();
    }

    @isTest static void loadPorteFeuilleContrat_TEST() {
        Test.startTest();
        HP_Porte_Feuille_Contrat__c pfc = HP_EM024_PorteFeuilleContrat.loadPorteFeuilleContrat('testGazElec-01');
        Test.stopTest();
        System.assertEquals('testGazElec-01', pfc.HP_Souscription_Digital_Id__c);
    }

    @isTest static void getPortefeuilleContratByXdataId_TEST() {
        Test.startTest();
        HP_Porte_Feuille_Contrat__c pfc = HP_EM024_PorteFeuilleContrat.getPortefeuilleContratByXdataId('1222');
        Test.stopTest();
        System.assertEquals('1222', pfc.Xdata_Id__c);
    }

}