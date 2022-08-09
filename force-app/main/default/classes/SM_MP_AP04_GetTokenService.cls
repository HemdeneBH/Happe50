public class SM_MP_AP04_GetTokenService {
    private static final String sm_appli = 'SMILE';
    private static SM_WS_Suffix__mdt suffixes = [select id, suffix__c from SM_WS_Suffix__mdt where QualifiedApiName= 'token' limit 1];
    private static String namedCredential = 'callout:AuthAPIHour';
    private static String suffixe = suffixes.suffix__c;
    private static String endpointURL = namedCredential + suffixe;

    private static String smClientId;
    private static String smClientSecret;
    private static String smScope;

    static {
        smClientId = MP_Xdata_credentials__c.getInstance('sm_client_id').Value__c;
        smClientSecret = MP_Xdata_credentials__c.getInstance('sm_client_secret').Value__c;
        smScope = MP_Xdata_credentials__c.getInstance('sm_scope').Value__c;
    }

    /* get token as String Json*/
    public static String getTokenFromSmile() {
        try {
            Cache.OrgPartition part = Cache.Org.getPartition('local.smileToken');
            String token = (String) part.get('token');

            if (token != null) {
                system.debug('[SMILE] Token already exist in salesforce cache...');
                return token;
            }
            system.debug('[SMILE] Getting token from API...');
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpointURL);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            Map < String, String > values = new Map < String, String > ();
            values.put('client_id', smClientId);
            values.put('client_secret', smClientSecret);
            values.put('grant_type', 'client_credentials');
            values.put('scope', smScope);
            req.setBody(encodeFormData(values));
            Http http = new Http();
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                token = getJsonFieldAsString('access_token', res.getBody());
                part.put('token', token, 3600 * 1 - 30);
                return token;
            }
        } catch (Exception e) {
            system.debug(e);
            return null;
        }
        return null;
    }

    private static String encodeFormData(Map < String, String > values) {
        String result = '';
        for (String thisKey : values.keySet()) {
            result += EncodingUtil.urlEncode(thisKey, 'UTF-8') + '=' + EncodingUtil.urlEncode(values.get(thisKey), 'UTF-8') + '&';
        }
        return result.removeEnd('&');
    }

    public static String getJsonFieldAsString(String nodeName, String body) {
        JSONParser parser = JSON.createParser(body);
        String node = '';
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText().equals(nodeName))) {
                // Get the value.
                parser.nextToken();
                //
                node = parser.getText();
            }
        }
        return node;
    }
}