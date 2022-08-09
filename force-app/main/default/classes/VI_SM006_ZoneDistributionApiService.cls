/*
*@Author: Paul Ghousoub
*@Description: recherhce des informations de la zone de distribution
*@CreatedDate: 27/10/2020
*@LastModified: 27/10/2020
*/
public class VI_SM006_ZoneDistributionApiService {
           /**
* @author Paul Ghousoub
* @date 27/10/2020
* @description Retourne la zonde de distribution par rapport au entrées
*/
    public static ZoneDeDistributionResponse callZoneDistribitionByCodeInsee(String codeINSEE,String postcode,
                                                                             String departement, String codeTypeEnergie, 
                                                                             String page, String size,
                                                                             String contexte, String partitionName) {
        //To test: VI_SM006_ZoneDistributionApiService.callZoneDistribitionByCodeInsee('75101','75101',null,null,null,null,  'VI', 'local.VIToken');
        Map<String, String> listParameters = new Map<String, String>();
        if (codeINSEE == null) { 
            system.debug('codeINSEE not found ...');
            return null;
        } else {
            listParameters.put('codeInsee', codeINSEE);
        }
        
        if (postcode == null) {
            system.debug('postcode not found ...');
            return null;
        } else {
            listParameters.put('postcode', postcode);
        }
        if(departement!= null){
          listParameters.put('departement', departement);  
        }                                                                         
        if(codeTypeEnergie!= null){
          listParameters.put('codeTypeEnergie', codeTypeEnergie);  
        } 
        if(page!= null){
          listParameters.put('page', page);  
        } 
        if(size!= null){
          listParameters.put('size', size);  
        }                                                                          
        String token;
        if (!Test.isRunningTest()) {
            token =  VI_SM013_GetTokenService.getToken(contexte, partitionName);
            system.debug('token '+token);
        } else {
            token = 'test'; 
        }
        
        if (token == null) {
            system.debug('Token not found ...');
            return null;
        }
        
        HttpResponse httpResponse = new HttpResponse();
        httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_Zones_Distribution',listParameters,null, contexte);
        if (httpResponse != null && (httpResponse.getStatusCode( )== 200 || httpResponse.getStatusCode()== 206)) {
            system.debug('httpResponse.getBody() '+httpResponse.getBody());
            ZoneDeDistributionResponse response = parse(httpResponse.getBody());
            system.debug(response);
            return response;
        }
        return null;
    }
    
    public class ZoneDeDistributionResponse{
        public cls_data[] data;
    }
    public class cls_data {

        public String libelleDistributeur;
        public String codeTypeEnergie;
        public String libelleTypeEnergie;
        public String codeInsee;
        public String codePostal;
        public String codeDepartement;
        public String appartientRegie;
        public String typeDistributeur;
    }
    public static ZoneDeDistributionResponse parse(String json){
        json = VI_UTIL001_HttpUtilities.handleResponse(json);
        system.debug('json '+json);
        return (ZoneDeDistributionResponse) System.JSON.deserialize(json, ZoneDeDistributionResponse.class);
    }
}