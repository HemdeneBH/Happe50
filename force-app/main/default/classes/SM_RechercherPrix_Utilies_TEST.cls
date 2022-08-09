/*
* @Auhtor: Jason Goolaup ~ goolaup.jasondavid@external.engie.com
* @Date: 09/01/2019
* @Description: Test class for utility class rechercherPrixEtRemisesServices
*/
@isTest
global class SM_RechercherPrix_Utilies_TEST {

  /*
  * @Auhtor: Jason Goolaup ~ goolaup.jasondavid@external.engie.com
  * @Date: 09/01/2019
  * @Description Methode test to simulate the construction of output in method 
  */
  @isTest
  global static void globalSuccessTest() {
        Map<String, object> inputMap = new Map<String, object>();
        Map<String, object> outputMap = new Map<String, object>();

        inputMap.put('codeCommune', '59220');
        inputMap.put('codePostal', '59000');
        inputMap.put('dateEffetContrat', '25-12-2018');
        inputMap.put('datePropositionCommerciale', '26-12-2018');
        
        SM_RechercherPrix_Utilies service = new SM_RechercherPrix_Utilies();
        service.invokeMethod('transformInputsWS', inputMap,  outputMap, null);
        System.assertEquals(outputMap.size(), 2);
    }
    /*
    * @Auhtor: Jason Goolaup ~ goolaup.jasondavid@external.engie.com
    * @Date: 09/01/2019
    * @Description Methode test to simulate call of another method
    */
    @isTest
    global static void globalfaliureTest() {
      Map<String, object> inputMap = new Map<String, object>();
      Map<String, object> outputMap = new Map<String, object>();

      SM_RechercherPrix_Utilies service = new SM_RechercherPrix_Utilies();
      service.invokeMethod('anotherinput', inputMap,  outputMap, null);
      System.assertEquals(outputMap.size(), 0);
    }
}