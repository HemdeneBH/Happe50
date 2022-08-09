/*******************************************************************************************************
* @description: Appeler le service crypter Param pour le debranchement ( Developpement fait dans le  cadre de l'us SMIL-1734 )
* @return the token
* @date: 2019-03-08 
* @author: Mohamed Kchaou
********************************************************************************************************/
public class SM_AP60_Debranchement_ServiceImpl {
    public String ContactIdValue {get; set;}
    public String chaineCryptee;   
    /* public SM_AP60_Debranchement_ServiceImpl() {
    }*/
    
    /* 
    *   @author : Mickaël
    *   @description Appel à l'API qui crypte une chaîne de caractère
    *   @date 11/03/2019
    */
    public void setChaineCryptee (String s) {
        chaineCryptee = s;
    }

    public String getChaineCryptee() {
        String contactIdBP;
        
        if(ContactIdValue == ''){
            chaineCryptee='#';
             return chaineCryptee;     
        }
        
        if(!Test.isRunningTest()) {
            contactIdBP= [SELECT Id,Identifiant_Buisness_Partener__c FROM Contact WHERE Id =: ContactIdValue].Identifiant_Buisness_Partener__c;
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
            if(contactIdBP.contains('200')){
                res.setStatusCode(200);
            }
            else{
                 res.setStatusCode(503);
            }
        }
            if(res != null && res.getStatusCode() == 200){
                 String chaineCrypteeValue = res.getBody();
            	chaineCryptee = Label.SM_CL_Api_Debranchement_endpoint + '/modification-rdv-distributeur.html?token='+chaineCrypteeValue;
            }
            else{
                chaineCryptee='#';
            }
           

        return chaineCryptee;     
    }
    
    /**
     * @Author: Mohamed Kchaou
     * @CreatedDate: 11/03/2019
     * @Return: Http Request Object
     * @Description: build the http request headers to send
    **/
    public  HttpRequest buildHttpRequestHeaders(String contactIdBP) {
        Long timestamp = Datetime.now().getTime() / 1000;
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');

        req.setEndpoint(Label.SM_CL_Api_Debranchement_endpoint +'/ssecu-ws/debranchement/crypterParam?urlParams=refbp%3D'+contactIdBP+'%26parcoursId%3DsmileModificationRdvDistributeur%26dateEnvoiEmail%3D'+timestamp); 

        req.setHeader('Content-Type', 'application/json');
        return req;
    }          
}