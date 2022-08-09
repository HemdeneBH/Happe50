/*
*@Author: Paul Ghoussoub
*@Description: Classe de test de VI_SM027_CoordonneesBancaires
*@CreatedDate: 23/02/2021
*/
@isTest
public class VI_SM027_CoordonneesBancaires_Test {
    @testSetup
    static void testSetup(){
        List<Group> ownerQueue = [Select Id,DeveloperName from Group where Type = 'Queue'];
        
        system.debug('query queue '+ownerQueue);
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        /* Start DDPCM 1319 */
        acc.VI_TypeParcours__c = 'PURE PLAYERS';
        acc.VI_Type_Enseigne__c = 'INDIRECTE';
        /* End DDPCM 1319 */
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        insert u;
    }
    @isTest 
    static void testMethod1(){
        /* Start DDPCM 1319 */
        User u =[Select id 
                 From user 
                 Where firstname='Test' And lastname='Test' And isActive = true And Profile.Name ='VI_PurePlayer'
                 Limit 1];
        /* End DDPCM 1319 */
        System.runAs(u){
            Test.startTest();
           List<VI_SM027_CoordonneesBancaires.Coordonnees> liscoor= VI_SM027_CoordonneesBancaires.getCoordonneesBancaires('FR1730002005680000376440G58', 'VI','local.VIToken');
            system.assert(liscoor.size()>0);
            Test.stopTest();
        }
    }
    @isTest 
    static void testMethod2(){
        /* Start DDPCM 1319 */
        User u =[Select id 
                 From user 
                 Where firstname='Test' And lastname='Test' And isActive = true And Profile.Name ='VI_PurePlayer'
                 Limit 1];
        /* End DDPCM 1319 */
        System.runAs(u){
            Test.startTest();
            String coorBanq=VI_SM027_CoordonneesBancaires.getCoordonneesBancairesById('0202000001-01','0202000001-01', 'VI','local.VIToken');
            system.assertEquals(coorBanq,'FR7613335003010497764704742');
            Test.stopTest();
        }
    }
}