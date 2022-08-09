/*
* @Author: Paul Ghoussoub
*@Description: Classe de test de VI_parcoursPPRechercheClient_Controller
*@CreatedDate: 28/1/2021
*/
@isTest
public class VI_parcoursPPRechercheClient_Test { 
    
    @testSetup
    static void testSetup(){
        VI_TestDataFactory.createDummyXData();
        
        List<Group> ownerQueue = [Select Id,DeveloperName from Group where Type = 'Queue'];
        
        system.debug('query queue '+ownerQueue);
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'TestVI','TestVI');
        u.isActive=true;
        insert u;
        //Fin de la methode
        //
        //
        //Test
    }
    
    @isTest
    static void testMethod1(){
        
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            Account acc=VI_TestUtility.createAccount('test');
            insert acc;
            Contact x=VI_TestUtility.createContact('test','test','test@test.com',acc.Id);
            x.Identifiant_Buisness_Partener__c='1111111111';
            x.MobilePhone='+331234';
            x.MailingPostalCode='1234';
            x.MailingCity='test';
            Id contactrecordTypeId = Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId();
            x.recordTypeId=contactrecordTypeId;
            insert x;
            Test.startTest();
            List<Contact> listContact=VI_parcoursPPRechercheClient_Controller.getContactListNew('test','01234','test@test.com','test','1234','111111111','test');
            system.assert(listContact.size()>0);
            Test.stopTest();
        }
    }
    @isTest 
    static void testMethod2(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            VI_Parcours__c parcours=VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            parcours.VI_RefusEmailCreationClient__c=true;
            insert parcours;
            Test.startTest();
            VI_parcoursPPRechercheClient_Controller.RechercheClientWrapper wrapper=new VI_parcoursPPRechercheClient_Controller.RechercheClientWrapper('test','test','test',false,'test','test','test',false,'test','test','test',false,'test','test','Mobile 1','test','test','test','test','Oui','Oui');
            VI_parcoursPPRechercheClient_Controller.createContact(parcours,wrapper);
            VI_Parcours__c parcours2=VI_parcoursPPRechercheClient_Controller.updateParcours(parcours, wrapper);
            system.assert(!parcours2.VI_RefusEmailCreationClient__c);
            VI_parcoursPPRechercheClient_Controller.createPersonneSF(wrapper,'123');
            VI_parcoursPPRechercheClient_Controller.RechercheClientResponseWrapper createContactwrapper=VI_parcoursPPRechercheClient_Controller.createContactFromLWC(parcours,'test','test','test',false,'test','test','test',false,'test','test','test',false,'test','test','test','test','test','test','test','Oui','Non');
            Test.stopTest();
        }
    }
    @isTest
    static void testMethod6(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            VI_Parcours__c parcours=VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            parcours.VI_RefusEmailCreationClient__c=true;
            parcours.VI_IDReferenceClient__c='1234384334';
            insert parcours;
            Test.startTest();
            VI_parcoursPPRechercheClient_Controller.RechercheClientWrapper wrapper=new VI_parcoursPPRechercheClient_Controller.RechercheClientWrapper('test','test','test',false,'test','test','test',false,'test','test','test',false,'test','test','Mobile 1','test','test','test','test','Non','Oui');
            VI_parcoursPPRechercheClient_Controller.createContact(parcours,wrapper);
            VI_Parcours__c parcours2=VI_parcoursPPRechercheClient_Controller.updateParcours(parcours, wrapper);
            system.assert(!parcours2.VI_RefusEmailCreationClient__c);
            VI_parcoursPPRechercheClient_Controller.createPersonneSF(wrapper,'123');
            VI_parcoursPPRechercheClient_Controller.RechercheClientResponseWrapper createContactwrapper=VI_parcoursPPRechercheClient_Controller.createContactFromLWC(parcours,'test','test','test',false,'test','test','test',false,'test','test','test',false,'test','test','test','test','test','test','test','Oui','Non');
            Test.stopTest();
        }
    }
    @isTest
    static void testMethod5(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            Test.startTest();
            VI_Parcours__c parcours=VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            parcours.VI_EmailPrincipalCreationClient__c='Email 1';
            parcours.VI_Email1Client__c='test@test.com';
            insert parcours;
            String email=VI_parcoursPPRechercheClient_Controller.checkPreferedEmail(parcours);
            system.assertEquals(email, 'test@test.com');
            Test.stopTest();
        }
    }
    
    @isTest
    public static void test_getVilles(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_TestDQEAdresse');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Set<String> testSet=new Set<String>();
            Test.setMock(HttpCalloutMock.class, multimock);
            List<String> listvilles=VI_parcoursPPRechercheClient_Controller.getVilles('MORANGIS');
            system.assert(listvilles.size()>0);
            Test.stopTest();
        }
    }
    
    @isTest
    public static void test_getMapVilles(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_TestDQEAdresse');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Set<String> testSet=new Set<String>();
            Test.setMock(HttpCalloutMock.class, multimock);
            VI_parcoursPPRechercheClient_Controller.getMapVilles('MORANGIS');
            Test.stopTest();
        }
    }
    
    @isTest
    public static void test_majPersonne(){
        Contact contactToInsert=new Contact(); 
        contactToInsert.lastname='test';
        Id contactrecordTypeId = Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId();
        contactToInsert.recordTypeId=contactrecordTypeId;
        insert contactToInsert;
        VI_parcoursPPRechercheClient_Controller.RechercheClientWrapper personne = new VI_parcoursPPRechercheClient_Controller.RechercheClientWrapper('test', 'test', 'Mr.', false, 'test@test.com','test@test.com', 'Adresse Mail 1', 
                                                                                                                                                     false, '0129824923', '0129824923','Fixe 1', false,'0129824923', '0129824923', 
                                                                                                                                                     'Mobile 1','18', 'AVENUE', 'MORANGIS','91420', 'Oui','Non');
        VI_parcoursPPRechercheClient_Controller.majPersonneSAP(personne, '12345');		
        VI_parcoursPPRechercheClient_Controller.createPersonneSF(personne, '12345');  
        VI_parcoursPPRechercheClient_Controller.updatePersonneSF(personne,'12345',contactToInsert.ID);
    }
    
    @isTest
    public static void test_getAdresseList(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_TestDQEAdresse');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            List<VI_SM002_AdresseDQE.AdressesWrapper> testList=new List<VI_SM002_AdresseDQE.AdressesWrapper>();
            Test.setMock(HttpCalloutMock.class, multimock);
            List<VI_SM002_AdresseDQE.AdressesWrapper> adresses=VI_parcoursPPRechercheClient_Controller.getAdresseList('MORANGIS');
            system.assert(adresses.size()>0);
            Test.stopTest();
        }
    }
    
    @isTest
    public static void test_getVillesCodePostal(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_TestDQEAdresse');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Set<String> testSet=new Set<String>();
            Test.setMock(HttpCalloutMock.class, multimock);
            List<VI_SM002_AdresseDQE.AdressesWrapper> listevilles=VI_parcoursPPRechercheClient_Controller.getVillesCodePostal('91420');
            system.assert(listevilles.size()>0);
            Test.stopTest();
        }
    } 
    
    @isTest
    public static void test_getVillesCodePostalMap(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_TestDQEAdresse');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Set<String> testSet=new Set<String>();
            Test.setMock(HttpCalloutMock.class, multimock);VI_parcoursPPRechercheClient_Controller.getVillesCodePostalMap('91420');
            Test.stopTest();
        }
    } 
    
    @isTest
    public static void test_verifyTell(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            VI_Parcours__c parcours=VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_SM001_PhoneVerificationService');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, multimock);
            VI_parcoursPPRechercheClient_Controller.RechercheClientResponseWrapper wrapper=VI_parcoursPPRechercheClient_Controller.verifTel(parcours, '01797687923');
            system.assertEquals(wrapper.message, 'success');
            Test.stopTest();
        }
    } 
    @isTest
    public static void test_verifMail(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            VI_Parcours__c parcours=VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_SM001_PhoneVerificationService');
            
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, multimock);
            VI_parcoursPPRechercheClient_Controller.RechercheClientResponseWrapper wrapper=VI_parcoursPPRechercheClient_Controller.verifMail(parcours, 'test@test.com');
            system.assertEquals(wrapper.message, 'success');
            Test.stopTest();
        }
    } 
    
    @isTest
    public static void test_verifyDQE(){  
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            VI_Parcours__c parcours=VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_SM001_PhoneVerificationService');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, multimock);
            VI_parcoursPPRechercheClient_Controller.RechercheClientResponseWrapper wrapper=VI_parcoursPPRechercheClient_Controller.verifyDQE(parcours, 'test@test.com', 'test@test.com','01797687923','01797687923','01797687923','01797687923');
            system.assertEquals(wrapper.message, 'success');
            Test.stopTest();      
        }
    } 
    
    @isTest
    public static void majEmailPersonneTest(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            List<Contact> listContact=new List<Contact>();
            VI_Parcours__c parcours=VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            parcours.VI_Email_CPV__c='test@test.com';
            VI_Parcours__c parcours2=VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            parcours2.VI_Email_CPV__c='test3@fs.com';
            VI_Parcours__c parcours3=VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            parcours3.VI_Email_CPV__c='test4@testm.com';
            VI_Parcours__c parcours4=VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            parcours4.VI_Email_CPV__c='test5@fs.com';
            VI_Parcours__c parcours5=VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            parcours5.VI_Email_CPV__c='tset6@test.com';
            Id smileRecordTypeid=VI_ObjectUtils.getRecordTypeId('Contact','Contact_Smile'); 
            Contact c=new Contact(Salutation='Madame',firstname='test',lastname='tets',RecordtypeId=smileRecordTypeid);
            listContact.add(c);
            Contact c2=new Contact(Salutation='Madame',firstname='test',email='test1@testm.com',lastname='tets2',RecordtypeId=smileRecordTypeid);
            listContact.add(c2);
            Contact c3=new Contact(Salutation='Madame',firstname='test',email='test2@testm.com',Adresse_Mail_2__c='test3@fs.com',lastname='tets2',RecordtypeId=smileRecordTypeid);
            listContact.add(c3);
            Contact c4=new Contact(Salutation='Madame',firstname='test',email='test4@testm.com',Adresse_Mail_2__c='test5@fs.com',Adresse_Mail_3__c='tset6@test.com',lastname='tets2',RecordtypeId=smileRecordTypeid);
            listContact.add(c4);
            Contact c5=new Contact(Salutation='Madame',firstname='test',email='test4@testm.com',Adresse_Mail_2__c='test5@fs.com',Adresse_Mail_3__c='tset6@test.com',lastname='tets2',Adresse_Mail_Principale__c='Adresse Mail 1',RecordtypeId=smileRecordTypeid);
            listContact.add(c5);
            Contact c6=new Contact(Salutation='Madame',firstname='test',email='test4@testm.com',Adresse_Mail_2__c='test5@fs.com',Adresse_Mail_3__c='tset6@test.com',lastname='tets2',Adresse_Mail_Principale__c='Adresse Mail 2',RecordtypeId=smileRecordTypeid);
            listContact.add(c6);
            Contact c7=new Contact(Salutation='Madame',firstname='test',email='test4@testm.com',Adresse_Mail_2__c='test5@fs.com',Adresse_Mail_3__c='tset6@test.com',lastname='tets2',Adresse_Mail_Principale__c='Adresse Mail 3',RecordtypeId=smileRecordTypeid);
            listContact.add(c7);
            Contact c8=new Contact(Salutation='Madame',lastname='tets',Adresse_Mail_2__c='test3@fs.com',RecordtypeId=smileRecordTypeid);
            listContact.add(c8);
            Contact c9=new Contact(Salutation='Madame',lastname='tets',Adresse_Mail_3__c='test3@fs.com',RecordtypeId=smileRecordTypeid);
            listContact.add(c9);
            Contact c10=new Contact(Salutation='Madame',firstname='test',email='test4@testm.com',Adresse_Mail_2__c='test5@fs.com',Adresse_Mail_3__c='tset6@test.com',lastname='tets2',Adresse_Mail_Principale__c='Adresse Mail 3',RecordtypeId=smileRecordTypeid);
            listContact.add(c10);
            insert listContact;
            Test.startTest();
            parcours.VI_Contact__c=c.id;
            VI_parcoursPPRechercheClient_Controller.majEmailPersonne(parcours);
            parcours.VI_Contact__c=c2.id;
            VI_parcoursPPRechercheClient_Controller.majEmailPersonne(parcours);
            parcours.VI_Contact__c=c3.id;
            VI_parcoursPPRechercheClient_Controller.majEmailPersonne(parcours);
            parcours.VI_Contact__c=c4.id;
            VI_parcoursPPRechercheClient_Controller.majEmailPersonne(parcours);
            parcours.VI_Contact__c=c5.id;
            VI_parcoursPPRechercheClient_Controller.majEmailPersonne(parcours);
            parcours.VI_Contact__c=c6.id;
            VI_parcoursPPRechercheClient_Controller.majEmailPersonne(parcours);
            parcours.VI_Contact__c=c7.id;
            VI_parcoursPPRechercheClient_Controller.majEmailPersonne(parcours);
            parcours.VI_Contact__c=c8.id;
            VI_parcoursPPRechercheClient_Controller.majEmailPersonne(parcours);
            parcours.VI_Contact__c=c9.id;
            VI_parcoursPPRechercheClient_Controller.majEmailPersonne(parcours);
            parcours2.VI_Contact__c=c8.id;
            VI_parcoursPPRechercheClient_Controller.majEmailPersonne(parcours2);
            parcours2.VI_Contact__c=c9.id;
            VI_parcoursPPRechercheClient_Controller.majEmailPersonne(parcours2);
            parcours3.VI_Contact__c=c10.id;
            VI_parcoursPPRechercheClient_Controller.majEmailPersonne(parcours3);
            parcours4.VI_Contact__c=c10.id;
            VI_parcoursPPRechercheClient_Controller.majEmailPersonne(parcours4);
            parcours5.VI_Contact__c=c10.id;
            VI_parcoursPPRechercheClient_Controller.majEmailPersonne(parcours5);
            Test.stopTest();
            
            
        }
    }
    
}