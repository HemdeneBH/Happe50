/**
 * @File Name          : HP_WRP031_APIHourConsentements.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 28/04/2020 à 12:27:02
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/02/2020   Mouhamadoune Coulibaly     Initial Version
**/
public with sharing class HP_WRP031_APIHourConsentements {
	
	@AuraEnabled
	public String id;
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
	@AuraEnabled
	public String dateModification;

	public class HP_Consentements{
		@AuraEnabled
		public String id;
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
		public HP_Consentements( String id,Integer idPersonne, Integer idQuestionnaire, Integer idQuestion, Boolean consent, String canal,String application) {
		this.id = id;
        this.idPersonne = idPersonne;
        this.idQuestionnaire = idQuestionnaire;
        this.idQuestion = idQuestion;
        this.consent = consent;
        this.canal = canal;
        this.application = application;
		}
		public HP_Consentements(Integer idPersonne, Integer idQuestionnaire, Integer idQuestion, Boolean consent, String canal,String application) {
			this.idPersonne = idPersonne;
			this.idQuestionnaire = idQuestionnaire;
			this.idQuestion = idQuestion;
			this.consent = consent;
			this.canal = canal;
			this.application = application;
			}
	}
	// public class HP_ConsentementsPost{
		
	// 	@AuraEnabled
	// 	public Integer idPersonne;
	// 	@AuraEnabled
	// 	public Integer idQuestionnaire;
	// 	@AuraEnabled
	// 	public Integer idQuestion;
	// 	@AuraEnabled
	// 	public Boolean consent;
	// 	@AuraEnabled
	// 	public String canal;
	// 	@AuraEnabled
	// 	public String application;
	// 	public HP_ConsentementsPost( Integer idPersonne, Integer idQuestionnaire, Integer idQuestion, Boolean consent, String canal,String application) {
		
    //     this.idPersonne = idPersonne;
    //     this.idQuestionnaire = idQuestionnaire;
    //     this.idQuestion = idQuestion;
    //     this.consent = consent;
    //     this.canal = canal;
    //     this.application = application;
    // 	}
	// }

     public HP_WRP031_APIHourConsentements(final HP_Consentements consent){
		this.id = consent.id;
		this.idPersonne = consent.idPersonne;
		this.idQuestionnaire = consent.idQuestionnaire;
		this.idQuestion = consent.idQuestion;
		this.consent = consent.consent;
		this.canal = consent.canal;
		this.application = consent.application;
     
	} 
	
}