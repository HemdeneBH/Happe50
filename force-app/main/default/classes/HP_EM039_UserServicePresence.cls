public with sharing  class HP_EM039_UserServicePresence {

    public static List <UserServicePresence> getUserServicePresenceMap(Set <String> userIds, Date selectedDate){
        return [Select Id, ServicePresenceStatus.DeveloperName, StatusStartDate,  StatusEndDate, UserId from UserServicePresence where (UserId in :userIds and DAY_ONLY(StatusStartDate) =: selectedDate and DAY_ONLY(StatusEndDate) =: selectedDate) ];
     }

}