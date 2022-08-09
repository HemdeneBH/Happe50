/**
 * @description       : Classe controlleur pour gérer la composition des équipes
 * @author            : Mohamed Aamer
 * @last modified on  : 04-20-2022
 * @last modified by  : Mohamed Aamer
**/
public with sharing class SM_CTRL011_AdministrationEquipes {

    /**
    * @description Méthode permettant de récupérer tous les utilisateurs appartenant au site de l'utilisateur connecté
    * @author Mohamed Aamer | 04-13-2022 
    * @return Map<String, Object> 
    **/
    @AuraEnabled(cacheable=true)
    public static Map<String,Object> getEquipes(){
        
        try {
            String userId=UserInfo.getUserId();
            String userRoleId = UserInfo.getUserRoleId();
            Set<ID> userIds = new Set<ID>{userId};
            Set<ID> userRoleIds = new Set<ID>{userRoleId};
            //Get Connected User
            List<User> users = SM_DM006_User.retrieveInfosByIds(userIds);
            User connectedUser = users.get(0);
            String trigrammeSite = connectedUser.Trigramme_Site__c;
            String trigrammePresta = connectedUser.Trigramme_Presta__c;
            String userSiteName = trigrammePresta+'_'+trigrammeSite;

            return SM_SM007_AdministrationEquipes.getEquipes(userRoleIds, trigrammePresta, trigrammeSite, userSiteName);
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * @description méthode pour mettre à jour les roles des conseillers/superviseurs
    * @author Mohamed Aamer | 04-13-2022 
    * @param json 
    **/
    @AuraEnabled
    public static void updateUsers(String json){

        SM_SM007_AdministrationEquipes.updateUsers(json);
    }
}