@isTest
public class SM_CTRL008_ParcoursDossier_Test {
    
    @isTest
    static void getParcoursDossier(){
        Map <String, Object> inputMap = new Map <String, Object>();
        Map <String, Object> outputMap = new Map <String, Object>();
        Map <String, Object> options = new Map <String, Object>();




        SM_CTRL008_ParcoursDossier parcoursDossierClass = new SM_CTRL008_ParcoursDossier();
        inputMap.put('noCourrier','false');




        // Demande Coupure
        inputMap.put('idStatut','EC');
        inputMap.put('idPresta','(COUP,Test)');
        inputMap.put('etatDemandeur','Validé');







        inputMap.put('matchingL1','true');
        inputMap.put('jalonCourrierL1seul','false');
        Test.startTest();
        parcoursDossierClass.invokemethod('getlistParcoursDossierWrapper',inputMap, outputMap, new  Map <String, Object>());




        



        // Demande Coupure Error
        inputMap.put('idStatut','AN');
        inputMap.put('idPresta','COUP');
        inputMap.put('etatDemandeur','ANNULE');




        inputMap.put('matchingL1','false');
        inputMap.put('jalonCourrierL1seul','true');




        SM_CTRL008_ParcoursDossier.getlistParcoursDossierWrapper(inputMap, outputMap);
        
        // Client Eligible Error
        inputMap.put('idStatut','AN');
        inputMap.put('idPresta','');
        inputMap.put('etatDemandeur','');
        SM_CTRL008_ParcoursDossier.getlistParcoursDossierWrapper(inputMap, outputMap);
        
        // Client Eligible 
        inputMap.put('idStatut','AT');
        inputMap.put('idPresta','COUP');
        inputMap.put('etatDemandeur','');
        SM_CTRL008_ParcoursDossier.getlistParcoursDossierWrapper(inputMap, outputMap);
        








        // Client coupé 
        inputMap.put('idStatut','RT');
        inputMap.put('idPresta','COUP');
        inputMap.put('etatDemandeur','');
        SM_CTRL008_ParcoursDossier.getlistParcoursDossierWrapper(inputMap, outputMap);
        
        // Client coupé Error 
        inputMap.put('idStatut','DR');
        inputMap.put('idPresta','COUP');
        inputMap.put('etatDemandeur','INTERVOK');
        SM_CTRL008_ParcoursDossier.getlistParcoursDossierWrapper(inputMap, outputMap);
        








        // Demande de réduction 
        inputMap.put('idStatut','AC');
        inputMap.put('idPresta','REDUCT');
        inputMap.put('etatDemandeur','Test');
        SM_CTRL008_ParcoursDossier.getlistParcoursDossierWrapper(inputMap, outputMap);
        
        // Demande de réduction Error
        inputMap.put('idStatut','AN');
        inputMap.put('idPresta','REDUCT');
        inputMap.put('etatDemandeur','ANNULE');
        SM_CTRL008_ParcoursDossier.getlistParcoursDossierWrapper(inputMap, outputMap);





        // Client éligible à la résiliation pour non paiement
        inputMap.put('idStatut','TT');
        inputMap.put('idPresta','REDUCT');
        inputMap.put('etatDemandeur','ANNULE');
        SM_CTRL008_ParcoursDossier.getlistParcoursDossierWrapper(inputMap, outputMap);
        
        // Client résilié pour non paiement
        inputMap.put('idStatut','RR');
        inputMap.put('idPresta','REDUCT');
        inputMap.put('etatDemandeur','ANNULE');
        SM_CTRL008_ParcoursDossier.getlistParcoursDossierWrapper(inputMap, outputMap);


        
        // Client en réduction de puissance
        inputMap.put('idStatut','DR');
        inputMap.put('idPresta','REDUCT');
        inputMap.put('etatDemandeur','INTERVOK');
        SM_CTRL008_ParcoursDossier.getlistParcoursDossierWrapper(inputMap, outputMap);
        
        // Client en réduction de puissance annulée
        inputMap.put('idStatut','TS');
        inputMap.put('idPresta','REDUCT');
        inputMap.put('etatDemandeur','ANNULE');
        SM_CTRL008_ParcoursDossier.getlistParcoursDossierWrapper(inputMap, outputMap);
        Test.stopTest();


        


    } 
}