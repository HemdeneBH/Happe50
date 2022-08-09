/**
 * @description       : Controller class for SM_CaseHarmonicaMoveIn Aura component
 * @author            : ???
 * @group             : 
 * @last modified on  : 08-12-2021
 * @last modified by  : Yassine HOUDAJ
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   ??-??-????   ???             Initial Version
 * 1.1   03-11-2021   David ATTALI    FT1-4449 + Refactoring
 * 1.2   08-12-2021   Yassine HOUDAJ  FT1-5079
 * 1.3   25-01-2022   Olivier MADRE  FT1-5591
**/
public class SM_CaseHarmonicaMoveIn_controller {
    
    public static final Boolean HAS_PERMISSION_EMM_LWC = FeatureManagement.checkPermission('SM_EnableLwcAcquisition');    
    
    public class HarmonicaData {
        @AuraEnabled public String harmonicaBankDetailsId;
        @AuraEnabled public Donnees_Vente__c data;
        @AuraEnabled public Boolean hasPermissionEnableLwcAcquisition;
    }

    @AuraEnabled
    public static HarmonicaData getData(String caseId) {
        
        // Get MoveInData from Donnees_Vente__c
        Donnees_Vente__c data = [SELECT Abonement_elec_HT__c, Abonement_elec_TTC__c, Abonement_gaz_HT__c,Abonement_gaz_TTC__c, batiment__c,
                                 CaseId__r.ContactId, CaseId__r.AccountId, CaseId__r.Contact.Identifiant_Buisness_Partener__c, CaseId__r.Origin, CaseId__r.Sous_type__c, CaseId__r.Type, CaseId__r.ParentId,
                                 Code_enseigne_remise_web__c, Code_offre_elec__c, Code_offre_gaz__c, Code_pack__c, Code_postale__c, Code_promotion__c, Commune__c, 
                                 Consomation_elec_HC_HT__c, Consomation_elec_HC_TTC__c,
                                 Consomation_elec_HP_HT__c, Consomation_elec_HP_TTC__c,
                                 Consomation_elec_simple_HT__c, Consomation_elec_simple_TTC__c,
                                 Consomation_elec_WE_HT__c, Consomation_elec_WE_TTC__c,
                                 Consomation_gaz_HT__c, Consomation_gaz_TTC__c,
                                 Date_mise_en_service__c, Dispositif_chauffage__c, Dispositif_production_eau_chaude__c, 
                                 E_documents__c, e_services_FEL__c, E_service_prelevement_auto__c, Energie_production_eau_chaude__c, Escalier__c,
                                 Estimation_conso_elec_HC__c, Estimation_conso_elec_HP__c,
                                 Estimation_conso_elec_st__c, Estimation_conso_elec_we__c,
                                 Estimation_conso_gaz__c, Etage__c,
                                 IBAN__c, IBAN_crypte__c, IBAN_Titulaire__c, ID_coordonnees_bancaires__c, idBan__c,
                                 Index_elec_HC__c, Index_elec_HP__c, Index_elec_HP_simple__c, Index_gaz__c, Libelle_voie__c,
                                 Mensualisation__c, mensualite_elec_TTC__c, mensualite_gaz_TTC__c, mensualite_totale_TTC__c, montantAjustable__c, Montant_mensualites__c,
                                 NB_occupants__c, numero_appartement__c, Numero_de_voie__c,
                                 Plage_de_consommation__c, Point_comptage_estimation__c, Point_de_livraison__c, Porte__c, Puissance__c, Surface_logement__c,
                                 Type_chauffage__c, Type_de_Comptage__c, Type_de_compteur_Elec__c, Type_de_compteur_Gaz__c,Type_habitation__c,Type_residence_logement__c,


                                 pourcentage_gaz_vert_plus__c,elec_vert_plus__c,gaz_vert_plus__c,HA_Type_Enseigne__c, HA_Enseigne__c,Naissance_assure__c,CaseId__r.Assurance_facture__c,
                                 TOTAL_MONTANT_ABO_GAZ_HT__c, TOTAL_MONTANT_ABO_ELEC_HT__c, MONTANT_ABO_ELEC_ACH_HT__c, MONTANT_ABO_GAZ_ACH_HT__c, MONTANT_ABO_ELEC_FOUR_HT__c, MONTANT_ABO_GAZ_FOUR_HT__c,
                                 TOTAL_MONTANT_CONSO_ELEC_HT__c, TOTAL_MONTANT_CONSO_GAZ_HT__c, PRIX_KWH_GAZ_ACH_HT__c, PRIX_KWH_GAZ_FOUR_HT__c, PRIX_KWH_ELEC_OBLI_HT__c, PRIX_KWH_GAZ_OBLI_HT__c,
                                 TOTAL_MONTANT_ABO_ELEC__c, TOTAL_MONTANT_ABO_GAZ__c,TOTAL_MONTANT_CONSO_ELEC__c, TOTAL_MONTANT_CONSO_GAZ__c, PRIX_KWH_GAZ_ACH__c, PRIX_KWH_GAZ_FOUR__c,
                                 PRIX_KWH_ELEC_OBLI__c, PRIX_KWH_GAZ_OBLI__c, MONTANT_ABO_ELEC_ACH__c, MONTANT_ABO_ELEC_FOUR__c, PRIX_KWH_ELEC_ACH__c, PRIX_KWH_ELEC_ACH_HT__c,
                                 PRIX_KWH_ELEC_ACH_HP__c, PRIX_KWH_ELEC_ACH_HP_HT__c, PRIX_KWH_ELEC_ACH_HC__c, PRIX_KWH_ELEC_ACH_HC_HT__c, PRIX_KWH_ELEC_ACH_HPH__c, PRIX_KWH_ELEC_ACH_HPH_HT__c,
                                 PRIX_KWH_ELEC_ACH_HCH__c, PRIX_KWH_ELEC_ACH_HCH_HT__c, PRIX_KWH_ELEC_ACH_HPB__c, PRIX_KWH_ELEC_ACH_HPB_HT__c, PRIX_KWH_ELEC_ACH_HCB__c, PRIX_KWH_ELEC_ACH_HCB_HT__c,
                                 PRIX_KWH_ELEC_FOUR_HT__c, PRIX_KWH_ELEC_FOUR__c, PRIX_KWH_ELEC_FOUR_HP__c, PRIX_KWH_ELEC_FOUR_HP_HT__c, PRIX_KWH_ELEC_FOUR_HC__c, PRIX_KWH_ELEC_FOUR_HC_HT__c,
                                 PRIX_KWH_ELEC_FOUR_WE__c, PRIX_KWH_ELEC_FOUR_WE_HT__c, MONTANT_ABO_GAZ_FOUR__c, MONTANT_ABO_GAZ_ACH__c, CODE_FTA__c

                                 FROM Donnees_Vente__c WHERE CaseId__c = :caseId];
        
        
        HarmonicaData harmonica = new HarmonicaData();
        harmonica.data = data;

        harmonica.hasPermissionEnableLwcAcquisition = HAS_PERMISSION_EMM_LWC; 
        System.debug('### OLI PSET ' + harmonica.hasPermissionEnableLwcAcquisition);
        
        String idBP = data.CaseId__r.Contact.Identifiant_Buisness_Partener__c;
        String ibanCrypte = data.IBAN_crypte__c;
        String ibanTitulaire = data.IBAN_Titulaire__c;
        String caseOrigin = data.CaseId__r.Origin;
        String harmonicaBankDetailsId  = data.ID_coordonnees_bancaires__c;
        

        // Decrypts IBAN in Harmonica Case (Origin : Tunnel en ligne)
        if(caseOrigin == 'Tunnel en ligne' && !String.isBlank(ibanCrypte) && String.isBlank(harmonicaBankDetailsId)) {
        try{
                harmonicaBankDetailsId = getHarmonicaBankDetailsId(idBP, ibanCrypte, ibanTitulaire);
            } catch(Exception ex) {
                harmonicaBankDetailsId = '';

            }
        }        
        harmonica.harmonicaBankDetailsId = harmonicaBankDetailsId;
               
        return harmonica;
    }
        
    public static String getHarmonicaBankDetailsId(String idBP, String ibanCrypte, String ibanTitulaire) {        
        String harmonicaBankDetailsId = '';
        // Decrypt the crypted IBAN
        String ibanDecrypted = '';
        if(!Test.isRunningTest()){
            ibanDecrypted = SM_AP91_decryptage.callapidecryptage(ibanCrypte);
        }        
        ibanDecrypted = ibanDecrypted.deleteWhitespace();       

        // Get Token
        String token;
        if(!Test.isRunningTest()){
            token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
        }
        
        // Search for bank details corresponding to the decrypted iban
        HttpResponse resp;
        Map < String, Object > resultAsMap;
        
        // Add '0' characters on business partner id (if there are missing characters)
        idBP = SM_AP24_CoordonneesBancaires.bpVerification(idBP);
        
        // Call
        String reqParams = '?idBusinessPartner=' +idBP;
        if(!Test.isRunningTest()){
            resp = SM_AP24_CoordonneesBancaires.getResponse(reqParams);
        }       
        
        if(resp != null && resp.getBody()!= null){
            resultAsMap = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
            List <Object> bankDetailsList = (List<Object>) resultAsMap.get('_data');


            if (bankDetailsList != null && !bankDetailsList.isEmpty()) {
                
                for(Object obj : bankDetailsList) { Map <String, Object> bankDetails = (Map <String, Object>) obj;
                    
                    // Compare harmonica decrypted IBAN with all IBAN from the service and get the banks details id in this case
                    if((String)bankDetails.get('iBAN') == ibanDecrypted) { harmonicaBankDetailsId = (String) bankDetails.get('id'); }
                }
            }
        }        
        
        // Create banks details if they are not found for this decrypted IBAN
        if(String.isEmpty(harmonicaBankDetailsId)) {
            
            Map < String, Object > inputMap = new Map < String, Object >();
            Map < String, Object > outMap = new Map < String, Object >();
            
            inputMap.put('idPersonneFormule', idBP);
            inputMap.put('IbanNumber', ibanDecrypted);
            inputMap.put('TitulaireCompteFormula', ibanTitulaire);
            inputMap.put('TitulaireCompte', ibanTitulaire);
            
            // Call
            if(!Test.isRunningTest()){
                SM_AP33_CoordonneesBancaires.creerCB(inputMap,outMap,null);
            }           
            
            // Get banks details created with the decrypted IBAN
            if(outMap.get('idCoordonneeBancaire') != null){
                harmonicaBankDetailsId = (String) outMap.get('idCoordonneeBancaire');
            }
        }        
        return harmonicaBankDetailsId;
    }
    
    @AuraEnabled
    public static boolean updateCaseStatus(String caseId){
        
        Case caseToUpdate = new Case();
        caseToUpdate.Status = 'En Traitement';
        caseToUpdate.HarmonicaDateTraitement__c = System.now();
        caseToUpdate.id = caseId;
        
        try{
            update caseToUpdate;
            return true;
        }catch(exception ex){
            return false;
        }
    }
}