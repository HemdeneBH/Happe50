/**
 * @File Name          : HP_ContractToUpdate.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 01-04-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    03/02/2020   Vincent Albiser     Initial Version
**/
//US HAPP-283
public class HP_ContractToUpdate {

	//public String id;
	public String codeStatutCrm;
	public String statut;
	public String dateFinValidite;
	public String dateDebutContrat;
	public String dateDebutValidite;
	//public String codeStatutPosteContrat;

	public HP_ContractToUpdate(String codeStatutCRM, String statut, String dateFinValidite, String dateDebutContrat, String dateDebutValidite) {
		//this.id = id;
		this.codeStatutCrm = codeStatutCRM;
		this.statut = statut;
		this.dateFinValidite = dateFinValidite;
		this.dateDebutContrat = dateDebutContrat;
		this.dateDebutValidite = dateDebutValidite;
    }

	public HP_ContractToUpdate(String codeStatutCRM, String statut, String dateFinValidite) {
		//this.id = id;
		this.codeStatutCrm = codeStatutCRM;
		this.statut = statut;
		this.dateFinValidite = dateFinValidite;
    }
}