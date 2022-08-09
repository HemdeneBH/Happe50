/*
*@Author: Paul Ghousoub
*@Description: Appel du WS 'VI_Gaz_Points_De_Livraison_V3'.
*@CreatedDate: 02/2020
*@LastModified: 02/11/2020
*/
public class VI_SM007_PtLivGaz {
    /**
* @author Paul Ghousoub
* @date  02/11/2020
* @description retourne les informations du point de livraison par rapport aux données entrées
*/
    public static PointLivraisonGazResponse API_PtLivGaz(String numeroPointDeLivraison, String Page, String size, String contexte, String partitionName) {
        //to test: VI_SM007_PtLivGaz.API_PtLivGaz('21101817736807',null,null ,'VI', 'local.VIToken');
        if (numeroPointDeLivraison==null || String.isBlank(numeroPointDeLivraison))
        {
            return new PointLivraisonGazResponse('PDL missing');
        }
        String token;
        if(Test.isRunningTest()){
            token ='1234';
        }else{
            token = VI_SM013_GetTokenService.getToken(contexte, partitionName); 
        }
        if (token == null) {
            return new PointLivraisonGazResponse('Token not found');
        }
        HttpResponse httpResponse = new HttpResponse();
        Map<String, String> bodyMap = new Map<String, String>();
        bodyMap.put('numeroPointDeLivraison', numeroPointDeLivraison);
        if(page!=null){
            bodyMap.put('page', page);
        }
        if(size!= null){
            bodyMap.put('size', size);
        }
        long start = System.currentTimeMillis();   
        system.debug('start time API_PtLivGaz'+ start);
        httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_Gaz_Points_De_Livraison_V3',bodyMap,null, contexte);
        long elapsedTime = System.currentTimeMillis() - start;
        system.debug('elapsed time API_PtLivGaz'+ elapsedTime);
        if (httpResponse != null) {
            PointLivraisonGazResponse response = parse(httpResponse.getBody());
            return response;
        }
        return new PointLivraisonGazResponse('No response');

    }
    
    public class PointLivraisonGazResponse{
		public cls_data[] data;
        public cls_pagination pagination;
        public String code; //null si 200, 201 ou 206
        public String name;
        public String message;
        public PointLivraisonGazResponse(string message){
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
		public String dateMiseAJour;	
		public Integer consommationAnnuelleDeReferenceActuelle;	
		public Integer consommationAnnuelleDeReferenceFuture;	
		public String frequenceReleve;
		public String codeMatricule;
		public Integer nombreRoue;
		public String codeSituation;
		public String debit;	
		public String codeAppareil;	
		public String etatAlimentation;	
		public String dangerGraveImmediat;	
		public String pression;	
		public String natureGaz;	
		public String idPIDT;	
		public String statutContractuel;	
		public String accessibilite;	
		public String dateIndexResiliation;
		public String indexResiliation;	
		public String motifCoupure;	
		public String  dateCoupure;
		public String fraude;	
		public String diagnostiqueGazObligatoire;	
		public Integer consommationAnnuelleDeReference;
		public String tarifAcheminement;	
		public String miseHorsServiceEnCours;	
		public String jourFixeTeleReleve;
		public String dateTeleReleve;
		public String etatPCE;
		public Integer consommationAnnuelleDeReferenceDistributeur;
		public String typeCompteur;	
		public String plageConsommation;
		public String cdUniteReleve;
		public String dateTheoriqueDerniereReleve;
		public String dateTheoriqueProchaineReleve;	
	}
    public class cls_pagination {
        public String pageActuelle;	
        public Integer elementParPage;	
        public String pageSuivante;	
    }
        
    public static PointLivraisonGazResponse parse(String response){
        response = VI_UTIL001_HttpUtilities.handleResponse(response);
		return (PointLivraisonGazResponse) System.JSON.deserialize(response, PointLivraisonGazResponse.class);
	}
}