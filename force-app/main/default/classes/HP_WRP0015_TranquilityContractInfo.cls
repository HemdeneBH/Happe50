/**
 * @author Sara El-Hannaoui
 * @date Creation 12/12/2019
 * @description Structure de réponse des infos de contrat Tranquility
 */
public with sharing class HP_WRP0015_TranquilityContractInfo {
	@AuraEnabled
    public OutputMessage messageRetour {get;set;}
	@AuraEnabled
	public OutputContrat[]  contratList {get;set;}

	public class OutputMessage {
		@AuraEnabled
		public String code;
		@AuraEnabled
		public String libelle;
		@AuraEnabled
		public ObjetErreur[] erreurList;
		@AuraEnabled
		public ObjetErreur objetErreur;
	}

	
	public class TranquilityRequest {
		@AuraEnabled
		public String idConsomateur;
		@AuraEnabled
		public String bpClient;
		@AuraEnabled
		public Integer idContrat;
		public TranquilityRequest(String bpClient, String idConsomateur){
			this.idConsomateur = idConsomateur;
			this.bpClient = bpClient;
		}
	}

	

	public class OutputContrat {
		@AuraEnabled
		public Integer idContrat;
		@AuraEnabled
		public String libOffre;
		@AuraEnabled
		public Date dateEffet;
		@AuraEnabled
		public Date dateResiliation;
		@AuraEnabled
		public Local localAssure;
		/* public EtatContrat etatContrat;
		public Boolean modifiable;
		public Integer statutContrat;
		public String coupon;
		public String idOffre;
		public Decimal prixAn;
		public Decimal prixMois;
		public String prixAn2;
		public String prixMois2;
		public String canal;
		public Datetime dateModification;
		public Date heureEffet;
		public ConseillerDetail conseillerDetail;
		public Integer idParent;
		public String orderId;
		public Client client;
	
		public ModePaiement paiementMode;
		public SignatureElec signatureElec;
		public String motifResiliation; */ 



	}

	public class Client {
		@AuraEnabled
		public String bpClient;
		@AuraEnabled
		public String nom;
		@AuraEnabled
		public String prenom;
		@AuraEnabled
		public String civilite;
		@AuraEnabled
		public String numRue;
		@AuraEnabled
		public String rue;
		@AuraEnabled
		public String codePostal;
		@AuraEnabled
		public String commune;
		@AuraEnabled
		public String pays;
		@AuraEnabled
		public String telmobile;
		@AuraEnabled
		public String telDomicile;
		@AuraEnabled
		public String email;

	}

	public class Local {
		@AuraEnabled
		public String numRue;
		@AuraEnabled
		public String rue;
		@AuraEnabled
		public Integer codePostal;
		@AuraEnabled
		public String commune;
		@AuraEnabled
		public String pays;
		@AuraEnabled
		public String ville;
		@AuraEnabled
		public String complement;
		@AuraEnabled
		public String batiment;
		@AuraEnabled
		public String escalier;
	}

	public class ModePaiement {
		@AuraEnabled
		public String libellePaiement;
		@AuraEnabled
		public String modePrelevement;
	}

	public class SignatureElec {
		@AuraEnabled
		public String signature;
	}

	public class conseillerDetail {
		@AuraEnabled
		public String nom;
		@AuraEnabled
		public String prenom;
		@AuraEnabled
		public String bpConseiller;
		@AuraEnabled
		public String gaia;
	}

	public class EtatContrat {
		@AuraEnabled
		public Integer etat;
		@AuraEnabled
		public String libEtat;
	}

	public class ObjetErreur {
		@AuraEnabled
		public String libObjet;
		@AuraEnabled
		public String libErreur;
	}
}