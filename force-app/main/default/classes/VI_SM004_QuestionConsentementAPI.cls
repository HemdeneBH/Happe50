/*
*@Author: Paul Ghousoub
*@Description: Appel du WS 'VI_Questions_Consentement'.
*@CreatedDate: 26/10/2020
*@LastModified: 05/11/2020
*/

public class VI_SM004_QuestionConsentementAPI {
       /**
* @author Paul Ghousoub
* @date 26/10/2020
* @description Appel du ws des questions consentements afin d'obtenir la liste des questions
* @param contexte (HP,SM,VI), partitionName (local.VIToken,local.smileToken)
* @return la question
*/
    public static QuestionConsentementResponse callQuestionConsentement(String contexte, String partitionName) { 
        String token;
        if(!Test.isRunningTest()){
            token = VI_SM013_GetTokenService.getToken(contexte, partitionName);
        }
        else{
            token = 'test';
        }
        if (token == null) {
            system.debug('Token not found ...');  
            return null;
        }
        HttpResponse httpResponse = VI_UTIL001_HttpUtilities.getResponseConsentement(token,'GET','QuestionConsentementAPI',contexte+'_Questions_Consentement',null,null, contexte);
        QuestionConsentementResponse response = parse(httpResponse.getBody());
        system.debug(response);
        return response;
    }
    
    public class QuestionConsentementResponse{
		public cls_data[] data;
        public String code; //null si 200, 201 ou 206
        public String name;
        public String message;
    }
	public class cls_data {
		public Integer idQuestionnaire;	//1
		public Integer idQuestion;	//1
		public String codeQuestionnaireQuestion;	//Q1.1
		public String libelleQuestion;	//J'accepte de recevoir des communications par voie électronique sur des offres de produits ou services de la société ENGIE similaires à la vente d’énergie.
		public String detailQuestion;	//J’accepte de recevoir des communications concernant des produits analogues Engie. (Les produits Engie correspondent à des abonnements énergie « Électricité, Gaz »)
	}
	public static QuestionConsentementResponse parse(String json){
        json = VI_UTIL001_httputilities.handleResponse(json);
		return (QuestionConsentementResponse) System.JSON.deserialize(json, QuestionConsentementResponse.class);
	}
    
}