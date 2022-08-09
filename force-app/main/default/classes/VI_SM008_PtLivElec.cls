/*
*@Author: Paul Ghousoub
*@Description: Appel du WS 'VI_Elec_Points_De_Livraison_V3'.
*@CreatedDate: 03/11/2020
*@LastModified: 03/11/2020
*/
public class VI_SM008_PtLivElec {
    /**
* @author Paul Ghousoub
* @date 03/11/2020
* @description retourne les informations du point de livraison par rapport aux données entrées
*/
    public static PointLivraisonElecResponse API_PtLivElec(String numeroPointDeLivraison, String page, String size, String contexte, String partitionName) {
        //To test: VI_SM008_PtLivElec.API_PtLivElec('23198697384673','2','2' ,'VI', 'local.VIToken');
        if (numeroPointDeLivraison==null )
        {
            return new PointLivraisonElecResponse('PCE est vide');
        }
        String token;
        if(Test.isRunningTest()){
            token ='1234';
        }else{
            token =  VI_SM013_GetTokenService.getToken(contexte, partitionName); 
        }
        if (token == null) {
            return new PointLivraisonElecResponse('Token not found ...');
        }
        Map<String, String> mapNumeroPointDeLivraison = new Map <String, String>();
        mapNumeroPointDeLivraison.put('numeroPointDeLivraison', numeroPointDeLivraison);
        if(page!= null){
            mapNumeroPointDeLivraison.put('page', page);
        }
        if(size!= null){
            mapNumeroPointDeLivraison.put('size', size);
        }
        HttpResponse httpResponse = new HttpResponse();
         long start = System.currentTimeMillis();   
        system.debug('start time API_PtLivElec'+ start);
        httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_Elec_Points_De_Livraison_V3',mapNumeroPointDeLivraison,null, contexte);
        long elapsedTime = System.currentTimeMillis() - start;
        system.debug('elapsed time API_PtLivElec'+ elapsedTime);
        system.debug(httpResponse);
        if (httpResponse != null) {
            PointLivraisonElecResponse response = parse(httpResponse.getBody());
            system.debug('response'+ response);
            return response;
        }
        return new PointLivraisonElecResponse('No response');
    }
    
    
    public class PointLivraisonElecResponse{
        public cls_data[] data;
        public cls_pagination pagination;
        public String code; //null si 200, 201 ou 206
        public String name;
        public String message;
        public PointLivraisonElecResponse(string message){
            this.message = message;
        }
    }
    public class cls_data {
        public Integer id;
        public String numeroPointDeLivraison;
        public Double longitude;
        public Double latitude;
        public String ville;
        public String codePostal;
        public String libelleVoie;
        public String numeroVoie;
        public String codeInsee;
        public String codeDistributeur;
        public String libelleDistributeur;
        public String codeMotifCoupure;
        public String codeEmplacementCoupure;
        public String dateMiseAJour;
        public String dateLimiteCoupure;
        public String nombreCadransFournisseur;
        public String codeMatricule;
        public String RegimePropriete;
        public String modeAlimentation;
        public String systemeInfoContractuel;
        public String jourFixeReleve;
        public String idCalendrierFournisseur;
        public String dateMiseHorsService;
        public String codePlageHeuresCreusesFutures;
        public String codePlageHeuresCreusesActuelles;
        public String codePerimetre;
        public String codeEtat;
        public String codeAlimentation;
        public String codeLocalisationCoupure;
        public String etatBranchement;
        public String puissanceMax;
        public String accessibilite;
        public String codeSituation;
        public String nombreCadransDistributeur;
        public String typeCompteur;
        public String puissanceCompteur;    
        public String codeCompteur; 
        public String natureDisjoncteur;    
        public String calibreDisjoncteur;    
        public String puissanceSouscrite;   
        public String regimeDisjoncteur;    
        public String codeNiveauService;    
        public Integer consommationAnnuelleDeReference; 
        public String typeDeComptage;   
        public String cdUniteReleve;    
        public String dateTheoriqueDerniereReleve;  
        public String dateTheoriqueProchaineReleve; 
    }
    public class cls_pagination {
        public String pageActuelle; 
        public Integer elementParPage;  
        public String pageSuivante; 
    }
    public static PointLivraisonElecResponse parse(String response){
        response = VI_UTIL001_HttpUtilities.handleResponse(response);
        return (PointLivraisonElecResponse) System.JSON.deserialize(response, PointLivraisonElecResponse.class);
    }
}