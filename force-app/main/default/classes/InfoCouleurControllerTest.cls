/**
 * @File Name          : InfoCouleurControllerTest.cls
 * @Description        : Class de test de la classe InfoCouleurController
 * @Author             : Jihad AZAMI HASSANI
 * @Ticket             : FT2-277, FT2-289, FT2-291/ Sprint 10
 * Ver       Date            Author      		    Modification
 * 1.0    05/03/2020   Jihad AZAMI HASSANI     Initial Version
**/
@isTest
public class InfoCouleurControllerTest {
    //Test methode getInfoCouleur
    @isTest static void testgetInfoCouleur() {
          List<InfoCouleur__c> listInfoCouleur = InfoCouleurController.getInfoCouleur();
        }

    //Test methode getCarousel
    @isTest static void testgetCarousel() {
      Boolean isCarousel = InfoCouleurController.getCarousel();
    }

    //Test methode getNbreInfoCouleur
    @isTest static void testgetNbreInfoCouleurRouge() {
          Integer nbreInfocouleur = InfoCouleurController.getNbreInfoCouleurRouge();
        }
    @isTest static void testgetNbreInfoCouleurBleu() {
          Integer nbreInfocouleur = InfoCouleurController.getNbreInfoCouleurBleu();
        }
    @isTest static void testgetNbreInfoCouleurViolette() {
          Integer nbreInfocouleur = InfoCouleurController.getNbreInfoCouleurViolette();
        }
    //Test methode createViewBy
    @isTest static void testcreateViewBy() {
          InfoCouleur__c ic = new InfoCouleur__c(name='test', Couleur__c='Rouge');
          insert ic;     
          Nombre_de_vue__c ViewBy = InfoCouleurController.createViewBy(ic.id);
        }
    @isTest static void testcreateViewBy1() {
          String userId = UserInfo.getUserId();
          InfoCouleur__c ic2 = new InfoCouleur__c(name='test', Couleur__c='Bleue');
          insert ic2;
          Nombre_de_vue__c nbrv = new Nombre_de_vue__c(User__c=userId, Info_Couleur__c=ic2.id,Nombre_de_vue__c=1);
          insert nbrv;      
          Nombre_de_vue__c ViewBy = InfoCouleurController.createViewBy(ic2.id);
        }
}