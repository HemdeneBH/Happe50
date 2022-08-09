/*
*@Author: Paul Ghoussoub
*@Description: Remonter les options et services à afficher dans le parcours
*@CreatedDate: 2/5/2022
*/

public without sharing class VI_parcoursOptionsEtServices_Controller {
    /* @author Paul Ghoussoub
* @date 2/5/2022
* @description Recuperer les options et services
* @param parcours
* @return OptionsEtServices wrapper defined in this class
*/
    @AuraEnabled(cacheable=false)
    public static OptionsEtServices getOptionsEtServices(VI_parcours__c parcours){
        OptionsEtServices optionsEtService=new OptionsEtServices();
        
        User currentUser = [SELECT Id, AccountId, Account.Name
                            FROM User 
                            WHERE Id =: UserInfo.getUserId()];
        String AccountId = currentUser.AccountId;
        String energie = (parcours.VI_ChoixEnergie__c == 'Electricité'? 'Elec':(parcours.VI_ChoixEnergie__c == 'Gaz'?'Gaz':'Duo'));
        String typeComptage = (parcours.VI_SaisieConsommationElec_HP_HC__c == true || parcours.VI_SaisieEstimationConsoElec_HP_HC__c == 'Oui' ? 'HPHC':'SIMPLE');
        String plageConsommation = parcours.VI_GazPlageConso__c!=null?(String.valueOf(parcours.VI_GazPlageConso__c)):'6000';
        List<wrapperPromotion> promotionsToAdd = new List<wrapperPromotion>();
        List<VI_SM051_Promobox.Promotion> listPromos;
        
        if(energie != 'Gaz'){
            String puissanceVert = (parcours.VI_EstimationPuissance__c == null?'6':parcours.VI_EstimationPuissance__c);
            OptionValues optionValuesElec = prepareOffreVerteElec('EFOPT_VERT', System.now() , System.now(),'PREM_MES',typeComptage, puissanceVert);
            optionsEtService.optionValueElec = optionValuesElec.optionValue;
            optionsEtService.optionValueElecHT = optionValuesElec.optionValueHT;
            if(optionsEtService.optionValueElec != null){
                optionsEtService.optionLabelElec = 'Option Elec Vert+';
                optionsEtService.optionCodeElec = 'EFOPT_VERT';
            }
        }
        if(energie != 'Elec'){
            optionValues optionValueGaz = prepareOffreVerteGaz('GOPT_VERT', System.now() , System.now(),'PREM_MES',plageConsommation, '10');
            optionsEtService.optionValueGaz = optionValueGaz.optionValue;
            optionsEtService.optionValueGazHT = optionValueGaz.optionValueHT;
            if(optionsEtService.optionValueGaz != null){
                optionsEtService.optionLabelGaz = 'Option Gaz Vert+';
                optionsEtService.optionCodeGaz = 'GOPT_VERT';
            }
        }
        if(AccountId != null){
            List<VI_ServicePayant__c> servicePayants = [SELECT Id, VI_NomDuService__c 
                                                        FROM VI_ServicePayant__c 
                                                        WHERE VI_Partenaire__c = :AccountId];
            for(VI_ServicePayant__c sp :servicePayants){
                if(sp.VI_NomDuService__c == 'Assurance Facture'){
                    optionsEtService.hasAssuranceFacture = true;
                    VI_SM042_AssuranceFacture.cls_offreList assuranceFacture = VI_SM042_AssuranceFacture.getOffresAvailables(String.valueOf(parcours.VI_NumeroRueRechercheLocal__c),parcours.VI_RueRechercheLocal__c,String.valueOf(parcours.VI_CodePostalRechercheLocal__c),parcours.VI_CommuneRechercheLocal__c,
                                                                                                                             'FR','Etage: '+String.valueof(parcours.VI_NumeroEtageRechercheLocal__c),parcours.VI_NumeroAppartementRechercheLocal__c,'','partenaire','smile',
                                                                                                                             'VI','local.VIToken'); 
                    if(assuranceFacture != null){
                        optionsEtService.AssuranceFacturePrixTTC = Decimal.valueof(assuranceFacture.prixMois);
                    }
                }
                if(sp.VI_NomDuService__c == 'Promotion'){
                    optionsEtService.promoEligible=true;
                    listPromos=VI_SM051_Promobox.recupererCodePromo(parcours,parcours.VI_Code_pack__c,parcours.VI_OffreChoisieElecPanierClient__c,parcours.VI_OffreChoisieGazPanierClient__c,'VI','local.VIToken');
                    system.debug('¤listPromos : ' + listPromos);
                    if (listPromos!=null && listPromos.size() > 0) {
                        for (VI_SM051_Promobox.Promotion infoPromo : listPromos){
                            wrapperPromotion promo = new wrapperPromotion(infoPromo.NumPromotion, infoPromo.CodePromo, infoPromo.LibelleSurFacture, infoPromo.NomPromotion, infoPromo.DescriptifPromotion, infoPromo.DebutValidity, infoPromo.FinValidity, infoPromo.CanalDeVente);
                            promotionsToAdd.add(promo);
                        }   
                    }
                    optionsEtService.promotions=promotionsToAdd;
                }
            }
        }
        return optionsEtService;
    }
    
        /* @author Amal Chreiteh
* @date 2/12/2020
* @description preparer les offres Vertes
* @param idOffre,  datePropositionCommerciale, dateEffetContrat, contexteSouscription, TypedeComptage,  puissance
* @return optionValues wrapper defined in this class
*/
    
    public static optionValues prepareOffreVerteElec(String idOffre, DateTime datePropositionCommerciale,DateTime dateEffetContrat,
                                                     String contexteSouscription,String TypedeComptage, String puissance)
    {
        //Decimal optionValue;
        optionValues optionValuesElec;
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt input=VI_SM022_PrixEtRemises.createInputPrixEtServices( idOffre,
                                                                                                                                 datePropositionCommerciale,
                                                                                                                                 dateEffetContrat,
                                                                                                                                 contexteSouscription,
                                                                                                                                 TypedeComptage,
                                                                                                                                 puissance);
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesResponse_element response  = VI_SM022_PrixEtRemises.recherchePrixetService(input,'callout:VI_AuthOctopus','VI','V2');
        
        System.debug('### response response : ' + response);
        if (response != null && response.messageRetours != null && response.messageRetours.messageRetour != null ) {
            for (VI_gdfsuezComBefChpCommunV3.messageRetour_element msgRetour : response.messageRetours.messageRetour) {
                if ('ERREUR'.equalsIgnoreCase(msgRetour.type_x)) {
                    
                }
            }
        }
        if (response != null && response.rechercherPrixServicesOutput != null){
            for(VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesOutputDt output :response.rechercherPrixServicesOutput){
                for(VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixOutDt prixOutput: output.donneesPrix){
                    for(VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixDt prixOut: prixOutput.donneesPrix){
                        if(prixOut.donneesPrixDetails != null){
                            optionValuesElec = new optionValues(prixOut.donneesPrixDetails.prixMensuelTTC, prixOut.donneesPrixDetails.prixMensuelHT);
                        }
                    }
                }
            }
        }
        return optionValuesElec;
    }
     /* @author Amal Chreiteh
* @date 2/12/2020
* @description preparer les offres Vertes Gaz
* @param idOffre,  datePropositionCommerciale, dateEffetContrat, contexteSouscription, TypedeComptage,  puissance
* @return optionValues wrapper defined in this class
*/
    public static optionValues prepareOffreVerteGaz(String idOffre, DateTime datePropositionCommerciale,DateTime dateEffetContrat,
                                                    String contexteSouscription,String plageConsommation, String pourcentage)
    {
        //Decimal optionValue;
        optionValues optionValuesGaz;
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt input=VI_SM022_PrixEtRemises.createInputPrixEtServicesGaz( idOffre,
                                                                                                                                    datePropositionCommerciale,
                                                                                                                                    dateEffetContrat,
                                                                                                                                    contexteSouscription,
                                                                                                                                    plageConsommation,
                                                                                                                                    pourcentage);
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesResponse_element response  = VI_SM022_PrixEtRemises.recherchePrixetService(input,'callout:VI_AuthOctopus','VI','V2');
        if (response != null && response.messageRetours != null && response.messageRetours.messageRetour != null ) {
            for (VI_gdfsuezComBefChpCommunV3.messageRetour_element msgRetour : response.messageRetours.messageRetour) {
                if ('ERREUR'.equalsIgnoreCase(msgRetour.type_x)) {
                    system.debug('msgRetour : '+ msgRetour);
                    system.debug('msgRetour.libelle : '+ msgRetour.libelle);
                }
            }
        }
        if (response != null && response.rechercherPrixServicesOutput != null){
            for(VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesOutputDt output :response.rechercherPrixServicesOutput){
                for(VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixOutDt prixOutput: output.donneesPrix){
                    for(VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixDt prixOut: prixOutput.donneesPrix){
                        if(prixOut.donneesPrixDetails != null){
                            optionValuesGaz = new optionValues(prixOut.donneesPrixDetails.prixMensuelTTC, prixOut.donneesPrixDetails.prixMensuelHT);
                        }
                    }
                }
            }
        }
        return optionValuesGaz; 
    }
    
    
    public class OptionsEtServices{
        @AuraEnabled
        public String optionCodeElec;
        @AuraEnabled
        public String optionLabelElec;
        @AuraEnabled
        public Decimal optionValueElec;
        @AuraEnabled
        public Decimal optionValueElecHT;
        @AuraEnabled
        public String optionCodeGaz;
        @AuraEnabled
        public String optionLabelGaz;
        @AuraEnabled
        public Decimal optionValueGaz;
        @AuraEnabled
        public Decimal optionValueGazHT;
        @AuraEnabled
        public Boolean hasAssuranceFacture;
        @AuraEnabled
        public Decimal AssuranceFacturePrixTTC;
        @AuraEnabled
        public List<wrapperPromotion> promotions;
        @AuraEnabled
        public Boolean promoEligible;
    }
    
    public class OptionValues{
        @AuraEnabled
        public Decimal optionValue;
        @AuraEnabled
        public Decimal optionValueHT;
        public optionValues(Decimal optionValue, Decimal optionValueHT){
            this.optionValue = optionValue;
            this.optionValueHT = optionValueHT;
        }
    }
    
    public class wrapperPromotion {
        @AuraEnabled
        public String NumPromotion;
        @AuraEnabled
        public String CodePromo;
        @AuraEnabled
        public String LibelleSurFacture;
        @AuraEnabled
        public String NomPromotion;
        @AuraEnabled
        public String DescriptifPromotion;
        @AuraEnabled
        public String DebutValidity;
        @AuraEnabled
        public String FinValidity;
        @AuraEnabled
        public String CanalDeVente;
        public wrapperPromotion(String NumPromotion, String CodePromo, String LibelleSurFacture, String NomPromotion, 
                                String DescriptifPromotion, String DebutValidity, String FinValidity, String CanalDeVente){
            this.NumPromotion = NumPromotion;
            this.CodePromo = CodePromo;
            this.LibelleSurFacture = LibelleSurFacture;
            this.NomPromotion = NomPromotion;
            this.DescriptifPromotion = DescriptifPromotion;
            this.DebutValidity = DebutValidity;
            this.FinValidity = FinValidity;
            this.CanalDeVente = CanalDeVente;
        }
        /* End DDPCM - 1192 */
    }
}