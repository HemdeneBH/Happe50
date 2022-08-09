/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 08-13-2021
 * @last modified by  : Badr Eddine Belkarchi
**/
@RestResource(urlMapping='/v1/questionFAQ/*')
global class HP_WS014_QuestionFAQ {
    
    @HttpPost
	global static void questionFAQCreation() {

        Datetime startCall = Datetime.now();
        HP_WRP043_QuestionFAQ.Request req;
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        RestResponse restResponse = RestContext.response;        

        try{
            String body = RestContext.request.requestBody.toString();
            req = (HP_WRP043_QuestionFAQ.Request) JSON.deserialize(body, HP_WRP043_QuestionFAQ.Request.class);
            HP_SM066_QuestionFAQAPI.questionsFAQCreation(req, response);
        }
        catch(Exception e){
            response.addError('SF Standard', e.getMessage());
            response.code = HP_HttpStatus.BAD_REQUEST;
        }
        finally {
			restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
			HP_UTIL_HTTPUtils.saveLogResponse(RestContext.request, restResponse, (Datetime.now().getTime() - startCall.getTime()));
		}
    }
}