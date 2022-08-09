/*
*@Author: Clément Bouquin
*@Description: Classe test de VI_SM047_PorteFeuilleContrat.
*@CreatedDate: 27/01/2022
*@LastModified: 01/02/2022
*/

@isTest
public class VI_SM047_PorteFeuilleContrat_Test {
    
	@isTest
    public static void callPortefeuilleContrat_test1() {
        
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_PorteFeuilleContrat_Mock');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        String testdata=VI_SM047_PorteFeuilleContrat.callPortefeuilleContrat('1234', 'VI', 'local.VIToken');
        
        system.debug('testdata :'+testdata);
        //system.assertEquals('OK', testdata);
        Test.stopTest();

	}
    
    @isTest
    public static void callPortefeuilleContrat_test2() {
        
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_PorteFeuilleContrat_Mock');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        String testdata=VI_SM047_PorteFeuilleContrat.callPortefeuilleContrat('', 'VI', 'local.VIToken');
        
        system.debug('testdata :'+testdata);
        //system.assertEquals('OK', testdata);
        Test.stopTest();

	}

}