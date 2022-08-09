/**
 * @File Name          : HP_WS001_PortailAuth_TEST.cls
 * @Description        : Classe de test de HP_WS001_PortailAuth
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 01-24-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/12/2019   Vincent Albiser     Initial Version
**/
@isTest
public class HP_WS001_PortailAuth_TEST {

    /**
    * @description testSetup
    * @author Vincent Albiser | 10/12/2019 
    * @return void 
    **/
    @testSetup static void dataSetup(){
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            HP_PortailCanal__c canal = (HP_PortailCanal__c)HP_UTIL_SmartFactory.createSObject('HP_PortailCanal__c', null, new Map<String, Object>{
                'Name' => 'CRC-ENGIE',
                'Droit_VenteEm__c' => true,
                'Droit_PaiementCB__c' => true,
                'Droit_ParcoursEmDm__c' => true,
                'Droit_VenteChf1Ex__c' => true,
                'Droit_VenteChf2Ex__c' => true,
                'Droit_VenteEm1Ex__c' => true,
                'HP_Paiement_prlvt__c' => true,
                'HP_Visu_docs__c' => true,
                'HP_Modif_ventes__c' => true,
                'HP_Liens_SF__c' => true,
                'HP_Vente_Stay__c' => true,
                'HP_Unshort_Lien__c' => true
            }, null, null, null);
            insert canal;
    
            HP_PortailPrestataire__c presta = (HP_PortailPrestataire__c)HP_UTIL_SmartFactory.createSObject('HP_PortailPrestataire__c', null, new Map<String, Object>{
                'IdPrestataire__c' => 'Happe',
                'Name' => 'Happe',
                'Canal__c' => canal.Id
            }, null, null, null);
    
            insert presta;
    
            Profile systemAdminProfile = [SELECT Id FROM Profile WHERE Name = 'HP_SystemAdmin'];
            insert new ByPassSettings__c(SetupOwnerId = systemAdminProfile.Id, ValidationRule__c = true);
            
            HP_PortailUtilisateur__c utilisateur = (HP_PortailUtilisateur__c)HP_UTIL_SmartFactory.createSObject('HP_PortailUtilisateur__c', null, new Map<String, Object>{
                'Login__c'        => 'Hap001',
                'Password__c'     => '123456',
                'Role__c'         => 'Conseiller',
                'Prestataire__c'  => presta.Id,
                'Nom__c'			=> 'Test Nom',
                'Prenom__c'		=> 'Test Prénom',
                'Civilite__c'		=> 'Mr'
            }, null, null, null);
            insert utilisateur; 
        }        
              
    }

    /**
    * @description checkAuth_200
    * @author Vincent Albiser | 10/12/2019 
    * @return void 
    **/
    @isTest static void checkAuth_200() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Test.startTest();

            String json = '{"login": "Hap001"}';

            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();

            req.requestURI = '/services/apexrest/portailAdmin/auth'; 
            req.httpMethod = 'POST';
            req.addHeader('Content-Type', 'application/json');            
            req.requestBody = Blob.valueOf(json);   

            RestContext.request = req;       
            RestContext.response = res;    

            HP_WS001_PortailAuth.checkAuth();

            System.assert(HP_HttpStatus.OK == res.statusCode, 'Echec checkAuth_200 statusCode');
            
        Test.stopTest(); 
        }
        
    }

    /**
    * @description checkAuth_401
    * @author Vincent Albiser | 10/12/2019 
    * @return void 
    **/
    @isTest static void checkAuth_401() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Test.startTest();

            String json = '{"login": "HaP001"}';

            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();

            req.requestURI = '/services/apexrest/portailAdmin/auth'; 
            req.httpMethod = 'POST';
            req.addHeader('Content-Type', 'application/json');            
            req.requestBody = Blob.valueOf(json);   

            RestContext.request = req;       
            RestContext.response = res;    

            HP_WS001_PortailAuth.checkAuth();

            System.assert(HP_HttpStatus.UNAUTHTORIZED == res.statusCode, 'Echec checkAuth_401 statusCode');
            
        Test.stopTest();
        }
         
    }

    /**
    * @description checkAuth_400
    * @author Vincent Albiser | 10/12/2019 
    * @return void 
    **/
    @isTest static void checkAuth_400() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Test.startTest();

            String json = '{"login": "Hap}';

            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();

            req.requestURI = '/services/apexrest/portailAdmin/auth'; 
            req.httpMethod = 'POST';
            req.addHeader('Content-Type', 'application/json');            
            req.requestBody = Blob.valueOf(json);   

            RestContext.request = req;       
            RestContext.response = res;    

            HP_WS001_PortailAuth.checkAuth();

            System.assert(HP_HttpStatus.BAD_REQUEST == res.statusCode, 'Echec checkAuth_400 statusCode');
            
        Test.stopTest(); 
    }
        }
        
}