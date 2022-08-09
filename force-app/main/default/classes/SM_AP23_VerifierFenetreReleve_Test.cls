@isTest
global class SM_AP23_VerifierFenetreReleve_Test {



 @isTest
 global static void test() {

  Map < String, Object > output = new Map < String, Object > ();
  Map < String, Object > input = new Map < String, Object > ();
  Map < String, Object > InitData = new Map < String, Object > ();
  InitData.put('pdlpce', '1234567');
  input.put('InitData', InitData);
  SM_AP23_VerifierFenetreReleve service = new SM_AP23_VerifierFenetreReleve();
  service.invokeMethod('verifierFenetreReleve', input, output, null);


 }

}