public class VI_SM037_ComposerMandat {
    public static VI_UTIL006_Cache_Management service = new VI_UTIL006_Cache_Management();
    /*
*@Auhtor: Paul Ghoussoub
*@Description Génération du contexte
*@CreatedDate: 15/02/2021
*/
    public static VI_gdfsuezComBefChpPivot.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        VI_gdfsuezComBefChpPivot.system_element osource = new VI_gdfsuezComBefChpPivot.system_element();
        osource.systemId=application;
        VI_gdfsuezComBefChpPivot.contextDt octx = new VI_gdfsuezComBefChpPivot.contextDt();
        octx.version=version;
        octx.systemPath = new VI_gdfsuezComBefChpPivot.systemPath_element();
        octx.systemPath.system_x = new VI_gdfsuezComBefChpPivot.system_element[] {osource};
            return octx;
    }
    
    /*
*@Auhtor: Paul Ghoussoub
*@Description Génération du port
*@CreatedDate: 15/02/2021
*/
    public static VI_gdfsuezBefCalypsoMandatV1.MandatPort initPort(String NamedCredentialName){
        VI_gdfsuezBefCalypsoMandatV1.MandatPort port = new VI_gdfsuezBefCalypsoMandatV1.MandatPort();
        port.endpoint_x =  NamedCredentialName+'/ES-Mandat_v1';
        port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
            return port;
    }
    
    /*
*@Auhtor: Paul Ghoussoub
*@Description Création de l'input à partir du mandat et de la personne afin de faire l'appel ws
*@CreatedDate: 15/02/2021
*/
    public static retourMandat composerMandat(String code,VI_Parcours__c parcours,Contact contactDuParcours, Boolean retourPDF,String application, String version,String NamedCredentialName){
        String responseCodeSignature;
        String responseLibelleSignature;
        VI_gdfsuezComBefChpPivot.contextDt octx = initContext(application,version);
        VI_gdfsuezBefCalypsoMandatV1.MandatPort port = initPort(NamedCredentialName);
        VI_gdfsuezBefCalypsoMandatV1.composerMandatInputDt composerMandatInput = generercomposerMandatInputDt(code,retourPDF);
        VI_gdfsuezBefCalypsoMandatV1.composerMandatResponse_element response = new VI_gdfsuezBefCalypsoMandatV1.composerMandatResponse_element();
        if (!Test.isRunningTest()) {
            system.debug('composerMandatInput '+composerMandatInput);
            response  = composerMandat_Http(composerMandatInput,octx,port,parcours,contactDuParcours);
            if(response!=null &&response.composerMandatOutput!=null && response.composerMandatOutput.mandatCompose !=null && response.composerMandatOutput.mandatCompose.idDocument !=null){
                return new retourMandat(response.composerMandatOutput.mandatCompose.idDocument,response.composerMandatOutput.mandatCompose.contenuDocument,  null);
            }
        }
        else {
            Test.setMock(HttpCalloutMock.class, new VI_SM037_ComposerMandat_Mock());
            VI_gdfsuezBefCalypsoMandatV1.MandatPort portTest = new VI_gdfsuezBefCalypsoMandatV1.MandatPort();
            response  = composerMandat_Http(composerMandatInput,octx,portTest,parcours,contactDuParcours);
            
            return new retourMandat(response.composerMandatOutput.mandatCompose.idDocument,response.composerMandatOutput.mandatCompose.contenuDocument,  null);
        }
        
        if(response!=null && response.messageRetours!=null && response.messageRetours.retourTraitementMessage[0]!=null && response.messageRetours.retourTraitementMessage[0].code!=null){
            responseCodeSignature = response.messageRetours.retourTraitementMessage[0].code;
            responseLibelleSignature = response.messageRetours.retourTraitementMessage[0].libelle;
            return new retourMandat(null,null,  responseCodeSignature + responseLibelleSignature);
        }
        else{
            return new retourMandat(null,null, 'Erreur lors de la composition du mandat');
        }
        
    }
    
    /*@Author: Paul Ghoussoub
*@Description: Appel Http vers le service CompteClient
*@CreatedDate: 16/02/2021
*/
    
    public static VI_gdfsuezBefCalypsoMandatV1.composerMandatResponse_element composerMandat_Http(VI_gdfsuezBefCalypsoMandatV1.composerMandatInputDt composerMandatInput,VI_gdfsuezComBefChpPivot.contextDt context,
                                                                                                           VI_gdfsuezBefCalypsoMandatV1.MandatPort port,VI_Parcours__c parcours,
                                          Contact contactDuParcours) 
    {
        system.debug('Composer Mandat: parcours.VI_Id_coordonnees_bancaires__c'+ parcours.VI_Id_coordonnees_bancaires__c);
        String IBAN=VI_SM027_CoordonneesBancaires.getCoordonneesBancairesById('0'+parcours.VI_IDReferenceClient__c,parcours.VI_Id_coordonnees_bancaires__c ,'VI','local.VIToken');
        DOM.Document doc = new DOM.Document();
        DOM.XmlNode body = populateDoc(doc);
        DOM.XmlNode methodNode = body.addChildElement('v1:composerMandat', null, null);	
        system.debug('doc '+doc.toXmlString());
        populateXmlNode(methodNode,composerMandatInput,context,parcours,contactDuParcours,IBAN);
        system.debug('methodNode '+doc.toXmlString());
        HttpRequest req = new HttpRequest();
        req.setEndpoint(port.endpoint_x);  	
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        req.setHeader('SOAPAction', 'tns:composerMandat');
        req.setBodyDocument(doc);
        req.setTimeout(120000);
        
        System.debug('reqbody '+req.getBodyDocument().getRootElement());
        Http http = new Http();
        HTTPResponse res;
        if(!Test.isRunningTest()){
              res= http.send(req);
        }
        else{
            Test.setMock(HttpCalloutMock.class, new VI_SM037_ComposerMandat_Mock());
              res = http.send(req);
        }       
        system.debug('res '+res);
        System.debug(res.getBody());
        
        Dom.Document responseDoc = res.getBodyDocument();
        system.debug('responseDoc '+responseDoc.toXmlString());
        Dom.XmlNode rootNode = responseDoc.getRootElement();
        Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
        system.debug('bodyNode'+ bodyNode);
        Dom.XmlNode composerMandatResponseNode = bodyNode.getChildElement('composerMandatResponse', 'http://gdfsuez/bef/calypso/mandat/v1');
        system.debug('composerMandatResponseNode'+ composerMandatResponseNode);
        VI_gdfsuezBefCalypsoMandatV1.composerMandatResponse_element response=parseResponseElement(composerMandatResponseNode);
        return response;
        /*
        Dom.XmlNode composerMandatOutputNode = composerMandatResponseNode.getChildElement('composerMandatOutput', null);
        system.debug('composerMandatOutputNode'+ composerMandatOutputNode);
        Dom.XmlNode mandatComposeNode = composerMandatOutputNode.getChildElement('mandatCompose', null);
        system.debug('idDocumentNode'+ mandatComposeNode);
        Dom.XmlNode idDocumentNode = mandatComposeNode.getChildElement('idDocument', null);
        system.debug('idDocumentNode'+ idDocumentNode);
        System.debug('idDocumentNode.getText()'+ idDocumentNode.getText());
        return idDocumentNode.getText();*/
    }
    
    public static VI_gdfsuezBefCalypsoMandatV1.composerMandatInputDt generercomposerMandatInputDt(String code, Boolean retourPDF){
        VI_gdfsuezBefCalypsoMandatV1.composerMandatInputDt input =new VI_gdfsuezBefCalypsoMandatV1.composerMandatInputDt();
        VI_gdfsuezComBefChpPivot.listeValeursDt idFormulaire =new VI_gdfsuezComBefChpPivot.listeValeursDt();
        idFormulaire.code=code;
        input.idFormulaire=idFormulaire;
        input.retourPDF=retourPDF;
        return input;
    }
    
    public class documents{
        public document document;
    }
    public class document{
        public enteteTechnique enteteTechnique;
    }
    public class enteteTechnique{
        public String TYPEDOC;
    }
    
    /*
*@Auhtor: Paul Ghoussoub
*@Description Remplir le header du doc XML de l'input
*@CreatedDate: 27/04/2021
*/
    private static DOM.XmlNode populateDoc(DOM.Document doc){
        String env = 'http://schemas.xmlsoap.org/soap/envelope/';
        String v1 ='http://gdfsuez/bef/calypso/mandat/v1';
        DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'soapenv');
        envelope.setNamespace('v1', v1);
        DOM.XmlNode header = envelope.addChildElement('soapenv:Header', null, null);
        DOM.XmlNode body = envelope.addChildElement('soapenv:Body', null, null);
        return body;
    }
    
    /*
*@Auhtor: Paul Ghoussoub
*@Description Remplir le corps du doc XML de l'input
*@CreatedDate: 27/04/2021
*/
    public static void populateXmlNode(Dom.XmlNode outerNode,VI_gdfsuezBefCalypsoMandatV1.composerMandatInputDt input,
                                       VI_gdfsuezComBefChpPivot.contextDt context,VI_Parcours__c parcours,Contact contactDuParcours,String IBANValue){
        system.debug('input '+input);
        Dom.XmlNode composerMandatInputNode = outerNode.addChildElement('composerMandatInput', null, null);
        if(input != null){
            VI_gdfsuezComBefChpPivot.listeValeursDt idFormulaireObj=input.idFormulaire;
            if(idFormulaireObj!=null){
                Dom.XmlNode idFormulaireNode = composerMandatInputNode.addChildElement('idFormulaire', null, null);  
                Dom.XmlNode codeNode = idFormulaireNode.addChildElement('code', null, null);
                codeNode.addTextNode(idFormulaireObj.code);
            }
            
            Dom.XmlNode documentXMLMetadonneesNode = composerMandatInputNode.addChildElement('documentXMLMetadonnees', null, null);  
            Dom.XmlNode DocumentsNode = documentXMLMetadonneesNode.addChildElement('documents', null, null); 
            Dom.XmlNode DocumentNode = DocumentsNode.addChildElement('document', null, null); 
            
            //Remplir le bloc entete technique
            Dom.XmlNode enteteTechniqueNode = DocumentNode.addChildElement('enteteTechnique', null, null); 
            Dom.XmlNode TYPEDOC = enteteTechniqueNode.addChildElement('TECH.TYPEDOC', null, null); 
            TYPEDOC.addTextNode('ZLET');
            Dom.XmlNode SAPID = enteteTechniqueNode.addChildElement('TECH.SAPID', null, null); 
            SAPID.addTextNode('ZMDT'+parcours.VI_ID_Mandat__c+parcours.VI_IDReferenceClient__c);
            Dom.XmlNode ENVOI_AFP = enteteTechniqueNode.addChildElement('TECH.ENVOI_AFP', null, null); 
            ENVOI_AFP.addTextNode('N');
            Dom.XmlNode ENVOI_EMAIL = enteteTechniqueNode.addChildElement('TECH.ENVOI_EMAIL', null, null); 
            ENVOI_EMAIL.addTextNode('N');
            Dom.XmlNode ENVOI_SMS = enteteTechniqueNode.addChildElement('TECH.ENVOI_SMS', null, null); 
            ENVOI_SMS.addTextNode('N');
            Dom.XmlNode ENVOI_FAX = enteteTechniqueNode.addChildElement('TECH.ENVOI_FAX', null, null);
            ENVOI_FAX.addTextNode('N');
            Dom.XmlNode MODELE_METIER = enteteTechniqueNode.addChildElement('TECH.MODELE_METIER', null, null);
            MODELE_METIER.addTextNode('MANDAT_POUR_SIGNATURE_ELECTRONIQUE');
            Dom.XmlNode MODELE_STRS = enteteTechniqueNode.addChildElement('TECH.MODELE_STRS', null, null); 
            MODELE_STRS.addTextNode('MANDAT_POUR_SIGNATURE_ELECTRONIQUE');
            Dom.XmlNode ENVOI_GED = enteteTechniqueNode.addChildElement('TECH.ENVOI_GED', null, null);
            ENVOI_GED.addTextNode('O');
            Dom.XmlNode SIGNE_LIGNE = enteteTechniqueNode.addChildElement('TECH.SIGNE_LIGNE', null, null); 
            SIGNE_LIGNE.addTextNode('O');
            Dom.XmlNode IMPRESSION_LOCALE = enteteTechniqueNode.addChildElement('TECH.IMPRESSION_LOCALE', null, null);
            IMPRESSION_LOCALE.addTextNode('N');
            Dom.XmlNode CODE_TYPE_DOC = enteteTechniqueNode.addChildElement('TECH.CODE_TYPE_DOC', null, null);
            CODE_TYPE_DOC.addTextNode('019');
            Dom.XmlNode CODE_CLIENT = enteteTechniqueNode.addChildElement('TECH.CODE_CLIENT', null, null);
            CODE_CLIENT.addTextNode('OCTOPUS');
           
            
            
            //Remplir le bloc correspondance
            Dom.XmlNode correspondanceNode = DocumentNode.addChildElement('correspondance', null, null); 
            Dom.XmlNode DESTINATAIRENode = correspondanceNode.addChildElement('DESTINATAIRE', null, null); 
            Dom.XmlNode CIVILITE = DESTINATAIRENode.addChildElement('DESTINATAIRE.CIVILITE', null, null); 
            CIVILITE.addTextNode(contactDuParcours.Salutation);
            Dom.XmlNode NOM = DESTINATAIRENode.addChildElement('DESTINATAIRE.NOM', null, null); 
            NOM.addTextNode(contactDuParcours.LastName);
            Dom.XmlNode PRENOM = DESTINATAIRENode.addChildElement('DESTINATAIRE.PRENOM', null, null);
            PRENOM.addTextNode(contactDuParcours.FirstName);
            Dom.XmlNode REFERENCE = DESTINATAIRENode.addChildElement('DESTINATAIRE.REFERENCE', null, null);
            REFERENCE.addTextNode(parcours.VI_IDReferenceClient__c);
            
            Dom.XmlNode DESTINATIONNode = correspondanceNode.addChildElement('DESTINATION', null, null); 
            if(contactDuParcours.Complement_adresse__c!=null){
                Dom.XmlNode COMPLEMENT = DESTINATIONNode.addChildElement('DESTINATION.COMPLEMENT', null, null); 
                COMPLEMENT.addTextNode(contactDuParcours.Complement_adresse__c );
            }
            Dom.XmlNode CODE_POSTAL = DESTINATIONNode.addChildElement('DESTINATION.CODE_POSTAL', null, null); 
            CODE_POSTAL.addTextNode(contactDuParcours.MailingPostalCode );
            Dom.XmlNode VILLE = DESTINATIONNode.addChildElement('DESTINATION.VILLE', null, null);
            VILLE.addTextNode(contactDuParcours.Mailingcity);
			Dom.XmlNode PAYS = DESTINATIONNode.addChildElement('DESTINATION.PAYS', null, null);
            if(String.isBlank(contactDuParcours.Mailingcountry)){
                PAYS.addTextNode('France');
            }
            else{
                PAYS.addTextNode(contactDuParcours.Mailingcountry);
            }
            
            Dom.XmlNode EMAIL = DESTINATIONNode.addChildElement('DESTINATION.EMAIL', null, null);
            EMAIL.addTextNode(parcours.VI_Email_CPV__c);
            
            
            Dom.XmlNode PCNode = correspondanceNode.addChildElement('PC', null, null); 
            Dom.XmlNode TYP_MARCHE = PCNode.addChildElement('PC.TYP_MARCHE', null, null); 
            TYP_MARCHE.addTextNode('OM');
            
            Dom.XmlNode MANDAT_1Node = correspondanceNode.addChildElement('MANDAT_1', null, null); 
            Dom.XmlNode RUMNode = MANDAT_1Node.addChildElement('MANDAT_1.RUM', null, null); 
            RUMNode.addTextNode(parcours.VI_ID_Mandat__c);            
            Dom.XmlNode IBAN = MANDAT_1Node.addChildElement('MANDAT_1.IBAN', null, null); 
            IBAN.addTextNode(IBANValue); 
            Dom.XmlNode TEMPLATE_MAIL = MANDAT_1Node.addChildElement('MANDAT_1.TEMPLATE_MAIL', null, null);
            TEMPLATE_MAIL.addTextNode('SEPAMandatPrelevementsigne');    
            
            Boolean retourPDF=input.retourPDF;
            Dom.XmlNode retourPDFNode = composerMandatInputNode.addChildElement('retourPDF', null, null);  
            if(retourPDF==false){
                retourPDFNode.addTextNode('false');
            }
            else{
                retourPDFNode.addTextNode('true');
            }
        }
        
        Dom.XmlNode contextNode = outerNode.addChildElement('context', null, null);
        system.debug('context '+context);
        if(context != null){
            Dom.XmlNode versionNode = contextNode.addChildElement('version', null, null);
            if(context.version != null){
                versionNode.addTextNode(context.version);
            }
            
            VI_gdfsuezComBefChpPivot.systemPath_element systemPathObj = context.systemPath;
            Dom.XmlNode systemPathNode = contextNode.addChildElement('systemPath',null, null);
            if(systemPathObj != null){
                VI_gdfsuezComBefChpPivot.system_element[] system_xObj = systemPathObj.system_x;
                if(system_xObj != null){
                    for(VI_gdfsuezComBefChpPivot.system_element element: system_xObj){
                        Dom.XmlNode system_xNode = systemPathNode.addChildElement('system', null, null);
                        Dom.XmlNode systemIdNode = system_xNode.addChildElement('systemId', null, null);
                        if(element.systemId != null){
                            systemIdNode.addTextNode(element.systemId);
                        }
                    }
                }	
            }
            Dom.XmlNode allowCacheNode = contextNode.addChildElement('allowCache', null,null);
            allowCacheNode.addTextNode('true');
        }
    }
    
    public static void fillIDFonclNode(Dom.XmlNode TracabiliteFluxNode,String name,String libelle,String valeur){
        Dom.XmlNode idFoncNode = TracabiliteFluxNode.addChildElement(name, '', ''); 
        Dom.XmlNode valeurNode = idFoncNode.addChildElement(valeur, '', ''); 
        valeurNode.addTextNode(valeur);
        Dom.XmlNode libelleNode = idFoncNode.addChildElement(libelle, '', ''); 
        libelleNode.addTextNode(libelle);
    }
    
    private static VI_gdfsuezBefCalypsoMandatV1.composerMandatResponse_element parseResponseElement(Dom.XmlNode responseNode){
        VI_gdfsuezBefCalypsoMandatV1.composerMandatResponse_element response_element =new VI_gdfsuezBefCalypsoMandatV1.composerMandatResponse_element();
        system.debug('responseNode '+responseNode);
        Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
        System.debug('composerMandatResponse'+ responseNode);
        
        DOM.XmlNode composerMandatOutputNode=responseNode.getChildElement('composerMandatOutput', null);
        if(composerMandatOutputNode == null){
            system.debug('composerMandatOutputNode'+ composerMandatOutputNode);
            response_element.composerMandatOutput = null;
        }
        else{
            system.debug('composerMandatOutputNode'+ composerMandatOutputNode);
            VI_gdfsuezBefCalypsoMandatV1.composerMandatOutputDt composerMandatOutputObj =new VI_gdfsuezBefCalypsoMandatV1.composerMandatOutputDt();
            DOM.XmlNode mandatComposeNode = composerMandatOutputNode.getChildElement('mandatCompose', null);
            system.debug('mandatComposeNode '+mandatComposeNode);
            if(mandatComposeNode==null){
                composerMandatOutputObj.mandatCompose=null;
            }
            else{
                system.debug('mandatComposeNode'+ mandatComposeNode);
                VI_gdfsuezBefCalypsoMandatV1.mandatCompose_element mandatCompose_elementObj =new VI_gdfsuezBefCalypsoMandatV1.mandatCompose_element();
                DOM.XmlNode idDocumentNode = mandatComposeNode.getChildElement('idDocument', null);
                mandatCompose_elementObj.idDocument=idDocumentNode.getText();
                DOM.XmlNode revisionDocumentNode = mandatComposeNode.getChildElement('revisionDocument', null);
                mandatCompose_elementObj.revisionDocument=revisionDocumentNode.getText();
                DOM.XmlNode contenuDocumentNode = mandatComposeNode.getChildElement('contenuDocument', null);
                mandatCompose_elementObj.contenuDocument=contenuDocumentNode.getText();
                DOM.XmlNode nomDocumentNode = mandatComposeNode.getChildElement('nomDocument', null);
                mandatCompose_elementObj.nomDocument=nomDocumentNode.getText();
                composerMandatOutputObj.mandatCompose=mandatCompose_elementObj;
                system.debug('mandatCompose_elementObj.idDocument '+mandatCompose_elementObj.idDocument);
            }
            response_element.composerMandatOutput=composerMandatOutputObj;
        }
        system.debug('response_element.composerMandatOutput '+response_element.composerMandatOutput);
        DOM.XmlNode messageRetoursNode = responseNode.getChildElement('messageRetours', null);
        system.debug('messageRetoursNode'+ messageRetoursNode);
        if(messageRetoursNode == null){
            response_element.messageRetours = null;
        } else{
            VI_gdfsuezComBefChpPivot.retourTraitementMessagesDt messageRetoursObj = new VI_gdfsuezComBefChpPivot.retourTraitementMessagesDt(messageRetoursNode);
            nodesParsed.add(messageRetoursNode);
            Dom.XmlNode[] retourTraitementMessageChildren = messageRetoursNode.getChildElements();
            VI_gdfsuezComBefChpPivot.retourTraitementMessageDt[] retourTraitementMessageList = new List<VI_gdfsuezComBefChpPivot.retourTraitementMessageDt>();
            if(retourTraitementMessageChildren == null || retourTraitementMessageChildren.size() == 0){
                messageRetoursObj.retourTraitementMessage = null;
            } else{
                for(DOM.XmlNode childNode : retourTraitementMessageChildren){
                    if(childNode.GetName() == 'retourTraitementMessage'){
                        VI_gdfsuezComBefChpPivot.retourTraitementMessageDt Obj = new VI_gdfsuezComBefChpPivot.retourTraitementMessageDt();
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
            
            response_element.messageRetours = messageRetoursObj;
        }
        return response_element;
    }
    
     public class retourMandat{
        public String idDocument;
        public String contenuDocument;
        public String message;
        
         public retourMandat( String idDocument, String contenuDocument, String message){
             this.idDocument = idDocument;
             this.contenuDocument = contenuDocument;
             this.message = message;
         }
    }
    
}