/*@Author: Amal Chreiteh
*@Description: Classe test de VI_parcoursPPLocal_Test
*@CreatedDate: 15/12/2020
*@LastModified: 15/12/2020
*/

public without sharing class VI_parcoursPPLocal_Controller {
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Méthode appeler par LWC pour récupérer les locals en se basant sur le PDL, PCE ou les deux
* @param PDL et PCE
* @return List<Local> wrapper defined in this class
*/
    @AuraEnabled(cacheable=true) 
    public static List<local> searchLocalbyPDLPCE( String PDL , String PCE) {
        //21101817736807
        String localPCE;
        String localPDL;
        List<Donnees_Vente__c> listDV;
        
        List<Local> locals = new List<Local>();
        if(string.isNotBlank(PDL)){
            List<local> localsPDL = searchLocalbyPDL(PDL);
            if(localsPDL!= null && localsPDL.size()>0){
                locals.add(localsPDL[0]);
                localPCE = localsPDL[0].PCE;
            }
        }
        if(string.isNotBlank(PCE) && PCE != localPCE){
            List<local> localsPCE = searchLocalbyPCE(PCE);
            if(localsPCE!= null && localsPCE.size()>0){
                locals.add(localsPCE[0]);
                localPDL=localsPCE[0].PDL;
            }
        }
        
        listDV=[SELECT ID,CaseId__r.Origin,CaseId__r.VI_DateEnvoiEnveloppe__c,
                Code_offre_elec__c,Code_offre_gaz__c,Point_de_livraison__c,Point_comptage_estimation__c,  VI_DateEnvoiCPV__c
                FROM Donnees_Vente__c
                WHERE CaseId__r.VI_OffreEnCoursSouscription__c=TRUE
                AND (Point_de_livraison__c=:PDL OR Point_de_livraison__c=:localPDL
                     OR Point_comptage_estimation__c=:localPCE OR Point_comptage_estimation__c=:PCE)];
        if(listDV!=null && listDV.size()>0){
            system.debug('listDV '+listDV.size());
            for(Donnees_Vente__c myDV:listDV){
                xCase xCaseToShow=new xCase();
                xCaseToShow.canal=myDV.CaseId__r.Origin;
                if(myDV.Code_offre_elec__c!=null && myDV.Code_offre_gaz__c!=null){
                    xCaseToShow.energie='Dual';
                }
                else if(myDV.Code_offre_elec__c!=null && myDV.Code_offre_gaz__c==null){
                    xCaseToShow.energie='Electricité';
                }
                else if(myDV.Code_offre_elec__c==null && myDV.Code_offre_gaz__c!=null){
                    xCaseToShow.energie='Gaz';
                }
                else if(myDV.Code_offre_elec__c==null && myDV.Code_offre_gaz__c==null){
                    xCaseToShow.energie='';
                }
                xCaseToShow.dateDenvoi=String.valueof(myDV.VI_DateEnvoiCPV__c);
                for(local currentLocal:locals){
                    if(myDV.Point_comptage_estimation__c!=null || myDV.Point_de_livraison__c !=null){
                        if((currentLocal.PDL==myDV.Point_de_livraison__c || currentLocal.PCE==myDV.Point_comptage_estimation__c) && 
                           (myDV.Point_comptage_estimation__c!=null || myDV.Point_de_livraison__c !=null)){
                               if(currentLocal.cases==null){
                                   currentLocal.cases=new List<xCase>();
                               }
                               currentLocal.hasCase=true;
                               currentlocal.showIcon='slds-show slds-icon slds-icon-text-default slds-icon_large';
                               currentLocal.cases.add(xCaseToShow);
                               break;
                           }
                    }
                }
            }
        }
        return locals;
    }
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Méthode appeler par la méthode searchLocalbyPDLPCE pour récuperer les infos du PCE
* @param PCE
* @return List<Local> wrapper defined in this class
*/
    @AuraEnabled(cacheable=true) 
    public static List<local> searchLocalbyPCE( String PCE) {
        List<Local> locals = new List<Local>();
        List<Donnees_Vente__c> listDV;
        List<xCase> listXCase=new List<xCase>();
        
        VI_SM007_PtLivGaz.PointLivraisonGazResponse responsePCE =  VI_SM007_PtLivGaz.API_PtLivGaz(PCE, null, null, 'VI', 'local.VIToken');
        if(responsePCE != null && responsePCE.data != null &&responsePCE.data.size()>0 && responsePCE.data[0]!= null){
            String MatriculePCE = responsePCE.data[0].codeMatricule;
            String numeroVoie = responsePCE.data[0].numeroVoie;
            String libelleVoie = responsePCE.data[0].libelleVoie;
            String codepostal = responsePCE.data[0].codepostal;
            String ville = responsePCE.data[0].ville;
            String codeCommune = responsePCE.data[0].codeINSEE;
            /* Start DDPCM - 671 */
            String typeCompteurGaz = responsePCE.data[0].typeCompteur;
            system.debug('¤ typeCompteurGaz : '+ typeCompteurGaz);
            /* End DDPCM - 671 */
            /* Start DDPCM - 1120 */
            Boolean infosLocalRecuperees=false;
            /* End DDPCM - 1120 */
            VI_SM005_AdressesApiService.getAddressByIdResponse responseAdresse = VI_SM005_AdressesApiService.searchAddressByPCE(PCE, responsePCE.data[0].ville, responsePCE.data[0].codepostal, responsePCE.data[0].libelleVoie,'VI', 'local.VIToken');
            system.debug('responseAdresse'+ responseAdresse);
            String PDL = (responseAdresse!= null && responseAdresse.data!= null && responseAdresse.data[0]!= null? responseAdresse.data[0].idPointDeLivraison:null);
            
            String MatriculePDL = null;
            /* Start DDPCM - 671 */
            String typeCompteurElec = '';
            /* End DDPCM - 671 */
            if(string.isNotBlank(PDL)){
                VI_SM008_PtLivElec.PointLivraisonElecResponse responsePDL =  VI_SM008_PtLivElec.API_PtLivElec(PDL, null, null, 'VI', 'local.VIToken');
                MatriculePDL = responsePDL.data[0].codeMatricule;
                /* Start DDPCM - 671 */
                typeCompteurElec = responsePDL.data[0].typeCompteur;
                /* End DDPCM - 671 */
                /* Start DDPCM - 1120 */
                infosLocalRecuperees=true;
                /* End DDPCM - 1120 */
            }
            locals.add(new local( numeroVoie ,libelleVoie , codePostal, codeCommune, ville, PCE, PDL, MatriculePCE, MatriculePDL/* Start DDPCM - 671 */, typeCompteurElec, typeCompteurGaz /* End DDPCM - 671 */,
                                 /* Start DDPCM - 1120 */infosLocalRecuperees=true /* End DDPCM - 1120 */));
        }
        return locals;
        
    }
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Méthode appeler par la méthode searchLocalbyPDLPCE pour récuperer les infos du PDL
* @param PDL
* @return List<Local> wrapper defined in this class
*/
    
    @AuraEnabled(cacheable=true) 
    public static List<local> searchLocalbyPDL( String PDL) {
        //23198697384673
        List<Local> locals = new List<Local>();
        List<Donnees_Vente__c> listDV;
        List<xCase> listXCase=new List<xCase>();
        VI_SM008_PtLivElec.PointLivraisonElecResponse responsePDL =  VI_SM008_PtLivElec.API_PtLivElec(PDL, null, null, 'VI', 'local.VIToken');
        system.debug('responsePDL'+ responsePDL);
        if(responsePDL != null && responsePDL.data != null && responsePDL.data.size() >0 && responsePDL.data[0]!= null){
            system.debug('responsePDL.data[0]'+ responsePDL.data[0]);
            String MatriculePDL = responsePDL.data[0].codeMatricule;
            String numeroVoie = responsePDL.data[0].numeroVoie;
            String libelleVoie = responsePDL.data[0].libelleVoie;
            String codepostal = responsePDL.data[0].codepostal;
            String ville = responsePDL.data[0].ville;
            String codeCommune = responsePDL.data[0].codeINSEE;
            /* Start DDPCM - 671 */
            String typeCompteurElec = responsePDL.data[0].typeCompteur;
            system.debug('¤ typeCompteurElec : '+ typeCompteurElec);
            /* End DDPCM - 671 */
            /* Start DDPCM - 1120 */
            Boolean infosLocalRecuperees=false;
            /* End DDPCM - 1120 */
            VI_SM005_AdressesApiService.getAddressByIdResponse responseAdresse = VI_SM005_AdressesApiService.searchAddressByPDL(PDL, responsePDL.data[0].ville, responsePDL.data[0].codepostal, responsePDL.data[0].libelleVoie,'VI', 'local.VIToken');
            system.debug('responseAdresse'+ responseAdresse);
            String PCE = responseAdresse.data[0].idPointDeComptage;
            String MatriculePCE = null;
            /* Start DDPCM - 671 */
            String typeCompteurGaz = '';
            /* End DDPCM - 671 */
            if(string.isNotBlank(PCE)){
                VI_SM007_PtLivGaz.PointLivraisonGazResponse responsePCE =  VI_SM007_PtLivGaz.API_PtLivGaz(PCE, null, null, 'VI', 'local.VIToken');
                system.debug('responsePCE'+ responsePCE);
                if(responsePCE!= null && responsePCE.data!= null && responsePCE.data.size()>0){
                    MatriculePCE = responsePCE.data[0].codeMatricule;
                    /* Start DDPCM - 671 */
                    typeCompteurGaz = responsePCE.data[0].typeCompteur;
                    /* End DDPCM - 671 */
                }
                /* Start DDPCM - 1120 */
                infosLocalRecuperees=true;
                /* End DDPCM - 1120 */
            }        
            locals.add(new local( numeroVoie ,libelleVoie , codePostal, codeCommune, ville, PCE, PDL, MatriculePCE, MatriculePDL/* Start DDPCM - 671 */, typeCompteurElec, typeCompteurGaz /* End DDPCM - 671 */,
                                 /* Start DDPCM - 1120 */infosLocalRecuperees=true /* End DDPCM - 1120 */));
        }
        return locals;
    }
    
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Appel webservice pour récuperer les informations du PDL
* @param PDL
* @return List<VI_SM008_PtLivElec.cls_data> wrapper defined in the class "VI_SM008_PtLivElec"
*/
    @AuraEnabled(cacheable=true)
    public static List<VI_SM008_PtLivElec.cls_data> getPDL( String PDL) { 
        VI_SM008_PtLivElec.PointLivraisonElecResponse response =  VI_SM008_PtLivElec.API_PtLivElec(PDL, null, null, 'VI', 'local.VIToken');
        return response.data;
    }
    
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Appel webservice pour récuperer les informations du PCE
* @param PCE
* @return List<VI_SM007_PtLivGaz.cls_data> wrapper defined in the class "VI_SM007_PtLivGaz"
*/
    
    @AuraEnabled(cacheable=true)
    public static List<VI_SM007_PtLivGaz.cls_data> getPCE( String PCE) { 
        VI_SM007_PtLivGaz.PointLivraisonGazResponse responsePCE =  VI_SM007_PtLivGaz.API_PtLivGaz(PCE, null, null, 'VI', 'local.VIToken');
        return responsePCE.data;
    }
    
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Méthode appeler par LWC pour récupérer les PDL/ PCE à partir de l'adresse du local
* @param ville, codePostal, LibelleVoie, numeroVoie
* @return List<Local> wrapper defined in this class
*/
    
    @AuraEnabled(cacheable=true)
    public static List<Local> getPDLPCEFromAdresse(String ville, String codePostal, String libelleVoie,String numeroVoie, String PDLChoisi, String PCEChoisi) { 
        List<Local> locals = new List<Local>();
        List<Local> localsToSend = new List<Local>();
        Local localSelectionne;
        String adresse = numeroVoie + ' ' + libelleVoie + ' ' +codepostal + ' ' +ville;
        String iban = VI_SM005_AdressesApiService.getIdBanIfSameAddr(EncodingUtil.URLENCODE(adresse,'UTF-8'));
        String PCE;
        String PDL;
        String MatriculePDL;
        String MatriculePCE;
        /* Start DDPCM - 671 */
        String typeCompteurElec;
        String typeCompteurGaz;
        /* End DDPCM - 671 */
        /* Start DDPCM - 1120 */
        Boolean infosLocalRecuperees=false;
        /* End DDPCM - 1120 */
        Set<String> setPDLs=new Set<String>();
        Set<String> setPCEs=new Set<String>();
        String codeCommune;
        List<Donnees_Vente__c> listDV;
        
        /* Start DDPCM - 1120 */
       	Integer nbInfosLocauxRecherches=0;
        /* End DDPCM - 1120 */
        
        VI_SM005_AdressesApiService.getAddressByIdResponse responseAdresse = VI_SM005_AdressesApiService.getAddressById(iban, '50', 'VI', 'local.VIToken' );
        if(responseAdresse!= null && responseAdresse.data != null && responseAdresse.data.size()>0){
            for(VI_SM005_AdressesApiService.cls_data responsAdd : responseAdresse.data){
                numeroVoie = responsAdd.numeroVoie;
                libelleVoie = responsAdd.libelleVoie;
                codepostal = responsAdd.codepostal;
                codeCommune = responsAdd.codeINSEE;
                ville = responsAdd.ville;
                PDL = responsAdd.idPointDeLivraison;
                setPDLs.add(PDL);
                PCE = responsAdd.idPointDeComptage;
                setPCEs.add(PDL);
                if(string.isNotBlank(PDL) ||string.isNotBlank(PCE)){
                    /* Start DDPCM - 1120 */
                    if(nbInfosLocauxRecherches<3){
                        infosLocalRecuperees=true;
                        /* End DDPCM - 1120 */
                        if(string.isNotBlank(PDL)){
                            List<VI_SM008_PtLivElec.cls_data> localPDL = getPDL(PDL);
                            if(localPDL != null && localPDL.size()>0){
                                MatriculePDL = localPDL[0].codeMatricule;
                                /* Start DDPCM - 671 */
                                system.debug('¤ TypeCompteur : '+ localPDL[0].TypeCompteur);
                                typeCompteurElec = localPDL[0].TypeCompteur;
                                /* End DDPCM - 671 */
                            }
                            
                        }
                        else{
                            MatriculePDL = '';
                            typeCompteurElec = '';
                        }
                        if(string.isNotBlank(PCE)){
                            List<VI_SM007_PtLivGaz.cls_data> localPCE = getPCE(PCE);
                            if(localPCE != null && localPCE.size()>0){
                                MatriculePCE = localPCE[0].codeMatricule;
                                /* Start DDPCM - 671 */
                                system.debug('¤ TypeCompteur :'+ localPCE[0].TypeCompteur);
                                typeCompteurGaz = localPCE[0].TypeCompteur;
                                /* End DDPCM - 671 */
                            }
                            
                        }
                        else{
                            MatriculePCE = '';
                            typeCompteurGaz = '';
                        }
                    }
                    else{
                        MatriculePDL = '';
                        typeCompteurElec = '';
                        MatriculePCE = '';
                        typeCompteurGaz = '';
                        infosLocalRecuperees=false;
                    }
                   
                    if(PDLChoisi == PDL && PCEChoisi ==PCE){
                        if(!infosLocalRecuperees){
                            infosLocalRecuperees=true;
                            /* End DDPCM - 1120 */
                            if(string.isNotBlank(PDL)){
                                List<VI_SM008_PtLivElec.cls_data> localPDL = getPDL(PDL);
                                if(localPDL != null && localPDL.size()>0){
                                    MatriculePDL = localPDL[0].codeMatricule;
                                    /* Start DDPCM - 671 */
                                    system.debug('¤ TypeCompteur : '+ localPDL[0].TypeCompteur);
                                    typeCompteurElec = localPDL[0].TypeCompteur;
                                    /* End DDPCM - 671 */
                                }
                                
                            }
                            else{
                                MatriculePDL = '';
                                typeCompteurElec = '';
                            }
                            if(string.isNotBlank(PCE)){
                                List<VI_SM007_PtLivGaz.cls_data> localPCE = getPCE(PCE);
                                if(localPCE != null && localPCE.size()>0){
                                    MatriculePCE = localPCE[0].codeMatricule;
                                    /* Start DDPCM - 671 */
                                    system.debug('¤ TypeCompteur :'+ localPCE[0].TypeCompteur);
                                    typeCompteurGaz = localPCE[0].TypeCompteur;
                                    /* End DDPCM - 671 */
                                }
                                
                            }
                            else{
                                MatriculePCE = '';
                                typeCompteurGaz = '';
                            }
                        }
                        localSelectionne = new local(numeroVoie ,libelleVoie , codePostal, codeCommune, ville, PCE, PDL, MatriculePCE, MatriculePDL/* Start DDPCM - 671 */, typeCompteurElec, typeCompteurGaz /* End DDPCM - 671 */,
                                                     /* Start DDPCM - 1120 */infosLocalRecuperees/* End DDPCM - 1120 */);
                        infosLocalRecuperees=false;
                    }
                    else{
                        locals.add(new local(numeroVoie ,libelleVoie , codePostal, codeCommune, ville, PCE, PDL, MatriculePCE, MatriculePDL/* Start DDPCM - 671 */, typeCompteurElec, typeCompteurGaz /* End DDPCM - 671 */,
                                             /* Start DDPCM - 1120 */infosLocalRecuperees/* End DDPCM - 1120 */));
                    }
                }
                nbInfosLocauxRecherches++;
            }
        }
        
        listDV=[SELECT ID,CaseId__r.Origin,CaseId__r.VI_DateEnvoiEnveloppe__c,VI_DateEnvoiCPV__c,
                Code_offre_elec__c,Code_offre_gaz__c,Point_de_livraison__c,Point_comptage_estimation__c
                FROM Donnees_Vente__c
                WHERE CaseId__r.VI_OffreEnCoursSouscription__c=TRUE
                AND (Point_de_livraison__c IN :setPDLs
                     OR Point_comptage_estimation__c IN :setPCEs)];
        
        if(listDV!=null && listDV.size()>0){
            system.debug('listDV '+listDV.size());
            for(Donnees_Vente__c myDV:listDV){
                xCase xCaseToShow=new xCase();
                xCaseToShow.canal=myDV.CaseId__r.Origin;
                if(myDV.Code_offre_elec__c!=null && myDV.Code_offre_gaz__c!=null){
                    xCaseToShow.energie='Dual';
                }
                else if(myDV.Code_offre_elec__c!=null && myDV.Code_offre_gaz__c==null){
                    xCaseToShow.energie='Electricité';
                }
                else if(myDV.Code_offre_elec__c==null && myDV.Code_offre_gaz__c!=null){
                    xCaseToShow.energie='Gaz';
                }
                else if(myDV.Code_offre_elec__c==null && myDV.Code_offre_gaz__c==null){
                    xCaseToShow.energie='';
                }
                xCaseToShow.dateDenvoi=String.valueof(myDV.VI_DateEnvoiCPV__c);
                for(local currentLocal:locals){
                    if(myDV.Point_comptage_estimation__c!=null || myDV.Point_de_livraison__c !=null){
                        system.debug('currentLocal.PDL '+currentLocal.PDL);
                        system.debug('myDV.Point_de_livraison__c '+myDV.Point_de_livraison__c);
                        system.debug('currentLocal.PCE '+currentLocal.PCE);
                        system.debug('myDV.Point_comptage_estimation__c '+myDV.Point_comptage_estimation__c);
                        if((currentLocal.PDL==myDV.Point_de_livraison__c || currentLocal.PCE==myDV.Point_comptage_estimation__c) && 
                           (myDV.Point_comptage_estimation__c!=null || myDV.Point_de_livraison__c !=null)){
                               system.debug('in if');
                               if(currentLocal.cases==null){
                                   currentLocal.cases=new List<xCase>();
                               }
                               currentLocal.hasCase=true;
                               currentlocal.showIcon='slds-show buttonIcon_dataTable';
                               currentLocal.cases.add(xCaseToShow);
                               break;
                           }
                    }
                }
            }
        }
        
        if(localSelectionne != null){
            localsToSend.add(localSelectionne); 
        }
        localsToSend.addAll(locals);
        return localsToSend; 
    }
    
    /**
* @author Paul Ghoussoub
* @date 29/03/2022
* @description Méthode appeler par LWC pour recuperer des infos supplementaires sur les PDL et PCE
* @param PDL,PCE
* @return 
*/
    @AuraEnabled(cacheable=true)
    public static List<Local> getInfosSuppPDLPCEfromAdresse(String locaux,Integer startIndexApex,Integer endIndexApex){ 
        system.debug('locaux '+locaux);
        List<Local> locauxToReturn=new List<Local>();
        String MatriculePDL;
        String MatriculePCE;
        String typeCompteurElec;
        String typeCompteurGaz;
        Boolean infosLocalRecuperees=false;
        List<Object> values = (List<Object>)JSON.deserializeUntyped(locaux);
        for(Object sectionData: values) {
            Map<String, Object> currentLocal = (Map<String, Object>)sectionData;
            local newLocal=new Local((String)currentLocal.get('numeroVoie'), (String)currentLocal.get('libelleVoie'), (String)currentLocal.get('codePostal'), (String)currentLocal.get('codeCommune'), (String)currentLocal.get('ville'), (String)currentLocal.get('PCE'), 
                                     (String) currentLocal.get('PDL'), (String)currentLocal.get('MatriculePCE'), (String)currentLocal.get('MatriculePDL'), (String)currentLocal.get('typeCompteurElec'), (String)currentLocal.get('typeCompteurGaz') 
                                     ,(Boolean)currentLocal.get('infoRecuperees'));
            locauxToReturn.add(newLocal);
            
        }
        
        if(locauxToReturn!=null && locauxToReturn.size()>0){
            for(Integer i=startIndexApex;i<=endIndexApex-1;i++){
                if(string.isNotBlank(locauxToReturn[i].PDL) ||string.isNotBlank(locauxToReturn[i].PCE)){
                    infosLocalRecuperees=true;
                    if(string.isNotBlank(locauxToReturn[i].PDL)){
                        List<VI_SM008_PtLivElec.cls_data> localPDL = getPDL(locauxToReturn[i].PDL);
                        if(localPDL != null && localPDL.size()>0){
                            MatriculePDL = localPDL[0].codeMatricule;
                            typeCompteurElec = localPDL[0].TypeCompteur;
                        }
                    }
                    else{
                        MatriculePDL = '';
                        typeCompteurElec = '';
                    }
                    if(string.isNotBlank(locauxToReturn[i].PCE)){
                        List<VI_SM007_PtLivGaz.cls_data> localPCE = getPCE(locauxToReturn[i].PCE);
                        if(localPCE != null && localPCE.size()>0){
                            MatriculePCE = localPCE[0].codeMatricule;
                            typeCompteurGaz = localPCE[0].TypeCompteur;
                        }
                    }
                    else{
                        MatriculePCE = '';
                        typeCompteurGaz = '';
                    }
                }     
                locauxToReturn[i].MatriculePCE = MatriculePCE;
                locauxToReturn[i].MatriculePDL = MatriculePDL;
                locauxToReturn[i].typeCompteurElec = typeCompteurElec;
                locauxToReturn[i].typeCompteurGaz = typeCompteurGaz;
                
                if (locauxToReturn[i].typeCompteurElec == 'LINKY' && locauxToReturn[i].typeCompteurGaz == 'GAZPAR'){
                    locauxToReturn[i].combinaisonTypeCompteur = 'LINKY' + '\r\n' + 'GAZPAR';
                }
                else if (locauxToReturn[i].typeCompteurElec == 'LINKY' && locauxToReturn[i].typeCompteurGaz != 'GAZPAR'){
                    locauxToReturn[i].combinaisonTypeCompteur = 'LINKY\r\n' + '\r\n' + '';
                }
                else if (locauxToReturn[i].typeCompteurElec != 'LINKY' && locauxToReturn[i].typeCompteurGaz == 'GAZPAR'){
                    locauxToReturn[i].combinaisonTypeCompteur = '' + '\r\n' + 'GAZPAR';
                }
                else {
                    locauxToReturn[i].combinaisonTypeCompteur = '';
                }
                locauxToReturn[i].infoRecuperees=infosLocalRecuperees;
            }
        }
        
        return locauxToReturn;
    }
    
    
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Méthode appeler par LWC pour mettre à jour le parcours par les informations du local séléctionné
* @param ville, codePostal, LibelleVoie, numeroVoie, accordClient, parcoursId, PCE, PDL et typeRechercheLocal
* @return String qui contient le message d'erreur en cas d'echec de mise à jour
*/
    
    @AuraEnabled(cacheable=false)
    public static String updateParcoursLocal(String PDL, String PCE, String numeroVoie, String libelleVoie, 
                                             String codePostal, String codeCommune, String ville, Boolean accordClient, String parcourId,
                                             String typeRechercheLocal) { 
                                                 Try{
                                                     update new VI_Parcours__c(Id = parcourId, 
                                                                               VI_PDLRechercheLocal__c = PDL,
                                                                               VI_PCERechercheLocal__c = PCE,
                                                                               VI_NumeroRueRechercheLocal__c	= numeroVoie,
                                                                               VI_RueRechercheLocal__c = libelleVoie,
                                                                               VI_CodePostalRechercheLocal__c = codePostal,
                                                                               VI_CommuneRechercheLocal__c = ville,
                                                                               VI_AccordClientRechercheLocal__c = accordClient,
                                                                               VI_TypeRechercheLocal__c = typeRechercheLocal,
                                                                               VI_CodeCommuneIdentificationLocal__c = codeCommune
                                                                              );
                                                     return null;   
                                                 }
                                                 catch(exception e){ return e.getMessage();
                                                 }
                                             }
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Méthode appeler par LWC pour mettre à jour le parcours par les informations remplies si le local n'est pas identifié par le partenaire
* @param ville, codePostal, LibelleVoie, numeroVoie, accordClient, parcoursId, PCE, PDL, typeRechercheLocal, localNonIdentifie, nomPredecesseur,
typeLogement, etage, numeroAppart, indexHP, indexHC, indexBase, numeroMatricule, droiteGauche, DDPCM - 279 > adresseIdentique, DDPCM - 671 > typeCompteurElec, typeCompteurGaz
* @return String qui contient le message d'erreur en cas d'echec de mise à jour
*/    
    @AuraEnabled(cacheable=false)
    public static String updateParcoursLocalNonIdentifie(String PDL, String PCE, String numeroVoie, String libelleVoie, 
                                                         String codePostal, String codeCommune, String ville, Boolean accordClient, String parcourId,
                                                         String typeRechercheLocal, Boolean localNonIdentifie, String nomPredecesseur,
                                                         String typeLogement, String etage, String numeroAppart, String indexHP,
                                                         String indexHC, String indexBase, String numeroMatricule, String droiteGauche,/* start DDPCM - 279*/ Boolean adresseIdentique /* end DDPCM - 279*/
                                                         /* Start DDPCM - 671 */, String typeCompteurElec, String typeCompteurGaz /* End DDPCM - 671 */) {                             
                                                             
                                                             Try{
                                                                 update new VI_Parcours__c(Id = parcourId, 
                                                                                           VI_PDLRechercheLocal__c = PDL,
                                                                                           VI_PCERechercheLocal__c = PCE,
                                                                                           VI_NumeroRueRechercheLocal__c = numeroVoie,
                                                                                           VI_RueRechercheLocal__c = libelleVoie,
                                                                                           VI_CodePostalRechercheLocal__c = codePostal,
                                                                                           VI_CommuneRechercheLocal__c = ville,
                                                                                           VI_AccordClientRechercheLocal__c = accordClient,
                                                                                           VI_TypeRechercheLocal__c = typeRechercheLocal,
                                                                                           VI_LocalNonIdentifieGenerationCase__c = localNonIdentifie,
                                                                                           VI_NomPredecesseurRechercheLocal__c = nomPredecesseur,
                                                                                           VI_TypeLogementRechercheLocal__c = typeLogement,
                                                                                           VI_NumeroEtageRechercheLocal__c = etage,
                                                                                           VI_NumeroAppartementRechercheLocal__c = numeroAppart,
                                                                                           VI_IndexHPRechercheLocal__c = indexHP,
                                                                                           VI_IndexHCRechercheLocal__c = indexHC,
                                                                                           VI_IndexBaseRechercheLocal__c = indexBase,
                                                                                           //VI_NumeroMatriculeRechercheLocal__c = numeroMatricule,
                                                                                           VI_DroiteGaucheRechercheLocal__c = droiteGauche,
                                                                                           VI_CodeCommuneIdentificationLocal__c = codeCommune,
                                                                                           /* start DDPCM - 279*/
                                                                                           VI_AdresseDeConsoIdentique__c = adresseIdentique,
                                                                                           /* end DDPCM - 279*/
                                                                                           /* Start DDPCM - 671 */
                                                                                           VI_typeCompteurElec__c = typeCompteurElec,
                                                                                           VI_typeCompteurGaz__c = typeCompteurGaz
                                                                                           /* End DDPCM - 671 */
                                                                                          );
                                                                 return null;   
                                                             }
                                                             catch(exception e){ return e.getMessage();
                                                             }
                                                         }
    
    
    public class local{
        @AuraEnabled
        public String adressePDLPCE;
        @AuraEnabled
        public String PCE;
        @AuraEnabled
        public String PDL;
        @AuraEnabled
        public String MatriculePCE;
        @AuraEnabled
        public String MatriculePDL;
        @AuraEnabled
        public String PDLPCE;
        @AuraEnabled
        public String Matricules;
        @AuraEnabled
        public String codePostal;
        @AuraEnabled
        public String codeCommune;
        @AuraEnabled
        public String ville;
        @AuraEnabled
        public String numeroVoie;
        @AuraEnabled
        public String libelleVoie;
        @AuraEnabled
        public String PDL_PCE;
        @AuraEnabled
        public List<xCase> cases;
        @AuraEnabled
        public Boolean hasCase;
        @AuraEnabled
        public String showIcon='slds-hide';
        @AuraEnabled
        public Boolean alreadyAddedToList;
        /* Start DDPCM - 671 */
        @AuraEnabled
        public String typeCompteurElec;
        @AuraEnabled
        public String typeCompteurGaz;
        @AuraEnabled
        public String combinaisonTypeCompteur;
        /* End DDPCM - 671*/
        /* Start DDPCM - 1120 */
        @AuraEnabled
        public Boolean infoRecuperees;
        /* End DDPCM - 1120*/
        
        public local( String numeroVoie, String libelleVoie, String codepostal, String codeCommune, String ville, String PCE, 
                     String PDL, String MatriculePCE, String MatriculePDL/* Start DDPCM - 671 */, String typeCompteurElec, String typeCompteurGaz /* End DDPCM - 671 */
                     /* Start DDPCM - 1120 */,Boolean infoRecuperees/* End DDPCM - 1120*/){
                         this.adressePDLPCE = numeroVoie + ' ' + libelleVoie + ' ' +codepostal + ' ' +ville;
                         this.PDL_PCE = PDL+'_'+PCE;
                         this.PCE = PCE;
                         this.PDL = PDL;
                         this.PDLPCE = 'PDL '+ PDL + '\r\n' + 'PCE '+ PCE ;
                         if ((MatriculePDL != null && MatriculePDL.length() > 0) && (MatriculePCE != null && MatriculePCE.length() > 0)) { this.Matricules = MatriculePDL + '\r\n' + MatriculePCE;
                         }
                         else if ((MatriculePDL != null && MatriculePDL.length() > 0) && (MatriculePCE == null || MatriculePCE.length() != 0)) {this.Matricules = MatriculePDL + '\r\n' + '\r\n';
                         }
                         else if ((MatriculePDL == null || MatriculePDL.length() != 0) && (MatriculePCE != null && MatriculePCE.length() > 0)) {this.Matricules = '' + '\r\n' + MatriculePCE;
                         }
                         else {
                             this.Matricules = '';
                         }
                         this.MatriculePCE = MatriculePCE;
                         this.MatriculePDL = MatriculePDL;
                         this.numeroVoie = numeroVoie;
                         this.libelleVoie = libelleVoie;
                         this.codePostal = codePostal;
                         this.codeCommune = codeCommune;
                         this.ville = ville;
                         
                         /* Start DDPCM - 671 */
                         this.typeCompteurElec = typeCompteurElec;
                         this.typeCompteurGaz = typeCompteurGaz;
                         
                         if (this.typeCompteurElec == 'LINKY' && this.typeCompteurGaz == 'GAZPAR'){ this.combinaisonTypeCompteur = 'LINKY' + '\r\n' + 'GAZPAR';
                         }
                         else if (this.typeCompteurElec == 'LINKY' && this.typeCompteurGaz != 'GAZPAR'){this.combinaisonTypeCompteur = 'LINKY\r\n' + '\r\n' + '';
                         }
                         else if (this.typeCompteurElec != 'LINKY' && this.typeCompteurGaz == 'GAZPAR'){ this.combinaisonTypeCompteur = '' + '\r\n' + 'GAZPAR';
                         }
                         else {
                             this.combinaisonTypeCompteur = '';
                         }
                         /* End DDPCM - 671*/
                         /* Start DDPCM - 1120 */
                         this.infoRecuperees=infoRecuperees;
                         /* End DDPCM - 1120*/
                     }
        
    }
    
    public class xCase{
        @AuraEnabled
        public String canal;
        @AuraEnabled
        public String energie;
        @AuraEnabled
        public String dateDenvoi;
    }
    
    /**
* @author CLément BOUQUIN
* @date 09/06/2021
* @description Récupération du contact reliés au parcours
* @param parcours provenant du lwc qui contient
* @return contactX contactAddress qui contient les l'adresse du contact
*/
    
    @AuraEnabled(cacheable=false)
    public static contactX getSelectedContactAddress(VI_parcours__c parcours) {
        List<Contact> contacts = [SELECT MailingPostalCode, MailingCity, No_Voie__c, MailingStreet
                                  FROM Contact 
                                  WHERE Id  =: parcours.VI_Contact__c];
        contactX contactAddresse;
        if(contacts!=null && contacts.size()>0){contactAddresse = new ContactX(contacts[0]);
        }
        return contactAddresse;
    }
    
    public class ContactX{
        @AuraEnabled
        public String MailingPostalCode{get;set;}
        @AuraEnabled
        public String MailingCity{get;set;}
        @AuraEnabled
        public String No_Voie{get;set;}
        @AuraEnabled
        public String MailingStreet{get;set;}
        
        public ContactX(Contact contact){
            this.MailingPostalCode = contact.MailingPostalCode;this.MailingCity = contact.MailingCity;this.No_Voie = contact.No_Voie__c;this.MailingStreet = contact.MailingStreet;
        }
    }
}