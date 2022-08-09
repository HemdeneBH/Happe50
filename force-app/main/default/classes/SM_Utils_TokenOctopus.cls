global class SM_Utils_TokenOctopus {
    
    //static final Integer TOKEN_TIMETOLIVE = 1790;

    // Obtenir un token octopus
    // Mettre usecache = true sauf si on veut un nouveau token (après une erreur technique ?)

    //global static String getOctopusToken(boolean usecache) {
    global static String getOctopusToken(boolean usecache) {
        String token;
        String coderetour;
         gdfsuezComBefChpCalypsoSessionV1New.openSessionResponse_element response;
        SM_UTIL_Cache_Management cacheManager = new SM_UTIL_Cache_Management() ;
        Map<String,Object> output = new Map<String,Object>()  ;
        cacheManager.getOctopusToken_SAP(null,output);
        token = (String) output.get('token') ;
        if(usecache){
           // token = (String) sessPart.get('tokenSAP');
            if (token != null && token != '') {
/*
                //TODO: valider d'utiliser le cache sans refresh
                gdfsuezComBefChpCalypsoSessionV1New.verifySessionInputDt verifySessionInput = new gdfsuezComBefChpCalypsoSessionV1New.verifySessionInputDt();
                verifySessionInput.userId = '{!$Credential.UserName}';
                verifySessionInput.sessionToken = token;
                verifySessionInput.population = 'Conseiller';
                gdfsuezComBefChpCalypsoSessionV1New.verifySessionResponse_element verifyResponse;
                verifyResponse = dependancy.VerifySession(verifySessionInput,ctxDT);
*/
                return token;
            }
        }

        try{
            SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();       
            gdfsuezComBefChpCommunV2New.system_element systemValue = new gdfsuezComBefChpCommunV2New.system_element();
            systemValue.systemId = 'SMILE';
            gdfsuezComBefChpCommunV2New.contextDt  ctxDT= new gdfsuezComBefChpCommunV2New.contextDt();
            ctxDT.version = '1.0';
            ctxDT.system_path = new gdfsuezComBefChpCommunV2New.system_path_element();
            ctxDT.system_path.system_x = new gdfsuezComBefChpCommunV2New.system_element[]{systemValue};

            gdfsuezComBefChpCalypsoSessionV1New.Dependency dependancy = new gdfsuezComBefChpCalypsoSessionV1New.Dependency();
            dependancy.endpoint_x = 'callout:AuthOctopus/E-Session_v1';
            // TODO: le nom du certificat suffit, pas besoin de variabiliser
            dependancy.clientCertName_x = octopusCS.certName__c;
            // TODO: pourquoi le mettre à vide, on peut ne rien mettre ?
            dependancy.clientCertPasswd_x='';
            // TODO: passé de 900 à 5000, verifier que ca marche
            dependancy.timeout_x = 5000;
            dependancy.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
                
            // If NOT existe dans la cache ==> OpenSession    
            gdfsuezComBefChpCalypsoSessionV1New.openSessionInputDt openSessionInput = new gdfsuezComBefChpCalypsoSessionV1New.openSessionInputDt();            
            openSessionInput.userId = '{!$Credential.UserName}';
            openSessionInput.password = '{!$Credential.Password}';
            openSessionInput.population = 'Conseillers';
                
            if(Test.isRunningTest()){
                token = '1234567890';
                coderetour = 'OCTOPUS_OpenSession_01';
            }else{
                response = dependancy.OpenSession(openSessionInput,ctxDT);
                coderetour  = response.messageretours.messageRetour[0].code;
                token = response.openSessionOutput.sessionToken;
            }
            if(coderetour == 'OCTOPUS_OpenSession_01'){
                output.put('token', token) ;
                cacheManager.setOctopusToken_SAP(output,null);               
            }else{
                String msgretour = response.messageretours.messageRetour[0].libelle;
                token = coderetour + '###'+msgretour;
            }
            return token;
        }catch(Exception e){
            return null;
        }
    }


    global static boolean addOcTokenToSOAPReq(Dom.XmlNode headernode){
        String octoken = getOctopusToken(true);
        if(octoken == null || octoken == ''){
            return false;
        }

        Dom.XmlNode secnode = headernode.addChildElement('Security','http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd','wsse');
        secnode.setAttribute('soapenv:mustUnderstand','0');
        Dom.XmlNode usertoknode = secnode.addChildElement('wsse:UsernameToken',null,null);
        usertoknode.setAttribute('xmlns:wsu', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd');
        usertoknode.setAttribute('wsu:Id', 'UsernameToken-1');

        Dom.XmlNode userNameNode = usertoknode.addChildElement('wsse:Username', null, null);
       // userNameNode.addTextNode('{!$Credential.UserName}');

        Dom.XmlNode passwnode = usertoknode.addChildElement('wsse:Password',null,null);
        passwnode.setAttribute('Type', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText');
    
        usernamenode.addTextNode(getOctopusUsername());
        passwnode.addTextNode(octoken);
        
        return true;
    }

    @AuraEnabled(cacheable=true)
    global static String getOctopusUsername(){
        
        String usrid = UserInfo.getUserId();
        NamedCredential[] ncrs = [select id from namedcredential where developername = 'AuthOctopus'];
        String ncid = '123456789012345';
        if(!Test.isRunningTest()){
            if(ncrs.size()==0){
                return null;
            }
            ncid= ncrs[0].id;
        }
        ExternalDataUserAuth[] auths = [select username from ExternalDataUserAuth where userid = :usrid and ExternalDataSourceId = :ncid ];
        if(Test.isRunningTest()){
            return 'HV1002';
        }
        if(auths.size()==0){
            return null;
        }
        return auths[0].username;
    }

    
    @AuraEnabled(cacheable=true)
    global static String checkOctopusUser(){
        return checkOctopusUserIntern(true);
    } 
    
    global static String checkOctopusUserIntern(boolean usecache){
        String usrid = UserInfo.getUserId();
        NamedCredential[] ncrs = [select id from namedcredential where developername = 'AuthOctopus'];
        String ncid = '123456789012345';
        if(!Test.isRunningTest()){
            if(ncrs.size()==0){
                return 'OCTOPUS_OpenSession_Global###Erreur de configuration globale, pas de connectivité Octopus configurée';
            }
            ncid= ncrs[0].id;
        }
        ExternalDataUserAuth[] auths = [select id from ExternalDataUserAuth where userid = :usrid and ExternalDataSourceId = :ncid ];
        if((auths.size()==0)&&(!Test.isRunningTest())){
            return 'OCTOPUS_OpenSession_User###Configurez votre nom d\'utilisateur et mot de passe SAP';
        }
        // login SAP, lecture du code retour
        // Mettre getOctopusToken(false) si le password vient d'etre changé
        // format si erreur : code##libelle
        return getOctopusToken(usecache);
    } 

/*
    @AuraEnabled(cacheable=true)
    global static String updateOctopusLogin(String uname, String pword){
        if(uname == null || uname == '' || pword == null || pword == '')
            return null;
        String usrid = UserInfo.getUserId();
        NamedCredential[] ncrs = [select id from namedcredential where developername = 'AuthOctopus'];
        String ncid = '123456789012345';
        if(!Test.isRunningTest()){
            if(ncrs.size()==0){
                return null;
            }
            ncid= ncrs[0].id;
        }
        ExternalDataUserAuth theUser;
        ExternalDataUserAuth[] auths = [select id from ExternalDataUserAuth where userid = :usrid and ExternalDataSourceId = :ncid ];
        if((auths.size()==0)||(Test.isRunningTest())){
            theUser = new ExternalDataUserAuth();
            theUser.username = uname;
            theUser.Password = pword;
            theUser.Protocol = 'Password';
            theUser.ExternalDataSourceId = ncid;
            //insert theUser;
        }else{
            theUser = auths[0];
            theUser.username = uname;
            theUser.Password = pword;
            //update theUser;
        }
        return auths[0].username;
    }
*/
}