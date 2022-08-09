/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 06-13-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_EC_AmazonPayController {

    private static final String HASH_KEY = 'SHA-256';
    private static final String AMAZON_HASH_KEY = 'AMZN-PAY-RSASSA-PSS';
    private static final String SIGNATURE_KEY = 'RSA-SHA256';
    private static final String AMAZONE_PAY = 'AMAZONE_PAY';

    @AuraEnabled
    public static AmazonPay_WRP generateAmazonPayParams(String echeanceId, String amount){
        AmazonPay_WRP myResult;
        HP_EC_Amazone_Pay_Setting__mdt mySetting = [SELECT Id, Security_Key__c, Return_URL__c, Store_Name__c, 
                                                    Store_Id__c, Public_Key_Id__c, Product_Type__c, Origin_Url__c, 
                                                    Merchant_Id__c, Merchant_Domain__c, Environment__c, Algorithm__c
                                                     FROM HP_EC_Amazone_Pay_Setting__mdt LIMIT 1];
        myResult = new AmazonPay_WRP(mySetting, echeanceId, amount);
        return myResult;
    }

    public static String createCheckoutSession(String echeanceId, String amount){
        HP_EC_Amazone_Pay_Setting__mdt mySetting = [SELECT Id, Security_Key__c, Return_URL__c, Store_Name__c, 
                                                    Store_Id__c, Public_Key_Id__c, Product_Type__c, Origin_Url__c, 
                                                    Merchant_Id__c, Merchant_Domain__c, Environment__c, Algorithm__c
                                                    FROM HP_EC_Amazone_Pay_Setting__mdt LIMIT 1];
        HP_Endpoint_Configuration__mdt myEndpointConfig = [SELECT Id, Value__c, DeveloperName, Header_Mandatory__c FROM HP_Endpoint_Configuration__mdt WHERE DeveloperName = :AMAZONE_PAY LIMIT 1];
        HttpRequest req = new HttpRequest();
        String body = generatePayload(mySetting, echeanceId, amount);
            
        Datetime startCall = Datetime.now();
        String payDate = startCall.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        List<String> headers = myEndpointConfig.Header_Mandatory__c.split(';');
        String idempotencyKey = generateIdempotencyKey();
        Map<String,String> headersMap = new Map<String,String>();
        for(String headerKey : headers) {
            String conf = HP_UTIL_MetadataManager.getConfigByKey(headerKey);
            List<String>  confParam = conf.split('=');
            if(confParam.size() >= 2) {
                req.setHeader(confParam.get(0), confParam.get(1));
                headersMap.put(confParam.get(0), confParam.get(1));
            }else if(confParam[0].contains('date')){
                req.setHeader(confParam.get(0), payDate);
                headersMap.put(confParam.get(0), payDate);
            }else {
                req.setHeader(confParam.get(0), idempotencyKey);
                headersMap.put(confParam.get(0), idempotencyKey);
            }
        }
        req.setEndpoint(myEndpointConfig.Value__c);
		req.setMethod('POST');
        req.setHeader('authorization', generateAuthorization(body, myEndpointConfig.Value__c, headersMap));
        req.setBody(body);
		Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
		HP_UTIL_HTTPUtils.saveLogResponse(req, res, (Datetime.now().getTime() - startCall.getTime() ));
        return res.getBody();
    }

    public static String generateAuthorization(String body, String endpoint, Map<String,String> headersMap){
        HP_EC_Amazone_Pay_Setting__mdt mySetting = [SELECT Id,  Public_Key_Id__c FROM HP_EC_Amazone_Pay_Setting__mdt LIMIT 1];
        return AMAZON_HASH_KEY + ' PublicKeyId='+ mySetting.Public_Key_Id__c + ', SignedHeaders=' + generateSignedHeaders(headersMap) + ', Signature=' + generateSignature(body, endpoint, headersMap);
    }

    public static String generateSignedHeaders(Map<String,String> headersMap){
        String result = '';
        for(String key : headersMap.keySet()){
            result = result + key + ';';
        }
        result.removeEnd(';');
        return result;
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
            // this.payloadJSON = generatePayload(mySetting, echeanceId, amount);
            // this.signature = generateSignature(this.payloadJSON);
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

    public static String generateSignature(String payload, String endpoint, Map<String,String> headersMap){
        String canonicalQuery = '';
        String canonicalHeaders = '';
        String signedHeaders = '';
        String canonicalRequest = '';
        String uri = endpoint;
        String httpMethod = 'POST';
        
        List<String> headerKeys = new List<String>(headersMap.keySet());
        headerKeys.sort();
        for(String key : headerKeys){
            canonicalHeaders = canonicalHeaders + key + ':' + headersMap.get(key) +'\n';
            signedHeaders = signedHeaders + key + ';';
        }
        //canonicalHeaders = signedHeaders.removeEnd(',');
        signedHeaders = signedHeaders.removeEnd(';');
        
        System.debug('This is the payload : ' + payload);
        HP_EC_Amazone_Pay_Setting__mdt mySetting = [SELECT Id, Security_Key__c  FROM HP_EC_Amazone_Pay_Setting__mdt LIMIT 1];
        blob pKey = Blob.valueOf(mySetting.Security_Key__c);
        String encodedUri = EncodingUtil.urlEncode(uri,'UTF-8');
        blob privateKey = EncodingUtil.base64Decode(pKey.toString());
        blob encodedPayload = Crypto.generateDigest(HASH_KEY, Blob.valueOf(payload));
        canonicalRequest = httpMethod + '\n' + uri +  '\n'+ '\n' + canonicalHeaders + '\n' + signedHeaders  + '\n' + EncodingUtil.convertToHex(encodedPayload);
        System.debug('Canonical Request : '+canonicalRequest);
        blob encodedCanonicalRequest = Crypto.generateDigest(HASH_KEY, Blob.valueOf(canonicalRequest));
        blob stringToSign = Blob.valueOf(AMAZON_HASH_KEY + '\n' + EncodingUtil.convertToHex(encodedCanonicalRequest));
        system.debug('String to Sign : '+ stringToSign.toString());
        blob signature = Crypto.sign(SIGNATURE_KEY, stringToSign, privateKey);
        

        system.debug('------');
        system.debug(EncodingUtil.base64Encode(signature));
        system.debug('------');
        return EncodingUtil.base64Encode(signature);
    }

    public static String generateIdempotencyKey() {
        System.debug('HP_EC_AmazonPayController.generateIdempotencyKey() | Method Start');
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz-_';
        String randStr = '';
        while (randStr.length() < 21) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        System.debug('HP_EC_AmazonPayController.generateIdempotencyKey() | Method Exit');
        return randStr; 
    }
}