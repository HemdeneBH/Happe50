/**
 * @File Name          : HP_WRP033_APIHourConsentementsPost.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 10/03/2020 à 18:22:58
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/03/2020   Mouhamadoune Coulibaly     Initial Version
**/
public with sharing class HP_WRP033_APIHourConsentementsPost {
   
	@AuraEnabled
	public Integer idPersonne;
	@AuraEnabled
	public Integer idQuestionnaire;
	@AuraEnabled
	public Integer idQuestion;
	@AuraEnabled
	public Boolean consent;
	@AuraEnabled
	public String canal;
	@AuraEnabled
	public String application;
	
    public class HP_ConsentementsPost{
		
		@AuraEnabled
		public Integer idPersonne;
		@AuraEnabled
		public Integer idQuestionnaire;
		@AuraEnabled
		public Integer idQuestion;
		@AuraEnabled
		public Boolean consent;
		@AuraEnabled
		public String canal;
		@AuraEnabled
		public String application;
		public HP_ConsentementsPost( Integer idPersonne, Integer idQuestionnaire, Integer idQuestion, Boolean consent, String canal,String application) {
		
        this.idPersonne = idPersonne;
        this.idQuestionnaire = idQuestionnaire;
        this.idQuestion = idQuestion;
        this.consent = consent;
        this.canal = canal;
        this.application = application;
    	}
    }
        public HP_WRP033_APIHourConsentementsPost(final HP_ConsentementsPost consent){

		this.idPersonne = consent.idPersonne;
		this.idQuestionnaire = consent.idQuestionnaire;
		this.idQuestion = consent.idQuestion;
		this.consent = consent.consent;
		this.canal = consent.canal;
		this.application = consent.application;
     
	} 
}