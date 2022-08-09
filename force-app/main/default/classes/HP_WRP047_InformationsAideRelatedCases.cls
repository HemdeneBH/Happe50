/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 12-06-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_WRP047_InformationsAideRelatedCases {
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
        @AuraEnabled
        public String caseSubject {get;set;}
        @AuraEnabled 
        public String caseWebName {get;set;}
    public HP_WRP047_InformationsAideRelatedCases(Case relatedCase) {
        this.caseId = relatedCase.Id;
        this.caseNumber = String.valueOf(relatedCase.CaseNumber);
        this.caseStatus = relatedCase.Status ;
        this.caseTypeHP = relatedCase.HP_Type__c;
        this.caseCreationDate = relatedCase.CreatedDate.format('dd/MM/yyyy HH:mm','Europe/Paris');
        this.caseSubject = relatedCase.Subject;
        this.caseWebName = relatedCase.SuppliedName;
    }
}