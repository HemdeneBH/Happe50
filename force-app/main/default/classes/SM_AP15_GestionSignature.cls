/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: Test Class for SM_AP12_PdlGaz
*/
global class SM_AP15_GestionSignature implements vlocity_cmt.VlocityOpenInterface {
    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: invoke method for vlocity
    */
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        if (methodName.equals('demanderSignature')) {
            try {
                demanderSignature(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug(e.getStackTraceString());
                return false;
            }
        }
        return true;
    }

    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: method demanderSignature
    */
    public static void demanderSignature(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        String responseCodeSignature;
        String responseLibelleSignature;
        String getCode;
        String getValeur;
        String getIdMandat;
        String getIdPersonne;
        Map < String, Object > elements = (Map < String, Object > ) inputMap.get('ServicesGestion');
        if (elements != null) {

            system.debug('elements : ' + elements);
            Map < String, Object > elementsPrelevementBlock = (Map < String, Object > ) elements.get('PrelevementBlock');
            Map < String, Object > envoiCodeBlockBlock = (Map < String, Object > ) elementsPrelevementBlock.get('EnvoiCodeBlock');

            system.debug('***** ' + envoiCodeBlockBlock);

            //  dans le cadre de l'us 1219
            Map<String, Object> elementsPrelevementInfosBlock =  SM_AP14_GestionPrelevement.getSelectedElement(elements.get('EditBlock1'));

            if (elementsPrelevementInfosBlock == null ) {
                system.debug('Pas de coordonnée bancaire selectionnée !');
                outMap.put('error', 'Pas de coordonnée bancaire selectionnée !');
                throw  new IOException('Pas de coordonnée bancaire selectionnée !');
            }
            getIdPersonne = String.valueof(elementsPrelevementInfosBlock.get('idPersonne'));

            //String.valueof(envoiCodeBlockBlock.get('idMandat')); dans le cadre de l'us 1219 ( recupré depuis la demande prelevement (creation mandat))
            if (String.isBlank(String.valueOf(inputMap.get('createdIdMandat')))) {
                outMap.put('error', 'l\'idMandat est manquant');
                throw new IOException('l\'idMandat est manquant');
            }
            getIdMandat = String.valueOf(inputMap.get('createdIdMandat'));

            // fin cadre us 1219
            getCode = String.valueof(envoiCodeBlockBlock.get('codeInput'));
            getValeur = String.valueof(envoiCodeBlockBlock.get('valeurInput'));

            system.debug('idPersonne : ' + getIdPersonne);
            system.debug('idMandat : ' + getIdMandat);
            system.debug('code : ' + getCode);
            system.debug('valeur : ' + getValeur);

            if (getCode != null && getCode == 'EMAIL' && String.isBlank(getValeur)) {
                responseLibelleSignature = 'Aucun Email';
                outMap.put('responseLibelleSignature', responseLibelleSignature);
                outMap.put('error', 'L\'email n\'a pas été sélectionné');
                throw new IOException('L\'email n\'a pas été sélectionné');
            }
            if(getCode == 'TEL' && String.isNotBlank(getValeur)){
                if(getValeur.length() >10){
                    getValeur = formatPhoneNumber(getValeur);
                }
            }
        }
        //Context
        gdfsuezComBefChpPivot_Mandat1.contextDt octx = initContext('Smile', '1.0');
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();

        //Port
        gdfsuezBefCalypsoMandatV1.MandatPort port = new gdfsuezBefCalypsoMandatV1.MandatPort();
        port.clientCertName_x = octopusCS.certName__c;
        port.endpoint_x =  octopusCS.endpoint__c + 'ES-Mandat_v1';
        port.inputHttpHeaders_x = new Map < String, String > {
            'Content-Type' => 'text/xml;charset=utf-8'
        };


        // Input
        gdfsuezBefCalypsoMandatV1.demanderSignatureInputDt demanderSignatureInput = new gdfsuezBefCalypsoMandatV1.demanderSignatureInputDt();

        // gdfsuezBefCalypsoMandatV1.canalCodeDt
        gdfsuezBefCalypsoMandatV1.canalCodeDt canalCodeInput = new gdfsuezBefCalypsoMandatV1.canalCodeDt();
        canalCodeInput.code = getCode;
        canalCodeInput.valeur = getValeur;

        gdfsuezBefCalypsoMandatV1.canalCodeDt[] codes = new gdfsuezBefCalypsoMandatV1.canalCodeDt[] {
            canalCodeInput
        };
        //   codes.add(canalCodeInput);

        demanderSignatureInput.idMandat = getIdMandat;
        demanderSignatureInput.idPersonne = getIdPersonne;
        demanderSignatureInput.canalCode = codes;

        system.debug('input : ' + demanderSignatureInput);


        // gdfsuezBefCalypsoMandatV1.demanderSignatureResponse_element
        gdfsuezBefCalypsoMandatV1.demanderSignatureResponse_element response = new gdfsuezBefCalypsoMandatV1.demanderSignatureResponse_element();


        try {
            if (!Test.isRunningTest()) {
                response = port.DemanderSignature(demanderSignatureInput, octx);
            } else {
                Test.setMock(WebServiceMock.class, new SM_AP15_GestionSignatureMock());
                gdfsuezBefCalypsoMandatV1.MandatPort portTest = new gdfsuezBefCalypsoMandatV1.MandatPort();
                response = portTest.DemanderSignature(demanderSignatureInput, octx);
            }


            responseCodeSignature = response.messageRetours.messageRetour[0].code;
            responseLibelleSignature = response.messageRetours.messageRetour[0].libelle;

            system.debug('reponse : ' + response);
            system.debug('responseCodeSignature : ' + responseCodeSignature);
            system.debug('responseLibelleSignature : ' + responseLibelleSignature);

            outMap.put('responseCodeSignature', responseCodeSignature);
            outMap.put('responseLibelleSignature', responseLibelleSignature);

        } catch (Exception e) {
            outMap.put('responseCodeSignature', responseCodeSignature);
            outMap.put('responseLibelleSignature', responseLibelleSignature);
            system.debug(e.getStackTraceString());
            outMap.put('error', responseCodeSignature + ' ' + responseLibelleSignature);
            throw new IOException('responseLibelleSignature');
        }


    }

    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: method initContext
    */
    public static gdfsuezComBefChpPivot_Mandat1.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        gdfsuezComBefChpPivot_Mandat1.system_element osource = new gdfsuezComBefChpPivot_Mandat1.system_element();
        osource.systemId = application;
        gdfsuezComBefChpPivot_Mandat1.contextDt octx = new gdfsuezComBefChpPivot_Mandat1.contextDt();
        octx.version = version;
        //  octx.allowCache = false ;
        octx.systemPath = new gdfsuezComBefChpPivot_Mandat1.systemPath_element();
        octx.systemPath.system_x = new gdfsuezComBefChpPivot_Mandat1.system_element[] {
            osource
        };
        return octx;
    }

    /*
    *@author: MHA
    *@Description: Formatage du numéro de téléphone
    *@CreatedDate: 04/04/2019
    *@LastModified: MHA 04/04/2019
    */
    public static String formatPhoneNumber(String phonerNumber){
        Integer startIndex = 0;
        Integer normalSize = 10;
        if(phonerNumber.length() > normalSize){
            system.debug('length:'+phonerNumber.length());
            startIndex = phonerNumber.length() - normalSize+1;
        }
        System.debug(startIndex);
        String newPhoneNumberformat = '0'+phonerNumber.substring(startIndex);
        System.debug('@result:'+newPhoneNumberformat+',var:'+phonerNumber.substring(startIndex));
        return newPhoneNumberformat;
    }


    public class IOException extends Exception {

    }
}