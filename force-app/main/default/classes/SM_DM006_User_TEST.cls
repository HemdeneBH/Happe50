/**
 * @description       : Test Class for SM_DM006_User
 * @author            : Mohamed Aamer
 * @last modified on  : 04-20-2022
 * @last modified by  : Mohamed Aamer
**/
@IsTest
public with sharing class SM_DM006_User_TEST {
    
    @testSetup static void dataSetup(){

        User user = SM_TestDataFactory.createUser('ter', 'email@email.com', 'lastName', 'username_Test@username-engie.com', 'System administrator');
        user.IsActive = true;
        user.Trigramme_Site__c = 'CAE';
        insert user;
    }

    @isTest static void retrieveInfosByIdsTest(){
        
        User user = [Select Id,UserName,LastName From User Where UserName='username_Test@username-engie.com'];

        System.runAs(user){
            Set<ID> userIds = new Set<ID>{user.Id};
            String lastName = 'lastName';
            Test.startTest();
            List<User> usersList = SM_DM006_User.retrieveInfosByIds(userIds);
            User userRes = usersList.get(0);
            Test.stopTest();
            System.assertEquals(lastName, userRes.LastName,'user retreived');
        }
    }

    @isTest static void retrieveInfosByTrigrammeTest(){
        
        User user = [Select Id,LastName,UserName,Trigramme_Site__c From User Where UserName='username_Test@username-engie.com'];

        System.runAs(user){
            Set<ID> userIds = new Set<ID>{user.Id};
            String trigSite = 'CAE';
            Test.startTest();
            List<User> usersList = SM_DM006_User.retrieveInfosByIds(userIds);
            User userRes = usersList.get(0);
            Test.stopTest();
            System.assertEquals(trigSite, userRes.Trigramme_Site__c,'user retreived');
        }
    }

    @isTest static void retrieveInfosByUsernamesTest(){
        
        User user = [Select Id,LastName,Username From User Where UserName='username_Test@username-engie.com'];

        System.runAs(user){
            List<String> usernames = new List<String>{user.UserName};
            Test.startTest();
            List<User> usersList = SM_DM006_User.retrieveInfosByUsernames(usernames);
            User userRes = usersList.get(0);
            Test.stopTest();
            System.assertEquals('username_test@username-engie.com', userRes.UserName,'user retreived');
        }
    }
}