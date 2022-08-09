/*
*@Author: Clément Bouquin
*@Description: Classe test de VI_SM049_LocauxContrats.
*@CreatedDate: 27/01/2022
*@LastModified: 01/02/2022
*/

@isTest
public class VI_SM049_LocauxContrats_Test {
    
	@isTest
    public static void callLocauxContrats_test1() {
        
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_PorteFeuilleContrat_Mock');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        String testdata=VI_SM049_LocauxContrats.callLocauxContrats('1234', 'VI', 'local.VIToken');
        system.debug('testdata '+testdata);
        Test.stopTest();

	}
    
    @isTest
    public static void callLocauxContrats_test2() {
        
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_PorteFeuilleContrat_Mock');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        String testdata=VI_SM049_LocauxContrats.callLocauxContrats('', 'VI', 'local.VIToken');
        system.debug('testdata '+testdata);
        Test.stopTest();

	}

}