/*
*@Author: Paul Ghousoub
*@Description: Classe test de VI_SM010_PdlGaz.
*@CreatedDate: 04/11/2020
*@LastModified: 05/11/2020
*/
@isTest
public class VI_SM010_PdlGaz_Test { 
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
    static void testCallout() {
        /* Start DDPCM 1319 */
        User u =[Select id 
                 From user 
                 Where firstname='Test' And lastname='Test' And isActive = true And Profile.Name ='VI_PurePlayer'
                 Limit 1];
        /* End DDPCM 1319 */
        System.runAs(u){
            Test.startTest();
            String retour=VI_SM010_PdlGaz.lirePdlV2('21101817097249','SMILE','2.0','callout:AuthOctopus');
            system.assertEquals(retour, null);
            Test.stopTest();
        }
    } 
}