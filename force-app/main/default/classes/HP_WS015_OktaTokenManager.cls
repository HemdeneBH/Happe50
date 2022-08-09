/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 01-31-2022
 * @last modified by  : Hemdene Ben Hammouda
**/

@RestResource(urlMapping='/v1/okta/token/manager/*')
global class HP_WS015_OktaTokenManager {
    private static final String METADATA_NAME = 'HP_Parameter.HP_OKTA_TOKEN';
    private static final String METADATA_LABEL = 'HP OKTA TOKEN';
    private static final String TOKEN_PREFIX = 'Authorization=SSWS ';
    private static final String FIELD_NAME = 'Value__c';
    private static final String TOKEN = 'token';

    @httpPost
    global static void updateOktaToken(){
        RestResponse restResponse = RestContext.response;        
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        Datetime startCall = Datetime.now();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        String body = RestContext.request.requestBody.toString();
        Map<String,String> bodyMap = (Map<String,String>) JSON.deserialize(body, Map<String,String>.class);

        try{
            if(String.isEmpty(body) || String.isEmpty(bodyMap.get(TOKEN))){
                throw new QueryException('Le Token ne doît pas être vide');
            }
            String encryptedData = HP_UTIL_CryptoUtils.encyptData(TOKEN_PREFIX+ bodyMap.get(TOKEN));
            fieldWithValuesMap.put(FIELD_NAME,encryptedData);
            HP_UTIL_MetadataUpdate.handleUpdate(METADATA_NAME, METADATA_LABEL, fieldWithValuesMap);
            restResponse.statusCode = HP_HttpStatus.OK;
            response.code = HP_HttpStatus.OK;
        }
        catch(Exception e){
            response.addError('Erreure', e.getMessage());
            response.code = HP_HttpStatus.BAD_REQUEST;
            restResponse.statusCode = HP_HttpStatus.BAD_REQUEST;
        }
        finally {
            restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
            HP_UTIL_HTTPUtils.saveLogResponse(RestContext.request, restResponse, (Datetime.now().getTime() - startCall.getTime()));
        } 
    }
}