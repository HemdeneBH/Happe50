/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-26-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   09-09-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class HP_EM036_SyncXdataSF {
    
    public static Map<String, Object> loadContractFromXdata(String xdataId) {
        Map<String, Object> listJson = (Map<String, Object>) JSON.deserializeUntyped(HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_CONTRATS, '/' + xdataId).getBody());
        HP_Contrat__c cont = new HP_Contrat__c(
            HP_Contrat_XdataId__c = Integer.valueOf(xdataId),
            HP_Type_de_Compteur__c = (listJson.get('energie') == 'Electricité' ? 'ELEC' : 'GAS'),
            HP_Porte_Feuille_Contrat__r = new HP_Porte_Feuille_Contrat__c(Xdata_Id__c = String.valueOf(listJson.get('idPortefeuilleContrat')))
        );

        Map<String, Object> result = new Map<String, Object>();
        result.put('cont' , cont);
        result.put('xdataPersonne' , listJson.get('idPersonne'));
        result.put('xdataPDL', listJson.get('idPointDeLivraison'));

        return result;
    }

    public static HP_Porte_Feuille_Contrat__c createPFC(String xdataIdPFC, String xdataContact) {
        HP_Porte_Feuille_Contrat__c pfc = new HP_Porte_Feuille_Contrat__c(
            HP_Contact__r = new Contact(Id_Tiers__c = Integer.valueOf(xdataContact)),
            Xdata_Id__c = xdataIdPFC
        );

        return pfc;
    }
}