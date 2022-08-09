/**
 * @File Name          : HP_WRP029_APIHourCoordonneesBancaires.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 20/02/2020 à 11:07:12
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/02/2020   Mouhamadoune Coulibaly     Initial Version
**/
public with sharing class HP_WRP029_APIHourCoordonneesBancaires {
    @AuraEnabled
    public String id;
    @AuraEnabled
	public String iBAN;
    @AuraEnabled
	public String libelleCompte;
    @AuraEnabled
	public String nomInstitutBancaire;
    @AuraEnabled
	public String rIB;
    @AuraEnabled
	public String titulaire;
    @AuraEnabled
	public String cleBancaire;
    @AuraEnabled
	public String codeGuichet;
    @AuraEnabled
	public String clePays;
    @AuraEnabled
	public String cleRIB;
    @AuraEnabled
	public String bIC;
    @AuraEnabled
	public String numeroCompteBancaire;
    @AuraEnabled
	public Integer idPortefeuilleContrat;
    @AuraEnabled
	public Integer idPersonne;
    @AuraEnabled
	public String idBusinessPartner;
    @AuraEnabled
	public Integer idCompteBancaire;
}