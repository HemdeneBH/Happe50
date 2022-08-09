/*
*@Author: Paul Ghousoub
*@Description: Classe test de VI_SM006_ZoneDistributionApiService.
*@CreatedDate: 04/11/2020
*@LastModified: 05/11/2020
*/
@isTest
public class VI_SM006_ZoneDistributionApiService_Test {
    @isTest
    static void testZoneDistrib(){
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestZoneDistrib');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        VI_SM006_ZoneDistributionApiService.ZoneDeDistributionResponse testResponse=VI_SM006_ZoneDistributionApiService.callZoneDistribitionByCodeInsee('test','test','test','test','test','test','VI', 'local.VIToken');
        system.assertEquals(testResponse.data[0].appartientRegie, 'non');
        Test.stopTest();
    }
}