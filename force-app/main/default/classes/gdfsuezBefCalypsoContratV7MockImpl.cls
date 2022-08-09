@isTest
public class gdfsuezBefCalypsoContratV7MockImpl implements WebServiceMock {
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
       
		System.debug(LoggingLevel.INFO, 'gdfsuezBefCalypsoContratV7MockImpl.doInvoke() - ' +
			'\n request: ' + request +
			'\n response: ' + response +
			'\n endpoint: ' + endpoint +
			'\n soapAction: ' + soapAction +
			'\n requestName: ' + requestName +
			'\n responseNS: ' + responseNS +
			'\n responseName: ' + responseName +
			'\n responseType: ' + responseType);

		if(request instanceOf gdfsuezBefCalypsoContratV7.rechercherContrat_element) {
			response.put( 'response_x', new gdfsuezBefCalypsoContratV7.rechercherContratResponse_element());
		}
	}
}