/**
 * @File Name          : HP_BAT008_NettoyageLogCallOut_TEST.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 

 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 19/06/2020 à 16:13:14

 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/04/2020   Mouhamadoune Coulibaly     Initial Version
**/
@istest
public with sharing class HP_BAT008_NettoyageLogCallOut_TEST {
   
    
    @testSetup static void dataSetup(){

        /*

        HP_LOG_CALLOUT__b logB = (HP_LOG_CALLOUT__b)HP_UTIL_SmartFactory.createSObject('HP_LOG_CALLOUT__b', null, new Map<String, Object>{
            'Date__c' => System.now().addDays(-30),
            'User_Id__c'=>UserInfo.getUserId(),
            'Key_Row__c'=>'K'+ System.now().addDays(-30).getTime() +Integer.valueof(Math.random() * 9999),
            'Status__c'=> 200
        }, null, null, null);

            insert logB;
            //Database.insertAsync(logB);
            //Database.insertImmediate(logB) ;
            //*/


        HP_Parameters__c param = (HP_Parameters__c)HP_UTIL_SmartFactory.createSObject('HP_Parameters__c', null, new Map<String, Object> {
			'Cycle_Purge_Log__c' =>15
		}, null, null,null);
		insert param;

    }

    @isTEST
    static void isExecute(){

        Test.startTest();
        Database.executeBatch(new HP_BAT008_NettoyageLogCallOut());
        Test.stopTest();
        System.assertEquals(0, (Integer)[select count() from HP_LOG_CALLOUT__b]);
    }
}