@isTest
/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: Test Class for SM_AP15_GestionSignature
*/
public class SM_AP15_GestionSignature_Test {

    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: Test method to invoke SM_AP15_GestionSignature.demanderSignature
    *@LastModified: MHA 19/03/2019
    */
    static testMethod void demanderSignatureTest() {
        Test.startTest();
        Map < String, Object > EnvoiCodeBlock = new Map < String, Object >();
        Map < String, Object > PrelevementBlock = new Map < String, Object >();
        Map < String, Object > ServicesGestion = new Map < String, Object >();
        Map < String, Object > ServicesGestionBlock = new Map < String, Object >();
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        /*Map < String, Object >  EditBlock1 = new   Map < String, Object >();*/

        EnvoiCodeBlock.put('idPersonneMandat', '0206371959');
        inputMap.put('createdIdMandat', '00S000127297');
        EnvoiCodeBlock.put('codeInput', 'EMAIL');
        EnvoiCodeBlock.put('valeurInput', 'mohamed.troudi@external.engie.com');

        PrelevementBlock.put('EnvoiCodeBlock', EnvoiCodeBlock);

        ServicesGestion.put('idPersonne','300014091');
        ServicesGestion.put('idCoordonneeBancaire','300014091-0001');
        ServicesGestion.put('iban','');
        ServicesGestion.put('bban','');
        ServicesGestion.put('titulaireCompte','testCompte');
        ServicesGestion.put('changementPayeur','false');
        ServicesGestion.put('selectedElement',true);

        ServicesGestionBlock.put('EditBlock1',new List<Object> {ServicesGestion});
        /*PrelevementBlock.put('',)*/
        ServicesGestionBlock.put('PrelevementBlock', PrelevementBlock);
        inputMap.put('ServicesGestion', ServicesGestionBlock);

        /*inputMap.put('ServicesGestion', ServicesGestion);*/
        SM_AP15_GestionSignature demandeSignature = new SM_AP15_GestionSignature();

        demandeSignature.invokeMethod('demanderSignature', inputMap, outMap, null);
        System.assertEquals('OCTOPUS_DemanderSignature_01',String.valueOf(outMap.get('responseCodeSignature')));
        System.assertEquals('Traitement effectué sans erreur', String.valueOf(outMap.get('responseLibelleSignature')));
        Test.stopTest();
    }

    /*
    * @Author: MHA
    * @Date: 04/04/2019
    * @Description: Test method to invoke SM_AP15_GestionSignature.demanderSignature for SMS
    *@LastModified: MHA 04/04/201
    */
    static testMethod void demanderSignatureSMSTest() {
        Test.startTest();
        Map < String, Object > EnvoiCodeBlock = new Map < String, Object >();
        Map < String, Object > PrelevementBlock = new Map < String, Object >();
        Map < String, Object > ServicesGestion = new Map < String, Object >();
        Map < String, Object > ServicesGestionBlock = new Map < String, Object >();
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        /*Map < String, Object >  EditBlock1 = new   Map < String, Object >();*/

        EnvoiCodeBlock.put('idPersonneMandat', '0206371959');
        inputMap.put('createdIdMandat', '00S000127297');
        EnvoiCodeBlock.put('codeInput', 'TEL');
        EnvoiCodeBlock.put('valeurInput', '+33701234567');

        PrelevementBlock.put('EnvoiCodeBlock', EnvoiCodeBlock);

        ServicesGestion.put('idPersonne','300014091');
        ServicesGestion.put('idCoordonneeBancaire','300014091-0001');
        ServicesGestion.put('iban','');
        ServicesGestion.put('bban','');
        ServicesGestion.put('titulaireCompte','testCompte');
        ServicesGestion.put('changementPayeur','false');
        ServicesGestion.put('selectedElement',true);

        ServicesGestionBlock.put('EditBlock1',new List<Object> {ServicesGestion});
        /*PrelevementBlock.put('',)*/
        ServicesGestionBlock.put('PrelevementBlock', PrelevementBlock);
        inputMap.put('ServicesGestion', ServicesGestionBlock);

        /*inputMap.put('ServicesGestion', ServicesGestion);*/
        SM_AP15_GestionSignature demandeSignature = new SM_AP15_GestionSignature();

        demandeSignature.invokeMethod('demanderSignature', inputMap, outMap, null);
        System.assertEquals('OCTOPUS_DemanderSignature_01',String.valueOf(outMap.get('responseCodeSignature')));
        System.assertEquals('Traitement effectué sans erreur', String.valueOf(outMap.get('responseLibelleSignature')));
        Test.stopTest();
    }

    /*
    * @Author: MHA
    * @Date: 19/03/2019
    * @Description: Test method pour vérifier que l'email a été rempli
    *@LastModified: MHA 19/03/2019
    */
    static testMethod void demanderSignatureErrorEmailValue_Test() {
        Test.startTest();
        Map < String, Object > EnvoiCodeBlock = new Map < String, Object >();
        Map < String, Object > PrelevementBlock = new Map < String, Object >();
        Map < String, Object > ServicesGestion = new Map < String, Object >();
        Map < String, Object > ServicesGestionBlock = new Map < String, Object >();
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        /*Map < String, Object >  EditBlock1 = new   Map < String, Object >();*/

        EnvoiCodeBlock.put('idPersonneMandat', '0206371959');
        inputMap.put('createdIdMandat', '00S000127297');
        EnvoiCodeBlock.put('codeInput', 'EMAIL');
        EnvoiCodeBlock.put('valeurInput', '');

        PrelevementBlock.put('EnvoiCodeBlock', EnvoiCodeBlock);

        ServicesGestion.put('idPersonne','300014091');
        ServicesGestion.put('idCoordonneeBancaire','300014091-0001');
        ServicesGestion.put('iban','');
        ServicesGestion.put('bban','');
        ServicesGestion.put('titulaireCompte','testCompte');
        ServicesGestion.put('changementPayeur','false');
        ServicesGestion.put('selectedElement',true);

        ServicesGestionBlock.put('EditBlock1',new List<Object> {ServicesGestion});
        /*PrelevementBlock.put('',)*/
        ServicesGestionBlock.put('PrelevementBlock', PrelevementBlock);
        inputMap.put('ServicesGestion', ServicesGestionBlock);

        /*inputMap.put('ServicesGestion', ServicesGestion);*/
        SM_AP15_GestionSignature demandeSignature = new SM_AP15_GestionSignature();

        demandeSignature.invokeMethod('demanderSignature', inputMap, outMap, null);
        System.assertEquals('L\'email n\'a pas été sélectionné',String.valueOf(outMap.get('error')));
        Test.stopTest();
    }

    /*
    * @Author: MHA
    * @Date: 19/03/2019
    * @Description: Test method pour vérifier que l'idMandat est présent
    *@LastModified: MHA 19/03/2019
    */
    static testMethod void demanderSignatureErrorWithOutMandat_Test() {
        Test.startTest();
        Map < String, Object > EnvoiCodeBlock = new Map < String, Object >();
        Map < String, Object > PrelevementBlock = new Map < String, Object >();
        Map < String, Object > ServicesGestion = new Map < String, Object >();
        Map < String, Object > ServicesGestionBlock = new Map < String, Object >();
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        /*Map < String, Object >  EditBlock1 = new   Map < String, Object >();*/

        EnvoiCodeBlock.put('idPersonneMandat', '0206371959');
        EnvoiCodeBlock.put('codeInput', 'EMAIL');
        EnvoiCodeBlock.put('valeurInput', 'mohamed.troudi@external.engie.com');

        PrelevementBlock.put('EnvoiCodeBlock', EnvoiCodeBlock);

        ServicesGestion.put('idPersonne','300014091');
        ServicesGestion.put('idCoordonneeBancaire','300014091-0001');
        ServicesGestion.put('iban','');
        ServicesGestion.put('bban','');
        ServicesGestion.put('titulaireCompte','testCompte');
        ServicesGestion.put('changementPayeur','false');
        ServicesGestion.put('selectedElement',true);

        ServicesGestionBlock.put('EditBlock1',new List<Object> {ServicesGestion});
        /*PrelevementBlock.put('',)*/
        ServicesGestionBlock.put('PrelevementBlock', PrelevementBlock);
        inputMap.put('ServicesGestion', ServicesGestionBlock);

        /*inputMap.put('ServicesGestion', ServicesGestion);*/
        SM_AP15_GestionSignature demandeSignature = new SM_AP15_GestionSignature();

        demandeSignature.invokeMethod('demanderSignature', inputMap, outMap, null);
        System.assertEquals('l\'idMandat est manquant',String.valueOf(outMap.get('error')));
        Test.stopTest();
    }

    static testMethod void demanderSignatureWithOutCoordonneeBancaire_Test() {
        Test.startTest();
        Map < String, Object > EnvoiCodeBlock = new Map < String, Object >();
        Map < String, Object > PrelevementBlock = new Map < String, Object >();
        Map < String, Object > ServicesGestion = new Map < String, Object >();
        Map < String, Object > ServicesGestionBlock = new Map < String, Object >();
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        /*Map < String, Object >  EditBlock1 = new   Map < String, Object >();*/

        EnvoiCodeBlock.put('idPersonneMandat', '0206371959');
        inputMap.put('createdIdMandat', '00S000127297');
        EnvoiCodeBlock.put('codeInput', 'EMAIL');
        EnvoiCodeBlock.put('valeurInput', 'mohamed.troudi@external.engie.com');

        PrelevementBlock.put('EnvoiCodeBlock', EnvoiCodeBlock);

        ServicesGestionBlock.put('EditBlock1',null);
        /*PrelevementBlock.put('',)*/
        ServicesGestionBlock.put('PrelevementBlock', PrelevementBlock);
        inputMap.put('ServicesGestion', ServicesGestionBlock);

        /*inputMap.put('ServicesGestion', ServicesGestion);*/
        SM_AP15_GestionSignature demandeSignature = new SM_AP15_GestionSignature();

        demandeSignature.invokeMethod('demanderSignature', inputMap, outMap, null);
        System.assertEquals('Pas de coordonnée bancaire selectionnée !',String.valueOf(outMap.get('error')));

        Test.stopTest();
    }
}