/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-27-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class HP_EC_Util_PasswordManager_TEST {
    @TestSetup
    public static void dataSetup(){
        HP_Community_User__c commUser = new HP_Community_User__c(   Username__c = 'email@email.com', 
                                                                    Crypted_Password__c = '',
                                                                    Activation_Key__c = 'av75d4cac9d69404a47a4b05333bbe09e427jhbgd',
                                                                    Reset_Password_Key__c = 'bhy8855d4cac9d69404a47a4b05333bbe0927gd',
                                                                    Salt__c = '123SLT',
                                                                    Name = 'Test Contact',
                                                                    Id_Tiers__c = '100166');
        insert commUser;

        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
            'Id_Tiers__c' => 100166,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'email' => 'email@email.com',
            'mobilePhone' => '0756543434',
            'Phone' => '0145454545',
            'No_Voie__c' => '22',
            'MailingStreet' => 'rue des bois',
            'MailingPostalCode' => '92160',
            'Complement_adresse__c' => 'REZID',
            'MailingCity' =>'ANTONY'
        }, null, null, null);
        insert contact;

        HP_Community_Settings__c settings = HP_Community_Settings__c.getOrgDefaults();
        settings.Issuer__c = '3MVG904d7VkkD2aN_5BfyZl0Kz9sV1ViUEg3QqeC1ASJz783.oct1fHm2VexJIXRvqgixkwgWnFY6nBhhehxR';
        settings.Crypto_Type__c = 'SHA1';
        settings.Certificate__c = 'HappeJWTSignEC';
        settings.Community_Name__c = 'happeportal';
        settings.Community_URL__c = 'https://devhpbh2-engie-dgpfr.cs189.force.com';
        upsert settings HP_Community_Settings__c.Id;
    }

    @IsTest
    static void setPasswordTest(){
        
        Test.startTest();
        HP_EC_Util_PasswordManager.setPassword('av75d4cac9d69404a47a4b05333bbe09e427jhbgd', 'P@ssw0rd');
        Test.stopTest();
        HP_Community_User__c myCommunityUser = [SELECT Id, Crypted_Password__c FROM HP_Community_User__c LIMIT 1];
        System.assert(myCommunityUser.Crypted_Password__c != '','Mot de passe enregistré avec succès');
    }

    @IsTest
    static void setPasswordTestKo(){
        
        Test.startTest();
        Map<String,Object> resultObject = HP_EC_Util_PasswordManager.setPassword('123456', 'P@ssw0rd');
        Test.stopTest();
        System.assert(resultObject.get('success') == false,'Exception catchée');
    }

    @IsTest
    static void resetPasswordTest(){
        HP_Community_User__c myCommunityUser = [SELECT Id, Crypted_Password__c FROM HP_Community_User__c LIMIT 1];
        myCommunityUser.Crypted_Password__c = '123456';
        update myCommunityUser;
        Test.startTest();
        HP_EC_Util_PasswordManager.resetPassword('bhy8855d4cac9d69404a47a4b05333bbe0927gd', 'P@ssw0rd');
        Test.stopTest();
        HP_Community_User__c myCommunityUserUpdated = [SELECT Id, Crypted_Password__c FROM HP_Community_User__c LIMIT 1];
        System.assert(myCommunityUserUpdated.Crypted_Password__c != '123456','Mot de passe mis à jour avec succès');
    }

    @IsTest
    static void resetPasswordTestKo(){
        HP_Community_User__c myCommunityUser = [SELECT Id, Crypted_Password__c FROM HP_Community_User__c LIMIT 1];
        myCommunityUser.Crypted_Password__c = '123456';
        update myCommunityUser;
        Test.startTest();
        Map<String,Object> resultObject = HP_EC_Util_PasswordManager.resetPassword('123456', 'P@ssw0rd');
        Test.stopTest();
        System.assert(resultObject.get('success') == false,'Exception catchée');
    }

    @IsTest
    static void sendResetPasswordTest(){
        Test.startTest();
        Map<String,Object> resultObject = HP_EC_Util_PasswordManager.sendResetPasswordEmail('email@email.com');
        Test.stopTest();
        System.assert(resultObject.get('success') != false ,'Email envoyé avec succès');
    }

    @IsTest
    static void sendResetPasswordTestKo(){
        Test.startTest();
        Map<String,Object> resultObject = HP_EC_Util_PasswordManager.sendResetPasswordEmail('monEmail@email.fr');
        Test.stopTest();
        System.assert(resultObject.get('success') == false ,'Exception catchée');
    }

    @IsTest
    static void reSendActivationEmailTest(){
        Test.startTest();
        Map<String,Object> resultObject = HP_EC_Util_PasswordManager.reSendActivationEmail('email@email.com');
        Test.stopTest();
        System.assert(resultObject.get('success') != false ,'Email envoyé avec succès');
    }

    @IsTest
    static void reSendActivationEmailKo(){
        Test.startTest();
        Map<String,Object> resultObject = HP_EC_Util_PasswordManager.reSendActivationEmail('monEmail@email.fr');
        Test.stopTest();
        System.assert(resultObject.get('success') == false ,'Exception catchée');
    }

    @IsTest
    static void retrieveActivationParamsTest(){
        Test.startTest();
        Map<String,Object> resultObject = HP_EC_Util_PasswordManager.retrieveActivationParams('av75d4cac9d69404a47a4b05333bbe09e427jhbgd');
        Test.stopTest();
        System.assert(resultObject.get('name') == 'Test Contact' ,'Param récupéré avec succès');
        System.assert(resultObject.get('email') == 'email@email.com' ,'Param récupéré avec succès');
    }

    @IsTest
    static void retrieveResetPasswordParamsTest(){
        Test.startTest();
        Map<String,Object> resultObject = HP_EC_Util_PasswordManager.retrieveResetPasswordParams('bhy8855d4cac9d69404a47a4b05333bbe0927gd');
        Test.stopTest();
        System.assert(resultObject.get('name') == 'Test Contact' ,'Param récupéré avec succès');
        System.assert(resultObject.get('email') == 'email@email.com' ,'Param récupéré avec succès');
    }

    @IsTest
    static void retrieveActivationParamsTestKo(){
        Test.startTest();
        Map<String,Object> resultObject = HP_EC_Util_PasswordManager.retrieveActivationParams('123456');
        Test.stopTest();
        System.assert(resultObject.get('error') != null ,'Exception catchée');
    }

    @IsTest
    static void retrieveResetPasswordParamsTestKo(){
        Test.startTest();
        Map<String,Object> resultObject = HP_EC_Util_PasswordManager.retrieveResetPasswordParams('123456');
        Test.stopTest();
        System.assert(resultObject.get('error') != null ,'Exception catchée');
    }

    @IsTest
    static void resetPasswordFromProfileTest(){
        HP_Community_User__c myCommunityUser = [SELECT Id, Id_Tiers__c, Crypted_Password__c FROM HP_Community_User__c LIMIT 1];
        system.debug(' myCommunityUser list ++++>'+myCommunityUser);
        myCommunityUser.Crypted_Password__c = '123456';
        update myCommunityUser;
        Test.startTest();
        HP_EC_Util_PasswordManager.resetPasswordFromProfile('100166', 'P@ssw0rd');
        Test.stopTest();
        HP_Community_User__c myCommunityUserUpdated = [SELECT Id, Crypted_Password__c FROM HP_Community_User__c LIMIT 1];
        System.assert(myCommunityUserUpdated.Crypted_Password__c != '123456','Mot de passe mis à jour avec succès');
    }

    @IsTest
    static void resetPasswordFromProfileTestKo(){
        HP_Community_User__c myCommunityUser = [SELECT Id, Crypted_Password__c FROM HP_Community_User__c LIMIT 1];
        myCommunityUser.Crypted_Password__c = '123456';
        update myCommunityUser;
        Test.startTest();
        Map<String,Object> resultObject = HP_EC_Util_PasswordManager.resetPasswordFromProfile('123456', 'P@ssw0rd');
        Test.stopTest();
        System.assert(resultObject.get('success') == false,'Exception catchée');
    }
}