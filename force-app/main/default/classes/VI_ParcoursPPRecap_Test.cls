/*
*@Author: Amal Chreiteh
*@Description: Classe de test de la classe VI_ParcoursPPRecap_Controller
*@CreatedDate: 23/03/2021
*@LastModified: 23/03/2021
*/


@isTest
public class VI_ParcoursPPRecap_Test {
    
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
    
    @isTest static void getSelectedContact() {
        VI_Parcours__c parcours =new VI_Parcours__c(VI_Email_CPV__c='test@test.com', VI_ChoixParcours__c='CHF');      
        Contact contact = new Contact();
        contact.LastName = 'UZUMAKI';
        contact.FirstName = 'Naruto';  
        Id contactrecordTypeId = Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId();
        contact.recordTypeId=contactrecordTypeId;
        insert contact;
        
        parcours.VI_Contact__c = contact.Id;
        parcours.VI_TypeParcours__c = 'PURE PLAYERS';
        
        Case kz = new Case();
        insert kz;
        
        parcours.VI_Case__c = kz.Id;
        
        insert parcours;
        
        test.startTest();
        VI_ParcoursPPRecap_Controller.RecapWrapper myResult = VI_ParcoursPPRecap_Controller.getSelectedContact(parcours);
        VI_ParcoursPPRecap_Controller.ContactX myContact = myResult.recapContact;
        System.assertEquals(contact.firstname ,myContact.firstname);
        System.assertEquals('UZUMAKI' ,myContact.LastName);
        test.stopTest();
        
    } 
    
    @isTest static void envoiCPVSuccessIdentifie() {
        VI_Parcours__c parcours =new VI_Parcours__c(VI_Email_CPV__c='test@test.com', VI_ChoixParcours__c='CHF');      
        Contact contact = new Contact();
        contact.LastName = 'UZUMAKI';
        contact.FirstName = 'Naruto';
        Id contactrecordTypeId = Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId();
        contact.recordTypeId=contactrecordTypeId;
        insert contact;
        
        parcours.VI_Contact__c = contact.Id;
        parcours.VI_TypeParcours__c = 'PURE PLAYERS';
        Case kz = new Case();
        insert kz;
        
        parcours.VI_Case__c = kz.Id;
        insert parcours;
        
        test.startTest();
        List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> listcouple=new List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element>();
        VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element element=new VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element();
        listcouple.add(element);
        VI_ParcoursPPRecap_Controller.validerParcoursWrapper wrapper = VI_ParcoursPPRecap_Controller.envoiCPV(parcours,'2',listcouple);
        //system.assertEquals(true, wrapper.parcours.VI_EmailEnvoye__c);
        test.stopTest();
        
    }  
    
    @isTest static void envoiCPVSuccessNonIdentifie() {
        VI_Parcours__c parcours =new VI_Parcours__c(VI_Email_CPV__c='test@test.com', VI_ChoixParcours__c='CHF', VI_LocalNonIdentifieGenerationCase__c = true);      
        Contact contact = new Contact();
        contact.LastName = 'UZUMAKI';
        contact.FirstName = 'Naruto';
        Id contactrecordTypeId = Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId();
        contact.recordTypeId=contactrecordTypeId;
        insert contact;
        
        parcours.VI_Contact__c = contact.Id;
        parcours.VI_TypeParcours__c = 'PURE PLAYERS';
        
        Case kz = new Case();
        insert kz;
        
        parcours.VI_Case__c = kz.Id;
        insert parcours;
        
        test.startTest();
        List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> listcouple=new List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element>();
        VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element element=new VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element();
        listcouple.add(element);
        VI_ParcoursPPRecap_Controller.validerParcoursWrapper wrapper = VI_ParcoursPPRecap_Controller.envoiCPV(parcours,'2',listcouple);
        //system.assertEquals(true, wrapper.parcours.VI_EmailEnvoye__c);
        test.stopTest();
        
    } 
    
    
    @isTest static void envoiCPVFailure() {
        VI_Parcours__c parcours =new VI_Parcours__c();      
        Contact contact = new Contact();
        contact.LastName = 'UZUMAKI';
        contact.FirstName = 'Naruto';
        Id contactrecordTypeId = Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId();
        contact.recordTypeId=contactrecordTypeId;
        insert contact;
        
        parcours.VI_Contact__c = contact.Id;
        parcours.VI_TypeParcours__c = 'PURE PLAYERS';
        
        Case kz = new Case();
        insert kz;
        
        parcours.VI_Case__c = kz.Id;
        insert parcours;
        
        test.startTest();
        List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> listcouple=new List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element>();
        VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element element=new VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element();
        listcouple.add(element);
        VI_ParcoursPPRecap_Controller.validerParcoursWrapper wrapper = VI_ParcoursPPRecap_Controller.envoiCPV(parcours,'2',listcouple);
        system.assertEquals('Erreur lors de la génération du CPV', wrapper.message);
        test.stopTest();
        
    }  
    
    @isTest
    static void testMethod3(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            Account acc=VI_TestUtility.createAccount('test');
            insert acc;
            Id smileRecordTypeid=VI_ObjectUtils.getRecordTypeId('Contact','Contact_Smile'); 
            Contact x=new Contact(accountid=acc.id,RecordtypeId=smileRecordTypeid);
            x.lastname='test';
            insert x;
            Case caseToInsert =new Case(subject = 'Test', contactid = x.Id);
            insert caseToInsert;
            VI_Parcours__c parcours= VI_TestDataFactory.createParcours('CHF', caseToInsert.Id, 'PURE PLAYERS');
            insert parcours;
            VI_parcoursPPRechercheClient_Controller.updateParcoursClient(parcours,'213','213');
            VI_parcoursPPRechercheClient_Controller.getContactList('test');
            List < VI_SM011_ConsentementAnswers_API.consentementAnswer > consentmentAnswers=new List < VI_SM011_ConsentementAnswers_API.consentementAnswer >(); 
            List<Object> testList=new List<Object>();
            Map<String,Object>testMap=new Map<String,Object>();
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_TestConsentementAnswers');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, multimock);
            consentmentAnswers=VI_SM011_ConsentementAnswers_API.getConsentementAnswersData('asfds','VI', 'local.VIToken');
            VI_ParcoursPPRecap_Controller.Question question=new VI_ParcoursPPRecap_Controller.Question(consentmentAnswers[0],'test');
            system.debug('question '+question);
            Test.stopTest();
        }
    }
    
        @isTest
    public static void testMethod4() {
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_TestQuestionsConsentement');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, multimock);
            List<VI_ParcoursPPRecap_Controller.Question> listquestions=VI_ParcoursPPRecap_Controller.getQuestions('12345');
            Test.stopTest();
        }
    }
    
    @isTest
    public static void test_submitAnswers(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_TestQuestionsConsentement');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, multimock);
            String resp=VI_ParcoursPPRecap_Controller.submitAnswers('123456', 'Oui', 'Non');
            system.assertEquals(resp, 'Success');
            Test.stopTest();
        }
    }
     @isTest
    public static void test_updateAnswers2(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            VI_SM011_ConsentementAnswers_API.consentementAnswer testconsent = new VI_SM011_ConsentementAnswers_API.consentementAnswer( 'id', 12,  1,
                                                                                                                                      'vvv',
                                                                                                                                      2, true,  'canal',  'application',  'dateModification');
                                                                                                                                     
            List<VI_SM011_ConsentementAnswers_API.consentementAnswer> listAnswers=new List<VI_SM011_ConsentementAnswers_API.consentementAnswer>{testconsent};
           
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_TestQuestionsConsentement');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, multimock);
            String resp=VI_ParcoursPPRecap_Controller.updateAnswers('123456', 'Non', 'Oui',listAnswers);
            system.assertEquals(resp, 'Success');
            Test.stopTest();
        }
    }
    
        @isTest
    public static void test_updateAnswers(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            VI_SM011_ConsentementAnswers_API.consentementAnswer testconsent = new VI_SM011_ConsentementAnswers_API.consentementAnswer( 'id', 12,  1,
                                                                                                                                      'vvv',
                                                                                                                                      2, true,  'canal',  'application',  'dateModification');
            VI_SM011_ConsentementAnswers_API.consentementAnswer testconsent2 = new VI_SM011_ConsentementAnswers_API.consentementAnswer( 'id', 12,  1,
                                                                                                                                      'vvv',
                                                                                                                                      3, true,  'canal',  'application',  'dateModification');
            List<VI_SM011_ConsentementAnswers_API.consentementAnswer> listAnswers=new List<VI_SM011_ConsentementAnswers_API.consentementAnswer>{testconsent,testconsent2};
           
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_TestQuestionsConsentement');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, multimock);
            String resp=VI_ParcoursPPRecap_Controller.updateAnswers('123456', 'Non', 'Oui',listAnswers);
            system.assertEquals(resp, 'Success');
            Test.stopTest();
        }
    }
}