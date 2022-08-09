/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_SM033_ServiceDocument
*@CreatedDate: 15/03/2021
*/
@isTest
public class VI_SM033_ServiceDocument_Test {
    @isTest
    static void testlireDocument(){
        Test.startTest();
        String mandat=VI_SM033_ServiceDocument.lireDocument('1',null,null,'HUBEONE',false,'VI','local.VIToken','callout:VI_AuthOctopus');
        System.assertEquals(mandat, 'aaaaa'); 
        Test.stopTest();
    }
}