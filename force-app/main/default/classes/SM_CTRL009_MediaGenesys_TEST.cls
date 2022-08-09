/**
 * @description       : Test Class for SM_CTRL009_MediaGenesys
 * @author            : Mohamed Aamer
 * @last modified on  : 01-18-2022
 * @last modified by  : Mohamed Aamer
 * @version           : 1.0
**/
@isTest
public with sharing class SM_CTRL009_MediaGenesys_TEST {
    
    @isTest
    private static void testGenesysUser(){
        Test.startTest();
        String userId = 'test-id';
        String response = SM_CTRL009_MediaGenesys.getGenesysUserId('testEndpoint','aa@bb.cc');
        Test.stopTest();
        System.assertEquals(userId, response, 'Genesys user id récupéré est null');
    }

    
      @isTest
    private static void testgetAllowedMediaTypes(){
        List<SM_Media_Queue__mdt> Ls = SM_Media_Queue__mdt.getAll().values();
        System.assertEquals(Ls,SM_CTRL009_MediaGenesys.getAllowedMediaTypes(), 'Allowed Type not comptible');
    }
     @isTest
    private static void testgetMediaConfig(){
        Test.startTest();
        HttpRequestService__mdt GENESYS_REQUEST_SERVICE = SM_CTRL009_MediaGenesys.getMediaConfig();
        HttpRequestService__mdt Media = HttpRequestService__mdt.getInstance('GENESYS');
        Test.stopTest();
        System.assertEquals(GENESYS_REQUEST_SERVICE,Media,'ERROR');
    }

    @isTest
    private static void testGetMedia(){
        String json = '{"entities":[{"name":"","joined":true,"id":"test-id"}]}';
        Test.startTest();
        SM_WRP004_GenesysMedia response = SM_CTRL009_MediaGenesys.getMedias('testEndpoint','test-id','1');
        String respString = System.JSON.serialize(response);
        Test.stopTest();
        System.assertEquals(json, respString, 'Genesys Media wrapper');
    }

    @isTest
    private static void testPatchMedia(){
        Test.startTest();
        Integer statusCode = 200;
        Integer response = SM_CTRL009_MediaGenesys.patchMedias('testEndpoint','test-id', '');
        Test.stopTest();
        System.assertEquals(statusCode, response, 'Média mise à jour');
    }
    
}