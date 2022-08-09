/**
@Author Dallel Riadh
@name SM_StreampurgeApiService
@CreatedDate 25/06/2021
@Description appel de l'API protected-streampurge pour les contacts impacté par GDPR
@Version 1.0
@reference <Referenced program names>
@ModifiedBy Dallel Riadh
*/

global class SM_StreampurgeApiService {

    public static Map<String, String> additionalHeaders = new Map<String, String>{
        'x-apigw-api-id' => System.Label.SM_CL47_xApigwApiId
    };

    public static void callStreampurgeApi(String bodyMessage) {

        HttpResponse httpResponse = getResponse(bodyMessage);
        system.debug('@@ httpResponse '+httpResponse);
        
    }
    
    public static HttpResponse getResponse(String bodyMessage) {

        HttpResponse httpResp = CalloutManager.sendRequest('Protected_Streampurge', null, 'PUT', CalloutManager.Scope.READWRITE,'test',additionalHeaders);
        if (CalloutManager.httpResponseFailureDetected(httpResp)) {
            try{
                // tracer les erreurs streampurge sur l'objet SyncEventLog__c
                insert new SyncEventLog__c (flux__c = 'protected_Streampurge', name='GDPR', inputdat__c = httpResp.getBody());
            } catch (DMLException e){
                System.debug('Erreur technique lors de l\'appel Streampurge');
            }
            system.debug('## [streampurge] error occured when sending data ##');
            return null;
        }
        return httpResp;
    }
}