/**
 * @description       : Handle Genesys API Callouts
 * @author            : Mohamed Aamer
 * @last modified on  : 01-18-2022
 * @last modified by  : Mohamed Aamer
 * @version           : 1.0
**/
public with sharing class SM_UTIL001_GenesysCalloutHandler {
    static final String NO_USER_IN_GENESYS = 'noUser';

    /**
    * @description GET Request
    * @author Mohamed Aamer | 01-18-2022 
    * @param url 
    * @return SM_WRP004_GenesysMedia 
    **/
    public static SM_WRP004_GenesysMedia getRequest(String url){
        SM_WRP004_GenesysMedia respWrapper = new SM_WRP004_GenesysMedia();
        HTTPResponse httpResp = new HttpResponse();
        try{
            if(Test.isRunningTest()){
                String body = '{"entities":[{"name":"","joined":true,"id":"test-id"}]}';
                httpResp.setBody(body);
                httpResp.setStatusCode(200);
            } else {
                httpResp = purecloud.SDK.Rest.get(url);
            }
            if (httpResp!= null){
                if (httpResp.getStatusCode() == 200){
                    respWrapper = SM_WRP004_GenesysMedia.parse(httpResp.getBody()); 
                } else{
                    System.debug('Unexpected status : ' +httpResp.getStatusCode());           
                }
            } else {
                System.debug('Unexpected error when calling Genesys API');
            }
        }
        catch (Exception e) {
            System.debug('*** Unexpected error when calling Genesys API : ' + e);
        }
        return respWrapper;
    }

    /**
    * @description POST Request
    * @author Mohamed Aamer | 01-18-2022 
    * @param endPoint 
    * @param params 
    * @return String 
    **/
    public static String postRequest(String endPoint,String params){
        String userID = null;
        HTTPResponse httpResp = new HttpResponse();
        try{
            if(Test.isRunningTest()){
                String body = '{"total":1,"pageCount":1,"pageSize":100,"pageNumber":1,"currentPage":"page1","types":["users"],"results":[{"id":"test-id","name":"test","email":"aa@bb.cc","primaryContactInfo":[{"address":"aa@bb.cc","mediaType":"EMAIL","type":"PRIMARY"}],"addresses":[],"state":"active","username":"dgpuser09@purecloud.engie.fr","version":62}]}';
                httpResp.setBody(body);
                httpResp.setStatusCode(200);
            } else {
                httpResp = purecloud.SDK.Rest.post(endPoint,params);
            }
            if (httpResp!= null){
                if (httpResp.getStatusCode() == 200){
                    SM_WRP003_GenUser respWrapper = SM_WRP003_GenUser.parse(httpResp.getBody());
                    userID = (respWrapper.Results != null) ? respWrapper.Results[0]?.id : NO_USER_IN_GENESYS;
                } else{
                    System.debug('postRequest Unexpected status : ' +httpResp.getStatusCode());           
                }
            } else {
                System.debug('postRequest Unexpected error when calling Genesys API');
            }
        }
        catch (Exception e) {
            System.debug('*** Unexpected error when calling Genesys API : ' + e);
        }
        return userID;
    }

    /**
    * @description PATCH Request
    * @author Mohamed Aamer | 01-18-2022 
    * @param endPoint 
    * @param params 
    * @return Integer 
    **/
    public static Integer patchRequest(String endPoint,String params){
        HTTPResponse httpResp = new HttpResponse();
        try{
            if(Test.isRunningTest()){
                httpResp.setStatusCode(200);
            } else {
                httpResp = purecloud.SDK.Rest.patch(endPoint,params);
            }
            return (httpResp!= null && httpResp.getStatusCode() == 200) ? httpResp.getStatusCode() : null;
        }
        catch (Exception e) {
            System.debug('*** Unexpected error when calling Genesys API : ' + e);
            return null;
        }
    }
}