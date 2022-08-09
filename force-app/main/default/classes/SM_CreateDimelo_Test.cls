@isTest
public class SM_CreateDimelo_Test {
    @isTest static void testDimelo_findContact(){
        Map<String, String> requestParams1 = new Map<String, String>();
        Map<String, String> requestParams2 = new Map<String, String>();
        Map<String, String> requestParams3 = new Map<String, String>();
        Map<String, String> requestParams4 = new Map<String, String>();
        Map<String, String> requestParams5 = new Map<String, String>();
        Map<String, String> requestParams6 = new Map<String, String>();
        Map<String, String> requestParams7 = new Map<String, String>();
        Map<String, String> requestParams9 = new Map<String, String>();
        
        
        Account accCont = new Account(Name = 'Test Account', Departements_couverts__c = '92', type = 'Partenaire', vlocity_cmt__Status__c = 'Actif');
        insert accCont;
        Contact acc = new Contact(LastName = 'Dimelo',FirstName = 'Dimelo',
                                  Identifiant_Buisness_Partener__c = '123',Email = 'dimelo@dimelo.com',Phone = '0123456789',AccountId=accCont.Id);
        insert acc;
        
        
        requestParams1.put('contact_id',acc.Id);
        requestParams1.put('case_statut','Nouveau');
        requestParams1.put('ToCreateCase','true');
        requestParams1.put('case_type','');
        
        
        String myJSON1 = JSON.serialize(requestParams1);
        
        RestRequest request1 = new RestRequest();
        
        request1.requestUri ='https://cs13.salesforce.com/services/apexrest/CreateDimeloMessageSmile';
        
        request1.httpMethod = 'POST';
        
        request1.requestBody = Blob.valueof(myJSON1);
        
        RestContext.request = request1;
        
        SM_CreateDimeloMessage.createMessage();
        //
        // *****
        requestParams2.put('contact_bp',acc.Identifiant_Buisness_Partener__c);
        String myJSON2 = JSON.serialize(requestParams2);
        
        request1.requestUri ='https://cs13.salesforce.com/services/apexrest/CreateDimeloMessageSmile';
        
        request1.httpMethod = 'POST';
        
        request1.requestBody = Blob.valueof(myJSON2);
        
        RestContext.request = request1;
        
        SM_CreateDimeloMessage.createMessage();
        
        // *****
        requestParams3.put('contact_email',acc.Email);
        String myJSON3 = JSON.serialize(requestParams3);
        
        request1.requestUri ='https://cs13.salesforce.com/services/apexrest/CreateDimeloMessageSmile';
        
        request1.httpMethod = 'POST';
        
        request1.requestBody = Blob.valueof(myJSON3);
        
        RestContext.request = request1;
        
        SM_CreateDimeloMessage.createMessage();
        
        // *****
        requestParams4.put('contact_tel',acc.Phone);
        String myJSON4 = JSON.serialize(requestParams4);    
        
        request1.requestUri ='https://cs13.salesforce.com/services/apexrest/CreateDimeloMessageSmile';
        
        request1.httpMethod = 'POST';
        
        request1.requestBody = Blob.valueof(myJSON4);
        
        RestContext.request = request1;
        
        SM_CreateDimeloMessage.createMessage();
        
        String myJSON5 = JSON.serialize(requestParams5);    
        
        request1.requestUri ='https://cs13.salesforce.com/services/apexrest/CreateDimeloMessageSmile';
        
        request1.httpMethod = 'POST';
        
        request1.requestBody = Blob.valueof(myJSON5);
        
        RestContext.request = request1;
        
        SM_CreateDimeloMessage.createMessage(); 
        
        requestParams6.put('contact_id','123456789876543');
        
        RestRequest request2 = new RestRequest();
        String myJSON6 = JSON.serialize(requestParams6);    
        
        request2.requestUri ='https://cs13.salesforce.com/services/apexrest/CreateDimeloMessageSmile';
        
        request2.httpMethod = 'POST';
        
        request2.requestBody = Blob.valueof(myJSON6);
        
        RestContext.request = request2;
        
        SM_CreateDimeloMessage.createMessage(); 
        
        Contact contact = new Contact();
        contact.LastName ='Test';
        insert contact;
        
        requestParams7.put('contact_id',contact.Id);
        request1.requestUri ='https://cs13.salesforce.com/services/apexrest/CreateDimeloMessageSmile';
        String myJSON7 = JSON.serialize(requestParams7);  
        request1.httpMethod = 'POST';
        
        request1.requestBody = Blob.valueof(myJSON7);
        
        RestContext.request = request1;
        
        SM_CreateDimeloMessage.createMessage();
        
        
        requestParams9.put('contact_id',acc.Id);
        requestParams9.put('ToCreateCase', 'true');
         RestRequest request3 = new RestRequest();
        request3.requestUri ='https://cs13.salesforce.com/services/apexrest/CreateDimeloMessageSmile';
        String myJSON8 = JSON.serialize(requestParams9);  
        request3.httpMethod = 'POST';
        
        request3.requestBody = Blob.valueof(myJSON8);
        
        RestContext.request = request3;
        
        SM_CreateDimeloMessage.findCase(requestParams9,acc.Id);
    }
}