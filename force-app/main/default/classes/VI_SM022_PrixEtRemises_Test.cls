@isTest
public class VI_SM022_PrixEtRemises_Test {
    @testSetup
    static void testSetup(){
        List<Group> ownerQueue = [Select Id,DeveloperName from Group where Type = 'Queue'];
        
        system.debug('query queue '+ownerQueue);
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        u.isActive=true;
        insert u;
    }
    
    @isTest
    static void test_RechercherPrixEtRemises(){
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            Test.startTest();
            VI_gdfsuezComBefChpCommunV3.contextDt contextt =VI_SM022_PrixEtRemises.initContext('SMILE','2.0');
            system.assertequals(contextt.version,'2.0');
            system.debug('contextt '+contextt.version);
            VI_gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort portt=VI_SM022_PrixEtRemises.initPort('callout:VI_AuthOctopus');
            system.assertequals(portt.endpoint_x,'callout:VI_AuthOctopus/ES-PrixEtRemises_v2');
            List<String> listString =new List<String>();
            listString.add('test');
            Datetime dt=datetime.newInstance(2013, 4, 1, 0, 0, 0);
            VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt input=VI_SM022_PrixEtRemises.createInputV2('test','test','test','test',listString,'test','test','test','test','test','test',5,5,'test','test',5,
                                                                                                                          listString,dt,dt,dt,'test','test','test',dt,'test','test'
                                                                                                                         );
            system.assertEquals(input.idpack,'test');
            List<VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt> testList=new List<VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt>();
            testList.add(input);
            VI_SM022_PrixEtRemises.recherchePrixetRemise(testList,'test','test','test');
            test.stopTest();
        }
    }
    
    
    @isTest
    static void test_RechercherPrixEtRemisesElec(){
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            Test.startTest();
            Datetime dt=datetime.newInstance(2013, 4, 1, 0, 0, 0);
            VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt input=VI_SM022_PrixEtRemises.createInputPrixEtServices('test',dt,dt,'CHF','SIMPLE', '9');
            system.assertEquals(input.idoffre,'test');
            test.stopTest();
        }
    }
    @isTest
    static void test_RechercherPrixEtRemisesGaz(){
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            Test.startTest();
            Datetime dt=datetime.newInstance(2013, 4, 1, 0, 0, 0);
            VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt input=VI_SM022_PrixEtRemises.createInputPrixEtServicesGaz('test',dt,dt,'CHF','6000', '19');
            system.assertEquals(input.idoffre,'test');
            test.stopTest();
        }
    }
    
    
    @isTest
    static void test_recherchePrixetService(){
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            Test.startTest();
            VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt input= new VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt();
            VI_SM022_PrixEtRemises.recherchePrixetService(input,'test','test','test');
            test.stopTest();
        }
    }
}