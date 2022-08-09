@isTest
public class SM_AP25_GetContactInfosForCards_Test {
    
    static testMethod void getInfosTest() {
    Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outputMap = new Map < String, Object >();
        Contact aContact = new Contact(LastName = 'Test',Complement_adresse__c = 'Engie',Email = 'Test@test.com',FirstName = 'Test',
                                       Identifiant_Buisness_Partener__c = '1256789',MailingCity = 'Paris',MailingPostalCode = '75000',No_Voie__c = '115',MailingStreet = '112 rue des testeurs',
                                       Salutation = 'Mr',Segment_Marketing__c = '12345');
        insert aContact;
    inputMap.put('Id',aContact.Id);
    system.debug('inputMap : '+inputMap);
        
        SM_AP25_GetContactInfosForCards serv = new SM_AP25_GetContactInfosForCards();
        serv.invokeMethod('getInfos',inputMap,outputMap,null);   
        
    }
}