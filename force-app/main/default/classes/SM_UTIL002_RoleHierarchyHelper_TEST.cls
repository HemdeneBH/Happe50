/**
 * @description       : Classe de test pour la classe SM_UTIL002_RoleHierarchyHelper
 * @author            : Mohamed Aamer
 * @last modified on  : 04-20-2022
 * @last modified by  : Mohamed Aamer
**/
@IsTest
public with sharing class SM_UTIL002_RoleHierarchyHelper_TEST {
    
    @testSetup static void dataSetup(){
        User user = SM_TestDataFactory.createUser('ter', 'email@email.com', 'hyperviseur', 'hyperviseur@username-engie.com', 'System administrator');
        insert user;

        UserRole roleResp = SM_TestDataFactory.createUserRole('ARM_CAE_Responsable_Equipe_1A');
        insert roleResp;
        
        UserRole roleCons = SM_TestDataFactory.createUserRole('ARM_CAE_Conseiller_1A');
        roleCons.ParentRoleId = roleResp.Id;
        insert roleCons;
    }

    @isTest static void getAllSubRoleNamesTest(){
        User user = [Select Id From User Where LastName='hyperviseur'];
        UserRole userRole = [Select Id,ParentRoleId From UserRole Where Name='ARM_CAE_Responsable_Equipe_1A'];

        System.runAs(user){
            Test.startTest();
            Set<ID> userRoleIds = new Set<ID>{userRole.Id};
            List<String> result = SM_UTIL002_RoleHierarchyHelper.getAllSubRoleNames(userRoleIds);
            Test.stopTest();
            System.assertEquals(1, result.size(),'result size match');
        }
    }
}