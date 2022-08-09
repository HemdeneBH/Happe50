/**
 * @File Name          : HP_Contract.cls
 * @Description        : 
 * @Author             : mouhamadoune.coulybaly@external.engie.com
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 24/01/2020 à 11:16:33
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/12/2019   mouhamadoune.coulybaly@external.engie.com     Initial Version
**/
public with sharing class HP_Contract {
    public final Integer id;
    public final Integer installationId;
	public final Integer personId;
    public final String energyType;
	public final String contractNumberCRM;
    public final String codeStatutCrm;
	public final String status;
    public final String dateDebutContrat;
	public final String dateFinContrat;
    public final Integer idPropositionCommerciale;
	public final Integer idPortefeuilleContrat ;
	public final String offre;
    public final String libelleStatutCrm;
    public final String idOffre;
public enum Status { //TODO add to opportunity stage ?

// Demande rejetée	H0104
		AwaitingEnergyDistributor,// En att,ente distributeur	H0101 // HAPP-283
		EnergyDistributorError,// KO Distributeur	H0102 //HAPP-387
// Contrat Actif	E0004
		InCancellation,// En résiliation	E0007
        Terminated,// Résilié	E0009
        CANCELLATION_NOT_DONE
// Résilié débiteur	H0103
// Contrat créée	H0105
	}
}