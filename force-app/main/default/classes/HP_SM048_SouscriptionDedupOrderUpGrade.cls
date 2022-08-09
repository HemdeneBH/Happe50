/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 

 * @last modified on  : 07-09-2021

 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   04-26-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

public without sharing class HP_SM048_SouscriptionDedupOrderUpGrade{

    public static final String SAVE_1 = 'SAVE_1';
    public static final String SAVE_2 = 'SAVE_2';
    public static final String SAVE_2_CONFIRMED = 'SAVE_2_CONFIRMED';
    public static final String SAVE_3 = 'SAVE_3';
    public static final String RETRACT = 'RETRACT';
    public static final String CANCEL = 'CANCEL';

    public static final String PERIMEE = 'PERIMEE';



  
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 04-26-2021 
    * @param souscriptions 
    * @param souscriptionDate 
    **/
    public static void updateSouscriptionWithHighestStatus(List<HP_souscription__c> souscriptions, Date souscriptionDate){
        
        if(souscriptions == null) return;
        List<HP_souscription__c> souscriptionsToUpdate = new List<HP_souscription__c>();

        Map<String,List<HP_souscription__c>> mapenergyPdlPceToSouscription = new Map<String,List<HP_souscription__c>>();
        Map<String,List<HP_souscription__c>> mapEnergyPdlPceContactSave2ToSouscription = new Map<String,List<HP_souscription__c>>();
        Map<String,List<HP_souscription__c>> mapEnergyPdlPceContactSave3ToSouscription = new Map<String,List<HP_souscription__c>>();

        /** contient les souscriptions souscriptions annulées, périmées et rétractées */

        Map<String,List<HP_souscription__c>> canceledSouscriptionMap =  new Map<String,List<HP_souscription__c>>();

        Set<String> souscTechSave2 = new Set<String>();
        Set<String> souscTechSave3 = new Set<String>();
        Set<String> souscTechAnnule = new Set<String>();
        System.debug('*******list souscriptions in:***'+souscriptions.size());

        /**MAP des souscription selon statut */
        for (HP_souscription__c sousc : souscriptions) {
            if(sousc.HP_Statut__c == SAVE_1){
                if(mapenergyPdlPceToSouscription.containsKey(sousc.HP_TECH_FormulaEnergyPDLPCEField__c)){
                    List<HP_souscription__c> listSouscription = mapenergyPdlPceToSouscription.get(sousc.HP_TECH_FormulaEnergyPDLPCEField__c);
                    listSouscription.add(sousc);
                    mapenergyPdlPceToSouscription.put(sousc.HP_TECH_FormulaEnergyPDLPCEField__c, listSouscription);
                }else {
                    mapenergyPdlPceToSouscription.put(sousc.HP_TECH_FormulaEnergyPDLPCEField__c, new List<HP_souscription__c> { sousc });
                   
                }
                System.debug('*******mapenergyPdlPceToSouscription:***'+mapenergyPdlPceToSouscription);

            }
            else if(sousc.HP_Statut__c == SAVE_2 || sousc.HP_Statut__c == SAVE_2_CONFIRMED){
                souscTechSave2.add(sousc.HP_TECH_FormulaEnergyPDLPCEField__c);
                if(mapEnergyPdlPceContactSave2ToSouscription.containsKey(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c)){
                    List<HP_souscription__c> listSouscription = mapEnergyPdlPceContactSave2ToSouscription.get(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c);
                    listSouscription.add(sousc);
                    mapEnergyPdlPceContactSave2ToSouscription.put(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c, listSouscription);
                }else {
                    mapEnergyPdlPceContactSave2ToSouscription.put(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c, new List<HP_souscription__c> { sousc });
                   
                }
                System.debug('*******mapEnergyPdlPceContactSave2ToSouscription:***'+mapEnergyPdlPceContactSave2ToSouscription);
            }
            else if(sousc.HP_Statut__c == SAVE_3) {
                souscTechSave2.add(sousc.HP_TECH_FormulaEnergyPDLPCEField__c);
                souscTechSave3.add(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c);
                if(mapEnergyPdlPceContactSave3ToSouscription.containsKey(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c)){
                    List<HP_souscription__c> listSouscription = mapEnergyPdlPceContactSave3ToSouscription.get(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c);
                    listSouscription.add(sousc);
                    mapEnergyPdlPceContactSave3ToSouscription.put(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c, listSouscription);
                }else {
                    mapEnergyPdlPceContactSave3ToSouscription.put(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c, new List<HP_souscription__c> { sousc });
                   
                }
                System.debug('*******mapEnergyPdlPceContactSave3ToSouscription:***'+mapEnergyPdlPceContactSave3ToSouscription);
            }

            else if(sousc.HP_Statut__c == RETRACT || sousc.HP_Statut__c == CANCEL || sousc.HP_Statut__c == PERIMEE) {
                souscTechAnnule.add(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c);
                populateMap(sousc, canceledSouscriptionMap);

                System.debug('*******canceledSouscriptionMap:***'+canceledSouscriptionMap);

            }
        }
        

        /**Traitement SAVE1 */
        for (String  folmulaConcatField  :  mapenergyPdlPceToSouscription.keySet()) {

            if(souscTechAnnule.contains(folmulaConcatField)){
                /** si une autre souscription(meme pdl/pce et energie) est au statut annulée, alors mettre null pour les souscription en save1 */
                for ( HP_souscription__c souscription  : mapenergyPdlPceToSouscription.get(folmulaConcatField)) {
                    souscription.HP_TECH_DedupOrder__c = null;
                    souscriptionsToUpdate.add(souscription);
                }
            }else{

            for( Integer i=0; i < mapenergyPdlPceToSouscription.get(folmulaConcatField).size()-1 ; i++){
                if(mapenergyPdlPceToSouscription.get(folmulaConcatField)[i+1].HP_TECH_DedupOrder__c ==1 ){
                    mapenergyPdlPceToSouscription.get(folmulaConcatField)[i].HP_TECH_DedupOrder__c = null;
                    souscriptionsToUpdate.add( mapenergyPdlPceToSouscription.get(folmulaConcatField)[i]);
                }
            }

            }


            for( HP_souscription__c souscription  : mapenergyPdlPceToSouscription.get(folmulaConcatField)){
               if(souscTechSave2.contains(souscription.HP_TECH_FormulaEnergyPDLPCEField__c)){
                souscription.HP_TECH_DedupOrder__c = null; 
                if(souscriptionsToUpdate.contains(souscription) && souscriptionsToUpdate.indexOf(souscription) != -1){
                    souscriptionsToUpdate.remove(souscriptionsToUpdate.indexOf(souscription));
                }
                souscriptionsToUpdate.add(souscription);
               }
            }
            System.debug('*******souscriptionsToUpdate save1 :***'+souscriptionsToUpdate);
        }


        /**Traitement SAVE2 */
        for (String  folmulaConcatField : mapEnergyPdlPceContactSave2ToSouscription.keySet()) {

            for( HP_souscription__c souscription  : mapEnergyPdlPceContactSave2ToSouscription.get(folmulaConcatField)){
                if(souscTechSave3.contains(souscription.HP_TECH_FormulaEnergyPDLPCEConcatField__c)){
                souscription.HP_TECH_DedupOrder__c = null;
                souscriptionsToUpdate.add(souscription);
                }
                System.debug('*******souscriptionsToUpdate save2 :***'+souscriptionsToUpdate);

            }

            if(mapEnergyPdlPceContactSave2ToSouscription.get(folmulaConcatField).size() >1) {
                // garder la 1ere souscription à 1.
                mapEnergyPdlPceContactSave2ToSouscription.get(folmulaConcatField)[0].HP_TECH_DedupOrder__c = 1;
                souscriptionsToUpdate.add( mapEnergyPdlPceContactSave2ToSouscription.get(folmulaConcatField)[0]);
                for( Integer i=1; i < mapEnergyPdlPceContactSave2ToSouscription.get(folmulaConcatField).size() ; i++){
                    mapEnergyPdlPceContactSave2ToSouscription.get(folmulaConcatField)[i].HP_TECH_DedupOrder__c = null;
                    souscriptionsToUpdate.add( mapEnergyPdlPceContactSave2ToSouscription.get(folmulaConcatField)[i]);
                }
                // Vérifier les souscriptions annulées.
                for( HP_souscription__c souscription  : mapEnergyPdlPceContactSave2ToSouscription.get(folmulaConcatField)){
                    if(souscTechAnnule.contains(souscription.HP_TECH_FormulaEnergyPDLPCEConcatField__c)  ){
                    souscription.HP_TECH_DedupOrder__c = 1;
                    souscriptionsToUpdate.add(souscription);
                    for (HP_souscription__c sc  : canceledSouscriptionMap.get(souscription.HP_TECH_FormulaEnergyPDLPCEConcatField__c)) {
                        sc.HP_TECH_DedupOrder__c = null;
                        souscriptionsToUpdate.add(sc);
                    }
                    }
                }
            }
         }

        /**Traitement SAVE3 : Garder la 1ère souscription*/
        for (String  item  :  mapEnergyPdlPceContactSave3ToSouscription.keySet()) {
            System.debug('*******list item********:***'+item);
            if(mapEnergyPdlPceContactSave3ToSouscription.get(item).size() > 1){
                mapEnergyPdlPceContactSave3ToSouscription.get(item)[0].HP_TECH_DedupOrder__c = 1;
                souscriptionsToUpdate.add( mapEnergyPdlPceContactSave3ToSouscription.get(item)[0]);
                for( Integer i=1; i < mapEnergyPdlPceContactSave3ToSouscription.get(item).size() ; i++){
                    mapEnergyPdlPceContactSave3ToSouscription.get(item)[i].HP_TECH_DedupOrder__c = null;
                    System.debug('*******mapEnergyPdlPceContactSave3ToSouscription.get(item)[i].HP_TECH_DedupOrder__c********:***'+mapEnergyPdlPceContactSave3ToSouscription.get(item)[i].HP_TECH_DedupOrder__c);
                    souscriptionsToUpdate.add( mapEnergyPdlPceContactSave3ToSouscription.get(item)[i]);
            }
            }

     }
     System.debug('*******list souscriptionsToUpdate********:***'+souscriptionsToUpdate);

     if(souscriptionsToUpdate.size() >0)  Database.update(souscriptionsToUpdate);
    
}


    public static void populateMap(HP_souscription__c sousc,  Map<String,List<HP_souscription__c>> mapToPopulate){
        Map<String,List<HP_souscription__c>> mapData = new Map<String,List<HP_souscription__c>>();
        System.debug('******* sousc********:***'+sousc);
        System.debug('******* sousc*HP_TECH_FormulaEnergyPDLPCEConcatField__c*******:***'+sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c);

        if(mapToPopulate.containsKey(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c)){
            List<HP_souscription__c> listSouscription = mapToPopulate.get(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c);
            listSouscription.add(sousc);
            mapToPopulate.put(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c, listSouscription);
        }else {
            mapToPopulate.put(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c, new List<HP_souscription__c> { sousc });
        }
    }

}