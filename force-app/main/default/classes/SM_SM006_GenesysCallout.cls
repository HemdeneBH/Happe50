/**
 * @description       : Service Class to call Genesys APIs
 * @author            : Mohamed Aamer
 * @last modified on  : 01-18-2022
 * @last modified by  : Mohamed Aamer
 * @version           : 1.0
**/
public with sharing class SM_SM006_GenesysCallout {

    static final Integer PAGE_SIZE_SEARCH_USER = 100;
    static final String QUERY_TYPE_SEARCH_USER = 'QUERY_STRING';
    static final List<String> QUERY_FIELD_SEARCH_USER = new List<String>{'email'};
    static final String GENESYS_SEARCH = 'search';

    /**
    * @description API Call to get Genesys User's ID
    * @author Mohamed Aamer | 01-18-2022 
    * @param baseEndpoint 
    * @param federationId 
    * @return String 
    **/
    public static String getGenesysUserId(String baseEndpoint, String federationId){
        String queryValue = federationId;
        String endPoint = baseEndpoint+GENESYS_SEARCH;
        Map<String,Object>query=new Map<String,Object>{'fields'=>QUERY_FIELD_SEARCH_USER,'value'=>queryValue,'type' =>QUERY_TYPE_SEARCH_USER};
        Map<String,Object>params=new Map<String,Object>{'query' => new List<Object>{ query },'pageSize' => PAGE_SIZE_SEARCH_USER};
        String paramsString = JSON.serialize(params);
        return SM_UTIL001_GenesysCalloutHandler.postRequest(endpoint,paramsString);
    }

    /**
    * @description API Call to get All Genesys Medias
    * @author Mohamed Aamer | 01-18-2022 
    * @param baseEndpoint 
    * @param genUserId 
    * @param pageSize 
    * @return SM_WRP004_GenesysMedia 
    **/
    public static SM_WRP004_GenesysMedia getGenesysMedia(String baseEndpoint,String genUserId,String pageSize){
        String url = baseEndpoint+genUserId+'/queues?pageSize='+pageSize;
        return SM_UTIL001_GenesysCalloutHandler.getRequest(url);
    }

    /**
    * @description API Call to update Genesys Medias
    * @author Mohamed Aamer | 01-18-2022 
    * @param baseEndpoint 
    * @param genUserId 
    * @param objMedias 
    * @return Integer 
    **/
    public static Integer patchGenesysMedia(String baseEndpoint, string genUserId, Object objMedias){
        String endpoint = baseEndpoint+genUserId+'/queues';
        String params = JSON.serialize(objMedias);
        return SM_UTIL001_GenesysCalloutHandler.patchRequest(endpoint,params);
    }
}