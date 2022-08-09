/**
 * @File Name          : HP_WS002_PortailLead_TEST.cls
 * @Description        :
 * @Author             : Vincent Albiser
 * @Group              :
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 23/04/2020 à 16:44:10
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    02/01/2020   Vincent Albiser     Initial Version
 **/
@isTest
public class HP_WS002_PortailLead_TEST {

    /**
    * @description testSetup
    * @author Vincent Albiser | 10/12/2019 
    * @return void 
    **/
     @testSetup static void dataSetup(){
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
            'HP_IsHappe__c' => true,
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
            'MailingCity' =>'ANTONY'
        }, null, null, null);
        insert contact;




        HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Canal_de_vente__c'  => 'CRC-HAPPE',
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
            'HP_Statut__c' =>'SAVE_3'
		}, null);
        insert enrolment;

        HP_Porte_Feuille_Contrat__c porteFeuille = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
            'HP_Contact__c' => contact.id,
            'Xdata_Id__c' => '1222',
            'HP_Souscription_Digital_Id__c'=>'testGazElec-01'
        }, null, null, null);
        insert porteFeuille;

        HP_Contrat__c cgaz =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
        new Map<String, Object>{ 
            'HP_Numero_reference_du_Compteur__c' => '423',
            'HP_Id_Compteur__c' => '31431211214068',
            'HP_Contrat_XdataId__c' => 100148,
            'HP_Souscription_Digital_Id__c' => enrolment.HP_Souscription_Digital_Id__c+'GAS',
            'HP_Proposition_Commerciale_XdataId__c'=>'775949',
            'HP_Souscription__c'=> enrolment.id,
            'HP_Type_de_Compteur__c' => 'GAS',
            'HP_Index_de_Compteur__c'=>2323434
        }, null);
        insert cgaz;
        }
        
          
    } 

    /**
    * @description checkGetLead_200
    * @author Vincent Albiser | 10/12/2019 
    * @return void 
    **/
     @isTest static void checkGetLead_200() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			'HP_APIHourAccessTokenResponse_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}),
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            'HP_APIHourAccessTokenResponse_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}),
            'identite/v1/espaces-prives' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
            null,
            new Map<String, String> {'Content-Type' => 'application/json'})
            };
            HP_PortailCanal__c canal = (HP_PortailCanal__c)HP_UTIL_SmartFactory.createSObject('HP_PortailCanal__c', null, new Map<String, Object>{
                'Name'=>'CRC-HAPPE',
                'Droit_VenteEm__c' => true,
                'Droit_PaiementCB__c' => true,
                'Droit_ParcoursEmDm__c'=>true,
                'Droit_VenteChf1Ex__c' => true,
                'Droit_VenteChf2Ex__c' => true,
                'Droit_VenteEm1Ex__c'=>true
            }, null, null, null);
            insert canal;
            HP_PortailPrestataire__c presta = (HP_PortailPrestataire__c)HP_UTIL_SmartFactory.createSObject('HP_PortailPrestataire__c', null, new Map<String, Object>{
                'IdPrestataire__c'=>'HAPPE_TEST',
                'Name' => 'Happe',
                'Canal__c' => canal.Id
            }, null, null, null);
            insert presta;
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            Profile systemAdminProfile = [SELECT Id FROM Profile WHERE Name = 'HP_SystemAdmin'];
            insert new ByPassSettings__c(SetupOwnerId = systemAdminProfile.Id, ValidationRule__c = true);
            HP_PortailUtilisateur__c utilisateur = (HP_PortailUtilisateur__c)HP_UTIL_SmartFactory.createSObject('HP_PortailUtilisateur__c', null, new Map<String, Object>{
                'Login__c'=>'Hap001',
                'Password__c' => '123456',
                'Role__c' => 'Conseiller',
                'Prestataire__c'=>presta.id,
                'Nom__c' => 'Test Nom',
                'Prenom__c' => 'Test Prenom',
                'Civilite__c'=>'Mr'
            }, null, null, null);
            insert utilisateur;

        Test.startTest();
 
            String json = '{"login": "Hap001"}';

            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();

            req.requestURI = '/services/apexrest/portailAdmin/leads'; 
            req.httpMethod = 'POST';
            req.addHeader('Content-Type', 'application/json');            
            req.requestBody = Blob.valueOf(json);   

            RestContext.request = req;       
            RestContext.response = res;    

            HP_WS002_PortailLead.getLeads();
             
        Test.stopTest(); 

        System.assert(HP_HttpStatus.OK == res.statusCode, 'Echec checkGetLead_200 statusCode');

        // String jsonResult = RestContext.response.responseBody.toString();
        // HP_WRP006_PortailRecords.Response resp = (HP_WRP006_PortailRecords.Response) System.JSON.deserialize(jsonResult, HP_WRP006_PortailRecords.Response.class);
        // System.assert(resp.records.size() == 1, 'Echec response size');
    } 
        
    } 
}