/*
*@Auhtor: Paul Ghoussoub
*@Description: Appel de l'API Mandat
*@CreatedDate: 20/05/2021
*/
public without sharing class VI_SM032_DemanderSignature {
    public static VI_UTIL006_Cache_Management service = new VI_UTIL006_Cache_Management();
    /*
*@Auhtor: Paul Ghoussoub
*@Description Génération du contexte
*@CreatedDate: 15/02/2021
*/
    public static gdfsuezComBefChpPivot_Mandat1.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        gdfsuezComBefChpPivot_Mandat1.system_element osource = new gdfsuezComBefChpPivot_Mandat1.system_element();
        osource.systemId=application;
        gdfsuezComBefChpPivot_Mandat1.contextDt octx = new gdfsuezComBefChpPivot_Mandat1.contextDt();
        octx.version=version;
        octx.systemPath = new gdfsuezComBefChpPivot_Mandat1.systemPath_element();
        octx.systemPath.system_x = new gdfsuezComBefChpPivot_Mandat1.system_element[] {osource};
            return octx;
    }
    /*
*@Auhtor: Paul Ghoussoub
*@Description Génération du port
*@CreatedDate: 15/02/2021
*/
    public static gdfsuezBefCalypsoMandatV1.MandatPort initPort(String NamedCredentialName){
        gdfsuezBefCalypsoMandatV1.MandatPort port = new gdfsuezBefCalypsoMandatV1.MandatPort();
        port.endpoint_x =  NamedCredentialName+'/ES-Mandat_v1';
        port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
            return port;
    }
    /*
*@Auhtor: Paul Ghoussoub
*@Description Création de l'input à partir du mandat et de la personne afin de faire l'appel ws
*@CreatedDate: 15/02/2021
*/
    public static String demanderSignature(String idMandat,String idPersonne,String code,String valeur,String application, String version,String NamedCredentialName){
        String responseCodeSignature;
        String responseLibelleSignature;
        gdfsuezComBefChpPivot_Mandat1.contextDt octx = initContext(application,version);
        gdfsuezBefCalypsoMandatV1.MandatPort port = initPort(NamedCredentialName);
        gdfsuezBefCalypsoMandatV1.demanderSignatureInputDt demanderSignatureInput = genererdemanderSignatureInputDt(idMandat,idPersonne,code,valeur);
        // gdfsuezBefCalypsoMandatV1.demanderSignatureResponse_element
        gdfsuezBefCalypsoMandatV1.demanderSignatureResponse_element response = new gdfsuezBefCalypsoMandatV1.demanderSignatureResponse_element();
        
        if (!Test.isRunningTest()) {
            response = DemanderSignature(demanderSignatureInput, octx,port);
            if(response!=null &&response.demanderSignatureOutput!=null && response.demanderSignatureOutput.idDocument !=null){
                return response.demanderSignatureOutput.idDocument;
            }
        } else {
            Test.setMock(WebServiceMock.class, new VI_SM032_DemanderSignature_Mock());
            gdfsuezBefCalypsoMandatV1.MandatPort portTest = new gdfsuezBefCalypsoMandatV1.MandatPort();
            response =DemanderSignature(demanderSignatureInput, octx,portTest);
        }
        
        if(response!=null && response.messageRetours!=null && response.messageRetours.messageRetour[0]!=null && response.messageRetours.messageRetour[0].code!=null){
            responseCodeSignature = response.messageRetours.messageRetour[0].code;
            responseLibelleSignature = response.messageRetours.messageRetour[0].libelle;
            return responseCodeSignature + responseLibelleSignature;
        }
        else{
            return 'Erreur lors de la demande de signature';
        }
        
    }
    /*@Author: Paul Ghoussoub
*@Description: Génération de l'input
*@CreatedDate: 16/02/2021
*/
    public static gdfsuezBefCalypsoMandatV1.demanderSignatureInputDt genererdemanderSignatureInputDt(String idMandat,String idPersonne,String code,String valeur){
        gdfsuezBefCalypsoMandatV1.canalCodeDt canalCodeInput = new gdfsuezBefCalypsoMandatV1.canalCodeDt();
        canalCodeInput.code = code;
        canalCodeInput.valeur = valeur;
        gdfsuezBefCalypsoMandatV1.canalCodeDt[] codes = new gdfsuezBefCalypsoMandatV1.canalCodeDt[] {
            canalCodeInput
                };          
        gdfsuezBefCalypsoMandatV1.demanderSignatureInputDt input=new gdfsuezBefCalypsoMandatV1.demanderSignatureInputDt();
        input.idMandat = idMandat;
        input.idPersonne = idPersonne;
      //  input.canalCode = codes;
        return input;
    }
    
    /*@Author: Paul Ghoussoub
*@Description: Appel Http vers le service DemanderSignature
*@CreatedDate: 16/02/2021
*/
    public static gdfsuezBefCalypsoMandatV1.demanderSignatureResponse_element DemanderSignature(gdfsuezBefCalypsoMandatV1.demanderSignatureInputDt demanderSignatureInput,gdfsuezComBefChpPivot_Mandat1.contextDt context,
                                                                                        gdfsuezBefCalypsoMandatV1.MandatPort port) {
            gdfsuezBefCalypsoMandatV1.demanderSignature_element request_x = new gdfsuezBefCalypsoMandatV1.demanderSignature_element();
            request_x.demanderSignatureInput = demanderSignatureInput;
            request_x.context = context;
            gdfsuezBefCalypsoMandatV1.demanderSignatureResponse_element response_x;
            Map<String, gdfsuezBefCalypsoMandatV1.demanderSignatureResponse_element> response_map_x = new Map<String, gdfsuezBefCalypsoMandatV1.demanderSignatureResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              port,
              request_x,
              response_map_x,
              new String[]{port.endpoint_x,
              'tns:DemanderSignature',
              'http://gdfsuez/bef/calypso/mandat/v1',
              'demanderSignature',
              'http://gdfsuez/bef/calypso/mandat/v1',
              'demanderSignatureResponse',
              'gdfsuezBefCalypsoMandatV1.demanderSignatureResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    
}