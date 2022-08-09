/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-04-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-28-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
global class HP_EM032_RetractLoadPCInfo {
    @InvocableMethod(label='Get PC Info')
    global static List<PCInfoWrapper> getInfoPC(List<String> souscriptionId) {
         List<HP_Contrat__c> contratList = [select HP_Proposition_Commerciale_XdataId__c, HP_Type_de_Compteur__c from HP_Contrat__c where HP_Souscription__c in :souscriptionId];
         PCInfoWrapper result = new PCInfoWrapper();
         for(HP_Contrat__c cont : contratList) {
             if(cont.HP_Proposition_Commerciale_XdataId__c == null) {
                 continue;
             }
             String body = HP_EM034_Retractation.loadPropositionCommecrialeXdata(String.valueOf(cont.HP_Proposition_Commerciale_XdataId__c));
             Map<String, Object> contMap = (Map<String, Object>) JSON.deserializeUntyped(body);
 
             System.debug('## body : ' + body);
             if(cont.HP_Type_de_Compteur__c == 'ELEC') {
                 result.statusElec = String.valueOf(contMap.get('codeStatutPropositionCommercialeHeader'));
             } else {
                 result.statusGaz = String.valueOf(contMap.get('codeStatutPropositionCommercialeHeader'));
             }
         }

         return new List<PCInfoWrapper>{result};
    }
    
    global class PCInfoWrapper {
         @InvocableVariable
         global String statusElec;
         @InvocableVariable
         global String statusGaz;
         
    }
}