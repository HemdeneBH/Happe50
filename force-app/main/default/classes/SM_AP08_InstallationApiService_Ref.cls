global class SM_AP08_InstallationApiService_Ref implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        if (methodName.equals('callInstallations')) {
            try {
                callInstallations(inputMap, outMap, options);
                // your implementation, use outMap to send response back to OmniScript
            } catch (Exception e) {
                return false;
            }
        }
        else if(methodName.equals('verifyExistencePDLOrPCE')){
            try {
                verifyExistencePDLOrPCE(inputMap, outMap, options);
            } catch (Exception e) {
                return false;
            }
        }
        else if(methodName.equals('getInstallationData')){
            try {
                getInstallationData(inputMap, outMap, options);
            } catch (Exception e) {
                return false;
            }
        }
        else if(methodName.equals('verifyExistentInstallations')){
            try {
                verifyExistentInstallations(inputMap, outMap, options);
            } catch (Exception e) {
                
                return false;
            }
        }

        return true;

}

    public static void callInstallations(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        Map<String, Object> insideMap = (Map<String, Object>)inputMap.get('ChoixElements1');
        Object valueNumeroPDL;
        Object valueNumeroPCE;
        if ((insideMap.get('selectedPDLValFormula') == null || String.valueOf(insideMap.get('selectedPDLValFormula')).length() == 0) && (insideMap.get('selectedPCEValFormula') == null || String.valueOf(insideMap.get('selectedPCEValFormula')).length() == 0)) {
            return;
        }

        if (insideMap.get('selectedPDLValFormula') != null && String.valueOf(insideMap.get('selectedPDLValFormula')).length() != 0) {
            valueNumeroPDL = String.valueOf(insideMap.get('selectedPDLValFormula'));
        }
        if (insideMap.get('selectedPCEValFormula') != null && String.valueOf(insideMap.get('selectedPCEValFormula')).length() != 0) {
            valueNumeroPCE = String.valueOf(insideMap.get('selectedPCEValFormula'));
        }

        HttpResponse httpResponse = new HttpResponse();
        Map<String,String> listParameters = new Map<String,String>();
        listParameters.put('numeroPointDeLivraison',String.valueOf(valueNumeroPDL));
        if (!Test.isRunningTest()) {
            httpResponse = getResponse(listParameters);
        } else {
            // Set the mock callout mode
            httpResponse = getResponse(listParameters);
        }

        Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
        List < Object > clientAccounts = (List < Object > ) resultAsMap.get('_data');

        if (clientAccounts.Size() == 0) {
        }else{
            Map<String, Object> transformedData = (Map<String, Object>)transformDatatoOmniscript(clientAccounts) ;
            List<Object> installs = (List<Object>)transformedData.get('resultdata1');
            InstallationsModel install = (InstallationsModel)installs.get(0);
            outMap.put('data1', transformedData);
            outMap.put('idLocal',String.valueOf(install.idLocal));
        }
        // methode qui transform les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript


        //PCE
        /*HttpResponse httpResponse1 = new HttpResponse();*/
        if (!Test.isRunningTest()) {
            listParameters.put('numeroPointDeLivraison',  String.valueOf(valueNumeroPCE));
            httpResponse = getResponse(listParameters);
        }

        Map < String, Object > resultAsMap1 = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
        List < Object > clientAccounts1 = (List < Object > ) resultAsMap1.get('_data');

        if (clientAccounts1.Size() == 0) {
            return;
        }else{
            Map<String, Object> transformedData1 =  transformDatatoOmniscript(clientAccounts1) ;
            List<Object> installs = (List<Object>)transformedData1.get('resultdata1');
            InstallationsModel install = (InstallationsModel)installs.get(0);
            outMap.put('data2', transformedData1);
            outMap.put('idLocal',String.valueOf(install.idLocal));
        }
        // methode qui transform les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript

        /*if(clientAccounts.Size() == 0){
            outMap.put('data1', transformedData);
        }else if(clientAccounts1.Size() == 0){
            outMap.put('data1', transformedData1);
        }else{
            return;
        }*/


}

    public static void  getInstallationData (Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

        if (inputMap.get('idLocal') == null || String.valueOf(inputMap.get('idLocal')).length() == 0) {
            return;
        }
        String idLocal = String.valueOf(inputMap.get('idLocal'));

        HttpResponse httpResponse = getResponse(new Map<String,String> {'idLocal' => idLocal});
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());

        if (resultAsMap.Size() == 0) {
            outMap.put('resultdata', new List<Object>());
        }
       else {
            outMap.put('resultdata', resultAsMap);
        }

}

    public static void verifyExistencePDLOrPCE(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        //Map<String, Object> insideMap = (Map<String, Object>) inputMap.get('SetTypeEnergieDemandee');
        String idLocal;
        String typeEnergieDemandee;
        String numeroPointDeLivraison;

        if(String.isBlank(String.valueOf(inputMap.get('typeEnergieDemandee')))){
            return;
        }
        if(String.isBlank(String.valueOf(inputMap.get('idLocal')))){
            return;
        }
        idLocal =  String.valueOf(inputMap.get('idLocal'));
        typeEnergieDemandee = String.valueOf(inputMap.get('typeEnergieDemandee'));



        HttpResponse httpResponse = new HttpResponse();
        Map<String,String> listParameters = new Map<String,String>();
        listParameters.put('idLocal',idLocal);
        if (!Test.isRunningTest()) {
            httpResponse = getResponse(listParameters);
        }
        else{
            httpResponse = getResponse(listParameters);
        }


        Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
        List < Object > listInstallationAPI = (List < Object > ) resultAsMap.get('_data');

        List<InstallationsModel> listInstallations = transformDatatoListInstallation(listInstallationAPI);
        String energyTypeAPIDemandee = transformDataSmileToAPIInstallation(typeEnergieDemandee);
        if(listInstallations.size()==0){
        }


        InstallationsModel installation = filterInstallationToCheck(listInstallations, energyTypeAPIDemandee);
        if(installation==null){
            // on lance la creation du PDL/PCE dans SAP

            if (!Test.isRunningTest()) {
               // Map<String, Object> insideMap = (Map<String, Object>)inputMap.get('ChoixElements1');
                if(String.isBlank(String.valueOf(inputMap.get('selectedPDLValFormula'))) && String.isBlank(String.valueOf(inputMap.get('selectedPCEValFormula')))){
                    return;
                }
                if(typeEnergieDemandee.equals('GAZ')){
                    numeroPointDeLivraison =  String.valueOf(inputMap.get('selectedPCEValFormula'));
                }
                else if(typeEnergieDemandee.equals('ELEC')){
                    numeroPointDeLivraison =  String.valueOf(inputMap.get('selectedPDLValFormula'));
                }
                outMap.put('isPDLOrPCEExistInSAP', false);
            }

        } else{
            // l'installation demandee existe - on poursuit le parcours
            outMap.put('isPDLOrPCEExistInSAP', true);
        }


}
    
    public static void verifyExistentInstallations(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        String typeOffreASouscrire;
        String numeroPCE;
        String numeroPDL;

       // Map < String, Object > etapeContexteMap = (Map < String, Object >) inputMap.get('ChoixElements');
      //  Map < String, Object > etapeLogementMap = (Map < String, Object >) inputMap.get('ChoixElements1');

        if(String.isBlank(String.valueOf(inputMap.get('typeEnergieDemandee')))){
            return;
        }

        if(String.isBlank(String.valueOf(inputMap.get('selectedPDLValFormula'))) && String.isBlank(String.valueOf(inputMap.get('selectedPCEValFormula')))){
            return;
        }

        typeOffreASouscrire = (String) inputMap.get('typeEnergieDemandee');
        numeroPCE = !String.isBlank(String.valueOf(inputMap.get('selectedPCEValFormula'))) ? String.valueOf(inputMap.get('selectedPCEValFormula')) : String.valueOf(inputMap.get('associatedPCEVal'));
        numeroPDL = !String.isBlank(String.valueOf(inputMap.get('selectedPDLValFormula'))) ? String.valueOf(inputMap.get('selectedPDLValFormula')) : String.valueOf(inputMap.get('associatedPDLVal'));
      
        InfoPDLPCEToBeCreated infoPDLPCEToBeCreated;
        String idLocalPDLInstallation;
        String idLocalPCEInstallation;
        
        // Cas A : l'adresse possède un pdl ET un pce
        if(!String.isBlank(numeroPCE) && !String.isBlank(numeroPDL)){
            // Si le client a choisi que le pdl
            if('Elec'.equals(typeOffreASouscrire)){
                idLocalPDLInstallation = isPointLivraisonPossedeInstallation(numeroPDL);
                if(String.isBlank(idLocalPDLInstallation)){
                    idLocalPCEInstallation = isPointLivraisonPossedeInstallation(numeroPCE);
                    if(String.isBlank(idLocalPCEInstallation)){
                        //  creation LC + PDL
                        infoPDLPCEToBeCreated = new InfoPDLPCEToBeCreated(null,numeroPDL,null,typeOffreASouscrire,false,true);
                    }
                    else{
                        // lancer creation PDL dans SAP
                        infoPDLPCEToBeCreated = new InfoPDLPCEToBeCreated(null,numeroPDL,idLocalPCEInstallation,typeOffreASouscrire,true,false);
                    }
                }
                else{
                    // Poursuivre parcours
                    infoPDLPCEToBeCreated = new InfoPDLPCEToBeCreated(null,null,idLocalPDLInstallation,typeOffreASouscrire,false,false);
                }
            }
            else if('Gaz'.equals(typeOffreASouscrire)){
                idLocalPCEInstallation = isPointLivraisonPossedeInstallation(numeroPCE);
                if(String.isBlank(idLocalPCEInstallation)){
                    idLocalPDLInstallation = isPointLivraisonPossedeInstallation(numeroPDL);
                    if(String.isBlank(idLocalPDLInstallation)){
                        //  creation LC + PDL
                        infoPDLPCEToBeCreated = new InfoPDLPCEToBeCreated(numeroPCE,null,null,typeOffreASouscrire,false,true);
                    }
                    else{
                        // lancer creation PDL dans SAP
                        infoPDLPCEToBeCreated = new InfoPDLPCEToBeCreated(numeroPCE,null,idLocalPDLInstallation,typeOffreASouscrire,true,false);
                    }
                }
                else{
                    // Poursuivre parcours
                    infoPDLPCEToBeCreated = new InfoPDLPCEToBeCreated(null,null,idLocalPCEInstallation,typeOffreASouscrire,false,false);
                }
            }
            else if('Duo'.equals(typeOffreASouscrire)){
                idLocalPCEInstallation = isPointLivraisonPossedeInstallation(numeroPCE);
                idLocalPDLInstallation = isPointLivraisonPossedeInstallation(numeroPDL);
                if(String.isBlank(idLocalPCEInstallation) && String.isBlank(idLocalPDLInstallation)){
                    // Ni le PDL ni le PCE possedent une installation
                    infoPDLPCEToBeCreated = new InfoPDLPCEToBeCreated(numeroPCE,numeroPDL,null,typeOffreASouscrire,false,true);
                }
                else if(!String.isBlank(idLocalPCEInstallation) && !String.isBlank(idLocalPDLInstallation)){
                    // PDL et PCE possedent tous les deux une installation dans SAP
                    infoPDLPCEToBeCreated = new InfoPDLPCEToBeCreated(null,null,idLocalPDLInstallation,typeOffreASouscrire,false,false);
                }
                    // Que le PCE qui possede une installation
                else if(!String.isBlank(idLocalPCEInstallation)){
                    infoPDLPCEToBeCreated = new InfoPDLPCEToBeCreated(null,numeroPDL,idLocalPCEInstallation,typeOffreASouscrire,true,false);
                }
                // Que le PDL qui possede une installation
                else{
                    infoPDLPCEToBeCreated = new InfoPDLPCEToBeCreated(numeroPCE,null,idLocalPDLInstallation,typeOffreASouscrire,true,false);
                }
                
            }
            
        }
        
        
        // Cas B : l'adresse possède que le pdl
        else if(!String.isBlank(numeroPDL)){
            idLocalPDLInstallation = isPointLivraisonPossedeInstallation(numeroPDL);
            // Il existe pas d'installation ELEC  - Creer PDL+LOCAL
            if(String.isBlank(idLocalPDLInstallation)){
                infoPDLPCEToBeCreated = new InfoPDLPCEToBeCreated(null,numeroPDL,null,typeOffreASouscrire,false,true);
            }
            else{
                // Installation ELEC existante - Poursuivre le parcours
                infoPDLPCEToBeCreated = new InfoPDLPCEToBeCreated(null,null,idLocalPDLInstallation,typeOffreASouscrire,false,false);
            }
            
        }
        // Cas C : l'adresse possède que le pce
        else if(!String.isBlank(numeroPCE)){
            
            idLocalPCEInstallation = isPointLivraisonPossedeInstallation(numeroPCE);
            // Il existe pas d'installation GAZ - - Creer PCE+LOCAL
            if(String.isBlank(idLocalPCEInstallation)){
                infoPDLPCEToBeCreated = new InfoPDLPCEToBeCreated(numeroPCE,null,null,typeOffreASouscrire,false,true);
            }
            else{
                // Installation GAZ existante - Poursuivre le parcours
                infoPDLPCEToBeCreated = new InfoPDLPCEToBeCreated(null,null,idLocalPCEInstallation,typeOffreASouscrire,false,false);
            }
            
            
        }
       // outMap.put('InfoPDLPCEToBeCreated',infoPDLPCEToBeCreated);
        outMap.put('numPCEToBeCreated', infoPDLPCEToBeCreated.numPCEToBeCreated);
        outMap.put('numPDLToBeCreated', infoPDLPCEToBeCreated.numPDLToBeCreated);
        outMap.put('typeOffreASouscrire', infoPDLPCEToBeCreated.typeOffreASouscrire);
        outMap.put('creerPointDeLivraison', infoPDLPCEToBeCreated.creerPointDeLivraison);
        outMap.put('creerLieuConso', infoPDLPCEToBeCreated.creerLieuConso);
        
        if(!String.isBlank(infoPDLPCEToBeCreated.idLocal)){
            outMap.put('idLocal',infoPDLPCEToBeCreated.idLocal);
        }

}

    public static InstallationsModel filterInstallationToCheck(List<InstallationsModel> listInstallations, String energyTypeAPIDemandee){

        InstallationsModel installation;
        for(InstallationsModel installationItem : listInstallations){
            if(installationItem.secteurActivite.equals(energyTypeAPIDemandee)){
                installation = installationItem;
            }
        }
        return installation;

}

    public static String transformDataSmileToAPIInstallation(String typeEnergieDemandee){
        typeEnergieDemandee = typeEnergieDemandee.toUpperCase();
        String energyTypeAPI;
        if(typeEnergieDemandee.equals('GAZ')){
            energyTypeAPI = 'Gaz Naturel';
        }
        else if(typeEnergieDemandee.equals('ELEC')){
            energyTypeAPI = 'Electricité';
        }
        return energyTypeAPI;

}

    public class InstallationsModel {
        public String numeroPointDeLivraison;
        public String value;
        public String idLocal;
        public String secteurActivite;
        public String numeroInstallation;
        /*public String url;*/

        public InstallationsModel(String numeroPointDeLivraison, String valueChb, String idLocal, String secteurActivite, String numeroInstallation) {
            this.numeroPointDeLivraison = numeroPointDeLivraison;
            this.value = valueChb;
            this.idLocal = idLocal;
            this.secteurActivite= secteurActivite;
            this.numeroInstallation = numeroInstallation;
            /*this.url = url;*/
        }


    }
    
    public class InfoPDLPCEToBeCreated{
        public String numPCEToBeCreated;
        public String numPDLToBeCreated;
        public String idLocal;
        public String typeOffreASouscrire;
        public boolean creerPointDeLivraison;
        public boolean creerLieuConso;
        
        public InfoPDLPCEToBeCreated(String numPCEToBeCreated, String numPDLToBeCreated, String idLocal, String typeOffreASouscrire,boolean creerPointDeLivraison, boolean creerLieuConso){
            this.numPCEToBeCreated = numPCEToBeCreated;
            this.numPDLToBeCreated = numPDLToBeCreated;
            this.idLocal = idLocal;
            this.typeOffreASouscrire = typeOffreASouscrire;
            this.creerPointDeLivraison = creerPointDeLivraison;
            this.creerLieuConso = creerLieuConso;
        }
    }

    public static  Map<String, Object> transformDatatoOmniscript(List < Object > apiData) {

        Map < String, Object > transformeDataStructure = new Map < String, Object > ();
        List < Object > listTemp = new List < Object > ();
        for (Object obj : apiData) {
            Map < String, Object > objectX = (Map < String, Object > ) obj;
            listTemp.add(new InstallationsModel(String.valueOf(objectX.get('numeroPointDeLivraison')), (String.valueOf(objectX.get('uniteReleve'))).substring(6, 8), String.valueOf(objectX.get('idLocal')),String.valueOf(objectX.get('secteurActivite')),String.valueOf(objectX.get('numeroInstallation'))));
        }
        transformeDataStructure.put('resultdata1', listTemp);
        return transformeDataStructure ;

}

    
    public static  List<InstallationsModel> transformDatatoListInstallation(List < Object > listInstallationAPI) {
        List <InstallationsModel> listInstallations = new List <InstallationsModel>();
        for (Object installationAPI : listInstallationAPI) {
            Map < String, Object > installationAPIMap = (Map < String, Object > ) installationAPI;
            listInstallations.add(new InstallationsModel(String.valueOf(installationAPIMap.get('numeroPointDeLivraison')), (String.valueOf(installationAPIMap.get('uniteReleve'))).substring(6, 8),String.valueOf(installationAPIMap.get('idLocal')), String.valueOf(installationAPIMap.get('secteurActivite')), String.valueOf(installationAPIMap.get('numeroInstallation'))));    
        }
        return listInstallations;

}
    /*
    * @Author: Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
    * @Date: 21/03/2019
    * @Description: Cette methode permet de verifier si le numero de point de livraison possede une installation ou pas
    *               Si oui, on retourne le idLocal
    *               Sinon on retourne null
    */
    public static String isPointLivraisonPossedeInstallation(String numeroPointLivraison){

        HttpResponse httpResponse = new HttpResponse();
        Map<String,String> listParameters = new Map<String,String>();
        listParameters.put('numeroPointDeLivraison', numeroPointLivraison);
        if (!Test.isRunningTest()) {
            httpResponse = getResponse(listParameters);
        } else {
            // Set the mock callout mode
            httpResponse = getResponse(listParameters);
        }

        Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
        List < Object > listInstallationAPI = (List < Object > ) resultAsMap.get('_data');
        if(listInstallationAPI.size()==0){
            return null;
        }
        List<InstallationsModel> listInstallations = transformDatatoListInstallation(listInstallationAPI);
        InstallationsModel installation = listInstallations.get(0);
        if(String.isBlank(installation.numeroInstallation)){
            return null;
        }
        return installation.idLocal;

}

    public static String buildRequestParams(Map<String,String> listParameters){
        String endpointParams = '';
        if(listParameters.size()>0){
            endpointParams +='?';
            Set<String> queryParamsKeys = listParameters.keySet();
            for(String key : queryParamsKeys){
                endpointParams+=key+'='+listParameters.get(key)+'&';
            }
            endpointParams = endpointParams.substring(0, endpointParams.length()-1);

        }
        return endpointParams;

}

    public static HttpResponse getResponse(Map<String,String> listParameters) {

        String endpointParams = buildRequestParams(listParameters);
        HttpResponse httpResp = CalloutManager.sendRequest('Installations', endpointParams, 'GET', CalloutManager.Scope.READ,null,null);
        if (CalloutManager.httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            return null;
        }

        return httpResp;

}

}