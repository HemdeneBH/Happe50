/*
*@Auhtor: Paul Ghoussoub
*@Description: Appel de l'API Processus relance mandat
*@CreatedDate: 15/02/2021
*/
public class VI_SM034_ProcessusRelanceMandat {
    public static VI_UTIL006_Cache_Management service = new VI_UTIL006_Cache_Management();
    /*
*@Auhtor: Paul Ghoussoub
*@Description Génération du contexte
*@CreatedDate: 15/02/2021
*/   
    public static VI_gdfsuezComBefChpPivotRelanceMandat.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        VI_gdfsuezComBefChpPivotRelanceMandat.system_element osource = new VI_gdfsuezComBefChpPivotRelanceMandat.system_element();
        osource.systemId=application;
        VI_gdfsuezComBefChpPivotRelanceMandat.contextDt octx = new VI_gdfsuezComBefChpPivotRelanceMandat.contextDt();
        octx.version=version;
        octx.systemPath = new VI_gdfsuezComBefChpPivotRelanceMandat.systemPath_element();
        octx.systemPath.system_x = new VI_gdfsuezComBefChpPivotRelanceMandat.system_element[] {osource};
            return octx;
    }
    /*
*@Auhtor: Paul Ghoussoub
*@Description Génération du port
*@CreatedDate: 15/02/2021
*/
    public static VI_gdfsuezComBefChpRelanceMandat.Dependency initPort(String NamedCredentialName){
        VI_gdfsuezComBefChpRelanceMandat.Dependency port = new VI_gdfsuezComBefChpRelanceMandat.Dependency();
        //A VOIR paul
        port.endpoint_x =  NamedCredentialName+'/ES-ProcessusRelanceMandat_v1';
        port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
            return port;
    }
    /*
*@Auhtor: Paul Ghoussoub
*@Description Création de l'input à partir de l'idpersonne et de la personne afin de faire l'appel ws
*@CreatedDate: 15/02/2021
*/    
    public static VI_gdfsuezComBefChpRelanceMandat.demarrerRelanceMandatResponse_element relancerMandat(String idPersonne,String idMandat,String idCompteClient,String canalVente,
                                                                                                        String application, String version,String NamedCredentialName)
    {
        VI_gdfsuezComBefChpPivotRelanceMandat.contextDt octx = initContext(application,version);
        VI_gdfsuezComBefChpRelanceMandat.Dependency port = initPort(NamedCredentialName);
        VI_gdfsuezComBefChpRelanceMandat.demarrerRelanceMandatInputDt input=genererdemarrerRelanceMandatInputDt(idPersonne,idMandat,idCompteClient,canalVente);
        VI_gdfsuezComBefChpRelanceMandat.demarrerRelanceMandatResponse_element response=new VI_gdfsuezComBefChpRelanceMandat.demarrerRelanceMandatResponse_element();        
        if(!Test.isRunningTest()) {
            //response=portRelanceMandat(input,octx,port);
            response=port.DemarrerRelanceMandat(input,octx);
        }
        else {
            Test.setMock(WebServiceMock.class, new VI_SM034_ProcessusRelanceMandat_Mock());
            VI_gdfsuezComBefChpRelanceMandat.Dependency porttest = new VI_gdfsuezComBefChpRelanceMandat.Dependency();
            system.debug('@@ start of mock');  
            response=porttest.DemarrerRelanceMandat(input,octx);
            system.debug('@@ end of mock');
        }
        
        return response;
    }
    /*@Author: Paul Ghoussoub
*@Description: Génération de l'input
*@CreatedDate: 16/02/2021
*/
    public static VI_gdfsuezComBefChpRelanceMandat.demarrerRelanceMandatInputDt genererdemarrerRelanceMandatInputDt(String idPersonne,String idMandat,String idCompteClient,String canalVente){
        VI_gdfsuezComBefChpRelanceMandat.demarrerRelanceMandatInputDt input=new VI_gdfsuezComBefChpRelanceMandat.demarrerRelanceMandatInputDt();
        //Le champ idPersonne sera utilisé pour appeler l’opération RechercherMandat du service Mandat
        input.idPersonne=idPersonne;
        //Le champ idMandat sera celui utilisé en entrée de l’opération MajMandat du service Mandat
        //Le champ idMandat est utilisé pour déterminer le type de Mandat :
        //Type électronique si l’idMandat n’est pas renseigné:
        //Type papier si l’idMandat est renseigné.  
        input.idMandat=idMandat;
        input.idCompteClient=idCompteClient;
        input.canalVente=canalVente;
        return input;
    }
    
    
}