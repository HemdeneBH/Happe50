/**
 * @description       : Genesys Callout Controller to choose the media type from Smile UI
 * @author            : Mohamed Aamer
 * @last modified on  : 02-02-2022
 * @last modified by  : Mohamed Aamer
 * @version           : 1.0
**/
public with sharing class  SM_CTRL009_MediaGenesys {

    static final String GENESYS_REQUEST_SERVICE = 'GENESYS';

    /**
    * @description get the mail of the current user
    * @author Mohamed Aamer | 12-16-2021 
    * @return string 
    **/
    @AuraEnabled(cacheable=true)
    public static string getFederationId() {
        String userId = UserInfo.getUserId();
        return [Select FederationIdentifier from User WHERE Id=:userId]?.FederationIdentifier;
    }

    /**
    * @description Get Media Type from custom metadatype
    * @author Mohamed Aamer | 12-16-2021 
    * @return List<SM_Media_Queue__mdt> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<SM_Media_Queue__mdt> getAllowedMediaTypes() {
        return SM_Media_Queue__mdt.getAll().values();
    }

    /**
    * @description Get Config of Media
    * @author Mohamed Aamer | 12-21-2021 
    * @return List<HttpRequestService__mdt> 
    **/
    @AuraEnabled(cacheable=true)
    public static HttpRequestService__mdt getMediaConfig(){
        return HttpRequestService__mdt.getInstance(GENESYS_REQUEST_SERVICE);
    }

    /**
    * @description Genesys Callout to get User's ID
    * @author Mohamed Aamer | 12-21-2021 
    * @param String baseEndpoint 
    * @return String 
    **/
    @AuraEnabled(cacheable=false)
    public static String getGenesysUserId(String baseEndpoint, String federationId){
        String userID = SM_SM006_GenesysCallout.getGenesysUserId(baseEndpoint,federationId);
        return userID;
    }

    
    /**
    * @description call Genesys Api to get User's Medias
    * @author Mohamed Aamer | 12-21-2021 
    * @param String baseEndpoint 
    * @param string genUserId 
    * @param string pageSize 
    * @return SM_WRP004_GenesysMedia 
    **/
    @AuraEnabled(cacheable=false)
    public static SM_WRP004_GenesysMedia getMedias(String baseEndpoint, string genUserId,string pageSize){
        SM_WRP004_GenesysMedia respWrapper = SM_SM006_GenesysCallout.getGenesysMedia(baseEndpoint,genUserId,pageSize);
        return respWrapper;
    }
    
    
    /**
    * @description call Genesys Api to update User's Medias
    * @author Mohamed Aamer | 12-21-2021 
    * @param String baseEndpoint 
    * @param string genUserId 
    * @param Object objMedias 
    * @return Integer 
    **/
    @AuraEnabled(cacheable=false)
    public static  Integer patchMedias(String baseEndpoint, string genUserId, Object objMedias){
        Integer statusCode = SM_SM006_GenesysCallout.patchGenesysMedia(baseEndpoint,genUserId,objMedias);
        return statusCode;
    }

}