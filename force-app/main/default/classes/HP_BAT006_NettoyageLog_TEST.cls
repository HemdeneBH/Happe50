/**
 * @File Name          : HP_BAT006_NettoyageLog_TEST.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 27/04/2020 à 13:34:57
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/04/2020   Mouhamadoune Coulibaly     Initial Version
**/
@ISTEST
public with sharing class HP_BAT006_NettoyageLog_TEST {




    @testSetup static void dataSetup(){

        HP_Parameters__c param = (HP_Parameters__c)HP_UTIL_SmartFactory.createSObject('HP_Parameters__c', null, new Map<String, Object> {
			'Cycle_Purge_Log__c' =>15
		}, null, null,null);
		insert param;

        HP_LOG_WS__c log = (HP_LOG_WS__c)HP_UTIL_SmartFactory.createSObject('HP_LOG_WS__c', null, new Map<String, Object>{
            'Date__c' => System.now().addDays(-30)
        }, null, null, null);
        insert log;
        
    }
    @isTEST
    static void isExecute(){

        Test.startTest();
        HP_BAT006_NettoyageLog.execute();
        Test.stopTest();
        System.assertEquals(0, (Integer)[select count() from HP_LOG_WS__c]);
    }
    
     @isTEST
    static void scheduleTest(){

        Test.startTest();
        HP_BAT006_NettoyageLog.launchNewScheduler('0 0 23 ? * * *','xxx');
        Test.stopTest();
       
    }
}