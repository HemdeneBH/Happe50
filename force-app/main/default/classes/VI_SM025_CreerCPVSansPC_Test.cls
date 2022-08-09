/*
*@Author: Eloi Dereeper
*@Description: Classe test de VI_SM025_CreerCPVSansPC
*@CreatedDate: 02/12/2020
*@LastModified: 10/12/2020
*/
@isTest
public class VI_SM025_CreerCPVSansPC_Test {  
    @testSetup
    static void testSetup(){
        List<Group> ownerQueue = [Select Id,DeveloperName from Group where Type = 'Queue'];
        
        system.debug('query queue '+ownerQueue);
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        u.isActive=true;
        insert u;
    }
    @isTest 
    static void SaveCPVTEST_test(){
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            date d=system.today();
            VI_parcours__c parcours = VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            parcours.VI_CodeOptionPanierClient__c = 'code';
            parcours.VI_CodeOptionGazPanierClient__c = 'code';
            parcours.VI_Email_CPV__c='test@test.com';
            parcours.VI_OffreChoisieGazPanierClient__c='GBUKF2';
            parcours.VI_InfosCompl_DateContratEffectif__c=d;
            parcours.VI_OffreChoisieElecPanierClient__c='EBUKF3V100';
            parcours.VI_TechOffreReferenceChoisie__c=true;
            Contact contact = new Contact();
            List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> listcouple=new List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element>();
            VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element element=new VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element();
            listcouple.add(element);
            List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> couplesCodeValeur = VI_SM025_CreerCPVSansPC.createCoupleCodeValeur(parcours, contact, '0000128639',listcouple);
            Test.startTest();
            VI_SM025_CreerCPVSansPC.createCoupleCodeValeurINIT(parcours);
            VI_gdfsuezComBefCalypsoCpvV2.creerCPVSansPCResponse_element elementcpv=VI_SM025_CreerCPVSansPC.creerCPVsansPC('test', 'test', couplesCodeValeur, true, true, 'test', 'test'); 
            VI_SM025_CreerCPVSansPC.retourCPV retour = VI_SM025_CreerCPVSansPC.SaveCPVTEST(parcours, contact, 'test', couplesCodeValeur, 'test', 'test', true, true, 'test', 'test');
            system.assertequals(elementcpv.creerCPVSansPCOutput.documentcree.iddocument,'00MPA2107614245908780000');
            Test.stopTest();
        }
    }
}