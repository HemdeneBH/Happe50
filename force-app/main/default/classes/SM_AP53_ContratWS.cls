/*
*   @description : Classe qui gère les différents appels au WS Contrat
*   @author : Mickael
*   @sprint : 22, 23
*/

global with sharing class SM_AP53_ContratWS implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        if (methodName.equals('rechercherContrat')) {
            try {
                rechercherContrat(inputMap, outMap, options);
              } catch (Exception e) {
                system.debug(e.getStackTraceString());
                return false;
            }            
        }
        return true;
    }

    /*
    *   @description : effectue l'appel à la méthode rechercherContrat. Le traitement est effectué dans les méthodes suivantes.
    */
    public static gdfsuezComBefChpPivotContrat.contextDt initContext(String application, String version){
         // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        gdfsuezComBefChpPivotContrat.contextDt_systemPath_system_element osource = new gdfsuezComBefChpPivotContrat.contextDt_systemPath_system_element();
        osource.systemId=application;
        gdfsuezComBefChpPivotContrat.contextDt octx = new gdfsuezComBefChpPivotContrat.contextDt();
        octx.version=version;
      //  octx.allowCache = false ;
        octx.systemPath = new gdfsuezComBefChpPivotContrat.contextDt_systemPath_element();
        octx.systemPath.system_x = new gdfsuezComBefChpPivotContrat.contextDt_systemPath_system_element[]{osource};
        return octx;
    }

    @AuraEnabled(cacheable=true)
    public static void rechercherContrat(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options){      
        System.debug('**** IN AP53 rechercherContrat');
        System.debug('*** Input params : ' + inputMap);
        
       
        String idBp = inputMap != null ? String.valueOf(inputMap.get('idBp')) : null;
        String origineAppel = inputMap != null ? (String) inputMap.get('origineAppel') : null; 
        String typeEnergie = inputMap != null ? (String) inputMap.get('typeEnergie') : null; 
        String idPortefeuilleContrat = inputMap != null && inputMap.containsKey('NoCompteClient') ? (String) inputMap.get('NoCompteClient') : null;
        System.debug('**** idPortefeuilleContrat : ' + idPortefeuilleContrat);
       
        system.debug('idBp ' +inputMap.get('idBp'));
        if(String.isBlank(idBp)){
            System.debug('*** idBp is mandatory');
            return ;
        }

        gdfsuezComBefChpPivotContrat.contextDt octx = initContext('Smile', '2.0'); 

        gdfsuezBefCalypsoContratV7.Dependency port = new gdfsuezBefCalypsoContratV7.Dependency() ;  
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();   
        port.clientCertName_x = octopusCS.certName__c;
        port.endpoint_x =  octopusCS.endpoint__c+'ES-Contrat_v7';
        System.debug('*** endpoint : ' + port.endpoint_x);
        port.inputHttpHeaders_x = new Map<String, String>{'Content-Type' => 'text/xml;charset=utf-8'}; 

        gdfsuezBefCalypsoContratV7.rechercherContratInputDt input = new gdfsuezBefCalypsoContratV7.rechercherContratInputDt();
        input.idPersonne = idBp;

        input.searchControlRequest = new gdfsuezComBefChpPivotContrat.searchControlRequestHeaderDt();
        input.searchControlRequest.pagination = new gdfsuezComBefChpPivotContrat.searchControlRequestDt();
        input.searchControlRequest.pagination.offset = '999';
        input.searchControlRequest.pagination.from_x = '0';

        gdfsuezBefCalypsoContratV7.rechercherContratResponse_element response ; 
        
        if(!Test.isRunningTest()){
            response  = port.RechercherContrat_Http(input,octx);
        }else {
            Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoContratHttpMock());
            gdfsuezBefCalypsoContratV7.Dependency porttest = new gdfsuezBefCalypsoContratV7.Dependency();
            system.debug('@@ start of mock');
            response = porttest.RechercherContrat_Http(input, octx);
            system.debug('@@ end of mock');
        }
        
        if(response != null && response.rechercherContratOutput != null && response.rechercherContratOutput.contrat != null){
            if(!String.isBlank(origineAppel) && origineAppel == 'Vue360'){
                List<Object> transformedData = transformDataVue360(response.rechercherContratOutput.contrat, typeEnergie, idPortefeuilleContrat, false);
                outMap.put('resultdata', transformedData);
                outMap.put('nombreRythmeFacturation',transformedData.size() == 1 ? 'OK' :'NOK' ) ;
            } else{
                outMap.putAll(transformDataSelfcare(response.rechercherContratOutput.contrat));
            }
        }

        if(response != null && response.messageRetours != null && response.messageRetours.retourTraitementMessage != null && response.messageRetours.retourTraitementMessage[0] != null){
            outMap.put('rechercheContratRet', response.messageRetours.retourTraitementMessage[0].code);
        }
        
        System.debug('*** : ' + outMap);
    }
    @AuraEnabled(cacheable=false)
    public static Map < String, Object > rechercherContratLightning(Map < String, Object > inputMap){      
        System.debug('**** IN AP53 rechercherContratLightning');
        System.debug('*** Input params : ' + inputMap);
        Map < String, Object > outMap  = new Map<String, Object>();
        // List<Object> transformedData;
        String idBp = inputMap != null ? String.valueOf(inputMap.get('idBp')) : null;
        String origineAppel = inputMap != null ? (String) inputMap.get('origineAppel') : null; 
        // String typeEnergie = inputMap != null ? (String) inputMap.get('typeEnergie') : null; 
        // String idPortefeuilleContrat = inputMap != null && inputMap.containsKey('NoCompteClient') ? (String) inputMap.get('NoCompteClient') : null;
        // System.debug('**** idPortefeuilleContrat : ' + idPortefeuilleContrat);
       
        system.debug('idBp ' +inputMap.get('idBp'));
        if(String.isBlank(idBp)){
            System.debug('*** idBp is mandatory');
            return null;
        }
        gdfsuezComBefChpPivotContrat.contextDt octx = initContext('Smile', '2.0'); 
        gdfsuezBefCalypsoContratV7.Dependency port = new gdfsuezBefCalypsoContratV7.Dependency() ;  
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();   
        port.clientCertName_x = octopusCS.certName__c;
        port.endpoint_x =  octopusCS.endpoint__c+'ES-Contrat_v7';
        System.debug('*** endpoint : ' + port.endpoint_x);
        port.inputHttpHeaders_x = new Map<String, String>{'Content-Type' => 'text/xml;charset=utf-8'}; 
        gdfsuezBefCalypsoContratV7.rechercherContratInputDt input = new gdfsuezBefCalypsoContratV7.rechercherContratInputDt();
        input.idPersonne = idBp;
        input.searchControlRequest = new gdfsuezComBefChpPivotContrat.searchControlRequestHeaderDt();
        input.searchControlRequest.pagination = new gdfsuezComBefChpPivotContrat.searchControlRequestDt();
        input.searchControlRequest.pagination.offset = '999';
        input.searchControlRequest.pagination.from_x = '0';
        gdfsuezBefCalypsoContratV7.rechercherContratResponse_element response ; 
        
        if(!Test.isRunningTest()){
            response  = port.RechercherContrat_Http(input,octx);
        }else {
            Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoContratHttpMock());
            gdfsuezBefCalypsoContratV7.Dependency porttest = new gdfsuezBefCalypsoContratV7.Dependency();
            system.debug('@@ start of mock');
            response = porttest.RechercherContrat_Http(input, octx);
            system.debug('@@ end of mock');
        }
        
        if(response != null && response.rechercherContratOutput != null && response.rechercherContratOutput.contrat != null){
            if(!String.isBlank(origineAppel) && origineAppel == 'Vue360'){
                system.debug('@@ response octopus..');
                system.debug(response);
                List<Object> transformedData = transformDataVue360(response.rechercherContratOutput.contrat, null, null, true);
                outMap.put('resultdata', transformedData);
                outMap.put('nombreRythmeFacturation',transformedData.size() == 1 ? 'OK' :'NOK' ) ;
            } else{
                outMap.putAll(transformDataSelfcare(response.rechercherContratOutput.contrat));
            }
        }
        if(response != null && response.messageRetours != null && response.messageRetours.retourTraitementMessage != null && response.messageRetours.retourTraitementMessage[0] != null){
            outMap.put('rechercheContratRet', response.messageRetours.retourTraitementMessage[0].code);
        }
        
        System.debug('*** : ' + outMap);
        return outMap;
    }
    




    /*
    *    @description : Cette méthode est destinée à la transformation du retour du WS pour utilisation sur le selfcare
    */
    public static Map<String, Set<String>> transformDataSelfcare(List<gdfsuezComBefCalypsoContrat.Contrat> contrats) {
        System.debug('*** IN : transformDataSelfcare');
        Map<String, Set<String>> results = new Map<String, Set<String>>();
        Set<String> gaz = new Set<String>();
        Set<String> elec = new Set<String>();
        
        for (gdfsuezComBefCalypsoContrat.Contrat contrat : contrats) {
            for(gdfsuezComBefCalypsoContrat.Contrat_composanteContrat_element comp : contrat.composanteContrat){
                String secteur = comp.secteurActivite != null ? comp.secteurActivite.code : null;
                String numPoint = comp.PDL != null ? comp.PDL.idPdl : null;

                if(!String.isBlank(secteur) && (secteur == '5G' || secteur == '5P') && !gaz.contains(numPoint)){
                    gaz.add(numPoint);
                } else if(!String.isBlank(secteur) && secteur == '5E' && !elec.contains(numPoint)){
                    elec.add(numPoint);
                }
            }    
        }
        
        results.put('gaz', gaz);
        results.put('elec', elec);
        
        return results;
    }
    
    /*
    *    @description : Cette méthode est destinée à la transformation du retour du WS pour utilisation sur la vue 360
    *    Cf. US SMIL-1624
    */
    public static List<Object> transformDataVue360(List<gdfsuezComBefCalypsoContrat.Contrat> contrats, String typeEnergieCard, String idPortefeuilleContrat, Boolean AllContrat) {
        System.debug('*** IN :  transformDataVue360');
        System.debug('*** Contrats  : ' + contrats);
        List<SM_AP10_ContratsApiService.ContratModel> results = new List<SM_AP10_ContratsApiService.ContratModel>();
        //List<SM_AP10_ContratsApiService.ContratModel> resultsResil = new List<SM_AP10_ContratsApiService.ContratModel>();
        Map<Integer,SM_AP10_ContratsApiService.ContratModel> resultsResilMapElec = new  Map<Integer,SM_AP10_ContratsApiService.ContratModel>() ;
        Map<Integer,SM_AP10_ContratsApiService.ContratModel> resultsResilMapGaz = new  Map<Integer,SM_AP10_ContratsApiService.ContratModel>() ;
                // Construction d'une table de transco entre product code et product name
        Map<String, String> productsCodes = new Map<String, String>();

        for(Product2 aProduct : [SELECT Id, Name, ProductCode FROM Product2]){
            productsCodes.put(aProduct.ProductCode, aProduct.Name);
        }

        Boolean bFoundE = false;
        Boolean bFoundG = false;

        for(gdfsuezComBefCalypsoContrat.Contrat aContrat : contrats){
            String idOffre, idCompteClient, statut, statutCard, typeEnergie, numPoint, numContrat, idContrat, uniteReleve, statutLibelle;
            Datetime dateDebut, dateFin, dateDemenagementSouhaitee;
            Integer diffAujEtDateFin=999999999;
            
            idContrat = aContrat.idContrat;
            dateDemenagementSouhaitee = aContrat.dateDemenagementSouhaitee;
            if(aContrat.compteClient != null){
                idCompteClient = aContrat.compteClient[0].idCompteClient;
            }

            if(aContrat.composanteContrat != null){
                Date DateRef =System.today();
                for(gdfsuezComBefCalypsoContrat.Contrat_composanteContrat_element aPartContrat : aContrat.composanteContrat){
                    uniteReleve = aPartContrat.uniteReleve;
                    System.debug('*** uniteReleve');
                    System.debug(uniteReleve);
                    numContrat = aPartContrat.numContratISU;

                    
                    
                    System.debug('*** aPartContrat.PDL');
                    System.debug(aPartContrat.PDL);

                    if(aPartContrat.PDL != null){
                        numPoint = aPartContrat.PDL.idPDL;
                        System.debug('*** aPartContrat.PDL.idPDL');
                        System.debug(aPartContrat.PDL.idPDL);
                    }

                    if(aPartContrat.historiqueComposante != null){
                        gdfsuezComBefCalypsoContrat.Contrat_composanteContrat_historiqueComposante_element historique = aPartContrat.historiqueComposante[0];
                        System.debug('*** historique');
                        System.debug(historique);
                        dateDebut = historique.dateDebutContrat;
                        dateFin = historique.dateFinContrat;
                        
                        if(dateFin!=null){     
                            Date dateFinFormatDate=Date.valueOf(dateFin)   ;                    
                            diffAujEtDateFin=dateFinFormatDate.daysBetween(DateRef);
                        }
                    
                        idOffre = historique.offre != null ? historique.offre.idOffre : null;
                        statut = historique.statutComposante != null ? historique.statutComposante.code : null;
                        statutLibelle = historique.statutComposante != null ? historique.statutComposante.libelleCourt : null;
                        System.debug(historique);
                    }

                    if(aPartContrat.secteurActivite != null){
                        typeEnergie = aPartContrat.secteurActivite.code;
                        typeEnergie = (typeEnergie == '5E') ? 'E' : (typeEnergie == '5G' || typeEnergie == '5P') ? 'GN' : (typeEnergie == '5S') ? 'S' : '';
                    }

                    statutCard = typeEnergie + statutLibelle;

                    System.debug(typeEnergieCard + ' - ' + typeEnergie);
                    System.debug(statut);
                    System.debug('*** idCompteClient : ' + idCompteClient + '/' + idPortefeuilleContrat); 
                    if((idPortefeuilleContrat == idCompteClient || AllContrat) && (String.isBlank(typeEnergieCard ) || typeEnergieCard == typeEnergie) && (statut == 'E0001' || statut == 'E0003' || statut == 'E0004' || statut == 'E0005' || statut == 'E0006' || statut == 'E0007' || statut == 'E0008' || statut == 'E0009')){
                        SM_AP10_ContratsApiService.ContratModel contratObj = new SM_AP10_ContratsApiService.ContratModel(Integer.valueOf(idCompteClient), productsCodes.get(idOffre), typeEnergie, uniteReleve, statutLibelle, String.valueOfGmt(dateDebut), String.valueOfGmt(dateFin),statutCard,idContrat,false, numPoint, idOffre, String.valueOfGmt(dateDemenagementSouhaitee) );
                        System.debug('idOffre');                        
                        System.debug(idOffre);
                        System.debug(productsCodes.get(idOffre));

                        contratObj.statutCode = statut;
                     
                        // On ne peut avoir qu'un contrat non résilié retourné par le WS par energie
                        if(statut != 'E0009' && (!bFoundE || AllContrat) && typeEnergie=='E'){
                            System.debug('*** Ajout non résilié : ' + contratObj);
                            results.add(contratObj);
                            bFoundE = true;
                        }else if(statut != 'E0009' && (!bFoundG || AllContrat) && typeEnergie=='GN'){
                            System.debug('*** Ajout non résilié : ' + contratObj);
                            results.add(contratObj);
                            bFoundG = true;
                        } else if (statut == 'E0009' && typeEnergie=='E') {
                            System.debug('*** Ajout résilié elec : ' + contratObj);
                            resultsResilMapElec.put(diffAujEtDateFin,contratObj);
                        } else if (statut == 'E0009' && typeEnergie=='GN') {
                            System.debug('*** Ajout résilié gaz: ' + contratObj);
                            resultsResilMapGaz.put(diffAujEtDateFin,contratObj);
                        } else if (AllContrat && typeEnergie =='S' && (statut == 'E0004' || statut == 'E0009')) {
                            results.add(contratObj);                            
                        }
                    }

                }
            }
            
        }
        List<SM_AP10_ContratsApiService.ContratModel> resilElecs=sortContratResilie(resultsResilMapElec);
        List<SM_AP10_ContratsApiService.ContratModel> resilGazs=sortContratResilie(resultsResilMapGaz);
        results.addAll(resilElecs);
        results.addAll(resilGazs);
        return results;
    }
    public static List<SM_AP10_ContratsApiService.ContratModel> sortContratResilie(Map<Integer,SM_AP10_ContratsApiService.ContratModel> resultsResilMap){
        List<SM_AP10_ContratsApiService.ContratModel> results = new List<SM_AP10_ContratsApiService.ContratModel>();
        system.debug('@@ resultsResilMap '+resultsResilMap);
        List<Integer> keyList = new List<Integer>(resultsResilMap.keySet());
        keyList.sort();
        for(Integer i = 0; i < resultsResilMap.size(); i++){
            Integer key=keyList[i];
            SM_AP10_ContratsApiService.ContratModel contratObj=resultsResilMap.get(key);
            
            if(i==0){
                contratObj.isLatestResil=true;
            }
            else{
                 contratObj.isLatestResil=false;
            }
            
            results.add(contratObj)  ;        
        }
        return results;
    }

  
}