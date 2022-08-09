/*
*@Author: Paul Ghousoub, ELoi Dereeper
*@Description: Classe utilitaire
*@CreatedDate: 23/10/2020
*@LastModified: 20/05/2021
*/
public without sharing class VI_UTIL002_Utilities {
    public static String encodeFormData(Map < String, String > values) { 
        String result = '';
        for (String thisKey : values.keySet()) {
            result += EncodingUtil.urlEncode(thisKey, 'UTF-8') + '=' + EncodingUtil.urlEncode(values.get(thisKey), 'UTF-8') + '&';
        }
        return result.removeEnd('&');
    }
    
    
    public static String getJsonFieldAsString(String nodeName, String body) {
        JSONParser parser = JSON.createParser(body);
        String node = '';
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText().equals(nodeName))) {
                    // Get the value.
                    parser.nextToken();
                    //
                    node = parser.getText();
                }
        }
        return node;
    }
    
    public static boolean processAutoReleve(gdfsuezComBefCalypsoPdlelectricite.PDLElectricite pdlElec, /*Map < String, Object > inputMap*/ Object value, String etatAli, String typeCompteur, String siContractuel, String niveauOuvertureServices) {
       // boolean situation = (inputMap.get('chooseSellingOption') != null && ((String) inputMap.get('chooseSellingOption')).equals('Mise en Service / Emménagement')) ? true : false;
        boolean situation = value!=null && ((String)value).equals('Mise en Service / Emménagement') ? true : false;
        boolean etatAliBool = (etatAli != null && etatAli.equals('non coupe')) ? true : false;
        boolean etatContractuel = (pdlElec.donneesGenerales[0] != null && pdlElec.donneesGenerales[0].etatContractuel != null && pdlElec.donneesGenerales[0].etatContractuel.code != null && pdlElec.donneesGenerales[0].etatContractuel.code.equals('SERVC')) ? true : false;
        boolean typeComptage = ((typeCompteur != null && !typeCompteur.equals('LINKY')) || (siContractuel != null && !siContractuel.equals('GINKO')) || (niveauOuvertureServices != null && !niveauOuvertureServices.equals('Niveau 1') && !niveauOuvertureServices.equals('Niveau 2'))) ? true : false;
        return situation && etatAliBool && etatContractuel && typeComptage;
    }

    public static String formatPhoneNumber(String phone){
        if(phone != null && phone.length() > 9){
        String phoneNumber='+33' + (phone.substring(phone.length()-9, phone.length()));
        system.debug('****** '+phoneNumber);
        return phoneNumber;
        }
        return '';
    }

    public static list<Object> removeDuplicatesAdress(list<Object> listAdress){
        //list<Object> listAddressRes = new list<Object>();
        Map<VI_SM005_AdressesApiService.addressUnicityWrp,Object> mapAdress = new Map<VI_SM005_AdressesApiService.addressUnicityWrp,Object>();
        
        for(Object obj : listAdress){
            String pdlvalue = '';
            String pcevalue = '';
            VI_SM005_AdressesApiService.addressUnicityWrp addWrp = new VI_SM005_AdressesApiService.addressUnicityWrp();
            Map < String, Object > objx = (Map < String, Object > ) obj;
            if(objx.get('idPointDeLivraison') != null){
                pdlvalue = (String) objx.get('idPointDeLivraison');
            }
            if(objx.get('idPointDeComptage') != null){
                pcevalue = (String) objx.get('idPointDeComptage');
            }
            
            addWrp.idPdl =  pdlvalue;   //(String) objx.get('idPointDeLivraison');
            addWrp.idPce =  pcevalue;  //(String) objx.get('idPointDeComptage');
            mapAdress.put(addWrp,obj);
        }
        system.debug('## mapAdress key '+mapAdress.keySet());
        system.debug('## mapAdress values '+mapAdress.values());
        return mapAdress.values();
    }
    

    public static Map<String, Object> transformDatatoOmniscriptAdresses(List < Object > apiData, Boolean bCallZoneDistrib) {
        Map < String, Object > transformeDataStructure = new Map < String, Object > ();
        List < Object > listTemp = new List < Object > ();
        boolean firstCall = true;
        String vElecRegie = '';
        String vGazRegie = '';
        for (Object obj : apiData) {
            Map < String, Object > objectX = (Map < String, Object > ) obj;
            Map< String, Object > newInputMap = new  Map< String, Object >();
            Map< String, Object > newOutputMap = new  Map< String, Object >();
            Map< String, Object > optionMap = new  Map< String, Object >();
            List<String> listPcePDL = new List<String>();
            String PDL = (String) objectX.get('idPointDeLivraison');
            String PCE = (String) objectX.get('idPointDeComptage');
            String addrLabel = (String) objectX.get('numeroVoie') + ' ' + (String) objectX.get('libelleVoie') + ' ' + (String) objectX.get('codePostal');
            addrLabel = addrLabel + ' ' + (String) objectX.get('ville');
            String noVoie = (String) objectX.get('numeroVoie');
            String libelleVoie = (String) objectX.get('libelleVoie');
            String ville = (String) objectX.get('ville');
            String postcode = (String) objectX.get('codePostal');
            String citycode = (String) objectX.get('codeINSEE');
            String complementAdresse = String.valueOf(objectX.get('complementAdresse'));
            String idBan = String.valueOf(objectX.get('idBAN'));
            newInputMap.put('codeINSEE', citycode);
            newInputMap.put('postcode', postcode);
            VI_SM005_AdressesApiService.PdlPceModel pointLivraison = new VI_SM005_AdressesApiService.pdlPceModel(PDL, PCE, vElecRegie, vGazRegie);
            listTemp.add(new VI_SM005_AdressesApiService.AdresseModel(addrLabel, pointLivraison, citycode, postcode, complementAdresse, noVoie, libelleVoie, ville, idBan));
        }
        transformeDataStructure.put('resultdata', listTemp);
        return transformeDataStructure ;
    }
    
    public static Boolean checkIfpdlExist(List<VI_SM005_AdressesApiService.AdresseModel> outAddr, String energy,String numPdlPce){
        String pdl;
        String pce;
        for(VI_SM005_AdressesApiService.AdresseModel objAdr : outAddr){
            pdl=objAdr.pointLivraison.vPDL;
            pce=objAdr.pointLivraison.vPCE;
            If(energy== 'Elec' && pdl==numPdlPce){
                return true;
            }
            If(energy== 'Gaz' && pce==numPdlPce){
                return true;
            }
        }
        return false;
    }

    // EDE : Transfered from VI_AdressesApi (End)
}