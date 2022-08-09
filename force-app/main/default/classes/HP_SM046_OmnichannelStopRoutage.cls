/**
 * @File Name          : HP_SM046_OmnichannelStopRoutage.cls
 * @Description        : 

 * @Author             : Antoine Latour
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 11-12-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/11/2020   Antoine Latour     Initial Version
**/
global class HP_SM046_OmnichannelStopRoutage {

    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param List<PendingServiceRouting> psrList 
    **/

    public static void ejectCaseFromOmnichannel(List<PendingServiceRouting> psrList) {
        Set<Id> psrIds = (new Map<Id,PendingServiceRouting>(psrList)).keySet();

        HP_EM037_AgentWork.deleteAgentWorkListFromPendingServiceRoutingIds(psrIds);
        HP_EM043_PendingServiceRouting.deletePendingRoutinService(psrIds);
    }
}