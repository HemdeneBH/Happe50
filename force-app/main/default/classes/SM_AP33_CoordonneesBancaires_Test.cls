@isTest
public class SM_AP33_CoordonneesBancaires_Test {

 @testSetup static void setup() {
  SM_AP08_TestLib.insertCS_SMOCTOPUS();
 }

 //FT2-1658 - Refonte de la classe SM_AP33_CoordonneesBancaires_Test
 //Test du cas où un payeur divergent existant est attribué
 @isTest static void testCasPayeurExistant() {

    Test.startTest();

    String methodName = 'creerCB';
    Map < String, Object > input = new Map < String, Object > ();
    Map < String, Object > output = new Map < String, Object > ();
    SM_AP33_CoordonneesBancaires service = new SM_AP33_CoordonneesBancaires();

    input.put('IbanNumber', 'FR7610107001011234567890129');
    input.put('TitulaireCompte', 'Samir Saghi');
    input.put('idPersonneFormule', '0302825203');
    output.put('nomInstitutBancaire', 'Banque Populaire');

    service.invokeMethod(methodName, input, output, null);
            
    System.assertEquals('true', String.valueOf(output.get('coordAdded')));
    System.assertEquals('0302825203', String.valueOf(output.get('idPersonne')));
    System.assertEquals('FR7610107001011234567890129', String.valueOf(output.get('IbanNumber')));
    System.assertEquals('Banque Populaire', String.valueOf(output.get('Nombanque')));
    System.assertEquals('N° IBAN: FR7610107001011234567890129', String.valueOf(output.get('libelle1')));
    System.assertEquals('Nom de la banque: Banque Populaire ,Titulaire du compte: Samir Saghi', String.valueOf(output.get('libelle2')));

    Test.stopTest();
  
 }

 //FT2-1658 - Refonte de la classe SM_AP33_CoordonneesBancaires_Test
 //Test du cas où un nouveau payeur divergent est créé
 @isTest static void testCasNewPayeur(){

    Test.startTest();

    String methodName = 'creerCB';
    Map < String, Object > input = new Map < String, Object > ();
    Map < String, Object > output = new Map < String, Object > ();
    SM_AP33_CoordonneesBancaires service = new SM_AP33_CoordonneesBancaires();

    input.put('IbanNumber', 'FR7630001007941234567890185');
    input.put('TitulaireCompte', 'El Houssaine Myaz');
    input.put('idPersonneFormule', '0312417161');
    input.put('isPayeurDivFormule', true);
    output.put('nomInstitutBancaire', 'Banque de France');

    service.invokeMethod(methodName, input, output, null);
            
    System.assertEquals('true', String.valueOf(output.get('selectedElementPayeur')));
    System.assertEquals('true', String.valueOf(output.get('coordAddedPayeurDivergent')));
    System.assertEquals('0312417161', String.valueOf(output.get('idPersonne')));
    System.assertEquals('FR7630001007941234567890185', String.valueOf(output.get('IbanNumber')));
    System.assertEquals('Banque de France', String.valueOf(output.get('NombanquePayeur')));
    System.assertEquals('N° IBAN: FR7630001007941234567890185', String.valueOf(output.get('libelle1Payeur')));
    System.assertEquals('Nom de la banque: Banque de France ,Titulaire du compte: El Houssaine Myaz', String.valueOf(output.get('libelle2Payeur')));

    Test.stopTest();
 }
}