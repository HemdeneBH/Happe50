/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_BAT006_MAJContrat
*@CreatedDate: 05/04/2022
*/
@isTest
public class VI_BAT006_MAJContrat_Test {
    @testSetup
    static void testSetup1(){
        MP_Xdata_credentials__c VI_user_tranquility = new MP_Xdata_credentials__c();
        VI_user_tranquility.Value__c = '4bf81dd4-b8ec-4c4b-9c84-8e009d8a2b35';
        VI_user_tranquility.Name = 'VI_user_tranquility';
        insert VI_user_tranquility;
        
        MP_Xdata_credentials__c VI_password_tranquility = new MP_Xdata_credentials__c();
        VI_password_tranquility.Value__c = '868e3fed-b555-4e42-9430-5bc93755ca51';
        VI_password_tranquility.Name = 'VI_password_tranquility';
        insert VI_password_tranquility;
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
        Case casex=new Case(Status='Fermé');
        insert casex;
        VI_Parcours__c parcours=new VI_Parcours__c(VI_AssuranceFactureCocheeAF__c=true,VI_ChoixParcours__c='CHF',VI_TypeParcours__c='PURE PLAYERS',VI_case__c=casex.id,
                                                  vi_contact__c=c.id);
        insert parcours;
    }
    
    @isTest
    static void testBatch(){
        Test.startTest();
        system.debug('Test Start');
        VI_BAT006_MAJContrat.execute();
        system.debug('Test END');
        Test.stopTest();
        VI_parcours__c p=[Select id,VI_Id_Local__c from vi_parcours__c limit 1];
        system.assertEquals('123', p.VI_Id_Local__c);
    }
}