/*
* @Author: Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
* @Date: 24/01/2019
* @Description: class test
*/
@isTest
global class SM_CreerPDL_Utilities_TEST {

    /*
  * @Author: Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
  * @Date: 24/01/2019
  * @Description Methode test to simulate the construction of output in method 
  */
  @isTest
  global static void globalSuccessTestGAZ() {
        Map<String, object> inputMap = new Map<String, object>();
        Map<String, object> outputMap = new Map<String, object>();
        Map<String, object> insideObj = new Map<String, object>();

        inputMap.put('typeEnergieDemandee', 'GAZ');
        insideObj.put('selectedPCEValFormula', '1234567891234');
        inputMap.put('ChoixElements1', insideObj);
        inputMap.put('numeroLocal', '07437645');

        
        SM_CreerPDL_Utilities service = new SM_CreerPDL_Utilities();
        service.invokeMethod('prepareRequestCreerPDLPCECasSouscrire', inputMap,  outputMap, null);
        System.assertEquals(outputMap.size(), 1);
        Map<String, Object> subOutputMap = (Map<String, Object>) outputMap.get('CreerPDLInput');
        System.assertEquals(subOutputMap.size(), 3);
    }
    /*
  * @Author: Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
  * @Date: 24/01/2019
  * @Description Methode test to simulate the construction of output in method 
  */
    @isTest
    global static void globalSuccessTestELEC() {
        Map<String, object> inputMap = new Map<String, object>();
        Map<String, object> outputMap = new Map<String, object>();
        Map<String, object> insideObj = new Map<String, object>();

        inputMap.put('typeEnergieDemandee', 'ELEC');
        insideObj.put('selectedPDLValFormula', '1234567891234');
        inputMap.put('ChoixElements1', insideObj);
        inputMap.put('numeroLocal', '07437645');

        
        SM_CreerPDL_Utilities service = new SM_CreerPDL_Utilities();
        //WHEN
        service.invokeMethod('prepareRequestCreerPDLPCECasSouscrire', inputMap,  outputMap, null);
        //THEN
        System.assertEquals(outputMap.size(), 1);
        Map<String, Object> subOutputMap = (Map<String, Object>) outputMap.get('CreerPDLInput');
        System.assertEquals(subOutputMap.size(), 3);
    }
    
    /*
  * @Author: Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
  * @Date: 28/03/2019
  * @Description Methode test to simulate the construction of output in method 
  */
    @isTest
    global static void globalSuccessTestDUO_NouveauLogement() {
        Map<String, object> inputMap = new Map<String, object>();
        Map<String, object> outputMap = new Map<String, object>();
        Map<String, object> insideObj = new Map<String, object>();

        insideObj.put('numPCEToBeCreated', '1234567891234');
        insideObj.put('numPDLToBeCreated', '1234567891234');
        inputMap.put('InfoPDLPCEToBeCreated', insideObj);
        inputMap.put('numeroLocal', '07437645');

        
        SM_CreerPDL_Utilities service = new SM_CreerPDL_Utilities();
        //WHEN
        service.invokeMethod('preparerDonneesCreerPDLPCECasNVLogement', inputMap,  outputMap, null);
        //THEN
        System.assertEquals(outputMap.size(), 1);
        Map<String, Object> subOutputMap = (Map<String, Object>) outputMap.get('CreerPDLInput');
        System.debug(subOutputMap);
        System.assertEquals(subOutputMap.size(), 4);
    }
    
    /*
  * @Author: Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
  * @Date: 25/06/2019
  * @Description Methode test to simulate the construction of output in method 
  */
  @isTest
  global static void globalSuccessTestPDLLOCAL() {
      Map<String, object> inputMap = new Map<String, object>();
      Map<String, object> outputMap = new Map<String, object>();
      Map<String, object> insideObj = new Map<String, object>();
      Map<String, object> infoPdlPceTobeCreated = new Map<String, object>();
      
      insideObj.put('nVoieValue', '12');
      inputMap.put('adresseFormatSAP', 'AVENUE GABRIEL PERI');
      insideObj.put('cityValue', 'PARIS');
      insideObj.put('postcodeValue', '75001');
      
      infoPdlPceTobeCreated.put('numPDLToBeCreated', '1234567899867');
      infoPdlPceTobeCreated.put('numPCEToBeCreated', '1234567899867');
      
      inputMap.put('ChoixElements1', insideObj);
      inputMap.put('InfoPDLPCEToBeCreated', infoPdlPceTobeCreated);
      
      
      SM_CreerPDL_Utilities service = new SM_CreerPDL_Utilities();
      service.invokeMethod('preparerDonneesCreerPDLLocal', inputMap,  outputMap, null);
      System.assertEquals(outputMap.size(), 1);
      
      Map<String, Object> insideMap = (Map<String, Object>) outputMap.get('creationPDLLocalInput');
      Map<String, Object> subOutputMap1 = (Map<String, Object>) insideMap.get('listePDL');
      List<Object> pdlLIST = (List<Map<String, Object>>) subOutputMap1.get('PDL');
      
      System.assertEquals(subOutputMap1.size(), 1);
      System.assertEquals(pdlLIST.size(), 2);
      
      
      Map<String, Object> subOutputMap2 = (Map<String, Object>) insideMap.get('adresseCreer');
      System.assertEquals(subOutputMap2.size(), 5);
    }

}