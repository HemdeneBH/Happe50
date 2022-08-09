/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 12-02-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_VF_FicheAidePDF_Controller {

    public String nameText {get; set;}
    public String idClientText {get; set;}
    public String situationCompteText {get; set;}
    public String montantDuText {get; set;}
    public String dateNextInvoiceText {get; set;}

    public String prelevementEnCoursText {get; set;}
    public String dateMontantsText {get; set;}
    public String clientMensualiseText {get; set;}

    public String planApurementText {get; set;}
    public String montantTotalPlanApurementText {get; set;}
    public String soldePlanApurementText {get; set;}

    public HP_VF_FicheAidePDF_Controller() {
        nameText = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('nameText'));
        idClientText = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('idClientText'));
        situationCompteText = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('situationCompteText'));
        montantDuText = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('montantDuText'));
        dateNextInvoiceText = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('dateNextInvoiceText'));

        prelevementEnCoursText = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('prelevementEnCoursText'));
        dateMontantsText = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('dateMontantsText'));
        clientMensualiseText = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('clientMensualiseText'));

        planApurementText = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('planApurementText'));
        montantTotalPlanApurementText = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('montantTotalPlanApurementText'));
        soldePlanApurementText = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('soldePlanApurementText'));
    }
}