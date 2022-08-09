/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-31-2022
 * @last modified by  : Hemdene Ben Hammouda
 * Modifications Log 
 * Ver   Date         Author                 Modification
 * 1.0   07-06-2021   Hemdene Ben Hammouda   Initial Version
**/
public with sharing class HP_SM063_WelcomeEmailSender {
    public static HP_Marketing_Definition_Key__mdt marketingDefinitionKeyConfig = null; 
    public static String definitionKey = '';

    public static void sendWelcomeEmail(Id SouscriptionId, String elecXdata, String gazXdata, Boolean okElec, Boolean okGaz){
        System.debug('HP_SM063_WelcomeEmailSender.sendWelcomeEmail | Method Start');
        HttpResponse response = null;
        try {
            marketingDefinitionKeyConfig = [SELECT Id,Label,Value__c,Is_Test__c from HP_Marketing_Definition_Key__mdt WHERE Is_Active__c = true AND Label='Bienvenue' LIMIT 1];
            definitionKey = marketingDefinitionKeyConfig.Value__c;
        } catch (QueryException ex) {
            System.debug('HP_SM063_WelcomeEmailSender.sendWelcomeEmail | Force Exit | No Active Definition Key Was Found');
        }
        if(marketingDefinitionKeyConfig != null){
            try {
                if(SouscriptionId != null){
                    HP_Souscription__c souscription = [ SELECT Id,HP_Numero_de_voie__c, HP_Nom_de_rue__c, HP_Code_postal__c, HP_Nom_de_ville__c, HP_Type_Energie__c, 
                                                        HP_code_promotion__c, HP_Parrainage__c, HP_Methode_de_paiement__c, HP_Periode_de_facturation__c, 
                                                        HP_Montant_de_la_facturation_electrique__c, HP_Montant_de_la_facturation_gaz__c, HP_OptionVert__c, HP_Jour_de_facturation__c, 
                                                        HP_type_Souscription__c, HP_Contact__r.FirstName, HP_Contact__r.LastName, HP_Contact__r.Email, HP_Contact__c, HP_Consentement_GRD__c 
                                                        FROM HP_Souscription__c WHERE Id= :SouscriptionId AND HP_Contact__c != null limit 1];
                    List<HP_Contrat__c> contList = [SELECT Id,HP_Contrat_XdataId__c, HP_StatutContrat__c,HP_Type_de_Compteur__c,(SELECT HP_OptionVertelec__c from  Options_Vertelec_Happe__r) from HP_Contrat__c where HP_Souscription__c= :SouscriptionId ];
                    System.debug('@Souscription : '+souscription);
                    System.debug('@Liste contrats : '+contList);
                    String body = buildBody(souscription,contList, elecXdata, gazXdata, okElec, okGaz);
                    System.debug('Body Request : '+body);
                    if(marketingDefinitionKeyConfig.Is_Test__c){
                        if(souscription.HP_Contact__r.Email.toLowerCase().contains('test_engie')){
                            response = HP_UTIL_HTTPUtils.calloutPostMarketing(HP_Constantes.API_MARKETING_CLOUD,body,getSubscriberKeyForWelcomeMail(contList));
                        }else{
                            system.debug('We are performing Tests ! ');
                        }
                    }else{
                        response = HP_UTIL_HTTPUtils.calloutPostMarketing(HP_Constantes.API_MARKETING_CLOUD,body,getSubscriberKeyForWelcomeMail(contList));
                    }
                    if(response != null){
                        system.debug('@@Response = '+response);
                        system.debug('@@Response Body = '+response.getBody());
                        if(response.getStatusCode() == 202){
                            System.debug('Welcome Email Sent Successfully ! ');
                        }else {
                            throw new CalloutException(response.getBody());
                        }
                    }
                }
            } catch (Exception ex) {
                System.debug('Exception : '+ex.getMessage()+'  stack'+ ex.getStackTraceString() +'  lineNumber : '+ ex.getLineNumber() + ' typeName  :  '+ex.getTypeName());
            }
        }

        System.debug('HP_SM063_WelcomeEmailSender.sendWelcomeEmail | Method Exit');
    }

    public static void sendSouscriptionEnAttenteDeValidationEmail(Id SouscriptionId, String elecXdata, String gazXdata, Boolean okElec, Boolean okGaz){
        System.debug('HP_SM063_WelcomeEmailSender.sendSouscriptionEnAttenteDeValidationEmail | Method Start');
        HttpResponse response = null;
        try {
            marketingDefinitionKeyConfig = [SELECT Id,Label,Value__c,Is_Test__c from HP_Marketing_Definition_Key__mdt WHERE Is_Active__c = true AND Label='Souscription en attente de validation' LIMIT 1];
            definitionKey = marketingDefinitionKeyConfig.Value__c;
        } catch (QueryException ex) {
            System.debug('HP_SM063_WelcomeEmailSender.sendSouscriptionEnAttenteDeValidationEmail | Force Exit | No Active Definition Key Was Found');
        }
        if(marketingDefinitionKeyConfig != null){
            try {
                if(SouscriptionId != null){
                    HP_Souscription__c souscription = [ SELECT Id,HP_Numero_de_voie__c, HP_Nom_de_rue__c, HP_Code_postal__c, HP_Nom_de_ville__c, HP_Type_Energie__c, 
                                                        HP_code_promotion__c, HP_Parrainage__c, HP_Methode_de_paiement__c, HP_Periode_de_facturation__c, 
                                                        HP_Montant_de_la_facturation_electrique__c, HP_Montant_de_la_facturation_gaz__c, HP_OptionVert__c, 
                                                        HP_Jour_de_facturation__c, HP_type_Souscription__c, HP_Contact__r.FirstName, HP_Contact__r.LastName, 
                                                        HP_Contact__r.Email, HP_Contact__c, HP_Consentement_GRD__c 
                                                        FROM HP_Souscription__c WHERE Id= :SouscriptionId AND HP_Contact__c != null limit 1];
                    List<HP_Contrat__c> contList = [SELECT Id,HP_Contrat_XdataId__c, HP_StatutContrat__c,HP_Type_de_Compteur__c,(SELECT HP_OptionVertelec__c from  Options_Vertelec_Happe__r) from HP_Contrat__c where HP_Souscription__c= :SouscriptionId ];
                    System.debug('@Souscription : '+souscription);
                    System.debug('@Liste contrats : '+contList);
                    String body = buildBody(souscription,contList, elecXdata, gazXdata, okElec, okGaz);
                    System.debug('Body Request : '+body);
                    if(marketingDefinitionKeyConfig.Is_Test__c){
                        if(souscription.HP_Contact__r.Email.toLowerCase().contains('test_engie')){
                            response = HP_UTIL_HTTPUtils.calloutPostMarketing(HP_Constantes.API_MARKETING_CLOUD,body,getSubscriberKeyForSouscriptionEnAttente(contList));
                        }else{
                            system.debug('We are performing Tests ! ');
                        }
                    }else{
                        response = HP_UTIL_HTTPUtils.calloutPostMarketing(HP_Constantes.API_MARKETING_CLOUD,body,getSubscriberKeyForSouscriptionEnAttente(contList));
                    }
                    if(response != null){
                        system.debug('@@Response = '+response);
                        system.debug('@@Response Body = '+response.getBody());
                        if(response.getStatusCode() == 202){
                            System.debug('souscriptionEnAttenteDeValidation Email Sent Successfully ! ');
                        }else {
                            throw new CalloutException(response.getBody());
                        }
                    }
                }
            } catch (Exception ex) {
                System.debug('Exception : '+ex.getMessage()+'  stack'+ ex.getStackTraceString() +'  lineNumber : '+ ex.getLineNumber() + ' typeName  :  '+ex.getTypeName());
            }
        }

        System.debug('HP_SM063_WelcomeEmailSender.sendSouscriptionEnAttenteDeValidationEmail | Method Exit');
    }

    private static String buildBody(HP_Souscription__c souscription, List<HP_Contrat__c> contList, String elecXdata, String gazXdata, Boolean okElec, Boolean okGaz){
        String prenom = souscription.HP_Contact__r.FirstName != null ? souscription.HP_Contact__r.FirstName : '';
        String typeSouscription = souscription.HP_type_Souscription__c != null ? souscription.HP_type_Souscription__c : '';
        String numeroVoie = souscription.HP_Numero_de_voie__c != null ? souscription.HP_Numero_de_voie__c : '';
        String nomRue = souscription.HP_Nom_de_rue__c != null ? souscription.HP_Nom_de_rue__c : '' ;
        String codePostal = souscription.HP_Code_postal__c != null ? souscription.HP_Code_postal__c : '' ;
        String nomVille = souscription.HP_Nom_de_ville__c != null ? souscription.HP_Nom_de_ville__c : '' ;
        String adresse = numeroVoie + ', ' + nomRue + ' ' + codePostal + ' ' + nomVille;
        String typeEnergie = souscription.HP_Type_Energie__c != null ? souscription.HP_Type_Energie__c : '' ;
        String methodePaiement = souscription.HP_Methode_de_paiement__c != null ? souscription.HP_Methode_de_paiement__c : '' ;
        String jourFacturation = souscription.HP_Jour_de_facturation__c != null ? String.valueOf(souscription.HP_Jour_de_facturation__c) : '' ;
        String periodeFacturation = souscription.HP_Periode_de_facturation__c != null ? souscription.HP_Periode_de_facturation__c : '' ;
        String montantElec = souscription.HP_Montant_de_la_facturation_electrique__c != null ? String.valueOf(souscription.HP_Montant_de_la_facturation_electrique__c) : '';
        String montantGaz = souscription.HP_Montant_de_la_facturation_gaz__c != null ? String.valueOf(souscription.HP_Montant_de_la_facturation_gaz__c) : '' ;
        String codePromotion = souscription.HP_code_promotion__c != null ? souscription.HP_code_promotion__c : '';
        String contGazId = gazXdata != null ? gazXdata : '';
        String contElecId = elecXdata != null ? elecXdata : '';
        Boolean parainage = souscription.HP_Parrainage__c != null ? souscription.HP_Parrainage__c : false ;
        Boolean optionVert = souscription.HP_OptionVert__c != null ? souscription.HP_OptionVert__c :false;
        Boolean consentementGRD = souscription.HP_Consentement_GRD__c != null ? souscription.HP_Consentement_GRD__c :false;
              
        return '{"definitionKey":"'+definitionKey+'","recipient":{"contactKey":"'+souscription.HP_Contact__c+'","to":"'+souscription.HP_Contact__r.Email+'","attributes":{"Prenom":"'+prenom+'","Type_Souscription":"'+typeSouscription+
        '","Adresse":"'+adresse+'","Type_Energie":"'+typeEnergie+'","Id_Contrat_Electricite_Xdata":"'+contElecId+'","Id_Contrat_Gaz_Xdata":"'+contGazId+'","Methode_Paiement":"'+methodePaiement+'","Jour_Facturation":"'+jourFacturation+
        '","Periode_Facturation":"'+periodeFacturation+'","Montant_Facturation_Electrique":"'+montantElec+'","Montant_Facturation_Gaz":"'+montantGaz+'","Code_Promotion":"'+codePromotion+
        '","Parrainage":"'+parainage+'","Option_Verte":"'+optionVert+'","OK_Gaz":"'+okGaz+'","OK_Electricite":"'+okElec+'","consentement_grd":"'+consentementGRD+'"}}}';
    }

    private static String getSubscriberKeyForWelcomeMail(List<HP_Contrat__c> contList){
        if(contList.size() < 0 ){
            return '';
        }else if(contList.size() < 1 && contList.size() > 0){
            return contList[0].Id + '_emailBienvenue';
        }else{
            String result='';
            for(HP_Contrat__c cont : contList){
                result = result + cont.Id;
            }
            return result + '_emailBienvenue';
        }   
    }

    private static String getSubscriberKeyForSouscriptionEnAttente(List<HP_Contrat__c> contList){
        if(contList.size() < 0 ){
            return '';
        }else if(contList.size() < 1 && contList.size() > 0){
            return contList[0].Id + '_souscriptionEnAttente';
        }else{
            String result='';
            for(HP_Contrat__c cont : contList){
                result = result + cont.Id;
            }
            return result + '_souscriptionEnAttente';
        }   
    }
}