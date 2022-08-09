global class SM_AP25_GetContactInfosForCards implements vlocity_cmt.VlocityOpenInterface {
    
   global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

  if (methodName.equals('getInfos')) {
       try {
        	getInfos(inputMap, outMap, options);
       }catch (Exception e) {
        	system.debug(e.getStackTraceString());
        return false;
       }
  }
  return true;
 }
    
    public static void getInfos(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        
        system.debug('***** '+inputMap);
        String getIdContact = String.valueof(inputMap.get('Id'));
        
        system.debug('getIdContact '+getIdContact);
        
        List<Contact> contacts = [select id,A_requalifier__c,Complement_adresse__c,Email,EmailPrincipalValue__c,FirstName,Identifiant_Buisness_Partener__c,
                                  LastName,MailingCity,MailingPostalCode,MailingStreet,MobilePrincipalValue__c,Name,Salutation,Segment_Marketing__c,
                                  Statut_Internaute__c,TelFixePrincipalValue__c,No_Voie__c
                                  from Contact where id =: getIdContact];
        
        Contact aContact = contacts[0];
        
        system.debug(' name : '+aContact.name);
        
        outMap.put('Requalifier',aContact.A_requalifier__c);
        outMap.put('ComplementAdresse',aContact.Complement_adresse__c);
        outMap.put('ContactEmail',aContact.Email);
        outMap.put('EmailPrincipal',aContact.EmailPrincipalValue__c);
        outMap.put('FirstName',aContact.FirstName);
        outMap.put('ContactId',aContact.id);
        if(aContact.Identifiant_Buisness_Partener__c != null){
        outMap.put('ReferenceClient',integer.valueof(aContact.Identifiant_Buisness_Partener__c));
        }       
        outMap.put('LastName',aContact.LastName);
        outMap.put('Ville',aContact.MailingCity);
        outMap.put('PostalCode',aContact.MailingPostalCode);
        outMap.put('Rue',aContact.MailingStreet);
        outMap.put('MobilePrincipal',aContact.MobilePrincipalValue__c);
        outMap.put('Name',aContact.Name);
        outMap.put('Salutation',aContact.Salutation);
        outMap.put('SegmentMarketing',aContact.Segment_Marketing__c);
        outMap.put('StatutInternaute',aContact.Statut_Internaute__c);
        outMap.put('TelFixePrincipal',aContact.TelFixePrincipalValue__c);
        outMap.put('NumVoieRue',aContact.No_Voie__c ==null?aContact.MailingStreet:aContact.No_Voie__c+' '+aContact.MailingStreet);
        
         String urlELC;
        
        //
        List<NamedCredential> namesC = [SELECT DeveloperName,Endpoint,Id,MasterLabel,PrincipalType FROM NamedCredential where DeveloperName like '%SMIL%'];

        String idC = namesC[0].Id;
        
        // Check if have access to Named Credentials
        List<ExternalDataUserAuth> externals = [SELECT id,UserId, ExternalDataSource.Id from ExternalDataUserAuth];
        List<String> idsHaveAccess = new List<String>();
        if(externals != null && externals.size() > 0){
            for(ExternalDataUserAuth ex : externals ){
                if(ex.ExternalDataSource.Id == idC){
                idsHaveAccess.add(ex.UserId);
                }
            }
        }
        
       
        if(idsHaveAccess.contains(UserInfo.getUserId())){
            // get URL
            urlELC = SM_AP21_GestionImpersonation.getURLImpersonation(aContact.Identifiant_Buisness_Partener__c);
        }
        else {
            urlELC = '#';
        }
            
               
        system.debug('url : '+urlELC);
        outMap.put('UrlELC',urlELC);
        
    }

}