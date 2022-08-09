/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 


 * @last modified on  : 08-12-2020


 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-28-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
global class HP_EM031_RetractLoadContractInfo {
    @InvocableMethod(label='Get contract Info')
    global static List<ContractStatusWrapper> getInfoContract(List<String> souscriptionId) {
        System.debug('@@ souscriptionId1 ' + souscriptionId);
         List<HP_Contrat__c> contratList = [select HP_Contrat_XdataId__c, HP_Type_de_Compteur__c from HP_Contrat__c where HP_Souscription__c in :souscriptionId];
         ContractStatusWrapper result = new ContractStatusWrapper();
         for(HP_Contrat__c cont : contratList) {
             if(cont.HP_Contrat_XdataId__c == null || String.valueOf(cont.HP_Contrat_XdataId__c) == null) {
                 continue;
             }
             String body = HP_EM034_Retractation.loadContractFromXdata(String.valueOf(cont.HP_Contrat_XdataId__c));
             Map<String, Object> contMap = (Map<String, Object>) JSON.deserializeUntyped(body);
 
             System.debug('## body : ' + body);
             if(cont.HP_Type_de_Compteur__c == 'ELEC') {
                 result.statusElec = String.valueOf(contMap.get('codeStatutCrm'));


                 result.labelStatusElec = String.valueOf(contMap.get('libelleStatutCrm'));
             } else {
                 result.statusGaz = String.valueOf(contMap.get('codeStatutCrm'));
                 result.labelStatusGaz = String.valueOf(contMap.get('libelleStatutCrm'));


             }
         }
         result.dayNumberSave3 = null;
         System.debug('@@ souscriptionId ' + souscriptionId);
         HP_Souscription__c souscription = [select HP_DigitalDateSave3__c, HP_Date_de_Contractualisation__c, HP_Date_Origine__c 
                            from HP_Souscription__c where id in :souscriptionId];
         result.dateContractulisation = souscription.HP_Date_de_Contractualisation__c;
         result.dateOrigine = Date.newinstance(souscription.HP_Date_Origine__c.year(), souscription.HP_Date_Origine__c.month(), souscription.HP_Date_Origine__c.day());
        
         result.dateToday =System.today();
         if(souscription.HP_DigitalDateSave3__c != null) {
            result.dateSave3 = Date.newinstance(souscription.HP_DigitalDateSave3__c.year(), souscription.HP_DigitalDateSave3__c.month(), souscription.HP_DigitalDateSave3__c.day());
             result.dayNumberSave3 = numberDateFromToday(result.dateSave3, System.today());
         }
         result.dayNumberContractualisation = numberDateFromToday(result.dateOrigine, souscription.HP_Date_de_Contractualisation__c);
         return new List<ContractStatusWrapper>{result};
    }
    
    private static Integer numberDateFromToday(Date d1, Date d2) {
        if( d1 == null || d2 == null) {
            return null;
        }
        return d1.daysBetween(d2);
    }
    global class ContractStatusWrapper {
         @InvocableVariable
         global String statusElec;
         @InvocableVariable
         global String statusGaz;
         @InvocableVariable


         global String labelStatusElec;
         @InvocableVariable
         global String labelStatusGaz;
         @InvocableVariable


         global Integer dayNumberSave3;
         @InvocableVariable
         global Integer dayNumberContractualisation;
         @InvocableVariable
         global Date dateToday;
         @InvocableVariable
         global Date dateOrigine;
         @InvocableVariable
         global Date dateContractulisation;
         @InvocableVariable
         global Date dateSave3;

    }
}