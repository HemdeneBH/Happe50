/**
 * @description       : Classe de test pour la classe SM_CTRL011_AdministrationEquipes
 * @author            : Mohamed Aamer
 * @last modified on  : 04-13-2022
 * @last modified by  : Mohamed Aamer
**/
@isTest
public with sharing class SM_CTRL011_AdministrationEquipes_TEST {
    
    @testSetup static void dataSetup(){

        User user = SM_TestDataFactory.createUser('ter', 'email@email.com', 'hyperviseur', 'hyperviseur@username-engie.com', 'System administrator');
        user.IsActive = true;
        user.Trigramme_Site__c = 'CAE';
        user.Trigramme_Presta__c = 'ARM';
        insert user;
        
        UserRole roleCons = SM_TestDataFactory.createUserRole('ARM_CAE_Conseiller_1');
        insert roleCons;
        
        User userCons = SM_TestDataFactory.createUser('ter', 'email@email.com', 'conseiller', 'conseiller@username-engie.com', 'System administrator');
        userCons.IsActive = true;
        userCons.Trigramme_Site__c = 'CAE';
        userCons.Trigramme_Presta__c = 'ARM';
        userCons.UserRoleId = roleCons.Id;
        insert userCons;
        
        User userSansRole = SM_TestDataFactory.createUser('ter', 'email@email.com', 'sansrole', 'sansrole@username-engie.com', 'System administrator');
        userSansRole.IsActive = true;
        userSansRole.Trigramme_Site__c = 'CAE';
        userSansRole.Trigramme_Presta__c = 'ARM';
        insert userSansRole;
    }
    
    @isTest static void getEquipesTest(){
        User user = [Select Id From User Where UserName='hyperviseur@username-engie.com'];

        System.runAs(user){
            Test.startTest();
            String userSiteName = 'ARM_CAE';
            Map<String,Object> result = SM_CTRL011_AdministrationEquipes.getEquipes();
            Test.stopTest();
            System.assertEquals(userSiteName, result.get('site'),'site match');
        }
    }

    @isTest static void updateUsersTest(){
        User user = [Select Id From User Where LastName='hyperviseur'];

        System.runAs(user){
            Test.startTest();
            String json = '{\"oldUsers\":[{\"label\":\"conseiller\",\"value\":\"conseiller@username-engie.com\",\"role\":\"ARM_CAE_Conseiller_1\"}],\"newUsers\":[{\"label\":\"sansrole\",\"value\":\"sansrole@username-engie.com\",\"role\":\"ARM_CAE_Conseiller_2\"}],\"role\":\"ARM_CAE_Conseiller_2\"}';

            SM_CTRL011_AdministrationEquipes.updateUsers(json);
            Test.stopTest();
            User updatedUser = [Select UserRole.Name, Username, LastName From User Where LastName = 'sansrole'];

            System.assertEquals('ARM_CAE_Conseiller_2', updatedUser.UserRole.Name,'user updated');
        }
    }
}