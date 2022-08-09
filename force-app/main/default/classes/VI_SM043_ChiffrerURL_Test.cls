/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_SM043_ChiffrerURL
*@CreatedDate: 7/9/2021
*/
@isTest
public class VI_SM043_ChiffrerURL_Test {
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
        insert u;
    }
    
	@isTest
    static void testChiffreChaine(){
        User u =[Select id from user where firstname='Test' and lastname='Test' limit 1];
        System.runAs(u){
            Test.startTest();
            VI_SM043_ChiffrerURL.ChiffrerChaine(
                'test','callout:VI_AuthOctopus','VI','V1' );
            test.stopTest();
        }
    }
    @isTest
    static void VI_gdfsuezComBefChpPivotChiffrementTest(){
        VI_gdfsuezComBefChpPivotChiffrement.sortDt sortDt=new VI_gdfsuezComBefChpPivotChiffrement.sortDt();
        VI_gdfsuezComBefChpPivotChiffrement.field_element field_element=new VI_gdfsuezComBefChpPivotChiffrement.field_element();
        VI_gdfsuezComBefChpPivotChiffrement.system_element system_element=new VI_gdfsuezComBefChpPivotChiffrement.system_element();
        VI_gdfsuezComBefChpPivotChiffrement.paginationDt paginationDt=new VI_gdfsuezComBefChpPivotChiffrement.paginationDt();
        VI_gdfsuezComBefChpPivotChiffrement.retourTraitementMessageDt retourTraitementMessageDt=new VI_gdfsuezComBefChpPivotChiffrement.retourTraitementMessageDt();
        VI_gdfsuezComBefChpPivotChiffrement.retourTraitementMessagesDt retourTraitementMessagesDt=new VI_gdfsuezComBefChpPivotChiffrement.retourTraitementMessagesDt();
        VI_gdfsuezComBefChpPivotChiffrement.messageRetour_element messageRetour_element=new VI_gdfsuezComBefChpPivotChiffrement.messageRetour_element();
        VI_gdfsuezComBefChpPivotChiffrement.refPersonneCreerDt refPersonneCreerDt=new VI_gdfsuezComBefChpPivotChiffrement.refPersonneCreerDt();
        VI_gdfsuezComBefChpPivotChiffrement.horodatageSimpleDt horodatageSimpleDt=new VI_gdfsuezComBefChpPivotChiffrement.horodatageSimpleDt();
        VI_gdfsuezComBefChpPivotChiffrement.refPersonneLireDt refPersonneLireDt=new VI_gdfsuezComBefChpPivotChiffrement.refPersonneLireDt();
        VI_gdfsuezComBefChpPivotChiffrement.Dates_element Dates_element=new VI_gdfsuezComBefChpPivotChiffrement.Dates_element();
        VI_gdfsuezComBefChpPivotChiffrement.messageRetoursDt messageRetoursDt=new VI_gdfsuezComBefChpPivotChiffrement.messageRetoursDt();
        VI_gdfsuezComBefChpPivotChiffrement.systemPath_element systemPath_element=new VI_gdfsuezComBefChpPivotChiffrement.systemPath_element();
        VI_gdfsuezComBefChpPivotChiffrement.listeValeursParticulieresDt listeValeursParticulieresDt=new VI_gdfsuezComBefChpPivotChiffrement.listeValeursParticulieresDt();
        VI_gdfsuezComBefChpPivotChiffrement.refPersonneMAJDt refPersonneMAJDt=new VI_gdfsuezComBefChpPivotChiffrement.refPersonneMAJDt();
        VI_gdfsuezComBefChpPivotChiffrement.intervalleDt intervalleDt=new VI_gdfsuezComBefChpPivotChiffrement.intervalleDt();
        VI_gdfsuezComBefChpPivotChiffrement.valeur_element valeur_element=new VI_gdfsuezComBefChpPivotChiffrement.valeur_element();
        VI_gdfsuezComBefChpPivotChiffrement.searchControlRequestHeaderDt searchControlRequestHeaderDt=new VI_gdfsuezComBefChpPivotChiffrement.searchControlRequestHeaderDt();
        VI_gdfsuezComBefChpPivotChiffrement.horodatageDt horodatageDt=new VI_gdfsuezComBefChpPivotChiffrement.horodatageDt();
        VI_gdfsuezComBefChpPivotChiffrement.listeValeursDt listeValeursDt=new VI_gdfsuezComBefChpPivotChiffrement.listeValeursDt();
        VI_gdfsuezComBefChpPivotChiffrement.contextDt contextDt=new VI_gdfsuezComBefChpPivotChiffrement.contextDt();
        VI_gdfsuezComBefChpPivotChiffrement.searchControlRequestDt searchControlRequestDt=new VI_gdfsuezComBefChpPivotChiffrement.searchControlRequestDt();

    }
}