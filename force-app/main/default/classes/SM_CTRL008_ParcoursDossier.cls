global class SM_CTRL008_ParcoursDossier implements vlocity_cmt.VlocityOpenInterface {
    
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        // Méthode utilisée comme dataSource dans le flexCard SM_ParcoursDossier dans l'OS Recouvrement
        if (methodName.equals('getlistParcoursDossierWrapper')) {
            try {
                getlistParcoursDossierWrapper(inputMap, outMap);
           } catch (Exception e) {
                system.debug('Exception Message = '+e.getMessage()+' Trace = '+e.getStackTraceString());
                return false;
            }
        }
        return true;
    }
    
    public static void getlistParcoursDossierWrapper(Map < String, Object > inputMap, Map < String, Object > outputMap){  

        String idPresta = String.ValueOf(inputMap.get('idPresta'));
        if(!String.isBlank(idPresta))
            idPresta = idPresta.replaceAll( '\\s+', '');
        Boolean isNoCourrier = Boolean.valueOf(inputMap.get('noCourrier'));
        Boolean isMatchingL1 = Boolean.valueOf(inputMap.get('matchingL1'));
        Boolean isCourrierL1Seul = Boolean.valueOf(inputMap.get('jalonCourrierL1seul'));
        //ADE FT4-60
        String datePresta = (String)inputMap.get('datePresta');

        List<String> listIdPresta = new List<String>();
        if(idPresta.contains('('))
            listIdPresta = idPresta.substring(1, idPresta.length()-1).split(',');
        else
            listIdPresta.add(idPresta);
        
        String idStatut = String.ValueOf(inputMap.get('idStatut'));
        String etatDemandeur = String.ValueOf(inputMap.get('etatDemandeur'));        
        String dossierScenario = '';
        System.debug('### aka idStatut ' + idStatut);
         System.debug('### aka inputMap ' + inputMap);

        //Eligibilité FT4-6
        List<String> listStatutEligible_idStatut = Label.SM_ParcoursDossier_ClientEligible_idStatut.split(';'); //AT;NV;TC;TI	
        List<String> listStatutEligible_Error_idStatut = Label.SM_ParcoursDossier_ClientEligible_Error_idStatut.split(';');//AN;TM




        if(listStatutEligible_idStatut.contains(idStatut)){
            dossierScenario = 'ClientEligible';
        }
        else if(listStatutEligible_Error_idStatut.contains(idStatut)){



            dossierScenario = 'ClientEligible_Error';
        }     
        

        List<String> listDemandeCoupure_idStatut = Label.SM_ParcoursDossier_DemandeCoupure_idStatut.split(';'); //AC;EA;EC	
        List<String> listDemandeCoupure_Error_idStatut = Label.SM_ParcoursDossier_DemandeCoupure_Error_idStatut.split(';'); //AN;TM
        List<String> listDemandeCoupure_idPresta = Label.SM_ParcoursDossier_DemandeCoupure_idPresta.split(';'); // COUP;COUPCOND;COUPFERM;COUPCOND-CE;COUPCOND-TPM	
        List<String> listDemandeReduction_idPresta = Label.SM_ParcoursDossier_DemandeReduction_idPresta.split(';'); //REDUCT;REDUCT-CE



        String casIdPrestation = '';
        for(String idPrestation : listIdPresta){
            if(listDemandeCoupure_idPresta.contains(idPrestation)){
                casIdPrestation = 'DemandeCoupure';
            }


            else if(listDemandeReduction_idPresta.contains(idPrestation)){
                 casIdPrestation = 'DemandeReduction';
            }
        }

        if(casIdPrestation == 'DemandeCoupure'){








            //Demande de Coupure FT4-8
            if(listDemandeCoupure_idStatut.contains(idStatut) && etatDemandeur != 'ANNULE' && etatDemandeur != 'INTERVOK'){
                dossierScenario = 'DemandeDeCoupure';
            }
            //Demande de Coupure Annulée FT4-8
            else if(listDemandeCoupure_Error_idStatut.contains(idStatut) && etatDemandeur == 'ANNULE'){
                dossierScenario = 'DemandeDeCoupure_Error';
            } 
            //Client Coupé FT4-9
            else if(idStatut == 'DR' && etatDemandeur == 'INTERVOK'){
                  dossierScenario = 'ClientCoupe';
            }
            
        }



        else if(casIdPrestation == 'DemandeReduction') {
            //Demande de Réduction FT4-2
            if(listDemandeCoupure_idStatut.contains(idStatut) && etatDemandeur != 'ANNULE' && etatDemandeur != 'INTERVOK'){
                dossierScenario = 'DemandeReductionPuissance';
            }
            //Demande de Réduction Annulée FT4-8
            else if(listDemandeCoupure_Error_idStatut.contains(idStatut) && (etatDemandeur == 'ANNULE' || etatDemandeur == 'TRANSMISANNUL')){
                dossierScenario = 'DemandeReductionPuissance_Error';
            } 

            //Client en réduction de puissance FT4-10
            else if(idStatut == 'DR' && etatDemandeur == 'INTERVOK'){
                 dossierScenario = 'ReductiondePuissance';
            }
        }



        //Client Coupé annulé FT4-9
        if(idStatut == 'RT' || idStatut == 'TR'){
            dossierScenario = 'ClientCoupe_Error';
        }



        //Client éligible à la résiliation pour non paiement FT4-11
        if(idStatut == 'TT' || idStatut == 'AR' || idStatut == 'ER'){
            dossierScenario = 'ClientEligibleResil';
        }

        //Client résilié pour non paiement FT4-11
         if(idStatut == 'RR'){
            dossierScenario = 'ClientResilie';
        }
        

        //Client en réduction de puissance annulée FT4-10
         if(idStatut == 'TS' || idStatut == 'RS'){
            dossierScenario = 'ReductiondePuissance_Error';
        }

        

        System.debug('### aka dossierScenario ' + dossierScenario);


         List<Map<String, Object>> listMapReturn = new  List<Map<String, Object>>();
        if(!String.isBlank(dossierScenario)){


        List<SM_ParcoursDossier__mdt> listParcoursDossier = [SELECT Id, ListWrapper__c, MasterLabel
                                                             FROM SM_ParcoursDossier__mdt
                                                             where DeveloperName = :dossierScenario];



            List<ParcoursDossierWrapper> listParcoursDossierEtapes = (List<ParcoursDossierWrapper>)JSON.deserialize(String.valueof(listParcoursDossier[0].ListWrapper__c), List<ParcoursDossierWrapper>.class);
            
           


            List<Map<String, Object>> listMapReturnButtons = new  List<Map<String, Object>>();
            
            for(ParcoursDossierWrapper etapeParcours : listParcoursDossierEtapes){
                //ADE FT4-60
                System.debug('datePresta1'+datePresta);
                if(datePresta!=null&&datePresta!=''&&datePresta!='{datePlanification}'&&(etapeParcours.Title == 'Demande de coupure'||etapeParcours.Title == 'Demande de réduction de puissance'||etapeParcours.Title ==  'Demande de coupure/réduction de puissance')){
                  System.debug('datePresta'+datePresta);
                    List<String> dtFor= datePresta.split('/');
                    etapeParcours.datePresta=dtFor[1]+'/'+dtFor[0]+'/'+dtFor[2];
                }
                
                
                if(etapeParcours.EtapeNumber == '1')
                    etapeParcours.isFirst = true;
                else
                    etapeParcours.isFirst = false;
                
                
                if(etapeParcours.EtapeStatus == 'ValidatedStep'){
                    etapeParcours.isSuccess = true;
                    etapeParcours.isError = false;
                    etapeParcours.isGrey = false;
                    etapeParcours.isCurrent = false;
                    etapeParcours.isLineGrey = false;
                    etapeParcours.isLineGreen = true;
                }
                else if(etapeParcours.EtapeStatus == 'GreyStep'){
                    etapeParcours.isSuccess = false;
                    etapeParcours.isError = false;
                    etapeParcours.isGrey = true;
                    etapeParcours.isCurrent = false;  
                    // Pour les étapes de courriers réglementaire, meme si c'est en grey le hr_line va etre en vert
                    if(etapeParcours.EtapeNumber == '2' || etapeParcours.EtapeNumber == '3'){
                        etapeParcours.isLineGrey = false;
                        etapeParcours.isLineGreen = true;
                    }
                    else{
                        etapeParcours.isLineGrey = true;
                        etapeParcours.isLineGreen = false;
                    }
                    
                }
                else if(etapeParcours.EtapeStatus == 'ErrorStep'){
                    etapeParcours.isSuccess = false;
                    etapeParcours.isError = true;
                    etapeParcours.isGrey = false;
                    etapeParcours.isCurrent = false;
                    etapeParcours.isLineGrey = false;
                    etapeParcours.isLineGreen = true;
                }
                else if(etapeParcours.EtapeStatus == 'CurrentStep'){
                    etapeParcours.isSuccess = false;
                    etapeParcours.isError = false;
                    etapeParcours.isGrey = false;
                    etapeParcours.isCurrent = true;
                    etapeParcours.isLineGrey = false;
                    etapeParcours.isLineGreen = true;
                }

                
                //FT4-12



                if(!isNoCourrier){
                    if(etapeParcours.EtapeNumber == '2'){



                        if(isMatchingL1 || isCourrierL1Seul){
                             etapeParcours.isSuccess = true;
                             etapeParcours.isGrey = false;
                        }                          
                    }



                    if(etapeParcours.EtapeNumber == '3'){



                        if(!isCourrierL1Seul){
                             etapeParcours.isSuccess = true;
                             etapeParcours.isGrey = false;
                        }                          
                    }
                }
                
               
                
                listMapReturn.add(etapeParcours.mapStringObject());
            }


            System.debug('### listParcoursDossierEtapes ' + listParcoursDossierEtapes);
            outputMap.put('listParcoursDossierEtapes', listMapReturn); 
            outputMap.put('ErrorMessage', 'NOERROR');
        }
        else{
            outputMap.put('ErrorMessage', 'Pas d\'informations disponibles');



            outputMap.put('listParcoursDossierEtapes', listMapReturn); 
        }
        
        
    }
    
}