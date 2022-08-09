@isTest
/*@author: MKC
*@Description: Test de la classe de mise à jour du compte client
*@CreatedDate: 01/02/2019
*@LastModified: mHA 21/03/2019
*/
public class SM_AP20_MajCompteClient_Test {

	@testSetup static void setup() {
		SM_AP08_TestLib.insertCS_SMOCTOPUS();
	}
	//pas de retour
	@isTest static void majCompteClient_Test() {
		Test.startTest();
		Map < String, Object > input = new Map < String, Object > ();
		Map < String, Object > ServicesGestion = new Map < String, Object > ();
		Map < String, Object > prelevementBlock = new Map < String, Object > ();
		Map < String, Object > EditBlock1Map = new Map < String, Object > ();
		Map < String, Object > ChoixElements = new Map < String, Object > ();
		ChoixElements.put('FormulaNumCompteClientFrom360', '000402627727');

		EditBlock1Map.put('selectedElement', true);
		EditBlock1Map.put('idCoordonneeBancaire', '200377460-02');
		ServicesGestion.put('EditBlock1', EditBlock1Map ) ;
		input.put('ChoixElements', ChoixElements);
		input.put('ServicesGestion', ServicesGestion);

		input.put('idCompteClient', '000402627727');
		input.put('idCoordonneesBancaires', '200377460-02');
		Map < String, Object > output = new Map < String, Object > ();
		SM_AP20_MajCompteClient service = new SM_AP20_MajCompteClient();
		service.invokeMethod('majCompteClient', input, output, null);
        ServicesGestion.put('EditBlock1', new List<Object>{EditBlock1Map} ) ;
        prelevementBlock.put('Prelevement','Oui');
        ServicesGestion.put('PrelevementBlock', prelevementBlock) ;
        input.put('ServicesGestion', ServicesGestion);
        service.invokeMethod('majCompteClient', input, output, null);
        System.assertEquals(null,output.get('error'));
		Test.stopTest();
	}

	/*@Author:MHA
	*@Description: Test sans IdCompteClient créé
	*@CreatedDate: 15/01/2019
	*@LastModified: MHA 15/01/2019
	*/
	@isTest static void majCompteClientWithIdCompteClient360_Test() {
		Test.startTest();
		Map < String, Object > input = new Map < String, Object > ();
		Map < String, Object > ServicesGestion = new Map < String, Object > ();
		Map < String, Object > prelevementBlock = new Map < String, Object > ();
		Map < String, Object > EditBlock1Map = new Map < String, Object > ();
		Map < String, Object > ChoixElements = new Map < String, Object > ();
		ChoixElements.put('FormulaNumCompteClientFrom360', '000402627727');

		EditBlock1Map.put('selectedElement', true);
		EditBlock1Map.put('idCoordonneeBancaire', '200377460-02');
		ServicesGestion.put('EditBlock1', EditBlock1Map ) ;
		input.put('ChoixElements', ChoixElements);
		input.put('ServicesGestion', ServicesGestion);

		/*input.put('idCompteClient', '000402627727');*/
		input.put('idCoordonneesBancaires', '200377460-02');
		Map < String, Object > output = new Map < String, Object > ();
		SM_AP20_MajCompteClient service = new SM_AP20_MajCompteClient();
		service.invokeMethod('majCompteClient', input, output, null);
        ServicesGestion.put('EditBlock1', new List<Object>{EditBlock1Map} ) ;
        prelevementBlock.put('Prelevement','Oui');
        ServicesGestion.put('PrelevementBlock', prelevementBlock) ;
        input.put('ServicesGestion', ServicesGestion);
        service.invokeMethod('majCompteClient', input, output, null);
        System.assertEquals(null,output.get('error'));
		Test.stopTest();
	}

	@isTest static void majCompteClientWithOutCoordonneeBancaireSelected_Test() {
		Test.startTest();
		Map < String, Object > input = new Map < String, Object > ();
		Map < String, Object > ServicesGestion = new Map < String, Object > ();
		Map < String, Object > prelevementBlock = new Map < String, Object > ();
		Map < String, Object > EditBlock1Map = new Map < String, Object > ();
		Map < String, Object > ChoixElements = new Map < String, Object > ();
		ChoixElements.put('FormulaNumCompteClientFrom360', '000402627727');

		EditBlock1Map.put('selectedElement', false);
		EditBlock1Map.put('idCoordonneeBancaire', '200377460-02');
		ServicesGestion.put('EditBlock1', EditBlock1Map ) ;
		input.put('ChoixElements', ChoixElements);
		input.put('ServicesGestion', ServicesGestion);

		input.put('idCompteClient', '000402627727');
		input.put('idCoordonneesBancaires', '200377460-02');
		Map < String, Object > output = new Map < String, Object > ();
		SM_AP20_MajCompteClient service = new SM_AP20_MajCompteClient();
		service.invokeMethod('majCompteClient', input, output, null);
        ServicesGestion.put('EditBlock1', new List<Object>{EditBlock1Map} ) ;
        prelevementBlock.put('Prelevement','Oui');
        ServicesGestion.put('PrelevementBlock', prelevementBlock) ;
        input.put('ServicesGestion', ServicesGestion);
        service.invokeMethod('majCompteClient', input, output, null);
        System.assertEquals('Attention vous n\'avez pas sélectionné de Coordonnées bancaires',output.get('error'));
		Test.stopTest();
	}

	@isTest static void majCompteClientWithOutCoordonneeBancaire_Test() {
		Test.startTest();
		Map < String, Object > input = new Map < String, Object > ();
		Map < String, Object > ServicesGestion = new Map < String, Object > ();
		Map < String, Object > prelevementBlock = new Map < String, Object > ();
		/*Map < String, Object > EditBlock1Map = new Map < String, Object > ();*/
		Map < String, Object > ChoixElements = new Map < String, Object > ();
		ChoixElements.put('FormulaNumCompteClientFrom360', '000402627727');

		/*EditBlock1Map.put('selectedElement', false);
		EditBlock1Map.put('idCoordonneeBancaire', '200377460-02');*/
		ServicesGestion.put('EditBlock1', null ) ;
		input.put('ChoixElements', ChoixElements);
		input.put('ServicesGestion', ServicesGestion);

		input.put('idCompteClient', '000402627727');
		input.put('idCoordonneesBancaires', '200377460-02');
		Map < String, Object > output = new Map < String, Object > ();
		SM_AP20_MajCompteClient service = new SM_AP20_MajCompteClient();
		service.invokeMethod('majCompteClient', input, output, null);
        /*ServicesGestion.put('EditBlock1', new List<Object>{EditBlock1Map} ) ;*/
        prelevementBlock.put('Prelevement','Oui');
        ServicesGestion.put('PrelevementBlock', prelevementBlock) ;
        input.put('ServicesGestion', ServicesGestion);
        service.invokeMethod('majCompteClient', input, output, null);
        System.assertEquals(null,output.get('error'));
		Test.stopTest();
	}

	@isTest static void majCompteClientWithOutIdCoordonneeBancaire_Test() {
		Test.startTest();
		Map < String, Object > input = new Map < String, Object > ();
		Map < String, Object > ServicesGestion = new Map < String, Object > ();
		Map < String, Object > prelevementBlock = new Map < String, Object > ();
		Map < String, Object > EditBlock1Map = new Map < String, Object > ();
		Map < String, Object > ChoixElements = new Map < String, Object > ();
		ChoixElements.put('FormulaNumCompteClientFrom360', '000402627727');

		EditBlock1Map.put('selectedElement', true);
		EditBlock1Map.put('idCoordonneeBancaire', null);
		ServicesGestion.put('EditBlock1', null ) ;
		input.put('ChoixElements', ChoixElements);
		input.put('ServicesGestion', ServicesGestion);

		input.put('idCompteClient', '000402627727');
		input.put('idCoordonneesBancaires', null);
		Map < String, Object > output = new Map < String, Object > ();
		SM_AP20_MajCompteClient service = new SM_AP20_MajCompteClient();
		service.invokeMethod('majCompteClient', input, output, null);
        ServicesGestion.put('EditBlock1', new List<Object>{EditBlock1Map} ) ;
        prelevementBlock.put('Prelevement','Oui');
        ServicesGestion.put('PrelevementBlock', prelevementBlock) ;
        input.put('ServicesGestion', ServicesGestion);
        service.invokeMethod('majCompteClient', input, output, null);
        System.assertEquals('Pas d\'id coordonnée bancaire, la mise à jour du compte client ne peut pas etre effectuée !',output.get('error'));
		Test.stopTest();
	}

	@isTest static void majCompteClientWithOutIdCompteClient_Test() {
		Test.startTest();
		Map < String, Object > input = new Map < String, Object > ();
		Map < String, Object > ServicesGestion = new Map < String, Object > ();
		Map < String, Object > prelevementBlock = new Map < String, Object > ();
		Map < String, Object > EditBlock1Map = new Map < String, Object > ();
		Map < String, Object > ChoixElements = new Map < String, Object > ();
		ChoixElements.put('FormulaNumCompteClientFrom360', null);

		EditBlock1Map.put('selectedElement', true);
		EditBlock1Map.put('idCoordonneeBancaire', '200377460-02');
		ServicesGestion.put('EditBlock1', EditBlock1Map ) ;
		input.put('ChoixElements', ChoixElements);
		input.put('ServicesGestion', ServicesGestion);

		input.put('idCompteClient', null);
		input.put('idCoordonneesBancaires', '200377460-02');
		Map < String, Object > output = new Map < String, Object > ();
		SM_AP20_MajCompteClient service = new SM_AP20_MajCompteClient();
		service.invokeMethod('majCompteClient', input, output, null);
        ServicesGestion.put('EditBlock1', new List<Object>{EditBlock1Map} ) ;
        prelevementBlock.put('Prelevement','Oui');
        ServicesGestion.put('PrelevementBlock', prelevementBlock) ;
        input.put('ServicesGestion', ServicesGestion);
        service.invokeMethod('majCompteClient', input, output, null);
        System.assertEquals('le parametre Numero Compte Contrat est introuvable depuis la vue 360, la mise à jour du compte client ne peut pas etre effectué !',output.get('error'));
		Test.stopTest();
	}
}