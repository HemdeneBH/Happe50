@isTest
public with sharing class HP_EM042_User_TEST {

    @testSetup static void dataSetup(){        
        HP_UTIL_SmartFactory.insertUserHP();        
    }

    @isTest
    public static void getHPUsers() {
       
        Test.startTest();
        HP_EM042_User.getHPUsers(); 
        Test.stopTest();    
    }
    
    @isTest
    public static void getCurrentUser() {
       
        Test.startTest();
        HP_EM042_User.getQueryLocatorCurrentUser(); 
        Test.stopTest();
    }

    @isTest
    public static void getQueryLocatorHPUsers() {
  
        Test.startTest();
        HP_EM042_User.getQueryLocatorHPUsers(); 
        Test.stopTest();
    
    }
}