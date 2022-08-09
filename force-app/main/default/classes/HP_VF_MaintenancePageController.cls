/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-05-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public without sharing class HP_VF_MaintenancePageController {
    public String HP_EC_AvantBold {get;set;}
    public String HP_EC_AvantRegular {get;set;}
    public String HP_EC_BG_stars {get;set;}
    public String HP_EC_footer_dark {get;set;}
    public String HP_EC_black_logo {get;set;}
    
    public HP_VF_MaintenancePageController() {
        ApexPages.currentPage().getParameters().put('HP_EC_AvantBold', getDocumentRelativeLink('HP_EC_AvantBold'));
        ApexPages.currentPage().getParameters().put('HP_EC_AvantRegular', getDocumentRelativeLink('HP_EC_AvantRegular'));
        ApexPages.currentPage().getParameters().put('HP_EC_BG_stars', getDocumentRelativeLink('HP_EC_BG_stars'));
        ApexPages.currentPage().getParameters().put('HP_EC_footer_dark', getDocumentRelativeLink('HP_EC_footer_dark'));
        ApexPages.currentPage().getParameters().put('HP_EC_black_logo', getDocumentRelativeLink('HP_EC_black_logo'));

        HP_EC_AvantBold = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('HP_EC_AvantBold'));
        HP_EC_AvantRegular = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('HP_EC_AvantRegular'));
        HP_EC_BG_stars = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('HP_EC_BG_stars'));
        HP_EC_footer_dark = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('HP_EC_footer_dark'));
        HP_EC_black_logo = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('HP_EC_black_logo'));

        

    }

    public static String getDocumentRelativeLink(String documentName){
        String documentURL= '';
        try{
            list<Document> doc = [Select id,Name,SystemModStamp From Document Where Name  = :documentName];
            ID docIds = doc[0].id;
            documentURL = URL.getSalesforceBaseUrl().getProtocol()+'://'+System.URL.getSalesforceBaseUrl().getHost().remove('-api' )+'/servlet/servlet.ImageServer?id='+docIds+'&oid='+userinfo.getorganizationid();
        }catch(Exception ex){
            System.debug(ex.getMessage());
        }
        return documentURL ;
    }
}