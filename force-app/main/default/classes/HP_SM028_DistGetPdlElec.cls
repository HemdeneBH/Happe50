/**
 * @File Name          : HP_SM028_DistGetPdlElec.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 28/04/2020 à 06:05:14
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/03/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_SM028_DistGetPdlElec implements HP_PreContractService {

	public class EnergyDistributorException extends Exception {}

	public HP_EnergyResponse retrieveEnergyMeterInformations(HP_EnergyRequest energyrequest ){
		gdfsuezComBefChpPivot.contextDt octx = HP_OctopusUtils.buildContext(HP_Constantes.WS_ES_OCTOPUS_CONTEXT, HP_constantes.WS_ES_OCTOPUS_VERSION);
		gdfsuezBefCalypsoPdlelectriciteV3.Dependency port = new gdfsuezBefCalypsoPdlelectriciteV3.Dependency();
		port.endpoint_x = HP_OctopusUtils.END_POINT + HP_Constantes.WS_ES_OCTOPUS_PDLELEC_NAME;
		port.inputHttpHeaders_x = new Map < String, String > {
			HP_OctopusUtils.CONTENT_TYPE => HP_OctopusUtils.CHARSET
		};
		gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteInputDt lirePDLElecinput = buildInputParameters(energyrequest);
		final gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteResponse_element response = port.LirePDLElectricite(lirePDLElecinput, octx);
		System.debug(JSON.serializePretty(response, true));
		if ((response.lirePDLElectriciteOutput != null) && (response.lirePDLElectriciteOutput.donneesPDL != null)) {
			return (new HP_DistributorEnergyResponse(response.lirePDLElectriciteOutput.donneesPDL).toCoreType());
		}
		if((response.messageRetours != null) && (response.messageRetours.retourTraitementMessage != null)) {
			final List<gdfsuezComBefChpPivot.retourTraitementMessageDt> pdlMessageRetours = response.messageRetours.retourTraitementMessage;
			throw new EnergyDistributorException(pdlMessageRetours[0].libelle);
		}
		throw new EnergyDistributorException();
	}

	private static gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteInputDt buildInputParameters(final HP_EnergyRequest energyrequest) {
		final gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteInputDt lirePDLElecinput = new gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteInputDt();
		gdfsuezBefCalypsoPdlelectriciteV3.PDLElectricite_element element= new   gdfsuezBefCalypsoPdlelectriciteV3.PDLElectricite_element();
		//lirePDLElecinput.historiqueConsommations = true; FIXME remove 
		lirePDLElecinput.online = true;
		lirePDLElecinput.loginUtilisateur = HP_SLCT_User.retriveUser(System.UserInfo.getUserId()).Distributor_Login__c;
		if(lirePDLElecinput.loginUtilisateur == null || lirePDLElecinput.loginUtilisateur == '') {
			lirePDLElecinput.loginUtilisateur = HP_UTIL_MetadataManager.getConfigByKey('HP_LOGIN_ELEC');
		}

		element.PDLElectricite = new gdfsuezComBefCalypsoPdlelectricite.PDLElectriciteAbstract();
		element.PDLElectricite.idPDLElectricite = energyrequest.energyMeterId;
		element.accordFournisseurNonTitulaire = new gdfsuezBefCalypsoPdlelectriciteV3.accordFournisseurNonTitulaire_element();
		element.accordFournisseurNonTitulaire.autorisationClient = true;
		lirePDLElecinput.PDLElectricite = new gdfsuezBefCalypsoPdlelectriciteV3.PDLElectricite_element[] {
			element
		};
		return lirePDLElecinput;
	}
}