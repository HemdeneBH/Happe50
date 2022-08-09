/*
*@Author: Georges Mardini
*@Description: Envoyer les cases après la réception du lien d'archivage à Acorus pour le router vers la queue
*@CreatedDate: 2/12/2021
*@LastModified:  19/05/2021
*/

public without sharing class VI_NotifyListCase {
    
    /**
* @author Georges Mardini
* @date 2/12/2021
* @description Envoyer les cases après la réception du lien d'archivage à Acorus pour le router vers la queue
* @param new list case and old case map
* @return void ( called from a trigger)
*/
    
    public static void sendCase(Case[] newList,Map<Id, Case> oldMap,Map<Id, Case> newMap){
        System.debug('### START sendCase ');
        System.debug('### newList : ' + newList);
        System.debug('### oldMap : ' + oldMap);
        List<Case> listcase=new List<Case>();
        Id CaseRTId = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Acquisition_Harmonica').getRecordTypeId();
        for(case cas:newList){
            if(!(cas.Sous_type__c == null || cas.Origin == null) && cas.RecordTypeId == CaseRTId){
                if(cas.Origin.equals('Partner Community')
                   && cas.CPV_E_Lien_CPV__c != null
                   && oldMap.containsKey(cas.Id)  
                   && cas.CPV_E_Lien_CPV__c != oldMap.get(cas.Id).CPV_E_Lien_CPV__c){
                       listcase.add(cas);
                   }   
            }
        }
        System.debug('%%%%%%%listcase '+listcase);
        if(listcase!= null & listcase.size()>0){
            String content = VI_SM026_NotifyAcorusWebhook.jsonContent(newMap);
            VI_SM026_NotifyAcorusWebhook.Webhookcallout('callout:VI_Webhook', content );
        }
    }
}