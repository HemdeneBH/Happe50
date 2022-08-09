/**
 * @File Name          : HP_SM004_SGUT_Test.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Slimene Belhaj Ali
 * @Last Modified On   : 05-18-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/12/2019   Vincent Albiser     Initial Version
**/
@isTest
public class HP_SM004_SGUT_Test {

    private enum StaticResource {
        HP_APIHourAccessTokenResponse_MOCK,
        HP_SM004_SGUT_GETUtilisateur_MOCK,
        HP_SM004_SGUT_Response_MOCK
	}

    @testSetup static void dataSetup(){
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            HP_PortailCanal__c canal = (HP_PortailCanal__c)HP_UTIL_SmartFactory.createSObject('HP_PortailCanal__c', null, new Map<String, Object>{
                'Name' => 'CRC-ENGIE',
                'Droit_VenteEm__c' => true,
                'Droit_PaiementCB__c' => true,
                'Droit_ParcoursEmDm__c' => true,
                'Droit_VenteChf1Ex__c' => true,
                'Droit_VenteChf2Ex__c' => true,
                'Visu_docs_s2__c' => true,
                'HP_Paiement_prlvt__c' => true,
                'HP_Visu_docs__c' => true,
                'HP_Modif_ventes__c' => true,
                'Droit_VenteEm1Ex__c' => true
            }, null, null, null);
            insert canal;
    
            HP_PortailPrestataire__c presta = (HP_PortailPrestataire__c)HP_UTIL_SmartFactory.createSObject('HP_PortailPrestataire__c', null, new Map<String, Object>{
                'IdPrestataire__c' => 'Happe',
                'Name' => 'Happe',
                'Canal__c' => canal.Id
            }, null, null, null);
    
            insert presta;
            
            HP_PortailUtilisateur__c utilisateur = (HP_PortailUtilisateur__c)HP_UTIL_SmartFactory.createSObject('HP_PortailUtilisateur__c', null, new Map<String, Object>{
                'Login__c'        => 'Hap001@gmail.com',
                'Password__c'     => 'Happ1179!',
                'Role__c'         => 'Conseiller',
                'Prestataire__c'  => presta.Id,
                'Nom__c'			=> 'Test Nom',
                'Prenom__c'		=> 'Test Prénom',
                'Civilite__c'		=> 'Mr'
            }, null, null, null);
            insert utilisateur;
        }
    }

    @isTest static void creationUtilisateurs_Test() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                       StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                                                       new Map<String, String> {'Content-Type' => 'application/json'}),
                'identite/v1/espaces-prives' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                null,
                new Map<String, String> {'Content-Type' => 'application/json'})
            };
    
            Test.startTest();
    
                Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
                HP_PortailUtilisateur__c utilisateur = [SELECT Id FROM HP_PortailUtilisateur__c WHERE Login__c =:'Hap001@gmail.com' LIMIT 1];
                HP_PortailUtilisateur__c output = HP_SM004_SGUT.creationUtilisateur(utilisateur.Id);
                
            Test.stopTest(); 
    
            System.assert(HP_EM002_PortailUtilisateur.getUtilisateurById(utilisateur.Id).Sgut2Statut__c == 'OK', 'Succès appel SGUT');
        }       
    }

    @isTest static void creationUtilisateurs_TestKO() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                       StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                                                       new Map<String, String> {'Content-Type' => 'application/json'}),
                'identite/v1/espaces-prives' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400, 
                null,
                new Map<String, String> {'Content-Type' => 'application/json'})
            };
    
            Test.startTest();
    
                Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
                HP_PortailUtilisateur__c utilisateur = [SELECT Id FROM HP_PortailUtilisateur__c WHERE Login__c =:'Hap001@gmail.com' LIMIT 1];
                HP_PortailUtilisateur__c output = HP_SM004_SGUT.creationUtilisateur(utilisateur.Id);
                
            Test.stopTest(); 
    
            System.assert(HP_EM002_PortailUtilisateur.getUtilisateurById(utilisateur.Id).Sgut2Statut__c == 'KO', 'Erreur appel SGUT');
        }       
    }


     @isTest static void modificationMDP_Test() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                       StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                                                       new Map<String, String> {'Content-Type' => 'application/json'}),
                '/identite/v1/espaces-prives/mdp' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                       StaticResource.HP_SM004_SGUT_Response_MOCK.name(),
                                                       new Map<String, String> {'Content-Type' => 'application/json'}),
                'identite/v1/entites-espaces-prives?' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                       StaticResource.HP_SM004_SGUT_GETUtilisateur_MOCK.name(),
                                                       new Map<String, String> {'Content-Type' => 'application/json'})
            };
            
            Test.startTest();
    
                Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
                
    
                HP_PortailUtilisateur__c utilisateur = [SELECT Id FROM HP_PortailUtilisateur__c WHERE Login__c =: 'Hap001@gmail.com' LIMIT 1];
                HP_PortailUtilisateur__c output = HP_SM004_SGUT.modificationMDP(utilisateur.Id,'Happ1178!');
                
                
            Test.stopTest(); 
    
            System.assert(HP_EM002_PortailUtilisateur.getUtilisateurById(utilisateur.Id).Password__c == 'Happ1178!', 'Succès modification MDP SGUT');
        }       
    }

    @isTest static void modificationMDP_TestKO() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                       StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                                                       new Map<String, String> {'Content-Type' => 'application/json'}),
                '/identite/v1/espaces-prives/mdp' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400,
                                                       StaticResource.HP_SM004_SGUT_Response_MOCK.name(),
                                                       new Map<String, String> {'Content-Type' => 'application/json'}),
                'identite/v1/entites-espaces-prives?' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                       StaticResource.HP_SM004_SGUT_GETUtilisateur_MOCK.name(),
                                                       new Map<String, String> {'Content-Type' => 'application/json'})
            };
            
            Test.startTest();
    
                Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
                
    
                HP_PortailUtilisateur__c utilisateur = [SELECT Id FROM HP_PortailUtilisateur__c WHERE Login__c =: 'Hap001@gmail.com' LIMIT 1];
                HP_PortailUtilisateur__c output = HP_SM004_SGUT.modificationMDP(utilisateur.Id,'Happ1178!');
                
                
            Test.stopTest(); 
    
            System.assert(HP_EM002_PortailUtilisateur.getUtilisateurById(utilisateur.Id).Sgut2Statut__c == 'KO', 'Erreur appel SGUT');
        }     
    }
 
    @isTest static void suppressionUtilisateur_Test() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                       StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                                                       new Map<String, String> {'Content-Type' => 'application/json'}),
                'identite/v1/espaces-prives/' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                       StaticResource.HP_SM004_SGUT_Response_MOCK.name(),
                                                       new Map<String, String> {'Content-Type' => 'application/json'}),
                'identite/v1/entites-espaces-prives?' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                       StaticResource.HP_SM004_SGUT_GETUtilisateur_MOCK.name(),
                                                       new Map<String, String> {'Content-Type' => 'application/json'})
            };
    
            Test.startTest();
    
                Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
                HP_PortailUtilisateur__c utilisateur = [SELECT Id FROM HP_PortailUtilisateur__c WHERE Login__c =: 'Hap001@gmail.com' LIMIT 1];
                HP_PortailUtilisateur__c output = HP_SM004_SGUT.suppressionUtilisateur(utilisateur.Id);
                
            Test.stopTest(); 
    
            System.assert(HP_EM002_PortailUtilisateur.getUtilisateurById(utilisateur.Id).Sgut2Statut__c == 'OK', 'Succès appel SGUT');
        }    
    }

    @isTest static void suppressionUtilisateur_TestKO() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                       StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                                                       new Map<String, String> {'Content-Type' => 'application/json'}),
                'identite/v1/espaces-prives/' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400,
                                                       StaticResource.HP_SM004_SGUT_Response_MOCK.name(),
                                                       new Map<String, String> {'Content-Type' => 'application/json'}),
                'identite/v1/entites-espaces-prives?' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400,
                                                       StaticResource.HP_SM004_SGUT_GETUtilisateur_MOCK.name(),
                                                       new Map<String, String> {'Content-Type' => 'application/json'})
            };
    
            Test.startTest();
    
                Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
                HP_PortailUtilisateur__c utilisateur = [SELECT Id FROM HP_PortailUtilisateur__c WHERE Login__c =: 'Hap001@gmail.com' LIMIT 1];
                HP_PortailUtilisateur__c output = HP_SM004_SGUT.suppressionUtilisateur(utilisateur.Id);
                
            Test.stopTest(); 
    
            System.assert(HP_EM002_PortailUtilisateur.getUtilisateurById(utilisateur.Id).Sgut2Statut__c == 'KO', 'Erreur appel SGUT');
        }	       
    }
    
}