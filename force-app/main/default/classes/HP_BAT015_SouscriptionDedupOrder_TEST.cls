/**
 * @description  : 
 * @author       : Ali AJELLAL
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   04-12-2020   Ali AJELLAL   Initial Version
**/
@isTest 
global  class HP_BAT015_SouscriptionDedupOrder_TEST {
  
    @testSetup static void dataSetup(){
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{

                'Id_Tiers__c' => 100166,

                'HP_IsHappe__c' => true,
                'Salutation'=>'MR',
                'lastName' => 'testnicot',
                'firstName' => 'lenfant',
                'Email'=>'test@email.com',
                'mobilePhone' => '0756543434',
                'Phone' => '0145454545',
                'No_Voie__c' => '22',
                'MailingStreet' => 'rue des bois',
                'MailingPostalCode' => '92160',
                'Complement_adresse__c' => 'REZID',
                'MailingCity' =>'ANTONY'
            },null, null, null);
            insert contact;
    
            HP_Souscription__c enrolment1 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
                'HP_Souscription_Digital_Id__c' =>'testGaz-01',
                'HP_type_Souscription__c' =>'MOVING_IN',
                'HP_NumberPCE__c' =>'31431211214068',
                'HP_Statut__c' =>'SAVE_2',
                'HP_Tech_Is_Apex_Processing__c'=> false,
                'HP_Type_Energie__c' =>'GAS',
                'HP_Date_Origine__c' => System.now(),
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
                'HP_Date_Origine__c' => System.now(),
                'HP_Contact__c'=> contact.Id,
                'HP_Plan_de_Prix_electrique__c' =>'BASE',
                'HP_EnvoyerNotificationClient__c' => true
            }, null);
            insert enrolment2;

        }   
    }


     @isTest static void launch_TEST(){ 
        
        final String jobName = 'HP_BAT015_SouscriptionDedupOrder';
        final String cronExp = '0 0 23 ? * * *';
        Test.startTest();
        HP_BAT015_SouscriptionDedupOrder.launchNewScheduler(cronExp,jobName);
        Test.stopTest();   
    }


    @isTest static void launch_TEST2(){
        Test.startTest();
        HP_BAT015_SouscriptionDedupOrder.execute(Date.Today());
        Test.stopTest();   
    }


    




}