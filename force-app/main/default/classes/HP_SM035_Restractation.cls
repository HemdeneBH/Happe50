/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-07-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-27-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public without sharing class HP_SM035_Restractation {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> processRestractionProcess(String souscriptionId){
        List<String> outputList = new List<String>{'processEndResult', 'dayNumberContractualisation', 'dayNumberOPS', 'dayNumberSave3','updatePCStatus',
    'elecStatusContract', 'elecStatusOPS', 'elecStatusPC', 'gazStatusContract', 'gazStatusOPS', 'gazStatusPC', 'messageOutput', 'opsExist', 'US', 'updateContractStatus',
        'dateContractulisation', 'dateOrigine', 'datePrestationElec', 'datePrestationGaz', 'datePrestationMin', 'dateSave3', 'dateToday', 'createCase', 'updateSouscriptionStatus'};
        Map<String, Object> result = new Map<String, Object>();
        Flow.Interview.Hp_Retractation restractationFlow = new Flow.Interview.Hp_Retractation(new Map<String, Object> {'souscriptionId' => souscriptionId});
        restractationFlow.start();
       for(String item : outputList) { 
        result.put(item, restractationFlow.getVariableValue(item));
       }
       result.put('permissionViewLog', FeatureManagement.checkPermission('HP_VIEW_LOG_VUE360'));
       result.put('transactionId', HP_UTIL_HTTPUtils.getTransactionId());
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> confirmRetractation(String souscriptionId, boolean createCase, boolean updatePCStatus, boolean updateContractStatus, String updateSouscriptionStatus){
        Map<String, Object> result = new Map<String, Object>();
        result.put('transactionId', HP_UTIL_HTTPUtils.getTransactionId());

        List<HP_Contrat__c> contratList = [select Id,HP_Contrat_XdataId__c, HP_Type_de_Compteur__c, HP_Proposition_Commerciale_XdataId__c from HP_Contrat__c where HP_Souscription__c = :souscriptionId];
        List<Case> caseList = new List<Case>();
        Boolean bugApi = false;
        for(HP_Contrat__c cont : contratList) {
            String descriptionCase = '';
            if(updatePCStatus) {
                  String res = HP_EM034_Retractation.cancelXdataPC(cont.HP_Proposition_Commerciale_XdataId__c);
                  if(res != null) {
                    descriptionCase += 'PC Xdata KO : ' + res + '\n';
                  }
            }

            if(updateContractStatus) {
                String resXDATA = HP_EM034_Retractation.cancelXdataContrat(String.valueOf(cont.HP_Contrat_XdataId__c));
                if(resXDATA != null) {
                  descriptionCase += 'Contrat Xdata KO : ' + resXDATA + '\n';
                }
                String resAgilab = HP_EM034_Retractation.cancelAgilabContrat(String.valueOf(cont.HP_Contrat_XdataId__c));
                if(resAgilab != null) {
                  descriptionCase += 'Contrat Agilab KO : ' + resAgilab + '\n';
                }
            }
            if(createCase) {
                caseList.add(HP_EM034_Retractation.createCaseRetractation(souscriptionId,descriptionCase,(descriptionCase == '' ? 'CLOSED': 'TO_DO'), cont.Id, (cont.HP_Type_de_Compteur__c == 'GAS' ? 'Gas' : 'Electricity')));
            }
            if(descriptionCase != '') {
                bugApi = true;
            }
        }
        result.put('resultAPI', true);
        if(caseList.size() > 0) {
            if(bugApi) {
                result.put('resultAPI', false);
            }
            
            System.debug('insert ' + caseList.size());
            insert caseList;
            System.debug('insert ');
            for(Integer i = 0; i < caseList.size(); i++) {
                result.put('case' + (i+1), caseList.get(i).Id);
            }
        }
        if(updateSouscriptionStatus != null) {
            HP_Souscription__c sous = new HP_Souscription__c(Id = souscriptionId, HP_Statut__c = updateSouscriptionStatus);
            update sous;
        }
        return result;
    }
}