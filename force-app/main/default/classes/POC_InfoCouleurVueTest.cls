/**
 * @File Name          : POC_InfoCouleurVueTest.cls
 * @Description        : Classe de test de la classe "POC_InfoCouleurVue"
 * @Author             : Jihad AZAMI HASSANI
 * @Ticket             : FT2-277, FT2-289, FT2-291/ Sprint 10
 * Ver       Date            Author      		    Modification
 * 1.0    05/03/2020   Jihad AZAMI HASSANI     Initial Version
**/
@isTest
public class POC_InfoCouleurVueTest {
        //Test Variable get;set -- Controller -- Action vf
    @isTest private static void testAutoRun() {
        test.startTest();
        PageReference pageRef = Page.DejaLuVFP;
        InfoCouleur__c c = new InfoCouleur__c(name='test', Couleur__c='Rouge');
        insert c;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',c.id);
        ApexPages.StandardController sc = new ApexPages.standardController(c);
        POC_InfoCouleurVue  controller = new POC_InfoCouleurVue(sc);
        controller.InfoCouleurVue();
        test.stopTest();
    }
        //Test methode viewBy
    @isTest static void testcreateViewBy() {
          InfoCouleur__c ic = new InfoCouleur__c(name='test', Couleur__c='Rouge');
          insert ic;     
          String ViewBy = POC_InfoCouleurVue.createViewBy(ic.id);
        }
    @isTest static void testcreateViewBy1() {
          String userId = UserInfo.getUserId();
          InfoCouleur__c ic2 = new InfoCouleur__c(name='test', Couleur__c='Rouge');
          insert ic2;
          Nombre_de_vue__c nbrv = new Nombre_de_vue__c(User__c=userId, Info_Couleur__c=ic2.id,Nombre_de_vue__c=1);
          insert nbrv;      
          String ViewBy = POC_InfoCouleurVue.createViewBy(ic2.id);
        }
}