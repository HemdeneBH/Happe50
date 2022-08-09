/**
 * @description       : Classe de test pour la classe SM_SM007_AdministrationEquipes
 * @author            : Mohamed Aamer
 * @last modified on  : 04-20-2022
 * @last modified by  : Mohamed Aamer
**/
@isTest
public with sharing class SM_SM007_AdministrationEquipes_TEST {

    @testSetup static void dataSetup(){

        User user = SM_TestDataFactory.createUser('ter', 'email@email.com', 'hyperviseur', 'hyperviseur@username-engie.com', 'System administrator');
        User userResp = SM_TestDataFactory.createUser('ter', 'email@email.com', 'responsable', 'responsable@username-engie.com', 'System administrator');
        User userCons = SM_TestDataFactory.createUser('ter', 'email@email.com', 'conseillerA', 'conseiller@username-engie.com', 'System administrator');
        User userSansRole = SM_TestDataFactory.createUser('ter', 'email@email.com', 'sansrole', 'sansrole@username-engie.com', 'System administrator');
        
        user.IsActive = true;
        user.Trigramme_Site__c = 'CAE';
        user.Trigramme_Presta__c = 'ARM';
        insert user;

        UserRole roleResp = SM_TestDataFactory.createUserRole('ARM_CAE_Responsable_Equipe_1');
        UserRole roleCons = SM_TestDataFactory.createUserRole('ARM_CAE_Conseiller_1');
        insert roleResp;
        insert roleCons;

        userResp.IsActive = true;
        userResp.Trigramme_Site__c = 'CAE';
        userResp.Trigramme_Presta__c = 'ARM';
        userResp.UserRoleId = roleResp.Id;
        insert userResp;

        userCons.IsActive = true;
        userCons.Trigramme_Site__c = 'CAE';
        userCons.Trigramme_Presta__c = 'ARM';
        userCons.UserRoleId = roleCons.Id;
        insert userCons;

        userSansRole.IsActive = true;
        userSansRole.Trigramme_Site__c = 'CAE';
        userSansRole.Trigramme_Presta__c = 'ARM';
        insert userSansRole;
    }
    
    @isTest static void getEquipesTest(){
        User user = [Select Id From User Where LastName='hyperviseur'];

        System.runAs(user){
            Test.startTest();
            Set<ID> userIds = new Set<ID>{user.Id};
            String trigrammePresta = 'ARM';
            String trigrammeSite = 'CAE';
            String userSiteName = 'ARM_CAE';
            Map<String,Object> result = SM_SM007_AdministrationEquipes.getEquipes(userIds, trigrammePresta, trigrammeSite, userSiteName);
            Test.stopTest();
            System.assertEquals(userSiteName, result.get('site'),'site match');
        }
    }

    @isTest static void updateUsersTest(){
        User user = [Select Id From User Where LastName='hyperviseur'];
        User oldUser = [Select Id From User Where LastName='conseillerA'];
        User newUser = [Select Id From User Where LastName='sansrole'];

        System.runAs(user){
            Test.startTest();
            String json = '{\"oldUsers\":[{\"label\":\"conseillerA\",\"value\":\"conseiller@username-engie.com\",\"role\":\"ARM_CAE_Conseiller_1\"}],\"newUsers\":[{\"label\":\"sansrole\",\"value\":\"sansrole@username-engie.com\",\"role\":\"ARM_CAE_Conseiller_2\"}],\"role\":\"ARM_CAE_Conseiller_2\"}';

            SM_SM007_AdministrationEquipes.updateUsers(json);
            Test.stopTest();
            User updatedUser = [Select UserRole.Name, Username, LastName From User Where LastName = 'sansrole'];

            System.assertEquals('ARM_CAE_Conseiller_2', updatedUser.UserRole.Name,'user updated');
        }
    }
}