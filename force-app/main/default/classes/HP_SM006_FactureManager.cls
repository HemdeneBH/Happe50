/**
 * @File Name          : HP_SM004_FactureManager.cls
 * @Description        : class permet de gerer les facture
 * @Author             : Slimene Belhaj Ali
 * @Group              : 
 * @Created On         : 09/01/2020
**/
public with sharing class HP_SM006_FactureManager {

    /**
    * @description modifier le mode d'envoi facture
    * @author Slimene Belhaj Ali | 09/01/2020
    * @param String contractId Xdata contact Id 
    * @param String agilabStatus Statut de mode d'envoi { 1 => Electronique, 2 => Papier }
    * @return HP_PortailUtilisateur__c 
    **/
    @AuraEnabled(cacheable=true)
    public static Map<Integer, String> updateFactureModeEnvoi(String contractId, Integer agilabStatus){
        return HP_EM006_FactureManager.updateFactureModeEnvoi(contractId, agilabStatus);
    }

    @AuraEnabled
    public static Map<String, Object> updateEnergieVert(String contractId, String energieVert){
        return HP_EM006_FactureManager.updateEnergieVert(contractId, energieVert);
    }

    @AuraEnabled
    public static Map<String, Object> loadEnergieVerOption(String contractId){
        return HP_EM006_FactureManager.loadEnergieVerOption(contractId);
    }
}