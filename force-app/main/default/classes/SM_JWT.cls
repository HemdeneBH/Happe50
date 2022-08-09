/**
 * @description       : Generate JWT Token for OAuth 2.0 JWT Bearer Flow 
 * @author            : YAO LEYANG
 * @group             : 
 * @last modified on  : 03-07-2021
 * @last modified by  : YAO LEYANG
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   03-07-2021   YAO LEYANG   Initial Version
**/

public class SM_JWT {
    
    private String alg {get;set;}
    private String iss {get;set;}
    private String sub {get;set;}
    private String aud {get;set;}
    // private String exp {get;set;}
    // private String iat {get;set;}
    private Map<String,String> claims {get;set;}
    private Integer validFor {get;set;}
    private String cert {get;set;}
    private String pkcs8 {get;set;}
    private String privateKey {get;set;}
    
    private static final String HS256 = 'HS256';
    private static final String RS256 = 'RS256';
    private static final String NONE = 'none';
    private static final Integer VALIDPERIOD =  31536000;
    
    public SM_JWT(String alg, String cert, String iss, String sub, String aud) {
        this.alg = RS256;
        this.validFor = validPeriod;
        this.cert = cert;
        this.iss = iss;
        this.sub = sub;
        this.aud = aud;
        String completeJWT = assertion();
    }
    
    public String assertion() {
        
        String jwt = '';
        String encodedHeader = jwtHeaderBuider();
        jwt = encodedHeader;
        String encodedBody = jwtBodyBuider();
        jwt = encodedHeader + '.' + encodedBody;
        String encodedSignature = jwtSignatureBuider(jwt);
        jwt = encodedHeader + '.' + encodedBody + '.' + encodedSignature;
        
        System.debug('jwt header:');
        System.debug(encodedHeader);
        System.debug('jwt body:');
        System.debug(encodedBody);
        System.debug('jwt signature');
        System.debug(encodedSignature);
        
        return jwt;
    }
    
    private String jwtHeaderBuider(){
        JSONGenerator header = JSON.createGenerator(false);
        header.writeStartObject();
        header.writeStringField('alg', this.alg);
        header.writeEndObject();
        String encodedHeader = base64URLencode(Blob.valueOf(header.getAsString()));
        return encodedHeader;
    }

    private String jwtBodyBuider(){
        JSONGenerator body = JSON.createGenerator(false);
        body.writeStartObject();
        body.writeStringField('iss', this.iss);
        body.writeStringField('sub', this.sub);
        body.writeStringField('aud', this.aud);
        Long rightNow = (dateTime.now().getTime()/1000)+1;
        body.writeNumberField('iat', rightNow);
        body.writeNumberField('exp', (rightNow + validFor));
        if (claims != null) {
            for (String claim : claims.keySet()) {
                body.writeStringField(claim, claims.get(claim));
            }
        }
        body.writeEndObject();
        String encodedBody = base64URLencode(Blob.valueOf(body.getAsString()));
        return encodedBody;
    }

    private String jwtSignatureBuider(String jwt){
        String encodedSignature;
        if ( this.alg == HS256 ) {
            Blob key = EncodingUtil.base64Decode(privateKey);
            Blob signature = Crypto.generateMac('hmacSHA256',Blob.valueof(jwt),key);
            encodedSignature = base64URLencode(signature);  
        } else if ( this.alg == RS256 ) {
            Blob signature = null;
            
            if (cert != null ) {
                signature = Crypto.signWithCertificate('rsa-sha256', Blob.valueOf(jwt), cert);
            } else {
                // Blob privateKey = EncodingUtil.base64Decode(pkcs8);
                // signature = Crypto.sign('rsa-sha256', Blob.valueOf(jwt), privateKey);
            }
            encodedSignature =  base64URLencode(signature);
            
        } else if ( this.alg == NONE ) {
            encodedSignature = '';
        }
        return encodedSignature;
    }

    private String base64URLencode(Blob input){ 
        String output = encodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        while ( output.endsWith('=')){
            output = output.subString(0,output.length()-1);
        }
        return output;
    }
}