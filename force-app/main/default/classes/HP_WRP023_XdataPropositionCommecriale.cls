/**
 * @File Name          : HP_WRP023_XdataPropositionCommecriale.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 11-15-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_WRP023_XdataPropositionCommecriale {
    public Integer id;
	public Integer idPortefeuilleContrat;
	public Integer idPersonne;
	public String codePack;
	public String codeStatutPropositionCommercialeHeader;
	public String libelleStatutPropositionCommercialeHeader;
	public String libellePack;
	public String codeStatutPropositionCommercialePoste;
	public String libelleStatutPropositionCommercialePoste;
	public Integer idProduitOffreService;//HP_SLCT_OpportunityLineItem.EngieProductCode
	public List<Poste> postes;

    public HP_WRP023_XdataPropositionCommecriale(Integer idPortefeuilleContrat, Integer idPersonne, String productCode, String codeStatutPropositionCommercialeHeader,String codeStatutPropositionCommercialePoste ) {
        this.idPortefeuilleContrat = idPortefeuilleContrat;
		this.idPersonne =idPersonne;
		if(!String.isBlank(productCode)){
			this.postes = new List<Poste> {new Poste(Integer.valueOf(HP_UTIL_CustomSetting.getOffrebyCodeOffre(productCode).offreId__c), codeStatutPropositionCommercialePoste)};
		}
        //this.postes = new List<Poste> {new Poste(Integer.valueOf(HP_UTIL_CustomSetting.getOffrebyCodeOffre(productCode).offreId__c))};
        this.idProduitOffreService = idProduitOffreService;
        this.codeStatutPropositionCommercialeHeader = codeStatutPropositionCommercialeHeader;
		this.codeStatutPropositionCommercialePoste = codeStatutPropositionCommercialePoste;

		codePack = 'HAPPE_P';
    }
	public class Poste {
		public Integer idProduitOffreEtService;
		public String codeStatutPropositionCommercialePoste;
        public Poste(final Integer idProduitOffreEtService, final String codeStatutPropositionCommercialePoste) {
			this.idProduitOffreEtService = idProduitOffreEtService;
			this.codeStatutPropositionCommercialePoste = codeStatutPropositionCommercialePoste;

		}
	}
}