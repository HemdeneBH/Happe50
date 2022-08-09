/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-06-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_EC_Util_CommunityUsersManager {
    private static final String COMMUNITY_PROFILE ='HP_Community_User';
    private static final String TIME_ZONE_ID ='Europe/Paris	';
    private static final String LOCAL_ID ='fr_FR_EURO';
    private static final String LANGUAGE_KEY ='fr';
    private static final String EMAIL_ENCODE ='ISO-8859-1';
    private static final String HP_PERMISSION ='HP_EC_permissions';
    private static final String HASH_TYPE ='SHA1';

    //@future
    public static void createCommunityUser(Decimal idTiers){
        System.debug('HP_EC_Util_CommunityUsersManager.createCommunityUser() | Method Start');
        try {
            Contact myContact = [SELECT Id, Email, FirstName, LastName, AccountId, ID_Tiers__c FROM Contact WHERE ID_Tiers__c = :idTiers LIMIT 1];
            Id communityProfileId = [SELECT Id, Name FROM Profile WHERE Name = :COMMUNITY_PROFILE LIMIT 1].Id;
            try {
                List<User> existingUserList = [SELECT Id, ContactId, Name FROM User WHERE ContactId = :myContact.Id];
                if(!existingUserList.isEmpty() || existingUserList != null || existingUserList.size()>0){
                    System.debug('HP_EC_Util_CommunityUsersManager.createCommunityUser() | Method Exist | User Already exists : '+ existingUserList[0]);
                    return;
                }
            } catch (Exception ex) {
                System.debug(ex.getMessage());
            }
            Database.DMLOptions myDmlOptions = new Database.DMLOptions();
            myDmlOptions.EmailHeader.triggerUserEmail = false;       
            myDmlOptions.EmailHeader.triggerOtherEmail = false;
            myDmlOptions.EmailHeader.triggerAutoResponseEmail = false;       
            myDmlOptions.optAllOrNone = false;
            String nickName = myContact.FirstName + '_' + myContact.Lastname;
            String userName = myContact.email + '.happe';
            User myCommunityUser = new User(Alias= myContact.FirstName.length()>7 ? myContact.FirstName.SubString(0,8) : myContact.FirstName, 
                                            Email = myContact.Email, 
                                            EmailEncodingKey = EMAIL_ENCODE, 
                                            FirstName = myContact.FirstName, 
                                            LastName = myContact.Lastname, 
                                            LanguageLocaleKey = LANGUAGE_KEY,
                                            LocaleSidKey = LOCAL_ID,
                                            ContactId = myContact.Id,
                                            TimeZoneSidKey = TIME_ZONE_ID,  
                                            UserName = userName,
                                            CommunityNickname = nickName,
                                            ProfileId =communityProfileId, 
                                            IsActive = true);
            myCommunityUser.setOptions(myDmlOptions);
            insert myCommunityUser;
            Id myPermissionSetId = [SELECT id FROM PermissionSet WHERE Name = :HP_PERMISSION LIMIT 1].Id;
            PermissionSetAssignment myPermissionSetAssignment =  new PermissionSetAssignment(PermissionSetId = myPermissionSetId, AssigneeId = myCommunityUser.Id);
            insert myPermissionSetAssignment;

            ID jobID = System.enqueueJob(new HP_EC_CommunityUserLoginManagerAsync(myContact.Id));
        }
         catch (Exception ex) {
            System.debug('HP_EC_Util_CommunityUsersManager.createCommunityUser() | Exception : ' + ex.getMessage());     
        }
        System.debug('HP_EC_Util_CommunityUsersManager.createCommunityUser() | Method Exit');
    }

    public static HP_Community_User__c createCommunityUserLogin(Id myCommunityUserId, Contact myContact){
        System.debug('HP_EC_Util_CommunityUsersManager.createCommunityUserLogin() | Method Start');
        HP_Community_User__c myUserLogin = new HP_Community_User__c();
        myUserLogin.Name = myContact.FirstName + ' ' + myContact.LastName;
        myUserLogin.Community_User__c = myCommunityUserId;
        myUserLogin.Id_Tiers__c = String.valueOf(myContact.ID_Tiers__c);
        myUserLogin.Username__c = myContact.Email;
        myUserLogin.Activation_Key__c = generateActivationKey(myContact);
        myUserLogin.Salt__c = generateSalt();
        myUserLogin.Activation_Date__c = Date.today();
        insert myUserLogin;
        System.debug('HP_EC_Util_CommunityUsersManager.createCommunityUserLogin() | Method Exit');
        return myUserLogin;
    }

    public static String generateActivationKey(Contact myContact) {
        System.debug('HP_EC_Util_CommunityUsersManager.generateActivationKey() | Method Start');
        Blob preHashedKey = Blob.valueOf(myContact.Email + myContact.FirstName + myContact.LastName + String.valueOf(myContact.ID_Tiers__c) + Date.toDay()); 
        Blob cryptedKey = Crypto.generateDigest(HASH_TYPE, preHashedKey ); 
        String convertedKey = EncodingUtil.convertToHex(cryptedKey);
        System.debug('HP_EC_Util_CommunityUsersManager.generateActivationKey() | Method Exit');
        return convertedKey;
    }

    public static String generateSalt() {
        System.debug('HP_EC_Util_CommunityUsersManager.generateSalt() | Method Start');
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < 6) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        System.debug('HP_EC_Util_CommunityUsersManager.generateSalt() | Method Exit');
        return randStr; 
    }

    public static void insertLoginAndSendEmail(Id myContactId){
        System.debug('HP_EC_Util_CommunityUsersManager.insertLoginAndSendEmail() | Method Start');
        try {
        Contact myContact = [SELECT Id, Email, FirstName, LastName, AccountId, ID_Tiers__c FROM Contact WHERE Id = :myContactId LIMIT 1];
        Id myCommunityUserId = [SELECT Id FROM User WHERE ContactId = :myContactId LIMIT 1].Id;
        try {
            List<HP_Community_User__c> existingcommunityUserLoginList = [SELECT Id, Id_Tiers__c, Name FROM HP_Community_User__c WHERE Community_User__c = :myCommunityUserId];
                if(!existingcommunityUserLoginList.isEmpty() || existingcommunityUserLoginList != null || existingcommunityUserLoginList.size()>0){
                    System.debug('HP_EC_Util_CommunityUsersManager.insertLoginAndSendEmail() | Method Exist | User Login Already exists : '+ existingcommunityUserLoginList[0]);
                    return;
                }
        } catch (Exception ex) {
            System.debug(ex.getMessage());  
        }
        HP_Community_User__c communityUserLogin =  createCommunityUserLogin(myCommunityUserId, myContact);
        HP_EC_Util_EmailMessageHandler.sendWelcomeEmail(myContact.Email);
        } catch (Exception ex) {
            System.debug('HP_EC_Util_CommunityUsersManager.insertLoginAndSendEmail() | Exception : ' + ex.getMessage());        
        }
        System.debug('HP_EC_Util_CommunityUsersManager.insertLoginAndSendEmail() | Method Exit');
    }
}