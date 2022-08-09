/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 07-27-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
public with sharing class HP_EC_VF_JustificatifDomicilePDF_CTRL {

    public String date_du_jour {get; set;}
    public String ref_client {get; set;}
    public String adresse_factu1 {get; set;}
    public String adresse_factu2 {get; set;}
    public String adresse_local {get; set;}
    public String ref_contrat {get; set;}
    public String civilite_titulaire {get; set;}
    public String nom_titulaire {get; set;}
    public String prenom_titulaire {get; set;}
    public String civilite_cotitulaire {get; set;}
    public String nom_cotitulaire {get; set;}
    public String prenom_cotitulaire {get; set;}

    public String bodyParagraph {get; set;}

    public String capital_GDF_SUEZ {get; set;}
    public String adr_gdfsuez_siege {get; set;}
    public String numero_tva_gdf_suez {get; set;}
    public String service_client_agilab {get; set;}
    public String depannage_elec {get; set;}
    public String depannage_gaz {get; set;}
    
    public HP_EC_VF_JustificatifDomicilePDF_CTRL() {
        date_du_jour = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('date_du_jour'));
        ref_client = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('ref_client'));
        adresse_factu1 = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('adresse_factu1'));
        adresse_factu2 = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('adresse_factu2'));
        adresse_local = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('adresse_local'));
        ref_contrat = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('ref_contrat'));
        civilite_titulaire = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('civilite_titulaire'));
        nom_titulaire = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('nom_titulaire'));
        prenom_titulaire = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('prenom_titulaire'));
        civilite_cotitulaire = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('civilite_cotitulaire'));
        nom_cotitulaire = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('nom_cotitulaire'));
        prenom_cotitulaire = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('prenom_cotitulaire'));

        bodyParagraph = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('bodyParagraph'));

        capital_GDF_SUEZ = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('capital_GDF_SUEZ'));
        adr_gdfsuez_siege = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('adr_gdfsuez_siege'));
        numero_tva_gdf_suez = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('numero_tva_gdf_suez'));
        service_client_agilab = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('service_client_agilab'));
        depannage_elec = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('depannage_elec'));
        depannage_gaz = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('depannage_gaz'));
    }
}