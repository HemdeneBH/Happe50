/**
* @description       : Appel de l'API APIHOUR apiset/coordonnées bancaires
* @author            : MKC
* @group             : 
* @last modified on  : 03-11-2021
* @last modified by  : David ATTALI
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   02-01-2019   MKC             Initial Version
* 1.1   03-30-2020   RJM             ???
* 1.2   03-11-2021   David ATTALI    FT1-4449 + Refactoring
**/
global class SM_AP24_CoordonneesBancaires implements vlocity_cmt.VlocityOpenInterface {
    
    private static final String hideIBAN = 'XXXXXXXXXXXXXXXXXXX';
    
    /**
	*@Author: MKC
	*@Description: Méthode à appeler dans cette API
	*@CreatedDate: 02-01-2019
	*@LastModified: MHA 04-04-2019
	**/
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        
        if (methodName.equals('getCoordonneesBancaires')) {
            try {
                getCoordonneesBancaires(inputMap, outMap, options);
            } catch (Exception ex) {
                System.debug(ex);
                return false;
            }
        }
        
        return true;
    }
    
    /**
    *@Author: MKC
    *@Description: Appel de l'API APIHOUR apiset/coordonnées bancaires avec l'idBP
    *@CreatedDate: 02-01-2019
    *@LastModified: RJM 03-30-2020
	**/
    public static void getCoordonneesBancaires(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        
        String vIdBP = (String) inputMap.get('refClientIdBP');
        
        // Ajouté par RJM le 30/03/2020 : FT2-394 (Changement d'offre)
        Boolean isCHO = ((Boolean) inputMap.get('isCHOContext') != null) ? (Boolean) inputMap.get('isCHOContext') : false;
       // Boolean preleve = ((Boolean) inputMap.get('preleve') != null) ? (Boolean) inputMap.get('preleve') : false;
        Boolean preleve = inputMap.get('preleve') != null && inputMap.get('preleve') != '' && inputMap.get('preleve') != ' ' ? Boolean.valueOf(inputMap.get('preleve')) : false;
        String iBanCHO = (String) inputMap.get('iBanCHO');
        String nomBanqueCHO =(String) inputMap.get('nomBanqueCHO');
        String bicCHO = (String) inputMap.get('bicCHO');
        String nomTitulaireCHO = (String) inputMap.get('nomTitulaireCHO');
        Boolean isCHOHarmonica = ((Boolean) inputMap.get('isCHOHarmonica') != null) ? (Boolean) inputMap.get('isCHOHarmonica') : false;
        

        
        // Harmonica case
        String harmonicaBankDetailsId = '';
        harmonicaBankDetailsId = (String) inputMap.get('harmonicaBankDetailsId');
        
        // Cas Pure Player --> CaseOrigine = "Partner Community" | FT1-4573
        String caseOrigine = (String) inputMap.get('caseOrigine');
        
        System.debug('### getCoordonneesBancaires() - vIdBP : ' + vIdBP);
        System.debug('### getCoordonneesBancaires() - isCHO : ' + isCHO);
        System.debug('### getCoordonneesBancaires() - preleve : ' + preleve);
        System.debug('### getCoordonneesBancaires() - iBanCHO : ' + iBanCHO);
        System.debug('### getCoordonneesBancaires() - nomBanqueCHO : ' + nomBanqueCHO);
        System.debug('### getCoordonneesBancaires() - bicCHO : ' + bicCHO);
        System.debug('### getCoordonneesBancaires() - nomTitulaireCHO : ' + nomTitulaireCHO);
        System.debug('### getCoordonneesBancaires() - harmonicaBankDetailsId : ' + harmonicaBankDetailsId);
        
        
        Map<String, Object> moveinData;
        try {
            // Cas Harmonica moveindata renseigné
            moveinData = (Map<String,Object>) inputMap.get('moveinData'); 
        } catch(exception ex) {
            // Cas CRC moveindata vide
            System.debug('### cas movein CRC '+ex);
        }
        
        System.debug('### getCoordonneesBancaires() - moveinData : ' + inputMap.get('moveinData'));

        // Harmonica case : get bank details id
        if(moveinData != null && String.isBlank(harmonicaBankDetailsId)){
            harmonicaBankDetailsId = (String)moveinData.get('ID_coordonnees_bancaires__c');
        }
        

        // Add '0' characters on business partner id (if there are missing characters)
        vIdBP = bpVerification(vIdBP);
        String reqParams;
        
        // Rechercher les coordonnées bancaires a partir de la référence client
        if (!String.isBlank(vIdBP)) {
            reqParams = '?idBusinessPartner=' + vIdBP;
        } else {
            System.debug('Pas d\'identifiant Business Partner en entrée, l\'API ne peut etre invoqué.');
            return;
        }
        
        HttpResponse httpResponse = new HttpResponse();
        
        if (Test.isRunningTest()) {
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SM_MockResponseGetCoordonneesBancaires');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            // Set the mock callout mode
            Test.setMock(HttpCalloutMock.class, mock);
        }
        
        // Call
        httpResponse = getResponse(reqParams);
        
        System.debug('### getCoordonneesBancaires() - httpResponse : ' + httpResponse);
        Map<String, Object> blocksMap = new Map<String, Object> ();
        if (httpResponse != null) {
            
            System.debug('### getCoordonneesBancaires() - httpResponse.getBody() : ' + httpResponse.getBody());
            
            Map<String, Object> resultAsMap = (Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody());
            List<Object> bankDetailsList = (List<Object>) resultAsMap.get('_data');
            
            System.debug('### getCoordonneesBancaires() - _data : ' + resultAsMap.get('_data'));
            
            if (bankDetailsList != null && !bankDetailsList.isEmpty()) {
                
                // Alimente le bloc de prélèvement (Code encore utilisé ?)
                blocksMap.put('PrelevementBlock', getPrelevementInfosBlock(bankDetailsList));
               
                if((!isCHO || !preleve ) || isCHOHarmonica ){
                    blocksMap.put('EditBlock1', getAllList(bankDetailsList, harmonicaBankDetailsId, caseOrigine, isCHOHarmonica));
                  

                }
                
                // Ajouté par RJM le 30/03/2020 : FT2-394 (Changement d'offre)
                if(isCHO && preleve){
                    blocksMap.put('EditBlock2', setValuesCHO(iBanCHO, nomBanqueCHO, bicCHO, nomTitulaireCHO));
                    
                }

                outMap.put('ServicesGestion', blocksMap);
            }
        }
    }
    
    /**
    *@Author: David ATTALI
    *@Description: Alimente le bloc de prélèvement (Code encore utilisé ?)
    *@CreatedDate: 03-11-2021
    **/
    public static Map<String, Object> getPrelevementInfosBlock(List<Object> bankDetailsList) {
        
        Map<String, Object> bankDetails = (Map<String, Object>) bankDetailsList[0];
        
        Map<String, String> mapChamps = new Map <String, String> ();
        String iBAN = (String) bankDetails.get('iBAN');
        String bic = (String) bankDetails.get('bIC');
        String Nombanque = (String) bankDetails.get('nomInstitutBancaire');
        String TitulaireCompte = (String) bankDetails.get('titulaire');
        String idBusinessPartner = (String) bankDetails.get('idBusinessPartner');
        String idCoordonneesBancaire = (String) bankDetails.get('id');
        
        System.debug('### getPrelevementInfosBlock() - iBAN : ' + iBAN);
        System.debug('### getPrelevementInfosBlock() - bic : ' + bic);
        System.debug('### getPrelevementInfosBlock() - Nombanque : ' + Nombanque);
        System.debug('### getPrelevementInfosBlock() - TitulaireCompte : ' + TitulaireCompte);
        System.debug('### getPrelevementInfosBlock() - idBusinessPartner : ' + idBusinessPartner);
        System.debug('### getPrelevementInfosBlock() - idCoordonneesBancaire : ' + idCoordonneesBancaire);
        
        mapChamps.put('IbanNumber', iBAN);
        mapChamps.put('bic', bic);
        mapChamps.put('Nombanque', Nombanque);
        mapChamps.put('TitulaireCompte', TitulaireCompte);
        mapChamps.put('idPersonne', idBusinessPartner);
        mapChamps.put('idCoordonneeBancaire', idCoordonneesBancaire);
        
        Map <String, Object> mapPrelInfoBloc = new Map < String, Object > ();
        mapPrelInfoBloc.put('PrelevementInfosBlock', mapChamps);

        
        return mapPrelInfoBloc; 
    }
    

    /**
    *@Author: MKC
    *@Description: Appel de l'API APIHOUR apiset/coordonnées bancaires avec l'idBP
    *@CreatedDate: 02-01-2019
    *@LastModified: MHA 04-04-2019
    **/

    public static List<Object> getAllList(List<Object> bankDetailsList, String harmonicaBankDetailsId, String caseOrigine, Boolean isCHOHarmonica) {

        
        System.debug('### getAllList() - harmonicaBankDetailsId : ' + harmonicaBankDetailsId);
        
        List <Object> listtemp = new List <Object>();
        
        try {
            
            for (Object bankDetailsObj : bankDetailsList) {
                
                Map <String, Object> bankDetails = (Map<String, Object>) bankDetailsObj;
                Map <String, Object> mapChamps = new Map<String, Object>();
                
                String iBAN = (String) bankDetails.get('iBAN');
                String bic = (String) bankDetails.get('bIC');
                String Nombanque = (String) bankDetails.get('nomInstitutBancaire');
                String TitulaireCompte = (String) bankDetails.get('titulaire');
                Integer idCompteClient = (integer) bankDetails.get('idPortefeuilleContrat'); // idCompteClient coté Octopus mappé avec IdPortefeuillContrat coté Xdata
                String idPersonne = (String) bankDetails.get('idBusinessPartner'); // Idpersonne coté Octopus mappé avec IdBP coté Xdata
                String idCoordonneesBancaire = (String) bankDetails.get('id');
                
                System.debug('### getAllList() - iBAN : ' + iBAN);
                System.debug('### getAllList() - bic : ' + bic);
                System.debug('### getAllList() - Nombanque : ' + Nombanque);
                System.debug('### getAllList() - TitulaireCompte : ' + TitulaireCompte);
                System.debug('### getAllList() - idCompteClient : ' + idCompteClient);
                System.debug('### getAllList() - idPersonne : ' + idPersonne);
                System.debug('### getAllList() - idCoordonneesBancaire : ' + idCoordonneesBancaire);
                
                mapChamps.put('IbanNumber', iBAN);
                mapChamps.put('bic', bic);
                mapChamps.put('Nombanque', Nombanque);
                mapChamps.put('TitulaireCompte', TitulaireCompte);
                mapChamps.put('idPersonne', String.valueOf(idPersonne));
                mapChamps.put('idCompteClientCoordB', String.valueOf(idCompteClient));
                mapChamps.put('idCoordonneeBancaire', idCoordonneesBancaire);
              
                mapChamps.put('libelle1', 'N° IBAN: ' + iBAN.substring(0, 4) + hideIBAN + iBAN.substring(23, 27) + ' ,BIC: ' + bic);
                mapChamps.put('libelle2', 'Nom de la banque: ' + Nombanque + ' ,Titulaire du compte: ' + TitulaireCompte);
                
                if(((caseOrigine == 'Tunnel en ligne' || caseOrigine == 'Partner Community') || isCHOHarmonica)
                   && !String.isBlank(harmonicaBankDetailsId) && harmonicaBankDetailsId == String.valueOf(idCoordonneesBancaire)) {
                       mapChamps.put('selectedElement', true);
                       listtemp.add(mapChamps);
                   } 
                
                if((caseOrigine != 'Tunnel en ligne' && caseOrigine != 'Partner Community') && isCHOHarmonica != true){
                    mapChamps.put('selectedElement', false);
                    listtemp.add(mapChamps);
                }
            }
            
            
        } catch (Exception e) {
            System.debug('## error occured ##' + e.getStackTraceString());
        }
        
        return listtemp; 
    }
    
    /**
    *@Author: RJM
    *@Description: Récupèration des coordonnées actuelles du client
    *@CreatedDate: 03-30-2020
    **/
    public static List<Object> setValuesCHO(String iBanCHO, String nomBanqueCHO, String bicCHO, String nomTitulaireCHO) {
        
        List <Object> listtemp = new List <Object>();
        
        try {
            Map<String, Object> mapChamps = new Map<String, Object>();
            
            mapChamps.put('selectedElement1', true);
            mapChamps.put('libelle11', 'N° IBAN: ' + iBanCHO.substring(0, 4) + hideIBAN + iBanCHO.substring(23, 27) + ' ,BIC: ' + bicCHO);
            mapChamps.put('libelle21', 'Nom de la banque: ' + nomBanqueCHO + ' ,Titulaire du compte: ' + nomTitulaireCHO);
            
            System.debug('*** setValuesCHO - Added to json : ' + mapChamps);
            listtemp.add(mapChamps); 
            
        } catch (Exception ex) {
            System.debug('## error occured ##' + ex.getStackTraceString());
        }
        
        return listtemp; 
    }
    
    
    /**
    *@Author: MKC
    *@Description: Gestion de la response
    *@CreatedDate: 02-01-2019
    *@LastModified: MHA 04-04-2019
    **/
    public static HttpResponse getResponse(String reqParams) {
        
        HttpResponse httpResp = CalloutManager.sendRequest('Coordonnees_Bancaires', reqParams, 'GET', CalloutManager.Scope.READ,null,null);
        if (CalloutManager.httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('## [getAdresse] error occured when sending data ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            return null;
        }
        system.debug('http response is ' + httpResp.getBody());
        return httpResp;
        
    }
    
    
    public static String bpVerification(String idBP) {
        
        String result = '';
        if (idBP.length() < 10) {
            
            Integer missingNumber = 10 - idBP.length();
            for (Integer i = 0; i < missingNumber; i++) {
                result += '0';
            }
        }
        
        result += idBP;
        return result;
    }
    
}