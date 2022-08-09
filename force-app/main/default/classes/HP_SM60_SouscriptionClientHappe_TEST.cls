/**
 * @description       : 
 * @author            : Ali AJELLAL
 * @group             : 
 * @last modified on  : 05-03-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-03-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

@IsTest
public with sharing class HP_SM60_SouscriptionClientHappe_TEST {
    
    private enum StaticResource {
        HP_CONTRAT_XDATA_BY_PERSONNE_MOCK,
        HP_CONTRAT_XDATA_BY_PERSONNE_2_MOCK,
        HP_APIHourAccessTokenResponse_MOCK
    }
   
    @TestSetUp 
	private static void insertTestData() {
    Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
           
        'Id_Tiers__c' => 1844161,
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
        'HP_Souscription_Digital_Id__c' =>'testGazElec-case',
        'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
        'HP_type_Souscription__c' =>'MOVING_IN',
        'HP_NumberPCE__c' =>'31431211214068',
        'HP_NumPDL__c' =>'31431211214170',
        'HP_Statut__c' =>'SAVE_1'
    }, null);
    insert enrolment;

    HP_Offre__c offre = (HP_Offre__c)HP_UTIL_SmartFactory.createSObject('HP_Offre__c', null, new Map<String, Object>{
               
        'offreCode__c' => 'EITR2_H',
        'offreId__c'=> 436,
        'marqueCode__c'=> 'HAP',
        'packId__c' =>433
        
    }, null, null, null);
    insert offre;



}


@istest
static void updateHappeClient(){

    Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
        'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
        StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
        new Map<String, String> {'Content-Type' => 'application/json'}),
        'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
        'HP_APIHourAccessTokenResponse_MOCK',
        new Map<String, String> {'Content-Type' => 'application/json'}),

        'piset/0.2/contrats?idPersonne' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
        'HP_CONTRAT_XDATA_BY_PERSONNE_MOCK',
        new Map<String, String> {'Content-Type' => 'application/json'}),
    
        'piset/0.2/contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204,
        null,
        '{"civilite": "MR","nom":"lenfant","prenom":"testnicot","numVoie":"22","voie":"rue des bois","codePostal":"92160","ville":"ANTONY","estClientHappe":"false","prospect":"false","Client":"false"}',
        new Map<String, String> { 'Content-Type' => 'application/json'}
        )
    
        };

        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        List<Id> souscriptionIds = new List<Id>();
        List<HP_Souscription__c>  souscriptionList = [select Id from HP_Souscription__c ];
        for (HP_Souscription__c item: souscriptionList) {
            souscriptionIds.add(item.Id);
        }

    Test.startTest();
    HP_SM60_SouscriptionClientHappe.updateHappeClient(souscriptionIds);
    Test.stopTest();


}



@istest
static void updateHappeClient2(){
 
    Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
        'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
        StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
        new Map<String, String> {'Content-Type' => 'application/json'}),
        'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
        'HP_APIHourAccessTokenResponse_MOCK',
        new Map<String, String> {'Content-Type' => 'application/json'}),

        'piset/0.2/contrats?idPersonne' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
        'HP_CONTRAT_XDATA_BY_PERSONNE_2_MOCK',
        new Map<String, String> {'Content-Type' => 'application/json'}),
    
        'piset/0.2/contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204,
        null,
        '{"civilite": "MR","nom":"lenfant","prenom":"testnicot","numVoie":"22","voie":"rue des bois","codePostal":"92160","ville":"ANTONY","estClientHappe":"false","prospect":"false","Client":"false"}',
        new Map<String, String> { 'Content-Type' => 'application/json'}
        )
    
        };

        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        List<Id> souscriptionIds = new List<Id>();
        List<HP_Souscription__c>  souscriptionList = [select Id from HP_Souscription__c ];
        for (HP_Souscription__c item: souscriptionList) {
            souscriptionIds.add(item.Id);
        }

    Test.startTest();
    HP_SM60_SouscriptionClientHappe.updateHappeClient(souscriptionIds);
    Test.stopTest();


}

}