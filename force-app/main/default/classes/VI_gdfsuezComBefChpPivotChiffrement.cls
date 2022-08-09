/*
*@Author: Paul Ghousoub
*@Description: Generer par wsdl, classe de test: VI_SM043_ChiffrerURL_Test
*@CreatedDate: 7/9/2021
*@LastModified: 7/9/2021
*/
public class VI_gdfsuezComBefChpPivotChiffrement {
    public class sortDt {
        public VI_gdfsuezComBefChpPivotChiffrement.field_element[] field;
        private String[] field_type_info = new String[]{'field','http://gdfsuez.com/bef/chp/pivot',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'field'};
    }
    public class system_element {
        public String systemId;
        private String[] systemId_type_info = new String[]{'systemId','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'systemId'};
    }
    public class field_element {
        public String name;
        public Boolean desc_x;
        private String[] name_type_info = new String[]{'name','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] desc_x_type_info = new String[]{'desc','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'name','desc_x'};
    }
    public class paginationDt {
        public String pageCount;
        public String totalCount;
        private String[] pageCount_type_info = new String[]{'pageCount','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] totalCount_type_info = new String[]{'totalCount','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'pageCount','totalCount'};
    }
    public class retourTraitementMessageDt {
        public String id;
        public String source;
        public String complement;
        public String libelle;
        public String affiche;
        public String classe;
        public String type_x;
        public String code;
        public DateTime timestamp;
        public VI_gdfsuezComBefChpPivotChiffrement.retourTraitementMessageDt causedBy;
        private String[] id_type_info = new String[]{'id','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] source_type_info = new String[]{'source','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] complement_type_info = new String[]{'complement','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] libelle_type_info = new String[]{'libelle','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] affiche_type_info = new String[]{'affiche','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] classe_type_info = new String[]{'classe','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] code_type_info = new String[]{'code','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] timestamp_type_info = new String[]{'timestamp','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] causedBy_type_info = new String[]{'causedBy','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'id','source','complement','libelle','affiche','classe','type_x','code','timestamp','causedBy'};
    }
    public class retourTraitementMessagesDt {
        public VI_gdfsuezComBefChpPivotChiffrement.retourTraitementMessageDt[] retourTraitementMessage;
        private String[] retourTraitementMessage_type_info = new String[]{'retourTraitementMessage','http://gdfsuez.com/bef/chp/pivot',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'retourTraitementMessage'};
    }
    public class messageRetour_element {
        public String id;
        public String code;
        public String libelle;
        public String type_x;
        public String source;
        public String complement;
        public String classe;
        public DateTime timestamp;
        public String affiche;
        private String[] id_type_info = new String[]{'id','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] code_type_info = new String[]{'code','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] libelle_type_info = new String[]{'libelle','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] source_type_info = new String[]{'source','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] complement_type_info = new String[]{'complement','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] classe_type_info = new String[]{'classe','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] timestamp_type_info = new String[]{'timestamp','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] affiche_type_info = new String[]{'affiche','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'id','code','libelle','type_x','source','complement','classe','timestamp','affiche'};
    }
    public class refPersonneCreerDt {
        public String idPersonne;
        public VI_gdfsuezComBefChpPivotChiffrement.listeValeursDt rolePersonne;
        private String[] idPersonne_type_info = new String[]{'idPersonne','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] rolePersonne_type_info = new String[]{'rolePersonne','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'idPersonne','rolePersonne'};
    }
    public class horodatageSimpleDt {
        public DateTime dateDerniereMAJ;
        public VI_gdfsuezComBefChpPivotChiffrement.listeValeursDt flag;
        private String[] dateDerniereMAJ_type_info = new String[]{'dateDerniereMAJ','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] flag_type_info = new String[]{'flag','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'dateDerniereMAJ','flag'};
    }
    public class refPersonneLireDt {
        public String idPersonne;
        public VI_gdfsuezComBefChpPivotChiffrement.listeValeursDt rolePersonne;
        public VI_gdfsuezComBefChpPivotChiffrement.listeValeursDt entite;
        public String prenom;
        public String nom;
        private String[] idPersonne_type_info = new String[]{'idPersonne','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] rolePersonne_type_info = new String[]{'rolePersonne','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] entite_type_info = new String[]{'entite','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] prenom_type_info = new String[]{'prenom','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] nom_type_info = new String[]{'nom','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'idPersonne','rolePersonne','entite','prenom','nom'};
    }
    public class Dates_element {
        public DateTime valeurDate;
        public String operateur;
        private String[] valeurDate_type_info = new String[]{'valeurDate','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] operateur_type_info = new String[]{'operateur','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'valeurDate','operateur'};
    }
    public class messageRetoursDt {
        public VI_gdfsuezComBefChpPivotChiffrement.messageRetour_element[] messageRetour;
        private String[] messageRetour_type_info = new String[]{'messageRetour','http://gdfsuez.com/bef/chp/pivot',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'messageRetour'};
    }
    public class systemPath_element {
        public VI_gdfsuezComBefChpPivotChiffrement.system_element[] system_x;
        private String[] system_x_type_info = new String[]{'system','http://gdfsuez.com/bef/chp/pivot',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'system_x'};
    }
    public class listeValeursParticulieresDt {
        public String libelleCourt;
        public String code;
        private String[] libelleCourt_type_info = new String[]{'libelleCourt','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] code_type_info = new String[]{'code','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'libelleCourt','code'};
    }
    public class refPersonneMAJDt {
        public String idPersonne;
        public VI_gdfsuezComBefChpPivotChiffrement.listeValeursDt rolePersonne;
        private String[] idPersonne_type_info = new String[]{'idPersonne','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] rolePersonne_type_info = new String[]{'rolePersonne','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'idPersonne','rolePersonne'};
    }
    public class intervalleDt {
        public VI_gdfsuezComBefChpPivotChiffrement.Dates_element[] Dates;
        private String[] Dates_type_info = new String[]{'Dates','http://gdfsuez.com/bef/chp/pivot',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'Dates'};
    }
    public class valeur_element {
        public String valeurTexte;
        public DateTime valeurDate;
        public Double valeurDecimal;
        public VI_gdfsuezComBefChpPivotChiffrement.listeValeursDt valeurListe;
        public Boolean valeurBoolean;
        public Integer valeurEntier;
        private String[] valeurTexte_type_info = new String[]{'valeurTexte','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] valeurDate_type_info = new String[]{'valeurDate','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] valeurDecimal_type_info = new String[]{'valeurDecimal','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] valeurListe_type_info = new String[]{'valeurListe','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] valeurBoolean_type_info = new String[]{'valeurBoolean','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] valeurEntier_type_info = new String[]{'valeurEntier','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'valeurTexte','valeurDate','valeurDecimal','valeurListe','valeurBoolean','valeurEntier'};
    }
    public class searchControlRequestHeaderDt {
        public VI_gdfsuezComBefChpPivotChiffrement.searchControlRequestDt pagination;
        public VI_gdfsuezComBefChpPivotChiffrement.sortDt sort_x;
        private String[] pagination_type_info = new String[]{'pagination','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] sort_x_type_info = new String[]{'sort','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'pagination','sort_x'};
    }
    public class horodatageDt {
        public DateTime dateDerniereMAJ;
        public VI_gdfsuezComBefChpPivotChiffrement.listeValeursDt flag;
        public VI_gdfsuezComBefChpPivotChiffrement.valeur_element valeur;
        private String[] dateDerniereMAJ_type_info = new String[]{'dateDerniereMAJ','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] flag_type_info = new String[]{'flag','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] valeur_type_info = new String[]{'valeur','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'dateDerniereMAJ','flag','valeur'};
    }
    public class listeValeursDt {
        public String idValeur;
        public String description;
        public String categorie;
        public String order;
        public String libelleCourt;
        public String libelleLong;
        public String actif;
        public String langue;
        public String code;
        private String[] idValeur_type_info = new String[]{'idValeur','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] categorie_type_info = new String[]{'categorie','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] order_type_info = new String[]{'order','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] libelleCourt_type_info = new String[]{'libelleCourt','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] libelleLong_type_info = new String[]{'libelleLong','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] actif_type_info = new String[]{'actif','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] langue_type_info = new String[]{'langue','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] code_type_info = new String[]{'code','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'idValeur','description','categorie','order','libelleCourt','libelleLong','actif','langue','code'};
    }
    public class contextDt {
        public String version;
        public VI_gdfsuezComBefChpPivotChiffrement.systemPath_element systemPath;
        public Boolean allowCache;
        private String[] version_type_info = new String[]{'version','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] systemPath_type_info = new String[]{'systemPath','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] allowCache_type_info = new String[]{'allowCache','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'version','systemPath','allowCache'};
    }
    public class searchControlRequestDt {
        public String offset;
        public String from_x;
        private String[] offset_type_info = new String[]{'offset','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] from_x_type_info = new String[]{'from','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'offset','from_x'};
    }
}