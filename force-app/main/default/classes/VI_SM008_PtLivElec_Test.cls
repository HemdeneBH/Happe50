/*
*@Author: Paul Ghousoub
*@Description: Classe test de VI_SM008_PtLivElec.
*@CreatedDate: 04/11/2020
*@LastModified: 05/11/2020
*/
@isTest
public class VI_SM008_PtLivElec_Test { 
    @isTest
    static void testPtLivElec(){
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestIPPTLElec');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        VI_SM008_PtLivElec.PointLivraisonElecResponse testResponse=VI_SM008_PtLivElec.API_PtLivElec('23198697384673','2','2' ,'VI', 'local.VIToken');
        system.assertEquals(testResponse.data[0].cdUniteReleve, 'A30330EB');
        VI_SM008_PtLivElec.API_PtLivElec(null,'2','2' ,'VI', 'local.VIToken');
        Test.stopTest();
    }
}