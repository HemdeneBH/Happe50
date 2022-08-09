/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 03-01-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public class HP_UTIL_CryptoUtils {
    private static final HP_Okta_Token_Parameter__c ENCRYPTION_INFORMATIONS = HP_Okta_Token_Parameter__c.getOrgDefaults();
 
    public static string encyptData(String decryptedString){
        Blob data = Blob.valueOf(decryptedString);
        Blob encryptionKey = Blob.valueOf(ENCRYPTION_INFORMATIONS.Encryption_Key__c);
        Blob encryptedBlobData = Crypto.encryptWithManagedIV(ENCRYPTION_INFORMATIONS.Encryption_Code__c, encryptionKey , data );
        String base64EncryptedString = EncodingUtil.base64Encode(encryptedBlobData);
        return base64EncryptedString;
    }
   
    public static string decryptData(String encryptedString){
        Blob data = EncodingUtil.base64Decode(encryptedString);
        Blob encryptionKey = Blob.valueOf(ENCRYPTION_INFORMATIONS.Encryption_Key__c);
        Blob decryptedBlobData = Crypto.decryptWithManagedIV(ENCRYPTION_INFORMATIONS.Encryption_Code__c, encryptionKey , data);
        String decryptedString= decryptedBlobData.toString();
        return decryptedString;
    }
 
}