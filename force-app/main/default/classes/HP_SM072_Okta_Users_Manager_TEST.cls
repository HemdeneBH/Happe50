/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 03-01-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_SM072_Okta_Users_Manager_TEST {
    private enum StaticResource {
        HP_OktaCreateUser_OK_MOCK,
        HP_OktaCreateUser_KO_MOCK
    }

    @TestSetup
    static void dataSetup(){
        List<HP_PortailUtilisateur__c> listUsers = new List<HP_PortailUtilisateur__c>();
        HP_PortailCanal__c canal = (HP_PortailCanal__c) HP_UTIL_SmartFactory.createSObject('HP_PortailCanal__c', new Map<String, Object> {
            'Name' => 'CRC Happe',
            'Droit_PaiementCB__c' => true}, null);
            insert canal;
        HP_PortailPrestataire__c prestataire = (HP_PortailPrestataire__c) HP_UTIL_SmartFactory.createSObject('HP_PortailPrestataire__c', new Map<String, Object> {
            'Name' => 'Happe',
            'Canal__c' => canal.Id,
            'IdPrestataire__c' => 'HappeTest'}, null);
            insert prestataire;
        HP_PortailUtilisateur__c user1 = (HP_PortailUtilisateur__c) HP_UTIL_SmartFactory.createSObject('HP_PortailUtilisateur__c', new Map<String, Object> {
            'Login__c' => 'email@happe.com',
            'Password__c' => 'P@ssw0rd2k21!',
            'Nom__c' => 'Dupont',
            'Prenom__c' => 'Paul',
            'Civilite__c' => 'Mr',
            'Role__c' => 'Conseiller',
            'Prestataire__c' => prestataire.Id}, null);
            listUsers.add(user1);
        HP_PortailUtilisateur__c user2 = (HP_PortailUtilisateur__c) HP_UTIL_SmartFactory.createSObject('HP_PortailUtilisateur__c', new Map<String, Object> {
            'Login__c' => 'email',
            'Password__c' => 'P@ssw0rd2k21!',
            'Nom__c' => 'Dupont',
            'Prenom__c' => 'Marie',
            'Civilite__c' => 'Mme',
            'Role__c' => 'Conseiller',
            'Prestataire__c' => prestataire.Id}, null);
            listUsers.add(user2);
        
        insert listUsers;
        
        HP_Okta_Token_Parameter__c settings = HP_Okta_Token_Parameter__c.getOrgDefaults();
        settings.Encryption_Key__c = '8cPkWGCoHv9a3D7K';
        settings.Encryption_Code__c = 'AES128';
        upsert settings HP_Okta_Token_Parameter__c.Id;
    }

    @isTest 
    public static void createUserTestOk(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'api/v1/users?activate=true' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                                                    StaticResource.HP_OktaCreateUser_OK_MOCK.name(),
                                                   new Map<String, String> {'Content-Type' => 'application/json'})
        };
        HP_PortailUtilisateur__c  user  = [SELECT Id, HP_Okta_Status__c, HP_Okta_Erreur__c, HP_Okta_Id__c FROM HP_PortailUtilisateur__c WHERE Login__c LIKE '%@%' LIMIT 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM072_Okta_Users_Manager.creationUtilisateur(user.Id);
        Test.stopTest();
        HP_PortailUtilisateur__c updatedUser = [SELECT Id, HP_Okta_Status__c, HP_Okta_Erreur__c, HP_Okta_Id__c FROM HP_PortailUtilisateur__c WHERE Login__c LIKE '%@%' LIMIT 1];
        System.assertEquals('OK', updatedUser.HP_Okta_Status__c, 'Statut Ok');
        System.assertEquals(null, updatedUser.HP_Okta_Erreur__c, 'Pas d\'erreur');
        System.assertEquals(true, updatedUser.HP_Okta_Id__c != null, 'Id bien récupéré');
    }

    @isTest 
    public static void createUserTestKo(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'api/v1/users?activate=true' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400,
                                                    StaticResource.HP_OktaCreateUser_KO_MOCK.name(),
                                                   new Map<String, String> {'Content-Type' => 'application/json'})
        };
        HP_PortailUtilisateur__c user = [SELECT Id, HP_Okta_Status__c, HP_Okta_Erreur__c, HP_Okta_Id__c FROM HP_PortailUtilisateur__c WHERE Login__c = 'email' LIMIT 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM072_Okta_Users_Manager.creationUtilisateur(user.Id);
        Test.stopTest();
        HP_PortailUtilisateur__c updatedUser = [SELECT Id, HP_Okta_Status__c, HP_Okta_Erreur__c, HP_Okta_Id__c FROM HP_PortailUtilisateur__c WHERE Login__c = 'email' LIMIT 1];
        System.assertEquals('KO', updatedUser.HP_Okta_Status__c, 'Statut Ko');
        System.assertEquals(true, updatedUser.HP_Okta_Erreur__c != '', 'Erreure présente');
        System.assertEquals(false, updatedUser.HP_Okta_Id__c != null, 'Id non récupéré');
    }

    @isTest 
    public static void deleteUserTestOk(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'users/email' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                    StaticResource.HP_OktaCreateUser_OK_MOCK.name(),
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),
            'api/v1/users' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204,
                                                    null,
                                                   new Map<String, String> {'Content-Type' => 'application/json'})
        };
        HP_PortailUtilisateur__c user = [SELECT Id, HP_Okta_Status__c, HP_Okta_Erreur__c, HP_Okta_Id__c FROM HP_PortailUtilisateur__c WHERE Login__c = 'email' LIMIT 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM072_Okta_Users_Manager.suppressionUtilisateur(user.Id);
        Test.stopTest();
        HP_PortailUtilisateur__c updatedUser = [SELECT Id, HP_Okta_Status__c, HP_Okta_Erreur__c, HP_Okta_Id__c FROM HP_PortailUtilisateur__c WHERE Login__c = 'email' LIMIT 1];
        System.assertEquals(false, updatedUser.HP_Okta_Id__c != null, 'Id supprimé');
    }

    @isTest 
    public static void deleteUserTestKo(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'users/email' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                    StaticResource.HP_OktaCreateUser_OK_MOCK.name(),
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),
            'api/v1/users' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400,
                                                    StaticResource.HP_OktaCreateUser_KO_MOCK.name(),
                                                   new Map<String, String> {'Content-Type' => 'application/json'})
        };
        HP_PortailUtilisateur__c user = [SELECT Id, HP_Okta_Status__c, HP_Okta_Erreur__c, HP_Okta_Id__c FROM HP_PortailUtilisateur__c WHERE Login__c = 'email' LIMIT 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM072_Okta_Users_Manager.suppressionUtilisateur(user.Id);
        Test.stopTest();
        HP_PortailUtilisateur__c updatedUser = [SELECT Id, HP_Okta_Status__c, HP_Okta_Erreur__c, HP_Okta_Id__c FROM HP_PortailUtilisateur__c WHERE Login__c = 'email' LIMIT 1];
        System.assertEquals('KO', updatedUser.HP_Okta_Status__c, 'Statut Ko');
        System.assertEquals(true, updatedUser.HP_Okta_Erreur__c != '', 'Erreure présente');
    }

    @isTest 
    public static void updateUserPasswordTestOk(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'users/email' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                    StaticResource.HP_OktaCreateUser_OK_MOCK.name(),
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),
            'api/v1/users' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                    StaticResource.HP_OktaCreateUser_OK_MOCK.name(),
                                                   new Map<String, String> {'Content-Type' => 'application/json'})
        };
        HP_PortailUtilisateur__c user = [SELECT Id, HP_Okta_Status__c, HP_Okta_Erreur__c, HP_Okta_Id__c FROM HP_PortailUtilisateur__c WHERE Login__c = 'email' LIMIT 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM072_Okta_Users_Manager.modificationMDP(user.Id, 'NewP@ssw0rd!21');
        Test.stopTest();
        HP_PortailUtilisateur__c updatedUser = [SELECT Id, HP_Okta_Status__c, HP_Okta_Erreur__c, HP_Okta_Id__c, Password__c FROM HP_PortailUtilisateur__c WHERE Login__c = 'email' LIMIT 1];
        System.assertEquals('OK', updatedUser.HP_Okta_Status__c, 'Statut Ok');
        System.assertEquals('NewP@ssw0rd!21', updatedUser.Password__c , 'Mot de passe mis à jour');
    }

    @isTest 
    public static void updateUserPasswordTestKo(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'api/v1/users' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400,
                                                    StaticResource.HP_OktaCreateUser_KO_MOCK.name(),
                                                   new Map<String, String> {'Content-Type' => 'application/json'})
        };
        HP_PortailUtilisateur__c user = [SELECT Id, HP_Okta_Status__c, HP_Okta_Erreur__c, HP_Okta_Id__c FROM HP_PortailUtilisateur__c WHERE Login__c = 'email' LIMIT 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM072_Okta_Users_Manager.modificationMDP(user.Id, 'NewPassword');
        Test.stopTest();
        HP_PortailUtilisateur__c updatedUser = [SELECT Id, HP_Okta_Status__c, HP_Okta_Erreur__c, HP_Okta_Id__c FROM HP_PortailUtilisateur__c WHERE Login__c = 'email' LIMIT 1];
        System.assertEquals('KO', updatedUser.HP_Okta_Status__c, 'Statut Ko');
        System.assertEquals(true, updatedUser.HP_Okta_Erreur__c != '', 'Erreure présente');
    }
}