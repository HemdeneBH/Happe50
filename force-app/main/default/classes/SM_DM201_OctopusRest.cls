/**
 * @author Sutharsan Pushparajah
 * @date 24/03/2022
 * @description SM_DM201_OctopusRest - Every Octopus REST Webservice class must extends this class to inherit standard behaviour
 */
public inherited sharing class SM_DM201_OctopusRest extends DM003_HttpRequestService{
    
    /**
     * @author Sutharsan Pushparajah
     * @date 24/03/2022
     * @description OctopusCustomException - Custom Exception to control WS response from Octopus
     */
    public class OctopusCustomException extends Exception{}

    /**
     * @author Sutharsan Pushparajah
     * @date 24/03/2022
     * @description Constructor to instanciate the service settings
     * @param serviceName DeveloperName of the HttpRequestService__mdt setting 
     * @return void
     */
    public SM_DM201_OctopusRest(String serviceName) {
        super(serviceName);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 24/03/2022
     * @description Handle the response of the WS
     * @param httpRequestInfos wrapper containing request parameters
     * @return void
     */
    public override void parseHttpResponse(WRP003_HttpRequest httpRequestInfos){
        
        if (httpRequestInfos.theException != null){
            throw new OctopusCustomException(httpRequestInfos.theException);
        }

        try {
            Dom.Document responseDoc = httpRequestInfos.httpResponse.getBodyDocument();
            Dom.XmlNode rootNode = responseDoc.getRootElement();
        } catch (Exception exp){
            throw new OctopusCustomException('Error in response node : '+ httpRequestInfos);
        }
    }
}