/**
 * @description       : Service class for RechercherPrixServices operation of the PrixEtRemisesV3 WS (FT1-4381)
 * @author            : David Attali
 * @group             : 
 * @last modified on  : 01-21-2021
 * @last modified by  : David ATTALI
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   01-21-2021   David ATTALI    Initial Version
**/
public class SM_SM005_RechercherPrixServices {
    
    public class WrapperInput {
        public String idOffre;
        public String puissance;
        public String typeDeComptage;
        public String plageDeConsommation;
        public String tauxGazVert;
    }
    
    public class WrapperOutput {
        public String code;

        public String libelle;
        public String idOffre;
        public Double prixMensuelTTC;
        public List<AdditionalPrice> additionalPrices = new List<AdditionalPrice>();
    }
    
    public class AdditionalPrice {
        public Double prixMensuelTTC;
        public Map<String, String> criterias = new Map<String, String>();

    }
    
    /**
     * @description Call RechercherPrixServices operation of the PrixEtRemisesV3 WS
     * @param WrapperInput wrapperInput
     * @return WrapperOutput
     */
    public static WrapperOutput getPrixServices(WrapperInput wrapperInput){

        // Context initialization
        SM_OCTOPUS__c octopusCustomSetting = SM_OCTOPUS__c.getOrgDefaults();
        gdfsuezComBefChpCommunV3.contextDt contextDt = initContext(octopusCustomSetting);
        
        // Preparation of specific call parameters
        List<gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesInputDt> rechercherPrixServicesInputDts = new List<gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesInputDt>();

        gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesInputDt rechercherPrixServicesInputDt = new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesInputDt();
        
        // Specific parameter : Date management (idOffre : EFOPT_VERT and GOPT_VERT)
        Date todayDate = Date.today();
        Date firstDate = todayDate.toStartOfMonth();
        
        if(todayDate.isSameDay(firstDate)){
            rechercherPrixServicesInputDt.datePropositionCommerciale = firstDate;
            rechercherPrixServicesInputDt.dateEffetContrat = firstDate;
        } else {
            rechercherPrixServicesInputDt.datePropositionCommerciale = todayDate.addMonths(1).toStartOfMonth();
            rechercherPrixServicesInputDt.dateEffetContrat = todayDate.addMonths(1).toStartOfMonth();
        }
        
        rechercherPrixServicesInputDt.contexteSouscription = 'PREM_MES';
        
        // Specifics parameters : idOffre/criteres_element
        List<gdfsuezBefCalypsoPrixetremisesV3.criteres_element> criteresElements = new List<gdfsuezBefCalypsoPrixetremisesV3.criteres_element>();
        
        if(wrapperInput.idOffre == 'EFOPT_VERT'){
            
            rechercherPrixServicesInputDt.idOffre = 'EFOPT_VERT';
            
            gdfsuezBefCalypsoPrixetremisesV3.criteres_element critereElement01 = new gdfsuezBefCalypsoPrixetremisesV3.criteres_element();
            gdfsuezBefCalypsoPrixetremisesV3.criteres_element critereElement02 = new gdfsuezBefCalypsoPrixetremisesV3.criteres_element();
            
            critereElement01.parametre = 'ZZTYC';
            critereElement01.valeur = wrapperInput.typeDeComptage;
            criteresElements.add(critereElement01);
            
            critereElement02.parametre = 'ZZPS';
            critereElement02.valeur = wrapperInput.puissance;
            criteresElements.add(critereElement02);
            
        } else if(wrapperInput.idOffre == 'GOPT_VERT'){
            
            rechercherPrixServicesInputDt.idOffre = 'GOPT_VERT';
            
            // Get rate default value for Option GazVert
            
     
            String rate;
            if (WrapperInput.tauxGazVert != null){
               rate = WrapperInput.tauxGazVert;
            } else {
                SM_TauxOptionGazVert__mdt tauxOptionGazVert = [SELECT Rate__c FROM SM_TauxOptionGazVert__mdt WHERE DeveloperName = 'DefaultValue' LIMIT 1];
                rate = tauxOptionGazVert.Rate__c;
            }
            
            gdfsuezBefCalypsoPrixetremisesV3.criteres_element critereElement01 = new gdfsuezBefCalypsoPrixetremisesV3.criteres_element();
            gdfsuezBefCalypsoPrixetremisesV3.criteres_element critereElement02 = new gdfsuezBefCalypsoPrixetremisesV3.criteres_element();
            
            critereElement01.parametre = 'ZZCAE';
            critereElement01.valeur = wrapperInput.plageDeConsommation;
            criteresElements.add(critereElement01);
            
            critereElement02.parametre = 'ZZTAUX';
            critereElement02.valeur = rate;
            criteresElements.add(critereElement02);
        }
        
        rechercherPrixServicesInputDt.criteres = criteresElements;
        rechercherPrixServicesInputDts.add(rechercherPrixServicesInputDt);
        
        System.debug('size rechercherPrixServicesInputDts ' + rechercherPrixServicesInputDts.size());
        
        // Preparation of general call parameters
        gdfsuezBefCalypsoPrixetremisesV3.PrixEtRemisesPort prixEtRemisesPort = new gdfsuezBefCalypsoPrixetremisesV3.PrixEtRemisesPort();
        

        SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'PrixEtRemises_v2' limit 1];
        prixEtRemisesPort.endpoint_x = octopusCustomSetting.endpoint__c + suffixs.suffix__c;

        
        Map<String, String> headers = new Map<String, String>();
        headers.put('Content-Type', 'text/xml;charset=utf-8');
        prixEtRemisesPort.inputHttpHeaders_x = headers;
        
        prixEtRemisesPort.clientCertName_x = octopusCustomSetting.certName__c;
        prixEtRemisesPort.timeout_x = 30000;
        
        // Call
        gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesResponse_element rechercherPrixServicesResponseElement = new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesResponse_element();
        rechercherPrixServicesResponseElement = prixEtRemisesPort.RechercherPrixServices(rechercherPrixServicesInputDts, contextDt);

        WrapperOutput wrapperOutput = new WrapperOutput();
        
        // Return code status handle
        gdfsuezComBefChpCommunV3.messageRetoursDt messageRetoursDt = rechercherPrixServicesResponseElement.messageRetours;
        gdfsuezComBefChpCommunV3.messageRetour_element messageRetourElement = messageRetoursDt.messageRetour.get(0);
        
        System.debug('messageRetourElement.code ' + messageRetourElement.code);
        System.debug('messageRetourElement.type_x ' + messageRetourElement.type_x);
        System.debug('messageRetourElement.libelle ' + messageRetourElement.libelle);
        System.debug('messageRetourElement.source ' + messageRetourElement.source);
            
       wrapperOutput.code = messageRetourElement.code;
        wrapperOutput.libelle = messageRetourElement.libelle;
        
        System.debug('size rechercherPrixServicesOutput ' + rechercherPrixServicesResponseElement.rechercherPrixServicesOutput.size());
    
        // Return data handle (in case of 'OCTOPUS_RechercherPrixService_01' code)
        if(messageRetourElement.code == 'OCTOPUS_RechercherPrixService_01'){
            
            gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesOutputDt rechercherPrixServicesOutputDt = rechercherPrixServicesResponseElement.rechercherPrixServicesOutput.get(0);
            
            // Data block donneesPrix
            for(gdfsuezBefCalypsoPrixetremisesV3.donneesPrixOutDt donneesPrixOutDt : rechercherPrixServicesOutputDt.donneesPrix){
                
                System.debug('//////////////////// BLOC donneesPrix ////////////////////');
                System.debug('- idOffre ' + donneesPrixOutDt.idOffre);
                System.debug('- datePropositionCommerciale ' + donneesPrixOutDt.datePropositionCommerciale);
                System.debug('- dateEffetContrat ' + donneesPrixOutDt.dateEffetContrat);
                System.debug('- typePrix ' + donneesPrixOutDt.typePrix);
                
                wrapperOutput.idOffre = donneesPrixOutDt.idOffre;
                
                for(gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDt donneesPrixDt : donneesPrixOutDt.donneesPrix){
                    
                    gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDetailsDt donneesPrixDetailsDt = donneesPrixDt.donneesPrixDetails;
                    
                    System.debug('--- prixMensuelHT' + donneesPrixDetailsDt.prixMensuelHT);
                    System.debug('--- prixMensuelTTC' + donneesPrixDetailsDt.prixMensuelTTC);
                    System.debug('--- prixAnnuelHT' + donneesPrixDetailsDt.prixAnnuelHT);
                    System.debug('--- prixAnnuelTTC' + donneesPrixDetailsDt.prixAnnuelTTC);
                    

                    wrapperOutput.prixMensuelTTC = donneesPrixDetailsDt.prixMensuelTTC;

                    
                    for(gdfsuezBefCalypsoPrixetremisesV3.donneesPrixCriteresDt donneesPrixCriteresDt : donneesPrixDt.donneesPrixCriteres){
                        System.debug('----- donneesPrixParametre ' + donneesPrixCriteresDt.donneesPrixParametre);
                        System.debug('----- donneesPrixValeur ' + donneesPrixCriteresDt.donneesPrixValeur); 
                    }
                }  
            }
            
            // Data block donneesPrixAnnexe
            for(gdfsuezBefCalypsoPrixetremisesV3.donneesPrixOutDt donneesPrixOutDt : rechercherPrixServicesOutputDt.donneesPrixAnnexe){
                
                System.debug('//////////////////// BLOC donneesPrixAnnexe ////////////////////');
                System.debug('- idOffre ' + donneesPrixOutDt.idOffre);
                System.debug('- datePropositionCommerciale ' + donneesPrixOutDt.datePropositionCommerciale);
                System.debug('- dateEffetContrat ' + donneesPrixOutDt.dateEffetContrat);
                System.debug('- typePrix ' + donneesPrixOutDt.typePrix);
                
                for(gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDt donneesPrixDt : donneesPrixOutDt.donneesPrix){
                    
                    gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDetailsDt donneesPrixDetailsDt = donneesPrixDt.donneesPrixDetails;
                    
                    System.debug('--- prixMensuelHT' + donneesPrixDetailsDt.prixMensuelHT);
                    System.debug('--- prixMensuelTTC' + donneesPrixDetailsDt.prixMensuelTTC);
                    System.debug('--- prixAnnuelHT' + donneesPrixDetailsDt.prixAnnuelHT);
                    System.debug('--- prixAnnuelTTC' + donneesPrixDetailsDt.prixAnnuelTTC);
                    

                    AdditionalPrice additionalPrice = new AdditionalPrice();
                    additionalPrice.prixMensuelTTC = donneesPrixDetailsDt.prixMensuelTTC;
                    wrapperOutput.additionalPrices.add(additionalPrice);
                    
                    for(gdfsuezBefCalypsoPrixetremisesV3.donneesPrixCriteresDt donneesPrixCriteresDt : donneesPrixDt.donneesPrixCriteres){
                        
                        System.debug('----- donneesPrixParametre ' + donneesPrixCriteresDt.donneesPrixParametre);
                        System.debug('----- donneesPrixValeur ' + donneesPrixCriteresDt.donneesPrixValeur);  

                        additionalPrice.criterias.put(donneesPrixCriteresDt.donneesPrixParametre, donneesPrixCriteresDt.donneesPrixValeur);

                    }
                }
            }
        }
        return wrapperOutput;
    }
    
    /**
     * @description Initializes the context of the call
     * @param SM_OCTOPUS__c octopusCustomSetting
     * @return gdfsuezComBefChpCommunV3.contextDt
     */
    private static gdfsuezComBefChpCommunV3.contextDt initContext(SM_OCTOPUS__c octopusCustomSetting){
        
        gdfsuezComBefChpCommunV3.system_element systemElement = new gdfsuezComBefChpCommunV3.system_element();
        systemElement.systemId = octopusCustomSetting.appName__c;
        
        List<gdfsuezComBefChpCommunV3.system_element> systemElements = new List<gdfsuezComBefChpCommunV3.system_element>();
        systemElements.add(systemElement);
        
        gdfsuezComBefChpCommunV3.contextDt contextDt = new gdfsuezComBefChpCommunV3.contextDt();
        contextDt.version = '1.00';
        contextDt.systemPath = new gdfsuezComBefChpCommunV3.systemPath_element();
        contextDt.systemPath.system_x = systemElements;
        
        return contextDt;
    }
}