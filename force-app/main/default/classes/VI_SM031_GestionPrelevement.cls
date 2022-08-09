/*
*@Auhtor: Paul Ghoussoub
*@Description: Appel afin de retouner créer le mandat d'une personne
*@CreatedDate: 20/05/2021
*/

public without sharing class VI_SM031_GestionPrelevement {
    /*@Author: Paul Ghoussoub
*@Description: Demande de prélèvment
*@CreatedDate:18/2/2021
*/
    public static mandatRetour demandePrelevement(String getTitulaireCompte,String getIdCoordonneeBancaire,
                                                  String getIdPersonne,String getIdCompteClient,String NamedCredentialName) 
    {
        //Context
        VI_gdfsuezComBefChpPivot_Prelevement1.contextDt octx = initContext('PP', '2.0');
        VI_gdfsuezComBefChpCalypsoGestionprele.GestionPrelevementPort port = new VI_gdfsuezComBefChpCalypsoGestionprele.GestionPrelevementPort();
        port.endpoint_x =    NamedCredentialName + '/ES-GestionPrelevement_v1';
        port.inputHttpHeaders_x = new Map < String, String > {
            'Content-Type' => 'text/xml;charset=utf-8'
                };
                    VI_gdfsuezComBefChpCalypsoGestionprele.coordonneeBancaireDt coordonneesBancairesInput = new VI_gdfsuezComBefChpCalypsoGestionprele.coordonneeBancaireDt();
        coordonneesBancairesInput.idCoordonneeBancaire = getIdCoordonneeBancaire;
        VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementInputDt input = new VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementInputDt();
        input.idPersonne = getIdPersonne;
        input.coordonneesBancaires = coordonneesBancairesInput;
        input.idCompteClient = getIdCompteClient;
        input.changementPayeur = false; // getChangementPayeur;
        
        VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element response = new VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element();
        mandatRetour retour=new mandatRetour();
        String responseCodePrelevement;
        try {
            if (!Test.isRunningTest()) {
                response =port.DemanderPrelevement(input, octx);
                system.debug('response mandat '+response);
                
            } else {
                Test.setMock(WebServiceMock.class, new VI_SM031_GestionPrelevement_Mock());
                VI_gdfsuezComBefChpCalypsoGestionprele.GestionPrelevementPort porttest = new VI_gdfsuezComBefChpCalypsoGestionprele.GestionPrelevementPort();
                response =porttest.DemanderPrelevement(input, octx);
                system.debug('response mandat '+response);
            }
            Integer i = 1;
            for (VI_gdfsuezComBefChpPivot_Prelevement1.messageRetour_element anError : response.messageRetours.messageRetour) {
                if (i == 1) {
                    responseCodePrelevement = anError.code;
                }
                i++;
            }
            
        } catch (Exception e) {
            System.debug('*** Error when calling WS : ' + e);
            system.debug(e.getStackTraceString());
            retour.messageRetour='Une erreur est survenu au moment de l appel\'WS : DemanderPrelevement' + e.getStackTraceString();
        }
        System.debug('responseCodePrelevement '+responseCodePrelevement);
        if(responseCodePrelevement!=null){
            if (responseCodePrelevement.equals('OCTOPUS_DemanderPrelevement_01') || responseCodePrelevement.equals('OCTOPUS_DemanderPrelevement_02') ) {
                if (response.demanderPrelevementOutput != null && response.demanderPrelevementOutput.mandat != null && response.demanderPrelevementOutput.mandat.idMandat != null) {
                    retour.idMandat=response.demanderPrelevementOutput.mandat.idMandat;
                    retour.statutMandat=response.demanderPrelevementOutput.mandat.statutMandat.libelleCourt;
                } else {
                    retour.messageRetour='On ne peut pas recupérer l\'id mandat depuis le retour WS demander prelevement';
                }
            }
        }
        return retour;
        
    }
    
    /*@Author: Paul Ghoussoub
*@Description: initContext
*@CreatedDate: 16/02/2021
*/
    public static VI_gdfsuezComBefChpPivot_Prelevement1.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        VI_gdfsuezComBefChpPivot_Prelevement1.system_element osource = new VI_gdfsuezComBefChpPivot_Prelevement1.system_element();
        osource.systemId = application;
        VI_gdfsuezComBefChpPivot_Prelevement1.contextDt octx = new VI_gdfsuezComBefChpPivot_Prelevement1.contextDt();
        octx.version = version;
        //    octx.allowCache = false ;
        octx.systemPath = new VI_gdfsuezComBefChpPivot_Prelevement1.systemPath_element();
        octx.systemPath.system_x = new VI_gdfsuezComBefChpPivot_Prelevement1.system_element[] {
            osource
                };
                    return octx;
    }
    /*@Author: Paul Ghoussoub
*@Description: Appel Http vers le service demanderPrelevement
*@CreatedDate: 16/02/2021

public static VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element DemanderPrelevement(VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementInputDt demanderPrelevementInput,VI_gdfsuezComBefChpPivot_Prelevement1.contextDt context,
VI_gdfsuezComBefChpCalypsoGestionprele.GestionPrelevementPort port)
{
VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevement_element request_x = new VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevement_element();
request_x.demanderPrelevementInput = demanderPrelevementInput;
request_x.context = context;
VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element response_x;
Map<String, VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element> response_map_x = new Map<String, VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element>();
response_map_x.put('response_x', response_x);
system.debug('nouveaau gestion prelevement');
XMLSerializer serializerrequest = new XMLSerializer();
String serializedXMLrequest = serializerrequest.serialize(request_x,true, null); 
system.debug('serializedXMLpaul request'+ serializedXMLrequest);
if(APU002_Context.isCalloutTrackingEnabled())
{
system.debug('tracking enabled');
VI_WS002_GestionPrelevement.GestionPrelevement(
port,
request_x,
response_map_x,
new String[]{port.endpoint_x,
'tns:DemanderPrelevement',
'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',
'demanderPrelevement',
'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',
'demanderPrelevementResponse',
'VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element'}
);
}
else{
WebServiceCallout.invoke(
port,
request_x,
response_map_x,
new String[]{port.endpoint_x,
'tns:DemanderPrelevement',
'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',
'demanderPrelevement',
'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',
'demanderPrelevementResponse',
'VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element'}
);
}
response_x = response_map_x.get('response_x');
XMLSerializer serializerResponse = new XMLSerializer();
String serializedXMLResponse = serializerResponse.serialize(response_x,true, null); 
system.debug('serializedXMLpaul Response'+ serializedXMLResponse);
return response_x;
}
*/
    public class mandatRetour{
        public String idMandat;
        public String statutMandat;
        public String messageRetour;
    }
}