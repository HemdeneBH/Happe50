/*
*@Author: Paul Ghousoub
*@Description: Appel du WS VI_DQE_Adresse
*@CreatedDate: 27/10/2020
*@LastModified: 27/10/2020
*/
public class VI_SM002_AdresseDQE { 
    
    /**
* @author Amal Chreiteh
* @date 01/02/2021
* @description suggestion de commune en se basant sur le code postal
* @param code postal, contexte (HP,SM,VI), partitionName (local.VIToken,local.smileToken)
* @return liste d'adresses
*/
    public static Set<String> getSuggestionsCodePostal(String codePostal, String contexte, String PartitionName) {
        Map<String, String> listParameters = new Map<String, String>();
        Set<String> villes = new Set<String>();
        
        listParameters.put('Pays', 'FRA');
        listParameters.put('Instance', '0');
        listParameters.put('Alpha', 'false'); 
        
        if (CodePostal == null) {
            system.debug('code postal not found ...');
            return null;
        } else {
            listParameters.put('CodePostal', codePostal);
        }
        
        String token;
        if (Test.isRunningTest()) {
            token = 'wadfkoa1234';
        } else {
            token =  VI_SM013_GetTokenService.getToken(contexte, PartitionName);
        }
        HttpResponse res = new HttpResponse();
        res = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_DQE_CodePostal',listParameters,null, contexte);
        if(String.isNotBlank(res.getBody())){
            Map<String, Object> addressMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            for(String key : addressMap.keySet()) {
                Map<String, Object> currentAdd = (Map<String, Object>)addressMap.get(key);
                AdressesWrapper adresse = new AdressesWrapper(currentAdd, key);
                villes.add(adresse.ville.substring(0,1).toUpperCase() + adresse.ville.substring(1).toLowerCase());
            }
        }
        return villes;
    }   
    
    public static Map<String,String> getSuggestionsCodePostalMap(String codePostal, String contexte, String PartitionName) {
        Map<String, String> listParameters = new Map<String, String>();
        Set<String> villes = new Set<String>();
        Map<String,String> mapVilles=new Map<String,String>();
        
        listParameters.put('Pays', 'FRA');
        listParameters.put('Instance', '0');
        listParameters.put('Alpha', 'false'); 
        //DDPCM-193: Identification client & local : affichage de la commune des les 3 premiers chiffre du CP
        listParameters.put('Etendue','Y');
        //END
        
        if (CodePostal == null) {
            system.debug('code postal not found ...');
            return null;
        } else {
            listParameters.put('CodePostal', codePostal);
        }
        
        String token;
        if (Test.isRunningTest()) {
            token = 'wadfkoa1234';
        } else {
            token =  VI_SM013_GetTokenService.getToken(contexte, PartitionName);
        }
        HttpResponse res = new HttpResponse();
        res = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_DQE_CodePostal',listParameters,null, contexte);
        if(String.isNotBlank(res.getBody())){
            Map<String, Object> addressMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            for(String key : addressMap.keySet()) {
                Map<String, Object> currentAdd = (Map<String, Object>)addressMap.get(key);
                AdressesWrapper adresse = new AdressesWrapper(currentAdd, key);
                system.debug('adresse'+ adresse);
                if(!adresse.ville.containsIgnoreCase('CEDEX') && adresse.ville.length()>0){
                    villes.add(adresse.ville.substring(0,1).toUpperCase() + adresse.ville.substring(1).toLowerCase());
                    mapVilles.put(adresse.ville.substring(0,1).toUpperCase() + adresse.ville.substring(1).toLowerCase(),adresse.codePostal);
                }
            }
        }
        return mapVilles;
    }    
    /**
* @author Amal Chreiteh
* @date 01/02/2021
* @description suggestion de commune en se basant sur le code postal
* @param code postal, contexte (HP,SM,VI), partitionName (local.VIToken,local.smileToken)
* @return liste d'adresses
*/
    public static List<AdressesWrapper> getSuggestionsCodePostalWrapper(String codePostal, String contexte, String PartitionName) {
        System.debug('### Start getSuggestionsCodePostalWrapper : ');
        Map<String, String> listParameters = new Map<String, String>();
        Map<String, String> listParametersWrapper = new Map<String, String>();
        Set<String> villes = new Set<String>();
        Set<AdressesWrapper> villesWrapper = new Set<AdressesWrapper>();
        
        listParameters.put('Pays', 'FRA');
        listParameters.put('Instance', '0');
        listParameters.put('Alpha', 'false');
        listParameters.put('Etendue','Y');
        
        if (CodePostal == null) {
            system.debug('code postal not found ...');
            return null;
        } else {
            listParameters.put('CodePostal', codePostal);
        }
        
        String token;
        if (Test.isRunningTest()) {
            token = 'wadfkoa1234';
        } else {
            token =  VI_SM013_GetTokenService.getToken(contexte, PartitionName);
        }
        HttpResponse res = new HttpResponse();
        List<AdressesWrapper> adresseList = new List<AdressesWrapper>();
        if(!test.isRunningTest()){
            res = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_DQE_CodePostal',listParameters,null, contexte);
        }
        else{
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_TestDQEAdresse');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, multimock); 
            res = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_DQE_CodePostal',listParameters,null, contexte);
        }
        if(String.isNotBlank(res.getBody())){
            Map<String, Object> addressMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            system.debug('addressMap'+ addressMap);
            Set<String> currentAddresses=new Set<String>();
            for(String key : addressMap.keySet()) {
                
                
                Map<String, Object> currentAdd = (Map<String, Object>)addressMap.get(key);
                AdressesWrapper adresse = new AdressesWrapper(currentAdd, key);
                
                if(!adresse.ville.containsIgnoreCase('CEDEX') && adresse.ville.length()>0 && !currentAddresses.contains(adresse.ville)){
                    system.debug('currentAddresses '+currentAddresses);
                    adresseList.add(adresse);
                    currentAddresses.add(adresse.ville);
                }
            }
        } 
        
        
        System.debug('### adresseList : ');
        System.debug(adresseList);
        return adresseList;
    }   
    
    public static Map<String,AdressesWrapper> getSuggestionsCodePostalWrapperMap(String codePostal, String contexte, String PartitionName) {
        System.debug('### Start getSuggestionsCodePostalWrapperMap : ');
        Map<String, String> listParameters = new Map<String, String>();
        Map<String, String> listParametersWrapper = new Map<String, String>();
        Map<String,AdressesWrapper> mapAdresses=new Map<String,AdressesWrapper>();
        Set<String> villes = new Set<String>();
        Set<AdressesWrapper> villesWrapper = new Set<AdressesWrapper>();
        
        listParameters.put('Pays', 'FRA');
        listParameters.put('Instance', '0');
        listParameters.put('Alpha', 'false');
        listParameters.put('Etendue','Y');
        
        if (CodePostal == null) {
            system.debug('code postal not found ...');
            return null;
        } else {
            listParameters.put('CodePostal', codePostal);
        }
        
        String token;
        if (Test.isRunningTest()) {
            token = 'wadfkoa1234';
        } else {
            token =  VI_SM013_GetTokenService.getToken(contexte, PartitionName);
        }
        HttpResponse res = new HttpResponse();
        List<AdressesWrapper> adresseList = new List<AdressesWrapper>();
        if(!test.isRunningTest()){
            res = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_DQE_CodePostal',listParameters,null, contexte);
        }
        else{
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_TestDQEAdresse');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, multimock); 
            res = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_DQE_CodePostal',listParameters,null, contexte);
        }
        if(String.isNotBlank(res.getBody())){
            Map<String, Object> addressMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            system.debug('addressMap'+ addressMap);
            Set<String> currentAddresses=new Set<String>();
            for(String key : addressMap.keySet()) {
                
                
                Map<String, Object> currentAdd = (Map<String, Object>)addressMap.get(key);
                AdressesWrapper adresse = new AdressesWrapper(currentAdd, key);
                
                if(!adresse.ville.containsIgnoreCase('CEDEX') && adresse.ville.length()>0 && !currentAddresses.contains(adresse.ville)){
                    system.debug('currentAddresses '+currentAddresses);
                    adresseList.add(adresse);
                    currentAddresses.add(adresse.ville);
                    mapAdresses.put(adresse.ville.substring(0,1).toUpperCase() + adresse.ville.substring(1).toLowerCase(),adresse);

                }
            }
        } 
        
        
        System.debug('### mapAdresses : ');
        System.debug(mapAdresses);
        return mapAdresses;
    }   
    /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description suggestion de complement par rapport a la voie et le numero
* @param idVoie,numero, contexte (HP,SM,VI), partitionName (local.VIToken,local.smileToken)
* @return list de complements
*/
    public static List<Map<String, Object>> getSuggestionsComplementDQE(String idVoie, String numero, String contexte, String PartitionName) {
        List<Map<String, Object>> result = new List<Map<String, Object>>(); 
        Map<String, String> listParameters = new Map<String, String>();
        listParameters.put('Pays', 'FRA');
        listParameters.put('Taille', '38');
        String idVoiee;
        String numeroo; 
        if (idVoie == null) { 
            system.debug('idVoie not found ...');
            return null;
        } else {
            idVoiee = idVoie;
            listParameters.put('IDVoie', idVoiee);
        }
        
        if (numero == null) {
            system.debug('numero not found ...');
            return null;
        } else {
            numeroo = numero;
            listParameters.put('IDNum', numeroo);
        }
        //listParameters.put('CodePostal', '92000');
        
        String token;
        if (Test.isRunningTest()) {
            token = 'wadfkoa1234';
        } else {
            token =  VI_SM013_GetTokenService.getToken(contexte, PartitionName);
        }
        HttpResponse res = new HttpResponse();
        res = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_DQE_Complement',listParameters,null, contexte);
        if(res!= null && String.isNotBlank(res.getBody())){
            Map<String, Object> complementMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            for(String key : complementMap.keySet()) {
                if(!key.isNumeric()){
                    continue;
                }
                Map<String, Object> currentCompl = (Map<String, Object>)complementMap.get(key);
                String complement = (String)currentCompl.get('Batiment');
                result.add(new Map<String, Object>{'label' => complement});
            }
        }
        return result;
    }
    /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description suggestion d'adresse par rapport a l'adresse entrée
* @param adresseinput, contexte (HP,SM,VI), partitionName (local.VIToken,local.smileToken)
* @return liste d'adresses
*/
    public static List<AdressesWrapper> getSuggestionsAdresseDQE(String adresseInput, string contexte, String partitionName) {
        List<AdressesWrapper> adresseWrapperList = new List<AdressesWrapper>();
        Map<String, String> listParameters = new Map<String, String>();
        //utiliser urlEncode pour gerer les accents         
        listParameters.put('Pays', 'FRA');
        listParameters.put('NbMax', '5');
        listParameters.put('Adresse', EncodingUtil.URLENCODE(adresseInput,'UTF-8'));
        String token;
        if (Test.isRunningTest()) {
            token = 'wadfkoa1234';
        } else {
            token =  VI_SM013_GetTokenService.getToken(contexte, partitionName);
        }
        HttpResponse res = new HttpResponse();
        long start = System.currentTimeMillis();   
        system.debug('start time getSuggestionsAdresseDQE'+ start);
        res = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_DQE_Adresse',listParameters,null, contexte);
        long elapsedTime = System.currentTimeMillis() - start;
        system.debug('elapsed time getSuggestionsAdresseDQE'+ elapsedTime); 
        system.debug(res.getBody());
        if(String.isNotBlank(res.getBody())){
            Map<String, Object> addressMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            for(String key : addressMap.keySet()) {
                Map<String, Object> currentAdd = (Map<String, Object>)addressMap.get(key);
                AdressesWrapper adresse = new AdressesWrapper(currentAdd, key);
                adresseWrapperList.add(adresse);
            }
        }
        return adresseWrapperList;
    }
    
    
    /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Wrapper du retour de l'appel
*/ 
    public class AdressesWrapper {
        @AuraEnabled
        public String codePostal;
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String numero;
        @AuraEnabled
        public String voie;
        @AuraEnabled
        public String idVoie;
        @AuraEnabled
        public String complement;
        @AuraEnabled
        public String idLocalite;
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String ville;
        public AdressesWrapper( Map<String, Object> currentAdd, String key){
            this.codePostal = (String) currentAdd.get('CodePostal');
            this.label = (String) currentAdd.get('Numero') +' ' + (String)currentAdd.get('Voie')+' '+ (String) currentAdd.get('CodePostal')+' '+ (String) currentAdd.get('Localite');
            this.numero = (String) currentAdd.get('Numero');
            this.voie = (String) currentAdd.get('Voie');
            this.idVoie = (String) currentAdd.get('IDVoie');
            this.complement = (String) currentAdd.get('Complement');
            this.idLocalite = (String) currentAdd.get('IDLocalite');
            this.id = key;
            this.ville = (String) currentAdd.get('Localite');
            
        }
    }

}