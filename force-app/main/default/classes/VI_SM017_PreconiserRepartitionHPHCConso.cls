/*
*@Author: Eloi Dereeper
*@Description: Estimation de la répartition HP/HC en faisant appel au WS Consommation.
*@CreatedDate: 12/11/2020
*@LastModified: 16/11/2020
*/
public class VI_SM017_PreconiserRepartitionHPHCConso {
     
    public static EstimationHPHC getRepartitionHPHC(String energieChauffageCode, String energieECSCode, String typeChauffageCode, String typeECSCode, String ctxt, String version, String NamedCredentialName){
        
        gdfsuezComBefChpPivot.contextDt context = VI_UTIL005_OctopusCalloutUtils.initContext(ctxt, version, false);
        gdfsuezComBefChpCalypsoConsommation.ConsommationPort port = VI_UTIL005_OctopusCalloutUtils.initConsommationPort(NamedCredentialName);
        system.debug(port);
        // Input de la méthode :
        gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionHPHCConsommationInputDt input  = new gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionHPHCConsommationInputDt();
        //sauvegardeDt contenu dans l'input
        gdfsuezComBefChpCalypsoConsommation.sauvegardeDt sauvegardeZoneAgile = new gdfsuezComBefChpCalypsoConsommation.sauvegardeDt();
        sauvegardeZoneAgile.entree = false;
        sauvegardeZoneAgile.sortie = false;        
        input.sauvegardeZoneAgile = sauvegardeZoneAgile;
        
        // localDt contenu dans l'input
        gdfsuezComBefChpCalypsoConsommation.localDt local = new gdfsuezComBefChpCalypsoConsommation.localDt();
        //local.idLocal = '1212121212';
        // Avec les paramètres d'entrée disponibles, un seul élément définisable dans "local : "listeEquipements".
        gdfsuezComBefChpCalypsoConsommation.TypeListeEquipements listeEquipements = new gdfsuezComBefChpCalypsoConsommation.TypeListeEquipements();
        
        // Elements définissables dans listeEquipements : 
        gdfsuezComBefChpCalypsoConsommation.chauffageDt chauffage = new gdfsuezComBefChpCalypsoConsommation.chauffageDt();
        gdfsuezComBefChpCalypsoConsommation.eauChaudeSanitaireDt eauChaudeSanitaire = new gdfsuezComBefChpCalypsoConsommation.eauChaudeSanitaireDt();
        
        // Elements définissables dans chauffage : 
        gdfsuezComBefChpPivot.listeValeursDt energieChauffage = VI_UTIL005_OctopusCalloutUtils.initValue(energieChauffageCode);
        gdfsuezComBefChpPivot.listeValeursDt typeChauffage = VI_UTIL005_OctopusCalloutUtils.initValue(typeChauffageCode);
        
        // Elements définissables dans eauChaudeSanitaire : 
        gdfsuezComBefChpPivot.listeValeursDt energieECS = VI_UTIL005_OctopusCalloutUtils.initValue(energieECSCode);
        gdfsuezComBefChpPivot.listeValeursDt typeECS = VI_UTIL005_OctopusCalloutUtils.initValue(typeECSCode);
        
        chauffage.energieChauffage = energieChauffage;
        chauffage.typeChauffage = typeChauffage;
        eauChaudeSanitaire.energieECS = energieECS;
        eauChaudeSanitaire.typeECS = typeECS;
        listeEquipements.chauffage = chauffage;
        listeEquipements.eauChaudeSanitaire = eauChaudeSanitaire;
        local.listeEquipements = listeEquipements;
        input.local = local;
        
        gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionHPHCConsommationReponse_element reponse = 
            new gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionHPHCConsommationReponse_element();
            
        if(!Test.isRunningTest()){ 
            try{
                 reponse = PreconiserRepartitionHPHCConsommation_HTTP(input,context, port);
            }
            catch(Exception e){
                System.debug('EDE Debug, erreur : ' + e.getMessage());
                System.debug('EDE Debug, erreur : ' + e.getStackTraceString());
                return null;
            }
        }
        else{
            Test.setMock(HttpCalloutMock.class, new VI_SM017_PrecoRepartitionHPHCConso_Mock());
             gdfsuezComBefChpCalypsoConsommation.ConsommationPort porttest = new  gdfsuezComBefChpCalypsoConsommation.ConsommationPort();
            reponse = PreconiserRepartitionHPHCConsommation_HTTP(input, context, porttest);
        }
        
        System.debug('EDE Debug : reponse = ' + ((reponse == null) ? 'null' : String.valueOf(reponse)));
        System.debug('EDE Debug : PreconiserRepartitionHPHCConsommationOuput = ' + (
                     (reponse.PreconiserRepartitionHPHCConsommationOuput == null) ? 'null' : String.valueOf(reponse.PreconiserRepartitionHPHCConsommationOuput)));
        System.debug('EDE Debug : estimationConso = ' + (
                     (reponse.PreconiserRepartitionHPHCConsommationOuput.estimationConso == null) ? 'null' : String.valueOf(reponse.PreconiserRepartitionHPHCConsommationOuput.estimationConso)));
        
        if(reponse != null && reponse.PreconiserRepartitionHPHCConsommationOuput != null && reponse.PreconiserRepartitionHPHCConsommationOuput.estimationConso != null){
            gdfsuezComBefChpCalypsoConsommation.repartitionHPHCDt estimationConso = reponse.PreconiserRepartitionHPHCConsommationOuput.estimationConso;
            EstimationHPHC estimation = new EstimationHPHC(estimationConso.cleRepartitionHC, estimationConso.cleRepartitionHP);
            return estimation;
        }
        if(reponse != null && reponse.messageRetours != null && reponse.messageRetours.retourTraitementMessage != null ){ 
            for (gdfsuezComBefChpPivot.retourTraitementMessageDt message : reponse.messageRetours.retourTraitementMessage){
                if ('Erreur'.equals(message.type_x)){
                    return null;
                }
            }    
        }
            
        
        return null;
    }
    
    
    public static gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionHPHCConsommationReponse_element PreconiserRepartitionHPHCConsommation_HTTP(
            gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionHPHCConsommationInputDt PreconiserRepartitionHPHCConsommationInput, gdfsuezComBefChpPivot.contextDt context, 
        gdfsuezComBefChpCalypsoConsommation.ConsommationPort port) { 
                
                DOM.Document doc = new DOM.Document();
                DOM.XmlNode body = VI_UTIL005_OctopusCalloutUtils.populateDocConso(doc);
                DOM.XmlNode methodNode = body.addChildElement('PreconiserRepartitionHPHCConsommation', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3', '');
                
                gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionHPHCConsommation_element request_x = 
                    new gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionHPHCConsommation_element();
                request_x.PreconiserRepartitionHPHCConsommationInput = PreconiserRepartitionHPHCConsommationInput;
                request_x.context = context;
                request_x.populateXmlNode(methodNode);
                
                
                HttpRequest req = new HttpRequest();
                req.setEndpoint(port.endpoint_x);
                req.setMethod('POST');
                req.setHeader('Content-Type', 'text/xml');
                req.setHeader('SOAPAction', 'tns:PreconiserRepartitionHPHCConsommation');
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
                Dom.XmlNode PreconiserRepartitionHPHCConsommationReponseNode = bodyNode.getChildElement('PreconiserRepartitionHPHCConsommationReponse', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3');
                
                gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionHPHCConsommationReponse_element reponse_x = 
                    new gdfsuezComBefChpCalypsoConsommation.PreconiserRepartitionHPHCConsommationReponse_element(PreconiserRepartitionHPHCConsommationReponseNode);
                return reponse_x;
            }
    
    public class EstimationHPHC{
        @AuraEnabled
        public Double cleRepartitionHC;
        @AuraEnabled
        public Double cleRepartitionHP;
        public EstimationHPHC(Double cleRepartitionHC, Double cleRepartitionHP){
            this.cleRepartitionHC = cleRepartitionHC;
            this.cleRepartitionHP = cleRepartitionHP;
        }
    }
}