@isTest
public class MockHttpResponseGenerator implements HttpCalloutMock
{
	public String context;

	public MockHttpResponseGenerator (String context){
		this.context = context;
	}
    public HTTPResponse respond(HTTPRequest req)
    {
    	HttpResponse res = new HttpResponse();
    	if(context=='MPConsentement'){
    		if(req.getMethod()=='GET'){
    			res.setBody('{"_data":[{"id":"4d0cc6a9-2c63-42e5-954e-d41702ac2d17","idPersonne":123,"idQuestionnaire":1,"idQuestion":1,"consent":true},{"id":"4d0cc6a9-2c63-42e5-954e-d41702ac2d17","idPersonne":123,"idQuestionnaire":1,"idQuestion":2,"consent":true},{"id":"4d0cc6a9-2c63-42e5-954e-d41702ac2d17","idPersonne":123,"idQuestionnaire":1,"idQuestion":3,"consent":true}]}');
    			res.setStatusCode(200);
    		}else{
    			res.setStatusCode(201);
    		}
    	}else{
    		 res.setHeader('Content-Type', 'application/xml');
        	res.setBody('Target URL');
        	res.setStatusCode(200);
        	System.assertEquals('POST', req.getMethod());
    	}

        
       

        return res;
    }
}