/*
*@Author: Clément Bouquin
*@Description: Classe test de CaseHandler.
*@CreatedDate: 07/10/2021
*@LastModified: 07/10/2021
*/
@isTest 
public class VI_SM046_ParcoursBeforeUpdateHandlerTest {
    
    @isTest
    public static void ParcoursBeforeUpdateTest() {
        
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        acc.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('PartenaireAccountRT').getRecordTypeId();
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        insert u;
        
        VI_DonneesParcours__c donneesParcours = new VI_DonneesParcours__c(VI_RelanceCPV1_J__c=1, VI_RelanceCPV2_J__c=2, VI_RelanceCPV3_J__c=3, VI_RelanceCPV4_J__c=5, VI_RelanceCPV5_J__c=10, VI_NomPartenaire__c=acc.Id);
        insert donneesParcours;
        
        System.runAs(u){
            Test.startTest();
            
            VI_Parcours__c parcours=VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
        	insert parcours;
            
            parcours.VI_Date_envoi_email__c=system.today();
            update parcours;
            
            vi_parcours__c test = [select ID, VI_DateRelanceCPV1__c, VI_DateRelanceCPV2__c, VI_DateRelanceCPV3__c, VI_DateRelanceCPV4__c, VI_DateRelanceCPV5__c from vi_parcours__c where id=:parcours.id limit 1];
            
            system.assertEquals(test.VI_DateRelanceCPV1__c, system.today().adddays(donneesParcours.VI_RelanceCPV1_J__c.intValue()));
            system.assertEquals(test.VI_DateRelanceCPV2__c, system.today().adddays(donneesParcours.VI_RelanceCPV2_J__c.intValue()));
            system.assertEquals(test.VI_DateRelanceCPV3__c, system.today().adddays(donneesParcours.VI_RelanceCPV3_J__c.intValue()));
            system.assertEquals(test.VI_DateRelanceCPV4__c, system.today().adddays(donneesParcours.VI_RelanceCPV4_J__c.intValue()));
            system.assertEquals(test.VI_DateRelanceCPV5__c, system.today().adddays(donneesParcours.VI_RelanceCPV5_J__c.intValue()));
        }
    }
}