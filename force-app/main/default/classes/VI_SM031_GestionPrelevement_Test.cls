/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_SM031_GestionPrelevement
*@CreatedDate: 15/02/2021
*/
@isTest
public class VI_SM031_GestionPrelevement_Test {
    @isTest
    static void testdemandePrelevement(){
        Test.startTest();
        VI_SM031_GestionPrelevement.mandatRetour retour=VI_SM031_GestionPrelevement.demandePrelevement(null,'0304596236-0002','0304596236','000506631943','callout:VI_AuthOctopus');
        Test.stopTest();
    }
}