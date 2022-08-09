/*
*@Author: Eloi Dereeper
*@Description: Estimation de la consommation de gaz en faisant appel au WS Consommation.
*@CreatedDate: 17/11/2020
*@LastModified: 18/11/2020
*/
public class VI_SM019_EstimerGazConsommation {
    
    public static Decimal estimerGaz( String anneeConstructionInput, String codeRegion, String energieChauffageCode, String energieECSCode, Integer nbrPersonnesFoyer, Integer surface, 
                                                 String typeChauffageCode, String typeECSCode, String energieCuissonCode, String typeLogementCode,string typeResidenceCode, String ctxt, String version, String NamedCredentialName){  
            gdfsuezComBefChpPivot.contextDt context = VI_UTIL005_OctopusCalloutUtils.initContext(ctxt, version, true);
            gdfsuezComBefChpCalypsoConsommation.ConsommationPort port = VI_UTIL005_OctopusCalloutUtils.initConsommationPort(NamedCredentialName);
            // Input de la méthode :
            gdfsuezComBefChpCalypsoConsommation.EstimerGazConsommationInputDt input  = new gdfsuezComBefChpCalypsoConsommation.EstimerGazConsommationInputDt();
            //sauvegardeDt contenu dans l'input
            gdfsuezComBefChpCalypsoConsommation.sauvegardeDt sauvegarde = new gdfsuezComBefChpCalypsoConsommation.sauvegardeDt();
            sauvegarde.entree = false;
            sauvegarde.sortie = false;
            input.sauvegarde = sauvegarde;
            
            // localDt contenu dans l'input
            gdfsuezComBefChpCalypsoConsommation.localDt local = new gdfsuezComBefChpCalypsoConsommation.localDt();
            
            // Elements définissables dans local :
            gdfsuezComBefChpCalypsoConsommation.OccupationDt occupation = new gdfsuezComBefChpCalypsoConsommation.OccupationDt();
            gdfsuezComBefChpCalypsoConsommation.TypeListeEquipements listeEquipements = new gdfsuezComBefChpCalypsoConsommation.TypeListeEquipements();
            gdfsuezComBefChpPivot.listeValeursDt anneeConstruction = VI_UTIL005_OctopusCalloutUtils.initValue(anneeConstructionInput);
            gdfsuezComBefChpPivot.listeValeursDt codePostal = VI_UTIL005_OctopusCalloutUtils.initValue(codeRegion);
            gdfsuezComBefChpPivot.listeValeursDt typeLogement = VI_UTIL005_OctopusCalloutUtils.initValue(typeLogementCode);
			gdfsuezComBefChpPivot.listeValeursDt typeResidence = VI_UTIL005_OctopusCalloutUtils.initValue(typeResidenceCode);

            // Element définssable dans occupation :
            occupation.nombrePersonnesFoyer = nbrPersonnesFoyer;
            occupation.typeResidence = typeResidence;
            
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
            
            cuisson.energieCuisson = energieCuisson;
            chauffage.energieChauffage = energieChauffage;
            chauffage.typeChauffage = typeChauffage;
            eauChaudeSanitaire.energieECS = energieECS;
            eauChaudeSanitaire.typeECS = typeECS;
            listeEquipements.cuisson = cuisson;
            listeEquipements.chauffage = chauffage;
            listeEquipements.eauChaudeSanitaire = eauChaudeSanitaire;
            local.occupation = occupation;
            local.listeEquipements = listeEquipements;
            local.surface = surface;
            local.anneeConstruction = anneeConstruction;
            local.codePostal = codePostal;
            local.typeLogement = typeLogement;
            input.local = local;
            
            gdfsuezComBefChpCalypsoConsommation.EstimerGazConsommationReponse_element reponse = 
                new gdfsuezComBefChpCalypsoConsommation.EstimerGazConsommationReponse_element();
            
            if(!Test.isRunningTest()){ 
                    reponse = EstimerGazConsommation_HTTP(input,context, port);
            }
            else{
                // TODO : définir les mocks pour la classe test
                Test.setMock(HttpCalloutMock.class, new VI_SM019_EstimerGazConsommation_Mock());
                gdfsuezComBefChpCalypsoConsommation.ConsommationPort porttest = new  gdfsuezComBefChpCalypsoConsommation.ConsommationPort();
                reponse = EstimerGazConsommation_HTTP(input, context, porttest);
            }
            
            if(reponse != null && reponse.EstimerGazConsommationzOutput != null && reponse.EstimerGazConsommationzOutput.estimationConso != null){
                gdfsuezComBefChpCalypsoConsommation.estimationConsoDt estimationConso = reponse.EstimerGazConsommationzOutput.estimationConso;
                return estimationConso.consommationEstimee;
            }
            else if(reponse != null && reponse.messageRetours != null && reponse.messageRetours.retourTraitementMessage != null ){ 
                for (gdfsuezComBefChpPivot.retourTraitementMessageDt message : reponse.messageRetours.retourTraitementMessage){
                    if ('Erreur'.equals(message.type_x)){
                        break;
                    }
                }    
            }
        return null;
    }
    
    
    
    
    public static gdfsuezComBefChpCalypsoConsommation.EstimerGazConsommationReponse_element EstimerGazConsommation_HTTP(
            gdfsuezComBefChpCalypsoConsommation.EstimerGazConsommationInputDt EstimerGazConsommationInput,gdfsuezComBefChpPivot.contextDt context,
    		gdfsuezComBefChpCalypsoConsommation.ConsommationPort port){
                
                DOM.Document doc = new DOM.Document();
                DOM.XmlNode body = VI_UTIL005_OctopusCalloutUtils.populateDocConso(doc);
                DOM.XmlNode methodNode = body.addChildElement('EstimerGazConsommation', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3', '');
                
                gdfsuezComBefChpCalypsoConsommation.EstimerGazConsommation_element request_x = 
                    new gdfsuezComBefChpCalypsoConsommation.EstimerGazConsommation_element();
                request_x.EstimerGazConsommationInput = EstimerGazConsommationInput;
                request_x.context = context;
                request_x.populateXmlNode(methodNode);
                
                HttpRequest req = new HttpRequest();
                req.setEndpoint(port.endpoint_x);
                //req.setClientCertificateName(Label.SM_CL_OctopusCertificate);
                req.setMethod('POST');
                req.setHeader('Content-Type', 'text/xml');
                req.setHeader('SOAPAction', 'tns:EstimerGazConsommation');
                if(port.timeout_x != null){
                    req.setTimeout(port.timeout_x);
                }
                req.setBodyDocument(doc);
                
                System.debug('EDE debug, req XML body : ' + doc.toXmlString());
                
                Http http = new Http();
                HTTPResponse res = http.send(req);
                Dom.Document responseDoc = res.getBodyDocument();
                Dom.XmlNode rootNode = responseDoc.getRootElement();
                Dom.XmlNode bodyNode = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
                Dom.XmlNode EstimerGazConsommationReponseNode = bodyNode.getChildElement('EstimerGazConsommationReponse', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3');
                
                gdfsuezComBefChpCalypsoConsommation.EstimerGazConsommationReponse_element reponse_x = 
                    new gdfsuezComBefChpCalypsoConsommation.EstimerGazConsommationReponse_element(EstimerGazConsommationReponseNode);
                
                return reponse_x;
		}
    
}