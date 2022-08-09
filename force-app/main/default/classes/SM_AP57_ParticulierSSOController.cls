/*
*   @Projet : Smile
*   @description Gestion de l'authentificatio au selfcare (community)
*   @author Guillaume / Mickaël
*   @sprint Sprint 23/24
*/
global with sharing class SM_AP57_ParticulierSSOController {

    static String token_endpointclisvc = '/services/oauth2/token';

    
    global PageReference particulierAuth() {
        System.debug('particulier sso running');
        SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('digitalweb', 'login');

        String bpno =  ApexPages.currentPage().getParameters().get('bp');
        System.debug('*** params : ' + ApexPages.currentPage().getParameters().keySet());

        xiu.logImportError('usertok',null, ApexPages.currentPage().getParameters().get('token'));
        
        String cryptDat = ApexPages.currentPage().getParameters().get('token');
        System.debug('*** cryptDat : ' + cryptDat);
        if(cryptDat!=null){
            bpno = decryptTok(cryptDat);
        }
        String token = null;
        xiu.logImportError('userbpno',null, bpno);
        
        if(bpno != null){
	        token = getAccessToken(bpno);        
        }
        xiu.logImportError('userjwt',null, token);
        
        
        //https://uat-engiedgpbasesvcs-uat.cs85.force.com/digitaluat/vlocity_cmt__OmniScriptUniversalPage?id={0}&OmniScriptType=ContactSelfcare&OmniScriptSubType=ModificationRDV&OmniScriptLang=French&PrefillDataRaptorBundle=&scriptMode=vertical&layout=newport&ContextId={0}

        SM_Digsvc__c ds = SM_Digsvc__c.getInstance();
        String communityUrl = ds.communityurl__c;  
        String communityName = ds.communityname__c;
        
        xiu.saveLogs();
        
        PageReference pr;
        if(token != null){
            pr = new PageReference(communityUrl + '/' + communityName + '/secur/frontdoor.jsp?sid=' + token +'&retURL='+communityName+'/Selfcare_Modification_RDV&communityName='+ communityName);
        }else{
            pr = new PageReference(communityUrl + '/' + communityName + '/apex/Exception');
        }
        pr.setRedirect(false);
        return pr;
        //   https://nom_de_la_communaute/ParticulierSSO
    }

	/* extract bp number from encrypted token */    
    global static String decryptTok(String cryptDat){
        string bpno;
        Blob exampleIv = Blob.valueOf('Xi44kCyB4i7M26tN');
        Blob key = EncodingUtil.base64Decode('cFBGBl4bvvJk4fPvT9cilQ==');
        Blob data = EncodingUtil.base64Decode(cryptDat);
        Blob decrypted = Crypto.decrypt('AES128', key, exampleIv, data);
        String decryptedString = decrypted.toString();
        System.debug(decryptedString);
        List<String> kvals = decryptedString.split('[=&]');
        System.debug('alls vals: ' + kvals);
        Map<String,String> inputkv = new Map<String,String>();
        while(kvals.size()>1){
            inputkv.put(kvals.remove(0),kvals.remove(0));
        }
        System.debug('alls vals2: ' + inputkv);
        // exemple de donnees attendues : {dateEnvoiEmail=POULIQUEN, nomBP=POULIQUEN, parcoursId=POULIQUEN, refbp=0203654525}        
        bpno = inputkv.get('refbp');
        return bpno;
    }
        
    global static String getAccessToken(string bpno)
    {
        SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('digital', 'login');
	
        SM_Digsvc__c ds = SM_Digsvc__c.getInstance();
        String orgurl = ds.orgurl__c;
        String striss = ds.striss__c;
        String usrnamepostfix = ds.usrnamepostfix__c;
        String xdatausr = ds.xdusr__c;  
        String communityUrl = ds.communityurl__c;  
        String instanceType = ds.instancetype__c;   
        String communityName = ds.communityname__c; 
        String token_endpointusr = '/' + communityName + '/services/oauth2/token';  
        
        System.debug('*** orgUrl : ' + orgurl + token_endpointclisvc); 
        System.debug('*** striss : ' + striss);
        System.debug('*** usrnamepostfix : ' + usrnamepostfix);
        System.debug('*** xdatausr : ' + xdatausr);
        System.debug('*** community : ' + communityUrl);
        System.debug('*** instanceType : ' + instanceType);
        System.debug('*** community name: ' + communityName);
        System.debug('*** bpno : ' + bpno);
        
        String accessTokenusr;
        try{
            
    		while(bpno.length()<10){
            	bpno = '0' + bpno;
        	}
            // Check if the user exists or not
            system.debug('Step 1 check if user exist ') ;
            String usrnameFromsvc = 'clientbp.' + bpno + usrnamepostfix;
            System.debug('particulier sso getAccessToken for: ' + usrnameFromsvc);
            List<User> users = [select accountid, id from User where Contact.Identifiant_Buisness_Partener__c = :bpno];
            System.debug(users);
            if(users.size()>1){
                System.debug('if user exist return');
                return null;
            }
            if(users.size()==0){
                             
                /* 
                you can not write to database and later do callout
                you write to database to create user in another service called now
                then do a callout to OAuth endpoint to create jwt token
                so db write is done in a separate service
                */
    			system.debug('Step 2 create a user');
                system.debug('creating user: ' + usrnameFromsvc + ' - nb usrs' + users.size());
                String tokenclisvc;
                Auth.JWT jwtclisvc = new Auth.JWT();
    
                jwtclisvc.setIss(striss);
                jwtclisvc.setSub(xdatausr);
                jwtclisvc.setAud('https://'+ instanceType + '.salesforce.com');
                Auth.JWS jwsclisvc = new Auth.JWS(jwtclisvc, 'digitalsvcsJWTSign');
                Auth.JWTBearerTokenExchange bearerclisvc = new Auth.JWTBearerTokenExchange('https://'+ instanceType + '.salesforce.com' + token_endpointclisvc, jwsclisvc);
                String accessTokenclisvc;
                system.debug('creating user: ' + usrnameFromsvc + ' - nb usrs' + users.size());
                if(!Test.isRunningTest()){
                    accessTokenclisvc = bearerclisvc.getAccessToken();
                } else{
                    accessTokenclisvc = '123456789';
                } 
    
                system.debug('created access token for the call to create user: ' + usrnameFromsvc);
                
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
        
                System.debug(orgurl + '/services/apexrest/bptousr' + '?bp=' + (String)bpno);
                req.setEndpoint(orgurl + '/services/apexrest/bptousr' + '?bp=' + (String)bpno);
                req.setHeader('Authorization', 'Bearer ' + accessTokenclisvc);
                req.setHeader('Content-Type', 'application/json');  
                System.debug(req.getHeader('Authorization'));  
                Http http = new Http();
                HttpResponse res;
                try {
                    if(!Test.isRunningTest()){
                        res = http.send(req);
                        if(res.getBody()==null){
                            return null;
                        }
                        System.debug('created user: ' + res.getBody());
                    }
    
                } catch (Exception e) {
                    system.debug('failed to get user from bp');
                    return null;
                }
            }
    
            system.debug('Step 3 get users token');
            // get a token for the user
            system.debug('getting token to log user: ' + usrnameFromsvc);
            System.debug('audience : ' + communityUrl + '/' + communityName);
            System.debug('community login url: ' + communityUrl + token_endpointusr);
            Auth.JWT jwtusr = new Auth.JWT();
            jwtusr.setIss(striss);
            jwtusr.setSub(usrnameFromsvc);
            jwtusr.setAud(communityUrl + '/' + communityName);
            System.debug('jwt token: ' + jwtusr);
            Auth.JWS jwsusr = new Auth.JWS(jwtusr, 'digitalsvcsJWTSign');
            System.debug('jws: ' + jwsusr);
            Auth.JWTBearerTokenExchange bearerusr = new Auth.JWTBearerTokenExchange(communityUrl + token_endpointusr, jwsusr);
            System.debug('bearer: ' + bearerusr);
            
            if(!Test.isRunningTest()){
                accessTokenusr = bearerusr.getAccessToken();
                system.debug(bearerusr.getHttpResponse());
            } else{
                accessTokenusr = '123456789';
            } 
            System.debug('access token: ' + accessTokenusr);
        }catch(Exception e){
            System.debug('Exception ' + e);
            xiu.logImportError('tokerr',null, e.getMessage());
        }
        xiu.logImportError('striss',null, striss);
        xiu.logImportError('xdatausr',null, xdatausr);
        xiu.saveLogs();
        return accessTokenusr;

    }
}