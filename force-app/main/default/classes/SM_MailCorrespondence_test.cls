/*
* @Author: Amine Deghais ~ amine.deghais@external.engie.com
* @Date: 03/09/2019
* @Description: test Class: MailCorrespondence le service d'intégration des correspondances COURRIER dans SMILE
*/
@isTest
private class SM_MailCorrespondence_test {
    @isTest static void mailCorrespondence_test(){
        Map<String, String> requestParams = new Map<String, String>();
         Map<String, String> requestParams2 = new Map<String, String>();
         Map<String, String> requestParams3 = new Map<String, String>();
         Map<String, String> requestParams4 = new Map<String, String>();
        Account account = SM_TestDataFactory.createAccount('Test Account');
        insert account;
        
        Contact contactTest=new Contact(
            LastName = 'SENE',
            Email = 'sene.alain@yopmail.com',
            AccountId = account.Id,
            Adresse_Mail_3__c = 'sene.alain3@yopmail.com',
            Adresse_Mail_2__c = 'sene.alain@2yopmail.com',
            Mobile_3__c='+33654545402',
            Mobile_2__c='+33654545402', 
            Tel_Fixe_3__c='+33154545402', 
            Tel_Fixe_2__c ='+33154545402',
            Phone='+33154545402',
            MobilePhone='+33654545402',
            RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Smile').getRecordTypeId());        
        insert contactTest; 
        
        requestParams.put('contact_id',contactTest.Id);
        requestParams.put('Type_Doc','2');
        requestParams.put('ToCreateCase','true');
        
        requestParams.put('courrier_toaddresses','testTo@gmail.com');
        requestParams.put('courrier_fromaddresses','testFrom@gmail.com');
        requestParams.put('courrier_sujet','test subject');
        requestParams.put('courrier_content','test content');
        requestParams.put('courrier_link','https://engie-dmpa-dsi-digital.atlassian.net/browse/SMIL-3267');
        requestParams.put('direction_interaction','Entrant');
        
        
        String myJSON = JSON.serialize(requestParams);
        
        RestRequest request = new RestRequest();
        
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/MailCorrespondence';
        
        request.httpMethod = 'POST';
        
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        
        SM_MailCorrespondence.mailCorrespondence();
        
        
        requestParams3.put('Type_Doc', '');
        requestParams3.put('ToCreateCase', 'true');
         requestParams3.put('contact_email', 'test');
        
        
        String myJSON3 = JSON.serialize(requestParams3);
        
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/MailCorrespondence';
        
        request.httpMethod = 'POST';
        
        request.requestBody = Blob.valueof(myJSON3);
        
        RestContext.request = request;
        
        SM_MailCorrespondence.mailCorrespondence();
        
        
        String myJSON2 = JSON.serialize(requestParams2);
        
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/MailCorrespondence';
        
        request.httpMethod = 'POST';
        
        request.requestBody = Blob.valueof(myJSON2);
        
        RestContext.request = request;
        
        SM_MailCorrespondence.mailCorrespondence();
        
        
        
        Contact contact = new Contact();
        contact.LastName ='Test';
        insert contact;
        
        requestParams4.put('contact_id',contact.Id);
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/CreateDimeloMessageSmile';
        String myJSON4 = JSON.serialize(requestParams4);  
        request.httpMethod = 'POST';
        
        request.requestBody = Blob.valueof(myJSON4);
        
        RestContext.request = request;
        
        SM_MailCorrespondence.mailCorrespondence();

    }
    @isTest static void findCase_test() {
        Contact contactTest=new Contact(
            LastName = 'SENE',
            Email = 'sene.alain@yopmail.com',
            Adresse_Mail_3__c = 'sene.alain3@yopmail.com',
            Adresse_Mail_2__c = 'sene.alain@2yopmail.com',
            Mobile_3__c='+33654545402',
            Mobile_2__c='+33654545402', 
            Tel_Fixe_3__c='+33154545402', 
            Tel_Fixe_2__c ='+33154545402',
            Phone='+33154545402',
            MobilePhone='+33654545402',
            RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Smile').getRecordTypeId());        
        insert contactTest; 
        Map<String, String> rFindCase=SM_MailCorrespondence.findCase('32',contactTest.id+'');
        System.assertEquals(String.isBlank(rFindCase.get('id')),false);
        System.assertEquals(String.isBlank(rFindCase.get('statut')),false);
        System.assertEquals(String.isBlank(rFindCase.get('sous_statut')),false);
        
    }
    
    @isTest static void matchingCase_test() {
        Test.startTest();     
        SM_Matching_Case__mdt matchingCase32=SM_MailCorrespondence.matchingCase('32');
        // on prend l'exemple 32 qui correspond a (Type_Case__c='Acquisition',Sub_Type_Case__c='Emménagement)
        System.assertEquals(matchingCase32.Type_Case__c, 'Acquisition');
        System.assertEquals(matchingCase32.Sub_Type_Case__c, 'Emménagement');
        SM_Matching_Case__mdt matchingCase2=SM_MailCorrespondence.matchingCase('2');
        // on prend l'exemple 2 qui correspond a (Type_Case__c='Acquisition',Sub_Type_Case__c='Emménagement)
        //System.assertEquals(matchingCase2.Type_Case__c, 'Vie du contrat');
        //System.assertEquals(matchingCase2.Sub_Type_Case__c, 'Mise en place ou résiliation de prélèvement ou de mensualisation');
        Test.stopTest();
    }
}