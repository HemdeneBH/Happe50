/**
 * @File Name          : HP_WRP013_AgilabClientInfo.cls
 * @Description        : Structure de réponse d'un statut de client aidé Agilab
 * @Author             : Sara El-Hannaoui
 * @Group              :
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 10-12-2021
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    16/01/2020   Sara El-Hannaoui     Initial Version
 **/
public with sharing class HP_WRP013_AgilabClientInfo {
	public String status;
	public String message;
	public Output output;

	public class Output {
		public List<Logement> logements;
		public Cheque cheque_energie;
		public Surendettement surendettement;
	}

	public class Logement {
		public String id_contrat_xdata;
		public String id_portefeuille_contrat_xdata;
		public Blocage blocage_a_la_relance;
		public Aide aide;
		public Mediation mediation;
	}

	public class Cheque {
		public String date_debut_attribution_cheque_energie;
		public String date_fin_attribution_cheque_energie;
	}

	public class Surendettement {
		public String surendettement_en_cours;
		public String gestionnaire_de_dossier;
	}

	public class Blocage {
		public String date_debut_blocage;
		public String date_fin_blocage;
		public String motif_de_blocage;
		public String commentaire_de_blocage;
		public String date_deblocage;
	}

	public class Aide {
		public String date_de_debut_aide;
		public String date_de_fin_aide;
		public String en_attente_dattribution_daide_sociale;
		public String date_reception_lettre_engagement;
	}

	public class Mediation {
		public Boolean mediation_en_cours;
		public String motif_mediation;
	}

	public static HP_WRP013_AgilabClientInfo parseMap(Map<String,Object> inputMap){
		System.debug('HP_WRP013_AgilabClientInfo.parseMap | Method Start');
		HP_WRP013_AgilabClientInfo clientInfo = new HP_WRP013_AgilabClientInfo();
		Output objOutput = new Output();
		List<Logement> listLogement = new List<Logement>();
		Map<String, Object> outputMap = (Map<String, Object>)  inputMap.get('output');
		String key='';
		Integer i=1;
		do {
			key = 'logement_'+i;
			if(outputMap.containsKey(key)){
				Logement tempLogement = new Logement();
				Blocage tempBlocage = new Blocage();
				Aide tempAide = new Aide();
				Mediation tempMediation = new Mediation();
				Map<String,Object> tempMap = (Map<String,Object>) outputMap.get(key);
				Map<String,Object> tempMapBlocage = (Map<String,Object>) tempMap.get('blocage_a_la_relance');
				Map<String,Object> tempMapAide = (Map<String,Object>) tempMap.get('aide');
				Map<String,Object> tempMapMediation = (Map<String,Object>) tempMap.get('mediation');

				tempLogement.id_contrat_xdata = (String) tempMap.get('id_contrat_xdata');
				tempLogement.id_portefeuille_contrat_xdata = (String) tempMap.get('id_portefeuille_contrat_xdata');

				tempBlocage.commentaire_de_blocage = (String) tempMapBlocage.get('commentaire_de_blocage');
				tempBlocage.date_deblocage = (String) tempMapBlocage.get('date_deblocage');
				tempBlocage.date_debut_blocage = (String) tempMapBlocage.get('date_debut_blocage');
				tempBlocage.date_fin_blocage = (String) tempMapBlocage.get('date_fin_blocage');
				tempBlocage.motif_de_blocage = (String) tempMapBlocage.get('motif_de_blocage');

				tempAide.date_de_debut_aide = (String) tempMapAide.get('date_de_debut_aide');
				tempAide.date_de_fin_aide = (String) tempMapAide.get('date_de_fin_aide');
				tempAide.date_reception_lettre_engagement = (String) tempMapAide.get('date_reception_lettre_engagement');
				tempAide.en_attente_dattribution_daide_sociale = (String) tempMapAide.get('en_attente_dattribution_daide_sociale');

				tempMediation.mediation_en_cours = (Boolean) tempMapMediation.get('mediation_en_cours');
				tempMediation.motif_mediation = (String) tempMapMediation.get('motif_mediation');

				tempLogement.aide = tempAide;
				tempLogement.blocage_a_la_relance = tempBlocage;
				tempLogement.mediation = tempMediation;

				listLogement.add(tempLogement);
			}
			i++;
		} while (outputMap.containsKey(key));
		
		Cheque tempCheque = new Cheque();
		Surendettement tempSurendettement = new Surendettement();
		Map<String,Object> tempMapCheque = (Map<String,Object>) outputMap.get('cheque_energie');
		Map<String,Object> tempMapSurendettement = (Map<String,Object>) outputMap.get('surendettement');
	    tempCheque.date_debut_attribution_cheque_energie = (String) tempMapCheque.get('date_debut_attribution_cheque_energie');
		tempCheque.date_fin_attribution_cheque_energie = (String) tempMapCheque.get('date_fin_attribution_cheque_energie');
		tempSurendettement.surendettement_en_cours = (String) tempMapSurendettement.get('surendettement_en_cours');
		tempSurendettement.gestionnaire_de_dossier = (String) tempMapSurendettement.get('gestionnaire_de_dossier');

		objOutput.logements = listLogement;
		objOutput.cheque_energie = tempCheque;
		objOutput.surendettement = tempSurendettement;
		
		clientInfo.output = objOutput;
		clientInfo.message = (String) inputMap.get('message');
		clientInfo.status = (String) inputMap.get('status');

		System.debug('HP_WRP013_AgilabClientInfo.parseMap | Method Exit');
		return clientInfo;
	}
}