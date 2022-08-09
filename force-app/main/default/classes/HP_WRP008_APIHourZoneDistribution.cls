/**
 * @File Name          : HP_WRP008_APIHourZoneDistribution.cls
 * @Description        :  Structure de réponse de API Zones distributions
 * @Author             : Sara El-Hannaoui
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 08/01/2020 à 14:42:22
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    08/01/2020   Sara El-Hannaoui     Initial Version
 **/
public with sharing class HP_WRP008_APIHourZoneDistribution {


	@AuraEnabled
	public String codeDistributeur;

	@AuraEnabled
	public String libelleDistributeur;

	@AuraEnabled
	public String codeDepartement;

	@AuraEnabled
	public String codeInsee;

	@AuraEnabled
	public String codePostal;

	@AuraEnabled
	public String nomCommune;

	@AuraEnabled
	public String codeTypeEnergie;

	@AuraEnabled
	public String libelleTypeEnergie;

	@AuraEnabled
	public String appartientRegie;

	@AuraEnabled
	public String typeDistributeur;


}