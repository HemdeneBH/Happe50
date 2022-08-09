/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 12-16-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_GeneratePDFHelper {
    
    @AuraEnabled
    public static String generatePDF(String informationAideToPdf){
        System.debug('HP_GeneratePDFHelper.generatePDF() | Method Start');
        HP_WRP046_InformationsAidePDF wrapperPDF = (HP_WRP046_InformationsAidePDF)System.JSON.deserializeStrict(informationAideToPdf, HP_WRP046_InformationsAidePDF.class);
        System.debug('Information Aide Received : '+wrapperPDF);
        Pagereference pdfPage = Page.HP_VF_FicheAidePDF;
        Attachment objAttachment = new Attachment();
        try {
            pdfPage.getParameters().put('nameText', (String)wrapperPDF.clientName);
            pdfPage.getParameters().put('idClientText', (String)wrapperPDF.clientRef);
            pdfPage.getParameters().put('situationCompteText', formatDate((String)wrapperPDF.situationCompte));
            pdfPage.getParameters().put('montantDuText', formatCurrency((String)wrapperPDF.montantDu));
            pdfPage.getParameters().put('dateNextInvoiceText', formatDate((String)wrapperPDF.dateNextInvoice));
            pdfPage.getParameters().put('prelevementEnCoursText', (String)wrapperPDF.prelevement);
            pdfPage.getParameters().put('dateMontantsText', wrapperPDF.montantReglements != null ? (String)wrapperPDF.montantReglements : '');
            pdfPage.getParameters().put('clientMensualiseText', (String)wrapperPDF.isMensualisee);
            pdfPage.getParameters().put('planApurementText', (String)wrapperPDF.planApurement);
            pdfPage.getParameters().put('montantTotalPlanApurementText', wrapperPDF.montantApurement != null ? formatCurrency((String)wrapperPDF.montantApurement) : '');
            pdfPage.getParameters().put('soldePlanApurementText', wrapperPDF.soldeApurement != null ? formatCurrency((String)wrapperPDF.soldeApurement) : '');
            String caseId = (String)wrapperPDF.caseId;

            Case aCase = [SELECT Id FROM Case WHERE Id = :caseId limit 1];
            ContentVersion contentVersionPDFToInsert = new ContentVersion(
                Title=(String)wrapperPDF.clientName+' - Fiche de renseignements', 
                PathOnClient =(String)wrapperPDF.clientName+' - Fiche de renseignements.pdf',
                VersionData = !Test.isRunningTest() ? pdfPage.getContentaspdf()  : Blob.valueOf('Fake content'), 
                origin = 'H' 
            );
            insert contentVersionPDFToInsert;
            ContentVersion contentVersionPDF = [SELECT Id, Title, ContentDocumentId 
                            FROM ContentVersion WHERE Id = :contentVersionPDFToInsert.Id LIMIT 1];
            
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = aCase.id;
            contentlink.contentdocumentid = contentVersionPDF.contentdocumentid;
            contentlink.ShareType = 'V';

            Database.SaveResult attachmentForInsert=Database.Insert(contentlink,false);
            System.debug('HP_GeneratePDFHelper.generatePDF() | Method Exit');
            if(attachmentForInsert.isSuccess()){
                return contentlink.contentdocumentid;
            }else{
                throw new AuraHandledException(attachmentForInsert.getErrors().get(0).getMessage());
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    private static String formatDate(String input){
       return input.substringAfterLast('-') + '/' + input.substringBetween('-', '-') + '/' + input.substringBefore('-') ;
    }

    private static String formatCurrency(String input){
        if(input.contains('.')){
            return input + ' €';
        }else {
            return input + '.00 €';
        }
    }

    public class HP_WRP046_InformationsAidePDF{
        public String clientName {get; set;}
        public String clientRef{get; set;}
        public String situationCompte {get; set;}
        public String montantDu {get; set;}
        public String dateNextInvoice {get; set;}
        public String prelevement {get; set;}
        public String montantReglements {get; set;}
        public String isMensualisee {get; set;}
        public String planApurement {get; set;}
        public String montantApurement {get; set;}
        public String soldeApurement {get; set;}
        public String caseId {get; set;}
    }
}