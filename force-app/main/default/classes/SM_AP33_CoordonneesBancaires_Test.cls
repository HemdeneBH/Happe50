@isTest
public class SM_AP33_CoordonneesBancaires_Test {

 @testSetup static void setup() {
  SM_AP08_TestLib.insertCS_SMOCTOPUS();
 }

 @isTest static void testCallout() {

  Test.startTest();

  Map < String, Object > input = new Map < String, Object > ();
  input.put('IbanNumber', '21101817097249');
  input.put('TitulaireCompte', '21101817097249');
  input.put('idPersonneFormule', '21101817097249');

  Map < String, Object > output = new Map < String, Object > ();
  SM_AP33_CoordonneesBancaires service = new SM_AP33_CoordonneesBancaires();
  service.invokeMethod('creerCB', input, output, null);
  SM_AP33_CoordonneesBancaires.IOException exceptionTest = new SM_AP33_CoordonneesBancaires.IOException();
  Test.stopTest();
 }




}