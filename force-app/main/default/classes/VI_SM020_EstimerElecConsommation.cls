/*
*@Author: Eloi Dereeper
*@Description: Estimation de la consommation d'électricité en faisant appel au WS Consommation.
*@CreatedDate: 17/11/2020
*@LastModified: 18/11/2020
*/
public class VI_SM020_EstimerElecConsommation {
    
    public static Decimal estimerElec(String anneeConstructionInput, String codeRegion, String energieChauffageCode, String energieECSCode, Integer nbrPersonnesFoyer, Integer surface, 
                                                  String typeChauffageCode, String typeECSCode, String typeLogementCode, String typeResidenceCode, String energieCuissonCode,Boolean laveLingExists,
                                      				Boolean congelateurExists, Boolean laveVaisselleExists,Boolean secheLingeExists,String ctxt, String version,
                                                 String NamedCredentialName){
                
        gdfsuezComBefChpPivot.contextDt context = VI_UTIL005_OctopusCalloutUtils.initContext(ctxt, version, true);
        gdfsuezComBefChpCalypsoConsommation.ConsommationPort port = VI_UTIL005_OctopusCalloutUtils.initConsommationPort(NamedCredentialName);
        system.debug(port);
        // Input de la méthode :
        gdfsuezComBefChpCalypsoConsommation.EstimerElecConsommationInputDt input  = new gdfsuezComBefChpCalypsoConsommation.EstimerElecConsommationInputDt();
        //sauvegardeDt contenu dans l'input
        gdfsuezComBefChpCalypsoConsommation.sauvegardeDt sauvegardeZoneAgile = new gdfsuezComBefChpCalypsoConsommation.sauvegardeDt();
        sauvegardeZoneAgile.entree = false;
        sauvegardeZoneAgile.sortie = false;
        input.sauvegardeZoneAgile = sauvegardeZoneAgile;
        
        // localDt contenu dans l'input
        gdfsuezComBefChpCalypsoConsommation.localDt local = new gdfsuezComBefChpCalypsoConsommation.localDt();
        
        // Elements définissables dans local :
        gdfsuezComBefChpCalypsoConsommation.OccupationDt occupation = new gdfsuezComBefChpCalypsoConsommation.OccupationDt();
        gdfsuezComBefChpCalypsoConsommation.TypeListeEquipements listeEquipements = new gdfsuezComBefChpCalypsoConsommation.TypeListeEquipements();
        gdfsuezComBefChpPivot.listeValeursDt anneeConstruction = VI_UTIL005_OctopusCalloutUtils.initValue(anneeConstructionInput);
        gdfsuezComBefChpPivot.listeValeursDt codePostal = VI_UTIL005_OctopusCalloutUtils.initValue(codeRegion);
        gdfsuezComBefChpPivot.listeValeursDt typeLogement = VI_UTIL005_OctopusCalloutUtils.initValue(typeLogementCode);
        
        // Element définssable dans occupation :
        occupation.nombrePersonnesFoyer = nbrPersonnesFoyer;
        gdfsuezComBefChpPivot.listeValeursDt typeResidence = VI_UTIL005_OctopusCalloutUtils.initValue(typeResidenceCode);
        
        // Elements définissables dans listeEquipements : 
        gdfsuezComBefChpCalypsoConsommation.chauffageDt chauffage = new gdfsuezComBefChpCalypsoConsommation.chauffageDt();
        gdfsuezComBefChpCalypsoConsommation.eauChaudeSanitaireDt eauChaudeSanitaire = new gdfsuezComBefChpCalypsoConsommation.eauChaudeSanitaireDt();
        gdfsuezComBefChpCalypsoConsommation.cuissonDt cuisson = new gdfsuezComBefChpCalypsoConsommation.cuissonDt();
        
        // Elements définissables dans chauffage : 
        gdfsuezComBefChpPivot.listeValeursDt energieChauffage = VI_UTIL005_OctopusCalloutUtils.initValue(energieChauffageCode);
        gdfsuezComBefChpPivot.listeValeursDt typeChauffage = VI_UTIL005_OctopusCalloutUtils.initValue(typeChauffageCode);
        
        // Elements définissables dans eauChaudeSanitaire : 
        gdfsuezComBefChpPivot.listeValeursDt energieECS = VI_UTIL005_OctopusCalloutUtils.initValue(energieECSCode);
        gdfsuezComBefChpPivot.listeValeursDt typeECS = VI_UTIL005_OctopusCalloutUtils.initValue(typeECSCode);
        
        // Elements définissables dans cuisson : 
        gdfsuezComBefChpPivot.listeValeursDt energieCuisson = VI_UTIL005_OctopusCalloutUtils.initValue(energieCuissonCode);
        // Elements                                              
        gdfsuezComBefChpCalypsoConsommation.equipementDt laveLinge =  new gdfsuezComBefChpCalypsoConsommation.equipementDt();
        laveLinge.present = laveLingExists;
            
        gdfsuezComBefChpCalypsoConsommation.equipementDt laveVaisselle =  new gdfsuezComBefChpCalypsoConsommation.equipementDt();
        laveVaisselle.present = laveVaisselleExists;    
         
        gdfsuezComBefChpCalypsoConsommation.equipementDt secheLinge =  new gdfsuezComBefChpCalypsoConsommation.equipementDt();
        secheLinge.present = secheLingeExists; 
        
        gdfsuezComBefChpCalypsoConsommation.equipementDt congelateur =  new gdfsuezComBefChpCalypsoConsommation.equipementDt();
        congelateur.present = congelateurExists;                                             
                                                     
        cuisson.energieCuisson = energieCuisson;
        chauffage.energieChauffage = energieChauffage;
        chauffage.typeChauffage = typeChauffage;
        eauChaudeSanitaire.energieECS = energieECS;
        eauChaudeSanitaire.typeECS = typeECS;
        listeEquipements.cuisson = cuisson;
        listeEquipements.chauffage = chauffage;
        listeEquipements.laveLinge = laveLinge;
        listeEquipements.laveVaisselle = laveVaisselle; 
        listeEquipements.secheLinge = secheLinge;
        listeEquipements.congelateur = congelateur;                                      
        listeEquipements.eauChaudeSanitaire = eauChaudeSanitaire;
        occupation.typeResidence = typeResidence;
        local.occupation = occupation;
        local.listeEquipements = listeEquipements;
        local.surface = surface;
        local.anneeConstruction = anneeConstruction;
        local.codePostal = codePostal;
        local.typeLogement = typeLogement;
        input.local = local;
        
        gdfsuezComBefChpCalypsoConsommation.EstimerElecConsommationReponse_element reponse = 
            new gdfsuezComBefChpCalypsoConsommation.EstimerElecConsommationReponse_element();
        
        if(!Test.isRunningTest()){ 
            try{
            reponse = EstimerElecConsommation_HTTP(input,context, port);
            }
            catch(Exception e){
                return null;
            }
        }
        else{
            Test.setMock(HttpCalloutMock.class, new VI_SM020_EstimerElecConsommation_Mock());
             gdfsuezComBefChpCalypsoConsommation.ConsommationPort porttest = new  gdfsuezComBefChpCalypsoConsommation.ConsommationPort();
            reponse = EstimerElecConsommation_HTTP(input, context, porttest);
        }
        
        
        if(reponse != null && reponse.EstimerElecConsommationOutput != null && reponse.EstimerElecConsommationOutput.estimationConso != null
          && reponse.EstimerElecConsommationOutput.estimationConso.consommationEstimee != null){
            Integer consommationEstimee = reponse.EstimerElecConsommationOutput.estimationConso.consommationEstimee;
            return consommationEstimee;
            
        }
        else if(reponse != null && reponse.messageRetours != null && reponse.messageRetours.retourTraitementMessage != null ){ 
            for (gdfsuezComBefChpPivot.retourTraitementMessageDt message : reponse.messageRetours.retourTraitementMessage){
                if ('Erreur'.equals(message.type_x)){
                    System.debug(message.libelle);
                    return null;
                }
            }    
        }                                    
        return null;
    }
    
    public static gdfsuezComBefChpCalypsoConsommation.EstimerElecConsommationReponse_element EstimerElecConsommation_HTTP(
            gdfsuezComBefChpCalypsoConsommation.EstimerElecConsommationInputDt EstimerElecConsommationInput,gdfsuezComBefChpPivot.contextDt context,
    		gdfsuezComBefChpCalypsoConsommation.ConsommationPort port) {
                
                DOM.Document doc = new DOM.Document();
                DOM.XmlNode body = VI_UTIL005_OctopusCalloutUtils.populateDocConso(doc);
                DOM.XmlNode methodNode = body.addChildElement('EstimerElecConsommation', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3', '');
                
                gdfsuezComBefChpCalypsoConsommation.EstimerElecConsommation_element request_x = 
                    new gdfsuezComBefChpCalypsoConsommation.EstimerElecConsommation_element();
                request_x.EstimerElecConsommationInput = EstimerElecConsommationInput;
                request_x.context = context;
                request_x.populateXmlNode(methodNode);
                
                HttpRequest req = new HttpRequest();
                req.setEndpoint(port.endpoint_x);
                //req.setClientCertificateName(Label.SM_CL_OctopusCertificate);
                req.setMethod('POST');
                req.setHeader('Content-Type', 'text/xml');
                req.setHeader('SOAPAction', 'tns:EstimerElecConsommation');
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
                Dom.XmlNode EstimerElecConsommationReponseNode = bodyNode.getChildElement('EstimerElecConsommationReponse', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3');
                
                gdfsuezComBefChpCalypsoConsommation.EstimerElecConsommationReponse_element reponse_x = 
                    new gdfsuezComBefChpCalypsoConsommation.EstimerElecConsommationReponse_element(EstimerElecConsommationReponseNode);
                
                return reponse_x;
            }
    
}