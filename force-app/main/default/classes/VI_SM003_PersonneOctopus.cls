/*
*@Author: Paul Ghousoub
*@Description: Appel du WS Personne
*@CreatedDate: 27/10/2020
*@LastModified: 27/10/2020
*/
global class VI_SM003_PersonneOctopus { 
    public class MajPersonneException extends Exception{}
    
    /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Creation d'une personne dans Salesforce
* @param creerPersonneInput, context, port (wrappers Définit par WSDL), NamedCredentialName (callout:VI_AuthOctopus, callout:AuthOctopus), partitionName (local.VIToken,local.smileToken)
* @return creerPersonneResponse_element wrapper defined in the wsdl
*/
    public static gdfsuezBefCalypsoPersonneV8.creerPersonneResponse_element CreerPersonne(gdfsuezBefCalypsoPersonneV8.creerPersonneInputDt creerPersonneInput,gdfsuezComBefChpPivotV8.contextDt context, gdfsuezBefCalypsoPersonneV8.PersonnePort port, String partition, String NamedCredentialName) {
        DOM.Document doc = new DOM.Document();
        DOM.XmlNode body = VI_UTIL005_OctopusCalloutUtils.populateDoc(doc,NamedCredentialName, context.systemPath.system_x[0].systemId, '1.0', partition);
        DOM.XmlNode methodNode = body.addChildElement('v8:creerPersonne', null, null);          
        gdfsuezBefCalypsoPersonneV8.creerPersonne_element request_x = new gdfsuezBefCalypsoPersonneV8.creerPersonne_element(creerPersonneInput,context);
        VI_UTIL005_OctopusCalloutUtils.populateXmlNode(methodNode,creerPersonneInput, context);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(NamedCredentialName+'/E-Personne_v8');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        req.setHeader('SOAPAction', 'tns:CreerPersonne');
        req.setBodyDocument(doc);
        system.debug('request'+doc.toXmlString());
        Http http = new Http();
        HTTPResponse res;
        if(!Test.isRunningTest()){
            res = http.send(req);
        }
        else
        {
            Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPersonneV8HttpMock());
            res = http.send(req);
        }
        System.debug(res.getBody());
        Dom.Document responseDoc = res.getBodyDocument();
        system.debug('responseDoc'+responseDoc.toXmlString());
        Dom.XmlNode rootNode = responseDoc.getRootElement();
        Dom.XmlNode bodyNode = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
        Dom.XmlNode creerPersonneResponseNode = bodyNode.getChildElement('creerPersonneResponse', 'http://gdfsuez/bef/calypso/personne/v8');
        gdfsuezBefCalypsoPersonneV8.creerPersonneResponse_element response_x = new gdfsuezBefCalypsoPersonneV8.creerPersonneResponse_element(creerPersonneResponseNode);
        return response_x;
    }
    
    /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Mise à jour d'une personne dans Salesforce
* @param majPersonneInput, context, port (wrappers Définit par WSDL), NamedCredentialName (callout:VI_AuthOctopus, callout:AuthOctopus), partitionName (local.VIToken,local.smileToken)
* @return retourTraitementMessagesDt wrapper defined in the wsdl
*/
    public static gdfsuezComBefChpPivotV8.retourTraitementMessagesDt MajPersonne(gdfsuezBefCalypsoPersonneV8.majPersonneInputDt majPersonneInput,gdfsuezComBefChpPivotV8.contextDt context, gdfsuezBefCalypsoPersonneV8.PersonnePort port, String partition, String NamedCredentialName) {
        DOM.Document doc = new DOM.Document();
        DOM.XmlNode body = VI_UTIL005_OctopusCalloutUtils.populateDoc(doc,NamedCredentialName, context.systemPath.system_x[0].systemId, '1.0', partition);
        DOM.XmlNode methodNode = body.addChildElement('v8:majPersonne', null, null);            
        gdfsuezBefCalypsoPersonneV8.majPersonne_element request_x = new gdfsuezBefCalypsoPersonneV8.majPersonne_element(majPersonneInput,context);
        VI_UTIL005_OctopusCalloutUtils.populateXmlNode(methodNode,majPersonneInput, context);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(NamedCredentialName + '/E-Personne_v8');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        req.setHeader('SOAPAction', 'tns:MajPersonne');
        req.setBodyDocument(doc);
        Http http = new Http();
        HTTPResponse res;
        if(!Test.isRunningTest()){
            res = http.send(req);
        }
        else
        {
            Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPersonneV8HttpMock());
            res = http.send(req);
        }
        System.debug(res.getBody());
        Dom.Document responseDoc = res.getBodyDocument();
        Dom.XmlNode rootNode = responseDoc.getRootElement();
        Dom.XmlNode bodyNode = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
        Dom.XmlNode majPersonneResponseNode = bodyNode.getChildElement('majPersonneResponse', 'http://gdfsuez/bef/calypso/personne/v8');
        
        gdfsuezBefCalypsoPersonneV8.majPersonneResponse_element response_x = new gdfsuezBefCalypsoPersonneV8.majPersonneResponse_element(majPersonneResponseNode);
        return response_x.messageRetours;
    }
    
    /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Construire le wrapper d'une personne avec une adresse
* @param idPersonne, adresse, prenom, nom, civilite, canaux, ProfileMarketing( wrapper defined in the wsdl)
* @return Personne wrapper defined in the wsdl
*/
    
    public static gdfsuezComBefCalypsoPersonneV8.Personne PreparePersonne( String idPersonne, gdfsuezComBefCalypsoPersonneV8.adresseDt adresse, String prenom, String nom, String civilite,
                                                                          List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element> canaux,
                                                                          List<gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element> ProfileMarketing){
                                                                              gdfsuezComBefCalypsoPersonneV8.Personne personne = new gdfsuezComBefCalypsoPersonneV8.Personne();
                                                                              if(idPersonne!= null){
                                                                                  personne.idPersonne = idPersonne;
                                                                              }
                                                                              if(prenom != null){
                                                                                  personne.prenom = prenom;                                                                    
                                                                              }
                                                                              if(nom != null){
                                                                                  personne.nom = nom;                                                                    
                                                                              }
                                                                              if(civilite != null){
                                                                                  personne.civilite = prepareValue(Civilite);
                                                                              }
                                                                              if(ProfileMarketing!= null && ProfileMarketing.size()>0){
                                                                                  personne.profilMarketing = new gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element[]{};
                                                                                      personne.profilMarketing.addall(ProfileMarketing);
                                                                              }
                                                                              system.debug('canaux'+ canaux);
                                                                              if(canaux!= null && canaux.size()>0){
                                                                                  personne.correspondance = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_element();
                                                                                  personne.correspondance.canalCommunication = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element[canaux.size()];
                                                                                  for(Integer i = 0 ; i < canaux.size() ; i++){
                                                                                      system.debug('canaux[i]'+ canaux[i]);
                                                                                      personne.correspondance.canalCommunication[i] = canaux[i];
                                                                                  }
                                                                              }
                                                                              system.debug(adresse);
                                                                              if(adresse!= null){
                                                                                  personne.adresse = adresse; 
                                                                              }
                                                                              return personne;
                                                                          }
    /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Construire le wrapper d'une personne  sans adresse
* @param idPersonne, prenom, nom, civilite, canaux, ProfileMarketing( wrapper defined in the wsdl)
* @return Personne wrapper defined in the wsdl
*/
    public static gdfsuezComBefCalypsoPersonneV8.Personne PreparePersonne( String idPersonne,String prenom, String nom, String civilite,
                                                                          List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element> canaux,
                                                                          List<gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element> ProfileMarketing){
                                                                              return PreparePersonne( idPersonne, null, prenom,nom, civilite, canaux,ProfileMarketing);
                                                                          }
    /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Construire le wrapper Personne_correspondance_canalCommunication_element necesaire à la création d'une personne ( Email)
* @param email, utiliserdePreference, order
* @return Personne_correspondance_canalCommunication_element wrapper defined in the wsdl
*/
    public static gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element prepareCanalCommMail(String email, Boolean utiliserdePreference, Integer order){
        return prepareCanalComm(null, null,email, null, null, 'INT',null , utiliserdePreference,order);
    }
    /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Construire le wrapper Personne_correspondance_canalCommunication_element necesaire à la création d'une personne
* @param fag, code
* @return Personne_correspondance_canalCommunication_element wrapper defined in the wsdl
*/
    
    public static gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element prepareCanalCommSimple(String flag, String code){
        return  prepareCanalComm(null, null,null, null,flag,Code,null ,null, null);
    }
    /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Construire le wrapper Personne_correspondance_canalCommunication_element necesaire à la création d'une personne ( Phone)
* @param telephone, flag, code, utiliserdePreference, order
* @return Personne_correspondance_canalCommunication_element wrapper defined in the wsdl
*/
    public static gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element prepareCanalCommPhone(String telephone, String flag, String code, Boolean utiliserdePreference, Integer order){
        return prepareCanalComm(null, null,null, telephone,flag,Code,null ,utiliserdePreference, order);
    }
     /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Construire le wrapper Personne_correspondance_canalCommunication_element necesaire à la création d'une personne ( Adresse)
* @param nVoie,libelleVoie, codePostal, Ville, newComplement, newChez,  utiliserdePreference,  order
* @return Personne_correspondance_canalCommunication_element wrapper defined in the wsdl
*/   
    public static gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element prepareCanalCommAdresse(String nVoie, String libelleVoie, String CodePostal, String Ville, String newComplement, String newChez, Boolean utiliserdePreference, Integer order){
        return prepareCanalComm(prepareAdresse( nVoie, libelleVoie, CodePostal, Ville, newComplement, newChez), null,null,null, null, 'LET',null, utiliserdePreference,order);
    }
         /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Construire le wrapper Personne_correspondance_canalCommunication_element necesaire à la création d'une personne ( Adresse)
* @param nVoie,libelleVoie, codePostal, Ville, newComplement, newChez,  utiliserdePreference,  order
* @return Personne_correspondance_canalCommunication_element wrapper defined in the wsdl
*/  
    public static gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element prepareCanalComm(gdfsuezComBefCalypsoPersonneV8.adresseDt adresse, String horodatage,
                                                                                                                     String mail, String telephone, String flag, String Code,
                                                                                                                     Boolean prefere , Boolean utiliserdePreference,Integer order){
                                                                                                                         gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element canal = new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element();
                                                                                                                         if(horodatage!= null){
                                                                                                                             canal.horodatage = new gdfsuezComBefChpPivotV8.horodatageSimpleDt();
                                                                                                                             canal.horodatage.flag = prepareValue(horodatage);
                                                                                                                         }
                                                                                                                         if(code!= null){
                                                                                                                             canal.type_x = prepareValue(code);
                                                                                                                         }
                                                                                                                         if(adresse != null){
                                                                                                                             canal.adresse = adresse;
                                                                                                                         }
                                                                                                                         if(utiliserDePreference != null){
                                                                                                                             canal.utiliserDePreference = utiliserDePreference;
                                                                                                                         }
                                                                                                                         if(order != null){
                                                                                                                             canal.ordre = order;
                                                                                                                         }
                                                                                                                         if(prefere != null){
                                                                                                                             canal.prefere = prefere;
                                                                                                                         }
                                                                                                                         if(telephone != null){
                                                                                                                             canal.telephone = telephone;
                                                                                                                         }                                                                                                                 
                                                                                                                         if(mail != null){
                                                                                                                             canal.mail = mail;
                                                                                                                         }
                                                                                                                         return canal;
                                                                                                                     }
    
    
             /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Construire le wrapper adresseDt necesaire à la création d'une personne ( Adresse)
* @param nVoie,libelleVoie, codePostal, Ville, newComplement, newChez
* @return adresseDt wrapper defined in the wsdl
*/  
    public static gdfsuezComBefCalypsoPersonneV8.adresseDt prepareAdresse(String nVoie, String libelleVoie, String CodePostal, String Ville, 
                                                                          String newComplement, String newChez){
                                                                              return prepareAdresse(nVoie, libelleVoie,CodePostal, Ville,newComplement, newChez,null);
                                                                          }
                 /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Construire le wrapper adresseDt necesaire à la création d'une personne ( Adresse)
* @param nVoie,libelleVoie, codePostal, Ville, newComplement, newChez, pays
* @return adresseDt wrapper defined in the wsdl
*/  
    public static gdfsuezComBefCalypsoPersonneV8.adresseDt prepareAdresse(String nVoie, String libelleVoie, String CodePostal, String Ville, 
                                                                          String newComplement, String newChez, String Pays){
                                                                              gdfsuezComBefCalypsoPersonneV8.adresseDt adresse = new gdfsuezComBefCalypsoPersonneV8.adresseDt();
                                                                              if(nVoie != null){                                                                      
                                                                                  adresse.nVoie = nVoie;
                                                                              }                                                                      
                                                                              if(libelleVoie != null){                                                                      
                                                                                  adresse.libelleVoie = libelleVoie;
                                                                              }  
                                                                              if(CodePostal != null){                                                                      
                                                                                  adresse.CP = CodePostal;
                                                                              } 
                                                                              if(Ville != null){                                                                      
                                                                                  adresse.ville = Ville;
                                                                              } 
                                                                              if(newComplement != null){                                                                      
                                                                                  adresse.complementAdresse = VI_UTIL004_OctopusUtilities.formatStringToSAPFormat(newComplement);
                                                                              } 
                                                                              if(newChez != null){                                                                      
                                                                                  adresse.chez = VI_UTIL004_OctopusUtilities.formatStringToSAPFormat(newChez);
                                                                              }
                                                                              if(Pays != null){                                                                      
                                                                                  adresse.pays = prepareValue(Pays);
                                                                              } 
                                                                              return adresse;
                                                                          }
    
                 /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Construire le wrapper Personne_profilMarketing_element necesaire à la création d'une personne ( Adresse)
* @param nVoie,libelleVoie, codePostal, Ville, newComplement, newChez
* @return Personne_profilMarketing_element wrapper defined in the wsdl
*/  
    public static gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element prepareProfileMarketing(String designation, String valeurDesignation){
        gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element profilMarketing = new gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element();
        profilMarketing.designation = prepareValue(designation);
        profilMarketing.valeurDesignation = valeurDesignation;
        return profilMarketing;
    }
                  /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Construire le wrapper listeValeursDt en se basant sur le code
* @param nVoie,libelleVoie, codePostal, Ville, newComplement, newChez
* @return listeValeursDt wrapper defined in the wsdl
*/   
    public static gdfsuezComBefChpPivotV8.listeValeursDt prepareValue( String valeur){
        gdfsuezComBefChpPivotV8.listeValeursDt field = new gdfsuezComBefChpPivotV8.listeValeursDt();
        field.code = valeur;
        return field;
    }
    
                      /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Definir un contexte d'appel,à créer avec une méthode pour tout les appels octopus
* @param application(VI),version (v6)
* @return listeValeursDt wrapper defined in the wsdl
*/   
    public static gdfsuezComBefChpPivotV8.contextDt initContext(String application, String version){
        gdfsuezComBefChpPivotV8.contextDt_systemPath_system_element osource = new gdfsuezComBefChpPivotV8.contextDt_systemPath_system_element();
        osource.systemId=application;
        gdfsuezComBefChpPivotV8.contextDt octx = new gdfsuezComBefChpPivotV8.contextDt();
        octx.version=version;
        octx.systemPath = new gdfsuezComBefChpPivotV8.contextDt_systemPath_element();
        octx.systemPath.system_x = new gdfsuezComBefChpPivotV8.contextDt_systemPath_system_element[]{osource};
            return octx;
    } 
                      /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Definir un port d'appel,à créer avec une méthode pour tout les appels octopus
* @param 
* @return PersonnePort wrapper defined in the wsdl
*/   
    
    
    public static gdfsuezBefCalypsoPersonneV8.PersonnePort buildPortWSPersonne(){
        gdfsuezBefCalypsoPersonneV8.PersonnePort port = new gdfsuezBefCalypsoPersonneV8.PersonnePort() ;  
        port.endpoint_x = 'callout:VI_AuthOctopus'+'/E-Personne_v8';
        port.inputHttpHeaders_x = new Map<String, String>{'Content-Type' => 'text/xml;charset=utf-8'};
            return port;
    }
}