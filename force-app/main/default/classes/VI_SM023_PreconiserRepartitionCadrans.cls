/*
*@Author: Eloi Dereeper
*@Description: Estimation de la répartition 4 cadrans en faisant appel au WS Consommation.
*@CreatedDate: 25/11/2020
*@LastModified: 20/05/2021
*/
public without sharing class VI_SM023_PreconiserRepartitionCadrans {
    
    public static Map<String, Object> preconiserRepartitionCadrans(String idLocal, String codeFTA, String ctxt, String version, String NamedCredentialName){
        
        Map<String, Object> outMap = new Map<String, Object> ();

        gdfsuezComBefChpPivot.contextDt context = VI_UTIL005_OctopusCalloutUtils.initContext(ctxt, version, false);
        gdfsuezComBefChpCalypsoConsommation.ConsommationPort port = VI_UTIL005_OctopusCalloutUtils.initConsommationPort(NamedCredentialName);
        
        
        //Element nécessaire à l'input de la méthode :
        gdfsuezComBefChpPivot.listeValeursDt FTA = new gdfsuezComBefChpPivot.listeValeursDt();
        FTA.code = codeFTA;
        
        //Input de la méthode d'appel HTTP:
        gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionCadransDistributeurInputDt input = new gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionCadransDistributeurInputDt();
        input.formuleTarifaireAcheminement = FTA;
        input.idLocal = idLocal;
        
        gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionCadransDistributeurReponse_element reponse =
            new gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionCadransDistributeurReponse_element();
        
        if(!Test.isRunningTest()){ 
            try{
                 reponse = PreconiserRepartitionCadransDistributeur_HTTP(input,context, port);
            }
            catch(Exception e){
                outMap.put('errorLibelle', e);
                System.debug('EDE Debug, erreur : ' + e.getMessage());
                System.debug('EDE Debug, erreur : ' + e.getStackTraceString());
                return null;
            }
        }
        else{
            Test.setMock(HttpCalloutMock.class, new VI_SM023_PrecoRepartitionCadrans_Mock());
            gdfsuezComBefChpCalypsoConsommation.ConsommationPort porttest = new  gdfsuezComBefChpCalypsoConsommation.ConsommationPort();
            reponse = PreconiserRepartitionCadransDistributeur_HTTP(input, context, porttest);
        }
        
        if(reponse != null && 
           reponse.PreconiserRepartitionCadransDistributeurOuput != null &&
           reponse.PreconiserRepartitionCadransDistributeurOuput.estimationCadransDistributeur != null &&
           reponse.PreconiserRepartitionCadransDistributeurOuput.estimationCadransDistributeur.estimationConsoDistributeurParCadran != null){
               
               for(gdfsuezComBefChpCalypsoConsommation.repartitionCadransDistributeurDt repartition : 
                   reponse.PreconiserRepartitionCadransDistributeurOuput.estimationCadransDistributeur.estimationConsoDistributeurParCadran){
                       outMap.put(repartition.cadran.code, repartition.cleRepartition);
                   }
           }
        else if(reponse != null && reponse.messageRetours != null && reponse.messageRetours.retourTraitementMessage != null ){ 
            for (gdfsuezComBefChpPivot.retourTraitementMessageDt message : reponse.messageRetours.retourTraitementMessage){
                if ('Erreur'.equals(message.type_x)){
                    outMap.put(message.type_x, message.libelle);
                }
            }    
        }
            
        System.debug('EDE debug, outMap : ' + outMap);
        return outMap;
        
    }
    
    public static gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionCadransDistributeurReponse_element PreconiserRepartitionCadransDistributeur_HTTP(
            gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionCadransDistributeurInputDt PreconiserRepartitionCadransDistributeurInput,gdfsuezComBefChpPivot.contextDt context,
    		gdfsuezComBefChpCalypsoConsommation.ConsommationPort port) {
                
                DOM.Document doc = new DOM.Document();
                DOM.XmlNode body = VI_UTIL005_OctopusCalloutUtils.populateDocConso(doc);
                DOM.XmlNode methodNode = body.addChildElement('PreconiserRepartitionCadransDistributeur', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3', '');
                
                gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionCadransDistributeur_element request_x = 
                    new gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionCadransDistributeur_element();
                request_x.PreconiserRepartitionCadransDistributeurInput = PreconiserRepartitionCadransDistributeurInput;
                request_x.context = context;
                request_x.populateXmlNode(methodNode);
                
                
                HttpRequest req = new HttpRequest();
                req.setEndpoint(port.endpoint_x);
                //req.setClientCertificateName(Label.SM_CL_OctopusCertificate);
                req.setMethod('POST');
                req.setHeader('Content-Type', 'text/xml');
                req.setHeader('SOAPAction', 'tns:PreconiserRepartitionCadransDistributeur');
                if(port.timeout_x != null){
                    req.setTimeout(port.timeout_x);
                }
                req.setBodyDocument(doc);
                
                System.debug('EDE debug, req XML body : ' + doc.toXmlString());
                
                Http http = new Http();
                HTTPResponse res = http.send(req);
                System.debug('response status Code : '+res.getStatusCode());
                System.debug('response : '+res.getBody());
                Dom.Document responseDoc = res.getBodyDocument();
                Dom.XmlNode rootNode = responseDoc.getRootElement();
                Dom.XmlNode bodyNode = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
                Dom.XmlNode PreconiserRepartitionCadransDistributeurReponseNode = bodyNode.getChildElement('PreconiserRepartitionCadransDistributeurReponse', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3');
                
                gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionCadransDistributeurReponse_element reponse_x = 
                    new gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionCadransDistributeurReponse_element(PreconiserRepartitionCadransDistributeurReponseNode);
                return reponse_x;
                
            }

}