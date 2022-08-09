global class SM_AP66_FindDuplicateContact implements vlocity_cmt.VlocityOpenInterface  {
    
    
    global Boolean invokeMethod(String methodName, 
                                Map < String, Object > inputMap, 
                                Map < String, Object > outMap, 
                                Map < String, Object > options) {
                                    
                                    if (methodName.equals('findDuplicates')) {
                                        findDuplicatesCustom(inputMap, outMap, new Map< String, Object>());
                                        
                                    }
                                    return true;
                                }  
    /*
* @Author: Amine Deghais ~ amine.deghais@external.engie.com
* @Date: 03/09/2019
* @Description: Detecter les duplicates contactes selon les  3 duplications rules  sur contact avec recordtype 'Contact Smile'
*/
    public static void findDuplicatesCustom(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
             
        Map<String,Object> contactInfoMap = (Map<String,Object>) inputMap.get('ContactInfo');
        Map<String,Object> civilityBlock = (Map<String,Object>) contactInfoMap.get('CivilityBlock');
        Map<String,Object> addressMap = (Map<String,Object>) contactInfoMap.get('Address');
        Map<String,Object> emailMap = (Map<String,Object>) contactInfoMap.get('Email');
        Map<String,Object> telMobileMap = (Map<String,Object>) contactInfoMap.get('TelMobile');
        Map<String,Object> telFixeMap = (Map<String,Object>) contactInfoMap.get('TelFixe');
  
        
        Contact newCont = new Contact();        
        newCont.LastName =(String) civilityBlock.get('LastName');
        newCont.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Smile').getRecordTypeId();
        newCont.tech_bypass_dupRul__c=false;
        //Address
        newCont.MailingCity=(String) addressMap.get('City');
        newCont.MailingStreet=(String) addressMap.get('Street');
        newCont.MailingPostalCode=(String) addressMap.get('PC');
        //Email    
        if(emailMap.get('selectedEmail')!=null){
            if(((String) emailMap.get('selectedEmail')).equals('Adresse Mail 1')){
                newCont.EmailPrincipalValueRW__c=(String) emailMap.get('NewEmail1');
            }else if(((String) emailMap.get('selectedEmail')).equals('Adresse Mail 2')){
                newCont.EmailPrincipalValueRW__c=(String) emailMap.get('NewEmail2');
            }else if(((String) emailMap.get('selectedEmail')).equals('Adresse Mail 3')){
                newCont.EmailPrincipalValueRW__c=(String) emailMap.get('NewEmail3');
            }
        }
        //TelMobile
        if(telMobileMap.get('selectedNumMobile')!=null){   
            if(((String) telMobileMap.get('selectedNumMobile')).equals('Mobile 1')){
                newCont.MobilePrincipalValueRW__c=(String) telMobileMap.get('SFNewMobile1');
            }else if(((String) telMobileMap.get('selectedNumMobile')).equals('Mobile 2')){
                newCont.MobilePrincipalValueRW__c=(String) telMobileMap.get('SFNewMobile2');
            }else if(((String) telMobileMap.get('selectedNumMobile')).equals('Mobile 3')){
                newCont.MobilePrincipalValueRW__c=(String) telMobileMap.get('SFNewMobile3');
            }
        }      
        //TelFixe
        if(telFixeMap.get('selectedNumFixe')!=null){ 
            if(((String) telFixeMap.get('selectedNumFixe')).equals('Tel Fixe 1')){
                newCont.TelFixePrincipalValueRW__c=(String) telFixeMap.get('SFNewTelFixe1');
            }else if(((String) telFixeMap.get('selectedNumFixe')).equals('Tel Fixe 2')){
                newCont.TelFixePrincipalValueRW__c=(String) telFixeMap.get('SFNewTelFixe2');
            }else if(((String) telFixeMap.get('selectedNumFixe')).equals('Tel Fixe 3')){
                newCont.TelFixePrincipalValueRW__c=(String) telFixeMap.get('SFNewTelFixe3');
            }
        }
        system.debug('NewTelFixe2'+telFixeMap.get('NewTelFixe2'));
        
        system.debug('selectedNumFixe'+telFixeMap.get('selectedNumFixe'));
        system.debug('TelFixePrincipalValueRW__c'+newCont.TelFixePrincipalValueRW__c);
        List<Contact> conList = new List<Contact>();
        conList.add(newCont); 
        List<Id> existingContactId=new List<Id>();
        Datacloud.FindDuplicatesResult[] results = Datacloud.FindDuplicates.findDuplicates(conList);
        if (results.size() > 0) {					 
            for (Datacloud.FindDuplicatesResult findDupeResult : results) {
                for (Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()) {
                    for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
                        for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                            if(matchRecord.getRecord()!=null){
                                //NB: getRecord() ne retourne pas tous les attributs donc il faut passer un SOQL.
                                existingContactId.add(((contact) matchRecord.getRecord()).Id);    
                            }
                        }
                    }
                }
            }                       
            if(existingContactId.size()>0){
                System.System.debug('**SM_AP62_Consentement**: Duplicate Found');
                outMap.put('duplicatesFound',true);   
                outMap.put('matchRecord',[Select Id,salutation,FirstName,LastName,No_Voie__c,MailingCity,MailingStreet,MailingPostalCode,EmailPrincipalValue__c,TelFixePrincipalValue__c,MobilePrincipalValue__c from Contact where Id in :existingContactId]);                  
            }
            else{
                System.System.debug('**SM_AP62_Consentement**: Duplicate Not Found');
                outMap.put('duplicatesFound',false); 
            }
        }                
    }    
}