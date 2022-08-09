/**
 * @description       : Test Class for SM_DM007_UserRole
 * @author            : Mohamed Aamer
 * @group             : 
 * @last modified on  : 04-15-2022
 * @last modified by  : Mohamed Aamer
**/
@IsTest
public with sharing class SM_DM007_UserRole_TEST {

    @testSetup static void dataSetup(){

        User user = SM_TestDataFactory.createUser('ter', 'email@email.com', 'lastName', 'username_Test@username-engie.com', 'System administrator');
        user.IsActive = true;
        user.Trigramme_Site__c = 'CAE';
        insert user;

        UserRole userRole = SM_TestDataFactory.createUserRole('testRole');
        insert userRole;
    }

    @isTest static void retrieveInfosByIdsTest(){

        User user = [Select Id From User Where UserName='username_Test@username-engie.com'];
        String roleName = [Select Id,Name From UserRole Where Name='testRole']?.Name;
        System.runAs(user){
            List<String> names = new List<String>{roleName};
            String expectedRoleName = 'testRole';
            Test.startTest();
            List<UserRole> userRolesList = SM_DM007_UserRole.retrieveInfosByNames(names);
            UserRole userRole = userRolesList.get(0);
            System.assertEquals(expectedRoleName, userRole.Name,'userrole retreived');
            Test.stopTest();
        }
    }
}