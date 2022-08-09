/*
*@Author: Paul Ghoussoub
*@Description: Classe de test de VI_SM051_Promobox
*@CreatedDate: 14/04/22
*@LastModified: 14/04/22
*/
@isTest
public class VI_SM051_Promobox_Test {
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
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        u.isActive=true;
        insert u;
        
        MP_Xdata_credentials__c scope = new MP_Xdata_credentials__c();
        scope.Value__c = 'PCKEY';
        scope.Name = 'VI_ConsumerKeySymphonie';
        insert scope;
        
        MP_Xdata_credentials__c consumerKey = new MP_Xdata_credentials__c();
        consumerKey.Value__c = 'PCVALUE';
        consumerKey.Name = 'VI_ConsumerSecretSymphonie';
        insert consumerKey;
    }
    
    @isTest
    public static void recupererCodePromo_test1() {
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            VI_parcours__c parcours =new VI_parcours__c();
            parcours.VI_TypeParcours__c='PURE PLAYERS';
            insert parcours;
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_Promobox_Mock');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, multimock);
            List<VI_SM051_Promobox.Promotion> listPromos=VI_SM051_Promobox.recupererCodePromo(parcours,'DGBUIEBUI1VGO_P','EBUI1I','GBUI1I','VI','local.VIToken');
            system.assert(listPromos.size()>0);
            Test.stopTest();
        }
    }
    
    @isTest
    public static void recupererCodePromo_test2() {
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            VI_parcours__c parcours =new VI_parcours__c();
            parcours.VI_TypeParcours__c='PURE PLAYERS';
            insert parcours;
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_Promobox_Mock');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, multimock);
            VI_SM051_Promobox.recupererCodePromo(parcours,'DGBUIEBUI1VGO_P','EBUI1I','GBUI1I','VI','local.VIToken');
            parcours.VI_ChoixParcours__c='CHF';
            parcours.VI_ChoixEnergie__c='Electricité';
            parcours.VI_ChoixEstimation__c='Estimer la consommation d\'énergie';
            VI_SM051_Promobox.recupererCodePromo(parcours,'DGBUIEBUI1VGO_P','EBUI1I','GBUI1I','VI','local.VIToken');
            parcours.VI_ChoixParcours__c='EM';
            parcours.VI_ChoixEnergie__c='Gaz';
            parcours.VI_ChoixEstimation__c='Saisir la consommation d\'énergie';
            VI_SM051_Promobox.recupererCodePromo(parcours,'DGBUIEBUI1VGO_P','EBUI1I','GBUI1I','VI','local.VIToken');
            Test.stopTest();
        }
    }
}