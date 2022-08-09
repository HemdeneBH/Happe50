/*
*@Author: Paul Ghousoub
*@Description: Classe test de VI_SM002_AdresseDQE.
*@CreatedDate: 04/11/2020
*@LastModified: 05/11/2020
*/
@isTest
public class VI_SM002_AdresseDQE_Test {
    @isTest
    public static void testAdresse(){
    StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestDQEAdresse');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json'); 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        List<Map<String, Object>> returnvalue=VI_SM002_AdresseDQE.getSuggestionsComplementDQE('1454798','185', 'VI', 'local.VIToken');
        System.assertEquals(returnvalue[0].get('label'), 'testBatiment');
        Test.stopTest();
    }
    
    @isTest
    public static void testComplement(){
    StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestDQEAdresse');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        List<VI_SM002_AdresseDQE.AdressesWrapper> testList=new List<VI_SM002_AdresseDQE.AdressesWrapper>();
        Test.setMock(HttpCalloutMock.class, multimock);
        testList=VI_SM002_AdresseDQE.getSuggestionsAdresseDQE('as', 'VI', 'local.VIToken');
        system.assertEquals(testList[0].codePostal, '75010');
        Test.stopTest();
    }
    
    @isTest
    public static void test_getSuggestionsCodePostalWrapper(){
    StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestDQEAdresse');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        List<VI_SM002_AdresseDQE.AdressesWrapper> testList=new List<VI_SM002_AdresseDQE.AdressesWrapper>();
        Test.setMock(HttpCalloutMock.class, multimock);
        testList=VI_SM002_AdresseDQE.getSuggestionsCodePostalWrapper('75010', 'VI', 'local.VIToken');
        system.assertEquals(testList[0].codePostal, '75010');
        Test.stopTest();
    }
    
    @isTest
    public static void test_getSuggestionsCodePostalWrapperMap(){
    StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestDQEAdresse');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        Map<String,VI_SM002_AdresseDQE.AdressesWrapper> testMap=new Map<String,VI_SM002_AdresseDQE.AdressesWrapper>();
        Test.setMock(HttpCalloutMock.class, multimock);
        testMap=VI_SM002_AdresseDQE.getSuggestionsCodePostalWrapperMap('75010', 'VI', 'local.VIToken');
        system.assertequals(testMap.get('Paris').codePostal,'75010');
        system.debug('testmap '+testmap);
        Test.stopTest();
    }
    @isTest
    public static void test_getSuggestionsCodePostal(){
    StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestDQEAdresse');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        Set<String> testSet=new Set<String>();
        Test.setMock(HttpCalloutMock.class, multimock);
        testSet=VI_SM002_AdresseDQE.getSuggestionsCodePostal('75010', 'VI', 'local.VIToken');
        system.debug('testSet'+ testSet);
        Test.stopTest();
    }
    
    @isTest
    public static void test_getSuggestionsCodePostalMap(){
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestDQEAdresse');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        Map<String,String> testSet=new Map<String,String>();
        Test.setMock(HttpCalloutMock.class, multimock);
        testSet=VI_SM002_AdresseDQE.getSuggestionsCodePostalMap('75010', 'VI', 'local.VIToken');
        system.debug('testSet'+ testSet);
        Test.stopTest();
    }
    
    
}