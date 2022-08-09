/*
*@Author: Eloi Dereeper
*@Description: Estimation de la répartition 3 cadrans en faisant appel au WS Consommation.
*@CreatedDate: 17/11/2020
*@LastModified: 18/11/2020
*/
public class VI_SM018_Preconiser3cadransConso { 

    public static Estimation3Cadrans preconiser3cadrans(String energieChauffageCode, String energieECSCode, String typeChauffageCode, String typeECSCode, String ctxt, String version, String NamedcredentialName){
        

        gdfsuezComBefChpPivot.contextDt context = VI_UTIL005_OctopusCalloutUtils.initContext(ctxt, version, false);
        gdfsuezComBefChpCalypsoConsommation.ConsommationPort port = VI_UTIL005_OctopusCalloutUtils.initConsommationPort(NamedcredentialName);
        
        // Input de la méthode d'appel HTTP:
        gdfsuezComBefChpCalypsoConsommation.PreconiserRepartition3cadransConsommationInputDt input  = new gdfsuezComBefChpCalypsoConsommation.PreconiserRepartition3cadransConsommationInputDt();
        //sauvegardeDt contenu dans l'input
        gdfsuezComBefChpCalypsoConsommation.sauvegardeDt sauvegardeZoneAgile = new gdfsuezComBefChpCalypsoConsommation.sauvegardeDt();
        sauvegardeZoneAgile.entree = false;
        sauvegardeZoneAgile.sortie = false;        
        input.sauvegardeZoneAgile = sauvegardeZoneAgile;
        
        // Liste offreInDt contenue dans l'input
        gdfsuezComBefChpCalypsoConsommation.offreInDt[] donneesOffre = new gdfsuezComBefChpCalypsoConsommation.offreInDt[]{};
        
        // offreInDt à ajouter à la liste.
        gdfsuezComBefChpCalypsoConsommation.offreInDt donneeOffre = new gdfsuezComBefChpCalypsoConsommation.offreInDt();
        
        // localDt contenu dans l'input
        gdfsuezComBefChpCalypsoConsommation.localDt local = new gdfsuezComBefChpCalypsoConsommation.localDt();
        
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
        donneeOffre.local = local;
        donneesOffre.add(donneeOffre);
        input.donneesOffre = donneesOffre;
        
        gdfsuezComBefChpCalypsoConsommation.PreconiserRepartition3cadransConsommationReponse_element reponse = 
            new gdfsuezComBefChpCalypsoConsommation.PreconiserRepartition3cadransConsommationReponse_element();
            
        if(!Test.isRunningTest()){ 
            try{
                 reponse = PreconiserRepartition3cadransConsommation_HTTP(input,context, port);
            }
            catch(Exception e){
                return null;
            }
        }
        else{
            // TODO : définir les mocks pour la classe test
            Test.setMock(HttpCalloutMock.class, new VI_SM018_Preconiser3cadransConso_Mock());
             gdfsuezComBefChpCalypsoConsommation.ConsommationPort porttest = new  gdfsuezComBefChpCalypsoConsommation.ConsommationPort();
            reponse = PreconiserRepartition3cadransConsommation_HTTP(input, context, porttest);
        }
        
        if(reponse != null && reponse.PreconiserRepartition3cadransConsommationOutput != null && reponse.PreconiserRepartition3cadransConsommationOutput.donneesOffre != null){
            Double cleHC;
            Double cleHP;
            Double cleWE;
        	for(gdfsuezComBefChpCalypsoConsommation.offreOutDt donneeOffreOut :  reponse.PreconiserRepartition3cadransConsommationOutput.donneesOffre){
                for(gdfsuezComBefChpCalypsoConsommation.repartition3cadransDt repartition : donneeOffreOut.estimationConsoParCadran){
                    if(repartition.cadran.code == 'WE'){
                        cleWE = repartition.cleRepartition;
                    }
                    else if(repartition.cadran.code == 'HC'){
                        cleHC = repartition.cleRepartition;
                    }
                    else if(repartition.cadran.code == 'HP'){
                        cleHP = repartition.cleRepartition;
                    }
                }
            }
            Estimation3Cadrans estimation = new Estimation3Cadrans(cleHC, cleHP, cleWE);
            system.debug(estimation);
            return estimation;
        }
        else if(reponse != null && reponse.messageRetours != null && reponse.messageRetours.retourTraitementMessage != null ){ 
            for (gdfsuezComBefChpPivot.retourTraitementMessageDt message : reponse.messageRetours.retourTraitementMessage){
                if ('Erreur'.equals(message.type_x)){
                    return null;
                }
            }    
        }
                
        return null;
    }
    
    
    public static gdfsuezComBefChpCalypsoConsommation.PreconiserRepartition3cadransConsommationReponse_element PreconiserRepartition3cadransConsommation_HTTP(
            gdfsuezComBefChpCalypsoConsommation.PreconiserRepartition3cadransConsommationInputDt PreconiserRepartition3cadransConsommationInput,gdfsuezComBefChpPivot.contextDt context,
    	gdfsuezComBefChpCalypsoConsommation.ConsommationPort port) { 
                
                DOM.Document doc = new DOM.Document();
                DOM.XmlNode body = VI_UTIL005_OctopusCalloutUtils.populateDocConso(doc);
                DOM.XmlNode methodNode = body.addChildElement('PreconiserRepartition3cadransConsommation', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3', '');
                
                gdfsuezComBefChpCalypsoConsommation.PreconiserRepartition3cadransConsommation_element request_x = 
                    new gdfsuezComBefChpCalypsoConsommation.PreconiserRepartition3cadransConsommation_element();
                request_x.PreconiserRepartition3cadransConsommationInput = PreconiserRepartition3cadransConsommationInput;
                request_x.context = context;
                request_x.populateXmlNode(methodNode);
                
                HttpRequest req = new HttpRequest();
                req.setEndpoint(port.endpoint_x);
                //req.setClientCertificateName(Label.SM_CL_OctopusCertificate);
                req.setMethod('POST');
                req.setHeader('Content-Type', 'text/xml');
                req.setHeader('SOAPAction', 'tns:PreconiserRepartition3cadransConsommation');
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
                Dom.XmlNode PreconiserRepartition3cadransConsommationReponseNode = bodyNode.getChildElement('PreconiserRepartition3cadransConsommationReponse', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3');
                
                gdfsuezComBefChpCalypsoConsommation.PreconiserRepartition3cadransConsommationReponse_element reponse_x = 
                    new gdfsuezComBefChpCalypsoConsommation.PreconiserRepartition3cadransConsommationReponse_element(PreconiserRepartition3cadransConsommationReponseNode);
                
                return reponse_x;
        }
    
    public class Estimation3Cadrans{
        @AuraEnabled
        public Double cleHC;
        @AuraEnabled
        public Double cleHP;
        @AuraEnabled
        public Double cleWE;
        public Estimation3Cadrans(Double cleHC, Double cleHP, Double cleWE){
            this.cleHC = cleHC;
            this.cleHP = cleHP;
            this.cleWE = cleWE;
        }
    }
}