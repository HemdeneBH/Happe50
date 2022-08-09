/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 

 * @last modified on  : 07-09-2021

 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-08-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/


@IsTest
public with sharing class HP_SM048_DedupOrderUpGrade_TEST {
   
    @isTest 

    public static void  insertSave1() {

        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
           
            'Id_Tiers__c' => 100166,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'email' => 'user@example.com',
            'mobilePhone' => '0756543434',
            'Phone' => '0145454545',
            'No_Voie__c' => '22',
            'MailingStreet' => 'rue des bois',
            'MailingPostalCode' => '92160',
            'Complement_adresse__c' => 'REZID',
            'MailingCity' =>'ANTONY'
        }, null, null, null);
        insert contact;


        HP_Souscription__c enrolment1 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Souscription_Digital_Id__c' =>'testGaz-01',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',
            'HP_Statut__c' =>'SAVE_1',
            'HP_Tech_Is_Apex_Processing__c'=> false,
            'HP_Date_Origine__c'  =>System.today(),
            'HP_Type_Energie__c' =>'GAS',
            'HP_Contact__c'=> contact.Id,
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_EnvoyerNotificationClient__c' => true

        }, null);
        insert enrolment1;

        HP_Souscription__c enrolment2 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Souscription_Digital_Id__c' =>'testGaz-02',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',
            'HP_Statut__c' =>'SAVE_1',
            'HP_Tech_Is_Apex_Processing__c'=> false,
            'HP_Date_Origine__c'  =>System.today(),
            'HP_Type_Energie__c' =>'GAS',
            'HP_Contact__c'=> contact.Id,
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_EnvoyerNotificationClient__c' => true


        }, null);
        insert enrolment2;


            final String jobName = 'HP_BAT015_SouscriptionDedupOrderUpgrade';
            final String cronExp = '0 0 23 ? * * *';
            Test.startTest();
            HP_BAT015_SouscriptionDedupOrderUpgrade.launchNewScheduler(cronExp,jobName);
            Test.stopTest();   
       
    }

    @isTest static void launchSave1(){
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
           
            'Id_Tiers__c' => 100166,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'email' => 'user@example.com',
            'mobilePhone' => '0756543434',
            'Phone' => '0145454545',
            'No_Voie__c' => '22',
            'MailingStreet' => 'rue des bois',
            'MailingPostalCode' => '92160',
            'Complement_adresse__c' => 'REZID',
            'MailingCity' =>'ANTONY'
        }, null, null, null);
        insert contact;


        HP_Souscription__c enrolment1 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Souscription_Digital_Id__c' =>'testGaz-01',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',
            'HP_Statut__c' =>'SAVE_1',
            'HP_Tech_Is_Apex_Processing__c'=> false,
            'HP_Date_Origine__c'  =>System.today(),
            'HP_Type_Energie__c' =>'GAS',
            'HP_Contact__c'=> contact.Id,
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_EnvoyerNotificationClient__c' => true


        }, null);
        insert enrolment1;

        HP_Souscription__c enrolment2 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Souscription_Digital_Id__c' =>'testGaz-02',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',
            'HP_Statut__c' =>'SAVE_1',
            'HP_Tech_Is_Apex_Processing__c'=> false,
            'HP_Type_Energie__c' =>'GAS',
            'HP_Contact__c'=> contact.Id,
            'HP_Date_Origine__c'  =>System.today(),
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_EnvoyerNotificationClient__c' => true

        }, null);
        insert enrolment2;

    

        Test.startTest();
        HP_BAT015_SouscriptionDedupOrderUpgrade.execute(Date.Today());
        Test.stopTest();   
    }

    @isTest static void launch_TEST_SAVE2(){

        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
           
            'Id_Tiers__c' => 100166,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'email' => 'user@example.com',
            'mobilePhone' => '0756543434',
            'Phone' => '0145454545',
            'No_Voie__c' => '22',
            'MailingStreet' => 'rue des bois',
            'MailingPostalCode' => '92160',
            'Complement_adresse__c' => 'REZID',
            'MailingCity' =>'ANTONY'
        }, null, null, null);
        insert contact;


        HP_Souscription__c enrolment1 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Souscription_Digital_Id__c' =>'testGaz-01',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',

            'HP_Statut__c' =>'SAVE_2',

            'HP_Tech_Is_Apex_Processing__c'=> false,
            'HP_Date_Origine__c'  =>System.today(),
            'HP_Type_Energie__c' =>'GAS',
            'HP_Contact__c'=> contact.Id,
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_EnvoyerNotificationClient__c' => true


        }, null);
        insert enrolment1;

        HP_Souscription__c enrolment2 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Souscription_Digital_Id__c' =>'testGaz-02',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',

            'HP_Statut__c' =>'SAVE_2',

            'HP_Tech_Is_Apex_Processing__c'=> false,
            'HP_Type_Energie__c' =>'GAS',
            'HP_Contact__c'=> contact.Id,
            'HP_Date_Origine__c'  =>System.today(),
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_EnvoyerNotificationClient__c' => true

        }, null);
        insert enrolment2;

    

        Test.startTest();
        HP_BAT015_SouscriptionDedupOrderUpgrade.execute(Date.Today());
        Test.stopTest();   
    }


    @isTest static void launch_TEST_SAVE_3(){

        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
           
            'Id_Tiers__c' => 100166,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'email' => 'user@example.com',
            'mobilePhone' => '0756543434',
            'Phone' => '0145454545',
            'No_Voie__c' => '22',
            'MailingStreet' => 'rue des bois',
            'MailingPostalCode' => '92160',
            'Complement_adresse__c' => 'REZID',
            'MailingCity' =>'ANTONY'
        }, null, null, null);
        insert contact;


        HP_Souscription__c enrolment1 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Souscription_Digital_Id__c' =>'testGaz-01',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',

            'HP_Statut__c' =>'SAVE_3',

            'HP_Tech_Is_Apex_Processing__c'=> false,
            'HP_Date_Origine__c'  =>System.today(),
            'HP_Type_Energie__c' =>'GAS',
            'HP_Contact__c'=> contact.Id,
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_EnvoyerNotificationClient__c' => true


        }, null);
        insert enrolment1;

        HP_Souscription__c enrolment2 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Souscription_Digital_Id__c' =>'testGaz-02',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',

            'HP_Statut__c' =>'SAVE_3',

            'HP_Tech_Is_Apex_Processing__c'=> false,
            'HP_Type_Energie__c' =>'GAS',
            'HP_Contact__c'=> contact.Id,
            'HP_Date_Origine__c'  =>System.today(),
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_EnvoyerNotificationClient__c' => true

        }, null);
        insert enrolment2;

    

        Test.startTest();
        HP_BAT015_SouscriptionDedupOrderUpgrade.execute(Date.Today());
        Test.stopTest();   
    }




    @isTest static void populateMapContainsKey(){

        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
           
            'Id_Tiers__c' => 100166,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'email' => 'user@example.com',
            'mobilePhone' => '0756543434',
            'Phone' => '0145454545',
            'No_Voie__c' => '22',
            'MailingStreet' => 'rue des bois',
            'MailingPostalCode' => '92160',
            'Complement_adresse__c' => 'REZID',
            'MailingCity' =>'ANTONY'
        }, null, null, null);
        insert contact;


        HP_Souscription__c enrolment1 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Souscription_Digital_Id__c' =>'testGaz-01',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',
            'HP_Statut__c' =>'SAVE_3',
            'HP_Tech_Is_Apex_Processing__c'=> false,
            'HP_Date_Origine__c'  =>System.today(),
            'HP_Type_Energie__c' =>'GAS',
            'HP_Contact__c'=> contact.Id,
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_EnvoyerNotificationClient__c' => true


        }, null);
        insert enrolment1;

        HP_Souscription__c enrolment2 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {

            'HP_Souscription_Digital_Id__c' =>'testGaz-02_map',

            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',
            'HP_Statut__c' =>'SAVE_3',
            'HP_Tech_Is_Apex_Processing__c'=> false,
            'HP_Type_Energie__c' =>'GAS',
            'HP_Contact__c'=> contact.Id,
            'HP_Date_Origine__c'  =>System.today(),
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_EnvoyerNotificationClient__c' => true

        }, null);
        insert enrolment2;


        Map<String,List<HP_souscription__c>> canceledSouscriptionMap =  new Map<String,List<HP_souscription__c>>();
        List<HP_souscription__c> listSouscription = new     List<HP_souscription__c>();
        listSouscription = [select id,HP_TECH_FormulaEnergyPDLPCEConcatField__c, HP_Contact__c from HP_Souscription__c where HP_Souscription_Digital_Id__c =:'testGaz-02_map'];
        HP_souscription__c sousc =  [select id,HP_TECH_FormulaEnergyPDLPCEConcatField__c, HP_Contact__c from HP_Souscription__c where HP_Souscription_Digital_Id__c =:'testGaz-02_map' limit 1];
       canceledSouscriptionMap.put(sousc.HP_TECH_FormulaEnergyPDLPCEConcatField__c,listSouscription);
        Test.startTest();
        HP_SM048_SouscriptionDedupOrderUpGrade.populateMap(sousc,canceledSouscriptionMap);
        Test.stopTest();   
    }
    @isTest static void populateMapNoKey(){
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
           
            'Id_Tiers__c' => 100166,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'email' => 'user@example.com',
            'mobilePhone' => '0756543434',
            'Phone' => '0145454545',
            'No_Voie__c' => '22',
            'MailingStreet' => 'rue des bois',
            'MailingPostalCode' => '92160',
            'Complement_adresse__c' => 'REZID',
            'MailingCity' =>'ANTONY'
        }, null, null, null);
        insert contact;

        HP_Souscription__c enrolment2 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Souscription_Digital_Id__c' =>'testGaz-00_map',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',
            'HP_Statut__c' =>'SAVE_3',
            'HP_Tech_Is_Apex_Processing__c'=> false,
            'HP_Type_Energie__c' =>'GAS',
            'HP_Contact__c'=> contact.Id,
            'HP_Date_Origine__c'  =>System.today(),
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_EnvoyerNotificationClient__c' => true

        }, null);
        insert enrolment2;
       
        Map<String,List<HP_souscription__c>> canceledSouscriptionMap =  new Map<String,List<HP_souscription__c>>();
        HP_souscription__c sousc =  [select id,HP_TECH_FormulaEnergyPDLPCEConcatField__c, HP_Contact__c from HP_Souscription__c where HP_Souscription_Digital_Id__c =:'testGaz-00_map' limit 1];
   
        Test.startTest();
        HP_SM048_SouscriptionDedupOrderUpGrade.populateMap(sousc,canceledSouscriptionMap);

        Test.stopTest();   
    }

    


}