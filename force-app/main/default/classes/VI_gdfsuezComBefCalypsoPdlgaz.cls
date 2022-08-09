//Generated by wsdl2apex

public class VI_gdfsuezComBefCalypsoPdlgaz {
    public class dernieresReleves_element {
        public DateTime dateDerniereReleve;
        public DateTime dateDerniereTeleReleve;
        public VI_gdfsuezComBefCalypsoPdlgaz.releve6M_1MDt[] releve6M_1M;
        public VI_gdfsuezComBefCalypsoPdlgaz.DonneesConsommationsJournalieresDt DonneesConsommationsJournalieres;
        private String[] dateDerniereReleve_type_info = new String[]{'dateDerniereReleve','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] dateDerniereTeleReleve_type_info = new String[]{'dateDerniereTeleReleve','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] releve6M_1M_type_info = new String[]{'releve6M_1M','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','-1','false'};
        private String[] DonneesConsommationsJournalieres_type_info = new String[]{'DonneesConsommationsJournalieres','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'dateDerniereReleve','dateDerniereTeleReleve','releve6M_1M','DonneesConsommationsJournalieres'};
    }
    public class PDLGaz {
        public VI_gdfsuezComBefChpPivot.listeValeursDt reseau;
        public VI_gdfsuezComBefChpPivot.listeValeursDt typeNiveauReseau;
        public VI_gdfsuezComBefChpPivot.listeValeursDt typePointComptage;
        public String natureGaz;
        public String designationPDCELD;
        public String profilType;
        public VI_gdfsuezComBefCalypsoPdlgaz.PITD_element PITD;
        public VI_gdfsuezComBefChpPivot.listeValeursDt MEGPE;
        public DateTime dateDerniereModificationFormuleTarifaireAcheminement;
        public Boolean consommationSansFournisseur;
        public Boolean programmationPasHoraire;
        public VI_gdfsuezComBefChpCommunadresse.adresseCommunDt adresse;
        public VI_gdfsuezComBefCalypsoPdlgaz.installationDt installation;
        public VI_gdfsuezComBefCalypsoLocal.LocalAbstract local;
        public VI_gdfsuezComBefCalypsoPdlgaz.donneesContractuelles_element donneesContractuelles;
        public VI_gdfsuezComBefCalypsoPdlgaz.dernieresReleves_element dernieresReleves;
        public VI_gdfsuezComBefCalypsoPdlgaz.derniersIndex_element derniersIndex;
        public VI_gdfsuezComBefCalypsoPdlgaz.CAR_element CAR;
        public Boolean MIG;
        public VI_gdfsuezComBefCalypsoPdlgaz.utilisateurFinalDt utilisateurFinal;
        public VI_gdfsuezComBefCalypsoPdlgaz.GazparDt Gazpar;
        private String[] reseau_type_info = new String[]{'reseau','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] typeNiveauReseau_type_info = new String[]{'typeNiveauReseau','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] typePointComptage_type_info = new String[]{'typePointComptage','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] natureGaz_type_info = new String[]{'natureGaz','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] designationPDCELD_type_info = new String[]{'designationPDCELD','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] profilType_type_info = new String[]{'profilType','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] PITD_type_info = new String[]{'PITD','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] MEGPE_type_info = new String[]{'MEGPE','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] dateDerniereModificationFormuleTarifaireAcheminement_type_info = new String[]{'dateDerniereModificationFormuleTarifaireAcheminement','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] consommationSansFournisseur_type_info = new String[]{'consommationSansFournisseur','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] programmationPasHoraire_type_info = new String[]{'programmationPasHoraire','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] adresse_type_info = new String[]{'adresse','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] installation_type_info = new String[]{'installation','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] local_type_info = new String[]{'local','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] donneesContractuelles_type_info = new String[]{'donneesContractuelles','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] dernieresReleves_type_info = new String[]{'dernieresReleves','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] derniersIndex_type_info = new String[]{'derniersIndex','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] CAR_type_info = new String[]{'CAR','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] MIG_type_info = new String[]{'MIG','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] utilisateurFinal_type_info = new String[]{'utilisateurFinal','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] Gazpar_type_info = new String[]{'Gazpar','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'reseau','typeNiveauReseau','typePointComptage','natureGaz','designationPDCELD','profilType','PITD','MEGPE','dateDerniereModificationFormuleTarifaireAcheminement','consommationSansFournisseur','programmationPasHoraire','adresse','installation','local','donneesContractuelles','dernieresReleves','derniersIndex','CAR','MIG','utilisateurFinal','Gazpar'};
    }
    public class PDLGazRoot {
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class PITD_element {
        public String identifiant;
        public String libelle;
        private String[] identifiant_type_info = new String[]{'identifiant','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] libelle_type_info = new String[]{'libelle','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'identifiant','libelle'};
    }
    public class utilisateurFinalDt {
        public VI_gdfsuezComBefChpPivot.listeValeursDt civilite;
        public String nom;
        public String prenom;
        public String raisonSociale;
        public String codeSIRET;
        public String codeNAF;
        private String[] civilite_type_info = new String[]{'civilite','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] nom_type_info = new String[]{'nom','http://gdfsuez.com/bef/calypso/pdlgaz',null,'1','1','false'};
        private String[] prenom_type_info = new String[]{'prenom','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] raisonSociale_type_info = new String[]{'raisonSociale','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] codeSIRET_type_info = new String[]{'codeSIRET','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] codeNAF_type_info = new String[]{'codeNAF','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'civilite','nom','prenom','raisonSociale','codeSIRET','codeNAF'};
    }
    public class releve6M_1MDt {
        public DateTime dateDebut;
        public DateTime dateFin;
        public Double indexDebut;
        public String indicateurDebut;
        public Double indexFin;
        public String indicateurFin;
        public Integer volume;
        public String indicateurVolume;
        public Double coeffThermique;
        public String indicateurCoeffThermique;
        public Integer quantite;
        public String indicateurQuantite;
        public String libelleReleveSpeciale;
        private String[] dateDebut_type_info = new String[]{'dateDebut','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] dateFin_type_info = new String[]{'dateFin','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] indexDebut_type_info = new String[]{'indexDebut','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] indicateurDebut_type_info = new String[]{'indicateurDebut','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] indexFin_type_info = new String[]{'indexFin','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] indicateurFin_type_info = new String[]{'indicateurFin','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] volume_type_info = new String[]{'volume','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] indicateurVolume_type_info = new String[]{'indicateurVolume','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] coeffThermique_type_info = new String[]{'coeffThermique','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] indicateurCoeffThermique_type_info = new String[]{'indicateurCoeffThermique','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] quantite_type_info = new String[]{'quantite','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] indicateurQuantite_type_info = new String[]{'indicateurQuantite','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] libelleReleveSpeciale_type_info = new String[]{'libelleReleveSpeciale','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'dateDebut','dateFin','indexDebut','indicateurDebut','indexFin','indicateurFin','volume','indicateurVolume','coeffThermique','indicateurCoeffThermique','quantite','indicateurQuantite','libelleReleveSpeciale'};
    }
    public class adresseRecherchePDLGazDt {
        public Boolean RueNormalisee;
        public String ComplementAdresse;
        private String[] RueNormalisee_type_info = new String[]{'RueNormalisee','http://gdfsuez.com/bef/calypso/pdlgaz',null,'1','1','false'};
        private String[] ComplementAdresse_type_info = new String[]{'ComplementAdresse','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'RueNormalisee','ComplementAdresse'};
    }
    public class DonneesConsommationsJournalieresDt {
        public VI_gdfsuezComBefCalypsoPdlgaz.ConsommationJournaliereDt[] ConsommationJournaliere;
        private String[] ConsommationJournaliere_type_info = new String[]{'ConsommationJournaliere','http://gdfsuez.com/bef/calypso/pdlgaz',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'ConsommationJournaliere'};
    }
    public class ListePCEAdressesDt {
        public VI_gdfsuezComBefCalypsoPdlgaz.adresseRecherchePDLGazOutputDt[] adresseRecherchePDLGaz;
        public String[] nomUtilisateurFinal;
        public String[] matriculeCompteur;
        public String[] IdPceOmega;
        private String[] adresseRecherchePDLGaz_type_info = new String[]{'adresseRecherchePDLGaz','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','-1','false'};
        private String[] nomUtilisateurFinal_type_info = new String[]{'nomUtilisateurFinal','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','-1','false'};
        private String[] matriculeCompteur_type_info = new String[]{'matriculeCompteur','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','-1','false'};
        private String[] IdPceOmega_type_info = new String[]{'IdPceOmega','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'adresseRecherchePDLGaz','nomUtilisateurFinal','matriculeCompteur','IdPceOmega'};
    }
    public class installationDt {
        public VI_gdfsuezComBefChpPivot.listeValeursDt pressionAlimentation;
        public String reperageRobinetGazBranchement;
        public VI_gdfsuezComBefChpPivot.listeValeursDt etatAlimentation;
        public VI_gdfsuezComBefCalypsoPdlgaz.compteurDt compteur;
        private String[] pressionAlimentation_type_info = new String[]{'pressionAlimentation','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] reperageRobinetGazBranchement_type_info = new String[]{'reperageRobinetGazBranchement','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] etatAlimentation_type_info = new String[]{'etatAlimentation','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] compteur_type_info = new String[]{'compteur','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'pressionAlimentation','reperageRobinetGazBranchement','etatAlimentation','compteur'};
    }
    public class adresseRecherchePDLGazOutputDt {
        public String[] ComplAdresse1;
        public String[] ComplAdresse2;
        private String[] ComplAdresse1_type_info = new String[]{'ComplAdresse1','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','-1','false'};
        private String[] ComplAdresse2_type_info = new String[]{'ComplAdresse2','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'ComplAdresse1','ComplAdresse2'};
    }
    public class GazparDt {
        public DateTime dateRefusTelereleve;
        public VI_gdfsuezComBefChpPivot.listeValeursDt etatPDL;
        public VI_gdfsuezComBefCalypsoPdlgaz.deploiement_element deploiement;
        private String[] dateRefusTelereleve_type_info = new String[]{'dateRefusTelereleve','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] etatPDL_type_info = new String[]{'etatPDL','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] deploiement_type_info = new String[]{'deploiement','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'dateRefusTelereleve','etatPDL','deploiement'};
    }
    public class CAR_HistoDt {
        public VI_gdfsuezComBefCalypsoPdlgaz.TrancheDt[] Tranche;
        private String[] Tranche_type_info = new String[]{'Tranche','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'Tranche'};
    }
    public class donneesCoupureDt {
        public DateTime dateDebut;
        public VI_gdfsuezComBefChpPivot.listeValeursDt motif;
        public VI_gdfsuezComBefChpPivot.listeValeursDt localisation;
        public Boolean fraude;
        public Boolean diagnosticQualite;
        private String[] dateDebut_type_info = new String[]{'dateDebut','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] motif_type_info = new String[]{'motif','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] localisation_type_info = new String[]{'localisation','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] fraude_type_info = new String[]{'fraude','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] diagnosticQualite_type_info = new String[]{'diagnosticQualite','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'dateDebut','motif','localisation','fraude','diagnosticQualite'};
    }
    public class index_element {
        public DateTime dateIndex;
        public Double valeurIndex;
        public VI_gdfsuezComBefChpPivot.listeValeursDt natureIndex;
        private String[] dateIndex_type_info = new String[]{'dateIndex','http://gdfsuez.com/bef/calypso/pdlgaz',null,'1','1','false'};
        private String[] valeurIndex_type_info = new String[]{'valeurIndex','http://gdfsuez.com/bef/calypso/pdlgaz',null,'1','1','false'};
        private String[] natureIndex_type_info = new String[]{'natureIndex','http://gdfsuez.com/bef/calypso/pdlgaz',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'dateIndex','valeurIndex','natureIndex'};
    }
    public class compteurDt {
        public String matricule;
        public Integer nombreRoues;
        public VI_gdfsuezComBefChpPivot.listeValeursDt regime;
        public VI_gdfsuezComBefChpPivot.listeValeursDt situation;
        public VI_gdfsuezComBefChpPivot.listeValeursDt debitMax;
        public String codeAppareil;
        public VI_gdfsuezComBefChpPivot.listeValeursDt etatTechnique;
        public String idCompteur;
        public Boolean DGI;
        public VI_gdfsuezComBefChpPivot.listeValeursDt typeCompteur;
        public VI_gdfsuezComBefChpPivot.listeValeursDt statut;
        private String[] matricule_type_info = new String[]{'matricule','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] nombreRoues_type_info = new String[]{'nombreRoues','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] regime_type_info = new String[]{'regime','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] situation_type_info = new String[]{'situation','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] debitMax_type_info = new String[]{'debitMax','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] codeAppareil_type_info = new String[]{'codeAppareil','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] etatTechnique_type_info = new String[]{'etatTechnique','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] idCompteur_type_info = new String[]{'idCompteur','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] DGI_type_info = new String[]{'DGI','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] typeCompteur_type_info = new String[]{'typeCompteur','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] statut_type_info = new String[]{'statut','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'matricule','nombreRoues','regime','situation','debitMax','codeAppareil','etatTechnique','idCompteur','DGI','typeCompteur','statut'};
    }
    public class donneesReleveDt {
        public VI_gdfsuezComBefChpPivot.listeValeursDt frequenceReleve;
        public DateTime datePublicationMensuelle;
        public DateTime dateTheoriqueReleve;
        public Boolean accesReleve;
        public Double valeurIndexMiseHorsService;
        public DateTime dateMiseHorsService;
        private String[] frequenceReleve_type_info = new String[]{'frequenceReleve','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] datePublicationMensuelle_type_info = new String[]{'datePublicationMensuelle','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] dateTheoriqueReleve_type_info = new String[]{'dateTheoriqueReleve','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] accesReleve_type_info = new String[]{'accesReleve','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] valeurIndexMiseHorsService_type_info = new String[]{'valeurIndexMiseHorsService','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] dateMiseHorsService_type_info = new String[]{'dateMiseHorsService','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'frequenceReleve','datePublicationMensuelle','dateTheoriqueReleve','accesReleve','valeurIndexMiseHorsService','dateMiseHorsService'};
    }
    public class derniersIndex_element {
        public VI_gdfsuezComBefCalypsoPdlgaz.index_element[] index;
        private String[] index_type_info = new String[]{'index','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'index'};
    }
    public class CARDt {
        public Integer valeurCAR;
        public String typeCAR;
        public VI_gdfsuezComBefChpPivot.listeValeursDt profilCAR;
        private String[] valeurCAR_type_info = new String[]{'valeurCAR','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] typeCAR_type_info = new String[]{'typeCAR','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] profilCAR_type_info = new String[]{'profilCAR','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'valeurCAR','typeCAR','profilCAR'};
    }
    public class TrancheDt {
        public Date CARDebPeriod;
        public Date CARFinPeriod;
        public Double CARPeriod;
        private String[] CARDebPeriod_type_info = new String[]{'CARDebPeriod','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] CARFinPeriod_type_info = new String[]{'CARFinPeriod','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] CARPeriod_type_info = new String[]{'CARPeriod','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'CARDebPeriod','CARFinPeriod','CARPeriod'};
    }
    public class ListeCommunesDt {
        public String CodePostal;
        public String Commune;
        private String[] CodePostal_type_info = new String[]{'CodePostal','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] Commune_type_info = new String[]{'Commune','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'CodePostal','Commune'};
    }
    public class deploiement_element {
        public String etatPlanification;
        public DateTime dateDebutPlanification;
        public DateTime dateFinPlanification;
        private String[] etatPlanification_type_info = new String[]{'etatPlanification','http://gdfsuez.com/bef/calypso/pdlgaz',null,'1','1','false'};
        private String[] dateDebutPlanification_type_info = new String[]{'dateDebutPlanification','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] dateFinPlanification_type_info = new String[]{'dateFinPlanification','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'etatPlanification','dateDebutPlanification','dateFinPlanification'};
    }
    public class CAR_element {
        public VI_gdfsuezComBefCalypsoPdlgaz.CARDt CAR_Actuelle;
        public VI_gdfsuezComBefCalypsoPdlgaz.CARDt CAR_Future;
        public VI_gdfsuezComBefCalypsoPdlgaz.CAR_HistoDt CAR_Histo;
        private String[] CAR_Actuelle_type_info = new String[]{'CAR_Actuelle','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] CAR_Future_type_info = new String[]{'CAR_Future','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] CAR_Histo_type_info = new String[]{'CAR_Histo','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'CAR_Actuelle','CAR_Future','CAR_Histo'};
    }
    public class donneesContractuelles_element {
        public VI_gdfsuezComBefChpPivot.listeValeursDt tarifAcheminement;
        public Boolean miseHorsServiceEnCours;
        public Boolean premiereMiseEnService;
        public String statutContractuel;
        public Boolean contratCLD;
        public VI_gdfsuezComBefCalypsoPdlgaz.donneesReleveDt[] donneesReleve;
        public VI_gdfsuezComBefCalypsoPdlgaz.donneesCoupureDt donneesCoupure;
        private String[] tarifAcheminement_type_info = new String[]{'tarifAcheminement','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] miseHorsServiceEnCours_type_info = new String[]{'miseHorsServiceEnCours','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] premiereMiseEnService_type_info = new String[]{'premiereMiseEnService','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] statutContractuel_type_info = new String[]{'statutContractuel','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] contratCLD_type_info = new String[]{'contratCLD','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] donneesReleve_type_info = new String[]{'donneesReleve','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','-1','false'};
        private String[] donneesCoupure_type_info = new String[]{'donneesCoupure','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'tarifAcheminement','miseHorsServiceEnCours','premiereMiseEnService','statutContractuel','contratCLD','donneesReleve','donneesCoupure'};
    }
    public class PDLGazAbstract {
        public String idPDLGaz;
        private String[] idPDLGaz_type_info = new String[]{'idPDLGaz','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'idPDLGaz'};
    }
    public class ConsommationJournaliereDt {
        public Date Jour;
        public Integer IndexJour;
        public String Qualification;
        public Double volume;
        public Double coeffThermique;
        public Integer quantiteLivree;
        private String[] Jour_type_info = new String[]{'Jour','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] IndexJour_type_info = new String[]{'IndexJour','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] Qualification_type_info = new String[]{'Qualification','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] volume_type_info = new String[]{'volume','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] coeffThermique_type_info = new String[]{'coeffThermique','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] quantiteLivree_type_info = new String[]{'quantiteLivree','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'Jour','IndexJour','Qualification','volume','coeffThermique','quantiteLivree'};
    }
    public class adressePDLGazDt {
        public String[] NumeroRue;
        public String Rue;
        public String CodePostal;
        public String Commune;
        private String[] NumeroRue_type_info = new String[]{'NumeroRue','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','-1','false'};
        private String[] Rue_type_info = new String[]{'Rue','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] CodePostal_type_info = new String[]{'CodePostal','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] Commune_type_info = new String[]{'Commune','http://gdfsuez.com/bef/calypso/pdlgaz',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/pdlgaz','false','false'};
        private String[] field_order_type_info = new String[]{'NumeroRue','Rue','CodePostal','Commune'};
    }
}