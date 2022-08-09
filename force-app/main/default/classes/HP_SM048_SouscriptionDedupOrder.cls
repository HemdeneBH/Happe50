/**
 * @description  : 
 * @author       : Ali AJELLAL
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   02-12-2020   Ali AJELLAL   Initial Version
**/
public without sharing class HP_SM048_SouscriptionDedupOrder{

    
    /**
    * @La méthode permet de MAJ le champ HP_TECH_DedupOrder__c  sur la souscription en double ayant le statut le plus élevé.
    * @author Ali AJELLAL | 12-03-2020 
    * @param souscriptions 
    **/
    public static void updateSouscriptionWithHighestStatus(List<HP_souscription__c> souscriptions, Date souscriptionDate){
        if(souscriptions == null) return;

        Set<String> concatenationSet = new Set<String>();
        Map<String,List<HP_souscription__c>> mapPdlPceToSouscription = new Map<String,List<HP_souscription__c>>();
        List<HP_souscription__c> souscriptionsToUpdate = new List<HP_souscription__c>();
        Set<Id> ids = new Set<Id>();

        for (HP_souscription__c souscription : souscriptions) {
            concatenationSet.add(souscription.HP_TECH_FormulaConcatField__c);
        }
        System.debug('****************souscriptionList before size************** : ' + souscriptions.size());

        List<HP_Souscription__c> souscriptionList =  HP_EM005_Souscription.getSouscriptionsConcat(concatenationSet, souscriptionDate);
        System.debug('****************souscriptionList************** : ' + souscriptionList);
        System.debug('****************souscriptionList after size************** : ' + souscriptionList.size());


        // construire la Map des concaténations et la liste des souscriptions associée.
        for (HP_Souscription__c souscription : souscriptionList) {
            if(mapPdlPceToSouscription.containsKey(souscription.HP_TECH_FormulaConcatField__c)){
                List<HP_souscription__c> listSouscription = mapPdlPceToSouscription.get(souscription.HP_TECH_FormulaConcatField__c);
                listSouscription.add(souscription);
                mapPdlPceToSouscription.put(souscription.HP_TECH_FormulaConcatField__c, listSouscription);
            }else {
                mapPdlPceToSouscription.put(souscription.HP_TECH_FormulaConcatField__c, new List<HP_souscription__c> { souscription });
               
            }
        }
        System.debug('****************mapPdlPceToSouscription************** : ' + mapPdlPceToSouscription);

        // recuperer les ids des souscriptions avec le statut le plus elevé
        for (String  folmulaConcatField  :  mapPdlPceToSouscription.keySet()) {
            Id idSouscription;
            Integer maxValue = 0;
            for (HP_souscription__c souscription  : mapPdlPceToSouscription.get(folmulaConcatField)){
                souscription.HP_TECH_DedupOrder__c = null;
                Integer statusValue = getStatusValue(souscription.HP_Statut__c);
                if(statusValue > maxValue) {
                    maxValue = statusValue;
                    idSouscription = souscription.Id;
                }
            }
            for (HP_souscription__c souscription  : mapPdlPceToSouscription.get(folmulaConcatField)) {
                if(idSouscription == souscription.Id){
                    souscription.HP_TECH_DedupOrder__c = 1;
                }

                souscriptionsToUpdate.add(souscription);
            }

        }

        if(souscriptionsToUpdate.size() > 0) Database.update(souscriptionsToUpdate);
    }

    /**
    * @
    * @author Ali AJELLAL | 12-04-2020 
    * @param status 
    * @return Integer 
    **/
    public static Integer getStatusValue(String status){

        switch on status {
            when 'RETRACT' {
                return 1;
            }
            when 'PERIMEE' {
                return 2;
            }
            when 'CANCEL' {
                return 3;
            }
            when 'SAVE_1' {
                return 4;
            }
            when 'SAVE_2' {
                return 5;
            }
            when 'SAVE_2_CONFIRMED' {
                return 6;
            }
            when 'SAVE_3' {
                return 7;
            }
        }
        return 1;
    }
}