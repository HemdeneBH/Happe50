/*
*@Author: ADE
*@Description: complement pour DR_SM_LireHistoriqueLocalPDL_CheckStatusV3_Output
*@CreatedDate: 07/07/2020
*@LastModified: 07/07/2020
*/
global class SM_AP91_LireHistoriqueLocalPDL_DR_Comp implements vlocity_cmt.VlocityOpenInterface{
    /*
*@Author: ADE
*@Description: Méthode à appeler a partir de l'IP 
*@CreatedDate: 07/07/2020
*@LastModified: 07/07/2020
*/
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        
        if (methodName.equals('checkStatus')) {
            try {
                System.debug('NumOffresSubscription'+inputMap.get('NumOffresSubscription'));
                checkStatus(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug(e);
                return false;
            }
        }
        return true;        
    }
    /*
*@Author: ADE
*@Description: chercher un pdl 5S avec un statut precis
*@CreatedDate: 01/02/2019
*@LastModified: ADE 9/02/2021 FT1-4412
*/
    public static void checkStatus(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        System.debug('start Conversion');
        String ListeIDPDL=(JSON.serialize(inputMap)).replace('#text', 'value');   
        if(!Test.isRunningTest()){ListeIDPDL=ListeIDPDL.replace('composantePropositionCommerciale":{', 'composantePropositionCommerciale":[{');ListeIDPDL=ListeIDPDL.replace('},"personne"', '}],"personne"');  }
        WrapperContatPC wrapperContatPC=new WrapperContatPC();
        wrapperContatPC= wrapperContatPC.parse(ListeIDPDL); 
        System.debug('start debug DC');
        //pars DC to get the last DC status
        Map<String,WrapperContatPC.ListeIDPDLDonneesContrat5S> sortedIDPDLDC=new Map<String,WrapperContatPC.ListeIDPDLDonneesContrat5S>();
        //System.debug('ListeIDPDLDonneesContrat5S'+ wrapperContatPC.ListeIDPDLDonneesContrat5S);
        if( wrapperContatPC.ListeIDPDLDonneesContrat5S!=null){
            for(WrapperContatPC.ListeIDPDLDonneesContrat5S iDPDLDC : wrapperContatPC.ListeIDPDLDonneesContrat5S){
                //sortedIDPDLDC is empty                
                if(sortedIDPDLDC.isEmpty()){
                    sortedIDPDLDC.put(iDPDLDC.PDL.idPDL.value,iDPDLDC);  
                }else{
                    //sortedIDPDLDC not empty check & pdl doesn't exist yet
                    if(!sortedIDPDLDC.containsKey(iDPDLDC.PDL.idPDL.value)){
                        sortedIDPDLDC.put(iDPDLDC.PDL.idPDL.value,iDPDLDC);  
                    }
                    //sortedIDPDLDC not emptyand & pdl exist yet
                    else{                
                        //sortedIDPDLDC not emptyand & pdl exist yet & new pdl is more recent
                        if(long.valueOf(iDPDLDC.numContratISU.value)>long.valueOf(sortedIDPDLDC.get(iDPDLDC.PDL.idPDL.value).numContratISU.value)){
                            sortedIDPDLDC.put(iDPDLDC.PDL.idPDL.value,iDPDLDC);   
                        }
                    }
                    //sortedIDPDLDC not emptyand & pdl exist yet & new pdl is old 
                }                                             
            }    
        }
        System.debug('start debug PC');
        //pars PC to get the last pc status 
        Map<String,WrapperContatPC.ComposantePropositionCommerciale> sortedIDPDLPC=new Map<String,WrapperContatPC.ComposantePropositionCommerciale>();
        if( wrapperContatPC.ListeIDPDLPC!=null){
            for(WrapperContatPC.ListeIDPDLPC listeIDPDLPC : wrapperContatPC.ListeIDPDLPC){
                if( listeIDPDLPC.ComposantePropositionCommerciale!=null){
                    for(WrapperContatPC.ComposantePropositionCommerciale composantePropositionCommerciale : listeIDPDLPC.ComposantePropositionCommerciale){
                        //if list composantePropositionCommerciale not empty && PDL not empty&& PDL.secteurActivite=5S            
                        //System.debug('sortedIDPDLPC is empty'+composantePropositionCommerciale.PDL.secteurActivite.code.value+'idPro'+composantePropositionCommerciale.idPropositionCommerciale);
                        if(listeIDPDLPC.idPropositionCommerciale!=null && composantePropositionCommerciale.PDL!=null && composantePropositionCommerciale.PDL.secteurActivite!=null && composantePropositionCommerciale.PDL.secteurActivite.code.value == '5S'){
                            // System.debug('idPropositionCommerciale not empty');
                            //sortedIDPDLPC is empty
                            if(sortedIDPDLPC.isEmpty()){
                                composantePropositionCommerciale.idPropositionCommerciale=listeIDPDLPC.idPropositionCommerciale;
                                composantePropositionCommerciale.statutPropale=listeIDPDLPC.statutPropale;
                                sortedIDPDLPC.put(composantePropositionCommerciale.PDL.idPDL.value,composantePropositionCommerciale);                                
                            }else{
                                //sortedIDPDLPC not empty check & pdl doesn't exist yet
                                if(!sortedIDPDLPC.containsKey(composantePropositionCommerciale.PDL.idPDL.value)){composantePropositionCommerciale.idPropositionCommerciale=listeIDPDLPC.idPropositionCommerciale;composantePropositionCommerciale.statutPropale=listeIDPDLPC.statutPropale;sortedIDPDLPC.put(composantePropositionCommerciale.PDL.idPDL.value,composantePropositionCommerciale);  
                                                                                                                }
                                //sortedIDPDLPC not emptyand & pdl exist yet
                                else{                
                                    //sortedIDPDLPC not emptyand & pdl exist yet & new pdl is more recent
                                    if(long.valueOf(listeIDPDLPC.idPropositionCommerciale.value)>long.valueOf(sortedIDPDLPC.get(composantePropositionCommerciale.PDL.idPDL.value).idPropositionCommerciale.value)){composantePropositionCommerciale.idPropositionCommerciale=listeIDPDLPC.idPropositionCommerciale;composantePropositionCommerciale.statutPropale=listeIDPDLPC.statutPropale;sortedIDPDLPC.put(composantePropositionCommerciale.PDL.idPDL.value,composantePropositionCommerciale);                                                                                                                                                                                                                     }
                                }
                                //sortedIDPDLPC not emptyand & pdl exist yet & new pdl is old 
                            }                                                                             
                        }                                                
                    }
                }
            }
        }
                //numSubOff the number of PDL that looking for
        Integer numSubOff;
        //for old call we don't send NumOffresSubscription ,use 1 for default 
        if(inputMap.get('NumOffresSubscription')==null||inputMap.get('NumOffresSubscription')=='')
        { numSubOff=1;}
        else{
            numSubOff=Integer.valueOf(inputMap.get('NumOffresSubscription'));
        }                                    
        List<String> LireHistoriqueLocaIDPDLs=new List<String>();
        
        //check if we have DC with last status (Résilié E0009 OR Annulé E0002)
        for(WrapperContatPC.ListeIDPDLDonneesContrat5S iDPDLDC : sortedIDPDLDC.values()){
            //System.debug('DC'+iDPDLDC);
            if(iDPDLDC.historiqueComposanteDt.statutComposante.code.value=='E0009'||iDPDLDC.historiqueComposanteDt.statutComposante.code.value=='E0002'){
                LireHistoriqueLocaIDPDLs.add(iDPDLDC.PDL.idPDL.value);}
            if(LireHistoriqueLocaIDPDLs.size()==numSubOff){
                break;
            }
        }
        System.debug('LireHistoriqueLocaIDPDLs'+LireHistoriqueLocaIDPDLs);
        //System.debug('sortedIDPDLPC'+sortedIDPDLPC.values());
        
        // DC didn't return a valid PDL we check PC with last status E0002 (Annulée) E0006 (Abandonnée) E0009 (Abandonnée Non conforme)  E0010 (Abandonnée Hors délai) E0012 (Transformée) E0007 (Refusée)
        if(sortedIDPDLPC.values()!=null&&sortedIDPDLPC.values().size()>0&&LireHistoriqueLocaIDPDLs.size()<numSubOff){
            for(WrapperContatPC.ComposantePropositionCommerciale pc : sortedIDPDLPC.values()){
                //System.debug('PC'+pc);
                if(pc!=null&&pc.statutPropale!=null&&pc.statutPropale.code!=null){
                    if(pc.statutPropale.code.value=='E0002'||pc.statutPropale.code.value=='E0006'||pc.statutPropale.code.value=='E0009'||pc.statutPropale.code.value=='E0010'||pc.statutPropale.code.value=='E0012'||pc.statutPropale.code.value=='E0007'){
                        LireHistoriqueLocaIDPDLs.add(pc.PDL.idPDL.value);
                    }}
                if(LireHistoriqueLocaIDPDLs.size()==numSubOff){
                    break;
                }
            }}
    
    
        if(LireHistoriqueLocaIDPDLs.size()>0&&numSubOff>0){
            List<String> LireHistoriqueLocaIDPDLsResl=new List<String>();  
            //return the exact number of PDL s that we are looking for  FT1-4412
            for(Integer i=0;i<numSubOff;i++){
                if(LireHistoriqueLocaIDPDLs.size()>i){
                    LireHistoriqueLocaIDPDLsResl.add(LireHistoriqueLocaIDPDLs.get(i));                                             
                }                
            }
            outMap.put('LireHistoriqueLocaIDPDL',LireHistoriqueLocaIDPDLsResl);                           
               
        }else{
            outMap.put('LireHistoriqueLocaIDPDL',null);                           
        }        

    }
}