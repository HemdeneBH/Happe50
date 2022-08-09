@isTest 
public with sharing class HP_BAT000_BatchMaster_TEST {

    @TestSetup
    static void makeData(){

       HP_Parameters__c param = (HP_Parameters__c)HP_UTIL_SmartFactory.createSObject('HP_Parameters__c', null, new Map<String, Object> {
			'Cycle_Purge_Log__c' =>15
		}, null, null,null);
		insert param;

        HP_LOG_WS__c log = (HP_LOG_WS__c)HP_UTIL_SmartFactory.createSObject('HP_LOG_WS__c', null, new Map<String, Object>{
            'Date__c' => System.now().addDays(-30)
        }, null, null, null);
        insert log;
        
    }

    @IsTest
    static void  main_TEST(){

     	HP_BAT006_NettoyageLog.execute();
        Test.startTest();
        HP_BAT000_BatchMaster.main();
        Test.stopTest(); 
        
    }

}