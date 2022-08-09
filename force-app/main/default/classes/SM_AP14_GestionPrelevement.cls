/*@Author: MTR
*@Description: Demande de prélèvment
*@CreatedDate:
*@LastModified: MHA 05/02/2019
*/
global class SM_AP14_GestionPrelevement implements vlocity_cmt.VlocityOpenInterface {

    /*@Author: MTR
    *@Description: Demande de prélèvment
    *@CreatedDate:
    *@LastModified: MHA 12/02/2019
    */
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        System.debug('*** input : ' + inputMap);
        boolean returnValue = false;
        if (methodName.equals('demanderPrelevement')) {
            try {
                demandePrelevement(inputMap, outMap, options);
                returnValue = true;
            } catch (Exception e) {
                if (!Test.isRunningTest()) {
                    system.debug(e.getStackTraceString());
                    /*throw new IOException(e.getMessage());*/
                }
            }
        }
        System.debug('outMap:'+outMap);
        return returnValue;
    }

    /*@Author: MTR
    *@Description: Demande de prélèvment
    *@CreatedDate:
    *@LastModified: MHA 12/02/2019
    */
    public static void demandePrelevement(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
	
        Map < String, Object > elements = (Map < String, Object > ) inputMap.get('ServicesGestion');
        if (elements == null) {
            system.debug('no element names with choix elements in omniscript...');
            system.debug('inputs' + inputMap);
            return;
        }

        system.debug('@@elements' + elements);
		
        Map<String, Object> servicesGestion = (Map<String, Object>) inputMap.get('ServicesGestion');

        Map<String, Object> elementsPrelevementInfosBlock = getSelectedElement(servicesGestion.get('EditBlock1'));
        System.debug('@coordonneeBancaire:'+elementsPrelevementInfosBlock);
       /* if (elementsPrelevementInfosBlock == null ) {
            outMap.put('error', 'Pas de coordonnée bancaire selectionnée !');
            throw new IOException('Pas de coordonnée bancaire selectionnée !');
        } */

        String getIban = String.valueof(elementsPrelevementInfosBlock.get('IbanNumber'));
        String getTitulaireCompte = String.valueof(elementsPrelevementInfosBlock.get('TitulaireCompte'));
        String getIdCoordonneeBancaire = String.valueof(elementsPrelevementInfosBlock.get('idCoordonneeBancaire'));

        String getIdPersonne = String.valueof(elementsPrelevementInfosBlock.get('idPersonne'));

        String getIdCompteClient;
       
        if(String.isNotBlank(String.valueof(inputMap.get('idCompteClient')))){
            getIdCompteClient = String.valueof(inputMap.get('idCompteClient'));
        }
        else {
            outMap.put('error', 'l\'idCompteClient est manquant');
            throw new IOException('l\'idCompteClient est manquant');
        }

        /*if(getIdPersonne == null    || getIban == null    ||getTitulaireCompte == null    ||    getIdCompteClient == null ){
                throw    new IOException('donnée manquante : '+ (getIdPersonne == null ? 'idPersonne' : getIban == null ? 'Iban ' :
                                                             getTitulaireCompte == null ? 'getTitulaireCompte ':
                                                             getIdCompteClient == null ? 'Id CompteClient ' : '??')    +' ,le web service ne peut pas etre appele');
           }*/

        system.debug('idPersonne : ' + getIdPersonne);
        system.debug('titulaireCompte : ' + getTitulaireCompte);
        system.debug('idCompteClient : ' + getIdCompteClient);


        //Context
        gdfsuezComBefChpPivot_Prelevement1.contextDt octx = initContext('Smile', '1.0');
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();

        //gdfsuezComBefChpCalypsoGestionprele.GestionPrelevementPort
        gdfsuezComBefChpCalypsoGestionprele.GestionPrelevementPort port = new gdfsuezComBefChpCalypsoGestionprele.GestionPrelevementPort();
        port.clientCertName_x = octopusCS.certName__c;
        SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'GestionPrelevement' limit 1];
        port.endpoint_x =    octopusCS.endpoint__c + suffixs.suffix__c;
        port.inputHttpHeaders_x = new Map < String, String > {
            'Content-Type' => 'text/xml;charset=utf-8'
        };

        /// input ******
        //
        //gdfsuezComBefChpCalypsoGestionprele.coordonneeBancaireDt
        gdfsuezComBefChpCalypsoGestionprele.coordonneeBancaireDt coordonneesBancairesInput = new gdfsuezComBefChpCalypsoGestionprele.coordonneeBancaireDt();
        coordonneesBancairesInput.idCoordonneeBancaire = getIdCoordonneeBancaire;
        //coordonneesBancairesInput.iban = getIban;
        //coordonneesBancairesInput.bban = getBban;
        //coordonneesBancairesInput.titulaireCompte = getTitulaireCompte;

        //gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementInputDt
        gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementInputDt input = new gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementInputDt();
        input.idPersonne = getIdPersonne;
        input.coordonneesBancaires = coordonneesBancairesInput;
        input.idCompteClient = getIdCompteClient;
        input.changementPayeur = false; // getChangementPayeur;

        // gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element
        gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element response = new gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element();

        String responseCodePrelevement;
        /*String responseLibellePrelevement;*/

        try {
            if (!Test.isRunningTest()) {
                response = port.DemanderPrelevement(input, octx);
                system.debug('reponse : ' + response);

            } else {
                Test.setMock(WebServiceMock.class, new SM_AP14_GestionPrelevementMock());
                gdfsuezComBefChpCalypsoGestionprele.GestionPrelevementPort porttest = new gdfsuezComBefChpCalypsoGestionprele.GestionPrelevementPort();
                system.debug('@@ start of mock');
                response = porttest.DemanderPrelevement(input, octx);
                system.debug('@@ end of mock');
            }
            Integer i = 1;
            for (gdfsuezComBefChpPivot_Prelevement1.messageRetour_element anError : response.messageRetours.messageRetour) {
                /*responseCodePrelevement += anError.code;
                   responseLibellePrelevement += anError.libelle;*/
                outMap.put('responseCodePrelevement' + i, anError.code);
                outMap.put('responseLibellePrelevement' + i, anError.libelle);
                if (i == 1) {
                    responseCodePrelevement = anError.code;
                    outMap.put('responseCodePrelevement', responseCodePrelevement);
                }
                i++;
            }

        } catch (Exception e) {
            System.debug('*** Error when calling WS : ' + e);
            system.debug(e.getStackTraceString());
            outMap.put('error', 'une erreur est survenu au moment de l appel WS : DemanderPrelevement' + e.getStackTraceString());
            throw new IOException('une erreur est survenu au moment de l appel WS : DemanderPrelevement' + e.getStackTraceString() );
        }
        System.debug('@MHA output:' + outMap);
        /*outMap.put('responseCodePrelevement', responseCodePrelevement);
           outMap.put('responseLibellePrelevement', responseLibellePrelevement);*/

        /* il faut remonter l'id mandat en cas de succes comme parametre d'input pour la demande et la confirmation signature et
             US 1219
           // */
        /*if (responseCodePrelevement.equals('OCTOPUS_DemanderPrelevement_01') || responseCodePrelevement.equals('OCTOPUS_DemanderPrelevement_02') ) {*/
        if (responseCodePrelevement.equals('OCTOPUS_DemanderPrelevement_02') ) {

            if (response.demanderPrelevementOutput != null && response.demanderPrelevementOutput.mandat != null && response.demanderPrelevementOutput.mandat.idMandat != null) {
                system.debug('MHA response Mandat' + response.demanderPrelevementOutput.mandat.statutMandat.libelleCourt);
                outMap.put('createdIdMandat', response.demanderPrelevementOutput.mandat.idMandat);
                outMap.put('createdStatusMandat', response.demanderPrelevementOutput.mandat.statutMandat.libelleCourt);
                outMap.put('createdStatusCodeMandat', response.demanderPrelevementOutput.mandat.statutMandat.code);
            } else {
                outMap.put('error', 'On ne peut pas recupérer l id mandat depuis le retour WS demander prelevement');
                throw new IOException('On ne peut pas recupérer l id mandat depuis le retour WS demander prelevement');
            }
        }
    }

    /*@Author: MTR
    *@Description: initContext
    *@CreatedDate:
    */
    public static gdfsuezComBefChpPivot_Prelevement1.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        gdfsuezComBefChpPivot_Prelevement1.system_element osource = new gdfsuezComBefChpPivot_Prelevement1.system_element();
        osource.systemId = application;
        gdfsuezComBefChpPivot_Prelevement1.contextDt octx = new gdfsuezComBefChpPivot_Prelevement1.contextDt();
        octx.version = version;
        //    octx.allowCache = false ;
        octx.systemPath = new gdfsuezComBefChpPivot_Prelevement1.systemPath_element();
        octx.systemPath.system_x = new gdfsuezComBefChpPivot_Prelevement1.system_element[] {
            osource
        };
        return octx;
    }

    /*@Author: MTR
    *@Description: Demande de prélèvment
    *@CreatedDate:
    */
    public static Map<String, Object> getSelectedElement(Object elemCoordonnetemp) {
        List<Object> listCoordonne = new List<Object> ();
        if (elemCoordonnetemp instanceof Map<String, Object>) {
            listCoordonne.add(elemCoordonnetemp);
        } else if (elemCoordonnetemp instanceof List<Object>) {
            listCoordonne = (List<Object>) elemCoordonnetemp;
        }

        if (listCoordonne == null || listCoordonne.size() == 0) {
            system.debug('## Pas de coordonnées bancaires ..##');
            return null;
        }
        for ( Object coordonne :    listCoordonne    ) {
            if (((boolean) ((Map<String, Object>) coordonne).get('selectedElement')) == true ) {
                return (Map<String, Object>)coordonne;
            }
        }
        return null;
    }

    public class IOException extends Exception {

    }
}