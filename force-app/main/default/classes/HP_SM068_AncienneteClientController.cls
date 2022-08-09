/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 10-14-2021
 * @last modified by  : Badr Eddine Belkarchi
**/
public with sharing class HP_SM068_AncienneteClientController {

    @AuraEnabled(cacheable=true)
    public static List<Object> getAllContractsOfClient(string idXdataPersonne) {

        String resultContrat = HP_CALL001_XDATA.loadContractsFromXdata(idXdataPersonne);

        if((resultContrat == null) || resultContrat == '') 
            return new List<Map<String,Object>>();

        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(resultContrat);
        List<Object> listresponse = (List<Object>) resultAsMap.get('_data');

        List<Map<String,Object>> results = new List<Map<String,Object>>();

        for (Object item : listresponse) {
            Map<String,Object> data = (Map<String,Object>)item;
            Map<String,Object> partialContrat = new Map<String,Object>();

            partialContrat.put('id', data.get('id'));
            partialContrat.put('idPersonne', data.get('idPersonne'));
            partialContrat.put('statut', data.get('statut'));
            // partialContrat.put('codeStatutCrm', data.get('codeStatutCrm'));
            // partialContrat.put('libelleStatutCrm', data.get('libelleStatutCrm'));
            partialContrat.put('dateDebutValidite', data.get('dateDebutValidite'));
            partialContrat.put('dateFinValidite', data.get('dateFinValidite'));
            partialContrat.put('codeOffre', data.get('codeOffre'));

            results.add(partialContrat);
        }

        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<Object> getAllCodeOffres() {
        List<HP_Offre__c> codeOffres = HP_Offre__c.getall().values();
        return codeOffres;
    }
}