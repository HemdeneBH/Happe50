/**
 * @description       : 
 * @author            : Antoine Latour
 * @group             : 
 * @last modified on  : 01-19-2022
 * @last modified by  : Hemdene Ben Hammouda
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   11-12-2020   Antoine Latour   Initial Version
**/
public with sharing  class HP_EM037_AgentWork {
    
    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param String userId 
    * @param String status 
    * @return List<AgentWork> 
    **/
    public static List <AgentWork> getAgentWork(String userId, String status){
       return [SELECT Id, Status,UserId, WorkItemId FROM AgentWork WHERE (Status=:status and UserId =:userId) ];
    }

    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param Set<Id> pendingServiceRoutingIds 
    **/
    public static void deleteAgentWorkListFromPendingServiceRoutingIds(Set<Id> pendingServiceRoutingIds) {
        if(pendingServiceRoutingIds.isEmpty()) {
            return;
        }

        Set<String> openStatusSet = new Set<String>{'Assigned','Opened'};
        List<AgentWork> existingAgentWork = [SELECT Id, Status FROM AgentWork WHERE PendingServiceRoutingId IN : pendingServiceRoutingIds AND Status NOT IN :openStatusSet];

        if(existingAgentWork.size() > 0) {
            delete existingAgentWork;
        }
    }


}