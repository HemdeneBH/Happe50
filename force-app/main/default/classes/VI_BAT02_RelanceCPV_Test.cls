/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_BAT02_RelanceCPV
*@CreatedDate: 30/03/2021
*/
@isTest
public class VI_BAT02_RelanceCPV_Test {
  
    @isTest
    static void testBatch(){
        
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        acc.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('PartenaireAccountRT').getRecordTypeId();
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        insert u;
        
        VI_DonneesParcours__c donneesParcours = new VI_DonneesParcours__c(VI_EmailRelanceCPV1__c='Relance des CPV n°1', VI_NomPartenaire__c=acc.Id);
        insert donneesParcours;
        

        
        System.runAs(u){
            Test.startTest();
        
            VI_Parcours__c parcours=VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            parcours.VI_Date_envoi_email__c = system.today().adddays(-1);
            parcours.VI_DateRelanceCPV1__c = system.today();
            parcours.VI_Email_CPV__c = 'clement.bouquin@ei-technologies.com';
        	insert parcours;
        
            VI_BAT02_RelanceCPV.execute();
        
            Test.stopTest();        
            List<VI_Parcours__c> listParcours =[SELECT id, VI_Email_Relance_CPV__c
                                                FROM VI_Parcours__c
                                               	Where VI_Date_envoi_email__c=YESTERDAY AND VI_Email_CPV__c!=NULL];
            system.debug('¤ listParcours '+listParcours);
            if (listParcours.size() > 0) {
                for(VI_Parcours__c p:listParcours){
                    system.assertEquals(donneesParcours.VI_EmailRelanceCPV1__c, p.VI_Email_Relance_CPV__c);
                }
            }
            
            parcours.VI_DateRelanceCPV1__c = system.today()-2;
            parcours.VI_DateRelanceCPV5__c = system.today();
        	update parcours;
            VI_BAT02_RelanceCPV.execute();
        }
    }
}