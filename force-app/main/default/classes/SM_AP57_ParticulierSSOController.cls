/*
*   @Projet : Smile
*   @description Gestion de l'authentificatio au selfcare (community)
*   @author Guillaume / Mickaël
*   @sprint Sprint 23/24
*/
global with sharing class SM_AP57_ParticulierSSOController {

    static String token_endpointclisvc = '/services/oauth2/token';

    
    global PageReference particulierAuth() {
        SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('digitalweb', 'login');

        String bpno =  ApexPages.currentPage().getParameters().get('bp');

        xiu.logImportError('usertok',null, ApexPages.currentPage().getParameters().get('token'));
        
        String cryptDat = ApexPages.currentPage().getParameters().get('token');
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
        List<String> kvals = decryptedString.split('[=&]');
        Map<String,String> inputkv = new Map<String,String>();
        while(kvals.size()>1){
            inputkv.put(kvals.remove(0),kvals.remove(0));
        }
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
        
        
        String accessTokenusr;
        try{
            
    		while(bpno.length()<10){
            	bpno = '0' + bpno;
        	}
            // Check if the user exists or not
            String usrnameFromsvc = 'clientbp.' + bpno + usrnamepostfix;
            List<User> users = [select accountid, id from User where Contact.Identifiant_Buisness_Partener__c = :bpno];
            if(users.size()>1){
                return null;
            }
            if(users.size()==0){
                             
                /* 
                you can not write to database and later do callout
                you write to database to create user in another service called now
                then do a callout to OAuth endpoint to create jwt token
                so db write is done in a separate service
                */
                String tokenclisvc;
                Auth.JWT jwtclisvc = new Auth.JWT();
    
                jwtclisvc.setIss(striss);
                jwtclisvc.setSub(xdatausr);
                jwtclisvc.setAud('https://'+ instanceType + '.salesforce.com');
                Auth.JWS jwsclisvc = new Auth.JWS(jwtclisvc, 'digitalsvcsJWTSign');
                Auth.JWTBearerTokenExchange bearerclisvc = new Auth.JWTBearerTokenExchange('https://'+ instanceType + '.salesforce.com' + token_endpointclisvc, jwsclisvc);
                String accessTokenclisvc;
                if(!Test.isRunningTest()){
                    accessTokenclisvc = bearerclisvc.getAccessToken();
                } else{
                    accessTokenclisvc = '123456789';
                } 
    
                
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
        
                req.setEndpoint(orgurl + '/services/apexrest/bptousr' + '?bp=' + (String)bpno);
                req.setHeader('Authorization', 'Bearer ' + accessTokenclisvc);
                req.setHeader('Content-Type', 'application/json');  
                Http http = new Http();
                HttpResponse res;
                try {
                    if(!Test.isRunningTest()){
                        res = http.send(req);
                        if(res.getBody()==null){
                            return null;
                        }
                    }
    
                } catch (Exception e) {
                    return null;
                }
            }
    
            // get a token for the user
            Auth.JWT jwtusr = new Auth.JWT();
            jwtusr.setIss(striss);
            jwtusr.setSub(usrnameFromsvc);
            jwtusr.setAud(communityUrl + '/' + communityName);
            Auth.JWS jwsusr = new Auth.JWS(jwtusr, 'digitalsvcsJWTSign');
            Auth.JWTBearerTokenExchange bearerusr = new Auth.JWTBearerTokenExchange(communityUrl + token_endpointusr, jwsusr);
            
            if(!Test.isRunningTest()){
                accessTokenusr = bearerusr.getAccessToken();
            } else{
                accessTokenusr = '123456789';
            } 
        }catch(Exception e){
            xiu.logImportError('tokerr',null, e.getMessage());
        }
        xiu.logImportError('striss',null, striss);
        xiu.logImportError('xdatausr',null, xdatausr);
        xiu.saveLogs();
        return accessTokenusr;

    }
}