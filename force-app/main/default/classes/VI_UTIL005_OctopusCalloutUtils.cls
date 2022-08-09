/*
*@Author: Amal Chreiteh
*@Description: Octpous Callout Utils
*@CreatedDate: 15/11/2020
*@LastModified: 15/11/2020
*/

public without sharing class VI_UTIL005_OctopusCalloutUtils {
    
    /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description Initiate contexte 
* @param application (SM, VI, ..), version (1.0), allow cache ( true, false)
* @return  gdfsuezComBefChpPivot.contextDt defined in the wsdl
*/
    public static gdfsuezComBefChpPivot.contextDt initContext(String application, String version, Boolean allowCache) { 
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        gdfsuezComBefChpPivot.system_element osource = new gdfsuezComBefChpPivot.system_element();
        osource.systemId=application;
        gdfsuezComBefChpPivot.contextDt octx = new gdfsuezComBefChpPivot.contextDt();
        octx.version=version;
        octx.systemPath = new gdfsuezComBefChpPivot.systemPath_element();
        octx.systemPath.system_x = new gdfsuezComBefChpPivot.system_element[] {osource};
        octx.allowCache = allowCache;
        return octx;
    }
    
    
        /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description Intiate picklistValue
* @param value (picklist value)
* @return  gdfsuezComBefChpPivot.listeValeursDt defined in the wsdl
*/
    public static gdfsuezComBefChpPivot.listeValeursDt initValue( String value){
        gdfsuezComBefChpPivot.listeValeursDt valueToReturn = new gdfsuezComBefChpPivot.listeValeursDt();
        valueToReturn.code = value;
        return valueToReturn;
    }
    
          /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description Intiate Consommation Port
* @param value (picklist value)
* @return  gdfsuezComBefChpPivot.listeValeursDt defined in the wsdl
*/  
    public static gdfsuezComBefChpCalypsoConsommation.ConsommationPort initConsommationPort(){        
       	SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
        gdfsuezComBefChpCalypsoConsommation.ConsommationPort port = new gdfsuezComBefChpCalypsoConsommation.ConsommationPort();
        port.clientCertName_x = octopusCS.certName__c;
        port.endpoint_x = octopusCS.endpoint__c + '/E-Consommation_v3';
        port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
        port.timeout_x = 120000;
        System.debug(port);
        return port;
    }
    
    /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description Preparer l'input de la maj d'une personne
* @param outerNode, majPersonneInput, context
* @return void 
*/
    
    public static void populateXmlNode(Dom.XmlNode outerNode, gdfsuezBefCalypsoPersonneV8.majPersonneInputDt majPersonneInput, gdfsuezComBefChpPivotV8.contextDt context){
        Dom.XmlNode majPersonneInputNode = outerNode.addChildElement('majPersonneInput', null, null);
        if(majPersonneInput != null){ 
            majPersonneInput.populateXmlNode(majPersonneInputNode);
        }
        Dom.XmlNode contextNode = outerNode.addChildElement('context', null, null);
        if(context != null){
            context.populateXmlNode(contextNode);
        }
    }
    /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description Preparer l'input de la creer d'une personne
* @param outerNode, creerPersonneInput, context
* @return void 
*/
    public static void populateXmlNode(Dom.XmlNode outerNode, gdfsuezBefCalypsoPersonneV8.creerPersonneInputDt creerPersonneInput, gdfsuezComBefChpPivotV8.contextDt context){
        Dom.XmlNode creerPersonneInputNode = outerNode.addChildElement('creerPersonneInput', null, null);
        if(creerPersonneInputNode != null){ 
            creerPersonneInput.populateXmlNode(creerPersonneInputNode);
        }
        Dom.XmlNode contextNode = outerNode.addChildElement('context', null, null);
        if(context != null){
            context.populateXmlNode(contextNode);
        }
    }
    /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description Preparer l'input de la creation et maj d'une personne
* @param doc, certificateName, context, version, partition
* @return DOM.XmlNode 
*/
    public static DOM.XmlNode populateDoc(DOM.Document doc,String certificateName, String context,String version, string partition){
        String env = 'http://schemas.xmlsoap.org/soap/envelope/';
        String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
        String xsd = 'http://www.w3.org/2001/XMLSchema';
        String v8 = 'http://gdfsuez/bef/calypso/personne/v8';
        DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'soapenv');
        envelope.setNamespace('v8', v8);
        DOM.XmlNode header = envelope.addChildElement('Header', env, 'soapenv');
       // AddHeader(header, certificateName,  context,  version,partition);
        DOM.XmlNode body = envelope.addChildElement('Body', env, 'soapenv'); 
        return body;
    }
    
        /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description AddHeader
* @param doc, certificateName, context, version, partition
* @return void
*/
    public static void AddHeader(DOM.XmlNode header, String certificateName, String context,String version,String partition){
        if (!Test.isRunningTest() || VI_UTIL005_OctopusCalloutUtils_Test.isTestingPopulateDoc) {
            addOcTokenToSOAPReq(header,certificateName,  context,  version, partition);
        }
    }
    
    //Get Octopus Token
    public static boolean addOcTokenToSOAPReq(Dom.XmlNode headernode, String certificateName, String context,String version, String partition){        
        String octoken = getOctopusToken(true, certificateName,  context,  version,partition);
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
        system.debug('%%%%paul32');
        return true;
    }
    
    public static String getOctopusUsername(){
        system.debug('here1');
        String usrid = UserInfo.getUserId();
        NamedCredential[] ncrs = [select id 
                                  from namedcredential 
                                  where developername = 'VI_AuthOctopus'];
        system.debug('ncrs '+ncrs);
        String ncid = '123456789012345';
        if(!Test.isRunningTest()){
            if(ncrs.size()==0){
                return null;
            }
            ncid= ncrs[0].id;
        }
        ExternalDataUserAuth[] auths = [select username 
                                        from ExternalDataUserAuth 
                                        where userid = :usrid 
                                          and ExternalDataSourceId = :ncid ];
        system.debug('auths '+auths);
        if(Test.isRunningTest()){
            return 'HV1002';
        }
        if(auths.size()==0){
            return null;
        }
        system.debug('auths[0].username '+auths[0].username);
        return auths[0].username;
    }
    
    public static String getOctopusToken(boolean usecache, String certificateName, String context, String version, String partition) {
        String endpoint = certificateName+'/E-Session_v1';
        String token;
        String coderetour;
        // On récupère un token dans le cache
        gdfsuezComBefChpCalypsoSessionV1New.openSessionResponse_element response;
        token = getOctopusToken_SAP(partition);
        if(usecache){
            if(Test.isRunningTest()){
                token = '1234567890';
            }
            if (token != null && token != '') {
                String tokenExpiration = '';   
                gdfsuezComBefChpCommunV2New.contextDt  ctxDT = initContext( context, version);  
                gdfsuezComBefChpCalypsoSessionV1New.Dependency dependancy = initDependency(endpoint);    
                gdfsuezComBefChpCalypsoSessionV1New.verifySessionInputDt verifySessionInput = initVerifySessionInput(token);
                if(Test.isRunningTest()){
                    coderetour = 'OCTOPUS_VerifySession_01';
                } else {
                    gdfsuezComBefChpCalypsoSessionV1New.verifySessionResponse_element verifyResponse;
                    verifyResponse = dependancy.VerifySession(verifySessionInput,ctxDT);
                    coderetour  = verifyResponse.messageretours.messageRetour[0].code;
                    if(coderetour == 'OCTOPUS_VerifySession_01'){
                        tokenExpiration = string.valueOfGmt(verifyResponse.verifySessionOutput.tokenExpiration);
                        if (verifyResponse.verifySessionOutput.tokenExpiration != null && System.now() < verifyResponse.verifySessionOutput.tokenExpiration) {
                            setOctopusToken_SAP(token,partition);
                            return token;            
                        }
                    }
                }
            }
        }
        
        try{
            System.debug('getting token from octopus');
            gdfsuezComBefChpCommunV2New.contextDt  ctxDT= initContext( context, version);   
            gdfsuezComBefChpCalypsoSessionV1New.Dependency dependancy = initDependency(endpoint);   
            // If NOT existe dans la cache ==> OpenSession    
            gdfsuezComBefChpCalypsoSessionV1New.openSessionInputDt openSessionInput = initOpenSessionInput(); 
            if(Test.isRunningTest()){
                token = '1234567890';
                coderetour = 'OCTOPUS_OpenSession_01';
            }else{
                response = dependancy.OpenSession(openSessionInput,ctxDT);
                coderetour  = response.messageretours.messageRetour[0].code;
                token = response.openSessionOutput.sessionToken;
            }
            if(coderetour == 'OCTOPUS_OpenSession_01'){
                setOctopusToken_SAP(token,partition);               
            }else{
                String msgretour = response.messageretours.messageRetour[0].libelle;
                token = coderetour + '###'+msgretour;
            }
            return token;
        }catch(Exception e){
            System.debug(e);
            return null;
        }
        
    }
    
        /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description recuperer le token SAP
* @param  partition ( local.smileToken, )
* @return le token
*/  
    
    public static String getOctopusToken_SAP (String parition)
    {           
        Cache.SessionPartition sessionPart = Cache.Session.getPartition(parition);
        String token = (String)sessionPart.get('tokenSAP');    
        return token;
    } 
    
    /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description sauvegarder le token SAP
* @param token, partition ( local.smileToken, )
* @return void
*/  
    
    public static void setOctopusToken_SAP (String token, String partition){//'local.smileToken' 
        if(!String.isBlank(token)){     
            Cache.SessionPartition sessionPart = Cache.Session.getPartition(partition);
            sessionPart.put('tokenSAP', token, Integer.valueOf(Label.SM_CL40_Octopus_Token_TTL));//TTL en secondes 
        }
        
    }
    
            /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description Initiate context
* @param context (VI, SM), version ( 1, 2)
* @return gdfsuezComBefChpCommunV2New.contextDt
*/  
    
    public static gdfsuezComBefChpCommunV2New.contextDt initContext( string context, String version){
        gdfsuezComBefChpCommunV2New.system_element systemValue = new gdfsuezComBefChpCommunV2New.system_element();
        systemValue.systemId = context;
        gdfsuezComBefChpCommunV2New.contextDt  ctxDT= new gdfsuezComBefChpCommunV2New.contextDt();
        ctxDT.version = version;
        ctxDT.system_path = new gdfsuezComBefChpCommunV2New.system_path_element();
        ctxDT.system_path.system_x = new gdfsuezComBefChpCommunV2New.system_element[]{systemValue};
        return ctxDT;
    }
    
        /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description Initiate dependency
* @param endpoint
* @return gdfsuezComBefChpCalypsoSessionV1New.Dependency
*/  
    
    public static gdfsuezComBefChpCalypsoSessionV1New.Dependency initDependency(String endpoint){
        gdfsuezComBefChpCalypsoSessionV1New.Dependency dependancy = new gdfsuezComBefChpCalypsoSessionV1New.Dependency();
        dependancy.endpoint_x = endpoint;
        dependancy.clientCertPasswd_x='';
        dependancy.timeout_x = 5000;
        dependancy.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
        return dependancy;
    }
    
    /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description Initiate verify session input 
* @param 
* @return gdfsuezComBefChpCalypsoSessionV1New.verifySessionInputDt
*/  
    public static gdfsuezComBefChpCalypsoSessionV1New.verifySessionInputDt initVerifySessionInput(String token){
        gdfsuezComBefChpCalypsoSessionV1New.verifySessionInputDt verifySessionInput = new gdfsuezComBefChpCalypsoSessionV1New.verifySessionInputDt();
        verifySessionInput.userId = '{!$Credential.UserName}';
        verifySessionInput.sessionToken = token;
        verifySessionInput.population = 'Conseillers';
        return verifySessionInput;
    }
    
    /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description Initiate open session input 
* @param 
* @return gdfsuezComBefChpCalypsoSessionV1New.openSessionInputDt
*/  
    
    public static gdfsuezComBefChpCalypsoSessionV1New.openSessionInputDt initOpenSessionInput(){
        gdfsuezComBefChpCalypsoSessionV1New.openSessionInputDt openSessionInput = new gdfsuezComBefChpCalypsoSessionV1New.openSessionInputDt();            
        openSessionInput.userId = '{!$Credential.UserName}';
        openSessionInput.password = '{!$Credential.Password}';
        openSessionInput.population = 'Conseillers';
        return openSessionInput;
    }
    
                  /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description Initiate Port 
* @param NamedCredentialName
* @return gdfsuezComBefChpCalypsoConsommation.ConsommationPort
*/  
    
    public static gdfsuezComBefChpCalypsoConsommation.ConsommationPort initConsommationPort(String NamedCredentialName){        
        gdfsuezComBefChpCalypsoConsommation.ConsommationPort port = new gdfsuezComBefChpCalypsoConsommation.ConsommationPort();
        port.endpoint_x = NamedCredentialName + '/E-Consommation_v3';
        port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
        port.timeout_x = 120000;
        System.debug(port);
        return port;
    }
    
              /**
* @author  Amal Chreiteh
* @date  15/11/2020
* @description populate le doc pour l'input de l'estimation de la consommation (infos générales)
* @param DOM.Document doc
* @return DOM.XmlNode
*/  
    
    public static DOM.XmlNode populateDocConso(DOM.Document doc){
			String env = 'http://schemas.xmlsoap.org/soap/envelope/';
			String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
			String xsd = 'http://www.w3.org/2001/XMLSchema';
			DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'soapenv');
			envelope.setNamespace('xsd', xsd);
			envelope.setNamespace('xsi', xsi);
			System.debug(doc.toXmlString());
			DOM.XmlNode body = envelope.addChildElement('Body', env, '');
			return body;
		}
}