/*
*@Author: Clement Bouquin
*@Description: Classe test de VI_SM042_AssuranceFacture.
*@CreatedDate: 30/08/2021
*@LastModified: 30/08/2021
*/
@isTest 
public class VI_SM042_AssuranceFacture_Test {
    @testSetup 
    static void testSetup(){ 
        MP_Xdata_credentials__c VI_user_tranquility = new MP_Xdata_credentials__c();
        VI_user_tranquility.Value__c = '4bf81dd4-b8ec-4c4b-9c84-8e009d8a2b35';
        VI_user_tranquility.Name = 'VI_user_tranquility';
        insert VI_user_tranquility;
        
        MP_Xdata_credentials__c VI_password_tranquility = new MP_Xdata_credentials__c();
        VI_password_tranquility.Value__c = '868e3fed-b555-4e42-9430-5bc93755ca51';
        VI_password_tranquility.Name = 'VI_password_tranquility';
        insert VI_password_tranquility;

    }
    
    @isTest
    public static void testOffresAvailables(){
        
        Test.startTest();
        VI_SM042_AssuranceFacture.cls_offreList offreARetourner = VI_SM042_AssuranceFacture.getOffresAvailables('127','avenue Simon Bolivar', '75019', 'Paris','', '', '', '', 'VI', '', '', 'ParterCom');
        system.assertNotEquals(offreARetourner, null);
        System.assertEquals(offreARetourner.idOffre, 'AF1');
        System.assertEquals(offreARetourner.libelle, 'Assurance facture');
        System.assertEquals(offreARetourner.prixAn, '60.00');
        Test.stopTest();
    }
    
    @isTest
    public static void testResponseAddContratTranquility(){
        
        
        
        Contact c = new Contact(LastName='test', FirstName='test', Salutation='Mr', Id_Tiers__c=100166,
                                  No_Voie__c='127', MailingStreet='Avenue Simon Bolivar', MailingPostalCode='75019', MailingCity='Paris', Complement_adresse__c='');
        insert c;
        
        VI_Parcours__c parcours =  VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
        parcours.VI_Contact__c=c.id;
        insert parcours;
        
        Test.startTest();
        VI_SM042_AssuranceFacture.getResponseAddContratTranquility(parcours.id, '', 'ParterCom');
        Test.stopTest();
    }
    
    @isTest
    public static void testResponseEditContratTranquility(){
        
        
        
        Contact c = new Contact(LastName='test', FirstName='test', Salutation='Mr', Id_Tiers__c=100166,
                                  No_Voie__c='127', MailingStreet='Avenue Simon Bolivar', MailingPostalCode='75019', MailingCity='Paris', Complement_adresse__c='');
        insert c;
        
        VI_Parcours__c parcours =  VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
        parcours.VI_Contact__c=c.id;
        insert parcours;
        
        Test.startTest();
        VI_SM042_AssuranceFacture.getResponseEditContratTranquility(parcours.id,'2','2', '', 'ParterCom');
        Test.stopTest();
    }
    
}