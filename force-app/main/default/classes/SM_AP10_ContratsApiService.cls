global class SM_AP10_ContratsApiService implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        if (methodName.equals('callContrats')) {
            try {
                callContrats(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug('Exception: ' + e);
                return false;
            }
        } else if (methodName.equals('callContratsActif')) {
            try {
                callContratsActif(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug('Exception: ' + e);
                return false;
            }
        } else if (methodName.equals('callContratswithId')) {
            try {
                callContratswithId(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug('Exception: ' + e);
                return false;
            }
        } else if (methodName.equals('callContratsSelfcare')) {
            try {
                callContratsSelfcare(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug('Exception: ' + e.getStackTraceString());
                return false;
            }
        }
        return true;
    }
    
    public static void callContrats(Map<String,Object> inputMap, Map<String,Object> outMap, Map <String,Object> options) {
        
        system.debug('@@ SM_AP10 inputMap ' +inputMap);
        
        if (inputMap.get('IdPortefeuilleContrat') == null || String.valueOf(inputMap.get('IdPortefeuilleContrat')).length() == 0) {
            system.debug('idPortefeuilleContrat is not found ...');
            return;
        }

        /*HttpResponse httpResponse = getResponse(token, (String) inputMap.get('IdPortefeuilleContrat'));*/
        HttpResponse httpResponse = getResponse(String.valueOf(inputMap.get('IdPortefeuilleContrat')), null);
        system.debug('@@ httpResponse '+httpResponse);
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
        system.debug('@@ resultAsMap '+resultAsMap);
        List<Object> contracts = (List <Object> ) resultAsMap.get('_data');
        system.debug('@@ contracts '+contracts);
        if (contracts.Size() == 0) {
            system.debug('No data to get the idPortefeuilleContrat ' + inputMap.get('IdPortefeuilleContrat'));
            //return;
            outMap.put('resultdata', new  List<Object>());
        }
       else{
            List<Object> transformedData = transformDataToCard(contracts) ;
            outMap.put('resultdata', transformedData);
            outMap.put('nombreRythmeFacturation',transformedData.size() == 1 ? 'OK' :'NOK' ) ;
    
            
        }
        system.debug('### MGH :: ' + outMap);
    }
    
    public static void callContratsSelfcare(Map<String,Object> inputMap, Map<String,Object> outMap, Map <String,Object> options) {
        
        system.debug('@@ SM_AP10 inputMap ' +inputMap);
        
        if (inputMap.get('idPersonne') == null || String.valueOf(inputMap.get('idPersonne')).length() == 0) {
            system.debug('IdPersonne is not found ...');
            return;
        }

        /*HttpResponse httpResponse = getResponse(token, (String) inputMap.get('IdPortefeuilleContrat'));*/
        HttpResponse httpResponse = getResponse(null, String.valueOf(inputMap.get('idPersonne')));
        system.debug('@@ httpResponse '+httpResponse);
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
        system.debug('@@ resultAsMap '+resultAsMap);
        List<Object> contracts = (List <Object> ) resultAsMap.get('_data');
        system.debug('@@ contracts '+contracts);
        if (contracts.Size() == 0) {
            system.debug('No data to get the idPersonne' + inputMap.get('idPersonne'));
            //return;
            outMap.put('resultdata', new  List<Object>());
        }
       else{
            Map<String, Set<String>> transformedData = transformDataPCEPDL(contracts) ;
            outMap.putAll(transformedData);
    
            
        }
        system.debug('### MGH :: ' + outMap);
    }
    

    public class ContratModel {
    
        @AuraEnabled
        public String idContrat;
        @AuraEnabled      
        public Integer idPortefeuilleContrat;
        @AuraEnabled        
        public String libelleOffre;
        @AuraEnabled
        public String typeContrat;   
        @AuraEnabled    
        public String uniteReleve;  
        @AuraEnabled    
        public String statut;    
        @AuraEnabled
        public String dateDebutContrat;  
        @AuraEnabled     
        public String dateFinContrat;
        @AuraEnabled      
        public String statutCard; 
        @AuraEnabled     
        public String statutCode; 
        @AuraEnabled     
        public String numeroPointDeLivraison; 
        @AuraEnabled       
        public String numeroContrat; 
        @AuraEnabled     
        public String numeroContratCRM;
        @AuraEnabled       
        public Boolean isLatestResil;
        @AuraEnabled       
        public String codeOffre;
        @AuraEnabled       
        public String dateDemenagementSouhaitee;
        @AuraEnabled       
        public String idPack;

        public ContratModel(Integer idPortefeuilleContrat, String libelleOffre, String typeContrat, String uniteReleve,
                                 String statut, String dateDebutContrat, 
                                String dateFinContrat,String statutCard,
                                String idContrat,Boolean isLatestResil) {
            this.idPortefeuilleContrat = idPortefeuilleContrat;
            this.libelleOffre = libelleOffre;
            this.typeContrat = typeContrat;
            this.uniteReleve = uniteReleve;
            this.statut = statut;
            if(!String.isBlank(dateDebutContrat)){
            Date dateDeb=Date.ValueOf(dateDebutContrat.substring(0, 10));
            this.dateDebutContrat=dateDeb.format();
            }
            if(!String.isBlank(dateFinContrat)){
            Date dateFin=Date.ValueOf(dateFinContrat.substring(0, 10));
            this.dateFinContrat=dateFin.format();
            }
            
            this.statutCard = statutCard;   
            this.idContrat=idContrat;
            this.isLatestResil=isLatestResil;       
           

        }
        public ContratModel(Integer idPortefeuilleContrat, String libelleOffre, String typeContrat, String uniteReleve,
                                 String statut, String dateDebutContrat, 
                                String dateFinContrat,String statutCard,
                                String idContrat,Boolean isLatestResil, 
                                String numeroPointDeLivraison, String idOffre,
                                String dateDemenagementSouhaitee, String idPack) {
            this(idPortefeuilleContrat, libelleOffre, typeContrat, uniteReleve, statut, dateDebutContrat, dateFinContrat, statutCard,idContrat,isLatestResil);            
            this.numeroPointDeLivraison = numeroPointDeLivraison;
            this.codeOffre = idOffre;
            this.idPack = idPack;
            if(!String.isBlank(dateDemenagementSouhaitee)){
                Date dateDem=Date.ValueOf(dateDemenagementSouhaitee.substring(0, 10));
                this.dateDemenagementSouhaitee=dateDem.format();
            }
        }

        public ContratModel(Integer idPortefeuilleContrat, String libelleOffre, String typeContrat, String uniteReleve, String statut, String dateDebutContrat, 
                            String dateFinContrat, String statutCard, String numeroPointDeLivraison, String numeroContrat, String numeroContratCRM) {
            this(idPortefeuilleContrat, libelleOffre, typeContrat, uniteReleve, statut, dateDebutContrat, dateFinContrat, statutCard,null,false);
            this.numeroPointDeLivraison = numeroPointDeLivraison;
            this.numeroContrat = numeroContrat;
            this.numeroContratCRM= numeroContratCRM;
            
        }
       
        
    }

    public static List<Object> transformDataToCard(List<Object> apiData) {
        List<Object> listTemp = new List <Object>();
        for (Object obj : apiData) {
            Map <String,Object> objectX = (Map <String, Object>) obj;
        //   if((String) objectX.get('statutComposante') == 'ACTIF')
            String dateDebut = (objectX.get('dateDebutContrat') == null) ? '' : (String) objectX.get('dateDebutContrat');
            String dateFin = (objectX.get('dateFinContrat') == null) ? '' : (String) objectX.get('dateFinContrat');
            
            String getStatut = (String) objectX.get('statutComposante');
            String getType = (String) objectX.get('typeContrat');
            
            String getStatutCard =  getType+getStatut;
          
            
            listTemp.add(new ContratModel((Integer) objectX.get('idPortefeuilleContrat'), (String) objectX.get('libelleOffre'), (String) objectX.get('typeContrat'), (String) objectX.get('uniteReleve'), (String) objectX.get('statutComposante'), dateDebut, dateFin,getStatutCard,null,false));
        }
        system.debug('@@ listTemp ' +listTemp);
        return listTemp;
    }
    
    public static Map<String, Set<String>> transformDataPCEPDL(List<Object> apiData) {
        Map<String, Set<String>> results = new Map<String, Set<String>>();
        Set<String> gaz = new Set<String>();
        Set<String> elec = new Set<String>();
        
        for (Object obj : apiData) {
            Map <String,Object> objectX = (Map <String, Object>) obj;
     
            String numPoint = (String) objectX.get('numeroPointDeLivraison');
            String secteur = (String) objectX.get('typeContrat');
            
            if(!String.isBlank(secteur) && secteur.startsWith('G') && !gaz.contains(numPoint)){
                gaz.add(numPoint);
            } else if(!String.isBlank(secteur) && secteur.startsWith('E') && !elec.contains(numPoint)){
                elec.add(numPoint);
            }
            
            
            System.debug('*** ' + secteur + ' : ' + numPoint);
        }
        
        results.put('gaz', gaz);
        results.put('elec', elec);
        
        return results;
    }

    public static String buildRequestParams(String idPortefeuilleContrat, String idPersonne) {
        String endpointParams='';
        if(!String.isBlank(idPortefeuilleContrat)){
            endpointParams += '?idPortefeuilleContrat=' + idPortefeuilleContrat;
        } else if (!String.isBlank(idPersonne)){
            endpointParams += '?idPersonne=' + idPersonne;
        }
        
        return endpointParams;
    }

    public static HttpResponse getResponse(String idBusinessPartner, String idPersonne) {
        String endpointParams = buildRequestParams(idBusinessPartner, idPersonne);
        HttpResponse httpResp = CalloutManager.sendRequest('Contrat', endpointParams, 'GET', CalloutManager.Scope.READ,null,null);
        if (CalloutManager.httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('## [Contrats] error occured when sending data ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            return null;
        }
        return httpResp;
    }
    
    
    
    /* OS-Meter Reading ==> Contract Elec & Gaz */

    public static List<Object> transformContratElec(List<Object> apiData) {
        List<Object> listTemp = new List <Object>();
        for (Object obj : apiData) {
            Map <String, Object> objectX = (Map <String, Object>) obj;
            String statut = (String) objectX.get('statutComposante');
            String typeC  = (String) objectX.get('typeContrat');
            if(String.isNotEmpty(typeC) && typeC.substring(0, 1) == 'E' && statut == 'Actif') {
                String dateDebut = (objectX.get('dateDebutContrat') == null) ? '' : (String) objectX.get('dateDebutContrat');
                String dateFin   = (objectX.get('dateFinContrat') == null) ? '' : (String) objectX.get('dateFinContrat');
                String statutCard =  typeC + statut;
                listTemp.add(new ContratModel((Integer) objectX.get('idPortefeuilleContrat'), (String) objectX.get('libelleOffre'), (String) objectX.get('typeContrat'), (String) objectX.get('uniteReleve'), (String) objectX.get('statutComposante'), dateDebut, dateFin, statutCard, (String) objectX.get('numeroPointDeLivraison'), (String) objectX.get('numeroContrat'), (String) objectX.get('numeroContratCRM')));
            }
        }
        return listTemp;
    }
    
    public static List<Object> transformContratGaz(List<Object> apiData) {
        List<Object> listTemp = new List <Object>();
        for (Object obj : apiData) {
            System.debug('Boucle XXXXXXXXXXXXXXXXXXXXXXX');

            Map <String, Object> objectX = (Map <String, Object>) obj;
            System.debug(objectX);
            String statut = (String) objectX.get('statutComposante');
            String typeC  = (String) objectX.get('typeContrat');
            System.debug(statut);
            System.debug(typeC);
            if(String.isNotEmpty(typeC) && typeC.substring(0, 1) == 'G' && statut == 'Actif') {
                String dateDebut = (objectX.get('dateDebutContrat') == null) ? '' : (String) objectX.get('dateDebutContrat');
                String dateFin   = (objectX.get('dateFinContrat') == null) ? '' : (String) objectX.get('dateFinContrat');
                String statutCard =  typeC + statut;
                listTemp.add(new ContratModel((Integer) objectX.get('idPortefeuilleContrat'), (String) objectX.get('libelleOffre'), (String) objectX.get('typeContrat'), (String) objectX.get('uniteReleve'), (String) objectX.get('statutComposante'), dateDebut, dateFin, statutCard, (String) objectX.get('numeroPointDeLivraison'), (String) objectX.get('numeroContrat'), (String) objectX.get('numeroContratCRM')));
            }
        }
        return listTemp;
    }

    public static Map<String, Object> transformContratwithIdContratGaz(List<Object> apiData, String idContrat) {
        Map<String, Object> listTemp = new Map<String, Object>();
        for (Object obj : apiData) {

            Map <String, Object> objectX = (Map <String, Object>) obj;
            System.debug(objectX);
            System.debug(idContrat);
            System.debug(objectX.get('numeroContratCRM'));
            if(idContrat.equals(objectX.get('numeroContratCRM'))) {
                String dateDebut = (objectX.get('dateDebutContrat') == null) ? '' : (String) objectX.get('dateDebutContrat');
                String dateFin   = (objectX.get('dateFinContrat') == null) ? '' : (String) objectX.get('dateFinContrat');
                listTemp.put('Gaz',new ContratModel((Integer) objectX.get('idPortefeuilleContrat'), (String) objectX.get('libelleOffre'), (String) objectX.get('typeContrat'), (String) objectX.get('uniteReleve'), (String) objectX.get('statutComposante'), dateDebut, dateFin, '', (String) objectX.get('numeroPointDeLivraison'), (String) objectX.get('numeroContrat'), (String) objectX.get('numeroContratCRM')));
            }
        }
        return listTemp;
    }
    
    
    public static void callContratsActif(Map<String,Object> inputMap, Map<String,Object> outMap, Map <String,Object> options) {
        System.debug('----------->' + inputMap.get('IdPortefeuilleContrat'));
        if (inputMap.get('IdPortefeuilleContrat') == null || String.valueOf(inputMap.get('IdPortefeuilleContrat')).length() == 0) {
            System.debug('idPortefeuilleContrat is not found ...');
            return;
        }
        
        HttpResponse httpResponse = getResponse(String.valueOf(inputMap.get('IdPortefeuilleContrat')), null);        
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
        List<Object> contracts = (List <Object> ) resultAsMap.get('_data');
        if (contracts.Size() == 0) {
            System.debug('No data to get the idPortefeuilleContrat ' + inputMap.get('IdPortefeuilleContrat'));
            outMap.put('resultdataElec', new  List<Object>());
            outMap.put('resultdataGaz', new  List<Object>());
        }
       else {
            putContractInOutMap(contracts, outMap);
        }
    }

    public static void callContratswithId(Map<String,Object> inputMap, Map<String,Object> outMap, Map <String,Object> options) {
        System.debug('----------->' + inputMap.get('IdPortefeuilleContrat'));
        if (inputMap.get('IdPortefeuilleContrat') == null || String.valueOf(inputMap.get('IdPortefeuilleContrat')).length() == 0) {
            System.debug('idPortefeuilleContrat is not found ...');
            return;
        }
        System.debug('----------->' + inputMap.get('idContrat'));
        if (inputMap.get('idContrat') == null || String.valueOf(inputMap.get('idContrat')).length() == 0) {
            System.debug('idContrat is not found ...');
            return;
        }
        
        HttpResponse httpResponse = getResponse(String.valueOf(inputMap.get('IdPortefeuilleContrat')), null);        
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
        List<Object> contracts = (List <Object> ) resultAsMap.get('_data');
        if (contracts.Size() == 0) {
            System.debug('No data to get the idPortefeuilleContrat ' + inputMap.get('IdPortefeuilleContrat'));
            outMap.put('resultdataGaz', new  List<Object>());
        }
       else {
            putContractwithIdInOutMap(contracts, outMap, String.valueOf(inputMap.get('idContrat')));
        }
    }

    public static void putContractwithIdInOutMap(List<Object> contracts, Map<String,Object> outMap, String idContrat) {
        Map<String,Object> transformedDataGaz  = transformContratwithIdContratGaz(contracts, idContrat) ;
        outMap.put('resultdataGaz', transformedDataGaz);
        System.debug('outputMap'+outMap);
        
    }

    public static void putContractInOutMap(List<Object> contracts, Map<String,Object> outMap) {
        List<Object> transformedDataElec = transformContratElec(contracts);
        List<Object> transformedDataGaz  = transformContratGaz(contracts) ;
        outMap.put('resultdataElec', transformedDataElec);
        outMap.put('resultdataGaz', transformedDataGaz);
        outMap.put('nombreRythmeFacturation', (transformedDataElec.size()>1 || transformedDataGaz.size()>1) ? 'NOK' :'OK');
        if(transformedDataElec.size() == 1 && transformedDataGaz.size() == 1)
             outMap.put('typeContratApi', 'Bi-energie');
        else if(transformedDataElec.size() == 1)
             outMap.put('typeContratApi', 'Elec');
        else if(transformedDataGaz.size() == 1)
             outMap.put('typeContratApi', 'Gaz');
        else 
             outMap.put('typeContratApi', 'KO');
        
        System.debug('outputMap'+outMap);
        
    }
}