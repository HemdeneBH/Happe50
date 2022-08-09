/**
 * @description       : 
 * @author            : Antoine Latour
 * @group             : 
 * @last modified on  : 11-12-2020
 * @last modified by  : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-12-2020   Antoine Latour   Initial Version
**/
public with sharing  class HP_EM043_PendingServiceRouting {

    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param Set<Id> pendingServiceRoutingIds 
    **/

    public static void deletePendingRoutinService(Set<Id> pendingServiceRoutingIds) {
        if(pendingServiceRoutingIds.isEmpty()) {
            return;
        }

        List<PendingServiceRouting> psrToDelete = [SELECT Id FROM PendingServiceRouting WHERE Id IN : pendingServiceRoutingIds];



        if(psrToDelete.size() > 0) {
            delete psrToDelete;
        }
    }
}