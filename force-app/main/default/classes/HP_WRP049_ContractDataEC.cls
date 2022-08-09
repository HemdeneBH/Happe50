/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 03-24-2022
 * @last modified by  : Clément Bauny
**/
public class HP_WRP049_ContractDataEC {

	public String key {get;set;} 
	public List<Data> x_data {get;set;} // in json: _data

	public HP_WRP049_ContractDataEC(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'key') {
						key = parser.getText();
					} else if (text == '_data') {
						x_data = arrayOfData(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'HP_WRP049_ContractDataEC consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Links {
		public String self {get;set;} 

		public Links(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'self') {
							self = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Links consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Data {
		public Integer id {get;set;} 
		public Integer idPortefeuilleContrat {get;set;} 
		public Integer idPersonne {get;set;} 
		public Object numeroContratISU {get;set;} 
		public String energie {get;set;} 
		public String statut {get;set;} 
		public String codeStatutCrm {get;set;} 
		public String libelleStatutCrm {get;set;} 
		public Integer dureeContratEnMois {get;set;} 
		public Object dateEmmenagement {get;set;} 
		public Object dateDemenagement {get;set;} 
		public String dateDebutContrat {get;set;} 
		public String dateFinContrat {get;set;} 
		public Boolean facture {get;set;} 
		public Object numeroContratCRM {get;set;} 
		public Object numeroInstallation {get;set;} 
		public Integer idOffre {get;set;} 
		public String offre {get;set;} 
		public String codeOffre {get;set;} 
		public Integer idInstallation {get;set;} 
		public Integer idPointDeLivraison {get;set;} 
		public Integer idPack {get;set;} 
		public String dateDebutValidite {get;set;} 
		public String dateFinValidite {get;set;} 
		public Object numeroContratExterne {get;set;} 
		public Integer idPropositionCommerciale {get;set;} 
		public Integer idAgence {get;set;} 
		public Integer idFoyer {get;set;} 
		public Object codeEquipement {get;set;} 
		public Object libelleEquipement {get;set;} 
		public Links x_links {get;set;} // in json: _links

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'idPortefeuilleContrat') {
							idPortefeuilleContrat = parser.getIntegerValue();
						} else if (text == 'idPersonne') {
							idPersonne = parser.getIntegerValue();
						} else if (text == 'numeroContratISU') {
							numeroContratISU = parser.readValueAs(Object.class);
						} else if (text == 'energie') {
							energie = parser.getText();
						} else if (text == 'statut') {
							statut = parser.getText();
						} else if (text == 'codeStatutCrm') {
							codeStatutCrm = parser.getText();
						} else if (text == 'libelleStatutCrm') {
							libelleStatutCrm = parser.getText();
						} else if (text == 'dureeContratEnMois') {
							dureeContratEnMois = parser.getIntegerValue();
						} else if (text == 'dateEmmenagement') {
							dateEmmenagement = parser.readValueAs(Object.class);
						} else if (text == 'dateDemenagement') {
							dateDemenagement = parser.readValueAs(Object.class);
						} else if (text == 'dateDebutContrat') {
							dateDebutContrat = parser.getText();
						} else if (text == 'dateFinContrat') {
							dateFinContrat = parser.getText();
						} else if (text == 'facture') {
							facture = parser.getBooleanValue();
						} else if (text == 'numeroContratCRM') {
							numeroContratCRM = parser.readValueAs(Object.class);
						} else if (text == 'numeroInstallation') {
							numeroInstallation = parser.readValueAs(Object.class);
						} else if (text == 'idOffre') {
							idOffre = parser.getIntegerValue();
						} else if (text == 'offre') {
							offre = parser.getText();
						} else if (text == 'codeOffre') {
							codeOffre = parser.getText();
						} else if (text == 'idInstallation') {
							idInstallation = parser.getIntegerValue();
						} else if (text == 'idPointDeLivraison') {
							idPointDeLivraison = parser.getIntegerValue();
						} else if (text == 'idPack') {
							idPack = parser.getIntegerValue();
						} else if (text == 'dateDebutValidite') {
							dateDebutValidite = parser.getText();
						} else if (text == 'dateFinValidite') {
							dateFinValidite = parser.getText();
						} else if (text == 'numeroContratExterne') {
							numeroContratExterne = parser.readValueAs(Object.class);
						} else if (text == 'idPropositionCommerciale') {
							idPropositionCommerciale = parser.getIntegerValue();
						} else if (text == 'idAgence') {
							idAgence = parser.getIntegerValue();
						} else if (text == 'idFoyer') {
							idFoyer = parser.getIntegerValue();
						} else if (text == 'codeEquipement') {
							codeEquipement = parser.readValueAs(Object.class);
						} else if (text == 'libelleEquipement') {
							libelleEquipement = parser.readValueAs(Object.class);
						} else if (text == '_links') {
							x_links = new Links(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static HP_WRP049_ContractDataEC parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new HP_WRP049_ContractDataEC(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	


    private static List<Data> arrayOfData(System.JSONParser p) {
        List<Data> res = new List<Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Data(p));
        }
        return res;
    }
}