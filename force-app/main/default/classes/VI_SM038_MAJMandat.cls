public class VI_SM038_MAJMandat {
    public static VI_UTIL006_Cache_Management service = new VI_UTIL006_Cache_Management();
    /*
*@Auhtor: Paul Ghoussoub
*@Description Génération du contexte
*@CreatedDate: 20/04/2021
*/
    public static VI_gdfsuezComBefChpPivot.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        VI_gdfsuezComBefChpPivot.system_element osource = new VI_gdfsuezComBefChpPivot.system_element();
        osource.systemId=application;
        VI_gdfsuezComBefChpPivot.contextDt octx = new VI_gdfsuezComBefChpPivot.contextDt();
        octx.version=version;
        octx.systemPath = new VI_gdfsuezComBefChpPivot.systemPath_element();
        octx.systemPath.system_x = new VI_gdfsuezComBefChpPivot.system_element[] {osource};
            return octx;
    }
    
    /*
*@Auhtor: Paul Ghoussoub
*@Description Génération du port
*@CreatedDate: 20/04/2021
*/
    public static VI_gdfsuezBefCalypsoMandatV1.MandatPort initPort(String NamedCredentialName){
        VI_gdfsuezBefCalypsoMandatV1.MandatPort port = new VI_gdfsuezBefCalypsoMandatV1.MandatPort();
        port.endpoint_x =  NamedCredentialName+'/ES-Mandat_v1';
        port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
            return port;
    }
    @future(callout=true)
    public static void majMandat(String caseId,String idMandat,String code,String idPersonne,String idCoordonneeBancaire,String application, String version,String NamedCredentialName)
    {
        String responseCodeSignature;
        String responseLibelleSignature;
        VI_gdfsuezComBefChpPivot.contextDt octx = initContext(application,version);
        VI_gdfsuezBefCalypsoMandatV1.MandatPort port = initPort(NamedCredentialName);
        VI_gdfsuezBefCalypsoMandatV1.majMandatInputDt majMandatInput = genererMajMandatInputDt(idMandat,code,idPersonne,idCoordonneeBancaire);
        VI_gdfsuezBefCalypsoMandatV1.majMandatResponse_element response = new VI_gdfsuezBefCalypsoMandatV1.majMandatResponse_element();
        if (!Test.isRunningTest()) {
            response=port.MajMandat(majMandatInput,octx);
            system.debug('response '+response);
        }
        else {
            Test.setMock(WebServiceMock.class, new VI_SM038_MAJMandat_Mock());
            VI_gdfsuezBefCalypsoMandatV1.MandatPort portTest = new VI_gdfsuezBefCalypsoMandatV1.MandatPort();
            response =portTest.MajMandat(majMandatInput,octx);
        }
        if(response!=null && response.messageRetours!=null && response.messageRetours.messageRetour[0]!=null && response.messageRetours.messageRetour[0].code!=null
          && response.messageRetours.messageRetour[0].code=='OCTOPUS_MajMandat_01'){
            responseCodeSignature = response.messageRetours.messageRetour[0].code;
            responseLibelleSignature = response.messageRetours.messageRetour[0].libelle;
            Case caseToUpdate=new Case();
            caseToUpdate.id=caseId;
            caseToUpdate.VI_Tech_MAJ_Mandat__c=true;
            update caseToUpdate;
        }
    }
    
    
    public static VI_gdfsuezBefCalypsoMandatV1.majMandatInputDt genererMajMandatInputDt(String idMandat,String code,String idPersonne,String idCoordonneeBancaire){
        VI_gdfsuezBefCalypsoMandatV1.majMandatInputDt input =new VI_gdfsuezBefCalypsoMandatV1.majMandatInputDt();
        VI_gdfsuezComBefChpPivot.listeValeursDt statutMandat =new VI_gdfsuezComBefChpPivot.listeValeursDt();
        statutMandat.code=code;
        input.idMandat=idMandat;
        input.idPersonne=idPersonne;
        //input.idCoordonneeBancaire=idCoordonneeBancaire;
        input.statutMandat=statutMandat;
        return input;
    }
}