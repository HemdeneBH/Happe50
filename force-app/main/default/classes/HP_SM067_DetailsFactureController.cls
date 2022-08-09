/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 08-23-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_SM067_DetailsFactureController {
    
    @AuraEnabled(Cacheable = true)
    public static List<HP_WRP042_RelatedCasesFactures> getRelatedCasesByRefFacture(String refFacture){
        System.debug('HP_WRP042_RelatedCasesFactures.getRelatedCasesByRefFacture() | Method Start');
        List<Case> relatedCases = new List<Case>();
        List<HP_WRP042_RelatedCasesFactures> relatedCasesWrapperList = new List<HP_WRP042_RelatedCasesFactures>();
        Set<String> listStatus = new Set<String>{'NEW_CASE','TO_DO','DELAYED_PROCESS','Escaladé (happe)','HP_PENDING','CANCELED','CLOSED','HP_Refused'};
        if(refFacture != null){
            try {
                relatedCases = [SELECT Id, createdDate, HP_Numero_de_facture__c, CaseNumber, Status, HP_Type__c from Case WHERE HP_Numero_de_facture__c = :refFacture AND Status IN :listStatus ORDER BY createdDate DESC];
                if(!relatedCases.isEmpty() && relatedCases.size()>0){
                    for(Case c : relatedCases){
                        relatedCasesWrapperList.add(new HP_WRP042_RelatedCasesFactures(c));
                    } 
                }
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
        System.debug('##Related Cases by Invoice : '+relatedCasesWrapperList);
        System.debug('HP_WRP042_RelatedCasesFactures.getRelatedCasesByRefFacture() | Method Exit');
        return relatedCasesWrapperList;
    }

    public class HP_WRP042_RelatedCasesFactures{
        @AuraEnabled
        public string caseNumber {get;set;}
        @AuraEnabled
        public string caseCreationDate {get;set;}
        @AuraEnabled
        public string caseStatus{get;set;}
        @AuraEnabled
        public string caseTypeHP {get;set;}
        @AuraEnabled
        public Id caseId {get;set;}

        public HP_WRP042_RelatedCasesFactures(Case relatedCase){
            this.caseId = relatedCase.Id;
            this.caseNumber = String.valueOf(relatedCase.CaseNumber);
            switch on relatedCase.Status {
                when 'NEW_CASE' {		
                    this.caseStatus = 'Nouveau (happe)';
                }	
                when 'TO_DO' {		
                    this.caseStatus = 'A traiter (happe)';
                }
                when 'DELAYED_PROCESS' {		
                    this.caseStatus = 'Différé (happe)';
                }
                when 'HP_PENDING' {		
                    this.caseStatus = 'En attente (happe)';
                }
                when 'CANCELED' {		
                    this.caseStatus = 'Annulé (happe)';
                }
                when 'CLOSED' {		
                    this.caseStatus = 'Fermé (happe)';
                }
                when 'HP_Refused' {		
                    this.caseStatus = 'Refusé (happe)';
                }
                when else {		
                    this.caseStatus = 'Escaladé (happe)';
                }
            }
            switch on relatedCase.HP_Type__c {
                when 'INVALID_DATA' {		
                    this.caseTypeHP = 'Données invalides (souscription Digital)';
                }	
                when 'CONTRACT_CANCELATION' {		
                    this.caseTypeHP = 'Résiliation (happe)';
                }
                when 'Service' {		
                    this.caseTypeHP = 'Frais / Service';
                }
                when 'HP_CONTRACT_DATA' {		
                    this.caseTypeHP = 'Données contrat happ-e';
                }
                when 'HP_ENROLMENT_MOVING_OUT' {		
                    this.caseTypeHP = 'Souscription - Déménagement';
                }
                when 'HP_INFORMATION' {		
                    this.caseTypeHP = 'Informations';
                }
                when 'HP_BILLING' {		
                    this.caseTypeHP = 'Facturation';
                }
                when 'HP_TECHNICAL_ISSUE' {		
                    this.caseTypeHP = 'Urgence - Problème technique';
                }
                when 'HP_MANUAL_PROCESS' {		
                    this.caseTypeHP = 'Prestation GRD manuelle';
                }
                when 'HP_Contractualization' {		
                    this.caseTypeHP = 'Contractualisation en erreur (Agilab)';
                }
                when 'HP_Chat' {		
                    this.caseTypeHP = 'Chat';
                }
                when 'HP_AUTOMATED_PROCESS' {		
                    this.caseTypeHP = 'Prestation GRD automatique	';
                }
                when 'HP_SouscriptionDigital' {		
                    this.caseTypeHP = 'Souscription Digital';
                }
                when 'HP_Form_Site' {		
                    this.caseTypeHP = 'Formulaire site internet';
                }
                when 'HP_Gestion_Contrat' {		
                    this.caseTypeHP = 'Gestion de contrat Happe';
                }
                when 'HP_Souscription' {		
                    this.caseTypeHP = 'Souscription Happe';
                }
                when 'HP_Assistance' {		
                    this.caseTypeHP = 'Assistance Happe';
                }
                when 'HP_Paiement' {		
                    this.caseTypeHP = 'Paiement Happe';
                }
                when 'HP_Reclamation' {		
                    this.caseTypeHP = 'Réclamation Happe';
                }
                when 'HP_ChatIndispo' {		
                    this.caseTypeHP = 'Chat Indisponible';
                }
                when 'HP_ConsentementsDigital' {		
                    this.caseTypeHP = 'Enregistrements consentements Xdata KO';
                }
                when 'HP_XDATA_ANOMALIE' {		
                    this.caseTypeHP = 'Anomalie Création Xdata';
                }
                when 'HP_DocumentCreationError' {		
                    this.caseTypeHP = 'Erreur création de documents';
                }
                when 'HP_Flux_GRD' {		
                    this.caseTypeHP = 'Flux GRD';
                }
                when 'HP_INSATISFACTION_CLIENT' {		
                    this.caseTypeHP = 'Insatisfaction client';
                }
                when 'HP_Mediation' {		
                    this.caseTypeHP = 'Médiation happe';
                }
                when 'HP_TIC_TAC' {		
                    this.caseTypeHP = 'TIC TAC';
                }
                when 'HP_Appel_Diabolocom' {		
                    this.caseTypeHP = 'Appel Diabolocom';
                }
                when 'HP_Rappel_planifie' {		
                    this.caseTypeHP = 'Rappel planifié';
                }
                when 'HP_Modification_titulaire' {		
                    this.caseTypeHP = 'Modification titulaire';
                }
                when 'HP_RappelLeadNonSigne' {		
                    this.caseTypeHP = 'Rappel lead non signé';
                }
                when 'HP_InsatisfactionSouscription' {		
                    this.caseTypeHP = 'Insatisfaction client souscription';
                }
                when else {		
                    this.caseTypeHP = relatedCase.HP_Type__c;
                }
            }
            this.caseCreationDate = relatedCase.CreatedDate.format('dd/MM/yyyy HH:mm','Europe/Paris');
        }
    }
}