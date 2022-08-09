/**
 * @author Sutharsan Pushparajah
 * @date 01/04/2022
 * @description SM_DM202_ApigeeRest - Every Apigee REST Webservice class must extends this class to inherit standard behaviour
 */
public inherited sharing class SM_DM202_ApigeeRest extends DM003_HttpRequestService{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 01/04/2022
     * @description ApigeeCustomException - Custom Exception to control WS response from Apigee
     */
    public class ApigeeCustomException extends Exception{}

    /* All Apigee successful respnse code */
    private static final Set<Integer> allowedStatusCode = new Set<Integer>{200, 201, 206};

    /**
     * @author Sutharsan Pushparajah
     * @date 01/04/2022
     * @description Constructor to instanciate the service settings
     * @param serviceName DeveloperName of the HttpRequestService__mdt setting 
     * @return void
     */
    public SM_DM202_ApigeeRest(String serviceName) {
        super(serviceName);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 04/04/2022
     * @description method to callout external service
     * @param httpRequestInfos wrapper containing request/response infos 
     * @return void
     */
    public override void sendRequest(WRP003_HttpRequest httpRequestInfos){
        Map<String, String> apigeeHeaders = new Map<String, String>{'Content-Length' => '0', 'X-correlation-id' => MP_AP13_GuidUtil.NewGuid()};
        httpRequestInfos.header.putAll(apigeeHeaders);
        super.sendRequest(httpRequestInfos);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 01/04/2022
     * @description Handle the response of the WS
     * @param httpRequestInfos wrapper containing request parameters
     * @return void
     */
    public override void parseHttpResponse(WRP003_HttpRequest httpRequestInfos){
        
        if (httpRequestInfos.theException != null){
            throw new ApigeeCustomException(httpRequestInfos.theException);
        }

        if (!allowedStatusCode.contains(httpRequestInfos.httpResponse.getStatusCode())){
            throw new ApigeeCustomException(httpRequestInfos.httpResponse.getBody());
        }
    }
}