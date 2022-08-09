/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: Class SM_AP19_ConfirmerSignature calling confirmerSignature
*/
global class SM_AP19_ConfirmerSignature implements vlocity_cmt.VlocityOpenInterface {

    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: invoke method for vlocity
    */
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        
        if (methodName.equals('confirmerSignature')) {
            try {
                confirmerSignature(inputMap, outMap, options);
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
    * @Description: vlocity calling method confirmerSignature
    */
    public static void confirmerSignature(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        Map < String, Object > elements = (Map < String, Object > ) inputMap.get('ServicesGestion');
        Map < String, Object > prelevementBloc = (Map < String, Object > ) elements.get('PrelevementBlock');
        Map < String, Object > codeBlock = (Map < String, Object > ) prelevementBloc.get('codeBlock');
        // system.debug('codeBlock'+elements.get('codeBlock'));
        system.debug('serviceGEstion' + elements);

        // dans le cadre de l'us 1219
        String selectedMandat = (String)inputMap.get('createdIdMandat'); //  (String) codeBlock.get('idMandatFormula');
        //  l'us 1219
        String selectedCode = (String) codeBlock.get('codeVerif');

        if (String.isBlank(selectedMandat) || String.isBlank(selectedCode) ) {
            System.debug('missing datas ...');
            if(String.isBlank(selectedMandat)){
                outMap.put('error','L\'id mandat est manquant');
                throw new IOException('L\'id mandat est manquant');
            }else if(String.isBlank(selectedCode)){
                outMap.put('error','Le code de vérification est manquant');
                throw new IOException('Le code de vérification est manquant');
            }
        }

        //Context
        gdfsuezComBefChpPivot_Mandat1.contextDt octx = initContext('Smile', '1.0');
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();

        //   codes.add(canalCodeInput);

        //Port
        gdfsuezBefCalypsoMandatV1.MandatPort port = new gdfsuezBefCalypsoMandatV1.MandatPort();
        port.clientCertName_x = octopusCS.certName__c;
        SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'MandatWS' limit 1];
        port.endpoint_x = octopusCS.endpoint__c + suffixs.suffix__c;
        port.inputHttpHeaders_x = new Map < String, String > {
            'Content-Type' => 'text/xml;charset=utf-8'
        };

        // input
        //
        gdfsuezBefCalypsoMandatV1.confirmerSignatureInputDt confirmerSignatureinput = new gdfsuezBefCalypsoMandatV1.confirmerSignatureInputDt();
        confirmerSignatureinput.idMandat = selectedMandat;
        confirmerSignatureinput.code = selectedCode;
        gdfsuezBefCalypsoMandatV1.confirmerSignatureResponse_element response = new gdfsuezBefCalypsoMandatV1.confirmerSignatureResponse_element();

        String responseCode;
        String responseLibelle;

        try {
            if (!Test.isRunningTest()) {
                response = port.ConfirmerSignature(confirmerSignatureinput, octx);
            } else {

                Test.setMock(WebServiceMock.class, new SM_AP19_ConfirmerSignatureMock());
                gdfsuezBefCalypsoMandatV1.MandatPort portest = new gdfsuezBefCalypsoMandatV1.MandatPort();
                system.debug('@@ start of mock');
                response = portest.ConfirmerSignature(confirmerSignatureinput, octx);
            }
            responseCode = response.messageRetours.messageRetour[0].code;
            responseLibelle = response.messageRetours.messageRetour[0].libelle;

            system.debug('reponse : ' + response);
            system.debug('responseCode: ' + responseCode);
            system.debug('responseLibelle : ' + responseLibelle);


            if (responseCode.equals(System.Label.SM_ConfirmerSignature_OK) || responseCode.equals('OCTOPUS_ConfirmerSignature_09')|| responseCode.equals('OCTOPUS_ConfirmerSignature_10') ) {
                outMap.put('confirmerSign_ok', 'Code de confirmation envoyé, le prelevement automatique a bien été prise en compte');
            } else if(responseCode.equals('OCTOPUS_ConfirmerSignature_04')|| responseCode.equals('OCTOPUS_ConfirmerSignature_05') ||
                      responseCode.equals('OCTOPUS_ConfirmerSignature_06')|| responseCode.equals('OCTOPUS_ConfirmerSignature_07')|| responseCode.equals('OCTOPUS_ConfirmerSignature_08') 
                      || responseCode.equals('OCTOPUS_ConfirmerSignature_99')){
                          outMap.put('confirmerSign_nok', 'Mince ! \n Le webservice est momentanément indisponible.\n veuillez cliquer "Appel inerrompu-Tracer l\'interaction"');
                        outMap.put('confirmerSign_ok', 'Init');
                      }else if( responseCode.equals('OCTOPUS_ConfirmerSignature_02')|| responseCode.equals('OCTOPUS_ConfirmerSignature_03')){
                          outMap.put('confirmerSign_nok', 'Code invalide, veuillez saisir le code à nouveau');
                          outMap.put('confirmerSign_ok', 'Init');
                      }

        } catch (Exception e) {
            system.debug(e.getStackTraceString());
            outMap.put('confirmerSign_nok', 'Mince ! \n Le webservice est momentanément indisponible.\n veuillez cliquer "Appel inerrompu-Tracer l\'interaction"');
            outMap.put('error','Mince ! \n Le webservice est momentanément indisponible.\n veuillez cliquer "Appel inerrompu-Tracer l\'interaction"');
            outMap.put('confirmerSign_ok', 'Init');
            throw new IOException('Problème lors de l\'appel du service Octopus confirmer signature');
        }
    }

    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: init context
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

    public class IOException extends Exception {

    }
}