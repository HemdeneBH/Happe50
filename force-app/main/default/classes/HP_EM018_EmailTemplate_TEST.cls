@isTest
public with sharing class HP_EM018_EmailTemplate_TEST {

    @testSetup static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }
    
    @isTest static void getEmailTemplateByNameException_TEST(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Test.startTest();
            EmailTemplate em =  HP_EM018_EmailTemplate.getEmailTemplateByName('test');
            Test.stopTest();
            System.assertEquals(0, [SELECT count() FROM EmailTemplate WHERE developerName = : 'test'], 'Exception');
        }  
    }
}