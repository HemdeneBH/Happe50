/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-17-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   09-17-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public class HP_DistributorEnergyContractResponse implements HP_ConversionUtils.ExternalType {

	public static final String OCT_MESSAGE_OUT1_ELEC = 'OCTOPUS_CreerPrestationServiceElectricite_01';

	public String idPrestationServiceDistributeur;
	public String code;
	public DateTime dateEffetPrevue;
	public String libelle;
	public Boolean prestationServiceDistributeurCree;
	public Boolean prestationServiceFournisseurCree;

	public HP_EnergyContractResponse toCoreType() {
		final Boolean isSuccess = (this.code == OCT_MESSAGE_OUT1_ELEC && this.prestationServiceDistributeurCree == true);
		return new HP_EnergyContractResponse(this.idPrestationServiceDistributeur, this.dateEffetPrevue, isSuccess);
	}

}