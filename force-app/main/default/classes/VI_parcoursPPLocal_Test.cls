/*
*@Author: Amal Chreiteh
*@Description: Classe de test de VI_parcoursPPLocal
*@CreatedDate: 18/03/2021
*@LastModified: 18/03/2021
*/


@isTest
public class VI_parcoursPPLocal_Test {
    @testSetup
    static void testSetup(){
        List<Group> ownerQueue = [Select Id,DeveloperName from Group where Type = 'Queue'];
        
        system.debug('query queue '+ownerQueue);
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        acc.VI_TypeParcours__c = 'PURE PLAYERS';
        acc.VI_Type_Enseigne__c='INDIRECTE';
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        u.isActive =true;
        insert u;
    }
    
   @isTest
    static void testMethod1(){
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_AdressesApiService');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json'); 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            List<VI_parcoursPPLocal_Controller.local> localResult=VI_parcoursPPLocal_Controller.searchLocalbyPDLPCE('21101817736807','23198697384673');
            system.debug('localResult '+localResult);
            system.assert(localResult.size()>0);
        }
        Test.stopTest();
        
    }
    @isTest
    static void testMethod2(){
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestIPPTLElec');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            List<VI_SM007_PtLivGaz.cls_data> data=VI_parcoursPPLocal_Controller.getPCE('21101817736807');
            system.assert(data.size()>0);
        }
        Test.stopTest();
    }
    @isTest
    public static void testMethod3() {
        List<String> listt=new List<String>();
        listt.add('element');
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock(); 
        multimock.setStaticResource('VI_TestIPPTLElec');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            List<VI_SM008_PtLivElec.cls_data> data=VI_parcoursPPLocal_Controller.getPDL('23198697384673');
            system.assert(data.size()>0);
        }
        Test.stopTest();        
    }
    
    @isTest
    public static void testMethod4() {
        List<String> listt=new List<String>();
        listt.add('element');
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock(); 
        multimock.setStaticResource('VI_AdressesApiService2');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            
            List<VI_parcoursPPLocal_Controller.local> localResult=VI_parcoursPPLocal_Controller.getPDLPCEFromAdresse('test','test','test','test','test','test');
            system.assert(localResult.size()>0);
            VI_parcoursPPLocal_Controller.getInfosSuppPDLPCEfromAdresse(json.serialize(localResult),0,1);
        }
        Test.stopTest();       
        
    }
    
    
    @isTest
    public static void testMethod5() {
        
        Test.startTest();
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            VI_parcours__c parcours = VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            insert parcours;
            VI_parcoursPPLocal_Controller.updateParcoursLocal('23198697384673','23198697384673','12','Avenue gabriel peri', '91420','91420', 'morangis', true, parcours.Id, 'Recherche du local par adresse');            
            VI_parcoursPPLocal_Controller.updateParcoursLocalNonIdentifie('23198697384673','23198697384673','12','Avenue gabriel peri', '91420','91420', 'morangis', true, parcours.Id, 'Recherche du local par adresse',
                                                                          true,  'nomPredecesseur','Appartement', '2', 'AB',  'indexHP','indexHC',  'indexBase',  'numeroMatricule', 'droiteGauche', true,'LINKY', 'GAZPAR');
            VI_parcours__c parcours1=[Select id,VI_PDLRechercheLocal__c,VI_NumeroRueRechercheLocal__c from VI_parcours__c where id=:parcours.id];
            system.assertEquals(parcours1.VI_PDLRechercheLocal__c,'23198697384673');
            system.assertEquals(parcours1.VI_NumeroRueRechercheLocal__c,'12');
        }
        Test.stopTest();       
        
    }
    
    @isTest
    public static void testMethod6() {
		Test.startTest();
        Contact con =[Select Id, MailingPostalCode, MailingCity, No_Voie__c, MailingStreet from contact where firstname='test' limit 1];
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            VI_parcours__c parcours = VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            parcours.VI_Contact__c = con.Id;
            insert parcours;
            VI_parcoursPPLocal_Controller.contactX conX = new VI_parcoursPPLocal_Controller.contactX(con);
            VI_parcoursPPLocal_Controller.contactX addressContact = VI_parcoursPPLocal_Controller.getSelectedContactAddress(parcours);
        }
        Test.stopTest();
    }
    
}