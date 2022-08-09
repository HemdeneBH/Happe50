/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 03-08-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_RGPD_PurgeDonneesInvocable {
    @InvocableMethod
    public static void sendConfirmationPurge(List<Requests> requestList){
        System.debug('HP_RGPD_PurgeDonneesInvocable.sendConfirmationPurge() | Method Start');
        if(!requestList.isEmpty()){
            RGPD_PurgeDonneesIdentification__e eventObject = requestList[0].eventObject;
            try {
                String messageBody =  convertEventToMessageBody(eventObject);
                sendPurgeConfirmation(messageBody);
            } catch (Exception ex) {
                System.debug('HP_RGPD_PurgeDonneesInvocable.sendConfirmationPurge() | Exception : '+ex.getMessage());
            }   
        }
        System.debug('HP_RGPD_PurgeDonneesInvocable.sendConfirmationPurge() | Method Exit');
    }

    public static String convertEventToMessageBody(RGPD_PurgeDonneesIdentification__e eventObject){
        Map<String, Object> cleObjet = new Map<String, Object>();
        cleObjet.put('idTiers', eventObject.idTiers__c);
        cleObjet.put('noPortefeuilleContrat', eventObject.noPortefeuilleContrat__c);
        cleObjet.put('noContrat', eventObject.noContrat__c);
        cleObjet.put('idPortefeuilleContrat', eventObject.idPortefeuilleContrat__c);
        cleObjet.put('noBp', eventObject.noBp__c);
        cleObjet.put('idContrat', eventObject.idContrat__c);
        Map<String, Object> dataInside = new Map<String, Object>();
        dataInside.put('idDemande', eventObject.idDemande__c);
        dataInside.put('cleObjet', cleObjet);
        Map<String, Object> data = new Map<String, Object>();
        data.put('eventVersion', '1.0');
        data.put('eventSource', 'HAPPE');
        data.put('eventTime', Datetime.now().format('yyyy-MM-dd hh:mm:ss'));
        data.put('eventType', eventObject.eventType__c+'OK');
        data.put('eventSubType', eventObject.eventSubType__c);
        data.put('eventId', eventObject.id);
        data.put('parentEventId', eventObject.eventId__c);
        data.put('data', dataInside);
        Map<String, Object> bodyObj = new Map<String, Object>();
        bodyObj.put('data', data);
        bodyObj.put('partition-key', '1');
        return JSON.serialize(bodyObj);
    } 

    @future(callout = true)
    public static void sendPurgeConfirmation(String messageBody){
        HP_UTIL_HTTPUtils.calloutPut(HP_Constantes.STREAM_PURGE_API_SERVICE, messageBody, null);
        
    } 

    public class Requests {
        @InvocableVariable(label='eventObject' description='La platform event object')
        public RGPD_PurgeDonneesIdentification__e eventObject;
    }
}