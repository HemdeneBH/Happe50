/**
 * @description       : Classe Helper pour récupérer la hierachie des rôles
 * @author            : Mohamed Aamer
 * @last modified on  : 04-20-2022
 * @last modified by  : Mohamed Aamer
**/
public inherited sharing class SM_UTIL002_RoleHierarchyHelper {
    
    /**
    * @description get all sub role names
    * @author Mohamed Aamer | 04-20-2022 
    * @param roleIds 
    * @return List<String> 
    **/
    public static List<String> getAllSubRoleNames(Set<ID> roleIds) {
        List<String> currentRoleNames = new List<String>();
        Set<ID> currentRoleIds = new Set<ID>();
        List<UserRole> subRoles = SM_DM007_UserRole.retrieveInfosByParent(roleIds);

        for(UserRole userRole :subRoles){
            currentRoleIds.add(userRole.Id);
            currentRoleNames.add(userRole.Name);
        }

        if(currentRoleNames.size() > 0){
            currentRoleNames.addAll(getAllSubRoleNames(currentRoleIds));
        }

        return currentRoleNames;
    }
}