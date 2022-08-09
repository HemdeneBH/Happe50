/**
 * @File Name          : HP_SM029_DistGetPdlGaz.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 03-14-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/03/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_SM029_DistGetPdlGaz implements HP_PreContractService {//FIXME naming

	private static final String END_POINT_PDLGAS = 'ES-PDLGaz_v2';//FIXME check was smile instead of engie, without namedCredential...
	private static final String DISTRIBUTOR_SMART_METER_CODE = '3';
	private static final String DISTRIBUTOR_EXTINCT_SERVICE_CODE = 'coupe';

	public class HP_GasDistributorDeliveryPointResponse implements HP_ConversionUtils.ExternalType {
		private final gdfsuezBefCalypsoPdlgazV2.PDLGaz deliveryPoint;
		private final String enrolmentType;
		private String contractualState;
		private Integer gazAnnualConsumption;
		private String deliveryPointStreetName;
		private String deliveryPointStreetNumber;
		private String deliveryPointCity;
		private String deliveryPointPostalCode;

		public HP_EnergyResponse toCoreType() {
			return new HP_EnergyResponse(
				this.isOnSiteIntervention(),
				this.isSmartMeter(),
				this.contractualState,
				this.gazAnnualConsumption,
				this.meterType(),
				this.deliveryPointStreetName,
				this.deliveryPointStreetNumber,
				this.deliveryPointCity,
				this.deliveryPointPostalCode
				);
		}
		public HP_GasDistributorDeliveryPointResponse(final gdfsuezBefCalypsoPdlgazV2.lirePDLGazResponse_element response, final String enrolmentType) {
			final List<gdfsuezBefCalypsoPdlgazV2.PDLGaz> deliveryPointList = response.lirePDLGazOutput.donneesPDL;
			this.deliveryPoint = (((deliveryPointList != null) && (!deliveryPointList.isEmpty())) ? (deliveryPointList[0]) : (null));
			this.enrolmentType = enrolmentType;
			if (this.deliveryPoint != null) {
				if (this.deliveryPoint.installation != null && this.deliveryPoint.installation.compteur != null && this.deliveryPoint.installation.compteur.etatTechnique != null) {
					this.contractualState =  this.deliveryPoint.installation.compteur.etatTechnique.libelleCourt;
				}
				if (this.deliveryPoint.CAR != null && this.deliveryPoint.CAR.CAR_Actuelle != null) {
					this.gazAnnualConsumption = this.deliveryPoint.CAR.CAR_Actuelle.valeurCAR;
				}
				if(this.deliveryPoint.adresse != null){
					this.deliveryPointStreetName = this.deliveryPoint.adresse.libelleVoie;
					this.deliveryPointStreetNumber = this.deliveryPoint.adresse.nVoie;
					this.deliveryPointCity = this.deliveryPoint.adresse.ville;
					this.deliveryPointPostalCode = this.deliveryPoint.adresse.cP;
				}
			}
		}
		private String meterType(){
			return (
				(this.deliveryPoint != null && this.deliveryPoint.Gazpar != null && this.deliveryPoint.Gazpar.etatPDL != null && this.deliveryPoint.Gazpar.etatPDL.code != null  && (this.deliveryPoint.Gazpar.etatPDL.code.equals('3') || this.deliveryPoint.Gazpar.etatPDL.code.equals('2') || this.deliveryPoint.Gazpar.etatPDL.code.equals('1')))
				? ('Compteur Gazpar')
				: ('Compteur Gaz')
				);
		}

		private Boolean isSmartMeter() {
			return (
				(this.deliveryPoint != null)
				&& (this.deliveryPoint.Gazpar != null)
				&& (this.deliveryPoint.Gazpar.etatPDL != null)
				&& (this.deliveryPoint.Gazpar.etatPDL.code == DISTRIBUTOR_SMART_METER_CODE)
				);
		}

		private Boolean isOnSiteIntervention() {
			return (
				(this.deliveryPoint != null)
				&& (
					((this.enrolmentType == 'MOVING_IN') && ((this.deliveryPoint.Gazpar != null) && (this.deliveryPoint.Gazpar.dateRefusTelereleve != null)))
					|| (((this.deliveryPoint.donneesContractuelles != null) && (this.deliveryPoint.donneesContractuelles.miseHorsServiceEnCours == true))
					    && (((this.deliveryPoint.installation != null) && (this.deliveryPoint.installation.compteur != null))
					        && ((this.deliveryPoint.installation.compteur.DGI == true)
					            || (((this.deliveryPoint.installation.compteur.etatTechnique != null) && (this.deliveryPoint.installation.compteur.etatTechnique.code == DISTRIBUTOR_EXTINCT_SERVICE_CODE))))
					        )
					    )
					)
				);
		}
	}

	public HP_EnergyResponse retrieveEnergyMeterInformations(final HP_EnergyRequest energyRequest){
		gdfsuezComBefChpPivot.contextDt context = HP_OctopusUtils.buildContext('0', HP_OctopusUtils.VERSION1);
		gdfsuezBefCalypsoPdlgazV2.Dependency port =
			(gdfsuezBefCalypsoPdlgazV2.Dependency)HP_OctopusUtils.buildPort(END_POINT_PDLGAS, gdfsuezBefCalypsoPdlgazV2.Dependency.class);
		return (
			new HP_GasDistributorDeliveryPointResponse(
				port.LirePDLGaz_Http((gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt)this.buildInputParameters(energyRequest), context),
				energyRequest.enrolmentType
				).toCoreType()
			);
	}

	private Object buildInputParameters(final HP_EnergyRequest energyRequest) {
		final gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt lirePDLGazInput = new gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt();
		lirePDLGazInput.loginUtilisateur = HP_SLCT_User.retriveUser(System.UserInfo.getUserId()).Distributor_Login__c;
		if(lirePDLGazInput.loginUtilisateur == null || lirePDLGazInput.loginUtilisateur == '') {
			lirePDLGazInput.loginUtilisateur = HP_UTIL_MetadataManager.getConfigByKey('HP_LOGIN_GAZ');
		}
		
		lirePDLGazInput.online = true;
		gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt_PDLGaz_element pDLGaz = new gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt_PDLGaz_element();
		gdfsuezComBefCalypsoPdlgaz.PDLGazAbstract pdlgazAstract = new gdfsuezComBefCalypsoPdlgaz.PDLGazAbstract();
		pdlgazAstract.idPDLGaz =energyRequest.energyMeterId;
		pDLGaz.recupererDerniersIndexGaz = true;
		pDLGaz.AutorisationSituationContractuelle = true;
		pDLGaz.PDLGaz = pdlgazAstract;
		lirePDLGazInput.PDLGaz = pDLGaz;
		return lirePDLGazInput;
	}
}