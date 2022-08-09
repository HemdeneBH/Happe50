/**
 * @Author <Amar Kaillo>
 * @name <SM_Utilities>
 * @CreatedDate <25/11/2019>
 * @Description <Class used to declare dynamic methods used in the projet>
 * @Version <1.0>
 * @reference <Referenced program names>
 * @ModifiedBy <Omar MOHAMAD>
 */

public class SM_Utilities {
      
    /**
     * @author Omar MOHAMAD
     * @date Creation 26/02/2019 
     * @description define a boolean for trigger to fire once
     */
    public static boolean runOnce = true;
    
    
    /**
     * @author Amar KAILLO
     * @date Creation 25/11/2019 
     * @param name Name the record Type
     * @param objectName Name of the object containing the recordTypes
     * @description Retrieve the Id of the recordType identified by his name and the corresponding object
     * @return Id the Id of the recordType identified by his name and the corresponding object
     */
    public static Id getRecordTypeIdByName(String objectName, String name){
        Id resultId = null;
        if (!String.isBlank(name) && !String.isBlank(objectName)){
            resultId =  Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().get(name).getRecordTypeId();
        }
        return resultId;
    }

    public static String getUserProfileName() {
        String profileName = '';
        Id profileId = userinfo.getProfileId();
        List<Profile> listProfile = [SELECT Id, Name 
                                     FROM Profile 
                                     WHERE Id =: profileId];
        
        if (listProfile.size() != 0) {
            profileName = listProfile.get(0).Name;
        }
        
        System.debug('ProfileName'+profileName);

        return profileName;
    }

}