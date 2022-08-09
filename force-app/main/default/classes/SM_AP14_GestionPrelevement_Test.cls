/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: Test Class for SM_AP14_GestionPrelevement
*/
@isTest
public class SM_AP14_GestionPrelevement_Test {

    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: test method for SM_AP14_GestionPrelevement.demanderPrelevement
    */
    static testMethod void demanderPrelevement_Test() {
        Test.startTest();
            Map < String, Object > ServicesGestion = new Map < String, Object >();
            Map < String, Object > ServicesGestionBlock = new Map < String, Object >();
            Map < String, Object > inputMap = new Map < String, Object >();
            Map < String, Object > outMap = new Map < String, Object >();

            ServicesGestion.put('idPersonne','300014091');
            ServicesGestion.put('idCoordonneeBancaire','300014091-0001');
            ServicesGestion.put('iban','');
            ServicesGestion.put('bban','');
            ServicesGestion.put('titulaireCompte','testCompte');
            inputMap.put('CompteClientId','500014641');
            inputMap.put('idCompteClient','500014641');          
            ServicesGestion.put('changementPayeur','false');
            ServicesGestion.put('selectedElement',true);

            ServicesGestionBlock.put('EditBlock1',ServicesGestion);
            inputMap.put('ServicesGestion', ServicesGestionBlock);


            SM_AP14_GestionPrelevement gestionPrelevement = new SM_AP14_GestionPrelevement();

            gestionPrelevement.invokeMethod('demanderPrelevement',inputMap,outMap,null);
            /*ServicesGestionBlock.put('EditBlock1',new List<Object> {ServicesGestion});
            inputMap.put('ServicesGestion', ServicesGestionBlock);
            gestionPrelevement.invokeMethod('demanderPrelevement',inputMap,outMap,null);*/
            System.assertEquals('00S012453607',String.valueOf(outMap.get('createdIdMandat')));
            System.assertEquals('A confirmer',String.valueOf(outMap.get('createdStatusMandat')));
        Test.stopTest();
    }


   static testMethod void demanderPrelevementErorWithOutCompteClient_Test() {
        Test.startTest();
            Map < String, Object > ServicesGestion = new Map < String, Object >();
            Map < String, Object > ServicesGestionBlock = new Map < String, Object >();
            Map < String, Object > inputMap = new Map < String, Object >();
            Map < String, Object > outMap = new Map < String, Object >();

            ServicesGestion.put('idPersonne','300014091');
            ServicesGestion.put('idCoordonneeBancaire','300014091-0001');
            ServicesGestion.put('iban','');
            ServicesGestion.put('bban','');
            ServicesGestion.put('titulaireCompte','testCompte');
            /*inputMap.put('CompteClientId','500014641');*/
           /*inputMap.put('idCompteClient','500014641');*/
           ServicesGestion.put('changementPayeur','false');
            ServicesGestion.put('selectedElement',true);
            ServicesGestionBlock.put('EditBlock1',null);
            inputMap.put('ServicesGestion', ServicesGestionBlock);


            SM_AP14_GestionPrelevement gestionPrelevement = new SM_AP14_GestionPrelevement();

            gestionPrelevement.invokeMethod('demanderPrelevement',inputMap,outMap,null);
            ServicesGestionBlock.put('EditBlock1',new List<Object> {ServicesGestion});
            inputMap.put('ServicesGestion', ServicesGestionBlock);
            gestionPrelevement.invokeMethod('demanderPrelevement',inputMap,outMap,null);
           //System.assertEquals('l\'idCompteClient est manquant',String.valueOf(outMap.get('error')));
        Test.stopTest();
    }
}