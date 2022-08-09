/*
*@Author: Clement Bouquin
*@Description: classe de test de VI_PPButtonImportContact
*@CreatedDate: 19/11/2021
*@LastModified: 19/11/2021
*/

@isTest
public class VI_PPButtonImportContact_Test {
    public static String[] csvFileLines;
    public static Blob csvFileBody;

    @isTest
    static void testmethode1(){
        
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        acc.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('PartenaireAccountRT').getRecordTypeId();
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        insert u;

        String file = 'Salutation;Firstname;Lastname;VI_CodeVendeur__c;VI_Site_Prestataire__c;VI_TypeUtilisateurPartnerCommunity__c;Email;VI_Utilisateur_actif__c\n0120Q0000009xf6QAA;Monsieur;clemiclem10;CRTFG;;0010Q00001J2PirQAF;aBj0Q00000002BoSAI;Conseiller - BO partenaire;paul.ghoussdddoub@eit-mena.com;true\n0120Q0000009xf6QAA;Monsieur;clemiclem11;CRTFG;;0010Q00001J2PirQAF;aBj0Q00000002BoSAI;Conseiller - BO partenaire;paul.ghoussdddoub@eit-mena.com;TRUE\n';       
        
        System.runAs(u){
            Test.startTest();       
            String base64Data = JSON.serialize(file);
            system.assertNotEquals(VI_PPButtonImportContact.saveFile(base64Data), null);
            Test.stopTest();
        }
    }
}