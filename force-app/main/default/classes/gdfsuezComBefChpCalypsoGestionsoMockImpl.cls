@isTest
public class gdfsuezComBefChpCalypsoGestionsoMockImpl implements WebServiceMock {
    
    public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) {
       
		

		if(request instanceOf gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionService_element) {
			response.put( 'response_x', new gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceResponse_element());
		}
		
	}

}