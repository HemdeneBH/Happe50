/**
 * @File Name          : HP_WS008_ResiliationCase_TEST.cls
 * @Description        : Test class for WS ResiliationCase : '/case/cancelation/*'
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 15/04/2020 à 16:04:11
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    15/04/2020   Sara El-Hannaoui     Initial Version
**/
@isTest
public with sharing class HP_WS008_ResiliationCase_TEST {

   
	private enum StaticResource {
        HP_CancelationCaseRestResourceElec_TEST

	}

    @testSetup static void initData() {
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object>{
                'LastName' => 'Test Lastname',
                'Id_Tiers__c' => 195464
            }, null, null, null);
            insert contact;
        }
    }

    @isTest
    public static void updateIndexOK() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            final String cancelationCaseRestResourceModelElecJson = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_CancelationCaseRestResourceElec_TEST.name());
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
            RestContext.request = reqHttp;
            RestContext.response= resHttp;
            reqHttp.requestBody = Blob.valueof(cancelationCaseRestResourceModelElecJson);
            
            Test.startTest();
            HP_WS008_ResiliationCase.firstUpdate();
            Test.stopTest();
            System.assertEquals(200, resHttp.statusCode , 'Contract and Case upserted.');
        }
    }

}