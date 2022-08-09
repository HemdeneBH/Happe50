/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-14-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest  
public with sharing class HP_SM071_Consentement_TEST {
    @testSetup 
        static void dataSetup(){
                Account acc = (Account)HP_UTIL_SmartFactory.createSObject('Account','HP_Account' ,new Map<String, Object>{
                    'HP_XDataExternalId__c' => 100166,
                    'Name' => 'UnitTest',
                    'OwnerId' => UserInfo.getUserId()
                },null,null, null);
                insert acc;
                
                Contact acontact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
                    'AccountId' => acc.Id,
                    'HP_IsHappe__c'=> true,
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
                    'MailingCity' =>'ANTONY',
                    'OwnerId' => UserInfo.getUserId()
                }, null, null, null);
                insert acontact;
            }
    @isTest     
    public static void consentementCreationTest() {
        
        Contact c = [SELECT Id FROM Contact Limit 1 ];
    	HP_SM071_Consentement.createConsentement(c, True, 1234567, 1,1,'CRM','WEB'); 

        
    }
}