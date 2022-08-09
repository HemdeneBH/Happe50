@isTest
public with sharing class SM_ChoixOffre_manager_TEST {
    static testmethod void choixoffredeactivation() {
        Choix_Offre__c choixoffre = new Choix_Offre__c();
        choixoffre.Energie__c = 'Gaz';
        choixoffre.Actif__c = true;
        insert choixoffre;
        Choix_Offre__c choixoffre2 = new Choix_Offre__c();
        choixoffre2.Energie__c = 'Gaz';
        choixoffre2.Actif__c = true;
        insert choixoffre2;
        list<Choix_Offre__c> listchoixOffre = [select id from Choix_Offre__c where Energie__c = 'Gaz' AND Actif__c = true];
        system.assertEquals(listchoixOffre.size(),1);
    }

}