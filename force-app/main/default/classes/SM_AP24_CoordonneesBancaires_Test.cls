@isTest
public class SM_AP24_CoordonneesBancaires_Test {
  @testSetup static void setup() {
    SM_AP08_TestLib.insertCS_GenericEndpoints();
    SM_AP08_TestLib.insertCS_XDATACredentials();
  }
  @isTest
  public static void testGetCoordonneesBancaires() {
    Test.startTest();
    Map<String, Object> inputMap = new Map<String, Object>();
    inputMap.put('refClientIdBP', '0202000001');
    Map<String, Object> outputMap = new Map<String, Object>();
    SM_AP24_CoordonneesBancaires service = new SM_AP24_CoordonneesBancaires() ;
    service.invokeMethod('getCoordonneesBancaires', inputMap,  outputMap, null) ;
    Map<String, Object> resultMap = (Map<String, Object>)outputMap.get('ServicesGestion');
    List<Object> editBlock1List = (List<Object>)resultMap.get('EditBlock1');
    Map<String, Object> coordonneeBancaire = (Map<String, Object>)editBlock1List[0];
    System.assertEquals('DELEBARRE CLAUDINE', String.valueOf(coordonneeBancaire.get('TitulaireCompte')));
    System.assertEquals('FR7613335003010497764704742', String.valueOf(coordonneeBancaire.get('IbanNumber')));
    Test.stopTest();
  }

  @isTest
  public static void GetCoordonneesBancaires_TEST() {
    Test.startTest();
    Map<String, Object> inputMap = new Map<String, Object>();
    inputMap.put('refClientIdBP', '202000001');
    Map<String, Object> outputMap = new Map<String, Object>();
    SM_AP24_CoordonneesBancaires service = new SM_AP24_CoordonneesBancaires() ;
    service.invokeMethod('getCoordonneesBancaires', inputMap,  outputMap, null) ;
    Map<String, Object> resultMap = (Map<String, Object>)outputMap.get('ServicesGestion');
    List<Object> editBlock1List = (List<Object>)resultMap.get('EditBlock1');
    Map<String, Object> coordonneeBancaire = (Map<String, Object>)editBlock1List[0];
    System.assertEquals('DELEBARRE CLAUDINE', String.valueOf(coordonneeBancaire.get('TitulaireCompte')));
    System.assertEquals('FR7613335003010497764704742', String.valueOf(coordonneeBancaire.get('IbanNumber')));
    Test.stopTest();
  }
}