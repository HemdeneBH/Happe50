/**
* @Author: Jalal ARIB (Coe Engie B2C-DGP)
* @Description: Classe pour notifier acorus via un appel au Acorus Webhook
* Le contenu de l'objet est envoyé sous forme de Json
* @CreatedDate: 10/11/2020
* @LastModified: 
*/

//TO TEST
/*List<Case> casesList = [Select Id from Case limit 2];
String content = VI_SM026_NotifyAcorusWebhook.jsonContent(null, casesList);
VI_SM026_NotifyAcorusWebhook.Webhookcallout('https://digital-editique.myengie.fr/Smile/webhook_deveit-smile.php', content );*/

public class VI_SM026_NotifyAcorusWebhook implements HttpCalloutMock {
    
    public static HttpRequest request;
    public static HttpResponse response;
    
    public HTTPResponse respond(HTTPRequest req) {
        request = req;
        response = new HttpResponse();
        response.setStatusCode(200);
        return response;
    }
    /**
* @Author: Jalal ARIB (Coe Engie B2C-DGP)
* @Description: Méthode pour préparer le contenu qui sera envoyé à Acorus
* Method name : jsonContent
* Inputs : List<Object> triggerNew, List<Object> triggerOld
* Output : String
* @CreatedDate: 10/11/2020
* @LastModified: 
*/
    public static String jsonContent(Map<id,Case> newMap) {
        system.debug('in jsoncontent');
        Set<Id> setCaseIdsWithoutDV=newMap.keyset();
        Map<Id,Case> newCaseMap=newMap;
        List<caseAndDV> listCaseAndDV=new List<caseAndDV>();
        String content='';
        if (newCaseMap != null) {
            List<Donnees_Vente__c> listDV=[select id,CaseId__c,name,Code_promotion__c,Code_enseigne_cp_web__c,Code_enseigne_remise_web__c,
                                           HA_Enseigne__c,HA_Type_Enseigne__c
                                           from Donnees_Vente__c where CaseId__c in :newCaseMap.keySet()];
            if(listDV!=null && listDV.size()>0){
                for(Donnees_Vente__c dvToLoop:listDV){
                    caseAndDV caseAndDVToAdd=new caseAndDV();
                    caseAndDVToAdd.VI_Case=newCaseMap.get(dvToLoop.CaseId__c);
                    caseAndDVToAdd.VI_DonneesVentes=dvToLoop;
                    listCaseAndDV.add(caseAndDVToAdd);
                    setCaseIdsWithoutDV.remove(dvToLoop.CaseId__c);
                }
            }
            if(setCaseIdsWithoutDV!=null && setCaseIdsWithoutDV.size()>0){
                for(Id caseWithoutDVId:setCaseIdsWithoutDV){
                    caseAndDV caseAndDVToAdd=new caseAndDV();
                    caseAndDVToAdd.VI_Case=newCaseMap.get(caseWithoutDVId);
                    listCaseAndDV.add(caseAndDVToAdd);
                }
            }
            String newObjects = '[]';
            if(listCaseAndDV!=null && listCaseAndDV.size()>0){
                newObjects = JSON.serialize(listCaseAndDV);
            }
            String userId = JSON.serialize(UserInfo.getUserId());
            content = '{"new": ' + newObjects + ', "userId": ' + userId + '}';
            system.debug ('content:'+content);
        }
        return content;
    }
    
    /**
* @Author: Jalal ARIB (Coe Engie B2C-DGP)
* @Description: Méthode pour faire un callout ashynchrone au Webhook d'Acorus
* Method name : Webhookcallout
* Inputs : String url , Strin content
* Output : String
* @CreatedDate: 10/11/2020
* @LastModified: 
*/
    
    @future(callout=true)
    public static void Webhookcallout(String Namedcredential, String content) {
        //DEVEIT - url = 'https://digital-editique.myengie.fr/Smile/webhook_deveit-smile.php';
        //UAT url= 'https://digital-editique.myengie.fr/Smile/webhook_uat-smile.php';
        
        if (Test.isRunningTest()) {
            Test.setMock(HttpCalloutMock.class, new VI_SM026_NotifyAcorusWebhook ());
        }
        
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Namedcredential);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(content);
        
        h.send(req);
    }
    
    
    public class caseAndDV{
        public Object VI_Case;
        public Object VI_DonneesVentes;
    }
}