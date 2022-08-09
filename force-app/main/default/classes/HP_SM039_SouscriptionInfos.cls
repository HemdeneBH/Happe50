/**
 * @File Name          : HP_SM039_SouscriptionInfos.cls
 * @Description        : 
 * @Author             : Antoine Latour
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 03-03-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    25/09/2020   Antoine Latour     Initial Version
**/
public with sharing class HP_SM039_SouscriptionInfos {
    
    public static HP_WRP038_SouscritpionStatus.Response getSouscriptionsInfo(HP_WRP038_SouscritpionStatus.Request req){
        List<HP_Souscription__c> souscriptionList   = HP_EM005_Souscription.getSouscriptionsInfos(req.souscriptionIdList);
        HP_WRP038_SouscritpionStatus.Response response      = new HP_WRP038_SouscritpionStatus.Response(souscriptionList);
        return response;
    }

    public static HP_WRP039_Devis.Response getDevis(HP_WRP039_Devis.Request req){
        List<HP_Souscription__c> souscriptionList   = HP_EM005_Souscription.getDevis(req.digitalId);
        if(souscriptionList != null && souscriptionList.size() == 1 && souscriptionList[0].HP_Statut__c != 'SAVE_1'){
            throw  new HP_WRP039_Devis.APIException();
        }
        HP_WRP039_Devis.Response response      = new HP_WRP039_Devis.Response(souscriptionList);
        return response;
    } 
}