/*author: RWA
*description: Appel de l'API REST Adresse
*CreatedDate: 26/07/2018
*LastModified: MHA 07/12/2018
*/

global class SM_AP07_AdressesApiService_ref implements vlocity_cmt.VlocityOpenInterface {
    
    
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        System.debug('*** methodName : ' + methodName);
        if (methodName.equals('searchAddress')) {
            try {
                searchAddress(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug(e);
                system.debug(e.getLineNumber());
                return false;
            }
        } else if (methodName.equals('searchAddressById')) {
            try {
                searchAddressById(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug(e);
                return false;
            }
        } else if (methodName.equals('getAddressById')) {
            try {
                getAddressById(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug(e);
                return false;
            }
        }  else if (methodName.equals('searchAddressSelfcare')) {
            try {
                searchAddressSelfcare(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug(e.getStackTraceString());
                return false;
            }
        }
        return true;
    }
    
    /*author: RWA
*Description
*createdDate: 26/07/2018
*LastModified MHA 07/12/2018
*/
    public static String getIdBanIfSameAddr(String addrComplete) {
        System.debug('@MHA Addr =>' + addrComplete);
        String IdBAN;
        String endpointURL = '';
        HttpRequest req = new HttpRequest();
        //addrComplete = addrComplete.replace(' ', '+');
        //utiliser urlEncode pour gerer les accents 
        //sinon la recherche dadresse ne ramene pas de resultats
        addrComplete = EncodingUtil.URLENCODE(addrComplete,'UTF-8');
        String api = 'SearchAdresse';
        SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername =: api limit 1];
        endpointURL = 'callout:APIAdresseGouv' + suffixs.suffix__c;
        req.setEndpoint(endpointURL + addrComplete);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        if (!Test.isRunningTest()) {
            res = http.send(req);
        } else {
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SM_MockResponseSearchAddrGouv');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            // Set the mock callout mode
            Test.setMock(HttpCalloutMock.class, mock);
            res = http.send(req);
        }
        System.debug('@@ response ' + res.getBody());
        Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(res.getBody());
        Map < String, Object > propertiesMap = new Map < String, Object >();
        List < Object > resultAsMapFeatures;
        if (resultAsMap.get('features') != null) {
            resultAsMapFeatures = (List <  Object > ) resultAsMap.get('features');
            
            for (Object feature : resultAsMapFeatures) {
                Map<String, Object> newCast = (Map<String, Object>)feature;
                if (newCast.get('properties') != null) {
                    propertiesMap = (Map<String, Object>)  newCast.get('properties');
                    break;
                }
            }
        }
        if (propertiesMap != null) {
            IdBAN = (String) propertiesMap.get('id');
            system.debug('@@IdBAN ' + IdBAN);
        }
        return IdBAN;
    }
    
    public class addressUnicityWrp{
        String idPdl;
        String idPce;
        public Boolean equals(Object obj) {
            if (obj instanceof addressUnicityWrp) {
                addressUnicityWrp addr = (addressUnicityWrp)obj;
                return ((idPdl==addr.idPdl) && (idPce==addr.idPce));
            }
            return false;
        }
        public Integer hashCode() {
            return idPdl.length() * idPce.length();
        } 
    }
    /*author: Guy Joel
*Description to remove duplicates adresses
*createdDate: 22/10/2019
*/
    public static list<Object> removeDuplicatesAdress(list<Object> listAdress){
        //list<Object> listAddressRes = new list<Object>();
        map<addressUnicityWrp,Object> mapAdress = new map<addressUnicityWrp,Object>();
		
        for(Object obj : listAdress){
			String pdlvalue = '';
		    String pcevalue = '';
            addressUnicityWrp addWrp = new addressUnicityWrp();
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
    
    /*author: RWA
*Description
*createdDate: 26/07/2018
*LastModified OMH 06/05/2019
*/
    public static void searchAddress(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        String selectedPDLVal = String.valueOf(inputMap.get('selectedPDLVal'));
        String selectedPCEVal = String.valueOf(inputMap.get('selectedPCEVal'));
        String vAddr = (String) inputMap.get('searchAddr');
        String vIsBillingAddressSameAsLiving, vSearchPCE, vSearchPDL;
        vIsBillingAddressSameAsLiving = (String) inputMap.get('isBillingAddressSameAsLiving');
        
        vSearchPCE = (String) inputMap.get('selectedPCE');
        system.debug('@@ vSearchPCE ' + vSearchPCE);
        vSearchPDL = (String) inputMap.get('selectedPDL');
        system.debug('@@ vSearchPDL ' + vSearchPDL);
        
        String vSearchAddrId;
        //system.debug('OUI'.equalsIgnoreCase(vIsBillingAddressSameAsLiving));
        if ('OUI'.equalsIgnoreCase(vIsBillingAddressSameAsLiving) ) {
            vSearchAddrId = getIdBanIfSameAddr(vAddr);
        } else {
            vSearchAddrId = (String) inputMap.get('idAddr');
        }
        
        
        String reqParams = '?';
        /* rechercher par les PDL, PCE en priorit??  ar plus precis */
        if (!String.isBlank(vSearchPDL)) {
            reqParams = reqParams + 'idPointDeLivraison=' + vSearchPDL;
        } else if (!String.isBlank(vSearchPCE)) {
            reqParams = reqParams + 'idPointDeComptage=' + vSearchPCE;
        } else if (!String.isBlank(vSearchAddrId)) {
            reqParams = reqParams + 'idBAN=' + vSearchAddrId+'&size=50';
        }
        else {
            system.debug('@@ there is no PDL,no PCE, no idBAN for address ' );
            return ;
        }
       
        HttpResponse httpResponse = new HttpResponse();
        Map < String, Object > resultAsMap = new Map<String,Object>();
        List < Object > listAdresses = new List<Object>();
        
        if(reqParams.contains('idBAN')){
            List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
            
            Map < String, Object > searchNext = new  Map < String, Object >();
            Integer page = 0;
            do{
                if(!Test.isRunningTest()) {
                    httpResponse = getResponse(reqParams+'&page='+page);
                }
                else if(Test.isRunningTest()){
                    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
                    mock.setStaticResource('SM_MockResponseGetAddr');
                    mock.setStatusCode(200);
                    mock.setHeader('Content-Type', 'application/json');
                    // Set the mock callout mode
                    Test.setMock(HttpCalloutMock.class, mock);
                    httpResponse = getResponse('?idBAN=ADRNIVX_0000000331881839');
                }
                system.debug('response' + httpResponse );
                if(httpResponse != null ){ 
                    resultAsMap  = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
                    if(page > 0 ){
                        listAdresses.addall((List<object>)resultAsMap.get('_data'));
                    }
                    else{
                        listAdresses= (List<object>)resultAsMap.get('_data');
                    }
                    system.debug('listAdresses ' +listAdresses);
                    searchNext.clear();
                    system.debug('_pagination' +resultAsMap.get('_pagination'));
                    
                    if(resultAsMap.get('_pagination') != null){
                        searchNext = (Map < String, Object >) resultAsMap.get('_pagination');
                        searchNext.put('pagination',resultAsMap.get('_pagination'));
                    }
                    
                    system.debug('searchNext'+searchNext);
                    system.debug('pageSuivante'+searchNext.containsKey('pageSuivante'));
                    system.debug('listaddress' + listAdresses.size());
                }
                page=page+1;
            }while(searchNext.containsKey('pageSuivante'));
        }
        else{
            if(!Test.isRunningTest()) {
                httpResponse = getResponse(reqParams);
            }
            else if(Test.isRunningTest()){
                StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
                mock.setStaticResource('SM_MockResponseGetAddr');
                mock.setStatusCode(200);
                mock.setHeader('Content-Type', 'application/json');
                // Set the mock callout mode
                Test.setMock(HttpCalloutMock.class, mock);
                httpResponse = getResponse('?idBAN=ADRNIVX_0000000331881839');
            }
        }
        
        if(!reqParams.contains('idBAN')){
            system.debug('no idban search');
            resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
            //Dans le cas de la recherche PDL ou PCE suite au passage de l'api normal a lapi spec
            // il est possible d'avoir deux resultats. vu avec XDATA prendre la premiere ligne.
            List < Object >  listTemp=(List < Object >) resultAsMap.get('_data');
            if(listTemp!=null && listTemp.size()>0){
                listAdresses.add(listTemp[0]);
                
            }else{
                listAdresses=(List < Object >) resultAsMap.get('_data');
            }
            
            
        }
        // HttpResponse httpResponse= getResponse(token, reqParams);
        System.debug('*** Out : ' + httpResponse.getBody());
        system.debug('listaddress' + listAdresses.size());
        
        if (listAdresses.Size() == 0) {
            system.debug('@@ no addresses found for ' + reqParams);
            outMap.put('data','error');
            return;
        }
        
        system.debug('### add0 '+listAdresses[0]);
        // methode qui transforme les donn??es retourn??es par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript
        //Map<String, Object> transformedData =  transformDatatoOmniscript(listAdresses, true);
        Map<String, Object> transformedData =  transformDatatoOmniscript(removeDuplicatesAdress(listAdresses), true);
        
        system.debug('@@ transformedData: ' + transformedData);
        if (outMap == null) {
            outMap = new Map < String, Object >();
        }
        
        outMap.put('data', transformedData);
        System.debug('### aka selectedPDLVal ' + selectedPDLVal);
        System.debug('### aka selectedPCEVal ' + selectedPCEVal);
        if((!String.isBlank(selectedPDLVal) && selectedPDLVal != 'false') 
           || (!String.isBlank(selectedPCEVal) && selectedPCEVal != 'false')
           || (String.isBlank(selectedPDLVal) && String.isBlank(selectedPCEVal))) {
               outMap.put('firstTimeRecherchePDL', 'true');	
           }
        
        
        
        
        system.debug('@@ outMap: ' + outMap);
        
    }
    
    /*author: RWA
*Description: Model du retour de l'aderesse
*createdDate: 26/07/2018
*LastModified MHA 07/12/2018
*/
    public class AdresseModel {
        public String valueChb;
        public PdlPceModel pointLivraison;
        public String citycode;
        public String postcode;
        public String complementAdresse;
        public String noVoie;
        public String libelleVoie;
        public String ville;
        public String idBan;
        
        public AdresseModel(String valueChb, PdlPceModel pointLivraison, String citycode, String postcode, String complementAdresse, String noVoie, String libelleVoie, String ville, String idBan) {
            this.valueChb = valueChb;
            this.pointLivraison = pointLivraison;
            this.citycode = citycode;
            this.postcode = postcode;
            this.complementAdresse = complementAdresse;
            
            this.noVoie = noVoie;
            this.libelleVoie = libelleVoie;
            this.ville = ville;
            this.idBan = idBan;
        }
        
    }
    
    /*author: RWA
*Description: mode de retour du PDL, PCE
*createdDate: 26/07/2018
*LastModified MHA 07/12/2018
*/
    public class PdlPceModel {
        public String vPDL;
        public String vPCE;
        public String vElecRegie;
        public String vGazRegie;
        
        public PdlPceModel(String vPDL, String vPCE, String vElecRegie, String vGazRegie) {
            this.vPDL = vPDL;
            this.vPCE = vPCE;
            this.vElecRegie = vElecRegie;
            this.vGazRegie = vGazRegie;
        }
        
    }
    
    /*author: RWA
*Description: construction du retour de l'appel
*createdDate: 26/07/2018
*LastModified MHA 07/12/2018
*/
    public static Map<String, Object> transformDatatoOmniscript(List < Object > apiData, Boolean bCallZoneDistrib) {
        system.debug('@@transformDatatoOmniscript apiData.size ' + apiData.size());
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
            
            /* ne pas effacer ce code ...comment?? uniquement dans le contexte de l'us SMIL-2903
if (bCallZoneDistrib && firstCall) {
firstCall = false;
//if(SM_AP44_ZoneDistributionApiService.callZoneDistribitionByCodeInsee(newInputMap, newOutputMap, optionMap) != null){
SM_AP44_ZoneDistributionApiService.callZoneDistribitionByCodeInsee(newInputMap, newOutputMap, optionMap);
SM_AP44_ZoneDistributionApiService.zoneDistributionModel elecZoneDistributeur = (SM_AP44_ZoneDistributionApiService.zoneDistributionModel)newOutputMap.get('elec');
SM_AP44_ZoneDistributionApiService.zoneDistributionModel gazZoneDistributeur = (SM_AP44_ZoneDistributionApiService.zoneDistributionModel)newOutputMap.get('gaz');
vElecRegie = elecZoneDistributeur!=null?elecZoneDistributeur.appartientRegie:'';
vGazRegie =  gazZoneDistributeur!=null?gazZoneDistributeur.appartientRegie:'';
//}
}*/
            PdlPceModel pointLivraison = new pdlPceModel(PDL, PCE, vElecRegie, vGazRegie);
            listTemp.add(new AdresseModel(addrLabel, pointLivraison, citycode, postcode, complementAdresse, noVoie, libelleVoie, ville, idBan));
            
        }
        system.debug('@@transformDatatoOmniscript listTemp ' + listTemp.size());
        transformeDataStructure.put('resultdata', listTemp);
        system.debug('@@transformDatatoOmniscript ended');
        return transformeDataStructure ;
        
        
    }
    
    /*author: RWA
*Description: appel de l'API
*createdDate: 26/07/2018
*LastModified MHA 07/12/2018
*/
    public static HttpResponse getResponse(String reqParams) {
        HttpResponse httpResp = CalloutManager.sendRequest('AdressesXdataSmile', reqParams, 'GET', CalloutManager.Scope.READ,null,null);
        if (CalloutManager.httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('## [getAdresse] error occured when sending data ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            return null;
        }
        system.debug('http response is ' + httpResp.getBody());
        system.debug('http response is ' + httpResp);
        return httpResp;
        
    }
    
    private static void  searchAddressById(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        system.debug('**** ' + inputMap);
        String idLogement = (String)inputMap.get('idLogement') ;
        String page = (String)inputMap.get('page') ;
        if (idLogement == null || idLogement.length() == 0) {
            system.debug('error occured when getting idLogement ..');
            return ;
        }
        
        HttpResponse httpResponse = new HttpResponse();
        String reqParams = '?idBAN=' + idLogement;
        
        if(page != null){
            reqParams = reqParams + '&page=' + page; 
        }
        
        if (!Test.isRunningTest()) {
            httpResponse = getResponse(reqParams);
        } else {
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SM_MockResponseGetAddr');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            // Set the mock callout mode
            Test.setMock(HttpCalloutMock.class, mock);
            httpResponse = getResponse('?idBAN=ADRNIVX_0000000331881839');
        }
        
        
        Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
        List < Object > listAdresses = (List < Object > ) resultAsMap.get('_data');
        
        if (listAdresses != null && listAdresses.size() > 0) {
            
            if(page != null){
                Map<String, Object> transformedData =  transformDatatoOmniscript(listAdresses, true) ;
                system.debug('@@ transformedData: ' + transformedData);
                if (outMap == null) {
                    outMap = new Map < String, Object >();
                }
                outMap.put('data', transformedData);
                outMap.put('pagination', resultAsMap.get('_pagination'));
            }
            else{
                Map<String, Object> adress  =   (Map<String, Object>) listAdresses.get(0) ; // unique adress , get the first element
                Map<String, Object> maptemp =  new Map<String, Object>() ;
                maptemp.put('PDL', adress.get('idPointDeLivraison')) ;
                maptemp.put('PCE', adress.get('idPointDeComptage'))  ;
                
                Map<String, Object> addr =  new Map<String, Object>() ;
                addr.put('NoVoie', adress.get('numeroVoie'));
                addr.put('Rue', adress.get('libelleVoie'));
                addr.put('Ville', adress.get('ville'));
                addr.put('CP', adress.get('codePostal'));
                addr.put('CpltAddr', adress.get('complementAdresse'));
                
                outMap.put('addrData', addr) ;
                outMap.put('results', maptemp)  ;
                system.debug('output map => ' + outMap);
            }
            
        } else {
            system.debug('no address found ..');
        }
        
        
    }
    
    
    public static void  getAddressById(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        system.debug('**** ' + inputMap);
        String idAddress = (String)inputMap.get('idAddress') ;
        if (idAddress == null || idAddress.length() == 0) {
            system.debug('error occured when getting idAddress ..');
            return ;
        }
        
        HttpResponse httpResponse = new HttpResponse();
        String reqParams = '/' + idAddress;
        
        if (!Test.isRunningTest()) {
            httpResponse = getResponse(reqParams);
        } else {
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SM_MockResponseGetAddr');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            // Set the mock callout mode
            Test.setMock(HttpCalloutMock.class, mock);
            httpResponse = getResponse('/51');
        }
        
        system.debug('adresse httpResponse ' + httpResponse);
        if (httpResponse != null ) {
            Map < String, Object > address = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
            system.debug(address);
            
            if (address.isEmpty() == false ) {
                Map<String, Object> maptemp = new Map< String, Object >();
                maptemp.put('idBan', address.get('idBAN')) ;
                outMap.put('results', maptemp)  ;
                system.debug('output map => ' + outMap);
            } else {
                system.debug('no address found ..');
            }
        } else {
            system.debug('no address found ..');
        }
        
        
    }
    
    /*
*   Cette m??thode est appel??e depuis l'IP pour le selfcare
*   On r??cup??re les donn??es et on les adapte pour pouvoir utiliser la m??thode searchAddress existante
*/
    public static void searchAddressSelfcare(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        System.debug('**** IN searchAddressSelfcare');
        System.debug('#### inputMap selfcare ' + inputMap);
        // On r??cup??re les ??l??ments de l'IP selfcare
        
        
        System.debug('*** params : ' + inputMap);
        /*Map<String,Object> contratIn = (Map<String,Object>) inputMap.get('WSContrat');
Set<String> gaz = (Set<String>) contratIn.get('gaz');
Set<String> elec = (Set<String>) contratIn.get('elec');
*/
        Map<String, Object> elecOps = new Map<String,Object>();
        Map<String, Object> opsListElec =  new Map<String,Object>(); 
        Map<String, Object> gazOps =  new Map<String,Object>(); 
        Map<String, Object> opsListGaz = new Map<String,Object>();
        
        elecOps = (Map<String, Object>) inputMap.get('RechercherPrestaElec');
        if(elecOPS!=null)
            opsListElec =(Map<String, Object>) elecOps.get('ops');
        
        gazOps = (Map<String, Object>) inputMap.get('RechercherPrestaGaz');
        if(gazOPS!=null)
            opsListGaz = (Map<String, Object>) gazOps.get('ops');
        
        List<Object> outAddr = new List<Object>();
        
        // On les remappe pour que la m??thode existante fonctionne
        // Un appel est fait pour chaque PDL / PCE
        
        if(!opsListGaz.isEmpty()){
            for(String gazPdl : (Set<String>) opsListGaz.keySet()){
                System.debug('*** pce ' + gazPdl);
                Map<String, Object> root = new Map<String, Object>();
                Map<String, Object> pdlPce = new Map<String, Object>();
                Map<String, Object> pceMap = new Map<String, Object>();
                
                system.debug('outAddr '+ outAddr);
                pceMap.put('PCENumber', gazPdl);
                pdlPce.put('SearchByPDLPCE', pceMap);
                root.put('ChoixElements1', pdlPce);
                
                Map<String, Object> apiOut = new Map<String, Object>();
                //Si le pce ?? d??j?? correspond ?? une adresse dans la liste il s'agit d'un doublon don on ne le rajoute pas
                if(checkIfpdlExist(outAddr,'Gaz',gazPdl)){
                    continue;
                }
                searchAddress(root, apiOut, options);
                system.debug('apiOut'+apiOut)    ;    
                
                
                system.debug(apiOut)    ;  
                if(apiOut.get('data') != 'error' ){
                    apiOut = (Map<String, Object>) apiOut.get('data');
                    List<Object> apiOutList = (List<Object>) apiOut.get('resultdata');
                    
                    for (Object anObj : apiOutList) {
                        AdresseModel adr = (AdresseModel) anObj;
                        outAddr.add( adr);
                    }
                }
                
                
                //outAddr.putAll(apiOut);
            }
        }
        
        
        if(!opsListElec.isEmpty()){
            for(String elecPdl : (Set<String>) opsListElec.keySet()){
                System.debug('*** pdl ' + elecPdl);
                Map<String, Object> root = new Map<String, Object>();
                Map<String, Object> pdlPce = new Map<String, Object>();
                Map<String, Object> pdlMap = new Map<String, Object>();
                
                pdlMap.put('PDLNumber', elecPdl);
                pdlPce.put('SearchByPDLPCE', pdlMap);
                root.put('ChoixElements1', pdlPce);
                
                Map<String, Object> apiOut = new Map<String, Object>();
                //Si le Pdl correspond ?? une adresse de la liste, l'adresse ?? ??t?? ramen?? par son pce paire ou doublon on ne rajoute pas ?? liste et pas d'appel WS
                if(checkIfpdlExist(outAddr,'Elec',elecPdl)){
                    continue;
                }
                searchAddress(root, apiOut, options);
                system.debug(apiOut)    ;       
                
                
                system.debug('apiOut'+apiOut)    ;  
                if(apiOut.get('data') != 'error' ){
                    apiOut = (Map<String, Object>) apiOut.get('data');
                    List<Object> apiOutList = (List<Object>) apiOut.get('resultdata');
                    
                    for (Object anObj : apiOutList) {
                        AdresseModel adr = (AdresseModel) anObj;
                        outAddr.add(adr);
                    }
                }
            }
            
            
        }
        system.debug('data'+outAddr);
        system.debug('data count'+outAddr.size());
        outMap.put('data', outAddr);
        
        
        System.debug('**** OUT searchAddressSelfcare');
    }
    
    public static Boolean checkIfpdlExist(List<Object> outAddr, String energy,String numPdlPce){
        
        String pdl;
        String pce;
        system.debug(' outAddr' +  outAddr);
        for(Object objAdr : outAddr){
            SM_AP07_AdressesApiService.AdresseModel adr = (SM_AP07_AdressesApiService.AdresseModel) objAdr;
            SM_AP07_AdressesApiService.PdlPceModel pdlPceObj = adr.pointLivraison;
            
            pdl=pdlPceObj.vPDL;
            pce=pdlPceObj.vPCE;
            If(energy== 'Elec' && pdl==numPdlPce){
                return true;
            }
            If(energy== 'Gaz' && pce==numPdlPce){
                return true;
            }
        }
        
        return false;
    }
    
    
    
}