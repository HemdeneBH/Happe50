/*
*@Author: Eloi Dereeper
*@Description: Appel de l'API Adresses
*@CreatedDate: 03/11/2020
*@LastModified: 03/11/2020
*/
public class VI_SM012_Adresses {
    /*
*@Author: Eloi Dereeper
*@Description: retourne les informations correspondantes aux champs envoyés
*@CreatedDate: 03/11/2020
*/
    public static List<AdressesWrapper> CallAdresses(String ville, String codePostal, String libelleVoie, String numeroVoie, 
                                                     String contexte, String partitionName){
                                                         Map<String, String> listParameters = new Map<String, String>();
                                                         listParameters.put('ville', ville);
                                                         listParameters.put('codePostal', codePostal);
                                                         listParameters.put('numeroVoie', numeroVoie);
                                                         listParameters.put('size', '50');
                                                         listParameters.put('libelleVoie', EncodingUtil.URLENCODE(libelleVoie,'UTF-8'));
                                                         
                                                         String token;
                                                         if(Test.isRunningTest()){
                                                             token ='1234';
                                                         }else{
                                                             token =  VI_SM013_GetTokenService.getToken(contexte, partitionName);  
                                                         }
                                                         system.debug('token '+token);
                                                         if (token == null) {
                                                             return null;
                                                         }
                                                         HttpResponse httpResponse = new HttpResponse();
                                                         httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token, 'GET', contexte+'_Adresses', listParameters, null, contexte);
                                                         
                                                         if (httpResponse != null) {
                                                             Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
                                                             List < Object > listResult = (List < Object > ) resultAsMap.get('_data');
                                                             
                                                             if (listResult.Size() == 0) {
                                                                 system.debug('No result');
                                                                 return null;
                                                             }
                                                             Map < String, Object > outMap= new Map < String, Object >();
                                                             List<AdressesWrapper> adresseWrapperList = new List<AdressesWrapper>();
                                                             adresseWrapperList = transformToOutPut(listResult);
                                                             return adresseWrapperList;
                                                         }
                                                         return null;
                                                     }
    
    public static List<AdressesWrapper> transformToOutPut (List < Object > apiData) {
        List <AdressesWrapper> adresseWrapperList = new List<AdressesWrapper>();
        
        for (Object obj : apiData) {
            Map < String, Object > objectX = (Map < String, Object > ) obj;
            String cityCode = String.valueOf(objectX.get('codeINSEE'));
            String postCode = String.valueOf(objectX.get('codePostal'));
            String idBan = String.valueOf(objectX.get('idBAN'));
            String libelleVoie = String.valueOf(objectX.get('libelleVoie'));
            String noVoie = String.valueOf(objectX.get('numeroVoie'));
            String ville = String.valueOf(objectX.get('ville'));
            String vPCE = String.valueOf(objectX.get('idPointDeComptage'));
            String vPDL = String.valueOf(objectX.get('idPointDeLivraison'));
            String valueChb = noVoie + ' ' + libelleVoie + ' ' + postCode + ' ' + ville;
            String vGazRegie = '';
            String vElecRegie = '';
            
            AdressesWrapper wrp = new AdressesWrapper(cityCode, postCode, idBan, libelleVoie, noVoie, ville, vPCE, vPDL, 
                                                      valueChb, vGazRegie, vElecRegie);
            adresseWrapperList.add(wrp);            
        }
        
        return adresseWrapperList;
    }
    
    public class AdressesWrapper {
        public String cityCode;
        public String postCode;
        public String idBan;
        public String libelleVoie;
        public String noVoie;
        public String ville;
        public String vPCE;
        public String vPDL;
        public String valueChb;
        public String vGazRegie;
        public String vElecRegie;
        Map<String, Object> pointLivraison = new Map<String, Object>();
        
        public AdressesWrapper(String cityCode, String postCode, String idBan, String libelleVoie, String noVoie, String ville, 
                               String vPCE, String vPDL, String valueChb, String vGazRegie, String vElecRegie){
                                   
                                   Map<String, Object> pointLivraisonContent = new Map<String, Object>();
                                   pointLivraisonContent.put('vPCE', vPCE);
                                   pointLivraisonContent.put('vPDL', vPDL);
                                   pointLivraisonContent.put('vGazRegie', vGazRegie);
                                   pointLivraisonContent.put('vElecRegie', vElecRegie);
                                   
                                   pointLivraison.put ('pointLivraisonContent', pointLivraisonContent);
                                   
                                   this.cityCode = cityCode;
                                   this.postCode = postCode;
                                   this.idBan = idBan;
                                   this.libelleVoie = libelleVoie;
                                   this.noVoie = noVoie;
                                   this.ville = ville;
                                   this.valueChb = valueChb;
                                   
                               }
    }
    
}