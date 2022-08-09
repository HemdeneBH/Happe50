/*
*@Author: Eloi Dereeper
*@Description: Classe test de VI_SM012_Adresses.
*@CreatedDate: 04/11/2020
*@LastModified: 05/11/2020
*/
@isTest
public class VI_SM012_Adresses_Test {
    
    @isTest
    static void testCallAdresses(){
        Map<String, String> inputMap = new Map<String, String>();
        List<VI_SM012_Adresses.AdressesWrapper> testResponse= new List<VI_SM012_Adresses.AdressesWrapper>();
        inputMap.put('ville', 'Toulouse');
        inputMap.put('codePostal', '31500');
        inputMap.put('libelleVoie', 'Rue Jonquières');
        inputMap.put('numeroVoie', '8');
        
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_IpAdresses');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, multimock);
        testResponse=VI_SM012_Adresses.CallAdresses('Toulouse', '31500', 'Rue Jonquières', '8', 'VI', 'local.VIToken');
        system.debug(testResponse);
        system.assertEquals(testResponse[0].cityCode, '91432');
        Test.stopTest();
    }
    
}