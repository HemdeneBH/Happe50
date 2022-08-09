/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_SM029_CoordonneesBancaires
*@CreatedDate: 15/03/2021
*/
@isTest
public class VI_SM029_CoordonneesBancaires_Test {
	@isTest
    static void testcreerCompteBancaire(){
        Test.startTest();
      VI_SM029_CoordonneesBancaires.InfosCompteBancaire infos=
          VI_SM029_CoordonneesBancaires.creerCompteBancaire('300014091','FR1930002005680000876440G50','FR7612607000099501973863230','VI','local.VIToken');
        system.assertEquals(infos.idCoordonneeBancaire, 'FR1930002005680000876440G50');
        Test.stopTest();
    }
}