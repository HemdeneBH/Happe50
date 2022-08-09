@isTest
public class VI_SM037_ComposerMandat_Test {
    @isTest
    static void testComposerMandat(){
        Id contactRTId = Contact.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId();
        Contact parcoursContact =new Contact();
        parcoursContact.firstname='tests';
        parcoursContact.salutation='Mr';
        parcoursContact.lastName='test';
        parcoursContact.Complement_adresse__c='test';
        parcoursContact.MailingPostalCode='test';
        parcoursContact.Mailingcity='test';
        parcoursContact.Mailingcountry='test';
        parcoursContact.recordTypeId=contactRTId;
        
        
        insert parcoursContact;
        VI_Parcours__c parcours =new VI_Parcours__c();
        
        parcours.VI_ID_Mandat__c='2134';
        parcours.VI_IDReferenceClient__c='1234';
        parcours.VI_CiviliteClient__c='Monsieur';
        parcours.VI_NomClient__c='test';
        parcours.VI_PrenomClient__c='test';
        parcours.VI_IDReferenceClient__c='test';
        parcours.VI_Email_CPV__c='test@est.com';
        parcours.VI_Id_coordonnees_bancaires__c='0202000001-01';
        insert parcours;
        Test.startTest();
        VI_SM037_ComposerMandat.retourMandat response=
            VI_SM037_ComposerMandat.composerMandat('MANDAT_POUR_SIGNATURE_ELECTRONIQUE',parcours ,parcoursContact,true,'PP','1.0','callout:VI_AuthOctopus');
        system.assertEquals(response.idDocument,'00MPA2112619234606130000');
        Test.stopTest();
    }
}