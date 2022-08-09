/*
*@Author: Paul Ghoussoub
*@Description: Classe test de VI_parcoursOptionsEtServices_Controller.
*@CreatedDate: 23/05/2022
*/
@isTest
public class VI_parcoursOptionsEtServices_Test {
    @testSetup
    static void testSetup(){
        List<Group> ownerQueue = [Select Id,DeveloperName from Group where Type = 'Queue'];
        
        MP_Xdata_credentials__c VI_user_tranquility = new MP_Xdata_credentials__c();
        VI_user_tranquility.Value__c = '4bf81dd4-b8ec-4c4b-9c84-8e009d8a2b35';
        VI_user_tranquility.Name = 'VI_user_tranquility';
        insert VI_user_tranquility;
        
        MP_Xdata_credentials__c VI_password_tranquility = new MP_Xdata_credentials__c();
        VI_password_tranquility.Value__c = '868e3fed-b555-4e42-9430-5bc93755ca51';
        VI_password_tranquility.Name = 'VI_password_tranquility';
        insert VI_password_tranquility;
        
        MP_Xdata_credentials__c scope = new MP_Xdata_credentials__c();
        scope.Value__c = 'PCKEY';
        scope.Name = 'VI_ConsumerKeySymphonie';
        insert scope;
        
        MP_Xdata_credentials__c consumerKey = new MP_Xdata_credentials__c();
        consumerKey.Value__c = 'PCVALUE';
        consumerKey.Name = 'VI_ConsumerSecretSymphonie';
        insert consumerKey;

        
        system.debug('query queue '+ownerQueue);
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        acc.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('PartenaireAccountRT').getRecordTypeId();
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        
        VI_ServicePayant__c sp1=new VI_ServicePayant__c(VI_NomDuService__c= 'Assurance Facture',VI_Partenaire__c=acc.id,Canal__c='Pure Player');
        insert sp1;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'TestVI','TestVI');
        insert u;
    }
    
    @isTest
    static void getOptionsEtServicesTest(){
        User u =[Select id from user where firstname='TestVI' and lastname='TestVI' and isActive=true limit 1];
        System.runAs(u){
            Test.startTest();
            VI_Parcours__c parcoursTest = VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            VI_parcoursOptionsEtServices_Controller.OptionsEtServices OptionsEtServices=VI_parcoursOptionsEtServices_Controller.getOptionsEtServices(parcoursTest);
            system.assertEquals(5.00,OptionsEtServices.AssuranceFacturePrixTTC);
            Test.stopTest();
        }
    }
    @isTest
    static void wrapperPromotionTest(){
        VI_parcoursOptionsEtServices_Controller.wrapperPromotion wp=new VI_parcoursOptionsEtServices_Controller.wrapperPromotion(
            'NumPromotion',  'CodePromo',  'LibelleSurFacture',  'NomPromotion', 
            'DescriptifPromotion',  'DebutValidity',  'FinValidity',  'CanalDeVente');
    }
}