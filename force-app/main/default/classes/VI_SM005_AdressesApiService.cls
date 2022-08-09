/*
*@Author: Paul Ghousoub
*@Description: Appel de l'API REST Adresse
*@CreatedDate: 27/10/2020
*@LastModified: 27/10/2020
*/
public class VI_SM005_AdressesApiService { 
    /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description rechercher l'adresse par rapport aux données entrées
*/
    public static getAddressByIdResponse searchAddress(String idBAN, String ville, String codePostal, String codeINSEE, 
                                                       String libelleVoie,String numeroVoie, String idPointDeLivraison, 
                                                       String idPointDeComptage, String longitude, String latitude, String page, 
                                                       String size,String contexte, String partitionName ){
                                                           if ((idBAN == null || idBAN.length() == 0) && (ville == null || ville.length() == 0) && (codePostal == null || codePostal.length() == 0) &&(codeINSEE == null || codeINSEE.length() == 0) && (libelleVoie == null || libelleVoie.length() == 0) && (numeroVoie == null || numeroVoie.length() == 0)
                                                               && (idPointDeLivraison == null || idPointDeLivraison.length() == 0) && (idPointDeComptage == null || idPointDeComptage.length() == 0) &&(size == null || size.length() == 0)) {
                                                                   return null;
                                                               }
                                                           String   token ;
                                                           if (Test.isRunningTest()) {
                                                               token = 'wadfkoa1234';
                                                           } else {
                                                               token =  VI_SM013_GetTokenService.getToken(contexte, partitionName);
                                                           }
                                                           HttpResponse httpResponse = new HttpResponse();
                                                           Map<String, String> reqParams = new Map<String, String>(); 
                                                           if(idBAN != null){
                                                               reqParams.put('idBAN', idBAN);  
                                                           }
                                                           if(ville != null){
                                                               ville = EncodingUtil.URLENCODE(ville,'UTF-8'); 
                                                               reqParams.put('ville', ville);  
                                                           }
                                                           if(codePostal != null){
                                                               reqParams.put('codePostal', codePostal);  
                                                           } 
                                                           if(codeINSEE != null){
                                                               reqParams.put('codeINSEE', codeINSEE);  
                                                           } 
                                                           if(libelleVoie != null){
                                                               libelleVoie = EncodingUtil.URLENCODE(libelleVoie,'UTF-8'); 
                                                               reqParams.put('libelleVoie', libelleVoie);  
                                                           } 
                                                           if(numeroVoie != null){
                                                               reqParams.put('numeroVoie', numeroVoie);  
                                                           }
                                                           if(idPointDeLivraison != null){
                                                               reqParams.put('idPointDeLivraison', idPointDeLivraison);  
                                                           }
                                                           if(idPointDeComptage != null){
                                                               reqParams.put('idPointDeComptage', idPointDeComptage);  
                                                           }
                                                           if(longitude != null){
                                                               reqParams.put('longitude', longitude);  
                                                           }
                                                           if(latitude != null){
                                                               reqParams.put('latitude', latitude);  
                                                           }
                                                           if(page != null){
                                                               reqParams.put('page', page);  
                                                           }
                                                           if(size != null){
                                                               reqParams.put('size', size);  
                                                           }
                                                           
                                                           if (!Test.isRunningTest()) {
                                                               long start = System.currentTimeMillis();   
                                                               system.debug('start time searchAddress'+ start);
                                                               httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token, 'GET', contexte+'_Adresses', reqParams, null, contexte);
                                                               long elapsedTime = System.currentTimeMillis() - start;
                                                               system.debug('elapsed time searchAddress'+ elapsedTime);
                                                               system.debug('httpResponse'+ httpResponse);
                                                           } else {
                                                               handleRunningTestCase(reqParams,'ADRNIVX_0000000331881839', 'VI_AdressesApiService', 'application/json' );
                                                               httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token, 'GET', contexte+'_Adresses', reqParams, null, contexte);
                                                           }
                                                           if(httpResponse!= null ){
                                                               getAddressByIdResponse adresse = parsegetAddressByIdResponse(httpResponse.getBody());
                                                               if (adresse != null) {
                                                                   system.debug('adresse'+ adresse);
                                                                   return adresse;
                                                                   
                                                               } 
                                                               else {
                                                                   return null;
                                                               }
                                                           }
                                                           else{
                                                               return null;  
                                                           }
                                                       }
    
    public static getAddressByIdResponse searchAddressByPCE(String PCE, String ville, String codePostal,String libellevoie,
                                                            String contexte, String partitionName){
                                                                //To test: VI_SM005_AdressesApiService.searchAddressByPCE('23198697384673','MORANGIS', '91420' ,'AVENUE GABRIEL PERI' ,'VI', 'local.VIToken' );
                                                                return searchAddress(null, ville, codePostal, null,libellevoie,null,null,PCE,null ,null, null,null,contexte,partitionName );
                                                            }
    
    public static getAddressByIdResponse searchAddressByPDL(String PDL,String ville, String codePostal,String libellevoie,
                                                            String contexte, String partitionName){
                                                                //To test: VI_SM005_AdressesApiService.searchAddressByPDL('21101817736807','MORANGIS', '91420' ,'AVENUE GABRIEL PERI' ,'VI', 'local.VIToken' );
                                                                return searchAddress(null, ville, codePostal, null,libellevoie,null,PDL,null,null ,null, null,null,contexte,partitionName );
                                                            }   
    
    
    public static getAddressByIdResponse searchAddressById(String idBAN, String size,String contexte, String partitionName){
        //To test: VI_SM005_AdressesApiService.searchAddressById('91432_0780_00018', '2', 'VI', 'local.VIToken' );
        return searchAddress(idBAN, null, null, null,null,null,null,null, null,null, null,size,contexte,partitionName );
    }
    //get address by IdBAN
    public static getAddressByIdResponse  getAddressById(String idBAN, String size, String contexte, String partitionName) {
        //To test: VI_SM005_AdressesApiService.getAddressById('91432_0780_00018', 'VI', 'local.VIToken' );
        return searchAddressById(idBAN, size,contexte, partitionName);
    }
    
    // Cherche l'id BAN de l'adresse
    public static String getIdBanIfSameAddr(String addrComplete) { //utiliser urlEncode pour gerer les accents sinon la recherche dadresse ne ramene pas de resultats
        //To test: String IdBAN = VI_SM005_AdressesApiService.getIdBanIfSameAddr('18 Avenue Gabriel Péri 91420 Morangis');
        String IdBAN;
        //addrComplete = addrComplete.replace(' ', '+');        
        //addrComplete = EncodingUtil.URLENCODE(addrComplete,'UTF-8');        
        HTTPResponse res = VI_UTIL001_HttpUtilities.makeGetCalloutAdresse(addrComplete);
        system.debug('res'+ res.getBody());
        adresseCalloutResponse adresseWrapper = parseAdresseCallout(res.getBody());
        if (adresseWrapper != null) {
            system.debug('adresseWrapper '+adresseWrapper);
            IdBAN = adresseWrapper.features[0].properties.id;
            system.debug('adresseWrapper.features[0].properties.postcode '+adresseWrapper.features[0].properties.postcode);
            system.debug('@@IdBAN ' + IdBAN);
        }
        return IdBAN;
    }
    public class addressUnicityWrp{
        public String idPdl;
        public String idPce;
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
    
    public class adresseCalloutResponse{
        public String version;
        public cls_features[] features;
        public String attribution;  
        public String licence;
        public String query;    
    }
    public class cls_features {
        public String type; 
        public cls_geometry geometry;
        public cls_properties properties;
    }
    public class cls_geometry {
        public String type; 
    }
    
    public class cls_properties {
        public String label;     
        public Double score;    
        public String housenumber;  
        public String id;   
        public String type; 
        public Double x;    
        public Double y;    
        public Double importance;   
        public String name; 
        public String postcode; 
        public String citycode; 
        public String city; 
        public String context;  
        public String street;
    }
    public static adresseCalloutResponse parseAdresseCallout(String json){
        return (adresseCalloutResponse) System.JSON.deserialize(json, adresseCalloutResponse.class);
    }
    
    public class getAddressByIdResponse{
        public cls_data[] data;
        public cls_pagination pagination;
        public String code; //null si 200, 201 ou 206
        public String name;
        public String message;
    }
    public class cls_data {
        public Integer id;  
        public String idBAN;    
        public String idPointDeLivraison;
        public String idPointDeComptage;
        public Double longitude;
        public Double latitude; 
        public String ville;    
        public String codePostal;   
        public String libelleVoie;  
        public String numeroVoie;   
        public String codeINSEE;    
        public String complementAdresse;    
        public cls_links links;
    }
    public class cls_links {
        public String self;
    }
    public class cls_pagination {
        public String pageActuelle; 
        public Integer elementParPage;  
        public String pageSuivante; 
    }
    public static getAddressByIdResponse parsegetAddressByIdResponse(String json){
        json = handleResponse(json);
        return (getAddressByIdResponse) System.JSON.deserialize(json, getAddressByIdResponse.class);
    }
    
    public static void handleRunningTestCase(Map<String, String> reqParams, String idBAN, String staticResource, String contentType){
        reqParams.clear();
        reqParams.put('idBAN', idBAN);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource(staticResource);
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', contentType);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
    }
    
    public static String handleResponse(String json){
        json = json.replaceAll('__', '_');
        json = json.replace('_pagination', 'pagination');
        json = json.replace('_data', 'data');
        json = json.replace('_links', 'links');
        return json;
    }
    
}