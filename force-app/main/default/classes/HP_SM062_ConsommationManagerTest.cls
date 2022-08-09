/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 06-21-2021
 * @last modified by  : Hemdene Ben Hammouda
 * Modifications Log 
 * Ver   Date         Author                 Modification
 * 1.0   06-21-2021   Hemdene Ben Hammouda   Initial Version
**/
@isTest
public class HP_SM062_ConsommationManagerTest {
    @isTest
    static void testGetConsommationElecOk(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                   'HP_APIHourAccessTokenResponse_MOCK',
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),

            'api/v1/personnes/afficher_consommation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                  'HP_HisotiqueConsommationELEC_OK',
                                                  new Map<String, String> { 'Content-Type' => 'application/json'}
                                                  )
        };
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        List<HP_SM062_ConsommationManager.HP_WRP040_ConsommationManagerELEC> resultsList= HP_SM062_ConsommationManager.getConsommationELEC(1853207,'16426338583401');
        Test.stopTest();
        System.assertEquals(7, resultsList.size()); 
    }

    @isTest
    static void testGetConsommationGazOk(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                   'HP_APIHourAccessTokenResponse_MOCK',
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),

            'api/v1/personnes/afficher_consommation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                  'HP_HisotiqueConsommationGAZ_OK',
                                                  new Map<String, String> { 'Content-Type' => 'application/json'}
                                                  )
        };
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        List<HP_SM062_ConsommationManager.HP_WRP041_ConsommationManagerGAZ> resultsList= HP_SM062_ConsommationManager.getConsommationGAZ(1853207,'21101817244517');
        Test.stopTest();
        System.assertEquals(3, resultsList.size()); 
    }

    @isTest
    static void testGetConsommationGazKo(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                   'HP_APIHourAccessTokenResponse_MOCK',
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),

            'api/v1/personnes/afficher_consommation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(422,
                                                  'HP_HisotiqueConsommationGAZ_KO',
                                                  new Map<String, String> { 'Content-Type' => 'application/json'}
                                                  )
        };
        List<HP_SM062_ConsommationManager.HP_WRP041_ConsommationManagerGAZ> resultsList = new List<HP_SM062_ConsommationManager.HP_WRP041_ConsommationManagerGAZ>();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        try{
             resultsList= HP_SM062_ConsommationManager.getConsommationGAZ(1853207,'211018172445');
        }catch(Exception ex){
            System.assertEquals('System.AuraHandledException', ex.getTypeName());
        }
        Test.stopTest();
        System.assertEquals(0, resultsList.size()); 
    }

    @isTest
    static void testGetConsommationElecKo(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                   'HP_APIHourAccessTokenResponse_MOCK',
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),

            'api/v1/personnes/afficher_consommation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(422,
                                                  'HP_HisotiqueConsommationELEC_KO',
                                                  new Map<String, String> { 'Content-Type' => 'application/json'}
                                                  )
        };
        List<HP_SM062_ConsommationManager.HP_WRP040_ConsommationManagerELEC> resultsList = new List<HP_SM062_ConsommationManager.HP_WRP040_ConsommationManagerELEC>();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        try{
            resultsList = HP_SM062_ConsommationManager.getConsommationELEC(1853207,'164263385834');
        }catch(Exception ex){
            System.assertEquals('System.AuraHandledException', ex.getTypeName());
        }
        Test.stopTest();
        System.assertEquals(0, resultsList.size()); 
    }

    @isTest
    static void testGetConsommationGazEmptyPce(){
        Test.startTest();
        List<HP_SM062_ConsommationManager.HP_WRP041_ConsommationManagerGAZ> resultsList= HP_SM062_ConsommationManager.getConsommationGAZ(1853207,'');
        Test.stopTest();
        System.assertEquals(0, resultsList.size()); 
    }

    @isTest
    static void testGetConsommationElecEmptyPce(){
        Test.startTest();
        List<HP_SM062_ConsommationManager.HP_WRP040_ConsommationManagerELEC> resultsList= HP_SM062_ConsommationManager.getConsommationELEC(1853207,'');
        Test.stopTest();
        System.assertEquals(0, resultsList.size()); 
    }

    @isTest
    static void testGetConsommationGazEmptyIdXdata(){
        List<HP_SM062_ConsommationManager.HP_WRP041_ConsommationManagerGAZ> resultsList = new List<HP_SM062_ConsommationManager.HP_WRP041_ConsommationManagerGAZ>();
        Test.startTest();
        try{
            resultsList = HP_SM062_ConsommationManager.getConsommationGAZ(null,'164263385834');
        }catch(Exception ex){
            System.assertEquals('System.AuraHandledException', ex.getTypeName());
        }
        Test.stopTest();
        System.assertEquals(0, resultsList.size()); 
    }

    @isTest
    static void testGetConsommationElecEmptyIdXdata(){
        List<HP_SM062_ConsommationManager.HP_WRP040_ConsommationManagerELEC> resultsList = new List<HP_SM062_ConsommationManager.HP_WRP040_ConsommationManagerELEC>();
        Test.startTest();
        try{
            resultsList = HP_SM062_ConsommationManager.getConsommationELEC(null,'164263385834');
        }catch(Exception ex){
            System.assertEquals('System.AuraHandledException', ex.getTypeName());
        }
        Test.stopTest();
        System.assertEquals(0, resultsList.size()); 
    }
}