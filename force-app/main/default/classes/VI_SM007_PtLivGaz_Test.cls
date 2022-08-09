/*
*@Author: Paul Ghousoub
*@Description: Classe test de VI_SM007_PtLivGaz.
*@CreatedDate: 04/11/2020
*@LastModified: 05/11/2020
*/
@isTest 
public class VI_SM007_PtLivGaz_Test {
    @isTest
    static void testPtLivGaz(){
        Map<String,String> testMap=new Map<String,String>();
        testMap.put('numeroPointDeLivraison','06414471708129');
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestIPPTLGaz');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json'); 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        VI_SM007_PtLivGaz.PointLivraisonGazResponse testResponse= VI_SM007_PtLivGaz.API_PtLivGaz('21101817736807','2', '2', 'VI', 'local.VIToken');
        system.assertEquals(testResponse.data[0].cdUniteReleve, 'A30330DB');
        VI_SM007_PtLivGaz.API_PtLivGaz(null,null, null, 'VI', 'local.VIToken');
        Test.stopTest();
    }
}