/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: Test Class for SM_AP19_ConfirmerSignature
*/
@isTest
public class SM_AP19_ConfirmerSignature_Test {
    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: setup test method
    */
    @testSetup static void setup() {
        SM_AP08_TestLib.insertCS_SMOCTOPUS();
    }

    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: method to test invoke confirmerSignature
    */
    @isTest static void testCallout() {
        Test.startTest();

        Map < String, Object > input = new Map < String, Object > ();
        Map<String, Object> codeBlock = new Map<String, Object>();
        codeBlock.put('codeVerif', '1691415151');
        codeBlock.put('idMandatFormula', '144946546489');
        Map<String, Object>prelevementBloc = new Map<String, Object>();
        prelevementBloc.put('codeBlock', codeBlock);
        Map<String, Object> elements = new Map<String, Object> ();
        elements.put('PrelevementBlock', prelevementBloc);
        input.put('ServicesGestion', elements);
        input.put('SelectedMandat', '00S000127297');
        input.put('selectedCode', 'cxrk');
        input.put('createdIdMandat', '12345');
        Map < String, Object > output = new Map < String, Object > ();
        SM_AP19_ConfirmerSignature service = new SM_AP19_ConfirmerSignature();
        SM_AP19_ConfirmerSignatureMock.CODE_RETOUR_WS = 'OCTOPUS_ConfirmerSignature_01';
        service.invokeMethod('confirmerSignature', input, output, null);
        System.assertEquals('Code de confirmation envoyé, le prelevement automatique a bien été prise en compte', output.get('confirmerSign_ok'));
        Test.stopTest();
    }

    /*
    * @Author:MHA
    * @Date: 20/03/2019
    * @Description: method to test invoke confirmerSignature
    * @LastModified:MHA 20/03/2019
    */
    @isTest static void callConfirmerSignatureWithOutIdMandat() {
        Test.startTest();

        Map < String, Object > input = new Map < String, Object > ();
        Map<String, Object> codeBlock = new Map<String, Object>();
        codeBlock.put('codeVerif', '1691415151');
        codeBlock.put('idMandatFormula', '144946546489');
        Map<String, Object>prelevementBloc = new Map<String, Object>();
        prelevementBloc.put('codeBlock', codeBlock);
        Map<String, Object> elements = new Map<String, Object> ();
        elements.put('PrelevementBlock', prelevementBloc);
        input.put('ServicesGestion', elements);
        input.put('SelectedMandat', '00S000127297');
        input.put('selectedCode', 'cxrk');
        /*input.put('createdIdMandat','12345');*/
        Map < String, Object > output = new Map < String, Object > ();
        SM_AP19_ConfirmerSignature service = new SM_AP19_ConfirmerSignature();
        SM_AP19_ConfirmerSignatureMock.CODE_RETOUR_WS = 'OCTOPUS_ConfirmerSignature_01';
        service.invokeMethod('confirmerSignature', input, output, null);
        System.assertEquals('L\'id mandat est manquant', output.get('error'));
        Test.stopTest();
    }

    /*
    * @Author:MHA
    * @Date: 20/03/2019
    * @Description: method to test invoke confirmerSignature
    * @LastModified:MHA 20/03/2019
    */
    @isTest static void callConfirmerSignatureWithOutCodeVerif() {
        Test.startTest();

        Map < String, Object > input = new Map < String, Object > ();
        Map<String, Object> codeBlock = new Map<String, Object>();
        /*codeBlock.put('codeVerif', '1691415151');*/
        /*codeBlock.put('idMandatFormula', '144946546489');*/
        Map<String, Object>prelevementBloc = new Map<String, Object>();
        prelevementBloc.put('codeBlock', codeBlock);
        Map<String, Object> elements = new Map<String, Object> ();
        elements.put('PrelevementBlock', prelevementBloc);
        input.put('ServicesGestion', elements);
        input.put('SelectedMandat', '00S000127297');
        input.put('selectedCode', 'cxrk');
        input.put('createdIdMandat', '12345');
        Map < String, Object > output = new Map < String, Object > ();
        SM_AP19_ConfirmerSignature service = new SM_AP19_ConfirmerSignature();
        SM_AP19_ConfirmerSignatureMock.CODE_RETOUR_WS = 'OCTOPUS_ConfirmerSignature_01';
        service.invokeMethod('confirmerSignature', input, output, null);
        System.assertEquals('Le code de vérification est manquant', output.get('error'));
        Test.stopTest();
    }
    
    /*
    * @Author:MMA
    * @Date: 13/05/2019
    * @Description: Couvre le cas où le code retour égal OCTOPUS_ConfirmerSignature_04 à 09 et 99
    */
    @isTest static void callConfirmerSignatureErreur1() {
        Test.startTest();

        Map < String, Object > input = new Map < String, Object > ();
        Map<String, Object> codeBlock = new Map<String, Object>();
        codeBlock.put('codeVerif', '1691415151');
        codeBlock.put('idMandatFormula', '144946546489');
        Map<String, Object>prelevementBloc = new Map<String, Object>();
        prelevementBloc.put('codeBlock', codeBlock);
        Map<String, Object> elements = new Map<String, Object> ();
        elements.put('PrelevementBlock', prelevementBloc);
        input.put('ServicesGestion', elements);
        input.put('SelectedMandat', '00S000127297');
        input.put('selectedCode', 'cxrk');
        input.put('createdIdMandat', '12345');
        Map < String, Object > output = new Map < String, Object > ();
        SM_AP19_ConfirmerSignature service = new SM_AP19_ConfirmerSignature();
        SM_AP19_ConfirmerSignatureMock.CODE_RETOUR_WS = 'OCTOPUS_ConfirmerSignature_04';
        service.invokeMethod('confirmerSignature', input, output, null);
        System.assertEquals('Init', output.get('confirmerSign_ok'));
        Test.stopTest();
    }
    
    /*
    * @Author:MMA
    * @Date: 13/05/2019
    * @Description: Couvre le cas où le code retour égal OCTOPUS_ConfirmerSignature_02 et 03
    */
    @isTest static void callConfirmerSignatureErreur2() {
        Test.startTest();

        Map < String, Object > input = new Map < String, Object > ();
        Map<String, Object> codeBlock = new Map<String, Object>();
        codeBlock.put('codeVerif', '1691415151');
        codeBlock.put('idMandatFormula', '144946546489');
        Map<String, Object>prelevementBloc = new Map<String, Object>();
        prelevementBloc.put('codeBlock', codeBlock);
        Map<String, Object> elements = new Map<String, Object> ();
        elements.put('PrelevementBlock', prelevementBloc);
        input.put('ServicesGestion', elements);
        input.put('SelectedMandat', '00S000127297');
        input.put('selectedCode', 'cxrk');
        input.put('createdIdMandat', '12345');
        Map < String, Object > output = new Map < String, Object > ();
        SM_AP19_ConfirmerSignature service = new SM_AP19_ConfirmerSignature();
        SM_AP19_ConfirmerSignatureMock.CODE_RETOUR_WS = 'OCTOPUS_ConfirmerSignature_02';
        service.invokeMethod('confirmerSignature', input, output, null);
        System.assertEquals('Init', output.get('confirmerSign_ok'));
        Test.stopTest();
    }
}