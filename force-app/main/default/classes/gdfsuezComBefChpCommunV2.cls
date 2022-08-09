//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)
	
public class gdfsuezComBefChpCommunV2 {
	public class actionMajDt {
		public gdfsuezComBefChpCommunV2.listeValeursDt actionMaj;
		private String[] actionMaj_type_info = new String[]{'actionMaj','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'actionMaj'};
	}
	public class adresseDt {
		public String NVoie;
		public String complementAdresse;
		public String etage;
		public String libelleVoie;
		public gdfsuezComBefChpCommunV2.listeValeursDt departement;
		public String ville;
		public gdfsuezComBefChpCommunV2.listeValeursDt pays;
		public String CP;
		public String INSEE;
		public String servicePostauxBP;
		public String servicePostauxTSA;
		public String digicode;
		public String typeVoie;
		public String sigleBatiment;
		public String salle;
		public gdfsuezComBefChpCommunV2.listeValeursDt nonDistribution;
		public String chez;
		public String boitePostale;
		public String codeBoitePostale;
		public String autreVille;
		public String porte;
		public String escalier;
		public String groupeStructureRegionale;
		public String lieuDit;
		private String[] NVoie_type_info = new String[]{'NVoie','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] complementAdresse_type_info = new String[]{'complementAdresse','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] etage_type_info = new String[]{'etage','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] libelleVoie_type_info = new String[]{'libelleVoie','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] departement_type_info = new String[]{'departement','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] ville_type_info = new String[]{'ville','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] pays_type_info = new String[]{'pays','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] CP_type_info = new String[]{'CP','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] INSEE_type_info = new String[]{'INSEE','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] servicePostauxBP_type_info = new String[]{'servicePostauxBP','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] servicePostauxTSA_type_info = new String[]{'servicePostauxTSA','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] digicode_type_info = new String[]{'digicode','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] typeVoie_type_info = new String[]{'typeVoie','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] sigleBatiment_type_info = new String[]{'sigleBatiment','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] salle_type_info = new String[]{'salle','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] nonDistribution_type_info = new String[]{'nonDistribution','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] chez_type_info = new String[]{'chez','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] boitePostale_type_info = new String[]{'boitePostale','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] codeBoitePostale_type_info = new String[]{'codeBoitePostale','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] autreVille_type_info = new String[]{'autreVille','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] porte_type_info = new String[]{'porte','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] escalier_type_info = new String[]{'escalier','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] groupeStructureRegionale_type_info = new String[]{'groupeStructureRegionale','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] lieuDit_type_info = new String[]{'lieuDit','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'NVoie','complementAdresse','etage','libelleVoie','departement','ville','pays','CP','INSEE','servicePostauxBP','servicePostauxTSA','digicode','typeVoie','sigleBatiment','salle','nonDistribution','chez','boitePostale','codeBoitePostale','autreVille','porte','escalier','groupeStructureRegionale','lieuDit'};
	}
	public class blocageDt {
		public DateTime dateDebutBlocage;
		public DateTime dateFinBlocage;
		public gdfsuezComBefChpCommunV2.listeValeursDt motifBlocage;
		private String[] dateDebutBlocage_type_info = new String[]{'dateDebutBlocage','http://gdfsuez.com/bef/chp/commun/v2','dateTime','0','1','false'};
		private String[] dateFinBlocage_type_info = new String[]{'dateFinBlocage','http://gdfsuez.com/bef/chp/commun/v2','dateTime','0','1','false'};
		private String[] motifBlocage_type_info = new String[]{'motifBlocage','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'dateDebutBlocage','dateFinBlocage','motifBlocage'};
	}
	public class canalDt {
		public gdfsuezComBefChpCommunV2.listeValeursDt type_x;
		public Boolean prefere;
		public gdfsuezComBefChpCommunV2.logDt[] historiqueCanal;
		public String telephone;
		public gdfsuezComBefChpCommunV2.adresseDt adresse;
		public String mail;
		public Boolean utiliserDePreference;
		public Boolean stopDemande;
		private String[] type_x_type_info = new String[]{'type','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','1','1','false'};
		private String[] prefere_type_info = new String[]{'prefere','http://gdfsuez.com/bef/chp/commun/v2','boolean','0','1','false'};
		private String[] historiqueCanal_type_info = new String[]{'historiqueCanal','http://gdfsuez.com/bef/chp/commun/v2','logDt','0','-1','false'};
		private String[] telephone_type_info = new String[]{'telephone','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] adresse_type_info = new String[]{'adresse','http://gdfsuez.com/bef/chp/commun/v2','adresseDt','0','1','false'};
		private String[] mail_type_info = new String[]{'mail','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] utiliserDePreference_type_info = new String[]{'utiliserDePreference','http://gdfsuez.com/bef/chp/commun/v2','boolean','0','1','false'};
		private String[] stopDemande_type_info = new String[]{'stopDemande','http://gdfsuez.com/bef/chp/commun/v2','boolean','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'type_x','prefere','historiqueCanal','telephone','adresse','mail','utiliserDePreference','stopDemande'};
	}
	public class contextDt {
		public String version;
		public gdfsuezComBefChpCommunV2.contextDt_system_path_element system_path;
		public Boolean allowCache;
		private String[] version_type_info = new String[]{'version','http://gdfsuez.com/bef/chp/commun/v2','string','1','1','false'};
		private String[] system_path_type_info = new String[]{'system_path','http://gdfsuez.com/bef/chp/commun/v2','','1','1','false'};
		private String[] allowCache_type_info = new String[]{'allowCache','http://gdfsuez.com/bef/chp/commun/v2','boolean','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'version','system_path','allowCache'};
	}
	public class contextDt_system_path_element {
		public gdfsuezComBefChpCommunV2.contextDt_system_path_system_element[] system_x;
		private String[] system_x_type_info = new String[]{'system','http://gdfsuez.com/bef/chp/commun/v2','','1','-1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'system_x'};
	}
	public class contextDt_system_path_system_element {
		public String systemId;
		private String[] systemId_type_info = new String[]{'systemId','http://gdfsuez.com/bef/chp/commun/v2','string','1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'systemId'};
	}
	public class contratDt {
		public String iDContrat;
		public String refPersonne;
		public String refIDCompteClient;
		public String refIDPC;
		public String refIDPDL;
		public gdfsuezComBefChpCommunV2.blocageDt[] blocage;
		public String duree;
		public gdfsuezComBefChpCommunV2.listeValeursDt motifResil;
		public String codeCampagne;
		public gdfsuezComBefChpCommunV2.contratDt_detail_element[] detail;
		public String numContrat;
		public String refPackage;
		public gdfsuezComBefChpCommunV2.listeValeursDt typeContrat;
		public String indicateurEnvoiAvenant;
		private String[] iDContrat_type_info = new String[]{'iDContrat','http://gdfsuez.com/bef/chp/commun/v2','string','1','1','false'};
		private String[] refPersonne_type_info = new String[]{'refPersonne','http://gdfsuez.com/bef/chp/commun/v2','string','1','1','false'};
		private String[] refIDCompteClient_type_info = new String[]{'refIDCompteClient','http://gdfsuez.com/bef/chp/commun/v2','string','1','1','false'};
		private String[] refIDPC_type_info = new String[]{'refIDPC','http://gdfsuez.com/bef/chp/commun/v2','string','1','1','false'};
		private String[] refIDPDL_type_info = new String[]{'refIDPDL','http://gdfsuez.com/bef/chp/commun/v2','string','1','1','false'};
		private String[] blocage_type_info = new String[]{'blocage','http://gdfsuez.com/bef/chp/commun/v2','blocageDt','0','-1','false'};
		private String[] duree_type_info = new String[]{'duree','http://gdfsuez.com/bef/chp/commun/v2','string','1','1','false'};
		private String[] motifResil_type_info = new String[]{'motifResil','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] codeCampagne_type_info = new String[]{'codeCampagne','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] detail_type_info = new String[]{'detail','http://gdfsuez.com/bef/chp/commun/v2','','1','-1','false'};
		private String[] numContrat_type_info = new String[]{'numContrat','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] refPackage_type_info = new String[]{'refPackage','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] typeContrat_type_info = new String[]{'typeContrat','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','1','1','false'};
		private String[] indicateurEnvoiAvenant_type_info = new String[]{'indicateurEnvoiAvenant','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'iDContrat','refPersonne','refIDCompteClient','refIDPC','refIDPDL','blocage','duree','motifResil','codeCampagne','detail','numContrat','refPackage','typeContrat','indicateurEnvoiAvenant'};
	}
	public class contratDt_detail_element {
		public String cAEGaz;
		public String cAEHP;
		public String cAEHC;
		public gdfsuezComBefChpCommunV2.listeValeursDt plageConsommation;
		public gdfsuezComBefChpCommunV2.listeValeursDt puissance;
		public gdfsuezComBefChpCommunV2.listeValeursDt typeComptage;
		public gdfsuezComBefChpCommunV2.listeValeursDt tarifAcheminement;
		public gdfsuezComBefChpCommunV2.listeValeursDt profilConsommation;
		public String NBCertificatsVerts;
		public String dureeRemiseAbonnement;
		public gdfsuezComBefChpCommunV2.listeDatesDt listeDates;
		public String cAEElec;
		public gdfsuezComBefChpCommunV2.listeValeursDt statutContrat;
		public gdfsuezComBefChpCommunV2.listeValeursDt refProduit;
		public String cAR;
		public DateTime dateNaissanceSouscripteur;
		private String[] cAEGaz_type_info = new String[]{'cAEGaz','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] cAEHP_type_info = new String[]{'cAEHP','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] cAEHC_type_info = new String[]{'cAEHC','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] plageConsommation_type_info = new String[]{'plageConsommation','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] puissance_type_info = new String[]{'puissance','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] typeComptage_type_info = new String[]{'typeComptage','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] tarifAcheminement_type_info = new String[]{'tarifAcheminement','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] profilConsommation_type_info = new String[]{'profilConsommation','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] NBCertificatsVerts_type_info = new String[]{'NBCertificatsVerts','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] dureeRemiseAbonnement_type_info = new String[]{'dureeRemiseAbonnement','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] listeDates_type_info = new String[]{'listeDates','http://gdfsuez.com/bef/chp/commun/v2','listeDatesDt','0','1','false'};
		private String[] cAEElec_type_info = new String[]{'cAEElec','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] statutContrat_type_info = new String[]{'statutContrat','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','1','1','false'};
		private String[] refProduit_type_info = new String[]{'refProduit','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] cAR_type_info = new String[]{'cAR','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] dateNaissanceSouscripteur_type_info = new String[]{'dateNaissanceSouscripteur','http://gdfsuez.com/bef/chp/commun/v2','dateTime','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'cAEGaz','cAEHP','cAEHC','plageConsommation','puissance','typeComptage','tarifAcheminement','profilConsommation','NBCertificatsVerts','dureeRemiseAbonnement','listeDates','cAEElec','statutContrat','refProduit','cAR','dateNaissanceSouscripteur'};
	}
	public class intervalledDt {
		public gdfsuezComBefChpCommunV2.intervalledDt_Dates_element[] Dates;
		private String[] Dates_type_info = new String[]{'Dates','http://gdfsuez.com/bef/chp/commun/v2','','1','-1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'Dates'};
	}
	public class intervalledDt_Dates_element {
		public DateTime valeurDate;
		public String operateur;
		private String[] valeurDate_type_info = new String[]{'valeurDate','http://gdfsuez.com/bef/chp/commun/v2','dateTime','1','1','false'};
		private String[] operateur_type_info = new String[]{'operateur','http://gdfsuez.com/bef/chp/commun/v2','valeursOpEnum','1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'valeurDate','operateur'};
	}
	public class intervalleMontantDt {
		public gdfsuezComBefChpCommunV2.intervalleMontantDt_intervalleMontant_element[] intervalleMontant;
		private String[] intervalleMontant_type_info = new String[]{'intervalleMontant','http://gdfsuez.com/bef/chp/commun/v2','','1','-1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'intervalleMontant'};
	}
	public class intervalleMontantDt_intervalleMontant_element {
		public Integer valeurMontant;
		public String operateur;
		private String[] valeurMontant_type_info = new String[]{'valeurMontant','http://gdfsuez.com/bef/chp/commun/v2','int','1','1','false'};
		private String[] operateur_type_info = new String[]{'operateur','http://gdfsuez.com/bef/chp/commun/v2','valeursOpEnum','1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'valeurMontant','operateur'};
	}
	public class listeDatesDt {
		public gdfsuezComBefChpCommunV2.listeDatesDt_date_element[] date_x;
		private String[] date_x_type_info = new String[]{'date','http://gdfsuez.com/bef/chp/commun/v2','','1','-1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'date_x'};
	}
	public class listeDatesDt_date_element {
		public gdfsuezComBefChpCommunV2.listeValeursDt motifDate;
		public DateTime valeurDate;
		private String[] motifDate_type_info = new String[]{'motifDate','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] valeurDate_type_info = new String[]{'valeurDate','http://gdfsuez.com/bef/chp/commun/v2','dateTime','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'motifDate','valeurDate'};
	}
	public class listeValeursDt {
		public String idValeur;
		public String categorie;
		public String code;
		public String actif;
		public String langue;
		public String libelleCourt;
		public String libelleLong;
		public String description;
		public String order;
		private String[] idValeur_type_info = new String[]{'idValeur','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] categorie_type_info = new String[]{'categorie','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] code_type_info = new String[]{'code','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] actif_type_info = new String[]{'actif','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] langue_type_info = new String[]{'langue','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] libelleCourt_type_info = new String[]{'libelleCourt','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] libelleLong_type_info = new String[]{'libelleLong','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] description_type_info = new String[]{'description','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] order_type_info = new String[]{'order','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'idValeur','categorie','code','actif','langue','libelleCourt','libelleLong','description','order'};
	}
	public class logDt {
		public DateTime dateTrace;
		public gdfsuezComBefChpCommunV2.listeValeursDt action;
		public gdfsuezComBefChpCommunV2.listeValeursDt direction;
		public gdfsuezComBefChpCommunV2.refPersonneDt refPersonne;
		public gdfsuezComBefChpCommunV2.listeValeursDt canal;
		private String[] dateTrace_type_info = new String[]{'dateTrace','http://gdfsuez.com/bef/chp/commun/v2','dateTime','1','1','false'};
		private String[] action_type_info = new String[]{'action','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','1','1','false'};
		private String[] direction_type_info = new String[]{'direction','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] refPersonne_type_info = new String[]{'refPersonne','http://gdfsuez.com/bef/chp/commun/v2','refPersonneDt','0','1','false'};
		private String[] canal_type_info = new String[]{'canal','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'dateTrace','action','direction','refPersonne','canal'};
	}
	public class messageRetoursDt {
		public gdfsuezComBefChpCommunV2.messageRetoursDt_messageRetour_element[] messageRetour;
		private String[] messageRetour_type_info = new String[]{'messageRetour','http://gdfsuez.com/bef/chp/commun/v2','','1','-1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'messageRetour'};
	}
	public class messageRetoursDt_messageRetour_element {
		public String code;
		public String type_x;
		public String libelle;
		public String source;
		private String[] code_type_info = new String[]{'code','http://gdfsuez.com/bef/chp/commun/v2','string','1','1','false'};
		private String[] type_x_type_info = new String[]{'type','http://gdfsuez.com/bef/chp/commun/v2','string','1','1','false'};
		private String[] libelle_type_info = new String[]{'libelle','http://gdfsuez.com/bef/chp/commun/v2','string','1','1','false'};
		private String[] source_type_info = new String[]{'source','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'code','type_x','libelle','source'};
	}
	public class monetaireDt {
		public Double montant;
		public String devise;
		private String[] montant_type_info = new String[]{'montant','http://gdfsuez.com/bef/chp/commun/v2','double','0','1','false'};
		private String[] devise_type_info = new String[]{'devise','http://gdfsuez.com/bef/chp/commun/v2','','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'montant','devise'};
	}
	public class refPersonneDt {
		public String idPersonne;
		public gdfsuezComBefChpCommunV2.listeValeursDt[] rolePersonne;
		public String entite;
		private String[] idPersonne_type_info = new String[]{'idPersonne','http://gdfsuez.com/bef/chp/commun/v2','string','1','1','false'};
		private String[] rolePersonne_type_info = new String[]{'rolePersonne','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','1','-1','false'};
		private String[] entite_type_info = new String[]{'entite','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'idPersonne','rolePersonne','entite'};
	}
	public class serviceSouscritDt {
		public String idService;
		public gdfsuezComBefChpCommunV2.logDt[] historiqueServiceSouscrit;
		public gdfsuezComBefChpCommunV2.listeValeursDt typeService;
		public gdfsuezComBefChpCommunV2.listeValeursDt statutService;
		private String[] idService_type_info = new String[]{'idService','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] historiqueServiceSouscrit_type_info = new String[]{'historiqueServiceSouscrit','http://gdfsuez.com/bef/chp/commun/v2','logDt','0','-1','false'};
		private String[] typeService_type_info = new String[]{'typeService','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','1','1','false'};
		private String[] statutService_type_info = new String[]{'statutService','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'idService','historiqueServiceSouscrit','typeService','statutService'};
	}
	public class typologieFRDt {
		public gdfsuezComBefChpCommunV2.listeValeursDt segmentClient;
		public String valeurDette;
		public String ancienneDette;
		public String actionPrioritaire;
		private String[] segmentClient_type_info = new String[]{'segmentClient','http://gdfsuez.com/bef/chp/commun/v2','listeValeursDt','0','1','false'};
		private String[] valeurDette_type_info = new String[]{'valeurDette','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] ancienneDette_type_info = new String[]{'ancienneDette','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] actionPrioritaire_type_info = new String[]{'actionPrioritaire','http://gdfsuez.com/bef/chp/commun/v2','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/commun/v2','true','false'};
		private String[] field_order_type_info = new String[]{'segmentClient','valeurDette','ancienneDette','actionPrioritaire'};
	}
}