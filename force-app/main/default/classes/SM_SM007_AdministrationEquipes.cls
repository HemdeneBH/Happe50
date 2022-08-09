/**
 * @description       : Classe Service pour le module composition des équipe
 * @author            : Mohamed Aamer
 * @last modified on  : 04-20-2022
 * @last modified by  : Mohamed Aamer
**/
public inherited sharing class SM_SM007_AdministrationEquipes {

    public static Map<String,Object> outputMap = new Map<String,Object>();
    private static List<User> allResponsables = new List<User>();
    private static List<User> allConseillers = new List<User>();
    private static List<User> allNonAssignes = new List<User>();
    private static Map<String,Map<String,List<User>>> equipesMap = new Map<String,Map<String,List<User>>>();

    /**
    * @description  Méthode permettant de récupérer tous les utilisateurs appartenant au site de l'utilisateur connecté
    * @author Mohamed Aamer | 04-13-2022 
    * @param userIds 
    * @param trigrammePresta 
    * @param trigrammeSite 
    * @param userSiteName 
    * @return Map<String, Object> 
    **/
    public static Map<String,Object> getEquipes(Set<ID> userRoleIds, String trigrammePresta, String trigrammeSite, String userSiteName){
        /* Initiation de la map avec les équipes du site */
        List<String> subRoleNames = SM_UTIL002_RoleHierarchyHelper.getAllSubRoleNames(userRoleIds);
        for (String subRoleName : subRoleNames) {
            String nomEquipe = getNomEquipe(subRoleName);
            if (subRoleName.contains('Responsable')) {
                handleEquipeMap(nomEquipe,null,'responsablesEquipe');
            }
            //Contruire la liste des conseillers
            else if (subRoleName.contains('Conseiller')){
                String nomEquipeCons = 'Equipe_'+nomEquipe;
                handleEquipeMap(nomEquipeCons,null,'conseillersEquipe');
            }
        }
        /* Initiation END */

        //Récupération de tous les users appartenant au site 
        List<User> allSiteUsers = SM_DM006_User.retrieveInfosByTrigramme(trigrammePresta, trigrammeSite);

        //Alimentation de la map avec les responsables/conseillers da chaque équipe
        for (User user : allSiteUsers) {
            //Affecter le user sans role à la liste allNonAssignes
            if(user.UserRole == null) {
                allNonAssignes.add(user);
            } else {
                String roleName = user.UserRole.Name;
                String nomEquipe = getNomEquipe(roleName);
                
                //Contruire la liste des responsables
                if (roleName.contains('Responsable')) {
                    handleEquipeMap(nomEquipe,user,'responsablesEquipe');
                    allResponsables.add(user);
                }
                //Contruire la liste des conseillers
                else if (roleName.contains('Conseiller')){
                    String nomEquipeCons = 'Equipe_'+nomEquipe;
                    handleEquipeMap(nomEquipeCons,user,'conseillersEquipe'); 
                    allConseillers.add(user);
                }
            }
        }
        outputMap.put('equipes', equipesMap);
        outputMap.put('allResponsables', allResponsables);
        outputMap.put('allConseillers', allConseillers);
        outputMap.put('allNonAssignes', allNonAssignes);
        outputMap.put('site', userSiteName);
        return outputMap;
    }

    /**
    * @description get nom equipe by splitting the role name
    * @author Mohamed Aamer | 04-20-2022 
    * @param roleName 
    * @return String 
    **/
    private static String getNomEquipe(String roleName){
        List<String> splitRoleNameList = roleName.split('_', 4);
        return splitRoleNameList.get(splitRoleNameList.size() - 1);
    }

    /**
    * @description construire la map des équipes
    * @author Mohamed Aamer | 04-13-2022 
    * @param nomEquipe 
    * @param user 
    * @param mapKey 
    **/
    private static void handleEquipeMap(String nomEquipe, User user, String mapKey) {
        if (equipesMap.containsKey(nomEquipe)) {
            //mapValue = Map contenant la liste des responsables et les conseillers de l'équipe
            Map<String,List<User>> mapValue = equipesMap.get(nomEquipe);
            //typeEquipe = la liste des responsables de l'équipe ou la liste des conseillers de l'équipe
            List<User> typeEquipe = mapValue.get(mapKey);
            if (typeEquipe != null) {
                typeEquipe.add(user);
                //Assosier à chaque équipe deux listes: responsables et conseillers
                equipesMap.put(nomEquipe, mapValue);
            } else {
                mapValue.put(mapKey, new List<User>{user});
                equipesMap.put(nomEquipe, mapValue);
            }
        } else {
            Map<String,List<User>> mapTypeEquipe = new Map<String,List<User>>();
            mapTypeEquipe.put(mapKey, new List<User>{user});
            equipesMap.put(nomEquipe, mapTypeEquipe);
        }
    }

    public static void updateUsers(String json){

        try {
            SM_WRP005_AdministrationEquipes wrapper = SM_WRP005_AdministrationEquipes.parse(json);

            List<String> oldUsernames = new List<String>();
            List<String> newUsernames = new List<String>();
            List<String> newRoles = new List<String>{wrapper.role};

            for (Integer i=0;i<wrapper.newUsers.size();i++) {
                newUsernames.add(wrapper.newUsers.get(i).value);
            }
            for (Integer i=0;i<wrapper.oldUsers.size();i++) {
                oldUsernames.add(wrapper.oldUsers.get(i).value);
            }

            List<User> userToUpdate = new List<User>();
            //Récupérer les nouveaux users pour leurs attribuer le nouveau rôle
            List<User> newUsers = SM_DM006_User.retrieveInfosByUsernames(newUsernames);
            
            //Récupérer les anciens users pour leurs enlever le rôle
            List<User> oldUsers = SM_DM006_User.retrieveInfosByUsernames(oldUsernames);
                
            //Récupérer le role concerné
            List<UserRole> roles = SM_DM007_UserRole.retrieveInfosByNames(newRoles);
            UserRole newRole = roles.get(0);
    
                //Affectation du nouveau rôle
            for (User  newUsr : newUsers) {
                newUsr.UserRoleId = newRole.Id;
                userToUpdate.add(newUsr);
            }
            //Suppression du rôle aux anciens users
            for (User oldUsr : oldUsers) {
                oldUsr.UserRoleId = null;
                userToUpdate.add(oldUsr);
            }
            
            update userToUpdate;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }
}