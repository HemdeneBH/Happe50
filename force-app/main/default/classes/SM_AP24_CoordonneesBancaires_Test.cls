/**
* @description       : Test class for SM_AP24_CoordonneesBancaires
* @author            : ???
* @group             : 
* @last modified on  : 03-12-2021
* @last modified by  : David ATTALI
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   ??-??-????   ???             Initial Version
* 1.1   03-12-2021   David ATTALI    FT1-4449 + Refactoring
**/
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
	System.debug('outputMap :'+ outputMap);
      
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
    inputMap.put('isCHOContext', true);
    inputMap.put('preleve', true);
    inputMap.put('iBanCHO', 'FR7613335003010497764704742');  
    inputMap.put('nomBanqueCHO', 'CAISSE D\'EPARGNE AQUITAINE POITOU CHARENTES');  
    inputMap.put('bicCHO', 'CEPAFRPP333');  
    inputMap.put('nomTitulaireCHO', 'DELEBARRE CLAUDINE');  
      
	Map<String, Object> outputMap = new Map<String, Object>();
	SM_AP24_CoordonneesBancaires service = new SM_AP24_CoordonneesBancaires() ;
      
	service.invokeMethod('getCoordonneesBancaires', inputMap,  outputMap, null) ;
      
	Map<String, Object> resultMap = (Map<String, Object>)outputMap.get('ServicesGestion');
      
	List<Object> editBlock2List = (List<Object>)resultMap.get('EditBlock2');
	Map<String, Object> coordonneeBancaire = (Map<String, Object>)editBlock2List[0];
      
	System.assertEquals('N° IBAN: FR76XXXXXXXXXXXXXXXXXXX4742 ,BIC: CEPAFRPP333', String.valueOf(coordonneeBancaire.get('libelle11')));
	System.assertEquals('Nom de la banque: CAISSE D\'EPARGNE AQUITAINE POITOU CHARENTES ,Titulaire du compte: DELEBARRE CLAUDINE', String.valueOf(coordonneeBancaire.get('libelle21')));
      
	Test.stopTest();
  }
}