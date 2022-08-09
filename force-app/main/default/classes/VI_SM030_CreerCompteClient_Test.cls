/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_SM030_CreerCompteClient
*@CreatedDate: 15/03/2021
*/
@isTest
public class VI_SM030_CreerCompteClient_Test {
    @isTest
    static void CreerCompteClient(){
        Test.startTest();
        String retour=VI_SM030_CreerCompteClient.CreerCompteClient('+14B','01','01','test','PP','5.0','callout:VI_AuthOctopus');
        system.assertEquals(retour, '000516694472');
        Test.stopTest();
    }
}