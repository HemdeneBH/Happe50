/*
*@Author: Paul Ghousoub
*@Description: Mapping des champs du parcours dans données de vente et dans le case
*@CreatedDate: 2/12/2021
*@LastModified:  29/12/2021
*/

public inherited sharing class VI_ParcoursAfterUpdateHandler {
    /**
* @author Paul Ghousoub
* @date 2/12/2021
* @description Mapping des champs du parcours dans les objets données de ventes et case
* @param parcourList, oldParcourMap
* @return void ( called from a trigger)
*/
    public static void ParcoursAfterUpdate(List<VI_Parcours__c> parcourList, Map<ID,VI_Parcours__c> oldParcourMap)
    {
        System.debug('updateParcours: START with ' + parcourList.size() + ' parcour records');  
        List<Case> relatedCaseToUpdate = new List<Case>();
        List<Donnees_Vente__c> relatedDonneesVenteToUpdate = new List<Donnees_Vente__c>();
        String sous_type;
        Integer indexBase, indexHP, indexHC, nBOccupants;
        Map<Id,Contact> mapContact;
        Map<Id,User> mapOwner;
        Set<id> setContactIds=new Set<Id>();
        Set<id> setParcoursOwnersId=new Set<Id>();
        List<CaseComment> CaseCommentListInsert = new List<CaseComment>();
        List<Id> caseCommentListId = new List<Id>();
        
        for (VI_Parcours__c parIter : parcourList){
            if( oldParcourMap.containskey(parIter.Id)	
               && parIter.VI_StatutParcours__c != oldParcourMap.get(parIter.Id).VI_StatutParcours__c
               && (parIter.VI_StatutParcours__c == 'CPV Envoyées: PDL/PCE connu' || parIter.VI_StatutParcours__c == 'CPV Envoyées: PDL/PCE non connu') ){
                   caseCommentListId.add(parIter.VI_Case__c);
               }
            setParcoursOwnersId.add(parIter.OwnerId); 
            if(parIter.VI_Contact__c != null){
                setContactIds.add(parIter.VI_Contact__c);
            }
        }
        
        
        if(setContactIds!=null && setContactIds.size()>0){
            mapContact=new Map<Id,Contact>([Select id,Email,Adresse_Mail_2__c,Adresse_Mail_3__c,Phone,Tel_Fixe_2__c,Tel_Fixe_3__c,Tel_Fixe_Principal__c,
                                            Mobile_Principal__c,MobilePhone,Mobile_2__c,Mobile_3__c,accountId,account.VI_Groupe_Fonctionnel__c,account.VI_TypeParcours__c,
                                            Identifiant_Buisness_Partener__c,MailingStreet from contact where id in :setContactIds]);
        }
        if(setParcoursOwnersId!=null && setParcoursOwnersId.size()>0){
            mapOwner = new Map<Id, User>([SELECT Id, AccountId,account.name, Account.VI_Type_Enseigne__c, Account.VI_TypeParcours__c, Account.VI_Groupe_Fonctionnel__c,Account.VI_Email_Partenaire__c
                                          FROM User  
                                          WHERE Id =: setParcoursOwnersId]);
        }
        
        Map<Id, Case> casesToUpdate = new Map<Id, Case>();
        // Parsing Parcours list again to execute init logic
        for (VI_Parcours__c parIter : parcourList) {
            // Loop through each Related Case record
            sous_type = (parIter.VI_ChoixParcours__c =='CHF'?'Changement de fournisseur':(parIter.VI_ChoixParcours__c =='EM'?'Emménagement': ''));
            indexBase = (parIter.VI_InfosCompl_IndexElec__c  != Null?Integer.valueOf(parIter.VI_InfosCompl_IndexElec__c ):null);
            indexHC = (parIter.VI_InfosCompl_HeuresCreusesElec__c != Null? Integer.valueOf(parIter.VI_InfosCompl_HeuresCreusesElec__c):null);
            indexHP = (parIter.VI_InfosCompl_HeuresPleinesElec__c != Null?Integer.valueOf(parIter.VI_InfosCompl_HeuresPleinesElec__c):null);
            nBOccupants = (parIter.VI_NombreOccupantLogementSaisieConso__c != Null?Integer.valueOf(parIter.VI_NombreOccupantLogementSaisieConso__c):null);
            
            String phoneToFill=getPhoneToFill(mapContact, parIter.VI_Contact__c);
            
            Id caseAcquisitionHarmonicaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                .get('Acquisition_Harmonica').getRecordTypeId();
            
            String premierRaccordement=(parIter.VI_InfosCompl_PremiereMiseEnService__c?'oui':'non');
            
            Boolean prelevementAuto=parIter.VI_ChoixMoyenPaiement__c=='Prélèvement automatique'?true:false;
            
            if(!String.isBlank(parIter.VI_Case__c)){
                String queueAcorus = '';
                if(mapOwner.containsKey(parIter.OwnerId) && mapOwner.get(parIter.OwnerId).account != null){
                    queueAcorus='Partner Community - '+mapOwner.get(parIter.OwnerId).account.name+' - '+parIter.VI_ChoixParcours__c;
                }
                if(oldParcourMap.get(parIter.Id) == null){
                    casesToUpdate.put(parIter.VI_Case__c, new Case(Id=parIter.VI_Case__c,
                                                                   Sous_type__c = sous_type,
                                                                   Subject = sous_type,
                                                                   MES_urgente__c=parIter.VI_InfosCompl_MiseEnServiceUrgente__c,
                                                                   ContactId = parIter.VI_Contact__c,
                                                                   Consent_prospection_engie_non_analogue__c = (parIter.VI_ConsentProspectionEngieNonAnalogue__c == 'Oui' ? true : false),
                                                                   Consent_prospection_partenaire__c = (parIter.VI_ConsentProspectionPartenaire__c == 'Oui' ? true : false),
                                                                   QueueAcorus__c=queueAcorus,
                                                                   MENS__c=(parIter.VI_FrequencePrelevementMoyendePaiement__c == 'Mensuel'?True: false)
                                                                  ));
                }
                else{
                    if(parIter.VI_ChoixParcours__c != null &&  oldParcourMap.get(parIter.Id).VI_ChoixParcours__c != parIter.VI_ChoixParcours__c){  
                        casesToUpdate.put(parIter.VI_Case__c, new Case(Id = parIter.VI_Case__c, Sous_type__c = sous_type, Subject = sous_type, QueueAcorus__c=queueAcorus ));
                    }
                    if(parIter.VI_Contact__c != null && oldParcourMap.get(parIter.Id).VI_Contact__c != parIter.VI_Contact__c){
                        if(casesToUpdate.containsKey(parIter.VI_Case__c)){
                            Case caseToUpdate = casesToUpdate.get(parIter.VI_Case__c);
                            caseToUpdate.ContactId = parIter.VI_Contact__c;
                            casesToUpdate.put(parIter.VI_Case__c, caseToUpdate);
                        }
                        else{
                            casesToUpdate.put(parIter.VI_Case__c, new Case(Id = parIter.VI_Case__c, ContactId = parIter.VI_Contact__c));
                        }
                    }
                    if(oldParcourMap.get(parIter.Id).VI_ConsentProspectionEngieNonAnalogue__c != parIter.VI_ConsentProspectionEngieNonAnalogue__c){
                        if(casesToUpdate.containsKey(parIter.VI_Case__c)){
                            Case caseToUpdate = casesToUpdate.get(parIter.VI_Case__c);
                            caseToUpdate.Consent_prospection_engie_non_analogue__c = (parIter.VI_ConsentProspectionEngieNonAnalogue__c == 'Oui' ? true : false);
                            casesToUpdate.put(parIter.VI_Case__c, caseToUpdate);
                        }
                        else{
                            casesToUpdate.put(parIter.VI_Case__c, new Case(Id = parIter.VI_Case__c,
                                                                           Consent_prospection_engie_non_analogue__c = (parIter.VI_ConsentProspectionEngieNonAnalogue__c == 'Oui' ? true : false)));
                        }
                    }
                    
                    if(oldParcourMap.get(parIter.Id).VI_ConsentProspectionPartenaire__c != parIter.VI_ConsentProspectionPartenaire__c){
                        if(casesToUpdate.containsKey(parIter.VI_Case__c)){
                            Case caseToUpdate = casesToUpdate.get(parIter.VI_Case__c);
                            caseToUpdate.Consent_prospection_partenaire__c = (parIter.VI_ConsentProspectionPartenaire__c == 'Oui' ? true : false);
                            casesToUpdate.put(parIter.VI_Case__c, caseToUpdate);
                        }
                        else{
                            casesToUpdate.put(parIter.VI_Case__c, new Case(Id = parIter.VI_Case__c, 
                                                                           Consent_prospection_partenaire__c = (parIter.VI_ConsentProspectionPartenaire__c == 'Oui' ? true : false)));
                        }
                    }
                    
                    if(oldParcourMap.get(parIter.Id).VI_InfosCompl_MiseEnServiceUrgente__c != parIter.VI_InfosCompl_MiseEnServiceUrgente__c){
                        if(casesToUpdate.containsKey(parIter.VI_Case__c)){
                            Case caseToUpdate = casesToUpdate.get(parIter.VI_Case__c);
                            caseToUpdate.MES_urgente__c = parIter.VI_InfosCompl_MiseEnServiceUrgente__c;
                            casesToUpdate.put(parIter.VI_Case__c, caseToUpdate);
                        }
                        else{
                            casesToUpdate.put(parIter.VI_Case__c, new Case(Id = parIter.VI_Case__c, 
                                                                           MES_urgente__c = parIter.VI_InfosCompl_MiseEnServiceUrgente__c));
                        }
                    }
                    
                    if(oldParcourMap.get(parIter.Id).VI_Date_envoi_email__c != parIter.VI_Date_envoi_email__c){
                        if(casesToUpdate.containsKey(parIter.VI_Case__c)){
                            Case caseToUpdate = casesToUpdate.get(parIter.VI_Case__c);
                            if(parIter.VI_ChoixParcours__c == 'EM' ){
                                caseToUpdate.CPV_E_Date_de_signature__c = parIter.VI_Date_envoi_email__c;
                                caseToUpdate.CPV_E_Signee__c = 'Oui';
                                caseToUpdate.AutorisationClient__c = true;
                            }
                            caseToUpdate.CPV_E_Envoyee__c = 'Oui';
                            casesToUpdate.put(parIter.VI_Case__c, caseToUpdate);
                        }
                        else{
                            if(parIter.VI_ChoixParcours__c == 'EM' ){
                                casesToUpdate.put(parIter.VI_Case__c, new Case(Id = parIter.VI_Case__c, 
                                                                               CPV_E_Date_de_signature__c = parIter.VI_Date_envoi_email__c,
                                                                               CPV_E_Signee__c = 'Oui', CPV_E_Envoyee__c = 'Oui', AutorisationClient__c = true));
                            }
                            else{
                                casesToUpdate.put(parIter.VI_Case__c, new Case(Id = parIter.VI_Case__c, 
                                                                               CPV_E_Envoyee__c = 'Oui'));
                            }
                        }
                    }
                    // Start DDPCM-424
                    if (parIter.VI_idDocumentCPV__c != null && oldParcourMap.get(parIter.Id).VI_idDocumentCPV__c != parIter.VI_idDocumentCPV__c) {
                        if(casesToUpdate.containsKey(parIter.VI_Case__c)){
                            Case caseToUpdate = casesToUpdate.get(parIter.VI_Case__c);
                            caseToUpdate.VI_IdCPV__c	= parIter.VI_idDocumentCPV__c;
                            casesToUpdate.put(parIter.VI_Case__c, caseToUpdate);
                        }
                        else{
                            casesToUpdate.put(parIter.VI_Case__c, new Case(Id = parIter.VI_Case__c,
                                                                           VI_IdCPV__c	= parIter.VI_idDocumentCPV__c));
                        }
                    }
                    // End DDPCM-424
                    if (oldParcourMap.get(parIter.Id).VI_AF_Enregistre__c != parIter.VI_AF_Enregistre__c) {
                        if(casesToUpdate.containsKey(parIter.VI_Case__c)){
                            Case caseToUpdate = casesToUpdate.get(parIter.VI_Case__c);
                            caseToUpdate.Assurance_Facture__c	= parIter.VI_AF_Enregistre__c;
                            casesToUpdate.put(parIter.VI_Case__c, caseToUpdate);
                        }
                        else
                        {
                            casesToUpdate.put(parIter.VI_Case__c, new Case(Id = parIter.VI_Case__c,
                                                                           Assurance_Facture__c = parIter.VI_AF_Enregistre__c));
                        }
                    }
                    
                    // Start DDPCM - 1183
                    if (oldParcourMap.get(parIter.Id).VI_Date_Heure_envoi_email__c != parIter.VI_Date_Heure_envoi_email__c) {
                        if(casesToUpdate.containsKey(parIter.VI_Case__c)){
                            Case caseToUpdate = casesToUpdate.get(parIter.VI_Case__c);
                            caseToUpdate.Date_Heure_Creation_Formulaire__c	= parIter.VI_Date_Heure_envoi_email__c;
                            casesToUpdate.put(parIter.VI_Case__c, caseToUpdate);
                        }
                        else
                        {
                            casesToUpdate.put(parIter.VI_Case__c, new Case(Id = parIter.VI_Case__c,
                                                                           Date_Heure_Creation_Formulaire__c = parIter.VI_Date_Heure_envoi_email__c));
                        }
                    }
                    // End DDPCM - 1183
                }
                
            }
            
            //handle abonnement 
            Decimal abonnenementAnnuelElec=(parIter.VI_AbonnementAnnuelElecTTCPanierClient__c == null ? 0 : parIter.VI_AbonnementAnnuelElecTTCPanierClient__c);
            Decimal abonnenementAnnuelGaz=(parIter.VI_AbonnementAnnuelGazTTCPanierClient__c == null ? 0 : parIter.VI_AbonnementAnnuelGazTTCPanierClient__c);
            //handle prix KWH
            Decimal elecKWHTTCHP=(parIter.VI_EleckWhTTCPanierClient__c == null ? null : parIter.VI_EleckWhTTCPanierClient__c);
            Decimal elecKWHTTCHC=(parIter.VI_EleckWhTTCHCPanierClient__c == null ? null : parIter.VI_EleckWhTTCHCPanierClient__c);
            Decimal gazKWHTTC=(parIter.VI_GazkWhTTCPanierClient__c == null ? null : parIter.VI_GazkWhTTCPanierClient__c);
            
            //handle estimation
            Decimal estimationConsoElecHC, estimationConsoElecHP, estimationConsoGaz,estimationConsoElecST;
            estimationConsoElecHC = 0;
            estimationConsoElecST = 0;
            estimationConsoElecHP = 0; 
            estimationConsoGaz = 0;
            if(parIter.VI_ChoixEstimation__c == 'Saisir la consommation d\'énergie'){
                estimationConsoElecST = (parIter.VI_SaisieConsommationElec_HP_HC__c == true? null:parIter.VI_SaisieConsommationHeuresPleines__c);
                estimationConsoElecHC=(parIter.VI_SaisieConsommationElec_HP_HC__c == true ? parIter.VI_SaisieConsommationHeuresCreuses__c : null);
                estimationConsoElecHP=(parIter.VI_SaisieConsommationElec_HP_HC__c == true? parIter.VI_SaisieConsommationHeuresPleines__c : null);
                estimationConsoGaz=(parIter.VI_ConsommationGazKwHSaisieConso__c == null ? null : parIter.VI_ConsommationGazKwHSaisieConso__c);
            }
            else if(parIter.VI_ChoixEstimation__c == 'Estimer la consommation d\'énergie'){
                estimationConsoElecST = (parIter.VI_SaisieEstimationConsoElec_HP_HC__c == 'Oui'? null:parIter.VI_Estimation_conso_elec_HP__c);
                estimationConsoElecHC=(parIter.VI_SaisieEstimationConsoElec_HP_HC__c == 'Oui' ? parIter.VI_Estimation_conso_elec_HC__c : null);
                estimationConsoElecHP=(parIter.VI_SaisieEstimationConsoElec_HP_HC__c == 'Oui' ? parIter.VI_Estimation_conso_elec_HP__c: null );
                estimationConsoGaz=(parIter.VI_Estimation_conso_gaz__c == null ? null : parIter.VI_Estimation_conso_gaz__c);
            }
            
            if (!String.isBlank(parIter.VI_DonneesVente__c)) {
                Donnees_Vente__c dv = new Donnees_Vente__c(Id=parIter.VI_DonneesVente__c,
                                                           CaseId__c = parIter.VI_Case__c,
                                                           AccountId__c = parIter.VI_CompteClient__c,
                                                           
                                                           
                                                           //ADDED 31-5-2021
                                                           Parcours__c=parIter.id,
                                                           //END 31-5-2021
                                                           
                                                           
                                                           //reference_client__c = parIter.VI_ReferenceClientRechercheClient__c,
                                                           //Statut_reference_client__c = To_be_filled, //Champ à créer dans Parcours
                                                           Nom_client__c = parIter.VI_NomClientExistant__c,
                                                           Prenom_client__c = parIter.VI_PrenomClientExistant__c,
                                                           Civilite_client__c = parIter.VI_CiviliteClientExistant__c,
                                                           Consent_prospection_partenaire__c = (parIter.VI_ConsentProspectionPartenaire__c == 'Oui' ? true : false),
                                                           Abonement_elec_HT__c = parIter.VI_AbonnementAnnuelElecHTPanierClient__c,
                                                           Abonement_elec_TTC__c = parIter.VI_AbonnementAnnuelElecTTCPanierClient__c,
                                                           Abonement_gaz_HT__c = parIter.VI_AbonnementAnnuelGazHTPanierClient__c,
                                                           Abonement_gaz_TTC__c = parIter.VI_AbonnementAnnuelGazTTCPanierClient__c,
                                                           //DDPCM-933 START 
                                                           Ajustement_mensualite__c = parIter.VI_AjustementMensualitesPanierClient__c+'%',
                                                           //DDPCM-933 END 
                                                           Ancien_occupant__c = parIter.VI_NomPredecesseurRechercheLocal__c,
                                                           Annee_construction_futur_logement__c = parIter.VI_AnneeConstructionLogementSaisieConso__c,
                                                           Code_enseigne_remise_web__c=parIter.VI_CodePromotionnelPanierClient__c,
                                                           Code_offre_elec__c = parIter.VI_OffreChoisieElecPanierClient__c,
                                                           Code_offre_gaz__c = parIter.VI_OffreChoisieGazPanierClient__c, 
                                                           Code_pack__c = parIter.VI_Code_pack__c, 
                                                           Code_postale__c = parIter.VI_CodePostalRechercheLocal__c,
                                                           //Code_promotion__c = parIter.VI_CodePromotionnelPanierClient__c, 
                                                           Commune__c = parIter.VI_CommuneRechercheLocal__c,
                                                           //Compte_client__c = A CREER? Selon nouveaux scénarios gestion EM et mandat Sepa etc
                                                           Consent_prospection_engie_non_analogue__c = (parIter.VI_ConsentProspectionEngieNonAnalogue__c == 'Oui' ? true : false),
                                                           Consomation_elec_HC_HT__c = (parIter.VI_EleckWhHTHCPanierClient__c == null ? null : parIter.VI_EleckWhHTHCPanierClient__c),
                                                           Consomation_elec_HC_TTC__c = elecKWHTTCHC,
                                                           Consomation_elec_HP_HT__c = (parIter.VI_EleckWhHTHCPanierClient__c == null ? null : parIter.VI_EleckWhHTPanierClient__c),
                                                           Consomation_elec_HP_TTC__c = (parIter.VI_EleckWhHTHCPanierClient__c == null ? null : parIter.VI_EleckWhTTCPanierClient__c),
                                                           Consomation_elec_simple_HT__c = (parIter.VI_EleckWhHTHCPanierClient__c == null ?parIter.VI_EleckWhHTPanierClient__c : null),
                                                           Consomation_elec_simple_TTC__c = (parIter.VI_EleckWhHTHCPanierClient__c == null ?parIter.VI_EleckWhTTCPanierClient__c : null),
                                                           Consomation_gaz_HT__c = parIter.VI_GazkWhHTPanierClient__c,
                                                           Consomation_gaz_TTC__c = parIter.VI_GazkWhTTCPanierClient__c,
                                                           Date_mise_en_service__c = parIter.VI_InfosCompl_DateContratEffectif__c,
                                                           //Deja_client_engie__c /// à ajouter 
                                                           Dispositif_chauffage__c = parIter.VI_DispositifChauffageSaisieConso__c,
                                                           //Type_chauffage__c ///à Ajouter
                                                           Dispositif_production_eau_chaude__c = parIter.VI_DispositifEauChaudeSaisieConso__c,
                                                           E_documents__c = (parIter.VI_EdocsMoyensPaiement__c == 'Oui' ? true: false),
                                                           E_service_prelevement_auto__c = prelevementAuto,
                                                           E_services_FEL__c = (parIter.VI_FactureEnLigne__c == 'Oui' ? true: false),
                                                           Email_client__c = parIter.VI_Email_CPV__c,
                                                           //email_partenaire__c=UserInfo.getUserEmail(),
                                                           email_partenaire__c=(mapOwner.containsKey(parIter.OwnerId) && mapOwner.get(parIter.OwnerId).account != null? mapOwner.get(parIter.OwnerId).account.VI_Email_Partenaire__c: null),
                                                           Energie_production_eau_chaude__c = getEnergieValue(parIter.VI_EnergieEauChaudeSaisieConso__c, 'eauChaude'),
                                                           Espace_client__c=parIter.VI_Espace_client__c,
                                                           Estimation_conso_elec_HP__c = estimationConsoElecHP,
                                                           Estimation_conso_elec_HC__c = estimationConsoElecHC,
                                                           Estimation_conso_elec_st__c = estimationConsoElecST,
                                                           Estimation_conso_gaz__c = estimationConsoGaz,
                                                           Etage__c = parIter.VI_NumeroEtageRechercheLocal__c,
                                                           // DDPCM 1418
                                                           HA_Enseigne__c = (mapOwner.containsKey(parIter.OwnerId) && mapOwner.get(parIter.OwnerId).account != null? mapOwner.get(parIter.OwnerId).account.VI_Groupe_Fonctionnel__c: null),
                                                           IBAN__c = parIter.VI_IBANMoyendePaiement__c,
                                                           ID_coordonnees_bancaires__c=(parIter.VI_ChoixMoyenPaiement__c == 'Prélèvement automatique'? parIter.VI_ID_coordonnees_bancaires__c: ''),
                                                           gaz_vert_plus__c = (parIter.VI_CodeOptionGazPanierClient__c!= null?'true':'false' ),
                                                           elec_vert_plus__c = (parIter.VI_CodeOptionPanierClient__c!= null? 'true':'false' ),
                                                           Index_elec_HC__c = indexHC,
                                                           Index_elec_HP__c = indexHP,
                                                           Index_elec_HP_simple__c = indexBase,
                                                           Index_gaz__c = parIter.VI_InfosCompl_IndexGaz__c,
                                                           Libelle_voie__c = parIter.VI_RueRechercheLocal__c,
                                                           Mensualisation__c =(parIter.VI_FrequencePrelevementMoyendePaiement__c == 'Mensuel'?True: false),
                                                           mensualite_elec_TTC__c = (parIter.VI_MensualiteElecTTC__c != null?parIter.VI_MensualiteElecTTC__c : 0),
                                                           mensualite_gaz_TTC__c = (parIter.VI_MensualiteGazTTC__c != null? parIter.VI_MensualiteGazTTC__c : 0),
                                                           mensualite_totale_TTC__c = parIter.VI_MontantOffrePanierClient__c,
                                                           Mensualite_initiale__c = parIter.VI_MontantOffrePanierClient__c,
                                                           Montant_mensualites__c = parIter.VI_MontantdelaMensualitePanierClient__c,
                                                           IBAN_Titulaire__c = parIter.VI_NomTitulaireMoyendePaiement__c,
                                                           NB_occupants__c = nBOccupants,
                                                           Numero_appartement__c = parIter.VI_NumeroAppartementRechercheLocal__c,
                                                           Numero_de_voie__c= parIter.VI_NumeroRueRechercheLocal__c,
                                                           //DDPCM-934 START
                                                           //offre_energie__c=(parIter.VI_CodeOptionPanierClient__c!= null?parIter.VI_CodeOptionPanierClient__c:'')+(parIter.VI_CodeOptionGazPanierClient__c!= null?parIter.VI_CodeOptionGazPanierClient__c:'')+(parIter.VI_Code_pack__c!= null?parIter.VI_Code_pack__c:''),
                                                           offre_energie__c=parIter.VI_LibelleOffrePanierClient__c!= null?parIter.VI_LibelleOffrePanierClient__c:'',
                                                           //DDPCM-934 END
                                                           //Numero_de_voie__c = parIter.VI_Numero_de_la_rue__c or parIter.VI_NumeroRueRechercheLocal__c, => logic to determine
                                                           Parcours_Client__c = sous_type,
                                                           Point_comptage_estimation__c = parIter.VI_PCERechercheLocal__c, // No field mentioned in mapping file, to confirm
                                                           Point_de_livraison__c = parIter.VI_PDLRechercheLocal__c,
                                                           Premier_raccordement__c = premierRaccordement,
                                                           Puissance__c = parIter.VI_PuissanceCompteurElecSaisieConso__c,
                                                           reference_client__c =(parIter.VI_Contact__c != null && mapContact.containsKey(parIter.VI_Contact__c)?mapContact.get(parIter.VI_Contact__c).Identifiant_Buisness_Partener__c:null), 
                                                           //Statut_compte_client__c = A CREER post arbitrage ? Si création compte client
                                                           Statut_mandat__c = (parIter.VI_ID_Mandat__c!=null ?'à signer':''),
                                                           Statut_reference_client__c = parIter.VI_Statut_reference_client__c,
                                                           Surface_logement__c = parIter.VI_SurfaceLogementSaisieConso__c,
                                                           Telephone_client__c=phoneToFill,
                                                           Theme_demande__c='Partenaire',
                                                           //Correction Anomalie DDPCM-890
                                                           Type_habitation__c = (parIter.VI_TypeLogementSaisieConso__c== 'Individuel'? 'Individuelle':(parIter.VI_TypeLogementSaisieConso__c== 'Collectif'?'Collective':(parIter.VI_TypeLogementSaisieConso__c== 'Je ne sais pas'?'Autre':''))),
                                                           Type_de_Comptage__c = (parIter.VI_SaisieConsommationElec_HP_HC__c == true || parIter.VI_SaisieEstimationConsoElec_HP_HC__c == 'Oui'?'double':'simple'),
                                                           Type_chauffage__c= getEnergieValue(parIter.VI_EnergieChauffageSaisieConso__c, 'chauffage'),
                                                           
                                                           
                                                           
                                                           
                                                           
                                                           HA_Type_Enseigne__c = (mapOwner.containsKey(parIter.OwnerId) && mapOwner.get(parIter.OwnerId).account != null? mapOwner.get(parIter.OwnerId).account.VI_Type_Enseigne__c: null),
                                                           
                                                           
                                                           
                                                           
                                                           Type_logement__c = parIter.VI_TypeLogementRechercheLocal__c,
                                                           Type_residence_logement__c = parIter.VI_TypeResidenceSaisieConso__c,
                                                           //MES_urgente__c=parIter.VI_InfosCompl_MiseEnServiceUrgente__c,
                                                           Maj_email__c=parIter.VI_Email_CPV_IsFavori__c,
                                                           Compte_client__c=parIter.VI_idCompteClient__C,
                                                           Statut_compte_client__c=(parIter.VI_idCompteClient__C != null?'Créé automatiquement':null),
                                                           //DDPCM - 416
                                                           TOTAL_MONTANT_ABO_ELEC_HT__c = parIter.VI_TOTAL_MONTANT_ABO_ELEC_HT__c,
                                                           TOTAL_MONTANT_ABO_ELEC__c = parIter.VI_TOTAL_MONTANT_ABO_ELEC_TTC__c,
                                                           MONTANT_ABO_ELEC_ACH_HT__c = parIter.VI_MONTANT_ABO_ELEC_ACH_HT__c,
                                                           MONTANT_ABO_ELEC_ACH__c = parIter.VI_MONTANT_ABO_ELEC_ACH_TTC__c,
                                                           MONTANT_ABO_ELEC_FOUR_HT__c = parIter.VI_MONTANT_ABO_ELEC_FOUR_HT__c,
                                                           MONTANT_ABO_ELEC_FOUR__c = parIter.VI_MONTANT_ABO_ELEC_FOUR_TTC__c,
                                                           TOTAL_MONTANT_CONSO_ELEC_HT__c = parIter.VI_TOTAL_MONTANT_CONSO_ELEC_HT__c,
                                                           TOTAL_MONTANT_CONSO_ELEC__c = parIter.VI_TOTAL_MONTANT_CONSO_ELEC_TTC__c,
                                                           PRIX_KWH_ELEC_ACH_HT__c = parIter.VI_PRIX_KWH_ELEC_ACH_HT__c,
                                                           PRIX_KWH_ELEC_ACH__c = parIter.VI_PRIX_KWH_ELEC_ACH_TTC__c,
                                                           PRIX_KWH_ELEC_ACH_HP_HT__c = parIter.VI_PRIX_KWH_ELEC_ACH_HP_HT__c,
                                                           PRIX_KWH_ELEC_ACH_HP__c = parIter.VI_PRIX_KWH_ELEC_ACH_HP_TTC__c,
                                                           PRIX_KWH_ELEC_ACH_HC_HT__c = parIter.VI_PRIX_KWH_ELEC_ACH_HC_HT__c,
                                                           PRIX_KWH_ELEC_ACH_HC__c = parIter.VI_PRIX_KWH_ELEC_ACH_HC_TTC__c,
                                                           PRIX_KWH_ELEC_FOUR_HT__c = parIter.VI_PRIX_KWH_ELEC_FOUR_HT__c,
                                                           PRIX_KWH_ELEC_FOUR__c = parIter.VI_PRIX_KWH_ELEC_FOUR_TTC__c,
                                                           PRIX_KWH_ELEC_FOUR_HP_HT__c = parIter.VI_PRIX_KWH_ELEC_FOUR_HP_HT__c,
                                                           PRIX_KWH_ELEC_FOUR_HP__c = parIter.VI_PRIX_KWH_ELEC_FOUR_HP_TTC__c,
                                                           PRIX_KWH_ELEC_FOUR_HC_HT__c = parIter.VI_PRIX_KWH_ELEC_FOUR_HC_HT__c,
                                                           PRIX_KWH_ELEC_FOUR_HC__c = parIter.VI_PRIX_KWH_ELEC_FOUR_HC_TTC__c,
                                                           PRIX_KWH_ELEC_OBLI_HT__c = parIter.VI_PRIX_KWH_ELEC_OBLI_HT__c,
                                                           PRIX_KWH_ELEC_OBLI__c = parIter.VI_PRIX_KWH_ELEC_OBLI__c,
                                                           //DDPCM 993 START
                                                           PRIX_KWH_ELEC_ACH_HCB_HT__c = parIter.VI_PRIX_KWH_ELEC_ACH_HCbasse_HTT__c,
                                                           PRIX_KWH_ELEC_ACH_HCB__c = parIter.VI_PRIX_KWH_ELEC_ACH_HCbasse_TTC__c,
                                                           PRIX_KWH_ELEC_ACH_HPB_HT__c = parIter.VI_PRIX_KWH_ELEC_ACH_HPbasse_HTT__c,
                                                           PRIX_KWH_ELEC_ACH_HPB__c = parIter.VI_PRIX_KWH_ELEC_ACH_HPbasse_TTC__c,
                                                           PRIX_KWH_ELEC_ACH_HCH_HT__c = parIter.VI_PRIX_KWH_ELEC_ACH_HChaute_HTT__c,
                                                           PRIX_KWH_ELEC_ACH_HCH__c = parIter.VI_PRIX_KWH_ELEC_ACH_HChaute_TTC__c,
                                                           PRIX_KWH_ELEC_ACH_HPH_HT__c = parIter.VI_PRIX_KWH_ELEC_ACH_HPhaute_HTT__c,
                                                           PRIX_KWH_ELEC_ACH_HPH__c = parIter.VI_PRIX_KWH_ELEC_ACH_HPhaute_TTC__c,
                                                           //DDPCM 993 END
                                                           TOTAL_MONTANT_ABO_GAZ_HT__c = parIter.VI_TOTAL_MONTANT_ABO_GAZ_HT__c,
                                                           TOTAL_MONTANT_ABO_GAZ__c = parIter.VI_TOTAL_MONTANT_ABO_GAZ_TTC__c,
                                                           MONTANT_ABO_GAZ_ACH_HT__c = parIter.VI_MONTANT_ABO_GAZ_ACH_HT__c,
                                                           MONTANT_ABO_GAZ_ACH__c = parIter.VI_MONTANT_ABO_GAZ_ACH_TTC__c,
                                                           MONTANT_ABO_GAZ_FOUR_HT__c = parIter.VI_MONTANT_ABO_GAZ_FOUR_HT__c,
                                                           MONTANT_ABO_GAZ_FOUR__c = parIter.VI_MONTANT_ABO_GAZ_FOUR_TTC__c,
                                                           TOTAL_MONTANT_CONSO_GAZ_HT__c = parIter.VI_TOTAL_MONTANT_CONSO_GAZ_HT__c,
                                                           TOTAL_MONTANT_CONSO_GAZ__c = parIter.VI_TOTAL_MONTANT_CONSO_GAZ_TTC__c,
                                                           PRIX_KWH_GAZ_ACH_HT__c = parIter.VI_PRIX_KWH_GAZ_ACH_HT__c,
                                                           PRIX_KWH_GAZ_ACH__c = parIter.VI_PRIX_KWH_GAZ_ACH_TTC__c,
                                                           PRIX_KWH_GAZ_FOUR_HT__c = parIter.VI_PRIX_KWH_GAZ_FOUR_HT__c,
                                                           PRIX_KWH_GAZ_FOUR__c = parIter.VI_PRIX_KWH_GAZ_FOUR_TTC__c,
                                                           PRIX_KWH_GAZ_OBLI_HT__c = parIter.VI_PRIX_KWH_GAZ_OBLI_HT__c,
                                                           PRIX_KWH_GAZ_OBLI__c = parIter.VI_PRIX_KWH_GAZ_OBLI__c,
                                                           CODE_FTA__c = parIter.VI_Code_FTA_Offre__c,
                                                           Assurance_facture__c=parIter.VI_AF_Enregistre__c
                                                          );
                if(parIter.VI_CodeOptionGazPanierClient__c!= null){
                    dv.pourcentage_gaz_vert_plus__c = 10;
                }
                else{
                    dv.pourcentage_gaz_vert_plus__c = null;
                }
                
                //DDPCM 1187
                if(String.isNotBlank(parIter.VI_CodePromo__c) ){
                     dv.Promo__c = parIter.VI_CodePromo__c;
                }
                if(String.isNotBlank(parIter.VI_CodePromo2__c)){
                     dv.Promo__c = (parIter.VI_CodePromo__c!= null?dv.Promo__c+'-'+ parIter.VI_CodePromo2__c:parIter.VI_CodePromo2__c);
                }
                                                          
                
                relatedDonneesVenteToUpdate.add(dv);
            }
            
            // Create Case Comment
            
            if(oldParcourMap.containskey(parIter.Id)	
               && parIter.VI_StatutParcours__c != oldParcourMap.get(parIter.Id).VI_StatutParcours__c
               && (parIter.VI_StatutParcours__c == 'CPV Envoyées: PDL/PCE connu' || parIter.VI_StatutParcours__c == 'CPV Envoyées: PDL/PCE non connu') ){
                   if(parIter.VI_CommentaireGeneral_Constitutionpanier__c != null){
                       CaseComment commentCaseTemp = new CaseComment();
                       commentCaseTemp.CommentBody = 'Constitution Panier : ' + parIter.VI_CommentaireGeneral_Constitutionpanier__c;
                       commentCaseTemp.parentId = parIter.VI_Case__c;
                       CaseCommentListInsert.add(commentCaseTemp);
                   }
                   if(parIter.VI_CommentaireGeneral_EstimationConso__c != null){
                       CaseComment commentCaseTemp = new CaseComment();
                       commentCaseTemp.CommentBody = 'Estimation Consommation : ' + parIter.VI_CommentaireGeneral_EstimationConso__c;
                       commentCaseTemp.parentId = parIter.VI_Case__c;
                       CaseCommentListInsert.add(commentCaseTemp);
                   }
                   
                   if(parIter.VI_CommentaireGeneral_idlocal__c != null){
                       CaseComment commentCaseTemp = new CaseComment();
                       commentCaseTemp.CommentBody = 'Identification Local : ' + parIter.VI_CommentaireGeneral_idlocal__c;
                       commentCaseTemp.parentId = parIter.VI_Case__c;
                       CaseCommentListInsert.add(commentCaseTemp);
                   }
                   if(parIter.VI_CommentaireGeneral_idbesoin__c != null){
                       CaseComment commentCaseTemp = new CaseComment();
                       commentCaseTemp.CommentBody = 'Identification Besoin : ' + parIter.VI_CommentaireGeneral_idbesoin__c;
                       commentCaseTemp.parentId = parIter.VI_Case__c;
                       CaseCommentListInsert.add(commentCaseTemp);
                   }
                   if(parIter.VI_CommentaireGeneral_idclient__c != null){
                       CaseComment commentCaseTemp = new CaseComment();
                       commentCaseTemp.CommentBody = 'Identification Client: ' + parIter.VI_CommentaireGeneral_idclient__c;
                       commentCaseTemp.parentId = parIter.VI_Case__c;
                       CaseCommentListInsert.add(commentCaseTemp);
                   }
                   
                   if(parIter.VI_CommentaireGeneral_InfosCompl__c != null){
                       CaseComment commentCaseTemp = new CaseComment();
                       commentCaseTemp.CommentBody = 'Information Complémentaire : ' + parIter.VI_CommentaireGeneral_InfosCompl__c;
                       commentCaseTemp.parentId = parIter.VI_Case__c;
                       CaseCommentListInsert.add(commentCaseTemp);
                   }
                   if(parIter.VI_CommentaireGeneral_MoyensPaiement__c != null){
                       CaseComment commentCaseTemp = new CaseComment();
                       commentCaseTemp.CommentBody = 'Moyens de Paiement : ' + parIter.VI_CommentaireGeneral_MoyensPaiement__c;
                       commentCaseTemp.parentId = parIter.VI_Case__c;
                       CaseCommentListInsert.add(commentCaseTemp);
                   }
                   if(parIter.VI_CommentairesParcours__c != null){
                       CaseComment commentCaseTemp = new CaseComment();
                       commentCaseTemp.CommentBody = 'Récapitulatif de la souscription : ' + parIter.VI_CommentairesParcours__c;
                       commentCaseTemp.parentId = parIter.VI_Case__c;
                       CaseCommentListInsert.add(commentCaseTemp);
                   }
                   
               }
        }   
        
        if (casesToUpdate != null) update casesToUpdate.Values();
        if (relatedDonneesVenteToUpdate.size()!=0) update relatedDonneesVenteToUpdate;
        try {
            insert CaseCommentListInsert;
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        } 
        
        System.debug('update related Cases and Donnees_Vente__c with Parcours data : END');  
    }
    
    /**
* @author Amal Chreiteh
* @date 2/12/2021
* @description Décider le numéro de téléphone à mapper dans Données de ventes
* @param mapContact, contactId
* @return String (phoneNumber)
*/
    
    public static String getPhoneToFill(Map<Id, Contact> mapContact, ID contactId){ 
        String phoneToFill = '';	
        if(contactId != null && mapContact.containsKey(contactId) && mapContact.get(contactId)!=null){
            Contact contactToCheck = mapContact.get(contactId);
            System.debug('### contactToCheck : ' + contactToCheck);
            if(contactToCheck.MobilePhone==null && contactToCheck.Mobile_2__c==null && contactToCheck.Mobile_3__c==null)
            {
                if(contactToCheck.Phone==null && contactToCheck.Tel_Fixe_2__c==null && contactToCheck.Tel_Fixe_3__c==null)
                {
                    phoneToFill='';
                }
                else 
                {
                    if(contactToCheck.Tel_Fixe_Principal__c==null)
                    {
                        phoneToFill = (contactToCheck.Phone!=null?contactToCheck.Phone:
                                       (contactToCheck.Tel_Fixe_2__c!=null?contactToCheck.Tel_Fixe_2__c: 
                                        (contactToCheck.Tel_Fixe_3__c!=null?contactToCheck.Tel_Fixe_3__c:'')));
                    }
                    else{
                        phoneToFill = (contactToCheck.Tel_Fixe_Principal__c=='Tel Fixe 1'?contactToCheck.Phone:
                                       (contactToCheck.Tel_Fixe_Principal__c=='Tel Fixe 2'?contactToCheck.Tel_Fixe_2__c: 
                                        (contactToCheck.Tel_Fixe_Principal__c=='Tel Fixe 3'?contactToCheck.Tel_Fixe_3__c:'')));
                    }
                }
            }
            else 
            {	
                if(contactToCheck.Mobile_Principal__c==null)
                {
                    phoneToFill = (contactToCheck.MobilePhone!=null?contactToCheck.MobilePhone:
                                   (contactToCheck.Mobile_2__c!=null?contactToCheck.Mobile_2__c: 
                                    (contactToCheck.Mobile_3__c!=null?contactToCheck.Mobile_3__c:'')));
                }
                else
                {
                    phoneToFill = (contactToCheck.Mobile_Principal__c=='Mobile 1'?contactToCheck.MobilePhone:
                                   (contactToCheck.Mobile_Principal__c=='Mobile 2'?contactToCheck.Mobile_2__c: 
                                    (contactToCheck.Mobile_Principal__c=='Mobile 3'?contactToCheck.Mobile_3__c:'')));
                }
            }
        }
        return phoneToFill; 
    }
    /**
* @author Amal Chreiteh
* @date 2/12/2021
* @description Mapper les picklists values différentes entre l'objet parcours et l'objet données de vente
* @param energie ( gaz, elec, ..), energieType ( eauChaude, ..)
* @return String (Correct picklist value)
*/
    
    public static String getEnergieValue(String energie, String energieType){ 
        if( energie == 'Je ne sais pas'){
            return 'NSP';
        }
        if(energieType == 'eauChaude'){        
            if( energie == 'Gaz naturel'){
                return 'Gaz_naturel';
            }
            if( energie == 'Electricité'){
                return 'Électricité';
            }
            if( energie == 'Réseau de chaleur'){
                return 'Réseau_de_chaleur';
            }
            if( energie == 'Propane GPL'){
                return 'Propane_GPL';
            }
            if( energie == 'Autre énergie renouv'){
                return 'Autre_énergie_renouvelable';
            }
            
        }
        
        if(energieType == 'chauffage'){        
            if( energie == 'Gaz naturel'){
                return 'Gaz';
            }
            if( energie == 'Electricité'){
                return 'Elec';
            }
            if( energie == 'Autre énergie renouv'){
                return 'Autre énergie renouvelable';
            }
        }
        return energie;
    }
}