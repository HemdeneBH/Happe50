/**
 * @File Name          : HP_WrapperTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 28/04/2020 à 15:24:36
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/04/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@isTest
public class HP_WrapperTest {

@testSetup static void dataSetup(){
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){          
        }
    }

   
 @isTest 
 static void HP_WRP0016_AgilabPersonneTest() {
    System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        HP_WRP0016_AgilabPersonne wp = new HP_WRP0016_AgilabPersonne();
        wp.output = new HP_WRP0016_AgilabPersonne.Output();
        wp.output.id = 12;
        Test.startTest();
        wp.functionalIdHandler();
        Test.stopTest();
    } 
 }
    
@isTest 
 static void HP_WRP0017_DQEemailTest() {
    System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        HP_WRP0017_DQEemail wp = new HP_WRP0017_DQEemail();
        Test.startTest();
        HP_WRP0017_DQEemail.parse('{"CodeActivite": "1"}');
        Test.stopTest();
    }
 }

 @isTest  
 static void HP_WRP0018_DQEtelephoneTest() {
    System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        HP_WRP0018_DQEtelephone wp = new HP_WRP0018_DQEtelephone();
        Test.startTest();
        HP_WRP0018_DQEtelephone.parse('{"Type": "1"}');
        Test.stopTest();
    }
 }

 @isTest
 static void HP_WRP004_AgilabRemboursementTest() {
    System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        HP_WRP004_AgilabRemboursement wp = new HP_WRP004_AgilabRemboursement();
        Test.startTest();
        HP_WRP004_AgilabRemboursement.parse('{"status": "1"}');
        Test.stopTest();
    }
 }

 @isTest
 static void HP_WRP026_AgilabEcheanceTest() {
    System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        HP_WRP026_AgilabEcheance wp = new HP_WRP026_AgilabEcheance();
        Test.startTest();
        HP_WRP026_AgilabEcheance.parse('{"reference": "1"}');
        Test.stopTest();
    }
 }

 @isTest
 static void HP_WRP027_AgilabSoldeTest() {
    System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        HP_WRP027_AgilabSolde wp = new HP_WRP027_AgilabSolde();
        wp.output = new HP_WRP027_AgilabSolde.Output(null);
        Test.startTest();
        HP_WRP027_AgilabSolde.parse('{"status": "1"}');
        Test.stopTest();
    }
 }

@isTest
 static void HP_WRP028_AgilabFacturesTest() {
    System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        HP_WRP028_AgilabFactures wp = new HP_WRP028_AgilabFactures();
        Test.startTest();
        HP_WRP028_AgilabFactures.parse('{"status": "1"}');
        Test.stopTest();
    }
 }
}