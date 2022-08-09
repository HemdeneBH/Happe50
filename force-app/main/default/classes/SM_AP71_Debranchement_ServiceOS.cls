/*******************************************************************************************************
* @description: Appeler le service crypter Param pour le debranchement via omniscript
* @return the token
* @date: 2019-03-08 
* @author: Omar Mohamad
********************************************************************************************************/
global class SM_AP71_Debranchement_ServiceOS implements vlocity_cmt.VlocityOpenInterface {

    
    /*@Author: OMH
	*@Description : gestion des appels
	*@CreatedDate : 04/07/2019
	*LastModified: OMH 04/07/2019
	*/
	global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

		if (methodName.equals('getChaineCryptee')) {
			try {
				getChaineCryptee(inputMap, outMap, options);
				// your implementation, use outMap to send response back to OmniScript
			} catch (Exception e) {
				system.debug(e);
				return false;
			}
        }
        
        return true;
    }
    
    public static void getChaineCryptee(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
       
        String ContactIdValue ;
         String contactIdBP;
        String chaineCryptee;
        system.debug(inputMap.get('ContextId'));
        if (inputMap.get('ContextId') != '') {
			ContactIdValue = (String)inputMap.get('ContextId');
		} else {
			System.debug('Contact missing');
			return;
		}
        
        if(!Test.isRunningTest()) {
            contactIdBP= [SELECT Id,Identifiant_Buisness_Partener__c FROM Contact WHERE Id =: ContactIdValue].Identifiant_Buisness_Partener__c;
            system.debug('contactIdBP' + contactIdBP);
        }
        else {
            contactIdBP = ContactIdValue;
        }

        contactIdBP = contactIdBP.removeStart('0');

        HttpRequest httpRequest = buildHttpRequestHeaders( contactIdBP) ;
        Http http = new Http();
        HttpResponse res = new HttpResponse();

        if(!Test.isRunningTest()) {
            res = http.send(httpRequest);
        }
        else{
            res.setHeader('Content-Type', 'application/json');
            res.setBody('13246578987894654321');
            if(inputMap.get('statusCode') == '200'){
                res.setStatusCode(200);
            }
            else{
                 res.setStatusCode(503);
            }
            
            

        }
            system.debug(res.getStatusCode());
            if(res != null && res.getStatusCode() == 200){
                 String chaineCrypteeValue = res.getBody();
            	chaineCryptee = Label.SM_CL_Api_Debranchement_endpoint + '/modification-rdv-distributeur.html?token='+chaineCrypteeValue;
            }
            else{
                chaineCryptee='#';
            }
           
       /*} 
        else {
            chaineCryptee =  Label.SM_CL_Api_Debranchement_endpoint + '/modification-rdv-distributeur.html?token='+contactIdBP;
        } */

        system.debug('chaineCryptee'+chaineCryptee);

        outMap.put('chaineCryptee', chaineCryptee);
       
    }
    
    /**
     * @Author: Mohamed Kchaou
     * @CreatedDate: 11/03/2019
     * @Return: Http Request Object
     * @Description: build the http request headers to send
    **/
    public static  HttpRequest buildHttpRequestHeaders(String contactIdBP) {
        Long timestamp = Datetime.now().getTime() / 1000;
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');

        req.setEndpoint(Label.SM_CL_Api_Debranchement_endpoint +'/ssecu-ws/debranchement/crypterParam?urlParams=refbp%3D'+contactIdBP+'%26parcoursId%3DsmileModificationRdvDistributeur%26dateEnvoiEmail%3D'+timestamp); 

        req.setHeader('Content-Type', 'application/json');
        return req;
    }          
}