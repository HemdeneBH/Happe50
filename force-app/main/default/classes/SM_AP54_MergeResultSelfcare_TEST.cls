@isTest
private class SM_AP54_MergeResultSelfcare_TEST
{
    @testSetup static void setup() {
        SM_AP08_TestLib.insertCS_GenericEndpoints();
        SM_AP08_TestLib.insertCS_XDATACredentials();
    }
    
    @isTest
    public static void testUserValue(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
         SM_AP54_MergeResultSelfcare selfcare = new SM_AP54_MergeResultSelfcare();
        selfcare.invokeMethod('userValues', inputMap, outputMap, null);
    }    

   @isTest(SeeAllData = false)
    public static void testMergeSelfcare(){
        // Création du bloc adresse
        Map<String, Object> addrInput = new Map<String, Object>();
        List<Object> dataAddr = new List<Object>();

        SM_AP07_AdressesApiService.PdlPceModel pdlPce = new SM_AP07_AdressesApiService.PdlPceModel('PDL1', 'PCE1','', '');
        SM_AP07_AdressesApiService.AdresseModel adr = new SM_AP07_AdressesApiService.AdresseModel('chb', pdlPce, '75015', '75015', '', '17', 'rue gramme', 'Paris', 'idBan');
        dataAddr.add(adr);
        addrInput.put('data', dataAddr);

        // Création du bloc Elec
        Map<String, Object> elecInput = new Map<String, Object>();
        Map<String, Object> dataElec = new Map<String, Object>();

        Map<String, Object> opsElec = new Map<String, Object>();
        opsElec.put('pdl', 'PDL1');
        opsElec.put('idPrestationDistributeur', 'A123');
        opsElec.put('presenceObligatoire','PO');
        opsElec.put('heureDebut','13h00');
        opsElec.put('heureFin','18h00');
        opsElec.put('intervention','true');
        opsElec.put('noIntervention',false);
        opsElec.put('libelle', 'Mise en service dans votre nouveau logement');
        opsElec.put('code_retour_ops', 'OCTOPUS_LirePrestationServiceElectricite_01');
        opsElec.put('datePrevue', '2025/12/12');
        dataElec.put('PDL1', opsElec);
        elecInput.put('ops', dataElec);
        
        // Création du bloc gaz
        Map<String, Object> gazInput = new Map<String, Object>();
        Map<String, Object> dataGaz = new Map<String, Object>();
        
        Map<String, Object> opsGaz = new Map<String, Object>();
        opsGaz.put('pdl', 'PCE1');
        opsGaz.put('intervention','true');
        opsGaz.put('presenceObligatoire','PNO');
        opsGaz.put('heureDebut','13h00');
        opsGaz.put('heureFin','18h00');
        opsGaz.put('idPrestationDistributeur', 'A123');
        opsGaz.put('libelle', 'Mise en service dans votre nouveau logement');
        opsGaz.put('code_retour_ops', 'OCTOPUS_LirePrestationServiceGaz_01');
        opsGaz.put('datePrevue', '2025/12/13');



        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('Adresses', addrInput);
        inputMap.put('LirePrestationElec', elecInput);
        inputMap.put('LirePrestationGaz', gazInput);

        Map<String, Object> outputMap = new Map<String, Object>();

        dataGaz.put('PCE1', opsGaz);
        gazInput.put('ops', dataGaz);
        inputMap.put('LirePrestationElec', elecInput);
        inputMap.put('LirePrestationGaz', gazInput);
        
        SM_AP54_MergeResultSelfcare selfcare = new SM_AP54_MergeResultSelfcare();
        selfcare.invokeMethod('merge', inputMap, outputMap, null);

        System.debug('*** out : ' + outputMap);

        // Objectif du test : vérifier qu'on a une adresse, qui contient une OPS gaz et une OPS elec
        List<Object> addrListOut = (List<Object>) outputMap.get('adresses');
        System.assertEquals(1, addrListOut.size());

        SM_AP54_MergeResultSelfcare.AddrSelfcare addrOut = (SM_AP54_MergeResultSelfcare.AddrSelfcare) addrListOut[0];
        System.debug('**** out : ' + addrOut);

        system.debug('Test all ko');
        //Test all ko
        opsGaz.put('code_retour_ops', 'OCTOPUS_LirePrestationServiceGaz_03');
        opsGaz.put('datePrevue', '2025/12/14');
        opsElec.put('code_retour_ops', 'OCTOPUS_LirePrestationServiceElectricite_03');
        opsElec.put('datePrevue', '2025/12/15');
        dataGaz.put('PCE1', opsGaz);
        gazInput.put('ops', dataGaz);
        dataElec.put('PDL1', opsElec);
        elecInput.put('ops', dataElec);
        inputMap.put('LirePrestationElec', elecInput);
        inputMap.put('LirePrestationGaz', gazInput);
        selfcare = new SM_AP54_MergeResultSelfcare();
        selfcare.invokeMethod('merge', inputMap, outputMap, null);

        //test date error
        system.debug('test date error');
        opsGaz.put('code_retour_ops', 'OCTOPUS_LirePrestationServiceGaz_01');
        opsGaz.put('datePrevue', 'error');
        opsElec.put('code_retour_ops', 'OCTOPUS_LirePrestationServiceElectricite_01');
        opsElec.put('datePrevue', 'error');
        dataGaz.put('PCE1', opsGaz);
        gazInput.put('ops', dataGaz);
        dataElec.put('PDL1', opsElec);
        elecInput.put('ops', dataElec);
        inputMap.put('LirePrestationElec', elecInput);
        inputMap.put('LirePrestationGaz', gazInput);
        selfcare = new SM_AP54_MergeResultSelfcare();
        selfcare.invokeMethod('merge', inputMap, outputMap, null);
        
         //test date missing , presence 1 and creneau missing
         system.debug('test date missing , presence 1 and creneau missing');
        opsGaz.put('code_retour_ops' , 'OCTOPUS_LirePrestationServiceGaz_01');
        opsGaz.put('datePrevue', '');
        opsElec.put('code_retour_ops', 'OCTOPUS_LirePrestationServiceElectricite_01');
        opsElec.put('datePrevue', '');
        opsElec.put('presence', '1');
        dataGaz.put('PCE1', opsGaz);
        gazInput.put('ops', dataGaz);
        dataElec.put('PDL1', opsElec);
        elecInput.put('ops', dataElec);
        inputMap.put('LirePrestationElec', elecInput);
        inputMap.put('LirePrestationGaz', gazInput);
        selfcare = new SM_AP54_MergeResultSelfcare();
        selfcare.invokeMethod('merge', inputMap, outputMap, null);
        
        //test date format ko
        system.debug('test date format ko');
        opsGaz.put('code_retour_ops' , 'OCTOPUS_LirePrestationServiceGaz_01');
        opsGaz.put('datePrevue', '2025-12-18');
        opsElec.put('code_retour_ops', 'OCTOPUS_LirePrestationServiceElectricite_01');
        opsElec.put('datePrevue', '2025 12 18');
        opsElec.put('presence', '1');
        dataGaz.put('PCE1', opsGaz);
        gazInput.put('ops', dataGaz);
        dataElec.put('PDL1', opsElec);
        elecInput.put('ops', dataElec);
        inputMap.put('LirePrestationElec', elecInput);
        inputMap.put('LirePrestationGaz', gazInput);
        selfcare = new SM_AP54_MergeResultSelfcare();
        selfcare.invokeMethod('merge', inputMap, outputMap, null);
        
        //test date in past j-2
        system.debug('test date in past j-2');
        opsGaz.put('code_retour_ops', 'OCTOPUS_LirePrestationServiceGaz_01');
        opsGaz.put('datePrevue', '2018/12/16');
        opsGaz.put('noIntervention','');
        opsElec.put('code_retour_ops', 'OCTOPUS_LirePrestationServiceElectricite_01');
        opsElec.put('datePrevue', '2018/12/16');
        opsElec.put('noIntervention','true');
        dataGaz.put('PCE1', opsGaz);
        gazInput.put('ops', dataGaz);
        dataElec.put('PDL1', opsElec);
        elecInput.put('ops', dataElec);
        inputMap.put('LirePrestationElec', elecInput);
        inputMap.put('LirePrestationGaz', gazInput);
        selfcare = new SM_AP54_MergeResultSelfcare();
        selfcare.invokeMethod('merge', inputMap, outputMap, null);
        
         //test date ok
          system.debug('test date ok');
        opsGaz.put('code_retour_ops', 'OCTOPUS_LirePrestationServiceGaz_01');
        opsGaz.put('datePrevue', '2020/12/16');
        opsGaz.put('heureDebut','');
        opsGaz.put('heureFin','');
        opsElec.put('code_retour_ops', 'OCTOPUS_LirePrestationServiceElectricite_01');
        opsElec.put('datePrevue', '2020/12/16');
        opsElec.put('noIntervention',false);
        dataGaz.put('PCE1', opsGaz);
        gazInput.put('ops', dataGaz);
        dataElec.put('PDL1', opsElec);
        elecInput.put('ops', dataElec);
        inputMap.put('LirePrestationElec', elecInput);
        inputMap.put('LirePrestationGaz', gazInput);
        selfcare = new SM_AP54_MergeResultSelfcare();
        selfcare.invokeMethod('merge', inputMap, outputMap, null);

          //test date ok libelle empty
          system.debug('test date ok libelle empty');
          opsGaz.put('code_retour_ops', 'OCTOPUS_LirePrestationServiceGaz_01');
          opsGaz.put('datePrevue', '2020/12/16');
          opsGaz.put('libelle', '');
          opsElec.put('code_retour_ops', 'OCTOPUS_LirePrestationServiceElectricite_01');
          opsElec.put('datePrevue', '2020/12/16');
          opsElec.put('libelle', '');
          dataGaz.put('PCE1', opsGaz);
          gazInput.put('ops', dataGaz);
          dataElec.put('PDL1', opsElec);
          elecInput.put('ops', dataElec);
          inputMap.put('LirePrestationElec', elecInput);
          inputMap.put('LirePrestationGaz', gazInput);
          selfcare = new SM_AP54_MergeResultSelfcare();
          selfcare.invokeMethod('merge', inputMap, outputMap, null);
  
		
        //test adresse ko
        system.debug('test adresse ko');
        Map<String, Object> dataAddrKO = new Map<String, Object>();
        inputMap.put('Adresses', dataAddrKO);
        selfcare = new SM_AP54_MergeResultSelfcare();
        selfcare.invokeMethod('merge', inputMap, outputMap, null);
        
    }

   
}