/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_SM032_DemanderSignature
*@CreatedDate: 15/03/2021
*/
@isTest
public class VI_SM032_DemanderSignature_Test {
    @isTest
    static void testdemanderSignature(){
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestDemanderSignature');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        String idDocument=VI_SM032_DemanderSignature.demanderSignature(
            '00S012453607','0304596236','EMAIL','Test@external.gdfsuez-it.com',
            'PP','3','callout:VI_AuthOctopus'
        );
        System.assertEquals(idDocument, 'OCTOPUS_DemanderSignature_01Traitement effectué sans erreur'); 
        Test.stopTest();

    }
}