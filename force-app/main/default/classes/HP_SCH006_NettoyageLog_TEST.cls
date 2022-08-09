/**
 * @File Name          : HP_SCH006_NettoyageLog_TEST.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 17/06/2020 à 01:24:00
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/06/2020   Vincent Albiser     Initial Version
**/
@isTest
public with sharing class HP_SCH006_NettoyageLog_TEST {


    @testSetup static void dataSetup(){

        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            HP_Parameters__c param = (HP_Parameters__c)HP_UTIL_SmartFactory.createSObject('HP_Parameters__c', null, new Map<String, Object> {
                'Cycle_Purge_Log__c' =>1
            }, null, null,null);
            insert param;
        }
    }

    @isTest static void launchNewScheduler_TEST(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Test.startTest();
            HP_SCH006_NettoyageLog.launchNewScheduler();
             Test.stopTest();
             System.assertEquals(2, [Select count() from AsyncApexJob],'job executed');
        }
    }
    
}