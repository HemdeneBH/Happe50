/*
*@Auhtor: Paul Ghoussoub
*@Description: Appel de l'API Document_v2
*@CreatedDate: 20/05/2021
*/
public without sharing class VI_SM033_ServiceDocument {
    public static VI_UTIL006_Cache_Management service = new VI_UTIL006_Cache_Management();
    /*
*@Auhtor: Paul Ghoussoub
*@Description Génération du contexte
*@CreatedDate: 15/02/2021
*/
    public static VI_gdfsuezComBefChpPivot_DocumentV2.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        VI_gdfsuezComBefChpPivot_DocumentV2.system_element osource = new VI_gdfsuezComBefChpPivot_DocumentV2.system_element();
        osource.systemId=application;
        VI_gdfsuezComBefChpPivot_DocumentV2.contextDt octx = new VI_gdfsuezComBefChpPivot_DocumentV2.contextDt();
        octx.version=version;
        octx.systemPath = new VI_gdfsuezComBefChpPivot_DocumentV2.systemPath_element();
        octx.systemPath.system_x = new VI_gdfsuezComBefChpPivot_DocumentV2.system_element[] {osource};
            return octx;
    }
    /*
*@Auhtor: Paul Ghoussoub
*@Description Génération du port
*@CreatedDate: 15/02/2021
*/
    public static VI_gdfsuezBefCalypsoDocumentV2.DocumentPrevisuPort initPort(String NamedCredentialName){
        VI_gdfsuezBefCalypsoDocumentV2.DocumentPrevisuPort port = new VI_gdfsuezBefCalypsoDocumentV2.DocumentPrevisuPort();
        port.endpoint_x =  NamedCredentialName+'/ES-Document_v2';
        port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
        return port;
    }
     /*
*@Auhtor: Paul Ghoussoub
*@Description Récupération du mandat
*@CreatedDate: 15/02/2021
*/
    public static String lireDocument(String idDocument,String referenceClient,String URL,String idApplication,Boolean retourMetadonnees,
                                    String application, String version,String NamedCredentialName)
    {
        VI_gdfsuezComBefChpPivot_DocumentV2.contextDt octx = initContext(application,version);
        VI_gdfsuezBefCalypsoDocumentV2.DocumentPrevisuPort port = initPort(NamedCredentialName);
        VI_gdfsuezBefCalypsoDocumentV2.lireDocumentInputDt input=genererlireDocumentInputDt(idDocument,referenceClient,URL,idApplication,retourMetadonnees);
        VI_gdfsuezBefCalypsoDocumentV2.lireDocumentResponse_element response=new VI_gdfsuezBefCalypsoDocumentV2.lireDocumentResponse_element();
        if(!Test.isRunningTest()) {
            response=portLireDocument(input,octx,port);
            if(response!=null && response.lireDocumentOutput!=null && response.lireDocumentOutput.contenuDocument!=null){
                return response.lireDocumentOutput.contenuDocument;
            }
        }
        else {
            Test.setMock(WebServiceMock.class, new VI_SM033_ServiceDocument_Mock());
            VI_gdfsuezBefCalypsoDocumentV2.DocumentPrevisuPort porttest = new VI_gdfsuezBefCalypsoDocumentV2.DocumentPrevisuPort();
            system.debug('@@ start of mock');  
            response=portLireDocument(input,octx,porttest);
            system.debug('@@ end of mock');
            return response.lireDocumentOutput.contenuDocument;
        }
        return 'Pas de Réponse';
    }
    
    public static VI_gdfsuezBefCalypsoDocumentV2.lireDocumentInputDt genererlireDocumentInputDt(String idDocument,String referenceClient,String URL,String idApplication,Boolean retourMetadonnees){
        VI_gdfsuezComBefChpPivot_DocumentV2.listeValeursDt listeIdApplication=genererIdApplication(idApplication);
        VI_gdfsuezBefCalypsoDocumentV2.document_element document =new  VI_gdfsuezBefCalypsoDocumentV2.document_element();
        //Au choix 1 entrée parmi les 3 suivantes (obligatoire) 
        document.idDocument=idDocument;
        document.referenceClient=referenceClient;
        document.URL=URL;
        //Application dans laquelle récupérer le document (SAE ou Hubeone) 
        document.idApplication=listeIdApplication;
        //booléen facultatif (false par défaut) applicable uniquement avec Hubeone, permettant de récupérer les metadonnées du document
        document.retourMetadonnees=retourMetadonnees;
        VI_gdfsuezBefCalypsoDocumentV2.lireDocumentInputDt input =new VI_gdfsuezBefCalypsoDocumentV2.lireDocumentInputDt();
        input.document=document;
        return input;
    }
        /*@Author: Paul Ghoussoub
*@Description: Génération de l'input
*@CreatedDate: 16/02/2021
*/
    public static VI_gdfsuezComBefChpPivot_DocumentV2.listeValeursDt genererIdApplication( String idApplication){
        VI_gdfsuezComBefChpPivot_DocumentV2.listeValeursDt listeIdAppliccation = new VI_gdfsuezComBefChpPivot_DocumentV2.listeValeursDt();
        listeIdAppliccation.code = idApplication;
        return listeIdAppliccation;
    }
    /*@Author: Paul Ghoussoub
*@Description: Appel Http vers le service Document
*@CreatedDate: 16/02/2021
*/
    public static VI_gdfsuezBefCalypsoDocumentV2.lireDocumentResponse_element portLireDocument(VI_gdfsuezBefCalypsoDocumentV2.lireDocumentInputDt lireDocumentInput,VI_gdfsuezComBefChpPivot_DocumentV2.contextDt context,
                                                                                   VI_gdfsuezBefCalypsoDocumentV2.DocumentPrevisuPort port) 
    {
            
        	VI_gdfsuezBefCalypsoDocumentV2.lireDocument_element request_x = new VI_gdfsuezBefCalypsoDocumentV2.lireDocument_element();
            request_x.lireDocumentInput = lireDocumentInput;
            request_x.context = context;
        	system.debug('request_x'+ request_x);
            VI_gdfsuezBefCalypsoDocumentV2.lireDocumentResponse_element response_x;
            Map<String, VI_gdfsuezBefCalypsoDocumentV2.lireDocumentResponse_element> response_map_x = new Map<String, VI_gdfsuezBefCalypsoDocumentV2.lireDocumentResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              port,
              request_x,
              response_map_x,
              new String[]{port.endpoint_x,
              'tns:lireDocument',
              'http://gdfsuez/bef/calypso/document/v2',
              'lireDocument',
              'http://gdfsuez/bef/calypso/document/v2',
              'lireDocumentResponse',
              'VI_gdfsuezBefCalypsoDocumentV2.lireDocumentResponse_element'}
            );
        
        response_x = response_map_x.get('response_x');
        system.debug('response_x '+response_x);
        system.debug(response_x.lireDocumentOutput.contenuDocument);
            return response_x;
        }
    
}