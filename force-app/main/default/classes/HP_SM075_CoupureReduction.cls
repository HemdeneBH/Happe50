/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 03-15-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_SM075_CoupureReduction {

    @future(callout=true)
    public static void processCoupureReduction(List<Id> caseIds){
        HP_EM054_CoupureReduction.processCoupureReduction(caseIds);
    }

    @AuraEnabled
    public static string processRetablissement(String caseId, Boolean prestaUrgente, String origineDemande){
        return HP_EM054_CoupureReduction.processRetablissement(caseId, prestaUrgente, origineDemande);
    }

}