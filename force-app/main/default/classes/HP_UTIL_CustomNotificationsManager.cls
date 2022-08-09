/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   12-03-2021   Antoine Latour   Initial Version
**/
public with sharing class HP_UTIL_CustomNotificationsManager {

    private static Map<String, CustomNotificationType> customNotificationTypeMap = null;

    /**
    * @description Génère la Map des type de notification custom happ-e par developername
    * @author Antoine Latour | 12-03-2020 
    * @return Map<String, CustomNotificationType> 
    **/
    public static Map<String, CustomNotificationType> getCustomNotificationTypeMap() {
        if(customNotificationTypeMap == null) {
            customNotificationTypeMap = new Map<String, CustomNotificationType>();
            List<CustomNotificationType> customNotificationTypeList = [SELECT Id, DeveloperName FROM CustomNotificationType];
            for(CustomNotificationType customNotificationType : customNotificationTypeList) {
                if(customNotificationType.DeveloperName.startsWith('HP')) {
                    customNotificationTypeMap.put(customNotificationType.DeveloperName, customNotificationType);
                }
            }
        }

        return customNotificationTypeMap;
    }

    public static void sendNotificationCaseOwnerChange(Set<String> recipients, Id target) {
        Map<String, CustomNotificationType> notificationTypeMap = HP_UTIL_CustomNotificationsManager.getCustomNotificationTypeMap();
        List<String> constantes = new List<String>{'HP_NotificationCaseOwnerChange'};
        Map<String, Map<object,object>> mapConstantes = HP_UTIL_MetadataManager.getCodification(constantes);
        final String titre = (String) mapConstantes.get('HP_NotificationCaseOwnerChange').get('titre');
        final String message = (String) mapConstantes.get('HP_NotificationCaseOwnerChange').get('message');
        System.debug('titre notif : ' + titre);
        System.debug('titre message : ' + message);
        try {
        	Messaging.CustomNotification notification = new Messaging.CustomNotification();    
       		notification.setTitle(titre);
        	notification.setBody(message);
        	notification.setNotificationTypeId(notificationTypeMap.get('HP_CaseOwnerChange').Id);
        	notification.setTargetId(target);
            notification.send(recipients);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
}