/**
* @description       : WSDL generated class gdfsuezBefCalypsoPrixetremisesV3 (FT1-4381)
* @author            : David Attali
* @group             : 
* @last modified on  : 01-25-2021
* @last modified by  : David ATTALI
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   01-25-2021   David ATTALI    Initial Version
**/
public class gdfsuezBefCalypsoPrixetremisesV3 {
    public class rechercherPrixEtRemisesServices_element {
        public gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesServicesInputDt[] rechercherPrixEtRemisesServicesInput;
        public gdfsuezComBefChpCommunV3.contextDt contexte;
        private String[] rechercherPrixEtRemisesServicesInput_type_info = new String[]{'rechercherPrixEtRemisesServicesInput','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','-1','false'};
        private String[] contexte_type_info = new String[]{'contexte','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'rechercherPrixEtRemisesServicesInput','contexte'};
    }
    public class caracteristiquesOffreElecDt {
        public gdfsuezComBefChpCommunV3.listeValeursDt typePrix;
        public gdfsuezComBefChpCommunV3.listeValeursDt versionUtilisation;
        public gdfsuezComBefChpCommunV3.listeValeursDt puissance;
        public gdfsuezComBefChpCommunV3.listeValeursDt typeComptage;
        public gdfsuezComBefChpCommunV3.listeValeursDt pourcentageOffreVerte;
        public gdfsuezComBefChpCommunV3.listeValeursDt structureMesureFournisseur;
        public Integer CAEElec;
        public Double CoefRepartition;
        public String niveauOuvertureService;
        private String[] typePrix_type_info = new String[]{'typePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] versionUtilisation_type_info = new String[]{'versionUtilisation','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] puissance_type_info = new String[]{'puissance','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] typeComptage_type_info = new String[]{'typeComptage','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] pourcentageOffreVerte_type_info = new String[]{'pourcentageOffreVerte','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] structureMesureFournisseur_type_info = new String[]{'structureMesureFournisseur','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] CAEElec_type_info = new String[]{'CAEElec','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] CoefRepartition_type_info = new String[]{'CoefRepartition','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] niveauOuvertureService_type_info = new String[]{'niveauOuvertureService','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'typePrix','versionUtilisation','puissance','typeComptage','pourcentageOffreVerte','structureMesureFournisseur','CAEElec','CoefRepartition','niveauOuvertureService'};
    }
    public class rechercherPrixEtRemisesServicesOutputDt {
        public gdfsuezBefCalypsoPrixetremisesV3.donneesPackDt donneesPack;
        public gdfsuezBefCalypsoPrixetremisesV3.donneesOffreServiceDt[] donneesOffre;
        private String[] donneesPack_type_info = new String[]{'donneesPack','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] donneesOffre_type_info = new String[]{'donneesOffre','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'donneesPack','donneesOffre'};
    }
    public class donneesPackDt {
        public String idPack;
        public String libellePack;
        public gdfsuezBefCalypsoPrixetremisesV3.listeRemisesDt listeRemises;
        private String[] idPack_type_info = new String[]{'idPack','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] libellePack_type_info = new String[]{'libellePack','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] listeRemises_type_info = new String[]{'listeRemises','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'idPack','libellePack','listeRemises'};
    }
    public class caracteristiquesOffreServiceOutDt {
        public gdfsuezComBefChpCommunV3.listeValeursDt typePrix;
        private String[] typePrix_type_info = new String[]{'typePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'typePrix'};
    }
    public class remiseDt {
        public gdfsuezComBefChpCommunV3.listeValeursDt typeRemise;
        public Double montantHT;
        public Double montantTTC;
        public Double tauxTVA;
        public String duree;
        public String pourcentageRemise;
        public String natureRemise;
        public DateTime dateFinEffet;
        public gdfsuezComBefChpCommunV3.listeValeursDt applicationRemise;
        private String[] typeRemise_type_info = new String[]{'typeRemise','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] montantHT_type_info = new String[]{'montantHT','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] montantTTC_type_info = new String[]{'montantTTC','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] tauxTVA_type_info = new String[]{'tauxTVA','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] duree_type_info = new String[]{'duree','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] pourcentageRemise_type_info = new String[]{'pourcentageRemise','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] natureRemise_type_info = new String[]{'natureRemise','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] dateFinEffet_type_info = new String[]{'dateFinEffet','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] applicationRemise_type_info = new String[]{'applicationRemise','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'typeRemise','montantHT','montantTTC','tauxTVA','duree','pourcentageRemise','natureRemise','dateFinEffet','applicationRemise'};
    }
    public class identifiantsLieuDt {
        public String codeCommune;
        public String codePostal;
        private String[] codeCommune_type_info = new String[]{'codeCommune','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','1','false'};
        private String[] codePostal_type_info = new String[]{'codePostal','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'codeCommune','codePostal'};
    }
    public class rechercherPrixEtRemisesServicesResponse_element {
        public gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesServicesOutputDt[] rechercherPrixEtRemisesServicesOutput;
        public gdfsuezComBefChpCommunV3.messageRetoursDt messageRetours;
        private String[] rechercherPrixEtRemisesServicesOutput_type_info = new String[]{'rechercherPrixEtRemisesServicesOutput','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','-1','false'};
        private String[] messageRetours_type_info = new String[]{'messageRetours','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'rechercherPrixEtRemisesServicesOutput','messageRetours'};
    }
    public class caracteristiquesOffreGazDt {
        public gdfsuezComBefChpCommunV3.listeValeursDt typePrix;
        public gdfsuezComBefChpCommunV3.listeValeursDt plageConsommation;
        public Integer CAEGaz;
        private String[] typePrix_type_info = new String[]{'typePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] plageConsommation_type_info = new String[]{'plageConsommation','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] CAEGaz_type_info = new String[]{'CAEGaz','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'typePrix','plageConsommation','CAEGaz'};
    }
    public class donneesOffreDt {
        public String idOffre;
        public String libelleOffre;
        public gdfsuezBefCalypsoPrixetremisesV3.listePrixDt listePrix;
        public gdfsuezBefCalypsoPrixetremisesV3.listeRemisesDt listeRemises;
        public gdfsuezComBefChpCommunV3.listeValeursDt secteurActivite;
        public gdfsuezComBefChpCommunV3.listeValeursDt formuleTarifaireAcheminement;
        private String[] idOffre_type_info = new String[]{'idOffre','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] libelleOffre_type_info = new String[]{'libelleOffre','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] listePrix_type_info = new String[]{'listePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] listeRemises_type_info = new String[]{'listeRemises','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] secteurActivite_type_info = new String[]{'secteurActivite','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] formuleTarifaireAcheminement_type_info = new String[]{'formuleTarifaireAcheminement','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'idOffre','libelleOffre','listePrix','listeRemises','secteurActivite','formuleTarifaireAcheminement'};
    }
    public class rechercherPrixServices_element {
        public gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesInputDt[] rechercherPrixServicesInput;
        public gdfsuezComBefChpCommunV3.contextDt contexte;
        private String[] rechercherPrixServicesInput_type_info = new String[]{'rechercherPrixServicesInput','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','-1','false'};
        private String[] contexte_type_info = new String[]{'contexte','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'rechercherPrixServicesInput','contexte'};
    }
    public class caracteristiquesOffreServiceInDt {
        public gdfsuezComBefChpCommunV3.listeValeursDt typePrix;
        private String[] typePrix_type_info = new String[]{'typePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'typePrix'};
    }
    public class donneesPrixDetailsDt {
        public Double prixMensuelHT;
        public Double prixMensuelTTC;
        public Double prixAnnuelHT;
        public Double prixAnnuelTTC;
        private String[] prixMensuelHT_type_info = new String[]{'prixMensuelHT','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] prixMensuelTTC_type_info = new String[]{'prixMensuelTTC','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] prixAnnuelHT_type_info = new String[]{'prixAnnuelHT','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] prixAnnuelTTC_type_info = new String[]{'prixAnnuelTTC','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'prixMensuelHT','prixMensuelTTC','prixAnnuelHT','prixAnnuelTTC'};
    }
    public class rechercherPrixEtRemises_element {
        public gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesInputDt[] rechercherPrixEtRemisesInput;
        public gdfsuezComBefChpCommunV3.contextDt contexte;
        private String[] rechercherPrixEtRemisesInput_type_info = new String[]{'rechercherPrixEtRemisesInput','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','-1','false'};
        private String[] contexte_type_info = new String[]{'contexte','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'rechercherPrixEtRemisesInput','contexte'};
    }
    public class listeCaracteristiquesDiagDt {
        public gdfsuezComBefChpCommunV3.listeValeursDt[] caracteristique;
        private String[] caracteristique_type_info = new String[]{'caracteristique','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'caracteristique'};
    }
    public class rechercherPrixEtRemisesServicesInputDt {
        public gdfsuezBefCalypsoPrixetremisesV3.identifiantsLieuDt identifiantsLieu;
        public String idPack;
        public gdfsuezComBefChpCommunV3.listeValeursDt idGroupeOffres;
        public String[] idOffre;
        public gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesOffreServiceInDt caracteristiquesOffreService;
        public DateTime dateEffetContrat;
        public DateTime datePropositionCommerciale;
        public DateTime dateValiditePrix;
        public gdfsuezComBefChpCommunV3.listeValeursDt enseigneSouscription;
        public gdfsuezComBefChpCommunV3.listeValeursDt typeDonneesRemontees;
        private String[] identifiantsLieu_type_info = new String[]{'identifiantsLieu','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] idPack_type_info = new String[]{'idPack','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] idGroupeOffres_type_info = new String[]{'idGroupeOffres','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] idOffre_type_info = new String[]{'idOffre','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','-1','false'};
        private String[] caracteristiquesOffreService_type_info = new String[]{'caracteristiquesOffreService','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] dateEffetContrat_type_info = new String[]{'dateEffetContrat','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] datePropositionCommerciale_type_info = new String[]{'datePropositionCommerciale','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] dateValiditePrix_type_info = new String[]{'dateValiditePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] enseigneSouscription_type_info = new String[]{'enseigneSouscription','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] typeDonneesRemontees_type_info = new String[]{'typeDonneesRemontees','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'identifiantsLieu','idPack','idGroupeOffres','idOffre','caracteristiquesOffreService','dateEffetContrat','datePropositionCommerciale','dateValiditePrix','enseigneSouscription','typeDonneesRemontees'};
    }
    public class donneesPrixCriteresDt {
        public String donneesPrixParametre;
        public String donneesPrixValeur;
        private String[] donneesPrixParametre_type_info = new String[]{'donneesPrixParametre','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] donneesPrixValeur_type_info = new String[]{'donneesPrixValeur','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'donneesPrixParametre','donneesPrixValeur'};
    }
    public class caracteristiquesDiagnosticGazDt {
        public gdfsuezBefCalypsoPrixetremisesV3.listeCaracteristiquesDiagDt listeCaracteristiquesGaz;
        private String[] listeCaracteristiquesGaz_type_info = new String[]{'listeCaracteristiquesGaz','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'listeCaracteristiquesGaz'};
    }
    public class rechercherPrixServicesInputDt {
        public String idOffre;
        public DateTime datePropositionCommerciale;
        public DateTime dateEffetContrat;
        public String contexteSouscription;
        public gdfsuezBefCalypsoPrixetremisesV3.criteres_element[] criteres;
        private String[] idOffre_type_info = new String[]{'idOffre','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','1','false'};
        private String[] datePropositionCommerciale_type_info = new String[]{'datePropositionCommerciale','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','1','false'};
        private String[] dateEffetContrat_type_info = new String[]{'dateEffetContrat','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','1','false'};
        private String[] contexteSouscription_type_info = new String[]{'contexteSouscription','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','1','false'};
        private String[] criteres_type_info = new String[]{'criteres','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'idOffre','datePropositionCommerciale','dateEffetContrat','contexteSouscription','criteres'};
    }
    public class listeRemisesDt {
        public gdfsuezBefCalypsoPrixetremisesV3.remiseDt[] remise;
        private String[] remise_type_info = new String[]{'remise','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'remise'};
    }
    public class rechercherPrixEtRemisesResponse_element {
        public gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesOutputDt[] rechercherPrixEtRemisesOutput;
        public gdfsuezComBefChpCommunV3.messageRetoursDt messageRetours;
        private String[] rechercherPrixEtRemisesOutput_type_info = new String[]{'rechercherPrixEtRemisesOutput','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','-1','false'};
        private String[] messageRetours_type_info = new String[]{'messageRetours','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'rechercherPrixEtRemisesOutput','messageRetours'};
    }
    public class donneesPrixDt {
        public gdfsuezBefCalypsoPrixetremisesV3.donneesPrixCriteresDt[] donneesPrixCriteres;
        public gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDetailsDt donneesPrixDetails;
        private String[] donneesPrixCriteres_type_info = new String[]{'donneesPrixCriteres','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','-1','false'};
        private String[] donneesPrixDetails_type_info = new String[]{'donneesPrixDetails','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'donneesPrixCriteres','donneesPrixDetails'};
    }
    public class prixServiceDt {
        public gdfsuezComBefChpCommunV3.listeValeursDt clePrix;
        public DateTime dateDebutValiditePrix;
        public Double montantHT;
        public Double montantTTC;
        public Double tauxTVA;
        public gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesOffreServiceOutDt caracteristiquesService;
        public DateTime dateFinValiditePrix;
        private String[] clePrix_type_info = new String[]{'clePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] dateDebutValiditePrix_type_info = new String[]{'dateDebutValiditePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] montantHT_type_info = new String[]{'montantHT','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] montantTTC_type_info = new String[]{'montantTTC','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] tauxTVA_type_info = new String[]{'tauxTVA','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] caracteristiquesService_type_info = new String[]{'caracteristiquesService','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] dateFinValiditePrix_type_info = new String[]{'dateFinValiditePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'clePrix','dateDebutValiditePrix','montantHT','montantTTC','tauxTVA','caracteristiquesService','dateFinValiditePrix'};
    }
    public class rechercherPrixEtRemisesOutputDt {
        public gdfsuezBefCalypsoPrixetremisesV3.donneesPackDt donneesPack;
        public gdfsuezBefCalypsoPrixetremisesV3.donneesOffreDt[] donneesOffre;
        private String[] donneesPack_type_info = new String[]{'donneesPack','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] donneesOffre_type_info = new String[]{'donneesOffre','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'donneesPack','donneesOffre'};
    }
    public class prixDt {
        public gdfsuezComBefChpCommunV3.listeValeursDt clePrix;
        public DateTime dateDebutValiditePrix;
        public Double montantHT;
        public Double montantTTC;
        public Double tauxTVA;
        public gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesOffreElecDt caracteristiquesElec;
        public gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesOffreGazDt caracteristiquesGaz;
        public gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesDiagnosticElecDt caracteristiquesDiagnosticElec;
        public gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesDiagnosticGazDt caracteristiquesDiagnosticGaz;
        public DateTime dateFinValiditePrix;
        private String[] clePrix_type_info = new String[]{'clePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] dateDebutValiditePrix_type_info = new String[]{'dateDebutValiditePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] montantHT_type_info = new String[]{'montantHT','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] montantTTC_type_info = new String[]{'montantTTC','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] tauxTVA_type_info = new String[]{'tauxTVA','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] caracteristiquesElec_type_info = new String[]{'caracteristiquesElec','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] caracteristiquesGaz_type_info = new String[]{'caracteristiquesGaz','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] caracteristiquesDiagnosticElec_type_info = new String[]{'caracteristiquesDiagnosticElec','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] caracteristiquesDiagnosticGaz_type_info = new String[]{'caracteristiquesDiagnosticGaz','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] dateFinValiditePrix_type_info = new String[]{'dateFinValiditePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'clePrix','dateDebutValiditePrix','montantHT','montantTTC','tauxTVA','caracteristiquesElec','caracteristiquesGaz','caracteristiquesDiagnosticElec','caracteristiquesDiagnosticGaz','dateFinValiditePrix'};
    }
    public class donneesPrixOutDt {
        public String idOffre;
        public DateTime datePropositionCommerciale;
        public DateTime dateEffetContrat;
        public String typePrix;
        public gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDt[] donneesPrix;
        private String[] idOffre_type_info = new String[]{'idOffre','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] datePropositionCommerciale_type_info = new String[]{'datePropositionCommerciale','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] dateEffetContrat_type_info = new String[]{'dateEffetContrat','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] typePrix_type_info = new String[]{'typePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] donneesPrix_type_info = new String[]{'donneesPrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'idOffre','datePropositionCommerciale','dateEffetContrat','typePrix','donneesPrix'};
    }
    public class listePrixDt {
        public gdfsuezBefCalypsoPrixetremisesV3.prixDt[] prix;
        private String[] prix_type_info = new String[]{'prix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'prix'};
    }
    public class donneesOffreServiceDt {
        public String idOffre;
        public String libelleOffre;
        public gdfsuezBefCalypsoPrixetremisesV3.listePrixServiceDt listePrix;
        public gdfsuezBefCalypsoPrixetremisesV3.listeRemisesDt listeRemises;
        public gdfsuezComBefChpCommunV3.listeValeursDt secteurActivite;
        private String[] idOffre_type_info = new String[]{'idOffre','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] libelleOffre_type_info = new String[]{'libelleOffre','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] listePrix_type_info = new String[]{'listePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] listeRemises_type_info = new String[]{'listeRemises','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] secteurActivite_type_info = new String[]{'secteurActivite','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'idOffre','libelleOffre','listePrix','listeRemises','secteurActivite'};
    }
    public class rechercherPrixServicesResponse_element {
        public gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesOutputDt[] rechercherPrixServicesOutput;
        public gdfsuezComBefChpCommunV3.messageRetoursDt messageRetours;
        private String[] rechercherPrixServicesOutput_type_info = new String[]{'rechercherPrixServicesOutput','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','-1','false'};
        private String[] messageRetours_type_info = new String[]{'messageRetours','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'rechercherPrixServicesOutput','messageRetours'};
    }
    public class listePrixServiceDt {
        public gdfsuezBefCalypsoPrixetremisesV3.prixServiceDt[] prix;
        private String[] prix_type_info = new String[]{'prix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'prix'};
    }
    public class caracteristiquesDiagnosticElecDt {
        public gdfsuezBefCalypsoPrixetremisesV3.listeCaracteristiquesDiagDt listeCaracteristiquesElec;
        private String[] listeCaracteristiquesElec_type_info = new String[]{'listeCaracteristiquesElec','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'listeCaracteristiquesElec'};
    }
    public class rechercherPrixEtRemisesInputDt {
        public gdfsuezBefCalypsoPrixetremisesV3.identifiantsLieuDt identifiantsLieu;
        public String idPack;
        public gdfsuezComBefChpCommunV3.listeValeursDt idGroupeOffres;
        public String[] idOffre;
        public gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesOffreElecDt caracteristiquesOffreElec;
        public gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesOffreGazDt caracteristiquesOffreGaz;
        public gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesDiagnosticGazDt caracteristiquesDiagnosticGaz;
        public gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesDiagnosticElecDt caracteristiquesDiagnosticElec;
        public DateTime dateEffetContrat;
        public DateTime datePropositionCommerciale;
        public DateTime dateValiditePrix;
        public gdfsuezComBefChpCommunV3.listeValeursDt enseigneSouscription;
        public gdfsuezComBefChpCommunV3.listeValeursDt motifSouscriptionPropositionCommerciale;
        public gdfsuezComBefChpCommunV3.listeValeursDt typeDonneesRemontees;
        public DateTime dateDerniereModificationFormuleTarifaireAcheminement;
        public gdfsuezComBefChpCommunV3.listeValeursDt formuleTarifaireAcheminement;
        public gdfsuezComBefChpCommunV3.listeValeursDt contexteSouscription;
        private String[] identifiantsLieu_type_info = new String[]{'identifiantsLieu','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] idPack_type_info = new String[]{'idPack','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] idGroupeOffres_type_info = new String[]{'idGroupeOffres','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] idOffre_type_info = new String[]{'idOffre','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','-1','false'};
        private String[] caracteristiquesOffreElec_type_info = new String[]{'caracteristiquesOffreElec','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] caracteristiquesOffreGaz_type_info = new String[]{'caracteristiquesOffreGaz','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] caracteristiquesDiagnosticGaz_type_info = new String[]{'caracteristiquesDiagnosticGaz','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] caracteristiquesDiagnosticElec_type_info = new String[]{'caracteristiquesDiagnosticElec','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] dateEffetContrat_type_info = new String[]{'dateEffetContrat','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] datePropositionCommerciale_type_info = new String[]{'datePropositionCommerciale','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] dateValiditePrix_type_info = new String[]{'dateValiditePrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] enseigneSouscription_type_info = new String[]{'enseigneSouscription','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] motifSouscriptionPropositionCommerciale_type_info = new String[]{'motifSouscriptionPropositionCommerciale','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] typeDonneesRemontees_type_info = new String[]{'typeDonneesRemontees','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] dateDerniereModificationFormuleTarifaireAcheminement_type_info = new String[]{'dateDerniereModificationFormuleTarifaireAcheminement','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] formuleTarifaireAcheminement_type_info = new String[]{'formuleTarifaireAcheminement','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] contexteSouscription_type_info = new String[]{'contexteSouscription','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'identifiantsLieu','idPack','idGroupeOffres','idOffre','caracteristiquesOffreElec','caracteristiquesOffreGaz','caracteristiquesDiagnosticGaz','caracteristiquesDiagnosticElec','dateEffetContrat','datePropositionCommerciale','dateValiditePrix','enseigneSouscription','motifSouscriptionPropositionCommerciale','typeDonneesRemontees','dateDerniereModificationFormuleTarifaireAcheminement','formuleTarifaireAcheminement','contexteSouscription'};
    }
    public class rechercherPrixServicesOutputDt {
        public gdfsuezBefCalypsoPrixetremisesV3.donneesPrixOutDt[] donneesPrix;
        public gdfsuezBefCalypsoPrixetremisesV3.donneesPrixOutDt[] donneesPrixAnnexe;
        private String[] donneesPrix_type_info = new String[]{'donneesPrix','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','-1','false'};
        private String[] donneesPrixAnnexe_type_info = new String[]{'donneesPrixAnnexe','http://gdfsuez/bef/calypso/prixetremises/v2',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'donneesPrix','donneesPrixAnnexe'};
    }
    public class criteres_element {
        public String parametre;
        public String valeur;
        private String[] parametre_type_info = new String[]{'parametre','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] valeur_type_info = new String[]{'valeur','http://gdfsuez/bef/calypso/prixetremises/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2','false','false'};
        private String[] field_order_type_info = new String[]{'parametre','valeur'};
    }
    public class PrixEtRemisesPort {
        public String endpoint_x = 'http://localhost:8080/services/prixetremises';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://gdfsuez/bef/calypso/prixetremises/v2', 'gdfsuezBefCalypsoPrixetremisesV3', 'http://gdfsuez.com/bef/chp/commun/v2', 'gdfsuezComBefChpCommunV3'};
        public gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesResponse_element RechercherPrixEtRemises(gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesInputDt[] rechercherPrixEtRemisesInput,gdfsuezComBefChpCommunV3.contextDt contexte) {
            gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemises_element request_x = new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemises_element();
            request_x.rechercherPrixEtRemisesInput = rechercherPrixEtRemisesInput;
            request_x.contexte = contexte;
            gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesResponse_element response_x;
            Map<String, gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesResponse_element> response_map_x = new Map<String, gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'tns:RechercherPrixEtRemises',
              'http://gdfsuez/bef/calypso/prixetremises/v2',
              'rechercherPrixEtRemises',
              'http://gdfsuez/bef/calypso/prixetremises/v2',
              'rechercherPrixEtRemisesResponse',
              'gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesResponse_element RechercherPrixServices(gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesInputDt[] rechercherPrixServicesInput,gdfsuezComBefChpCommunV3.contextDt contexte) {
            gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServices_element request_x = new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServices_element();
            request_x.rechercherPrixServicesInput = rechercherPrixServicesInput;
            request_x.contexte = contexte;
            gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesResponse_element response_x;
            Map<String, gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesResponse_element> response_map_x = new Map<String, gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'tns:RechercherPrixServices',
              'http://gdfsuez/bef/calypso/prixetremises/v2',
              'rechercherPrixServices',
              'http://gdfsuez/bef/calypso/prixetremises/v2',
              'rechercherPrixServicesResponse',
              'gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesServicesResponse_element RechercherPrixEtRemisesServices(gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesServicesInputDt[] rechercherPrixEtRemisesServicesInput,gdfsuezComBefChpCommunV3.contextDt contexte) {
            gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesServices_element request_x = new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesServices_element();
            request_x.rechercherPrixEtRemisesServicesInput = rechercherPrixEtRemisesServicesInput;
            request_x.contexte = contexte;
            gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesServicesResponse_element response_x;
            Map<String, gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesServicesResponse_element> response_map_x = new Map<String, gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesServicesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'tns:RechercherPrixEtRemisesServices',
              'http://gdfsuez/bef/calypso/prixetremises/v2',
              'rechercherPrixEtRemisesServices',
              'http://gdfsuez/bef/calypso/prixetremises/v2',
              'rechercherPrixEtRemisesServicesResponse',
              'gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesServicesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
}