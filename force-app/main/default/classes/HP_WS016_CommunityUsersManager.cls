/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 04-20-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@RestResource(urlMapping='/v1/user/manager/*')
global class HP_WS016_CommunityUsersManager {
    
    private static final String COMMUNITY_PROFILE ='HP_Community_User';
    private static final String ID_TIERS ='id_tiers';
    private static final String TIME_ZONE_ID ='Europe/Paris	';
    private static final String LOCAL_ID ='fr_FR_EURO';
    private static final String LANGUAGE_KEY ='fr';
    private static final String EMAIL_ENCODE ='ISO-8859-1';
    private static final String HP_PERMISSION ='HP_EC_permissions';
    private static final String HASH_TYPE ='SHA1';

    @httpPost
    global static void createCommunityUser(){
        System.debug('HP_WS016_CommunityUsersManager.createCommunityUser() | Method Start');
        RestResponse restResponse = RestContext.response;        
        Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
        Datetime startCall = Datetime.now();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        String body = RestContext.request.requestBody.toString();
        Map<String,String> bodyMap = (Map<String,String>) JSON.deserialize(body, Map<String,String>.class);
        
        try {
            Decimal idTiers = Decimal.valueOf(bodyMap.get(ID_TIERS));
            if(String.isEmpty(body) || String.isEmpty(bodyMap.get(ID_TIERS))){
                throw new QueryException('L\'Id Tiers ne doit pas être vide');
            }
            Contact myContact = [SELECT Id, Email, FirstName, LastName, AccountId, ID_Tiers__c FROM Contact WHERE ID_Tiers__c = :idTiers LIMIT 1];
            Id communityProfileId = [SELECT Id, Name FROM Profile WHERE Name = :COMMUNITY_PROFILE LIMIT 1].Id;
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

            insertLoginAndSendEmail(myCommunityUser.Id, myContact.Id);

            restResponse.statusCode = HP_HttpStatus.OK;
            response.code = HP_HttpStatus.OK;
        }catch(QueryException ex){
            System.debug('HP_WS016_CommunityUsersManager.createCommunityUser() | Exception : ' + ex.getMessage());
            response.addError('Erreure', 'Contact non trouvé');
            response.code = HP_HttpStatus.BAD_REQUEST;
            restResponse.statusCode = HP_HttpStatus.BAD_REQUEST;  
        }
         catch (Exception ex) {
            System.debug('HP_WS016_CommunityUsersManager.createCommunityUser() | Exception : ' + ex.getMessage());
            response.addError('Erreure', ex.getMessage());
            response.code = HP_HttpStatus.BAD_REQUEST;
            restResponse.statusCode = HP_HttpStatus.BAD_REQUEST;       
        }
        finally {
            restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
            HP_UTIL_HTTPUtils.saveLogResponse(RestContext.request, restResponse, (Datetime.now().getTime() - startCall.getTime()));
        } 
        System.debug('HP_WS016_CommunityUsersManager.createCommunityUser() | Method Exit');
    }

    public static HP_Community_User__c createCommunityUserLogin(Id myCommunityUserId, Contact myContact){
        System.debug('HP_WS016_CommunityUsersManager.createCommunityUserLogin() | Method Start');
        HP_Community_User__c myUserLogin = new HP_Community_User__c();
        myUserLogin.Name = myContact.FirstName + ' ' + myContact.LastName;
        myUserLogin.Community_User__c = myCommunityUserId;
        myUserLogin.Id_Tiers__c = String.valueOf(myContact.ID_Tiers__c);
        myUserLogin.Username__c = myContact.Email;
        myUserLogin.Activation_Key__c = generateActivationKey(myContact);
        myUserLogin.Salt__c = generateSalt();
        insert myUserLogin;
        System.debug('HP_WS016_CommunityUsersManager.createCommunityUserLogin() | Method Exit');
        return myUserLogin;
    }

    public static String generateActivationKey(Contact myContact) {
        System.debug('HP_WS016_CommunityUsersManager.generateActivationKey() | Method Start');
        Blob preHashedKey = Blob.valueOf(myContact.Email + myContact.FirstName + myContact.LastName + String.valueOf(myContact.ID_Tiers__c)); 
        Blob cryptedKey = Crypto.generateDigest(HASH_TYPE, preHashedKey ); 
        String convertedKey = EncodingUtil.convertToHex(cryptedKey);
        System.debug('HP_WS016_CommunityUsersManager.generateActivationKey() | Method Exit');
        return convertedKey;
    }

    public static String generateSalt() {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < 6) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }

    @Future
    public static void insertLoginAndSendEmail(Id myCommunityUserId, Id myContactId){
        Contact myContact = [SELECT Id, Email, FirstName, LastName, AccountId, ID_Tiers__c FROM Contact WHERE Id = :myContactId LIMIT 1];
        HP_Community_User__c communityUserLogin =  createCommunityUserLogin(myCommunityUserId, myContact);
        HP_EC_Util_EmailMessageHandler.sendWelcomeEmail(myContact.Email);
    }
}