/*
* @Author: Mohamed Kchaou
* @Date: 11/02/2019
* @Description: Test Class for SM_AP12_PdlGaz
*/
@isTest
public class SM_AP12_PdlGaz_Test {
    @testSetup 
    static void setup() {
        SM_AP08_TestLib.insertCS_SMOCTOPUS();
    }

    /*
    * @Author: Mohamed Kchaou
    * @Date: 11/02/2019
    * @Description: Test Class for SM_AP12_PdlGaz
    */
    @isTest 
    static void testCallout() {
        Test.startTest();

        Map < String, Object > input = new Map < String, Object > ();
        Map < String, Object > chois = new Map < String, Object > ();
        chois.put('selectedPCEVal', '21101817097249');
        input.put('ChoixElements1', chois);
        Map < String, Object > output = new Map < String, Object > ();
        SM_AP12_PdlGaz service = new SM_AP12_PdlGaz();
        service.invokeMethod('lirePdlGaz', input, output, null);
        SM_AP12_PdlGaz.PdlInfo objectTest = new SM_AP12_PdlGaz.PdlInfo(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null, null, null,null,null,null,null);
        SM_AP12_PdlGaz.Mesures mesure = new SM_AP12_PdlGaz.Mesures(null,null);

        Test.stopTest();
    }
}