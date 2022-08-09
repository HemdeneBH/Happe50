/**
 * @File Name          : HP_EM004_FactureManager.cls
 * @Description        : class permet de gerer les facture
 * @Author             : Slimene Belhaj Ali
 * @Group              : 
 * @Created On         : 09/01/2020
**/
public with sharing class HP_EM006_FactureManager {
    
    private static final String ENDPOINT_MODIFIER_MODE_ENVOI =  '/propositions/modifier_mode_denvoi_factures?';
    /**
    * @description modifier le mode d'envoi facture
    * @author Slimene Belhaj Ali | 09/01/2020
    * @param String contractId Xdata contact Id 
    * @param String agilabStatus Statut de mode d'envoi { 1 => Electronique, 2 => Papier }
    * @return HP_PortailUtilisateur__c 
    **/
    public static Map<Integer, String> updateFactureModeEnvoi(String contractId, Integer agilabStatus){
		System.debug('@@@ contractId ' + contractId + '  ' + agilabStatus);
		String param = 'id_contrat_xdata='+ContractId + '&mode_denvoi_factures='+agilabStatus; 
		Map<Integer, String> responseNoteMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_MODIFIER_MODE_ENVOI_FACTURE, param);
		System.debug('Response =============================' + responseNoteMap);
		return responseNoteMap;
	}

  public static Map<String, Object> updateEnergieVert(String contractId, String energieVert, String profil){
		Map<String, String> paramMap = new Map<String, String>{'id_contrat_xdata' => contractId, 'option_vert' => energieVert, 'profil' => profil};
    HTTPResponse res = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_PROPOSITION_MODIFIER, paramMap);
    Map<String, Object> bodyMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
    Map<String, Object> result = new Map<String, Object>();
    result.put('status', res.getStatusCode());
    result.put('message', result.get('message'));
		return result;
	}

  public static Map<String, Object> loadEnergieVerOption(String contractId){
    HTTPResponse res = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_HAPPE_ENEGIE_VERT, 'id_contrat_xdata=' + contractId);
    return (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
	}
}