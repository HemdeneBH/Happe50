/*
* @Author: Paul Ghoussoub
*@Description: Controlleur Apex du LWC parcoursPurePlayersContent
*@CreatedDate: 15/12/2020
*@LastModified: 29/12/2020
*/
public without sharing class VI_parcoursPurePlayersContent_Controller {
    @AuraEnabled(cacheable=true)
    public static VI_Parcours__c getParcours(String parcoursID) {
        system.debug('parcoursID'+ parcoursID);
        VI_parcours__c parcours = [SELECT Id,Name,CreatedDate,OwnerId, VI_NomClient__c, VI_CommentairesParcours__c,VI_ChoixEnergie__c,VI_ChoixParcours__c,VI_TypeRechercheLocal__c, 
                                   VI_CommentairesAnnulerParcours__c, VI_CommentairesReprendreParcours__c, VI_CommentairesTransfertAppel__c,
                                   VI_PlanifierTache__c, VI_DateEcheanceTache__c, VI_HeureEcheanceTache__c, VI_DescriptionTache__c, VI_Numero_de_la_rue__c,
                                   VI_Etape_Parcours__c,VI_Email1Client__c, VI_PrenomClient__c,VI_Email2Client__c,  VI_CommuneClient__c, VI_RueCreationClient__c,
                                   VI_CodePostalClient__c, VI_IDReferenceClient__c, VI_Contact__c, VI_TelephoneFixe1Client__c, VI_RefusMobile__c, VI_TelephoneFixe2Client__c,
                                   VI_TelephonePrincipalCreationClient__c,VI_RefusEmailCreationClient__c, VI_EmailPrincipalCreationClient__c, VI_RefusTelephoneCreationClient__c, 
                                   VI_Mobile1Client__c, VI_Mobile2Client__c, VI_MobilePrincipalCreationClient__c, VI_ConsentProspectionEngieNonAnalogue__c, VI_ConsentProspectionPartenaire__c,
                                   VI_PDLRechercheLocal__c, VI_PCERechercheLocal__c,VI_NumeroRueRechercheLocal__c, VI_RueRechercheLocal__c, VI_CodePostalRechercheLocal__c, 
                                   VI_CommuneRechercheLocal__c,VI_AccordClientRechercheLocal__c, VI_LocalNonIdentifieGenerationCase__c,VI_CommentaireGeneral_Constitutionpanier__c,
                                   VI_CommentaireGeneral_EstimationConso__c,VI_CommentaireGeneral_idlocal__c,VI_CommentaireGeneral_idbesoin__c,VI_CommentaireGeneral_idclient__c,
                                   VI_CommentaireGeneral_InfosCompl__c,VI_CommentaireGeneral_MoyensPaiement__c, VI_NomPredecesseurRechercheLocal__c, 
                                   VI_TypeLogementRechercheLocal__c,VI_NumeroEtageRechercheLocal__c, VI_NumeroAppartementRechercheLocal__c, VI_EstimationFtaCode__c,
                                   VI_IndexHPRechercheLocal__c, VI_IndexHCRechercheLocal__c, VI_IndexBaseRechercheLocal__c,VI_NumeroMatriculeRechercheLocal__c,
                                   VI_DroiteGaucheRechercheLocal__c,Tech_IdentificationClientInitiee__c, VI_CiviliteClient__c, VI_ChoixEstimation__c, VI_SaisieConsommationHeuresPleines__c, 
                                   VI_SaisieConsommationHeuresCreuses__c, VI_Secteur_Activit_Gaz__c,VI_Secteur_Activite_Elec__c,VI_ChoixOffreStructureMesureFournisseur__c,
                                   VI_PuissanceCompteurElecSaisieConso__c, VI_SaisieConsommationElec_HP_HC__c,VI_InfosCompl_DateContratEffectif__c,
                                   VI_InfosCompl_MiseEnServiceUrgente__c,VI_InfosCompl_PremiereMiseEnService__c,VI_InfosCompl_IndexElec__c,VI_InfosCompl_IndexGaz__c,
                                   VI_InfosCompl_HP_HC__c,VI_InfosCompl_HeuresPleinesElec__c,VI_InfosCompl_HeuresCreusesElec__c,VI_InfosCompl_ChoixReleveCompteur__c, 
                                   VI_ConsommationGazKwHSaisieConso__c, VI_TypeResidenceSaisieConso__c, VI_TypeLogementSaisieConso__c, VI_idCompteClient__c,
                                   VI_SurfaceLogementSaisieConso__c, VI_NombreOccupantLogementSaisieConso__c, VI_AnneeConstructionLogementSaisieConso__c, 
                                   VI_ServiceOptionVerteElecPrixAbHT__c,VI_GazPlageConso__c,VI_EstimationNiveauOuvertureServices__c,VI_DateLastModifFormTarifaireAcheminemt__c,VI_EstimationPuissance__c,
                                   VI_DispositifChauffageSaisieConso__c, VI_Code_pack__c,VI_ChoixOffrePourcentageOffreVerte__c,VI_Id_coordonnees_bancaires__c,
                                   VI_EnergieChauffageSaisieConso__c, VI_EnergieCuissonSaisieConso__c, VI_DispositifEauChaudeSaisieConso__c, VI_EnergieEauChaudeSaisieConso__c
                                   , VI_CongelateurElecSaisieConso__c, VI_SecheLingeElecSaisieConso__c, VI_LaveLingeElecSaisieConso__c, VI_LaveVaisselleElecSaisieConso__c,
                                   VI_BoutonCreerNouveauClientClique__c, VI_SaisieEstimationConsoElec_HP_HC__c , VI_ChoixOffreSurParcoursPanierClient__c, VI_AjustementMensualitesPanierClient__c, 
                                   VI_MontantdelaMensualitePanierClient__c,VI_MontantOffrePanierClient__c, VI_EleckWhHTPanierClient__c, VI_EleckWhTTCPanierClient__c, VI_GazkWhHTPanierClient__c, VI_GazkWhTTCPanierClient__c,
                                   VI_AbonnementAnnuelGazHTPanierClient__c, VI_AbonnementAnnuelGazTTCPanierClient__c, VI_AbonnementAnnuelElecHTPanierClient__c, VI_AbonnementAnnuelElecTTCPanierClient__c, 
                                   VI_CodePromotionnelPanierClient__c, VI_OffreChoisieElecPanierClient__c, VI_OffreChoisieGazPanierClient__c, VI_LibelleOffrePanierClient__c, VI_CodeOptionPanierClient__c,
                                   VI_LibelleOptionPanierClient__c, VI_MontantOptionPanierClient__c, VI_CodeCommuneIdentificationLocal__c, VI_Estimation_conso_elec_HP__c, VI_Estimation_conso_elec_HC__c, 
                                   VI_Estimation_conso_gaz__c, ScriptDescription__c,VI_Statut_reference_client__c,VI_ChoixMoyenPaiement__c,VI_FrequencePrelevementMoyendePaiement__c,VI_NomTitulaireMoyendePaiement__c, VI_IBANEnSelfCare__c,
                                   VI_IBANMoyendePaiement__c,/* Start DDPCM - 1110 VI_FactureEnLigneMoyendePaiement__c,VI_EdocMoyendePaiement__c, End DDPCM - 1110 */VI_Case__c,VI_CodeOptionGazPanierClient__c,VI_ServiceOptionVerteElecPrixAbTTC__c,VI_ServiceOptionVerteGazPrixAbHT__c,
                                   VI_LibelleOptionGazPanierClient__c, VI_EleckWhTTCHCPanierClient__c, VI_EleckWhHTHCPanierClient__c,VI_StatutParcours__c,VI_ServiceOptionVerteGazPrixAbTTC__c,VI_Email_CPV_IsFavori__c,VI_Email_CPV__c, VI_Espace_client__c,
                                   VI_EmailEnvoye__c, VI_idDocumentCPV__c, VI_idDocumentMandat__c,VI_NumeroMatriculeGAZRechercheLocal__c, VI_RechercheLocal_AdresseComplete__c, VI_AdresseDeConsoIdentique__c, VI_ParcoursDeSouscriptionAF__c,
                                   VI_CiviliteAF__c, VI_NomAF__c, VI_PrenomAF__c, VI_DateDeNaissanceAF__c, VI_CategorieSocioprofessionnelleAF__c, VI_ArretDeTravailPourRaisonDeSanteAF__c, VI_RenteInvaliditeAF__c, VI_ModeDePaiementAF__c, VI_AssuranceFactureCocheeAF__c,
                                   VI_MONTANT_ABO_ELEC_FOUR_TTC__c,VI_MONTANT_ABO_GAZ_FOUR_TTC__c,VI_MONTANT_ABO_ELEC_ACH_TTC__c,VI_MONTANT_ABO_GAZ_ACH_TTC__c,
                                   VI_PRIX_KWH_ELEC_FOUR_TTC__c,VI_PRIX_KWH_ELEC_ACH_TTC__c,VI_PRIX_KWH_ELEC_FOUR_HP_TTC__c,VI_PRIX_KWH_ELEC_FOUR_HC_TTC__c,
                                   VI_PRIX_KWH_ELEC_ACH_HP_TTC__c,VI_PRIX_KWH_ELEC_ACH_HC_TTC__c,VI_MONTANT_ABO_ELEC_FOUR_HT__c,VI_MONTANT_ABO_ELEC_ACH_HT__c,
                                   VI_PRIX_KWH_ELEC_FOUR_HT__c,VI_PRIX_KWH_ELEC_ACH_HT__c,VI_PRIX_KWH_ELEC_OBLI__c,VI_PRIX_KWH_ELEC_OBLI_HT__c,VI_PRIX_KWH_ELEC_FOUR_HP_HT__c,
                                   VI_PRIX_KWH_ELEC_FOUR_HC_HT__c,VI_PRIX_KWH_ELEC_ACH_HP_HT__c,VI_PRIX_KWH_ELEC_ACH_HC_HT__c,
                                   VI_MONTANT_ABO_GAZ_FOUR_HT__c,VI_MONTANT_ABO_GAZ_ACH_HT__c,VI_PRIX_KWH_GAZ_FOUR_TTC__c,VI_PRIX_KWH_GAZ_FOUR_HT__c,
                                   VI_PRIX_KWH_GAZ_ACH_TTC__c,VI_PRIX_KWH_GAZ_ACH_HT__c,VI_PRIX_KWH_GAZ_OBLI__c,VI_PRIX_KWH_GAZ_OBLI_HT__c,VI_PrixAssuranceFacture__c, VI_AF_Enregistre__c,VI_TechOffreReferenceChoisie__c,
                                   VI_TOTAL_MONTANT_ABO_GAZ_HT__c, VI_TOTAL_MONTANT_CONSO_GAZ_TTC__c , VI_TOTAL_MONTANT_CONSO_GAZ_HT__c, VI_TOTAL_MONTANT_ABO_ELEC_HT__c, VI_Abonement_elec_HT__c,VI_TOTAL_MONTANT_ABO_ELEC_TTC__c,
                                   VI_TOTAL_MONTANT_ABO_GAZ_TTC__c,VI_URL_IBAN_en_selfcare__c,/*Start DDPCM-940*/VI_MensualiteElecTTC__c, VI_MensualiteGazTTC__c,/*ENd DDPCM-940*/
                                   VI_TOTAL_MONTANT_CONSO_ELEC_HT__c, VI_TOTAL_MONTANT_CONSO_ELEC_TTC__c,VI_Code_FTA_Offre__c, VI_URL_IBAN_Mandat__c,VI_TECH_SitePrestatairePartenaire__c,VI_TECH_TypeDuSitePrestataire__c,VI_TECH_NomDuClient__c,VI_TECH_TelephonePrincipal__c,VI_StatutCasePartnerCommunity__c,
                                   VI_NomCompletClientCPV__c /* Start DDPCM-860 */,VI_SaisieEstimationConsoElec_GazPar__c/* Start DDPCM-860 *//* Start DDPCM-727 New Cannaux*/, VI_TypeParcours__c,/*, VI_RemplissageAutomatiqueAdresseLocal__c, VI_Mensualisation__c *//*END DDPCM-727 New Cannaux*/
                                   VI_PRIX_KWH_ELEC_ACH_HCbasse_HTT__c, VI_PRIX_KWH_ELEC_ACH_HPbasse_HTT__c, VI_PRIX_KWH_ELEC_ACH_HChaute_HTT__c, VI_PRIX_KWH_ELEC_ACH_HPhaute_HTT__c, VI_PRIX_KWH_ELEC_ACH_HCbasse_TTC__c, VI_PRIX_KWH_ELEC_ACH_HPbasse_TTC__c, VI_PRIX_KWH_ELEC_ACH_HChaute_TTC__c, 
                                   VI_PRIX_KWH_ELEC_ACH_HPhaute_TTC__c/* Start DDPCM-1004 */,VI_CompteurCommunicantLinkySaisieConso__c/* Start DDPCM-1004 *//* Start DDPCM - 671 */, VI_typeCompteurElec__c, VI_typeCompteurGaz__c/* End DDPCM - 671 *//* Start DDPCM 1183 */, VI_Date_Heure_envoi_email__c/* Start DDPCM - 1110 */, VI_FactureEnLigne__c, VI_EdocsMoyensPaiement__c, VI_ChoixMensualisation__c/* End DDPCM - 1110 *//* End DDPCM 1183 */        
                                   /* Start DDPCM-1192 */, VI_FinValidity__c, VI_DebutValidity__c, VI_CanalDeVente__c, VI_DescriptifPromotion__c, VI_NomPromotion__c, VI_LibelleSurFacture__c, VI_CodePromo__c, VI_NumPromotion__c, VI_FinValidity2__c, VI_DebutValidity2__c, VI_CanalDeVente2__c, VI_DescriptifPromotion2__c, VI_NomPromotion2__c, VI_LibelleSurFacture2__c, VI_CodePromo2__c, VI_NumPromotion2__c, VI_CodePromoApplied__c, VI_CodePromoApplied2__c/* End DDPCM-1192 */
                                   ,VI_VilleNaissanceAF__c,VI_PaysNaissanceAF__c,VI_CodePostalNaissanceAF__c
                                   FROM VI_Parcours__c
                                   WHERE id=:parcoursID limit 1]; 
        //mise à jour du statut du parcours si le parcours a été interrompu
        if(parcours.VI_StatutParcours__c == 'Vente à compléter'){
           parcours.VI_StatutParcours__c = 'Vente en cours'; 
        }
        
        return  parcours;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<VI_DonneesParcours__c> getParcoursDonnee() {
        system.debug('### START getParcoursDonnee'); 
        List<VI_DonneesParcours__c> donneesParcoursList = new List<VI_DonneesParcours__c>();
        
        donneesParcoursList = [SELECT Id,Name,VI_CHFScript1__c,VI_CHFScript2__c,VI_DonneesGDPR__c,
                               VI_EMScript1__c,VI_EMScript2__c,RecordTypeId,RecordType.name,
                               VI_Description_Option_Elec_v__c,Description_Option_Gaz_Vert__c,
                               Description_Option_Elec_Vert_2__c,
                               Description_Option_Gaz_Vert_2__c, VI_DescriptionAssuranceFacture1__c	, 
                               VI_DescriptionAssuranceFacture2__c, VI_CHF_DUAL_Script_1__c, VI_CHF_DUAL_Script_2__c,
                               VI_CHF_ELEC_Script_1__c, VI_CHF_ELEC_Script_2__c, VI_CHF_GAZ_Script_1__c, VI_CHF_GAZ_Script_2__c,
                               VI_EM_DUAL_Script_1__c, VI_EM_DUAL_Script_2__c, VI_EM_ELEC_Script_1__c, VI_EM_ELEC_Script_2__c,
                               VI_EM_Gaz_Script_1__c, VI_EM_GAZ_Script_2__c, VI_PrisenCompte_Choix_energie__c    
                               FROM VI_DonneesParcours__c];
        
        system.debug('### END getParcoursDonnee return : ' + donneesParcoursList); 
        return donneesParcoursList;
    }
    
    @AuraEnabled(cacheable=false)
    public static String createParcours(String test){
        /* Start DDPCM-727 New Cannaux*/
        User currentUser = [SELECT Id, AccountId,account.name, Account.VI_TypeParcours__c, Account.VI_Type_Enseigne__c, Account.VI_Groupe_Fonctionnel__c,Account.VI_Email_Partenaire__c
                                          FROM User
                                          WHERE Id =: system.UserInfo.getUserId()
                                          Limit 1];
        /* End DDPCM-727 New Cannaux*/
        
        Id caseRTId = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Acquisition_Harmonica').getRecordTypeId();
        case caseToCreate = new case(Status = 'Nouveau',
                                     Type = 'Acquisition',CPV_E_Canal_d_envoi__c='email',Origin = 'Partner Community',
                                     Priority = 'Medium',RecordTypeId=caseRTId,Vlocity_SendEmail__c = false);
        
        insert caseToCreate;
        system.debug('insert ddv');
        
        /* Start DDPCM-1303 */
        String dvCanal;
        if (currentUser.Account.VI_TypeParcours__c == 'DISTRIBUTION') {
            dvCanal = 'Distributeurs';
        }
        if (currentUser.Account.VI_TypeParcours__c == 'PURE PLAYERS') {
            dvCanal = 'Pure players';
        }
        if (currentUser.Account.VI_TypeParcours__c == 'VENTE DIRECTE') {
            dvCanal = 'Vente directe';
        }
        if (currentUser.Account.VI_TypeParcours__c == 'STORE') {
            dvCanal = 'Store/Corner';
        }
        Donnees_Vente__c donneesVenteToCreate = new Donnees_Vente__c( Canal__c = dvCanal, CaseId__c= caseToCreate.Id);
        //Donnees_Vente__c donneesVenteToCreate = new Donnees_Vente__c( Canal__c = 'Harmonica', CaseId__c= caseToCreate.Id);
        /* END DDPCM-1303 */
        donneesVenteToCreate.RecordTypeId =Donnees_Vente__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Acquisition_Harmonica').getRecordTypeId();
        insert donneesVenteToCreate;
        
		system.userinfo.getUserId();
        
        VI_Parcours__c parcoursToCreate=new VI_Parcours__c(VI_Case__c=caseToCreate.Id, VI_DonneesVente__c=donneesVenteToCreate.Id /* Start DDPCM-727 New Cannau*/, VI_TypeParcours__c=currentUser.Account.VI_TypeParcours__c /*END DDPCM-727 New Cannaux*/);
        insert parcoursToCreate; 
        system.debug('¤ parcour VI_TypeParcours__c : ' + parcoursToCreate.VI_TypeParcours__c);
        return parcoursToCreate.Id;
        
    }
    
    @AuraEnabled(cacheable=false)
    public static void updateParcours(String idParcours,String descriptionTache,String choixEnergie,
                                      String choixParcours,String choixTypeDeRechercheLocal,
                                      String etapeParcours)
    {
        VI_Parcours__c parcoursToUpdate=new VI_Parcours__c();
        if(idParcours !=null){
            parcoursToUpdate.id=idParcours; 
            if(descriptionTache!=null) parcoursToUpdate.VI_DescriptionTache__c=DescriptionTache;
            if(choixEnergie!=null) parcoursToUpdate.VI_ChoixEnergie__c=choixEnergie;
            if(choixParcours!=null) parcoursToUpdate.VI_ChoixParcours__c=choixParcours;
            if(choixTypeDeRechercheLocal!=null) parcoursToUpdate.VI_TypeRechercheLocal__c=choixTypeDeRechercheLocal;
            if(etapeParcours!=null) parcoursToUpdate.VI_Etape_Parcours__c=etapeParcours;
            
            update parcoursToUpdate;
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static String updateParcoursWrapper(VI_Parcours__c parcours, Boolean emailChangedOnly, Boolean gestionChangedOnly){
        system.debug('emailChangedOnly:'+ emailChangedOnly);
        system.debug('gestionChangedOnly:'+ gestionChangedOnly);
        system.debug('parcours.VI_idDocumentCPV__c:'+ parcours.VI_idDocumentCPV__c);
        try{ 
            if((parcours.VI_StatutParcours__c.equals('CPV Envoyées: PDL/PCE connu') || parcours.VI_StatutParcours__c.equals('CPV Envoyées: PDL/PCE non connu') && emailChangedOnly == false ))
               {
                   return 'Merci de ne pas modifier ce parcours';
               }
               else if((parcours.VI_idDocumentCPV__c != null && parcours.VI_idDocumentCPV__c.length() > 0)/* && gestionChangedOnly == false*/){
                   return 'Merci de ne pas modifier ce parcours';
               }
               else
               {
                   update parcours;
                   return 'Success';
               }
               /*update parcours;
				return 'Success';*/
        }
        catch(DmlException ex) {
            String message = ex.getDmlType(0) + ': ' + ex.getDmlMessage(0);
            System.debug(LoggingLevel.ERROR, 'An exception occured : ' + message);
            //throw new AuraHandledException(message);
            //DDPCM-952
            return 'Error';
        }
    }
}