/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_SM034_ProcessusRelanceMandat
*@CreatedDate: 16/03/2021
*/
@isTest
public class VI_SM034_ProcessusRelanceMandat_Test {
     @isTest
    static void testrealancerMandat(){
        Test.startTest();
        VI_gdfsuezComBefChpRelanceMandat.demarrerRelanceMandatResponse_element response=
            VI_SM034_ProcessusRelanceMandat.relancerMandat('0304596236',null,null,null,'VI','local.VIToken','callout:VI_AuthOctopus');
        system.assertEquals(response.demarrerRelanceMandatOutput.idProcessus,'1234');
        Test.stopTest();
    }
}