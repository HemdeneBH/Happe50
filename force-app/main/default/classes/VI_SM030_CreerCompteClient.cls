/*
*@Auhtor: Paul Ghoussoub
*@Description: Appel de l'API  CompteClient_v6 afin de créer un compte client
*@CreatedDate: 20/05/2021
*/
public without sharing class VI_SM030_CreerCompteClient {
    
    public static VI_UTIL006_Cache_Management service = new VI_UTIL006_Cache_Management();
    /*
*@Auhtor: Paul Ghoussoub
*@Description Création du compte client suite à l'appel du webservice CompteClient_v6
*@CreatedDate: 15/02/2021
*/
    public static String CreerCompteClient(String conditionPaiement,String idPersonne, String idCoordonneesBancaires, String descriptionCompteClient,String application, String version,String NamedCredentialName){
        
        gdfsuezComBefChpPivotCompteClient.contextDt octx = initContext(application,version);
        gdfsuezBefCalypsoCompteclientV6.Dependency port = initPort(NamedCredentialName);
        gdfsuezBefCalypsoCompteclientV6.creerCompteClientInputDt input = generercreerCompteClientInputDt(conditionPaiement,idPersonne,descriptionCompteClient, idCoordonneesBancaires);
        gdfsuezBefCalypsoCompteclientV6.creerCompteClientResponse_element response;
        
        if(!Test.isRunningTest()) {
            system.debug('before http');
            Datetime x =  Datetime.now();
            Integer m = x.millisecond();
            system.debug('OCTOPUS START CreerCompteClient_Http: '+x+':'+m); 
            response=CreerCompteClient_Http(input,octx,port);
            Datetime y =  Datetime.now();
            Integer n = y.millisecond();
            system.debug('OCTOPUS END CreerCompteClient_Http: '+y+':'+n);
            system.debug('after http'+ response);
            system.debug('after http'+ response.creerCompteClientOutput);
            system.debug('response.creerCompteClientOutput.compteClient' + response.creerCompteClientOutput.compteClient);
            system.debug('response.creerCompteClientOutput.compteClient.idCompteClient ' + response.creerCompteClientOutput.compteClient.idCompteClient);
            system.debug('response.messageRetours.retourTraitementMessage[0].codet ' + response.messageRetours.retourTraitementMessage[0].code);
            if(response.messageRetours != null && response.messageRetours.retourTraitementMessage[0].code != 'OCTOPUS_CreerCompteClient_01'){
                return 'Erreur: '+ response.messageRetours.retourTraitementMessage[0].libelle;
            }
            else{
                return response.creerCompteClientOutput.compteClient.idCompteClient;
            }
            
        }
        else {
            Test.setMock(HttpCalloutMock.class, new VI_SM030_CreerCompteClient_Mock());
            gdfsuezBefCalypsoCompteclientV6.Dependency porttest = new gdfsuezBefCalypsoCompteclientV6.Dependency();
            system.debug('@@ start of mock');  
            response=CreerCompteClient_Http(input,octx,porttest);
            system.debug('@@ end of mock');
            return response.creerCompteClientOutput.compteClient.idCompteClient;
        }
    }
    /*
*@Auhtor: Paul Ghoussoub
*@Description Génération du contexte
*@CreatedDate: 15/02/2021
*/
    public static gdfsuezComBefChpPivotCompteClient.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_system_element osource = new gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_system_element();
        osource.systemId=application;
        gdfsuezComBefChpPivotCompteClient.contextDt octx = new gdfsuezComBefChpPivotCompteClient.contextDt();
        octx.version=version;
        octx.allowcache=false;
        octx.systemPath = new gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_element();
        octx.systemPath.system_x = new gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_system_element[] {osource};
            return octx;
    } 
    
    
    /*
*@Auhtor: Paul Ghoussoub
*@Description Génération du port
*@CreatedDate: 15/02/2021
*/
    public static gdfsuezBefCalypsoCompteclientV6.Dependency initPort(String NamedCredentialName){
        gdfsuezBefCalypsoCompteclientV6.Dependency port = new gdfsuezBefCalypsoCompteclientV6.Dependency();
        port.endpoint_x =  NamedCredentialName+'/E-CompteClient_v6';
        port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
            return port;
    }
    
    /*@Author: Paul Ghoussoub
*@Description: Appel Http vers le service CompteClient
*@CreatedDate: 16/02/2021
*/
    
    public static gdfsuezBefCalypsoCompteclientV6.creerCompteClientResponse_element CreerCompteClient_Http(gdfsuezBefCalypsoCompteclientV6.creerCompteClientInputDt creerCompteClientInput,gdfsuezComBefChpPivotCompteClient.contextDt context,
                                                                                                           gdfsuezBefCalypsoCompteclientV6.Dependency port) 
    {
        DOM.Document doc = new DOM.Document();
        DOM.XmlNode body = populateDoc(doc);
        DOM.XmlNode methodNode = body.addChildElement('v6:creerCompteClient', null, null);	
        system.debug('doc '+doc.toXmlString());
        gdfsuezBefCalypsoCompteclientV6.creerCompteClient_element request_x = new gdfsuezBefCalypsoCompteclientV6.creerCompteClient_element(creerCompteClientInput,context);
        populateXmlNode(methodNode,creerCompteClientInput,context);
        system.debug('methodNode '+doc.toXmlString());
        HttpRequest req = new HttpRequest();
        req.setEndpoint(port.endpoint_x);  	
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        req.setHeader('SOAPAction', 'tns:CreerCompteClient');
        req.setBodyDocument(doc);
        req.setTimeout(120000);
        
        System.debug('reqbody '+req.getBodyDocument().getRootElement());
        Http http = new Http();
        HTTPResponse res = http.send(req);
        system.debug('res '+res);
        System.debug(res.getBody());
        Dom.Document responseDoc = res.getBodyDocument();
        system.debug('responseDoc '+responseDoc.toXmlString());
        Dom.XmlNode rootNode = responseDoc.getRootElement();
        Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
        Dom.XmlNode creerCompteClientResponseNode = bodyNode.getChildElement('creerCompteClientResponse', 'http://gdfsuez/bef/calypso/compteclient/v6');
        
        gdfsuezBefCalypsoCompteclientV6.creerCompteClientResponse_element response_x = parseResponseElement(creerCompteClientResponseNode);
        system.debug('response_x '+response_x);
        return response_x;
    }
    
    /*
*@Auhtor: Paul Ghoussoub
*@Description Recupérer la valeur des Nodes provenant du retour et les parse en gdfsuezBefCalypsoCompteclientV6.creerCompteClientResponse_element
*@CreatedDate: 15/02/2021
*/
    private static gdfsuezBefCalypsoCompteclientV6.creerCompteClientResponse_element parseResponseElement(Dom.XmlNode responseNode){
        gdfsuezBefCalypsoCompteclientV6.creerCompteClientResponse_element element = new gdfsuezBefCalypsoCompteclientV6.creerCompteClientResponse_element();
        system.debug('responseNode '+responseNode);
        Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
        System.debug('CreerCompteClientResponse'+ responseNode);
        DOM.XmlNode creerCompteClientOutputNode = responseNode.getChildElement('creerCompteClientOutput', null);
        if(creerCompteClientOutputNode == null){
            system.debug('creerCompteClientOutputNode'+ creerCompteClientOutputNode);
            element.creerCompteClientOutput = null;
        } else{
            system.debug('creerCompteClientOutputNode'+ creerCompteClientOutputNode);
            gdfsuezBefCalypsoCompteclientV6.creerCompteClientOutputDt creerCompteClientOutputObj = new gdfsuezBefCalypsoCompteclientV6.creerCompteClientOutputDt();
            DOM.XmlNode compteClientNode = creerCompteClientOutputNode.getChildElement('compteClient', null);
            if(compteClientNode == null){
                creerCompteClientOutputObj.compteClient = null;
            } else{
                gdfsuezComBefCalypsoComptecltV6.CompteClientAbstract compteClientObj = new gdfsuezComBefCalypsoComptecltV6.CompteClientAbstract();
                DOM.XmlNode idCompteClientNode = compteClientNode.getChildElement('idCompteClient', null);
                system.debug('idCompteClientNode'+ idCompteClientNode);
                if(idCompteClientNode==null){
                    compteClientObj.idCompteClient=null;
                }
                else{
                    system.debug('idCompteClientNode.getText()'+ idCompteClientNode.getText());
                    compteClientObj.idCompteClient = idCompteClientNode.getText();
                    nodesParsed.add(idCompteClientNode);
                }
                nodesParsed.add(compteClientNode);
                creerCompteClientOutputObj.compteClient = compteClientObj;
            }
            nodesParsed.add(creerCompteClientOutputNode);
            element.creerCompteClientOutput = creerCompteClientOutputObj;
        }
        System.debug(element.creerCompteClientOutput);			
        DOM.XmlNode messageRetoursNode = responseNode.getChildElement('messageRetours', null);
        system.debug('messageRetoursNode'+ messageRetoursNode);
        if(messageRetoursNode == null){
            element.messageRetours = null;
        } else{
            gdfsuezComBefChpPivotCompteClient.retourTraitementMessagesDt messageRetoursObj = new gdfsuezComBefChpPivotCompteClient.retourTraitementMessagesDt(messageRetoursNode);
            nodesParsed.add(messageRetoursNode);
            Dom.XmlNode[] retourTraitementMessageChildren = messageRetoursNode.getChildElements();
            gdfsuezComBefChpPivotCompteClient.retourTraitementMessageDt[] retourTraitementMessageList = new List<gdfsuezComBefChpPivotCompteClient.retourTraitementMessageDt>();
            if(retourTraitementMessageChildren == null || retourTraitementMessageChildren.size() == 0){
                messageRetoursObj.retourTraitementMessage = null;
            } else{
                for(DOM.XmlNode childNode : retourTraitementMessageChildren){
                    if(childNode.GetName() == 'retourTraitementMessage'){
                        gdfsuezComBefChpPivotCompteClient.retourTraitementMessageDt Obj = new gdfsuezComBefChpPivotCompteClient.retourTraitementMessageDt();
                        DOM.XmlNode codeMessageRetour = childNode.getChildElement('code', null);
                        system.debug('codeMessageRetour'+ codeMessageRetour);
                        if(codeMessageRetour==null){
                            Obj.code = null;
                        }
                        else{
                            system.debug('codeMessageRetour.getText()'+ codeMessageRetour.getText());
                            Obj.code = codeMessageRetour.getText();
                            nodesParsed.add(codeMessageRetour);
                        }
                        retourTraitementMessageList.Add(Obj);
                        nodesParsed.add(childNode);
                    }
                }
                messageRetoursObj.retourTraitementMessage = retourTraitementMessageList;
            }
            
            element.messageRetours = messageRetoursObj;
        }
        return element;
    }
    /*
*@Auhtor: Paul Ghoussoub
*@Description Remplir le header du doc XML de l'input
*@CreatedDate: 15/02/2021
*/
    private static DOM.XmlNode populateDoc(DOM.Document doc){
        String env = 'http://schemas.xmlsoap.org/soap/envelope/';
        String v6 ='http://gdfsuez/bef/calypso/compteclient/v6';
        DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'soapenv');
        envelope.setNamespace('v6', v6);
        DOM.XmlNode header = envelope.addChildElement('soapenv:Header', null, null);
        DOM.XmlNode body = envelope.addChildElement('soapenv:Body', null, null);
        return body;
    }
    /*@Author: Paul Ghoussoub
*@Description: Génération de l'input
*@CreatedDate: 16/02/2021
*/
    public static gdfsuezBefCalypsoCompteclientV6.creerCompteClientInputDt generercreerCompteClientInputDt(String conditionPaiement,String idPersonne,String descriptionCompteClient, String idCoordonnesBancaires){
        //condition paiement devrait etre +14B
        gdfsuezComBefChpPivotCompteClient.listeValeursDt listeConditionPaiements=createConditionPaiement(conditionPaiement);
        gdfsuezComBefCalypsoCoordonneesbanc.CoordonneesBancairesAbstract coob = new gdfsuezComBefCalypsoCoordonneesbanc.CoordonneesBancairesAbstract();
        coob.idCoordonneesBancaires = idCoordonnesBancaires;
        gdfsuezComBefCalypsoComptecltV6.CompteClient CompteClient=new gdfsuezComBefCalypsoComptecltV6.CompteClient();
        CompteClient.conditionPaiement=listeConditionPaiements;
        CompteClient.idCompteClient=idPersonne;
        CompteClient.descriptionCompteClient=descriptionCompteClient;
        CompteClient.coordonneeBancaire = coob;
        gdfsuezBefCalypsoCompteclientV6.creerCompteClientInputDt input=new gdfsuezBefCalypsoCompteclientV6.creerCompteClientInputDt();
        input.compteClient=CompteClient;
        return input;
    }
    /*
*@Auhtor: Paul Ghoussoub
*@Description Intiate picklistValue
*@CreatedDate: 15/02/2021
*/
    public static gdfsuezComBefChpPivotCompteClient.listeValeursDt createConditionPaiement( String value){
        gdfsuezComBefChpPivotCompteClient.listeValeursDt valueToReturn = new gdfsuezComBefChpPivotCompteClient.listeValeursDt();
        valueToReturn.code = value;
        return valueToReturn;
    }
    /*
*@Auhtor: Paul Ghoussoub
*@Description Remplir le corps du doc XML de l'input
*@CreatedDate: 15/02/2021
*/
    public static void populateXmlNode(Dom.XmlNode outerNode,gdfsuezBefCalypsoCompteclientV6.creerCompteClientInputDt input,gdfsuezComBefChpPivotCompteClient.contextDt context){
        system.debug('input '+input);
        Dom.XmlNode creerCompteClientInputNode = outerNode.addChildElement('creerCompteClientInput', null, null);
        if(input != null){
            //input.populateXmlNode(creerCompteClientInputNode);
            gdfsuezComBefCalypsoComptecltV6.CompteClient compteClientObj = input.compteClient;
            Dom.XmlNode compteClientNode = creerCompteClientInputNode.addChildElement('compteClient', '', '');
            if(compteClientObj != null){
                Dom.XmlNode testNod4 = compteClientNode.addChildElement('conditionPaiement', null, null);
                Dom.XmlNode testchildNode4 = testNod4.addChildElement('code', null, null);
                testchildNode4.addTextNode(input.CompteClient.conditionPaiement.code);
                
                if(input.CompteClient.coordonneeBancaire.idCoordonneesBancaires!=null)
                {
                    gdfsuezComBefCalypsoCoordonneesbanc.CoordonneesBancairesAbstract coordonneeBancaireObj = compteClientObj.coordonneeBancaire;
                    Dom.XmlNode coordonneeBancaireNode = compteClientNode.addChildElement('coordonneeBancaire', null, null);
                    Dom.XmlNode idCoordonneesBancairesNode = coordonneeBancaireNode.addChildElement('idCoordonneesBancaires', null, null);
                    idCoordonneesBancairesNode.addTextNode(input.CompteClient.coordonneeBancaire.idCoordonneesBancaires);
                }
                //if(coordonneeBancaireObj != null){
                    //Dom.XmlNode idCoordonneesBancairesNode = coordonneeBancaireNode.addChildElement('idCoordonneesBancaires', '', '');
                    //<idCoordonneesBancaires>200377460-02</idCoordonneesBancaires>
                    //idCoordonneesBancairesNode.addTextNode((coordonneeBancaireObj.idCoordonneesBancaires == null) ? '' : coordonneeBancaireObj.idCoordonneesBancaires);
                    //idCoordonneesBancairesNode.addTextNode('200377460-02');
                //}
                
                Dom.XmlNode testNode6 = compteClientNode.addChildElement('descriptionCompteClient', null, null);
                testNode6.addTextNode(input.CompteClient.descriptionCompteClient);
                
                Dom.XmlNode testNode = compteClientNode.addChildElement('contractant', null, null);
                Dom.XmlNode testchildNode = testNode.addChildElement('idPersonne', null, null);
                testchildNode.addTextNode(input.CompteClient.idCompteClient);
            }
        }
        
        Dom.XmlNode contextNode = outerNode.addChildElement('context', null, null);
        system.debug('context '+context);
        if(context != null){
            Dom.XmlNode versionNode = contextNode.addChildElement('version', null, null);
            if(context.version != null){
                versionNode.addTextNode(context.version);
            }
            
            gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_element systemPathObj = context.systemPath;
            Dom.XmlNode systemPathNode = contextNode.addChildElement('systemPath',null, null);
            if(systemPathObj != null){
                gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_system_element[] system_xObj = systemPathObj.system_x;
                if(system_xObj != null){
                    for(gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_system_element element: system_xObj){
                        Dom.XmlNode system_xNode = systemPathNode.addChildElement('system', null, null);
                        Dom.XmlNode systemIdNode = system_xNode.addChildElement('systemId', null, null);
                        if(element.systemId != null){
                            systemIdNode.addTextNode(element.systemId);
                        }
                    }
                }	
            }
            Dom.XmlNode allowCacheNode = contextNode.addChildElement('allowCache', null,null);
            allowCacheNode.addTextNode((context.allowCache == null) ? '' : String.valueOf(context.allowCache));
        }
    }
}