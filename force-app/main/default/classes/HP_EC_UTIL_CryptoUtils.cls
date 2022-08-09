/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-13-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_EC_UTIL_CryptoUtils {
    public static final String SOGENACTIF = 'EC_Sogenactif';
    public static final String ALGORITHME_NAME = 'HMACSHA256';
    public static final String HASH_KEY = 'SHA-256';
    public static final String AMAZON_HASH_KEY = 'AMZN-PAY-RSASSA-PSS-V2';
    public static final String SIGNATURE_KEY = 'RSA-SHA256';

    @AuraEnabled
    public static String getSha256(String input)
    {
        System.debug('input: '+ input);
        Blob myBlob = Blob.valueOf(input);
        Blob hashBlob = Crypto.generateDigest('SHA-256', myBlob);
        String hash = EncodingUtil.convertToHex(hashBlob);
        System.debug('getSha256 debug input: '+ hash);
        return hash;
    }

    @AuraEnabled
    public static Map<String,Object> generateSogenactifParams(String amount, String contactId, String echeanceId, String paymentMethod){
        System.debug('HP_EC_UTIL_CryptoUtils.generateSogenactifParams | Method Start');
        String convertedAmount = String.valueOf(Integer.valueOf(Decimal.valueOf(amount)*100));
        Map<String,Object> resultMap = new Map<String,Object>();
        HP_EC_Payment_Setting__mdt paymentSetting = [SELECT DeveloperName, Automatic_Response_Url__c, 
            Currency_Code__c, Customer_Language__c, Interface_Version__c, 
            Key_Version__c, Merchant_Id__c, Normal_Return_Url__c, 
            Secret_Key__c, Template_Name__c  FROM HP_EC_Payment_Setting__mdt WHERE DeveloperName = :SOGENACTIF LIMIT 1];
            Contact myContact = [SELECT Id, Id_Tiers__c, Email FROM Contact WHERE Id = :contactId LIMIT 1];
            HP_EC_WRP_Sogenactif myPaymentRequest = new HP_EC_WRP_Sogenactif(paymentSetting, myContact, echeanceId, convertedAmount, paymentMethod);
        try {
            myPaymentRequest.seal = generateSeal(myPaymentRequest, paymentSetting.Secret_Key__c);
            HttpResponse myResponse = HP_UTIL_HTTPUtils.calloutPost(HP_Constantes.SOGENACTIF, JSON.serialize(myPaymentRequest));
            resultMap = (Map<String,Object>) JSON.deserializeUntyped(myResponse.getBody());
            
        } catch (Exception ex) {
            System.debug('HP_EC_UTIL_CryptoUtils.generateSogenactifParams | Exception : ' + ex.getMessage());
        }
        System.debug('HP_EC_UTIL_CryptoUtils.generateSogenactifParams | Method Exit');
        return resultMap;
    }

    @AuraEnabled
    public static Map<String,Object> generateAmazonPayParams(String echeanceId, String amount){
        System.debug('HP_EC_UTIL_CryptoUtils.generateAmazonPayParams | Method Start');
        Map<String,Object> myResult = new Map<String,Object>();
        try {
            HP_EC_Amazone_Pay_Setting__mdt mySetting = [SELECT Id, Security_Key__c, Return_URL__c, Store_Name__c, 
                                                    Store_Id__c, Public_Key_Id__c, Product_Type__c, Origin_Url__c, 
                                                    Merchant_Id__c, Merchant_Domain__c, Environment__c, Algorithm__c
                                                     FROM HP_EC_Amazone_Pay_Setting__mdt LIMIT 1];
            AmazonPay_WRP myResultWrp = new AmazonPay_WRP(mySetting, echeanceId, amount);
            myResult = (Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(myResultWrp));
        } catch (Exception ex) {
            System.debug('HP_EC_UTIL_CryptoUtils.generateAmazonPayParams | Exception : ' + ex.getMessage());
        }
        System.debug('HP_EC_UTIL_CryptoUtils.generateAmazonPayParams | Method Exit');
        return myResult;
    }

    public static String generateSeal(HP_EC_WRP_Sogenactif myPaymentRequest, String secretKey){
        System.debug('HP_EC_UTIL_CryptoUtils.generateSeal | Method Start');
        String result;
        try {
            Map<String, Object> myMap = (Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(myPaymentRequest));
            String params = '';
            List<String> keyList = new List<String>(myMap.keySet());
            keyList.sort();
            for(String key : keyList){
                if(key == 'paymentMeanBrandList'){
                    for(Object value : (List<Object>)myMap.get(key)){
                        params = params + String.valueOf(value);
                    }
                }else if(key == 'keyVersion' || key == 'seal'){
                    params = params;
                }else if(key == 'customerContact'){
                    params = params + String.valueOf(((Map<String,Object>) myMap.get(key)).get('email'));
                }else {
                    params = params + String.valueOf(myMap.get(key));
                }
            }
            Blob hmacData = Crypto.generateMac(ALGORITHME_NAME, Blob.valueOf(params), Blob.valueOf(secretKey));
            result = EncodingUtil.convertToHex(hmacData);
        } catch (Exception ex) {
            System.debug('HP_EC_UTIL_CryptoUtils.generateSeal | Exception : ' + ex.getMessage() + ' Line : ' + ex.getLineNumber() + ' Stack : '+ ex.getStackTraceString());
        }
        System.debug('HP_EC_UTIL_CryptoUtils.generateSeal | Method Exit');
        return result;
    }

    public class HP_EC_WRP_Sogenactif{
        public String amount {get;set;}
        public String templateName {get;set;}
        public String merchantId {get;set;}
        public String keyVersion {get;set;}
        public String currencyCode {get;set;}
        public String interfaceVersion {get;set;}
        public String orderId {get;set;}
        public String normalReturnUrl {get;set;}
        public String automaticResponseUrl {get;set;}
        public String merchantWalletId {get;set;}
        public String customerLanguage {get;set;}
        public List<String> paymentMeanBrandList {get;set;}
        public CustomerContact customerContact {get;set;}
        public String seal {get;set;}
        public String orderChannel {get;set;}

        public HP_EC_WRP_Sogenactif(HP_EC_Payment_Setting__mdt paymentSetting, Contact myContact, String echeanceId, String amount, String paymentMethod){
            this.amount = amount;
            this.templateName = paymentSetting.Template_Name__c;
            this.merchantId = paymentSetting.Merchant_Id__c;
            this.keyVersion = paymentSetting.Key_Version__c;
            this.currencyCode = paymentSetting.Currency_Code__c;
            this.interfaceVersion = paymentSetting.Interface_Version__c;
            this.orderId = echeanceId;
            this.normalReturnUrl = paymentSetting.Normal_Return_Url__c;
            this.automaticResponseUrl = paymentSetting.Automatic_Response_Url__c.replace('#{self.id}', echeanceId);
            this.merchantWalletId = String.valueOf(myContact.Id_Tiers__c);
            this.customerLanguage = paymentSetting.Customer_Language__c;
            this.paymentMeanBrandList = paymentMethod == 'CB' ? new List<String>{'VISA','MASTERCARD','CB'} : new List<String>{'PAYLIB'};
            this.customerContact = new CustomerContact(myContact.Email);
            this.orderChannel = 'INTERNET';
        }
    }

    public class CustomerContact{
        public String email {get;set;}
        public CustomerContact(String email){
            this.email = email;
        }
    }

    public static String generateSignature(String payload){

        HP_EC_Amazone_Pay_Setting__mdt mySetting = [SELECT Id, Security_Key__c  FROM HP_EC_Amazone_Pay_Setting__mdt LIMIT 1];
        blob pKey = Blob.valueOf(mySetting.Security_Key__c);
        blob privateKey = EncodingUtil.base64Decode(pKey.tostring());
        blob encodedPayload = Crypto.generateDigest(HASH_KEY, Blob.valueOf(payload));
        //blob encodedcanonicalRequest = Crypto.generateDigest(HASH_KEY, Blob.valueOf(canonicalRequest));
        blob stringToSign = Blob.valueOf(AMAZON_HASH_KEY + '\n' + EncodingUtil.convertToHex(encodedPayload));
        system.debug('String to Sign : '+ stringToSign.toString());
        String salt = '20';
        blob signatureKey = Crypto.generateMac('HmacSHA256', Blob.valueOf(salt), privateKey);
        blob signature = Crypto.sign(SIGNATURE_KEY, stringToSign, privateKey);
        

        system.debug('------');
        system.debug(EncodingUtil.base64Encode(signature));
        system.debug('------');
        return EncodingUtil.base64Encode(signature);
    }
    
    public class AmazonPay_WRP{
        public String payloadJSON {get;set;}
        public String signature {get;set;}
        public String publicKeyId {get;set;}
        public String algorithm {get;set;}
        public String checkoutLanguage {get;set;}
        public String ledgerCurrency {get;set;}
        public String merchantId {get;set;}
        public String productType {get;set;}
        public String environment {get;set;}
        public String merchantDomain {get;set;}
        public String origin_url {get;set;}

        public AmazonPay_WRP(HP_EC_Amazone_Pay_Setting__mdt mySetting, String echeanceId, String amount){
            this.payloadJSON = generatePayload(mySetting, echeanceId, amount);
            this.signature = generateSignature(this.payloadJSON);
            this.publicKeyId = mySetting.Public_Key_Id__c;
            this.algorithm = mySetting.Algorithm__c;
            this.checkoutLanguage = 'fr_FR';
            this.ledgerCurrency = 'EUR';
            this.merchantId = mySetting.Merchant_Id__c;
            this.productType = mySetting.Product_Type__c;
            this.environment = mySetting.Environment__c;
            this.merchantDomain = mySetting.Merchant_Domain__c;
            this.origin_url = mySetting.Origin_Url__c;
        }
    }

    public static String generatePayload(HP_EC_Amazone_Pay_Setting__mdt mySetting, String echeanceId, String amount){
        Integer reference = echeanceId.startsWith('ECH') ? Integer.valueOf(echeanceId.substring(3,echeanceId.length())) : Integer.valueOf(echeanceId.substring(4,echeanceId.length()));
        String payload =  '{'+
                            '"webCheckoutDetails":'+
                            '{'+
                                '"checkoutResultReturnUrl":"'+mySetting.Return_URL__c+'",'+
                                '"checkoutCancelUrl":"'+mySetting.Return_URL__c+'",'+
                                '"checkoutMode":"ProcessOrder"'+
                            '},'+
                            '"storeId":"'+mySetting.Store_Id__c+'",'+
                            '"chargePermissionType": "OneTime",'+
                            '"paymentDetails":'+
                                '{'+
                                '"paymentIntent":"AuthorizeWithCapture",'+
                                '"canHandlePendingAuthorization":false,'+
                                '"chargeAmount":'+
                                    '{'+
                                    '"amount":"'+amount+'",'+
                                    '"currencyCode":"EUR"'+
                                    '}'+
                                '},'+
                            '"merchantMetadata":'+
                                '{'+
                                '"merchantReferenceId":'+reference+
                                ',"merchantStoreName":"'+mySetting.Store_Name__c+'",'+
                                '"noteToBuyer":"'+echeanceId+'",'+
                                '"customInformation":'+reference+
                                '},'+
                                '"providerMetadata": {}'+
                            '}';
        return payload;
    }
}