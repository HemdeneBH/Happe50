/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_SM028_BanquesApiService
*@CreatedDate: 15/03/2021
*/
@isTest
public class VI_SM028_BanquesApiService_Test {
	@isTest
    static void testgetInstitutBanqueByIBAN(){
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestBanquesApiService');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        String nomBanque=VI_SM028_BanquesApiService.getInstitutBanqueByIBAN('FR1930002005680000876440G50','VI','local.VIToken');
        System.assertEquals(nomBanque, 'Banque de test'); 
        Test.stopTest();
    }
}