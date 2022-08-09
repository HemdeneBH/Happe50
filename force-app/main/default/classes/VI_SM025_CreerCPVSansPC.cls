/*
*@Author: Eloi Dereeper
*@Description: Appel du WS Octopus creerCPVsansPC
*@CreatedDate: 02/12/2020
*@LastModified: 10/12/2020
*/
public class VI_SM025_CreerCPVSansPC { 
    
    // Map<String, String>mapCodeValeur : 
    // clé au format 'code : [XXX / null], libelleCourt : [YYY / null]', permettant de définir chaque code avec des substrings
    // valeur: valeur
    
    public static retourCPV SaveCPVTEST (VI_parcours__c parcours, Contact c, String caseNumber,List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> coupleCodeValeurs, String idFormulaireCode, String NomDuDocument, Boolean documentValide, Boolean documentRetourne, String ctxt, String NamedCredential){
        Map<String, String> mapCodeValeur = new Map<String, String>();
        system.debug('Start coupleCodeValeur: '+ Datetime.now());
        List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> couplesCodeValeur = createCoupleCodeValeur( parcours,  c, caseNumber, coupleCodeValeurs);
        system.debug('End coupleCodeValeur: '+ Datetime.now());
        if(couplesCodeValeur == null){
            return new retourCPV(null, null, 'Erreur lors de la creation du CPV.');
        }
        VI_gdfsuezComBefCalypsoCpvV2.creerCPVSansPCResponse_element response = new VI_gdfsuezComBefCalypsoCpvV2.creerCPVSansPCResponse_element();
        if(!Test.isRunningTest()){
            system.debug('Start creerCPVsansPC: '+ Datetime.now());
            response = creerCPVsansPC(null, idFormulaireCode, couplesCodeValeur,documentValide, documentRetourne,  ctxt, NamedCredential); 
            system.debug('END creerCPVsansPC: '+ Datetime.now());
        }
        else{
            Test.setMock(HttpCalloutMock.class, new VI_SM025_CreerCPVSansPC_Mock());
            response = creerCPVsansPC(null, idFormulaireCode, couplesCodeValeur,documentValide, documentRetourne,  ctxt, NamedCredential);
        }       
        system.debug(response);
        if(response != null){
            if(response.creerCPVSansPCOutput != null && response.creerCPVSansPCOutput.documentCree != null && response.creerCPVSansPCOutput.documentCree.contenuDocument!= null){
                String contenu = response.creerCPVSansPCOutput.documentCree.contenuDocument;
                return new retourCPV(response.creerCPVSansPCOutput.documentCree.idDocument, contenu, null);
            }
            if(response.messageRetours!= null && response.messageRetours.retourTraitementMessage[0]!= null && response.messageRetours.retourTraitementMessage[0].type_x == 'Erreur'){
                return new retourCPV(null, null, 'Erreur :'+response.messageRetours.retourTraitementMessage[0].libelle);
            }
        }
        return new retourCPV(null, null, 'Erreur');
        
    }
    
    @AuraEnabled(cacheable=false) 
    public static List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> createCoupleCodeValeurINIT(VI_parcours__c parcours){
        String typeComptage;
        if(parcours.VI_ChoixEstimation__c == 'Saisir la consommation d\'énergie'){
            typeComptage = (parcours.VI_SaisieConsommationElec_HP_HC__c == true? 'HPHC':'SIMPLE');
        }
        else{
            typeComptage = (parcours.VI_SaisieEstimationConsoElec_HP_HC__c == 'Oui'? 'HPHC':'SIMPLE');
        }
        system.debug('typeComptage'+ typeComptage);
        system.debug('Début createCoupleCodeValeurINIT:' + system.now());
        List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> couplesCodeValeur = 
            new List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element>();
        //Balises Gaz
        if(parcours.VI_ChoixEnergie__c != 'Electricité'){
            String idOffre = parcours.VI_OffreChoisieGazPanierClient__c;
            String regex = '[a-zA-Z]{1,}|\\-';
            String dureeOffre = idOffre.replaceAll(regex, '').substring(0, 1);
            system.debug('idOffre'+ idOffre);
            system.debug('dureeOffre'+ dureeOffre);
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.PDL',parcours.VI_PCERechercheLocal__c));
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.SECTEUR_ACTIVITE',parcours.VI_Secteur_Activit_Gaz__c));
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.RESEAU',''));
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.CODE_PRODUIT',idOffre));
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.INTITULE_OFFRE','Gaz Ajust')); // champs à créer
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.DATE_EFFET',buildDate(parcours.VI_InfosCompl_DateContratEffectif__c)));
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.DATE_ECHEANCE',buildDate(parcours.VI_InfosCompl_DateContratEffectif__c.addYears(Integer.valueOf(dureeOffre)))));
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.DUREE', dureeOffre));
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.FLAG_CARBONE','0'));
            
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.SEUIL_TRANCHE',''));
            
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.PLAGE_CONSO',(parcours.VI_GazPlageConso__c == 6000?'6000 kWh':(parcours.VI_GazPlageConso__c == 30000?'30000 kWh':(parcours.VI_GazPlageConso__c == 300000?'300000 kWh ':'horsscope')))));//
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.CTA','10.41285'));
            
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.CONTEXTE',''));
            
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.LIBELLE_REMISE_ABO',''));
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.DUREE_REMISE_ABO',''));
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.POURCEN_REMISE_ABO',''));
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.LIBELLE_REMISE_CONSO',''));
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.POURCEN_REMISE_CONSO',''));
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.QTE_REMISE_CONSO',''));
            couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.TYPE_OFFRE','tradeOff')); //TRADEOFF
            //TRADEOFF
            if(parcours.VI_TechOffreReferenceChoisie__c == false){
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.PRIX_ABO',String.valueOf(parcours.VI_AbonnementAnnuelGazTTCPanierClient__c)));//
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.TQ1',String.ValueOf(parcours.VI_GazkWhTTCPanierClient__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.TQ2',''));
            }
            
            if(parcours.VI_TechOffreReferenceChoisie__c == true){
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.TRADEOFF','X'));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.PLGE_CONSO_TRADEOFF',(parcours.VI_GazPlageConso__c == 6000?'6000 kWh':(parcours.VI_GazPlageConso__c == 30000?'30000 kWh':(parcours.VI_GazPlageConso__c == 300000?'300000 kWh ':'horsscope')))));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.ACH_ABO',String.ValueOf(parcours.VI_MONTANT_ABO_GAZ_ACH_TTC__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.ACH_ABO_HT',String.valueOf(parcours.VI_MONTANT_ABO_GAZ_ACH_HT__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.PRIX_ABO_HT',String.valueOf(parcours.VI_MONTANT_ABO_GAZ_FOUR_HT__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.PRIX_ABO',String.valueOf(parcours.VI_MONTANT_ABO_GAZ_FOUR_TTC__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.ACH_CO',String.valueOf(parcours.VI_PRIX_KWH_GAZ_ACH_TTC__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.ACH_CO_HT',String.valueOf(parcours.VI_PRIX_KWH_GAZ_ACH_HT__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.OBL',String.valueOf(parcours.VI_PRIX_KWH_GAZ_OBLI__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.OBL_HT',String.valueOf(parcours.VI_PRIX_KWH_GAZ_OBLI_HT__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.TOTAB',String.valueOf(parcours.VI_TOTAL_MONTANT_ABO_GAZ_TTC__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.TOTAB_HT',String.valueOf(parcours.VI_TOTAL_MONTANT_ABO_GAZ_HT__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.TOTCO',String.valueOf(parcours.VI_TOTAL_MONTANT_CONSO_GAZ_TTC__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.TOTCO_HT',String.valueOf(parcours.VI_TOTAL_MONTANT_CONSO_GAZ_HT__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.TQ1_HT',String.valueOf(parcours.VI_PRIX_KWH_GAZ_FOUR_HT__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP04_GAZ.TQ1',String.valueOf(parcours.VI_PRIX_KWH_GAZ_FOUR_TTC__c)));
                
            }
            
            
            if(parcours.VI_CodeOptionGazPanierClient__c != null){
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_GAZ/SERVICE.CODE_PRODUIT','GOPT_VERT'));
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_GAZ/SERVICE.INTITULE_SERVICE','Gaz Vert+'));
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_GAZ/SERVICE.DATE_ECHEANCE','20220731')); /// a definir
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_GAZ/SERVICE.PCE',parcours.VI_PCERechercheLocal__c));
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_GAZ/SERVICE.PLAGE_CONSO',String.valueOf(parcours.VI_GazPlageConso__c)));
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_GAZ/SERVICE.POURCENTAGE','100'));
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_GAZ/SERVICE.PRIX_AB_HT',String.valueOf(parcours.VI_ServiceOptionVerteGazPrixAbHT__c)));
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_GAZ/SERVICE.PRIX_AB_TTC',String.valueOf(parcours.VI_ServiceOptionVerteGazPrixAbTTC__c)));
                List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> annexeOptionGaz = getAnnexeOptionGaz(parcours);
                if(annexeOptionGaz != null ){
                    couplesCodeValeur.addAll(annexeOptionGaz);
                }
                else{
                    return null;
                }
            }
            
        }
        //Balises Elec
        if(parcours.VI_ChoixEnergie__c != 'Gaz'){
            String idOffre = parcours.VI_OffreChoisieElecPanierClient__c;
            String regex = '[a-zA-Z]{1,}|\\-';
            String dureeOffre = idOffre.replaceAll(regex, '').substring(0, 1);
            system.debug('idOffre'+ idOffre);
            system.debug('dureeOffre'+ dureeOffre);
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.PDL',parcours.VI_PDLRechercheLocal__c));
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.SECTEUR_ACTIVITE',parcours.VI_Secteur_Activite_Elec__c));
            //couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.RESEAU',''));
            
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.CODE_PRODUIT',idOffre)); 
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.INTITULE_OFFRE','Elec Ajust')); // à créer
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.DATE_EFFET', buildDate(parcours.VI_InfosCompl_DateContratEffectif__c)));
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.DATE_ECHEANCE',buildDate(parcours.VI_InfosCompl_DateContratEffectif__c.addYears(Integer.valueOf(dureeOffre)))));
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.DUREE',dureeOffre));
            String puissance = (parcours.VI_EstimationPuissance__c!= null? parcours.VI_EstimationPuissance__c: (parcours.VI_PuissanceCompteurElecSaisieConso__c != null? parcours.VI_PuissanceCompteurElecSaisieConso__c:'6' ));
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.PUISSANCE_SOUSCRITE',puissance)); 
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.TYPE_COMPTAGE',typeComptage));//(parcours.VI_SaisieConsommationElec_HP_HC__c == true || parcours.VI_SaisieEstimationConsoElec_HP_HC__c == 'Oui'?'HPHC':'SIMPLE')
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.CTA',''));
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.FLAG_VERT','0'));            
            
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.LIB_REMISE_ABO',''));
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.DUREE_REMISE_ABO',''));
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.POURCEN_REM_ABO',''));
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.LIB_REMISE_CONSO',''));
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.POURCEN_REM_CONSO',''));
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.QTE_REMISE_CONSO',''));
            couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.TYPE_OFFRE','tradeOff'));
            if(parcours.VI_TechOffreReferenceChoisie__c == false){
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.TQ1_GRIS',String.ValueOf(parcours.VI_EleckWhTTCPanierClient__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.HP_GRIS',String.ValueOf(parcours.VI_EleckWhTTCPanierClient__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.HC_GRIS',String.ValueOf(parcours.VI_EleckWhTTCHCPanierClient__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.PRIX_ABO',String.ValueOf(parcours.VI_AbonnementAnnuelElecTTCPanierClient__c)));
            }
            if(parcours.VI_TechOffreReferenceChoisie__c == true){
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.TRADEOFF','X'));
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.FTA',parcours.VI_Code_FTA_Offre__c));//(typeComptage == 'SIMPLE'? 'BTINFCUST': 'BTINFMUDT')
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.PRIX_ABO',String.ValueOf(parcours.VI_MONTANT_ABO_ELEC_FOUR_TTC__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.PRIX_ABO_HT',String.ValueOf(parcours.VI_MONTANT_ABO_ELEC_FOUR_HT__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_ABO_HT',String.ValueOf(parcours.VI_MONTANT_ABO_ELEC_ACH_HT__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_ABO',String.ValueOf(parcours.VI_MONTANT_ABO_ELEC_ACH_TTC__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.TOTAB_HT',String.ValueOf(parcours.VI_TOTAL_MONTANT_ABO_ELEC_HT__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.TOTAB',String.ValueOf(parcours.VI_TOTAL_MONTANT_ABO_ELEC_TTC__c)));
                //Consommation FOUR
                if(parcours.VI_PRIX_KWH_ELEC_FOUR_HP_HT__c == null){
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.LIBELLE_CADRAN1','Base'));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.CONSO_CADRAN1_HT',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_FOUR_HT__c)));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.CONSO_CADRAN1',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_FOUR_TTC__c)));
                }
                else{
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.LIBELLE_CADRAN2','HC'));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.CONSO_CADRAN2_HT',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_FOUR_HC_HT__c)));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.CONSO_CADRAN2',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_FOUR_HC_TTC__c)));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.LIBELLE_CADRAN1','HP'));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.CONSO_CADRAN1_HT',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_FOUR_HP_HT__c)));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.CONSO_CADRAN1',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_FOUR_HP_TTC__c)));
                    
                }
                
                
                
                //Consommation ACH
                if(parcours.VI_PRIX_KWH_ELEC_ACH_HC_HT__c == null && parcours.VI_PRIX_KWH_ELEC_ACH_HPbasse_HTT__c == null){
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_LIB_CADRAN1','Base'));
                    if(parcours.VI_PRIX_KWH_ELEC_ACH_HP_HT__c == null){
                        couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD1_HT',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HT__c)));
                        couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD1',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_TTC__c)));
                    }
                    else{
                        couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD1_HT',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HP_HT__c)));
                        couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD1',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HP_TTC__c)));
                    }
                    
                }
                else if(parcours.VI_PRIX_KWH_ELEC_ACH_HPbasse_HTT__c == null){
                    
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_LIB_CADRAN1','HP'));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD1_HT',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HP_HT__c)));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD1',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HP_TTC__c)));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_LIB_CADRAN2','HC'));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD2_HT',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HC_HT__c)));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD2',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HC_TTC__c)));
                }
                else{
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_LIB_CADRAN1','HC Basse'));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD1_HT',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HCbasse_HTT__c)));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD1',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HCbasse_TTC__c)));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_LIB_CADRAN2','HP Basse'));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD2_HT',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HPbasse_HTT__c)));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD2',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HPbasse_TTC__c)));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_LIB_CADRAN3','HC Haute'));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD3_HT',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HChaute_HTT__c)));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD3',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HChaute_TTC__c)));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_LIB_CADRAN4','HP Haute'));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD4_HT',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HPhaute_HTT__c)));
                    couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.ACH_CO_CAD4',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_ACH_HPhaute_TTC__c)));
                    
                }
                
                
                
                //Consommation OBL
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.OBL_HT',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_OBLI_HT__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.OBL',String.ValueOf(parcours.VI_PRIX_KWH_ELEC_OBLI__c))); 
                //Total Consommation
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.TOTCO_HT',String.ValueOf(parcours.VI_TOTAL_MONTANT_CONSO_ELEC_HT__c)));
                couplesCodeValeur.add(generateCodeValeur('ZP05_ELEC.TOTCO',String.ValueOf(parcours.VI_TOTAL_MONTANT_CONSO_ELEC_TTC__c))); 
            }
            if(parcours.VI_CodeOptionPanierClient__c != null){
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_ELEC/SERVICE.CODE_PRODUIT',parcours.VI_CodeOptionPanierClient__c));
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_ELEC/SERVICE.INTITULE_SERVICE',parcours.VI_LibelleOptionPanierClient__c));
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_ELEC/SERVICE.DATE_ECHEANCE',buildDate(parcours.VI_InfosCompl_DateContratEffectif__c)));
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_ELEC/SERVICE.PDL', parcours.VI_PDLRechercheLocal__c));
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_ELEC/SERVICE.PS',puissance));
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_ELEC/SERVICE.TYP_COMP','SIMPLE'));
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_ELEC/SERVICE.POURCENTAGE','10'));
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_ELEC/SERVICE.PRIX_AB_HT',String.valueof(parcours.VI_ServiceOptionVerteElecPrixAbHT__c)));
                couplesCodeValeur.add(generateCodeValeur('SERVICE_OPTION_VERTE_ELEC/SERVICE.PRIX_AB_TTC',String.valueOf(parcours.VI_ServiceOptionVerteElecPrixAbTTC__c)));
                List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> annexeOptionElec = getAnnexeOptionElec(parcours);
                if(annexeOptionElec != null ){
                    couplesCodeValeur.addAll(annexeOptionElec);
                }
                else{
                    return null;
                }
            }
            
        }
        system.debug('here 1');
        List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> annexeOffreGazElec = getAnnexeOffreGazElec(parcours);
        system.debug('here 2');
        if(annexeOffreGazElec != null ){
            couplesCodeValeur.addAll(annexeOffreGazElec);
        }
        else{
            return null;
        }
        system.debug('Fin createCoupleCodeValeurINIT:' + system.now());
        return couplesCodeValeur;
    }
    
    
    public static List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> createCoupleCodeValeur(VI_parcours__c parcours, Contact c, String caseNumber, List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> coupleCodeValeurs){
        List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> couplesCodeValeur = 
            new List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element>();
        
        // Balises Communes
        
        User currentUser = [SELECT Id, AccountId, account.name, account.VI_Code_Partenaire__c, account.VI_Groupe_Fonctionnel__c, account.VI_CodeRetractation__c, account.VI_CodeLocalite__c, contact.VI_CodeVendeur__c, contactId FROM User WHERE Id =: UserInfo.getUserId()];
        
        couplesCodeValeur.add(generateCodeValeur('TECH.TYPEDOC','ZCPV'));
        //START DDPCM 426
        //couplesCodeValeur.add(generateCodeValeur('TECH.SAPID','ZCPV0000000000'+ caseNumber));// //'ZCPV'+ parcours.VI_Case__c caseNumber
        couplesCodeValeur.add(generateCodeValeur('TECH.SAPID','ZCPV'+ parcours.VI_Case__c));
        //END DDPCM 426
        couplesCodeValeur.add(generateCodeValeur('TECH.ENVOI_AFP','N'));
        couplesCodeValeur.add(generateCodeValeur('TECH.ENVOI_EMAIL',(parcours.VI_ChoixParcours__c == 'EM'?'N':'O')));
        couplesCodeValeur.add(generateCodeValeur('TECH.ENVOI_GED',(parcours.VI_ChoixParcours__c == 'EM'?'O':'N')));
        couplesCodeValeur.add(generateCodeValeur('TECH.IMPRESSION_LOCALE','N'));
        //START DDPCM 426
        couplesCodeValeur.add(generateCodeValeur('TECH.NUM_SERVICE_CLIENT',null));
        //END DDPCM 426
        couplesCodeValeur.add(generateCodeValeur('TECH.DATE_CREATION',buildDate(System.today())));
        couplesCodeValeur.add(generateCodeValeur('TECH.CODE_CLIENT','PartnerCommunity')); // error when changed to  ACCLISW PartnerCommunity
        couplesCodeValeur.add(generateCodeValeur('TECH.SIGNE_LIGNE',(parcours.VI_ChoixParcours__c == 'EM'?'O':'N')));
        couplesCodeValeur.add(generateCodeValeur('TECH.ENVOI_MAIL',(parcours.VI_ChoixParcours__c == 'EM'?'N':'O')));
        couplesCodeValeur.add(generateCodeValeur('DESTINATAIRE.REFERENCE','0'+ parcours.VI_IDReferenceClient__c ));
        couplesCodeValeur.add(generateCodeValeur('DESTINATION.EMAIL', parcours.VI_Email_CPV__c));
        couplesCodeValeur.add(generateCodeValeur('DESTINATAIRE.CIVILITE',c.Salutation));
        couplesCodeValeur.add(generateCodeValeur('DESTINATAIRE.NOM',c.LastName));
        couplesCodeValeur.add(generateCodeValeur('DESTINATAIRE.PRENOM',c.FirstName));
        couplesCodeValeur.add(generateCodeValeur('DESTINATION.NUM_RUE',c.No_Voie__c));
        couplesCodeValeur.add(generateCodeValeur('DESTINATION.RUE',c.MailingStreet));
        couplesCodeValeur.add(generateCodeValeur('DESTINATION.COMPLEMENT',c.Complement_adresse__c));
        couplesCodeValeur.add(generateCodeValeur('DESTINATION.CODE_POSTAL',c.MailingPostalCode));
        couplesCodeValeur.add(generateCodeValeur('DESTINATION.VILLE',c.MailingCity));
        couplesCodeValeur.add(generateCodeValeur('DESTINATION.PAYS',c.MailingCountry));
        //couplesCodeValeur.add(generateCodeValeur('DESTINATAIRE.SEGMENT',''));
        couplesCodeValeur.add(generateCodeValeur('LC.RUE',parcours.VI_RueRechercheLocal__c));
        couplesCodeValeur.add(generateCodeValeur('LC.NUM_RUE',parcours.VI_NumeroRueRechercheLocal__c));
        String complementLocal='';
        Boolean alreadyfilled = false;
        if(parcours.VI_NumeroAppartementRechercheLocal__c != null ){
            complementLocal = complementLocal+ 'Appt: '+parcours.VI_NumeroAppartementRechercheLocal__c;
            alreadyfilled = true;
        }
        if(parcours.VI_NumeroEtageRechercheLocal__c != null ){
            complementLocal = complementLocal+ (alreadyfilled? ', Etage: '+parcours.VI_NumeroEtageRechercheLocal__c:'Etage: '+parcours.VI_NumeroEtageRechercheLocal__c);  
        }
        if(parcours.VI_DroiteGaucheRechercheLocal__c != null ){
            complementLocal = complementLocal+ (alreadyfilled? ', Porte: '+ parcours.VI_DroiteGaucheRechercheLocal__c:'Porte: '+parcours.VI_DroiteGaucheRechercheLocal__c);  
        }
        couplesCodeValeur.add(generateCodeValeur('LC.COMPLEMENT_LOCAL', complementLocal));
        couplesCodeValeur.add(generateCodeValeur('LC.CODE_POSTAL',parcours.VI_CodePostalRechercheLocal__c));
        couplesCodeValeur.add(generateCodeValeur('LC.VILLE',parcours.VI_CommuneRechercheLocal__c));
        couplesCodeValeur.add(generateCodeValeur('LC.PAYS','France'));
        couplesCodeValeur.add(generateCodeValeur('SIGNATURE.NOM_CONSEILLER',userInfo.getLastName()));
        couplesCodeValeur.add(generateCodeValeur('SIGNATURE.PRENOM_CONSEILLER',userInfo.getFirstName()));
        couplesCodeValeur.add(generateCodeValeur('PP.FLAG','N'));
        /*à remplir à partir du compte du contact connecté*/
        //couplesCodeValeur.add(generateCodeValeur('PP.CODE_PARTENAIRE',currentUser.account.VI_Code_Partenaire__c)); // à modifier: champs à créer sur compte
        couplesCodeValeur.add(generateCodeValeur('PP.GF_PARTENAIRE',currentUser.account.VI_Groupe_Fonctionnel__c));//à modifier: champs à créer sur compte
        couplesCodeValeur.add(generateCodeValeur('PP.RAISON_SOCIALE_PART', currentUser.account.Name)); // à modifier: nom du compte
        system.debug('currentUser.account.VI_CodeLocalite__c'+ currentUser.account.VI_CodeLocalite__c);
        couplesCodeValeur.add(generateCodeValeur('PP.RETRACTATION',currentUser.account.VI_CodeRetractation__c)); // à identifier --> Engie
        couplesCodeValeur.add(generateCodeValeur('BCP_LOCALITE',currentUser.account.VI_CodeLocalite__c)); // à identifier --> Engie
        couplesCodeValeur.add(generateCodeValeur('PACK.ENSEIGNE_LIBELLE',currentUser.account.Name));  // à modifier: nom du compte
        //couplesCodeValeur.add(generateCodeValeur('PC.CODE_PARTENAIRE',currentUser.account.VI_Code_Partenaire__c)); // à remonter du compte 
        //couplesCodeValeur.add(generateCodeValeur('PC.CODE_VENDEUR',currentUser.contact.VI_CodeVendeur__c)); // creer le champ sur contact
        couplesCodeValeur.add(generateCodeValeur('PACK.ENSEIGNE',currentUser.account.VI_Groupe_Fonctionnel__c)); // à remonter du compte
        /* end */
        //DDPCM-1196
        system.debug('parcours.VI_CodePromo__c'+ parcours.VI_CodePromo__c);
        system.debug('parcours.VI_CodePromo2__c'+ parcours.VI_CodePromo2__c);
        if(String.isNotBlank(parcours.VI_CodePromo__c)){
            couplesCodeValeur.add(generateCodeValeur('PROMOBOX/PM.CODE_PROMO',parcours.VI_CodePromo__c));
        }
        if(String.isNotBlank(parcours.VI_CodePromo2__c)){
            couplesCodeValeur.add(generateCodeValeur('PROMOBOX/PM.CODE_PROMO',parcours.VI_CodePromo2__c));
        }
        couplesCodeValeur.add(generateCodeValeur('PC.DATE_PROPOSITION',buildDate(System.today())));
        couplesCodeValeur.add(generateCodeValeur('PC.DATE_PROPOSITION_PLUS30',buildDate(System.today().addDays(30))));
        couplesCodeValeur.add(generateCodeValeur('PC.DATE_EFFET',buildDate(parcours.VI_InfosCompl_DateContratEffectif__c)));
        couplesCodeValeur.add(generateCodeValeur('PC.DATE_FIN_VALIDITE',buildDate(System.today().addDays(15))));
        couplesCodeValeur.add(generateCodeValeur('PC.CANAL','Email'));
        couplesCodeValeur.add(generateCodeValeur('PC.NB_EXEMPLAIRES',(parcours.VI_ChoixParcours__c == 'EM'?'1':'2')));
        couplesCodeValeur.add(generateCodeValeur('PC.SITUATION_CLIENT',(parcours.VI_ChoixParcours__c == 'EM'?'MES':'CHF')));
        couplesCodeValeur.add(generateCodeValeur('FACTURATION.AUTO_PLVT',(parcours.VI_ChoixMoyenPaiement__c == 'Prélèvement automatique'?'O':'N')));
        couplesCodeValeur.add(generateCodeValeur('FACTURATION.MODE_ENCAISSEMENT','N'));
        couplesCodeValeur.add(generateCodeValeur('PACK.CODE_PRODUIT',parcours.VI_Code_pack__c));
        couplesCodeValeur.add(generateCodeValeur('PACK.LIBELLE_PACK',parcours.VI_LibelleOffrePanierClient__c));
        
        if(parcours.VI_TechOffreReferenceChoisie__c == true){
            couplesCodeValeur.add(generateCodeValeur('PACK.TRADEOFF','OUI'));//TRADEOFF
            couplesCodeValeur.add(generateCodeValeur('POURCENT_ABO_FOURNISSEUR','5'));
            couplesCodeValeur.add(generateCodeValeur('POURCENT_ABO_ACHEMINEMENT','19'));
            couplesCodeValeur.add(generateCodeValeur('POURCENT_CO_FOURNISSEUR','41'));
            couplesCodeValeur.add(generateCodeValeur('POURCENT_CO_ACHEMINEMENT','22'));
            couplesCodeValeur.add(generateCodeValeur('POURCENTAGE_OBLIGATIONS','13'));
        }
        if (parcours.VI_ConsentProspectionEngieNonAnalogue__c == 'Oui') {
            couplesCodeValeur.add(generateCodeValeur('RGPD.CONSENT_ENGIE', '1'));
        }
        else {
            couplesCodeValeur.add(generateCodeValeur('RGPD.CONSENT_ENGIE', '0'));

        }
        if (parcours.VI_ConsentProspectionPartenaire__c == 'Oui') {
            couplesCodeValeur.add(generateCodeValeur('RGPD.CONSENT_PARTENAIRES', '1'));
        }
        else {
            couplesCodeValeur.add(generateCodeValeur('RGPD.CONSENT_PARTENAIRES', '0'));

        }
        couplesCodeValeur.add(generateCodeValeur('ZP07_MENS.CODE_PRODUIT',(parcours.VI_ChoixMoyenPaiement__c == 'Prélèvement automatique'?'MENS':'')));
        couplesCodeValeur.add(generateCodeValeur('ZP07_MENS.SOUSCRIPTION',(parcours.VI_FrequencePrelevementMoyendePaiement__c == 'Mensuel'?'OUI': 'NON')));
        couplesCodeValeur.add(generateCodeValeur('ZP07_MENS.MNT_TTC_MENSU',String.valueOf(parcours.VI_MontantdelaMensualitePanierClient__c)));
        couplesCodeValeur.add(generateCodeValeur('ZP07_CEL.CODE_PRODUIT','CEL'));
        /* Start DDPCM - 1110 */
        //couplesCodeValeur.add(generateCodeValeur('ZP07_FACT_DEMAT.CODE_PRODUIT',(parcours.VI_FactureEnLigneMoyendePaiement__c == true ?'FACT_DEMAT': '')));
        couplesCodeValeur.add(generateCodeValeur('ZP07_FACT_DEMAT.CODE_PRODUIT',(parcours.VI_FactureEnLigne__c == 'Oui' ?'FACT_DEMAT': '')));
        /* End DDPCM - 1110 */
        couplesCodeValeur.add(generateCodeValeur('ZP07_DOC_CONTRACT.CODE_PRODUIT','EDOC'));
        couplesCodeValeur.add(generateCodeValeur('ZP07_PREL.CODE_PRODUIT',(parcours.VI_ChoixMoyenPaiement__c == 'Prélèvement automatique'?'PREL':'')));
        couplesCodeValeur.add(generateCodeValeur('CC.MANDAT_ACTIF','O'));
        //couplesCodeValeur.addAll(createCoupleCodeValeurINIT(parcours));
        couplesCodeValeur.addAll(coupleCodeValeurs);
        return couplesCodeValeur;
    }
    
    public static List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> getAnnexeOptionElec(VI_parcours__c parcours){
        List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> couplesCodeValeur = 
            new List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element>();
        String typeComptageOption = null;
        Map<String, prixWrapperOffre> prixWrapperElec = new Map<String, prixWrapperOffre>();
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt input=VI_SM022_PrixEtRemises.createInputPrixEtServices( 'EFOPT_VERT',
                                                                                                                                 System.now(),
                                                                                                                                 System.now(),
                                                                                                                                 'PREM_MES',
                                                                                                                                 typeComptageOption,
                                                                                                                                 '9');
        try{
            VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesResponse_element response  = VI_SM022_PrixEtRemises.recherchePrixetService(input,'callout:VI_AuthOctopus','VI','V2');
            if (response != null && response.messageRetours != null && response.messageRetours.messageRetour != null ) {
                for (VI_gdfsuezComBefChpCommunV3.messageRetour_element msgRetour : response.messageRetours.messageRetour) {
                    if ('ERREUR'.equalsIgnoreCase(msgRetour.type_x)) {
                        return null;
                    }
                }
            }
            if (response != null && response.rechercherPrixServicesOutput != null){
                system.debug('Start Analyse reponse option Elec vert + : '+ Datetime.now());
                for(VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesOutputDt output :response.rechercherPrixServicesOutput){
                    for(VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixOutDt prixOutput: output.donneesPrixAnnexe){
                        //system.debug('typePrix'+ prixOutput.typePrix);
                        
                        for(VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixDt prixOut: prixOutput.donneesPrix){
                            String puissance;
                            String typeComptage;
                            for(VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixCriteresDt criteres: prixOut.donneesPrixCriteres){
                                
                                if(criteres.donneesPrixParametre == 'ZZTYC'){
                                    typeComptage = criteres.donneesPrixValeur;
                                }
                                if(criteres.donneesPrixParametre == 'ZZPS'){
                                    puissance = criteres.donneesPrixValeur;
                                }
                            }
                            String key = puissance+'_'+ typeComptage;
                            if(!prixWrapperElec.containsKey(key)){
                                prixWrapperOffre  wrapperInit = new prixWrapperOffre();
                                wrapperInit.puissance = puissance;
                                wrapperInit.typeComptage = typeComptage;
                                prixWrapperElec.put(key, wrapperInit);
                            }
                            prixWrapperOffre wrapper = prixWrapperElec.get(key);
                            if(prixOut.donneesPrixDetails != null){
                                wrapper.ABO_HT = String.valueOf(prixOut.donneesPrixDetails.prixMensuelHT);
                                wrapper.ABO_TTC = String.valueOf(prixOut.donneesPrixDetails.prixMensuelTTC);
                            }
                            prixWrapperElec.put(key, wrapper);
                        }
                    }
                }
                system.debug('End Analyse reponse option Elec vert + : '+ Datetime.now());
            }
            
            for(String key: prixWrapperElec.keySet()){
                if(prixWrapperElec.get(key) != null){
                    prixWrapperOffre wrapper = prixWrapperElec.get(key);
                    couplesCodeValeur.add(generateCodeValeur('ANNEXE_OPTION_VERTE_ELEC_FRANCE/PUISS_SOUS',wrapper.puissance));
                    couplesCodeValeur.add(generateCodeValeur('ANNEXE_OPTION_VERTE_ELEC_FRANCE/TYP_COMP',wrapper.typeComptage));
                    couplesCodeValeur.add(generateCodeValeur('ANNEXE_OPTION_VERTE_ELEC_FRANCE/ABO_HT',wrapper.ABO_TTC));
                    couplesCodeValeur.add(generateCodeValeur('ANNEXE_OPTION_VERTE_ELEC_FRANCE/ABO_TTC',wrapper.ABO_HT));
                }
            }
            return couplesCodeValeur;
        }
        catch(exception e){
            system.debug('exception e: '+ e.getmessage());
            return null;
        }
    }
    
    
    
    public static List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> getAnnexeOptionGaz(VI_parcours__c parcours){
        List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> couplesCodeValeur = 
            new List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element>();
        String plageConsommationOption = null;
        Map<Integer, prixWrapperOffre> prixWrapperGazOption = new Map<Integer, prixWrapperOffre>();
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt input=VI_SM022_PrixEtRemises.createInputPrixEtServicesGaz( 'GOPT_VERT',
                                                                                                                                    system.now(),
                                                                                                                                    system.now(),
                                                                                                                                    'PREM_MES',
                                                                                                                                    plageConsommationOption,
                                                                                                                                    '10');
        try{
            VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesResponse_element response  = VI_SM022_PrixEtRemises.recherchePrixetService(input,'callout:VI_AuthOctopus','VI','V2');
            if (response != null && response.messageRetours != null && response.messageRetours.messageRetour != null ) {
                for (VI_gdfsuezComBefChpCommunV3.messageRetour_element msgRetour : response.messageRetours.messageRetour) {
                    if ('ERREUR'.equalsIgnoreCase(msgRetour.type_x)) {
                        return null;
                    }
                }
            }
            if (response != null && response.rechercherPrixServicesOutput != null){
                system.debug('Start Analyse reponse option Gaz vert + : '+ Datetime.now());
                for(VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesOutputDt output :response.rechercherPrixServicesOutput){
                    //system.debug('output '+output);
                    //system.debug('output.donneesPrixAnnexe '+output.donneesPrixAnnexe);
                    for(VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixOutDt prixOutput: output.donneesPrixAnnexe){
                        //system.debug('typePrix'+ prixOutput.typePrix);
                        
                        for(VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixDt prixOut: prixOutput.donneesPrix){
                            Integer pourcentage=0;
                            Integer plageConsommation=0;
                            for(VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixCriteresDt criteres: prixOut.donneesPrixCriteres){
                                //system.debug('criteres.donneesPrixValeur '+criteres.donneesPrixValeur);
                                //system.debug('Integer.valueOf(criteres.donneesPrixValeur '+Integer.valueOf(criteres.donneesPrixValeur));
                                if(criteres.donneesPrixParametre == 'ZZCAE'){
                                    plageConsommation = Integer.valueOf(criteres.donneesPrixValeur);
                                }
                                if(criteres.donneesPrixParametre == 'ZZTAUX'){
                                    pourcentage = Integer.valueOf(criteres.donneesPrixValeur);
                                }
                            }
                            Integer key = pourcentage+ plageConsommation;
                            if(!prixWrapperGazOption.containsKey(key)){
                                prixWrapperOffre  wrapperInit = new prixWrapperOffre();
                                wrapperInit.plageConsommation = String.ValueOf(plageConsommation);
                                wrapperInit.pourcentageVert = String.ValueOf(pourcentage);
                                prixWrapperGazOption.put(key, wrapperInit);
                            }
                            prixWrapperOffre wrapper = prixWrapperGazOption.get(key);
                            if(prixOut.donneesPrixDetails != null){
                                wrapper.ABO_HT = String.valueOf(prixOut.donneesPrixDetails.prixMensuelHT);
                                wrapper.ABO_TTC = String.valueOf(prixOut.donneesPrixDetails.prixMensuelTTC);
                            }
                            prixWrapperGazOption.put(key, wrapper);
                        }
                    }
                }
                system.debug('End Analyse reponse option Gaz vert + : '+ Datetime.now());
            }
            //HPHC
            //3CADRANS
            List<Integer> consoList = new List<Integer>();
            consoList.addAll(prixWrapperGazOption.keySet());
            consoList.sort();
            for(Integer key: consoList){
                if(prixWrapperGazOption.get(key) != null){
                    prixWrapperOffre wrapper = prixWrapperGazOption.get(key);
                    String consoString = (wrapper.plageConsommation== '6000'? 'Jusqu\'à 6000 kwh': (wrapper.plageConsommation == '30000'?'de 6000 à 30000 kWh':(wrapper.plageConsommation == '300000'? 'plus de 30000 kWh': '0') ));
                    couplesCodeValeur.add(generateCodeValeur('ANNEXE_OPTION_VERTE_GAZ/PLGE_CONSO',consoString));
                    couplesCodeValeur.add(generateCodeValeur('ANNEXE_OPTION_VERTE_GAZ/POUCENTAGE_VERT',wrapper.pourcentageVert));
                    couplesCodeValeur.add(generateCodeValeur('ANNEXE_OPTION_VERTE_GAZ/ABO_HT',wrapper.ABO_HT));
                    couplesCodeValeur.add(generateCodeValeur('ANNEXE_OPTION_VERTE_GAZ/ABO_TTC',wrapper.ABO_TTC));
                }
            }
            return couplesCodeValeur;
        }
        catch(exception e){
            system.debug('exception e: '+ e.getmessage());
            return null;
        }
    }
    
    public static List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> getAnnexeOffreGazElec(VI_parcours__c parcours){
        System.debug('### START creerCPVSansPC : ');
        List <VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt> inputs = new List<VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt>();
        String contexteSouscription = (parcours.VI_ChoixParcours__c == 'EM'?'MES_EMM':'CHGT_FOURN');
        string typeComptageParcours;
        if(parcours.VI_ChoixEstimation__c == 'Saisir la consommation d\'énergie'){
            typeComptageParcours = (parcours.VI_SaisieConsommationElec_HP_HC__c == true? 'HPHC':'SIMPLE');
        }
        else{
            typeComptageParcours = (parcours.VI_SaisieEstimationConsoElec_HP_HC__c == 'Oui'? 'HPHC':'SIMPLE');
        }
        system.debug('typeComptageParcours'+ typeComptageParcours);
        if(parcours.VI_ChoixEnergie__c != 'Gaz'){
            Integer CAElec ;//champs à creer sur parcours
            List<String>  idOffre = new List<String>();
            idOffre.add(parcours.VI_OffreChoisieElecPanierClient__c);
            VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt inputElec = VI_parcoursOffre_Controller.prepareOffer(
                parcours.VI_CodeCommuneIdentificationLocal__c, parcours.VI_CodePostalRechercheLocal__c, 
                parcours.VI_code_Pack__c, idOffre,
                null,parcours.VI_ChoixOffrePourcentageOffreVerte__c  , 
                parcours.VI_ChoixOffreStructureMesureFournisseur__c, CAElec,
                parcours.VI_EstimationNiveauOuvertureServices__c,null,parcours.VI_InfosCompl_DateContratEffectif__c,
                parcours.VI_DateLastModifFormTarifaireAcheminemt__c,parcours.VI_EstimationFtaCode__c,contexteSouscription); 
            inputs.add(inputElec);
        }
        if(parcours.VI_ChoixEnergie__c != 'Electricité'){
            String plageConsommation = (parcours.VI_GazPlageConso__c<= 5999? '6000': (parcours.VI_GazPlageConso__c <= 29999?'30000':(parcours.VI_GazPlageConso__c >= 30000? '300000': '0') ));
            List<String>  idOffreGaz = new List<String>();
            idOffreGaz.add(parcours.VI_OffreChoisieGazPanierClient__c);
            VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt inputGaz = VI_parcoursOffre_Controller.prepareOffer(
                parcours.VI_CodeCommuneIdentificationLocal__c, parcours.VI_CodePostalRechercheLocal__c, 
                parcours.VI_code_Pack__c, idOffreGaz,null,null , null, null,null,null,parcours.VI_InfosCompl_DateContratEffectif__c,
                parcours.VI_DateLastModifFormTarifaireAcheminemt__c,parcours.VI_EstimationFtaCode__c,contexteSouscription); 
            inputs.add(inputGaz); 
        }
        //appel webservice de la classe offre
        Map<Integer, prixWrapperOffre> prixWrapperGaz = new Map<Integer, prixWrapperOffre>();
        Map<String, prixWrapperOffre> prixWrapperElec = new Map<String, prixWrapperOffre>();
        try{
            VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element response = VI_SM022_PrixEtRemises.recherchePrixetRemise(inputs, 'callout:VI_AuthOctopus', 'VI', 'V2');                          
            if (response != null && response.messageRetours != null && response.messageRetours.messageRetour != null ) {
                for (VI_gdfsuezComBefChpCommunV3.messageRetour_element msgRetour : response.messageRetours.messageRetour) {
                    if ('ERREUR'.equalsIgnoreCase(msgRetour.type_x)) {
                        system.debug('ERREUR'+ msgRetour.libelle );
                        system.debug('ERREUR'+ msgRetour.code );
                        return null;
                    }
                }
            }
            
            List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> couplesCodeValeur = 
                new List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element>(); 
            if(response != null && response.rechercherPrixEtRemisesOutput != null){
                system.debug('Start Analyse reponse offre: '+ Datetime.now());
                for (VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt donneesRetour : response.rechercherPrixEtRemisesOutput) {
                    if (donneesRetour != null && donneesRetour.donneesOffre != null) {
                        VI_gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt[] donneesOffre = donneesRetour.donneesOffre;
                        system.debug('donneesOffre'+ donneesOffre);
                        for (VI_gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt data : donneesOffre) {
                            VI_gdfsuezBefCalypsoPrixetremisesV2.listePrixDt listePrix = data.listePrix;
                            if (listePrix != null) {
                                for (VI_gdfsuezBefCalypsoPrixetremisesV2.prixDt prix : listePrix.prix) {
                                    //Get Gaz caracteristiques
                                    system.debug('ListPrix');
                                    if (prix.caracteristiquesGaz != null && prix.caracteristiquesGaz.typePrix!= null
                                        && prix.caracteristiquesGaz.plageconsommation != null) {
                                            Integer plageConso = Integer.ValueOf(prix.caracteristiquesGaz.plageConsommation.code);
                                            if(!prixWrapperGaz.containsKey(plageConso)){
                                                prixWrapperGaz.put(plageConso, new prixWrapperOffre());
                                            }
                                            prixWrapperOffre wrapper = prixWrapperGaz.get(plageConso);
                                            
                                            if (prix.caracteristiquesGaz.typePrix.code == 'AB') {
                                                wrapper.ABO_HT = String.valueOf(prix.montantHT);
                                                wrapper.ABO_TTC = String.valueOf(prix.montantTTC);
                                                
                                            }
                                            if (prix.caracteristiquesGaz.typePrix.code == 'CO') {
                                                wrapper.CO_HT = String.valueOf(prix.montantHT);
                                                wrapper.CO_TTC = String.valueOf(prix.montantTTC);
                                            }
                                            if (prix.caracteristiquesGaz.typePrix.code == 'ACHAB') {
                                                wrapper.ACHAB_HT = String.valueOf(prix.montantHT);
                                                wrapper.ACHAB_TTC = String.valueOf(prix.montantTTC);
                                            }
                                            if (prix.caracteristiquesGaz.typePrix.code == 'ACHCO') {
                                                wrapper.ACHCO_HT = String.valueOf(prix.montantHT);
                                                wrapper.ACHCO_TTC = String.valueOf(prix.montantTTC);
                                            }
                                            if (prix.caracteristiquesGaz.typePrix.code == 'OB') {
                                                wrapper.OB_HT = String.valueOf(prix.montantHT);
                                                wrapper.OB_TTC = String.valueOf(prix.montantTTC);
                                            }
                                            if (prix.caracteristiquesGaz.typePrix.code == 'OM') {
                                                wrapper.OM_HT = String.valueOf(prix.montantHT);
                                                wrapper.OM_TTC = String.valueOf(prix.montantTTC);
                                            }
                                            prixWrapperGaz.put(plageConso, wrapper);
                                        }
                                    if (prix.caracteristiquesElec != null && prix.caracteristiquesElec.typePrix != null
                                        && prix.caracteristiquesElec.puissance != null && prix.caracteristiquesElec.typeComptage != null) {
                                            system.debug('here 1');
                                            string puissance = String.valueOf(prix.caracteristiquesElec.puissance.code);
                                            system.debug('here 3');
                                            string typeComptage = String.valueOf(prix.caracteristiquesElec.typeComptage.code);
                                            system.debug('here 4');
                                            String key = puissance+'_'+ ((typeComptage == 'S'|| prix.caracteristiquesElec.typeComptage.code == 'STR_MESURE_SIMPLE'|| prix.caracteristiquesElec.typeComptage.code == 'BASE')?'SIMPLE':'HPHC');
                                            if(!prixWrapperElec.containsKey(key)){
                                                prixWrapperOffre  wrapperInit = new prixWrapperOffre();
                                                wrapperInit.puissance = puissance;
                                                wrapperInit.typeComptage = ((typeComptage == 'S'|| prix.caracteristiquesElec.typeComptage.code == 'STR_MESURE_SIMPLE'|| prix.caracteristiquesElec.typeComptage.code == 'BASE')?'SIMPLE':'HPHC');
                                                prixWrapperElec.put(key, wrapperInit);
                                            }
                                            prixWrapperOffre wrapper = prixWrapperElec.get(key);
                                            if (prix.caracteristiquesElec.typePrix.code == 'AB') {
                                                wrapper.ABO_HT = String.valueOf(prix.montantHT);
                                                wrapper.ABO_TTC = String.valueOf(prix.montantTTC);
                                            }
                                            if (prix.caracteristiquesElec.typePrix.code == 'ACHAB') {
                                                wrapper.ACHAB_HT = String.valueOf(prix.montantHT);
                                                wrapper.ACHAB_TTC = String.valueOf(prix.montantTTC);
                                            }
                                            if (prix.caracteristiquesElec.typePrix.code == 'ACHCO') {
                                                wrapper.ACHCO_HT = String.valueOf(prix.montantHT);
                                                wrapper.ACHCO_TTC = String.valueOf(prix.montantTTC);
                                            }
                                            if (prix.caracteristiquesElec.typePrix.code == 'CO') {
                                                if(typeComptage == 'P' || typeComptage == 'HP' ||typeComptage == 'S'|| typeComptage == 'STR_MESURE_SIMPLE'|| typeComptage == 'BASE'){
                                                    wrapper.CO_HT = String.valueOf(prix.montantHT);
                                                    wrapper.CO_TTC = String.valueOf(prix.montantTTC);
                                                }
                                                if(typeComptage == 'C'|| typeComptage == 'HC'){
                                                    wrapper.CO_HC_HT = String.valueOf(prix.montantHT);
                                                    wrapper.CO_HC_TTC = String.valueOf(prix.montantTTC);
                                                }
                                            }
                                            if (prix.caracteristiquesElec.typePrix.code == 'OB') {
                                                wrapper.OB_HT = String.valueOf(prix.montantHT);
                                                wrapper.OB_TTC = String.valueOf(prix.montantTTC);
                                            }
                                            if (prix.caracteristiquesElec.typePrix.code == 'OM') {
                                                wrapper.OM_HT = String.valueOf(prix.montantHT);
                                                wrapper.OM_TTC = String.valueOf(prix.montantTTC);
                                            }
                                            system.debug('## ACH: typeComptage wrapper'+ wrapper);
                                            prixWrapperElec.put(key, wrapper);
                                        }
                                }
                            }
                        }
                    }
                }
                system.debug('End Analyse reponse offre: '+ Datetime.now());
            }
            List<Integer> consoList = new List<Integer>();
            consoList.addAll(prixWrapperGaz.keySet());
            consoList.sort();
            for(Integer conso: consoList){
                if(prixWrapperGaz.get(conso) != null){
                    prixWrapperOffre wrapper = prixWrapperGaz.get(conso);
                    //String consoString = (conso== 6000? 'Jusqu\' à 6000 kWh': (conso == 30000?'de 6000 à 30000 kWh':(conso == 300000? 'plus de 300000 kWh': '0') ));
                    String consoString = (conso== 6000? '0 à 6000 kWh': (conso == 30000?'6 000 à 30 000 kWh':(conso == 300000? '30 000 à 300 000 kWh': '0') ));
                    if(parcours.VI_TechOffreReferenceChoisie__c == false){
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_BINOME/PLGE_CONSO',String.ValueOf(consoString)));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_BINOME/ABO_HT',wrapper.ABO_HT));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_BINOME/ABO_TTC',wrapper.ABO_TTC));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_BINOME/CONSO_HT',wrapper.CO_HT));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_BINOME/CONSO_TTC',wrapper.CO_TTC));
                    }
                    //TRADEOFF
                    else{
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_BINOME/PLGE_CONSO',String.ValueOf(consoString)));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_BINOME/ABO_HT',wrapper.ABO_HT));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_BINOME/ABO_TTC',wrapper.ABO_TTC));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_BINOME/CONSO_HT',wrapper.CO_HT));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_BINOME/CONSO_TTC',wrapper.CO_TTC));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_DIST/PLGE_CONSO',String.ValueOf(consoString)));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_DIST/ABO_ACH_HTT',wrapper.ACHAB_HT));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_DIST/ABO_ACH_TTC',wrapper.ACHAB_TTC));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_DIST/CO_ACH_HTT',wrapper.ACHCO_HT));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_DIST/CO_ACH_TTC',wrapper.ACHCO_TTC));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_OBLIG/PLGE_CONSO',String.ValueOf(consoString))); 
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_OBLIG/OBLIG_HTT',wrapper.OB_HT));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_OBLIG/OBLIG_TTC',wrapper.OB_TTC));  
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_OBLIG/OBL_MAX_HTT',wrapper.OM_HT));
                        couplesCodeValeur.add(generateCodeValeur('ANNEXE_GAZ_OBLIG/OBL_MAX_TTC',wrapper.OM_TTC));
                    }
                }
            }
            
            for(String key: prixWrapperElec.keySet()){
                system.debug('here 6');
                if(prixWrapperElec.get(key) != null){
                    prixWrapperOffre wrapper = prixWrapperElec.get(key);
                    system.debug('prixWrapperElec'+ prixWrapperElec.get(key));
                    if(parcours.VI_TechOffreReferenceChoisie__c == false){
                        if(wrapper.typeComptage == 'SIMPLE'){
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_SIMPLE/PUISS_SOUS',wrapper.puissance));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_SIMPLE/ABO_HT',wrapper.ABO_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_SIMPLE/ABO_TTC',wrapper.ABO_TTC));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_SIMPLE/CONSO_HT',wrapper.CO_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_SIMPLE/CONSO_TTC',wrapper.CO_TTC));
                        }
                        else if(wrapper.typeComptage == 'HPHC'){
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_HPHC/PUISS_SOUS',wrapper.puissance));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_HPHC/ABO_HT',wrapper.ABO_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_HPHC/ABO_TTC',wrapper.ABO_TTC));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_HPHC/CONSO_HP_HT',wrapper.CO_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_HPHC/CONSO_HP_TTC',wrapper.CO_TTC));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_HPHC/CONSO_HC_HT',wrapper.CO_HC_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_HPHC/CONSO_HC_TTC',wrapper.CO_HC_TTC));
                        }
                    }
                    //TRADEOFF
                    else{
                        if(wrapper.typeComptage == 'SIMPLE'){
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_SIMPLE/PUISS_SOUS',wrapper.puissance));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_SIMPLE/ABO_HT',wrapper.ABO_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_SIMPLE/ABO_TTC',wrapper.ABO_TTC));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_SIMPLE/CONSO_HT',wrapper.CO_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_SIMPLE/CONSO_TTC',wrapper.CO_TTC));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_DIST_1/PUISS_SOUS',wrapper.puissance));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_DIST_1/ABO_ACH_HTT',wrapper.ABO_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_DIST_1/ABO_ACH_TTC',wrapper.ABO_TTC));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_DIST_1/CO_ACH_CAD1_HTT',wrapper.ACHCO_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_DIST_1/CO_ACH_CAD1_TTC',wrapper.ACHCO_TTC));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_SIMPLE_OBLIG/PUISS_SOUS',wrapper.puissance));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_SIMPLE_OBLIG/OBLIG_HTT',wrapper.OB_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_SIMPLE_OBLIG/OBLIG_TTC',wrapper.OB_TTC));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_SIMPLE_OBLIG/OBL_MAX_HTT',wrapper.OM_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_SIMPLE_OBLIG/OBL_MAX_TTC',wrapper.OM_TTC));
                        }
                        else if(wrapper.typeComptage == 'HPHC'){
                            if(wrapper.ABO_HT != null){
                                couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_HPHC/PUISS_SOUS',wrapper.puissance));
                                couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_HPHC/ABO_HT',wrapper.ABO_HT));
                                couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_HPHC/ABO_TTC',wrapper.ABO_TTC));
                                couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_HPHC/CONSO_HP_HT',wrapper.CO_HT));
                                couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_HPHC/CONSO_HP_TTC',wrapper.CO_TTC));
                                couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_HPHC/CONSO_HC_HT',wrapper.CO_HC_HT));
                                couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_BINOME_HPHC/CONSO_HC_TTC',wrapper.CO_HC_TTC));
                            }
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_DIST_1/ABO_ACH_HTT',wrapper.ABO_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_DIST_1/ABO_ACH_TTC',wrapper.ABO_TTC));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_DIST_1/CO_ACH_CAD1_HTT',wrapper.ACHCO_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_DIST_1/CO_ACH_CAD1_TTC',wrapper.ACHCO_TTC));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_DIST_1/CO_ACH_CAD2_HTT',wrapper.ACHCO_HC_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_ELEC_DIST_1/CO_ACH_CAD2_TTC',wrapper.ACHCO_HC_TTC));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_HPHC_OBLIG/PUISS_SOUS',wrapper.puissance));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_HPHC_OBLIG/OBLIG_HTT',wrapper.OB_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_HPHC_OBLIG/OBLIG_TTC',wrapper.OB_TTC));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_HPHC_OBLIG/OBL_MAX_HTT',wrapper.OM_HT));
                            couplesCodeValeur.add(generateCodeValeur('ANNEXE_HPHC_OBLIG/OBL_MAX_TTC',wrapper.OM_TTC));
                        }
                    }
                }
            }
            return couplesCodeValeur;
        }
        catch(exception e){
            system.debug('exception e: '+ e.getmessage());
            return null;
        }
    }
    
    public static VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element generateCodeValeur( String contenuCode, String Valeur){
        
        VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element coupleCodeValeur =
            new VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element();
        coupleCodeValeur.valeur = valeur;
        // définition du code :
        VI_gdfsuezComBefChpPivotCpvV2.listeValeursDt code = new VI_gdfsuezComBefChpPivotCpvV2.listeValeursDt();
        code.code =contenuCode;
        coupleCodeValeur.code = code;        
        return coupleCodeValeur;
        
    }
    
    public static String buildDate ( Date dateToConvert){
        if(dateToConvert != null){
            String year = String.valueof(dateToConvert.year());
            String Month = (String.valueof(dateToConvert.month()).length()==1? '0'+String.valueof(dateToConvert.month()):String.valueof(dateToConvert.month()));
            String Day = (String.valueof(dateToConvert.day()).length()==1? '0'+String.valueof(dateToConvert.day()):String.valueof(dateToConvert.day()));
            return year+Month+Day;
        }
        return '';
    }
    
    public static VI_gdfsuezComBefCalypsoCpvV2.creerCPVSansPCResponse_element creerCPVsansPC(String idFormulaireLibelle, String idFormulaireCode, List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> couplesCodeValeur, Boolean documentValide, Boolean documentRetourne, String ctxt, String NamedCredential){
        
        Map <String, Object> outMap = new Map<String, Object>();
        String version = '2.0'; 
        Map < String, String > headers = new Map < String, String >();
        headers.put('Content-Type', 'text/xml;charset=utf-8');
        
        VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt listeCodeValeur = new VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt();
        listeCodeValeur.coupleCodeValeur = couplesCodeValeur;
        
        
        VI_gdfsuezComBefChpPivotCpvV2.listeValeursDt idFormulaire = new VI_gdfsuezComBefChpPivotCpvV2.listeValeursDt();
        idFormulaire.code = idFormulaireCode;
        idFormulaire.libelleCourt = idFormulaireLibelle;
        
        
        VI_gdfsuezComBefCalypsoCpvV2.creerCPVSansPCInputDt creerCPVSansPCInput = new VI_gdfsuezComBefCalypsoCpvV2.creerCPVSansPCInputDt(); 
        creerCPVSansPCInput.documentValide = documentValide;
        creerCPVSansPCInput.documentRetourne = documentRetourne;
        creerCPVSansPCInput.idFormulaire = idFormulaire;
        creerCPVSansPCInput.listeCodeValeur = listeCodeValeur;
        
        // Instanciation des éléments du context.
        
        VI_gdfsuezComBefChpPivotCpvV2.contextDt_systemPath_system_element syst = new VI_gdfsuezComBefChpPivotCpvV2.contextDt_systemPath_system_element();   
        syst.systemId = ctxt;
        
        List<VI_gdfsuezComBefChpPivotCpvV2.contextDt_systemPath_system_element> system_x = new List<VI_gdfsuezComBefChpPivotCpvV2.contextDt_systemPath_system_element>();   
        system_x.add(syst);
        
        VI_gdfsuezComBefChpPivotCpvV2.contextDt_systemPath_element systemPath = new VI_gdfsuezComBefChpPivotCpvV2.contextDt_systemPath_element();   
        systemPath.system_x = system_x;
        
        VI_gdfsuezComBefChpPivotCpvV2.contextDt context = new VI_gdfsuezComBefChpPivotCpvV2.contextDt();
        context.version = version;
        context.allowCache = false;
        context.systemPath = systemPath;
        
        // Appel au WS et remplissage de l'outMap à partir de la réponse.
        VI_gdfsuezComBefCalypsoCpvV2.CPVPort port = new VI_gdfsuezComBefCalypsoCpvV2.CPVPort();
        port.endpoint_x = NamedCredential+'/ES-CPV_v2';
        port.inputHttpHeaders_x = headers;
        
        VI_gdfsuezComBefCalypsoCpvV2.creerCPVSansPCResponse_element reponse = new VI_gdfsuezComBefCalypsoCpvV2.creerCPVSansPCResponse_element();
        XMLSerializer serializer1 = new XMLSerializer();
        String serializedXML1 = serializer1.serialize(creerCPVSansPCInput,true, null); 
        system.debug('serializedXML creerCPVSansPCInput'+ serializedXML1);
        if(!Test.isRunningTest()){
            //reponse = port.CreerCPVSansPC_Http(creerCPVSansPCInput, context);
            reponse = CreerCPVSansPC_Http(creerCPVSansPCInput, context, namedCredential);
        }
        else{
            Test.setMock(HttpCalloutMock.class, new VI_SM025_CreerCPVSansPC_Mock());
            VI_gdfsuezComBefCalypsoCpvV2.CPVPort portTest = new VI_gdfsuezComBefCalypsoCpvV2.CPVPort();
            reponse = CreerCPVSansPC_Http(creerCPVSansPCInput, context, namedCredential);
        }       
        return reponse;
    }
    
    public static VI_gdfsuezComBefCalypsoCpvV2.creerCPVSansPCResponse_element CreerCPVSansPC_Http(VI_gdfsuezComBefCalypsoCpvV2.creerCPVSansPCInputDt creerCPVSansPCInput,VI_gdfsuezComBefChpPivotCpvV2.contextDt context, String NamedCredential) {
        DOM.Document doc = new DOM.Document();
        DOM.XmlNode body = populateDoc(doc);
        DOM.XmlNode methodNode = body.addChildElement('v2:creerCPVSansPC', '', '');			
        VI_gdfsuezComBefCalypsoCpvV2.creerCPVSansPC_element request_x = new VI_gdfsuezComBefCalypsoCpvV2.creerCPVSansPC_element(creerCPVSansPCInput,context);
        request_x.populateXmlNode(methodNode);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(NamedCredential+ '/ES-CPV_v2');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        req.setHeader('SOAPAction', 'tns:CreerCPVSansPC');
        System.debug('doc'+ doc.toXmlString());
        req.setBodyDocument(doc);
        System.debug(req.getBody());
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        Dom.Document responseDoc = res.getBodyDocument();
        Dom.XmlNode rootNode = responseDoc.getRootElement();
        Dom.XmlNode bodyNode = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
        Dom.XmlNode creerCPVSansPCResponseNode = bodyNode.getChildElement('creerCPVSansPCResponse', 'http://gdfsuez.com/bef/calypso/cpv/v2');
        VI_gdfsuezComBefCalypsoCpvV2.creerCPVSansPCResponse_element response_x = new VI_gdfsuezComBefCalypsoCpvV2.creerCPVSansPCResponse_element(creerCPVSansPCResponseNode);
        System.debug('response_x'+ response_x);
        return response_x;
    }
    
    private static DOM.XmlNode populateDoc(DOM.Document doc){
        String env = 'http://schemas.xmlsoap.org/soap/envelope/';
        String xsi = 'http://gdfsuez.com/bef/calypso/cpv/v2';//'http://www.w3.org/2001/XMLSchema-instance';
        String xsd = 'http://schemas.xmlsoap.org/soap/envelope/';//'http://www.w3.org/2001/XMLSchema';
        
        DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'soapenv');
        envelope.setNamespace('soapenv', xsd);
        envelope.setNamespace('v2', xsi);
        DOM.XmlNode header = envelope.addChildElement('Header', env, 'soapenv');
        //System.debug(doc.toXmlString());
        DOM.XmlNode body = envelope.addChildElement('Body', env, 'soapenv');
        return body;
    }
    
    public class prixWrapperOffre{
        String ABO_HT;
        String ABO_TTC;
        String CO_HT;
        String CO_TTC;
        String CO_HC_HT;
        String CO_HC_TTC;
        String ACHAB_HT;
        String ACHAB_TTC;
        String ACHCO_HT;
        String ACHCO_TTC;
        String ACHCO_HC_HT;
        String ACHCO_HC_TTC;
        String OB_HT;
        String OB_TTC;
        String OM_HT;
        String OM_TTC;
        String typeComptage;
        String puissance;
        String plageConsommation;
        String pourcentageVert;
    }
    
    public class retourCPV{
        public String idDocument;
        public String contenuDocument;
        public String message;
        
        public retourCPV( String idDocument, String contenuDocument, String message){
            this.idDocument = idDocument;
            this.contenuDocument = contenuDocument;
            this.message = message;
        }
    }
}