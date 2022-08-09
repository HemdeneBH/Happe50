/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-29-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-28-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
global class HP_EM033_RetractLoadOPSInfo {
    @InvocableMethod(label='Get OPS Info')
    global static List<OPSInfoWrapper> getInfoOPS(List<String> souscriptionId) {
         List<Prestation_distributeur__c> opsList = [select Statut__c, HP_Contrat__r.HP_Type_de_Compteur__c, Date_de_prestation__c
         from Prestation_distributeur__c where HP_Contrat__r.HP_Souscription__c in :souscriptionId];
         OPSInfoWrapper result = new OPSInfoWrapper();
         result.opsExist = (opsList.size() != 0);
         Date minDate = null;
         for(Prestation_distributeur__c ops : opsList) {
             if(ops.HP_Contrat__r.HP_Type_de_Compteur__c == 'ELEC') {
                result.datePrestationElec =  ops.Date_de_prestation__c;
                result.statusElec = ops.Statut__c;
             } else {
                result.statusGaz = ops.Statut__c;
                result.datePrestationGaz =  ops.Date_de_prestation__c;
             }
             if(minDate == null && ops.Date_de_prestation__c != null) {
                minDate = ops.Date_de_prestation__c;
             } else if(ops.Date_de_prestation__c != null && minDate > ops.Date_de_prestation__c) {
                minDate =  ops.Date_de_prestation__c;
             }
         }
         result.minNumberDateOPS = null;
         if(minDate != null) {
            result.minNumberDateOPS = System.today().daysBetween(minDate);
         }
         result.datePrestationMin = minDate;
         return new List<OPSInfoWrapper>{result};
    }
    
    
    global class OPSInfoWrapper {
         @InvocableVariable
         global String statusElec;
         @InvocableVariable
         global String statusGaz;
         @InvocableVariable
         global Integer minNumberDateOPS;
         @InvocableVariable
         global boolean opsExist;
         @InvocableVariable
         global Date datePrestationElec;
         @InvocableVariable
         global Date datePrestationGaz;
         @InvocableVariable
         global Date datePrestationMin;
         
    }
}