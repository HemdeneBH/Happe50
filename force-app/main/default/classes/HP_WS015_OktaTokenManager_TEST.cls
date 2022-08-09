/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 03-01-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_WS015_OktaTokenManager_TEST {
    
    @TestSetup
    static void setupData(){
        HP_Okta_Token_Parameter__c settings = HP_Okta_Token_Parameter__c.getOrgDefaults();
        settings.Encryption_Key__c = '8cPkWGCoHv9a3D7K';
        settings.Encryption_Code__c = 'AES128';
        upsert settings HP_Okta_Token_Parameter__c.Id;
    }

    @isTest
    static void updateOktaTokenTestOK(){

        RestRequest reqHttp = new RestRequest();
        RestResponse resHttp = new RestResponse();
        String requestBody = '{"token" : "3VyszXPreriqhotjnXY08"}';
        reqHttp.requestBody = Blob.valueof(requestBody);
        RestContext.request = reqHttp;
        RestContext.response = resHttp;


        Test.startTest();
        HP_WS015_OktaTokenManager.updateOktaToken();
        Test.stopTest();

        System.assert (HP_HttpStatus.OK == resHttp.statusCode, 'Token mis à jour correctement');
    }

    @isTest
    static void updateOktaTokenTestKO(){

        RestRequest reqHttp = new RestRequest();
        RestResponse resHttp = new RestResponse();
        String requestBody = '{"token" : ""}';
        reqHttp.requestBody = Blob.valueof(requestBody);
        RestContext.request = reqHttp;
        RestContext.response = resHttp;


        Test.startTest();
        HP_WS015_OktaTokenManager.updateOktaToken();
        Test.stopTest();

        System.assert (HP_HttpStatus.BAD_REQUEST == resHttp.statusCode, 'Token ne peut pas être vide');
    }
}