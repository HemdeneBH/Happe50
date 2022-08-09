/**
 * @description       : 
 * @author            : Mohamed Aamer
 * @group             : 
 * @last modified on  : 06-13-2022
 * @last modified by  : Mohamed Aamer
**/
public with sharing class SM_WRP006_HistoriqueSymphonie {

    public SM_WRP006_HistoriqueSymphonie(Boolean isError, Boolean isEmpty, String id, String dateCreation, String heureCreation, String canal, String statut, 
    String activite, String idActivite, String pj, Boolean isURLExist, String commentaire, String marketing, String zOrigin, String responsable) {
        this.isError = isError;
        this.isEmpty = isEmpty;
        this.id = id;
        this.dateCreation = dateCreation;
        this.heureCreation = heureCreation;
        this.canal = canal;
        this.statut = statut;
        this.activite = activite;
        this.idActivite = idActivite;
        this.pj = pj;
        this.isURLExist = isURLExist;
        this.commentaire = commentaire;
        this.marketing = marketing;
        this.zOrigin = zOrigin;
        this.responsable = responsable;
    }
    
    @AuraEnabled
    public Boolean isError = false;

    @AuraEnabled
    public Boolean isEmpty = false;
    
    @AuraEnabled
    public String id;

    @AuraEnabled
    public String dateCreation;

    @AuraEnabled
    public String heureCreation;

    @AuraEnabled
    public String canal;

    @AuraEnabled
    public String statut;

    @AuraEnabled
    public String activite;

    @AuraEnabled
    public String idActivite;

    @AuraEnabled
    public String pj;

    @AuraEnabled
    public Boolean isURLExist;

    @AuraEnabled
    public String commentaire;

    @AuraEnabled
    public String marketing;

    @AuraEnabled
    public String zOrigin;

    @AuraEnabled
    public String responsable;

    public static SM_WRP006_HistoriqueSymphonie parse(String json) {
		return (SM_WRP006_HistoriqueSymphonie) System.JSON.deserialize(json, SM_WRP006_HistoriqueSymphonie.class);
	}
    
}