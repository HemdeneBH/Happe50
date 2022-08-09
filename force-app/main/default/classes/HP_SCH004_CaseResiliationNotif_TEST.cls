/**
 * @File Name          : HP_SCH004_CaseResiliationNotification_TEST.cls
 * @Description        : 
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 25/06/2020 à 14:03:22
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    25/06/2020   Sara El-Hannaoui     Initial Version
**/
@IsTest
global with sharing class HP_SCH004_CaseResiliationNotif_TEST {

    
    @testSetup static void dataSetup(){
        HP_Contrat__c contrat = (HP_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', null, new Map<String, Object>{
            'HP_Contrat_XdataId__c' => 282535
            }, null, null, null);
        insert contrat;

        Prestation_distributeur__c testpresta = (Prestation_distributeur__c)HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c', 'HP_PrestationDistributeur', new Map<String, Object>{
            'Numero_PDL_PCE__c' => '230492038433',
            'Statut__c' => 'En cours',
            'Secteur_activite__c' => 'Gaz',
            'Numero_affaire_distributeur__c' => 'QL30DPC4',
            'HP_Contrat__c' => contrat.Id,
            'HP_TECH_toNotify__c' => true
        }, null, null, null);
        insert testpresta;
    
    }

    @isTest static void launchNewScheduler_TEST(){
            Test.startTest();
            HP_SCH004_CaseResiliationNotification.launchNewScheduler();
            Test.stopTest();
            System.assertEquals(2, [Select count() from AsyncApexJob],'job executed');

    }
    
   
}