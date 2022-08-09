/*
*@Author: Paul Ghousoub
*@Description: Appel du WS ChiffrerURL
*@CreatedDate: 7/9/2021
*@LastModified: 7/9/2021
*/
public class VI_SM043_ChiffrerURL {
    /* @author Paul Ghoussoub
* @date 7/9/2021
* @description Initialisation du context 
* @param application,version
* @return le context
*/
    public static VI_gdfsuezComBefChpPivotChiffrement.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        VI_gdfsuezComBefChpPivotChiffrement.system_element osource = new VI_gdfsuezComBefChpPivotChiffrement.system_element();
        osource.systemId=application;
        VI_gdfsuezComBefChpPivotChiffrement.contextDt octx = new VI_gdfsuezComBefChpPivotChiffrement.contextDt();
        octx.version=version;
        octx.systemPath = new VI_gdfsuezComBefChpPivotChiffrement.systemPath_element();
        octx.systemPath.system_x = new VI_gdfsuezComBefChpPivotChiffrement.system_element[] {osource};
            octx.allowCache = false;
        return octx;
    }
    /* @author Paul Ghoussoub
* @date 7/9/2021
* @description Initialisation du port 
* @param NamedCredential
* @return port
*/
    public static VI_gdfsuezComBefChpCalypsoChiffrement.chiffrementPort initPort(String NamedCredential) {
        VI_gdfsuezComBefChpCalypsoChiffrement.chiffrementPort port = new VI_gdfsuezComBefChpCalypsoChiffrement.chiffrementPort();
        port.endpoint_x = NamedCredential + '/ES-Chiffrement_v1'; //'callout:VI_AuthOctopus'
        port.inputHttpHeaders_x = new Map < String, String > {
            'Content-Type' => 'text/xml;charset=utf-8'
                };
                    return port;
    }
    
    /* @author Paul Ghoussoub
* @date 7/9/2021
* @description Creer l'input du ws avec les parametres 
* @param URL à chiffrer
* @return input du ws
*/
    public static VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineInputDt createInput( String URL){
        VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineInputDt input=new VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineInputDt();
        input.chaineAChiffrer=URL;
        return input;
    }
    
    /* @author Paul Ghoussoub
* @date 7/9/2021
* @description Appel webservice pour recuperer l'url chiffré
* @param URL à chiffrer
* @return input du ws
*/
    public static String ChiffrerChaine(String URL,
                                        String NamedCredential, String application,String version)
    {
        VI_gdfsuezComBefChpCalypsoChiffrement.chiffrementPort port=initPort(NamedCredential);
        VI_gdfsuezComBefChpPivotChiffrement.contextDt context= initContext(application,version);
        VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineInputDt input=createInput(URL);
        VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineResponse_element response=new VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineResponse_element();
        
        
        if(!Test.isRunningTest()){ 
            Datetime x =  Datetime.now();
                Integer m = x.millisecond();
                system.debug('OCTOPUS START ChiffrerChaine: '+x+':'+m); 
            response=port.ChiffrerChaine(input,context);
            Datetime y =  Datetime.now();
                Integer n = y.millisecond();
                system.debug('OCTOPUS END ChiffrerChaine: '+y+':'+n); 
            
        }
        else{
            Test.setMock(WebServiceMock.class, new VI_SM043_ChiffrerURL_Mock());
            VI_gdfsuezComBefChpCalypsoChiffrement.chiffrementPort porttest = new  VI_gdfsuezComBefChpCalypsoChiffrement.chiffrementPort();
            response = porttest.ChiffrerChaine(input, context);
        }
        if(response!=null && response.messageRetours!=null && response.messageRetours.retourTraitementMessage!=null &&
          response.messageRetours.retourTraitementMessage[0]!=null && response.messageRetours.retourTraitementMessage[0].code=='OCTOPUS_Chiffrerchaine_01'){
              system.debug('response.chiffrerChaineOutput.chaineChiffree '+response.chiffrerChaineOutput.chaineChiffree);
            return response.chiffrerChaineOutput.chaineChiffree;
        }
        else{
            return 'Erreur lors du chiffrage';
        }
    }
}