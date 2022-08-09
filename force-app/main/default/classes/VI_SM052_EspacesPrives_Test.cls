/*
*@Author: Paul Ghoussoub
*@Description: Classe de test de VI_SM052_EspacesPrives
*@CreatedDate: 11/05/22
*@LastModified: 11/05/22
*/
@isTest
public class VI_SM052_EspacesPrives_Test {
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
        scope.Name = 'VI_consumerKeyAPIGEE_B2C';
        insert scope;
        
        MP_Xdata_credentials__c consumerKey = new MP_Xdata_credentials__c();
        consumerKey.Value__c = 'PCVALUE';
        consumerKey.Name = 'VI_consumerSecretAPIGEE_B2C';
        insert consumerKey;
    }
    
    @isTest
    public static void creerEspacePrive_test1() {
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_EspacesPrives_Mock');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, multimock);
            VI_SM052_EspacesPrives.Response resp=VI_SM052_EspacesPrives.creerEspaceClient('test','test','test','test','test','VI','local.VIToken');
            system.assertEquals(resp.statusCreation,'EXISTANT');
            Test.stopTest();
        }
    }
}