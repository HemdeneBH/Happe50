/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-26-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class HP_EC_Util_PasswordManager {
    private static final String HASH_TYPE ='SHA1';

    @AuraEnabled
    public static Map<String,Object> setPassword(String key, String password){
        System.debug('HP_EC_Util_PasswordManager.setPassword | Methode Start');
        Map<String,Object> resultObject = new Map<String,Object>();
        HP_Community_Settings__c myCommunitySetting = HP_Community_Settings__c.getInstance();
        try {
            HP_Community_User__c myCommunityUser = [SELECT Id, Activation_Key__c, Name, Username__c, Salt__c, Crypted_Password__c FROM HP_Community_User__c WHERE Activation_Key__c = :key LIMIT 1];
            Blob preHashedPassword = Blob.valueOf(password + myCommunityUser.Salt__c); 
            Blob cryptedPassword = Crypto.generateDigest(myCommunitySetting.Crypto_Type__c, preHashedPassword ); 
            String convertedPassword = EncodingUtil.convertToHex(cryptedPassword);
            myCommunityUser.Crypted_Password__c = convertedPassword;
            myCommunityUser.Activation_Key__c = '';
            update myCommunityUser;
            resultObject.put('success', true);
        } catch (Exception ex) {
            System.debug('HP_EC_Util_PasswordManager.setPassword | Exception : '+ ex.getMessage());
            resultObject.put('success', false);
        }
        System.debug('HP_EC_Util_PasswordManager.setPassword | Methode Exit');
        return resultObject;
    }

    @AuraEnabled
    public static Map<String,Object> resetPassword(String key, String password){
        System.debug('HP_EC_Util_PasswordManager.resetPassword | Methode Start');
        Map<String,Object> resultObject = new Map<String,Object>();
        HP_Community_Settings__c myCommunitySetting = HP_Community_Settings__c.getInstance();
        try {
            HP_Community_User__c myCommunityUser = [SELECT Id, Reset_Password_Key__c, Name, Username__c, Salt__c, Crypted_Password__c FROM HP_Community_User__c WHERE Reset_Password_Key__c = :key LIMIT 1];
            Blob preHashedPassword = Blob.valueOf(password + myCommunityUser.Salt__c); 
            Blob cryptedPassword = Crypto.generateDigest(myCommunitySetting.Crypto_Type__c, preHashedPassword ); 
            String convertedPassword = EncodingUtil.convertToHex(cryptedPassword);
            myCommunityUser.Crypted_Password__c = convertedPassword;
            myCommunityUser.Reset_Password_Key__c = '';
            update myCommunityUser;
            resultObject.put('success', true);
        } catch (Exception ex) {
            System.debug('HP_EC_Util_PasswordManager.resetPassword | Exception : '+ ex.getMessage());
            resultObject.put('success', false);
        }
        System.debug('HP_EC_Util_PasswordManager.resetPassword | Methode Exit');
        return resultObject;
    }

    @AuraEnabled
    public static Map<String,Object> sendResetPasswordEmail(String contactEmail){
        Map<String,Object> resultObject = new Map<String,Object>();
        System.debug('HP_EC_Util_PasswordManager.sendResetPasswordEmail | Methode Start');
        try {
            HP_Community_User__c myCommunityUser = [SELECT Id, Reset_Password_Key__c, Username__c, Name, Salt__c FROM HP_Community_User__c WHERE Unified_Username__c = :contactEmail.toLowerCase() LIMIT 1];
            myCommunityUser.Reset_Password_Key__c = generateResetPasswordKey(myCommunityUser);
            myCommunityUser.Reset_Password_Time__c = System.now();
            update myCommunityUser;
            resultObject = HP_EC_Util_EmailMessageHandler.sendResetPasswordEmail(contactEmail);
        }catch(QueryException ex){
            System.debug('HP_EC_Util_PasswordManager.sendResetPasswordEmail | Exception : '+ ex.getMessage());
            resultObject.put('success',false);
            resultObject.put('error','utilisateur non trouvé');
        } catch (Exception ex) {
            System.debug('HP_EC_Util_PasswordManager.sendResetPasswordEmail | Exception : '+ ex.getMessage()+' '+ex.getTypeName());
            resultObject.put('success',false);
            resultObject.put('error',ex.getMessage()+' '+ex.getTypeName());
        }
        System.debug('HP_EC_Util_PasswordManager.sendResetPasswordEmail | Methode Exit');
        return resultObject;
    }

    @AuraEnabled
    public static Map<String,Object> reSendActivationEmail(String contactEmail){
        Map<String,Object> resultObject = new Map<String,Object>();
        System.debug('HP_EC_Util_PasswordManager.sendResetPasswordEmail | Methode Start');
        try {
            HP_Community_User__c myCommunityUser = [SELECT Id, Activation_Key__c, Username__c, Name, Salt__c, Id_Tiers__c FROM HP_Community_User__c WHERE Unified_Username__c = :contactEmail.toLowerCase() LIMIT 1];
            myCommunityUser.Activation_Key__c = generateActivationKey(myCommunityUser);
            update myCommunityUser;
            resultObject = HP_EC_Util_EmailMessageHandler.sendWelcomeEmail(contactEmail);
        }catch(QueryException ex){
            System.debug('HP_EC_Util_PasswordManager.sendResetPasswordEmail | Exception : '+ ex.getMessage());
            resultObject.put('success',false);
            resultObject.put('error','utilisateur non trouvé');
        }
         catch (Exception ex) {
            System.debug('HP_EC_Util_PasswordManager.sendResetPasswordEmail | Exception : '+ ex.getMessage()+' '+ex.getTypeName());
            resultObject.put('success',false);
            resultObject.put('error',ex.getMessage()+' '+ex.getTypeName());
        }
        System.debug('HP_EC_Util_PasswordManager.sendResetPasswordEmail | Methode Exit');
        return resultObject;
    }

    public static String generateActivationKey(HP_Community_User__c myCommunityUser) {
        System.debug('HP_EC_Util_CommunityUsersManager.generateActivationKey() | Method Start');
        Blob preHashedKey = Blob.valueOf(myCommunityUser.Username__c + myCommunityUser.Name + myCommunityUser.Id_Tiers__c + Date.toDay()); 
        Blob cryptedKey = Crypto.generateDigest(HASH_TYPE, preHashedKey ); 
        String convertedKey = EncodingUtil.convertToHex(cryptedKey);
        System.debug('HP_EC_Util_CommunityUsersManager.generateActivationKey() | Method Exit');
        return convertedKey;
    }

    public static String generateResetPasswordKey(HP_Community_User__c myCommunityUser) {
        System.debug('HP_EC_Util_PasswordManager.generateResetPasswordKey() | Method Start');
        Blob preHashedKey = Blob.valueOf(myCommunityUser.Name + myCommunityUser.Username__c + myCommunityUser.Salt__c + Date.toDay()); 
        Blob cryptedKey = Crypto.generateDigest(HASH_TYPE, preHashedKey ); 
        String convertedKey = EncodingUtil.convertToHex(cryptedKey);
        System.debug('HP_EC_Util_PasswordManager.generateResetPasswordKey() | Method Exit');
        return convertedKey;
    }

    @AuraEnabled(Cacheable=true)
    public static Map<String,Object> retrieveActivationParams(String key){
        System.debug('HP_EC_Util_PasswordManager.retrieveActivationParams | Methode Start');
        Map<String,Object> resultObject = new Map<String,Object>();
        try {
            HP_Community_User__c myCommunityUser = [SELECT Id, Activation_Key__c, Name, Username__c FROM HP_Community_User__c WHERE Activation_Key__c = :key LIMIT 1];
        if(myCommunityUser != null){
            resultObject.put('name', myCommunityUser.Name);
            resultObject.put('email', myCommunityUser.Username__c);
            resultObject.put('error', null);
        }
        } catch (Exception ex) {
            System.debug('HP_EC_Util_PasswordManager.retrieveActivationParams | Exception : '+ ex.getMessage());
            resultObject.put('name', null);
            resultObject.put('email', null);
            resultObject.put('error', ex.getMessage());
        }
        System.debug('HP_EC_Util_PasswordManager.retrieveActivationParams | Methode Exit');
        return resultObject;
    }

    @AuraEnabled(Cacheable=true)
    public static Map<String,Object> retrieveResetPasswordParams(String key){
        System.debug('HP_EC_Util_PasswordManager.retrieveResetPasswordParams | Methode Start');
        Map<String,Object> resultObject = new Map<String,Object>();
        try {
            HP_Community_User__c myCommunityUser = [SELECT Id, Reset_Password_Key__c, Name, Username__c FROM HP_Community_User__c WHERE Reset_Password_Key__c = :key LIMIT 1];
        if(myCommunityUser != null){
            resultObject.put('name', myCommunityUser.Name);
            resultObject.put('email', myCommunityUser.Username__c);
            resultObject.put('error', null);
        }
        } catch (Exception ex) {
            System.debug('HP_EC_Util_PasswordManager.retrieveResetPasswordParams | Exception : '+ ex.getMessage());
            resultObject.put('name', null);
            resultObject.put('email', null);
            resultObject.put('error', ex.getMessage());
        }
        System.debug('HP_EC_Util_PasswordManager.retrieveResetPasswordParams | Methode Exit');
        return resultObject;
    }

    @AuraEnabled
    public static Map<String,Object> resetPasswordFromProfile(String idTiers, String password){
        System.debug('HP_EC_Util_PasswordManager.resetPasswordProfile | Methode Start');
        Map<String,Object> resultObject = new Map<String,Object>();
        HP_Community_Settings__c myCommunitySetting = HP_Community_Settings__c.getInstance();
        system.debug('myCommunitySetting user'+myCommunitySetting);
        try {
            HP_Community_User__c myCommunityUser = [SELECT Id, Name, Username__c, Salt__c, Crypted_Password__c FROM HP_Community_User__c WHERE Id_Tiers__c = :idTiers LIMIT 1];
            system.debug('community user'+myCommunityUser);
            Blob preHashedPassword = Blob.valueOf(password + myCommunityUser.Salt__c); 
            Blob cryptedPassword = Crypto.generateDigest(myCommunitySetting.Crypto_Type__c, preHashedPassword ); 
            String convertedPassword = EncodingUtil.convertToHex(cryptedPassword);
            myCommunityUser.Crypted_Password__c = convertedPassword;
            update myCommunityUser;
            resultObject.put('success', true);
        } catch (Exception ex) {
            System.debug('HP_EC_Util_PasswordManager.resetPasswordProfile | Exception : '+ ex.getMessage());
            resultObject.put('success', false);
        }
        System.debug('HP_EC_Util_PasswordManager.resetPasswordProfile | Methode Exit');
        return resultObject;
    }
}