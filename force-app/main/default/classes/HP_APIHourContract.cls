/**
 * @File Name          : HP_APIHourContract.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 28/04/2020 à 09:59:08
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/04/2020   Mouhamadoune Coulibaly     Initial Version
**/
public with sharing class HP_APIHourContract {
	public Integer id;
	// readOnly: true
	public Integer idPortefeuilleContrat;
	public Integer idPersonne;
	// numeroContratISU	string
	public String energie;
	public String codeStatutCrm;
	public String statut;	
	// dureeContratEnMois	integer
	// dateEmmenagement	string($date)
	// dateDemenagement	string($date)
	// dateDebutContrat	string($date)
	// dateFinContrat	string($date)
	// facture	boolean
	// numeroInstallation	string
	public String numeroContratCRM;
	public String idOffre;
	public String offre	;
	public String libelleStatutCrm;
	// codeOffre	string
	public Integer idInstallation;
	// idPointDeLivraison	integer
	public String dateDebutContrat;	
	public String dateFinContrat;
	// numeroContratExterne	string
	public Integer idPropositionCommerciale;

    public HP_Contract toCoreType() {
        return new HP_Contract(
			this.id,
			this.idInstallation,
			this.energie,
			this.idPersonne,
			this.numeroContratCRM,
			this.codeStatutCrm,
			this.statut,
			this.dateDebutContrat,
			this.dateFinContrat,
			this.idPropositionCommerciale,
			this.idPortefeuilleContrat,
			this.offre,
			this.libelleStatutCrm,
			this.idOffre

		);
    }
}