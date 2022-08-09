/**
 * @description       : DM Class for User Object
 * @author            : Mohamed Aamer
 * @last modified on  : 04-20-2022
 * @last modified by  : Mohamed Aamer
**/
public inherited sharing class SM_DM006_User {
    
    /**
    * @description get users by ID
    * @author Mohamed Aamer | 04-10-2022 
    * @param userIds 
    * @return List<User>
    **/
    public static List<User> retrieveInfosByIds(final Set<ID> userIds){
        List<User> users = [
            SELECT UserRoleId, UserRole.Name, LastName, Trigramme_Site__c, Trigramme_Presta__c 
            FROM User
            WHERE Id IN :userIds WITH SECURITY_ENFORCED
        ];
        return users;
    }

    /**
    * @description get Active Users by Trigramme_Presta__c & Trigramme_Site__c fields
    * @author Mohamed Aamer | 04-10-2022 
    * @param trigPresta
    * @param trigSite 
    * @return List<User> 
    **/
    public static List<User> retrieveInfosByTrigramme(final String trigPresta, final String trigSite){
        List<User> users = [
            SELECT Id, FirstName, LastName, Name, UserRoleId, UserRole.Name, Username, Trigramme_Site__c, Trigramme_Presta__c, IsActive
            FROM User
            WHERE Trigramme_Presta__c =:trigPresta AND Trigramme_Site__c=:trigSite
            AND IsActive = true
            WITH SECURITY_ENFORCED
            ORDER BY LastName ASC
        ];
        return users;
    }

    /**
    * @description get users by usernames
    * @author Mohamed Aamer | 04-10-2022 
    * @param usernames 
    * @return List<User> 
    **/
    public static List<User> retrieveInfosByUsernames(final List<String> usernames){
        List<User> users = [
            SELECT Id, FirstName, LastName, Name, Username, UserRoleId, UserRole.Name, Trigramme_Site__c, Trigramme_Presta__c 
            FROM User
            WHERE Username IN :usernames
            WITH SECURITY_ENFORCED
        ];
        return users;
    }

}