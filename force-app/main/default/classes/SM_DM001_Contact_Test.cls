/**
 * @description       : Classe de test pour la requete SOSL récupéré pour payeur divergent
 * @author            : AE
 * @group             : 
 * @last modified on  : 09-27-2021
 * @last modified by  : AE
**/
@isTest
private class SM_DM001_Contact_Test {

    @isTest static void TestgetPayeurDivergentSOSL() {

        Map<String , object> inputMap = new Map<String, object>() ;
        Map<String , object> outputMap = new Map<String, object>() ;
        inputMap.put('RechercheClient','Maxime');
        Contact c = SM_TestDataFactory.createContact('Maxime Martin',SM_TestDataFactory.createAccount('MaximeAccount').id);
		Test.starttest();
        SM_DM001_Contact.invokeMethod('getPayeurDivergentSOSL',inputMap, outputMap, Null);
        System.assertEquals(outputMap.size(), 1);
		Test.stopTest();
        SM_DM001_Contact.invokeMethod('Erreur1',inputMap, outputMap, Null);
        inputMap = new Map<String, object>() ;
        inputMap.put('RechercheClient','');
        SM_DM001_Contact.invokeMethod('getPayeurDivergentSOSL',inputMap, outputMap, Null);
        System.assertEquals(outputMap.get('RechercheVide'), 'Vide');
    }
}