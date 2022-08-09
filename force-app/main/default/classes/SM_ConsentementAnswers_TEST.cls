@isTest
public class SM_ConsentementAnswers_TEST {
    /*
*   @description : Appel depuis la vue 360
*/
    @isTest(SeeAllData = true)
    public static void callConsentementAnswers(){
        
        
        String methodName='apiConsentementAnswers';
        Map < String, Object > inputMap = new Map < String, Object >(); 
        Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > outMapWithoutId = new Map < String, Object >();
        Map < String, Object > options = new Map < String, Object >();
        SM_ConsentementAnswers_API trApiSerTest=new SM_ConsentementAnswers_API();
        inputMap.put('idPersonne',[select ID_Tiers__c from contact where ID_Tiers__c!=null limit 1].ID_Tiers__c);
        
        //all param are OK
        trApiSerTest.invokeMethod(methodName,inputMap,outMap,options);
        // Cache.OrgPartition part = Cache.Org.getPartition('local.smileToken');
        //  HttpResponse http=SM_ConsentementAnswers_API.getResponseTranquility('test','tokenTranquility',inputMap);
        Map < String, Object > inputMapUpdate = new Map < String, Object >();
        inputMapUpdate.put('idPersonne', [select ID_Tiers__c from contact where ID_Tiers__c!=null limit 1].ID_Tiers__c);
        inputMapUpdate.put('idBusinessPartner', [select Identifiant_Buisness_Partener__c from contact where Identifiant_Buisness_Partener__c!=null limit 1].Identifiant_Buisness_Partener__c);
        inputMapUpdate.put('canal', 'Telephone');
        inputMapUpdate.put('application', 'SMILE');
        List<Object> listConsentement =  new List<Object>();
        Map<Object,Object> Response = new Map<Object,Object>();
        Response.put('questionLabel', 'Jaccepte de recevoir des communications par voie électronique sur des offres de produits ou services de la société ENGIE similaires à la vente d’énergie.');
        Response.put('idQuestionnaire', 1);
        Response.put('idQuestion', 1);
        Response.put('key', '1_1');
        Response.put('consentNew', 'false');
        listConsentement.add(Response);

        Response.put('questionLabel', 'Jaccepte de recevoir des communications par voie électronique sur des offres de produits ou services des sociétés du groupe ENGIE non similaires à la vente d’énergie.');
        Response.put('idQuestionnaire', 1);
        Response.put('id', '31f5904f-4798-11e9-b085-000d3a2927b0');
        Response.put('consent', 'false');
        Response.put('idQuestion', 2);
        Response.put('key', '1_2');
        Response.put('consentNew', 'true');
        listConsentement.add(Response);
        inputMapUpdate.put('consentementResult', listConsentement);
        outMap = SM_ConsentementAnswers_API.updateConsentement(inputMapUpdate); 
        Response.put('id', '');
        listConsentement.add(Response);
        outMapWithoutId = SM_ConsentementAnswers_API.updateConsentement(inputMapUpdate);     
    }
    
}