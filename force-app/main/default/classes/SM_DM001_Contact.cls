/**
 * @description       : classe SOSL qui permets de récupérer les informations d'un payeur divergent recherché dans liste des contacts
 * @author            : AE
 * @group             : 
 * @last modified on  : 09-27-2021
 * @last modified by  : AE
**/
global class SM_DM001_Contact implements vlocity_cmt.VlocityOpenInterface{
    
    global static Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        boolean returnValue = true;
        if (methodName.equals('getPayeurDivergentSOSL')) {
            getPayeurDivergentSOSL(inputMap,outMap);
        }else{
            returnValue = false;
        }
        return returnValue;
    }
        
    
    global static void getPayeurDivergentSOSL(Map < String, Object > inputMap, Map < String, Object > outputMap){
        String rechercheString = (String)inputMap.get('RechercheClient');
        List<List<sObject>> contactList =new List<List<sObject>> ();
        if(rechercheString!=''){
            String searchQuery = 'FIND \'' + rechercheString + '\' IN ALL FIELDS RETURNING  Contact(Id,Salutation,FirstName,LastName,No_Voie__c,MailingCity,MailingPostalCode,MailingStreet,Identifiant_Buisness_Partener__c )';
            contactList = search.query(searchQuery);
        }else{
            String RechercheBlank = 'Vide';
            outputMap.put('RechercheVide',RechercheBlank);
        }
        outputMap.put('contactList',contactList);
    }
}