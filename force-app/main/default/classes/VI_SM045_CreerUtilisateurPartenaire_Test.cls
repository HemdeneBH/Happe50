@isTest
public class VI_SM045_CreerUtilisateurPartenaire_Test {
    @testSetup
    static void testSetup(){
        Id partnerRecordTypeid=VI_ObjectUtils.getRecordTypeId('Contact','PartenaireContactRT');
        Id partnerAccountRecordTypeid=VI_ObjectUtils.getRecordTypeId('Account','PartenaireAccountRT');
        Account acc = VI_TestUtility.createAccount('Marketshot2');
        acc.RecordTypeId=partnerAccountRecordTypeid;
        insert acc;
        VI_Site_Prestataire__c sitePresta=new VI_Site_Prestataire__c(VI_Type__c='Externe',name='testPresta2',VI_Nom_du_partenaire__c=acc.id);       
        insert sitePresta;
        Contact c=new Contact(RecordTypeId=partnerRecordTypeid,Salutation='Monsieur',FirstName='test2',LastName='test2',Email='tes2@test2.com',AccountId=acc.id,
                              VI_Site_Prestataire__c=sitePresta.id);
        insert c;
    }
    @isTest static void testInsert(){
        Id partnerRecordTypeid=VI_ObjectUtils.getRecordTypeId('Contact','PartenaireContactRT');
        Id partnerAccountRecordTypeid=VI_ObjectUtils.getRecordTypeId('Account','PartenaireAccountRT');
        Account acc = VI_TestUtility.createAccount('Marketshot');
        acc.RecordTypeId=partnerAccountRecordTypeid;
        insert acc;
        VI_Site_Prestataire__c sitePresta=new VI_Site_Prestataire__c(VI_Type__c='Externe',name='testPresta',VI_Nom_du_partenaire__c=acc.id);       
        insert sitePresta;
        Contact c=new Contact(RecordTypeId=partnerRecordTypeid,Salutation='Monsieur',FirstName='test1',LastName='test1',Email='test@test.com',AccountId=acc.id,
                              VI_Site_Prestataire__c=sitePresta.id);
        Test.startTest();
        insert c;
        Test.stopTest();
    }
    @isTest static void testUpdate(){
        Contact c=[SELECT id from contact where firstname='test2' limit 1];
        c.FirstName='test3';
        Test.startTest();
        update c;
        Test.stopTest();
    }
}