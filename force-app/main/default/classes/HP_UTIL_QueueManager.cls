/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   18-11-2020   Antoine Latour   Initial Version
**/

public with sharing class HP_UTIL_QueueManager {

    private static Map<String, Group> queueMapByName = null;

    /**
    * @description Génère la Map des queues happ-e par developername de la queue
    * @author Antoine Latour | 18-11-2020 
    * @return Map<String, Group> 
    **/
    public static Map<String, Group> getQueueMapByName() {
        if(queueMapByName == null) {
            queueMapByName = new Map<String, Group>();
            List<Group> queueList = [SELECT Id, DeveloperName FROM GROUP WHERE Type = 'Queue'];

            for(Group queue : queueList) {
                if(queue.DeveloperName.startsWith('HP')) {
                    queueMapByName.put(queue.DeveloperName, queue);
                }
            }
        }

        return queueMapByName;
    }


    /**
    * @description Génère la Map des queues happ-e par Id de la queue
    * @author Antoine Latour | 18-11-2020 
    * @return Map<Id, Group> 
    **/
    public static Map<Id, Group> getQueueMapById() {
        if(queueMapByName == null) {
            queueMapByName = getQueueMapByName();
        }

        Map<Id, Group> queueMapById = new Map<Id, Group>();
        for(Group queue : queueMapByName.values()) {
            queueMapById.put(queue.Id, queue);
        }

        return queueMapById;
    }

    /**
    * @description Renvoie l'ID d'une queue par rapport à sont nom
    * @author Antoine Latour | 18-11-2020 
    * @param String queueName 
    * @return Id 
    **/
    @AuraEnabled(cacheable = true)
    public static Id getQueueIdByName(String queueName) {
        if(queueMapByName == null) {
            queueMapByName = getQueueMapByName();
        }
        return queueMapByName.get(queueName).Id;
    }

}