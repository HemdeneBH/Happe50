/**
 * @description       : DM Class for UserRole Object
 * @author            : Mohamed Aamer
 * @last modified on  : 04-20-2022
 * @last modified by  : Mohamed Aamer
**/
public with sharing class SM_DM007_UserRole {
    
    /**
    * @description get user roles by names
    * @author Mohamed Aamer | 04-10-2022 
    * @param names 
    * @return List<UserRole> 
    **/
    public static List<UserRole> retrieveInfosByNames(final List<String> names){
        List<UserRole> userRoles = [
            SELECT Id, Name, ParentRoleId
            FROM UserRole
            WHERE Name IN :names WITH SECURITY_ENFORCED
        ];
        return userRoles;
    }

    /**
    * @description get user roles by parent role IDs
    * @author Mohamed Aamer | 04-20-2022 
    * @param roleIds 
    * @return List<UserRole> 
    **/
    public static List<UserRole> retrieveInfosByParent(final Set<ID> parentRoleIds){
        List<UserRole> userRoles = [
            SELECT Id, Name, ParentRoleId
            FROM UserRole
            WHERE ParentRoleId IN :parentRoleIds AND ParentRoleID != null WITH SECURITY_ENFORCED
        ];
        return userRoles;
    }
}