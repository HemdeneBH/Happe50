/**
 * @author Sutharsan Pushparajah
 * @date 24/03/2022
 * @description SM_DM200_OctopusSoap - Every Octopus SOAP Webservice class must extends this class to inherit standard behaviour
 */
public inherited sharing class SM_DM200_OctopusSoap extends DM005_SoapRequestService{
    
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
    public SM_DM200_OctopusSoap(String serviceName) {
        super(serviceName);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 24/03/2022
     * @description Handle the response of the WS
     * @param soapRequestInfos wrapper containing request parameters
     * @return void
     */
    public override void parseSoapResponse(WRP004_SoapRequest soapRequestInfos){
        
        if (soapRequestInfos.httpRequestInfos == null){
            throw new OctopusCustomException('No Request Information found : '+soapRequestInfos);
        } else {
            if (soapRequestInfos.httpRequestInfos.theException != null){
                throw new OctopusCustomException(soapRequestInfos.httpRequestInfos.theException);
            }

            if (soapRequestInfos.httpRequestInfos.soapResponse == null){
                throw new OctopusCustomException('No response node found : '+ soapRequestInfos.httpRequestInfos);
            }
        }
    }
}