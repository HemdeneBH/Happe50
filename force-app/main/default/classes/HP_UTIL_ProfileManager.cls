/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-08-2020
 * @last modified by  : Vincent Albiser
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   09-29-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class HP_UTIL_ProfileManager {

    private static Boolean isHappe = null;

    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @return Boolean 
    **/
    public static Boolean isHappeProfile() {
        try{
            if(isHappe != null){
                return isHappe;
            }
            String ProfileId = UserInfo.getProfileId();
            Profile prof = [select Name from Profile where Id = :ProfileId];
            isHappe = prof.Name.startsWith('HP_') || prof.Name.equals('System Administrator');            
            return isHappe;
        } catch(Exception e){
            isHappe = false;
            return isHappe;
        }
        
    }

    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @return String 
    **/
    public static String getCurrentUserProfileName() {
        String profileId = UserInfo.getProfileId();
        if(!String.isBlank(profileId)) {
        	Profile prof = [select Name from Profile where Id = :profileId];
        	return prof?.Name;           
        }
        return null;
    }

    /**
    * @description 
    * @author Antoine Latour | 22-03-2021 
    * @param String idOwner 
    * @return String 
    **/
    public static String getOwnerProfile(String idOwner) {
        User userOwner = [SELECT Profile.Name FROM User WHERE Id = :idOwner];
        return userOwner.Profile.Name;
    }

    /**
    * @description 
    * @author Antoine Latour | 06-04-2021 
    * @param Set<Id> usersId 
    * @return Map<Id, User> 
    **/
    public static Map<Id, User> getUsersProfiles(Set<Id> usersId) {
        return new Map<Id, User>([ Select Id, Name, ProfileId, Profile.Name From User where Id IN: usersId ]);
    }
}