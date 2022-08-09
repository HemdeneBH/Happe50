/*
*@Auhtor: Paul Ghoussoub
*@Description: generer par wsdl
*@CreatedDate: 9/12/2021
*@Classe de test: VI_gdfsuezComBefChpPivot_Prelevement1
*/
public class VI_gdfsuezComBefChpPivot_Prelevement1 {
    public class system_element {
        public String systemId;
        private String[] systemId_type_info = new String[]{'systemId','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'systemId'};
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
        private String[] id_type_info = new String[]{'id','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] code_type_info = new String[]{'code','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] libelle_type_info = new String[]{'libelle','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] source_type_info = new String[]{'source','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] complement_type_info = new String[]{'complement','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] classe_type_info = new String[]{'classe','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] timestamp_type_info = new String[]{'timestamp','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'id','code','libelle','type_x','source','complement','classe','timestamp'};
    }
    public class systemPath_element {
        public VI_gdfsuezComBefChpPivot_Prelevement1.system_element[] system_x;
        private String[] system_x_type_info = new String[]{'system','http://gdfsuez.com/bef/chp/pivot',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'system_x'};
    }
    public class refPersonneCreerDt {
        public String idPersonne;
        public VI_gdfsuezComBefChpPivot_Prelevement1.listeValeursDt rolePersonne;
        private String[] idPersonne_type_info = new String[]{'idPersonne','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] rolePersonne_type_info = new String[]{'rolePersonne','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'idPersonne','rolePersonne'};
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
        public VI_gdfsuezComBefChpPivot_Prelevement1.listeValeursDt refPersonne;
        private String[] idPersonne_type_info = new String[]{'idPersonne','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] refPersonne_type_info = new String[]{'refPersonne','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'idPersonne','refPersonne'};
    }
    public class refPersonneLireDt {
        public String idPersonne;
        public VI_gdfsuezComBefChpPivot_Prelevement1.listeValeursDt rolePersonne;
        public VI_gdfsuezComBefChpPivot_Prelevement1.listeValeursDt entite;
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
    public class messageRetoursDt {
        public VI_gdfsuezComBefChpPivot_Prelevement1.messageRetour_element[] messageRetour;
        private String[] messageRetour_type_info = new String[]{'messageRetour','http://gdfsuez.com/bef/chp/pivot',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'messageRetour'};
    }
    public class contextDt {
        public String version;
        public VI_gdfsuezComBefChpPivot_Prelevement1.systemPath_element systemPath;
        public Boolean allowCache;
        private String[] version_type_info = new String[]{'version','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] systemPath_type_info = new String[]{'systemPath','http://gdfsuez.com/bef/chp/pivot',null,'1','1','false'};
        private String[] allowCache_type_info = new String[]{'allowCache','http://gdfsuez.com/bef/chp/pivot',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot','false','false'};
        private String[] field_order_type_info = new String[]{'version','systemPath','allowCache'};
    }
}