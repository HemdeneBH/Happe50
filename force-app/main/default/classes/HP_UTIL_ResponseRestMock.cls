/**
* @author Slimen Belhaj Ali
* @date 13/12/2019
* @description Classe qui permet de faire un multi Mock Web service
*/

@isTest
global  class HP_UTIL_ResponseRestMock implements HttpCalloutMock {

    //variable pour encapsuler les configurations des reponses des WS
    private Map<String, ParameterMockWrapper> mockWSMap;

    /**
    * @author Slimene Belhaj Ali
    * @date 13/12/2019
    * @description constructeur qui permet d'initialiser les config
    * @param mockWSMap, Les configs des WS
    */
    global HP_UTIL_ResponseRestMock(Map<String, ParameterMockWrapper> mockWSMap) {
        this.mockWSMap = mockWSMap;
    }

    /**
    * @author Slimene Belhaj Ali
    * @date 13/12/2019
    * @description Methode à implémenter qui permet de définir la réponse de WS en fonction de endpoint
    * @param request, variable contient tous le context de requete
    */
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();

        for(String endPoint : mockWSMap.keySet()) {
            if(request.getEndpoint().contains(endPoint)) {
                ParameterMockWrapper currentMock = mockWSMap.get(endPoint);

                if(currentMock.resourceBodyName != null) {
                    response.setBody(HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(currentMock.resourceBodyName));
                }

				else if(currentMock.resourceBody != null) {
                    response.setBody(currentMock.resourceBody);
                }
                response.setStatusCode(currentMock.status);
                for(String header : currentMock.headerMap.keySet()) {
                    response.setHeader(header,  currentMock.headerMap.get(header));
                }
                break;
            }
        }

        return response;
    }

    /**
    * @author Slimen Belhaj Ali
    * @date 13/12/2019
    * @description Classe qui d'encapsuler la configuration d'un WS
    */
    global class ParameterMockWrapper {
        String resourceBodyName;
		String resourceBody;
        Integer status;
        Map<String, String> headerMap;


        global ParameterMockWrapper(Integer status, String resourceBodyName, Map<String, String> headerMap) {
            this.status = status;
            this.resourceBodyName = resourceBodyName;
            this.headerMap = headerMap;
        }
		global ParameterMockWrapper(Integer status, String resourceBodyName,String resourceBody, Map<String, String> headerMap) {
            this.status = status;
            this.resourceBodyName = resourceBodyName;
			this.resourceBody = resourceBody;
            this.headerMap = headerMap;
        }
    }
}