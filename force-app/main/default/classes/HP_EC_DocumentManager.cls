/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 07-27-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
public without sharing class HP_EC_DocumentManager {
    
    @AuraEnabled(cacheable=true)
    public static Object getContractDocumentsInfo(String idPortfolio) {
        System.debug('HP_EC_DocumentManager.getContractDocumentsInfo | Method Start');
        Object resultObject = null;
        try {
                Map<string, object> contractUntyped= (Map<string, object>)JSON.deserializeUntyped((String)HP_EC_LoadCustomerData.getContractData());
                List<Integer> pftcList = new List<Integer>();
                List<Object> myList = (List<Object>)contractUntyped.get('_data');
                for(Object obj : myList){
                    pftcList.add((Integer)((Map<String,Object>)obj).get('idPortefeuilleContrat'));
                }
                if (pftcList.contains(Integer.valueOf(idPortfolio))) {
                    resultObject = HP_SM001_Agilab.getDocumentsAgilab(idPortfolio);
                }
        }
        catch (Exception ex) {
            System.debug('HP_EC_DocumentManager.getContractDocumentsInfo | Exception : ' + ex.getMessage());
            string exceptionMessage = Label.HP_EC_InternalError; 
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        System.debug('HP_EC_DocumentManager.getContractDocumentsInfo | Method Exit');
        return resultObject;
    }

    @AuraEnabled(cacheable=true)
    public static string getJustificatif(string portfolioId){
        System.debug('HP_EC_DocumentManager.getJustificatif | Method Start');
        String result;
        try {
            EmailTemplate emailTemplate = [SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body FROM EmailTemplate WHERE name = 'HP_JustificatifDomicile'];
            String htmlBody = emailTemplate.HtmlValue;

            System.debug('emailTemplate.HtmlValue : '+htmlBody);
            //Replace all merge fields
            htmlBody.replace('{header_document}', '');
            htmlBody.replace('{hp_capital_GDF_SUEZ}', '');
            htmlBody.replace('{hp_adr_gdfsuez_siege}', '');
            htmlBody.replace('{hp_numero_tva_gdf_suez}', '');
            htmlBody.replace('{hp_date_today}', '');
            htmlBody.replace('{hp_code_client}', '');
            htmlBody.replace('{hp_local_adr}', '');
            htmlBody.replace('{hp_reference_contrat}', '');
            htmlBody.replace('{hp_tel_serviceClient}', '');
            htmlBody.replace('{hp_postal_serviceClient}', '');
            htmlBody.replace('{hp_tel_urgence}', '');
            htmlBody.replace('{hp_nom_client}', '');
            htmlBody.replace('{hp_date_signature}', '');
            htmlBody.replace('{ref_client}', '');
            
            Blob bodyData = Blob.toPdf(htmlBody);
            result = EncodingUtil.base64Encode(bodyData);
        } catch (Exception ex) {
            System.debug('HP_EC_DocumentManager.getJustificatif | Exception : ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
        System.debug('HP_EC_DocumentManager.getJustificatif | Method Exit');
        return result;
    }

    
    @AuraEnabled
    public static String generateJustificatifDomicilePDF(String informationJustificatifToPdf){
        System.debug('HP_GeneratePDFHelper.generateJustificatifDomicilePDF() | Method Start');
        HP_WRP054_InformationsJustificatifPDF wrapperPDF = (HP_WRP054_InformationsJustificatifPDF)System.JSON.deserializeStrict(informationJustificatifToPdf, HP_WRP054_InformationsJustificatifPDF.class);
        System.debug('Information Justificatif Received : '+wrapperPDF);
        Pagereference pdfPage = Page.HP_EC_VF_JustificatifDomicilePDF;
        
        Blob htmlBodyBlob;
        String result;

        try {
            pdfPage.getParameters().put('date_du_jour', (String)wrapperPDF.date_du_jour);
            pdfPage.getParameters().put('ref_client', (String)wrapperPDF.ref_client);
            pdfPage.getParameters().put('adresse_factu1', (String)wrapperPDF.adresse_factu1);
            pdfPage.getParameters().put('adresse_factu2', (String)wrapperPDF.adresse_factu2);
            pdfPage.getParameters().put('adresse_local', (String)wrapperPDF.adresse_local);
            pdfPage.getParameters().put('ref_contrat', (String)wrapperPDF.ref_contrat);
            pdfPage.getParameters().put('civilite_titulaire', (String)wrapperPDF.civilite_titulaire);
            pdfPage.getParameters().put('nom_titulaire', (String)wrapperPDF.nom_titulaire);
            pdfPage.getParameters().put('prenom_titulaire', (String)wrapperPDF.prenom_titulaire);
            pdfPage.getParameters().put('civilite_cotitulaire', (String)wrapperPDF.civilite_cotitulaire);
            pdfPage.getParameters().put('nom_cotitulaire', (String)wrapperPDF.nom_cotitulaire);
            pdfPage.getParameters().put('prenom_cotitulaire', (String)wrapperPDF.prenom_cotitulaire);

            pdfPage.getParameters().put('bodyParagraph', (String)wrapperPDF.bodyParagraph);

            pdfPage.getParameters().put('capital_GDF_SUEZ', (String)wrapperPDF.capital_GDF_SUEZ);
            pdfPage.getParameters().put('adr_gdfsuez_siege', (String)wrapperPDF.adr_gdfsuez_siege);
            pdfPage.getParameters().put('numero_tva_gdf_suez', (String)wrapperPDF.numero_tva_gdf_suez);
            pdfPage.getParameters().put('service_client_agilab', (String)wrapperPDF.service_client_agilab);
            pdfPage.getParameters().put('depannage_elec', (String)wrapperPDF.depannage_elec);
            pdfPage.getParameters().put('depannage_gaz', (String)wrapperPDF.depannage_gaz);

            // htmlBodyBlob = pdfPage.getContentaspdf();
            if(Test.isRunningTest()) { 
                htmlBodyBlob = blob.valueOf('Unit.Test');
            } else {
                htmlBodyBlob = pdfPage.getContentaspdf();
            }
            result = EncodingUtil.base64Encode(htmlBodyBlob);
            
        } catch (Exception ex) {
            System.debug('HP_GeneratePDFHelper.generateJustificatifDomicilePDF | Exception : ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }

        return result;
        
    }

    @AuraEnabled(cacheable=true)
    public static HP_EC_Justificatif_De_Domicile_Setting__mdt getJustificatifDeDomicileVariables() {
        System.debug('HP_EC_DocumentManager.getJustificatifDeDomicileVariables() | Methode Start');

        final String JUSTIFICATIF_DE_DOMICILE_VARIABLES = 'Justificatif_De_Domicile_Variables';

        HP_EC_Justificatif_De_Domicile_Setting__mdt justificatifDeDomicileSetting = [ SELECT DeveloperName, adr_gdfsuez_siege__c, capital_GDF_SUEZ__c, depannage_electricite__c, depannage_gaz__c, numero_tva_gdf_suez__c, service_client_agilab__c
        FROM HP_EC_Justificatif_De_Domicile_Setting__mdt WHERE DeveloperName = :JUSTIFICATIF_DE_DOMICILE_VARIABLES LIMIT 1];

        System.debug('HP_EC_DocumentManager.getJustificatifDeDomicileVariables | Method Exit');
        return justificatifDeDomicileSetting;
    }

    public class HP_WRP054_InformationsJustificatifPDF {
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
    }
}