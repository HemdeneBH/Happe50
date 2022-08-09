/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-26-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   03-26-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class HP_DistributorEnergyResponse implements HP_ConversionUtils.ExternalType {

	// sorties PDLElec
	public String etatContractuelcode; // ECRES ECRAC IMPRO INACCE
	public String etatAlimentationcode; // COUP LIMI NALI NRAC ALIM
	public String niveauOuvertureServicescode; // 1 or 2
	public String sIContactuelcode;   // GINKO
	public String formuleTarifaireAcheminementcode; //FIXME check usage
	public String code; // code message retour
	public String libelle; // libelle message retour
	// Flyout PDL
	public String contratID;
	public String etatContractuelLibelle;
	public Integer puissanceSouscriteValeur;
	public String puissanceSouscriteUnite;
	public Integer nbCadrans;
	public String typeComptageLibelle;
	public String niveauOuvertureServicesLibelle;


	private static final Map<String, Boolean> ALIMENTATION = new Map<String, Boolean> {'COUP' => true, 'LIMI' => true, 'NALI' => true, 'NRAC' => true};
	private static final Map<String, Boolean> ALIM = new Map<String, Boolean> {'ALIM' => true, '' => true, NULL => true};
	private static final Map<String, Boolean> ECRES = new Map<String, Boolean> {'ECRES' => true};
	private static final Map<String, Boolean> CONTRACT = new Map<String, Boolean> {'ECRAC' => true, 'IMPRO' => true, 'NRAC' => true, 'INACCE' => true};

	public Boolean isOnsiteIntervention(String etatalim, String etatcontract) {
		return (ALIMENTATION.containsKey(etatalim) || ((ALIM.containsKey(etatalim) && ECRES.containsKey(etatcontract))) || (ALIM.containsKey(etatalim) && CONTRACT.containsKey(etatcontract)));
	}

	public boolean isSmartMeter(String sIContractuel, String niveauOuvertureServicescode){
		return ( sIContractuel == 'GINKO' && (niveauOuvertureServicesCode == '1' || niveauOuvertureServicesCode == '2' ) );
	}

	public HP_EnergyResponse toCoreType() {
		return new HP_EnergyResponse(
			isOnsiteIntervention(this.etatAlimentationcode, this.etatContractuelcode),
			isSmartMeter(this.sIContactuelcode, this.niveauOuvertureServicescode),
			this.contratID,
			this.etatContractuelLibelle,
			this.puissanceSouscriteValeur,
			this.puissanceSouscriteUnite,
			this.nbCadrans,
			this.typeComptageLibelle,
			this.niveauOuvertureServicescode,
			this.niveauOuvertureServicesLibelle
			);
	}
	public HP_DistributorEnergyResponse(final List<gdfsuezComBefCalypsoPdlelectricite.PDLElectricite> pdlList) {
		final List<gdfsuezComBefCalypsoPdlelectricite.donneesGenerales_element> donneesGenerales = pdlList[0].donneesGenerales;
		if( pdlList[0].donneesGenerales != null ) {
			if( pdlList[0].donneesGenerales[0].etatContractuel != null ) {
				this.etatContractuelcode = pdlList[0].donneesGenerales[0].etatContractuel.code;
				this.etatContractuelLibelle = pdlList[0].donneesGenerales[0].etatContractuel.libelleCourt;
			}
			if( pdlList[0].donneesGenerales[0].niveauOuvertureServices != null ) {
				this.niveauOuvertureServicesLibelle = pdlList[0].donneesGenerales[0].niveauOuvertureServices.libelleCourt;
				this.niveauOuvertureServicescode = pdlList[0].donneesGenerales[0].niveauOuvertureServices.code;
			}
			if( pdlList[0].situationAlimentation != null  && pdlList[0].situationAlimentation[0].etatAlimentation != null ) {
				this.etatAlimentationcode = pdlList[0].situationAlimentation[0].etatAlimentation.code;
			}
		}

		if( pdlList[0].situationContractuelle != null ) {
			System.debug('contract id ########'+pdlList[0].situationContractuelle[0]);
			if(pdlList[0].situationContractuelle[0].contratID != null) {
				this.contratId = pdlList[0].situationContractuelle[0].contratID;
			}
			if(pdlList[0].situationContractuelle[0].sIContractuel != null) {
				this.sIContactuelcode = pdlList[0].situationContractuelle[0].sIContractuel.code;
			}
			if( pdlList[0].situationContractuelle[0].structureTarifaire != null ) {
				if( pdlList[0].situationContractuelle[0].structureTarifaire.formuleTarifaireAcheminement != null ) {
					this.formuleTarifaireAcheminementcode = pdlList[0].situationContractuelle[0].structureTarifaire.formuleTarifaireAcheminement.code;
				}
				if(pdlList[0].situationContractuelle[0].structureTarifaire.puissanceSouscriteMax != null ) {
					this.puissanceSouscriteValeur = pdlList[0].situationContractuelle[0].structureTarifaire.puissanceSouscriteMax.valeur;
					this.puissanceSouscriteUnite = pdlList[0].situationContractuelle[0].structureTarifaire.puissanceSouscriteMax.unite;
				}
			}
		}

		if (pdlList[0].situationComptage != null && pdlList[0].situationComptage[0].dispositifComptage != null) {
			if( pdlList[0].situationComptage[0].dispositifComptage.compteurs.compteur[0].modeleCompteur.nbCadrans != null) {
				this.nbCadrans = pdlList[0].situationComptage[0].dispositifComptage.compteurs.compteur[0].modeleCompteur.nbCadrans;
			}
			if ( pdlList[0].situationComptage[0].dispositifComptage.typeComptage.code != null) {
				this.typeComptageLibelle = pdlList[0].situationComptage[0].dispositifComptage.typeComptage.code;
			}
		}
	}
}