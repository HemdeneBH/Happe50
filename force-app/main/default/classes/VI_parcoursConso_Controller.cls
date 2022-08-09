public class VI_parcoursConso_Controller {
    
    
    @AuraEnabled(cacheable=false)
    public static Decimal getEstimationGaz(String anneeConstruction, String codePostal, String energieChauffage, String typeChauffage, Integer nbrPersonnesFoyer,
                                           Integer surface,String energieECS, String typeECS, String energieCuisson, String typeLogement, String typeResidence ){
                                               System.debug('### START getEstimationGaz : ' + 
                                                            'codePostal : ' + codePostal +
                                                            'energieChauffage : ' + energieChauffage +
                                                            'typeChauffage : ' + typeChauffage +
                                                            'nbrPersonnesFoyer : ' + nbrPersonnesFoyer +
                                                            'surface : ' + surface +
                                                            'energieECS : ' + energieECS +
                                                            'typeECS : ' + typeECS +
                                                            'energieCuisson : ' + energieCuisson +
                                                            'typeLogement : ' + typeLogement +
                                                            'typeResidence : ' + typeResidence +
                                                            'anneeConstruction : ' + anneeConstruction);
                                               Decimal EstimationGaz; 
                                               String anneeConstructionInput = anneeConstruction;
                                               String energieChauffageCode = energieChauffage;
                                               String typeChauffageCode = typeChauffage;
                                               String energieECSCode = energieECS;
                                               String typeECSCode = typeECS;   
                                               String energieCuissonCode = energieCuisson;
                                               String typeLogementCode = typeLogement;
                                               String typeResidenceCode = typeResidence;
                                               EstimationGaz = VI_SM019_EstimerGazConsommation.estimerGaz(anneeConstructionInput, codePostal, energieChauffageCode, energieECSCode, 
                                                                                                          nbrPersonnesFoyer, surface, typeChauffageCode, typeECSCode, energieCuissonCode, 
                                                                                                          typeLogementCode,typeResidenceCode, 'VI', 'V3', 'callout:VI_AuthOctopus');
                                               System.debug('### END getEstimationGaz - EstimationGaz : ' + EstimationGaz);
                                               return EstimationGaz;
                                           }
    
    @AuraEnabled(cacheable=false)
    public static Decimal getEstimationElec(String anneeConstruction, String codePostal, String energieChauffage, String energieECS, 
                                            Integer nbrPersonnesFoyer, Integer surface, String typeChauffage,
                                            String typeECS, String typeLogement, String typeResidence, String energieCuisson, Boolean laveLingExists,
                                            Boolean congelateurExists, Boolean laveVaisselleExists,Boolean secheLingeExists){
                                                Decimal EstimationElec; 
                                                String anneeConstructionInput = anneeConstruction;
                                                String energieChauffageCode = energieChauffage;
                                                String typeChauffageCode = typeChauffage;
                                                String energieECSCode = energieECS;
                                                String typeECSCode = typeECS;   
                                                String typeLogementCode = typeLogement;
                                                String typeResidenceCode = typeResidence;
                                                String energieCuissonCode = energieCuisson;                                       
                                                EstimationElec = VI_SM020_EstimerElecConsommation.estimerElec(anneeConstructionInput, codePostal,  energieChauffageCode,  energieECSCode,  nbrPersonnesFoyer,  surface, 
                                                                                                              typeChauffageCode,  typeECSCode,  typeLogementCode,  typeResidenceCode, energieCuissonCode, 
                                                                                                              laveLingExists,congelateurExists,  laveVaisselleExists, secheLingeExists, 'VI', 'V3', 'callout:VI_AuthOctopus');
                                                System.debug('### END getEstimationElec - EstimationElec : ' + EstimationElec);
                                                return EstimationElec;
                                            }
    
    @AuraEnabled(cacheable=false)
    public static VI_SM017_PreconiserRepartitionHPHCConso.EstimationHPHC getEstimationElecHPHC(String energieChauffage, String energieECS, String typeChauffage, String typeECS){
        VI_SM017_PreconiserRepartitionHPHCConso.EstimationHPHC EstimationElec; 
        String energieChauffageCode = energieChauffage;
        String typeChauffageCode = typeChauffage;
        String energieECSCode = energieECS;
        String typeECSCode = typeECS;   
        EstimationElec = VI_SM017_PreconiserRepartitionHPHCConso.getRepartitionHPHC( energieChauffageCode,  energieECSCode,  typeChauffageCode,  typeECSCode, 'VI', 'V3', 'callout:VI_AuthOctopus');
        return EstimationElec;
    }
    
    @AuraEnabled(cacheable=false)
    public static VI_SM018_Preconiser3cadransConso.Estimation3Cadrans getEstimationElecHPHCWE(String energieChauffage, String energieECS, String typeChauffage, String typeECS){
        VI_SM018_Preconiser3cadransConso.Estimation3Cadrans EstimationElec; 
        String energieChauffageCode = energieChauffage;
        String typeChauffageCode = typeChauffage;
        String energieECSCode = energieECS;
        String typeECSCode = typeECS;   
        EstimationElec = VI_SM018_Preconiser3cadransConso.preconiser3cadrans( energieChauffageCode,  energieECSCode,  typeChauffageCode,  typeECSCode, 'VI', 'V3', 'callout:VI_AuthOctopus');
        return EstimationElec;
    }
    
    @AuraEnabled(cacheable=false)
    public static Map<String, Map<String, String>> getCustomSettings(){
        Map<String, Map<String, String>> parcoursMappings = new Map<String, Map<String, String>>();
        List<Parcours_Mapping__c> mappings = Parcours_Mapping__c.getall().values();
        for(Parcours_Mapping__c mapping : mappings){
            if(!parcoursMappings.containsKey(mapping.Field_Name__c)){
                
                parcoursMappings.put(mapping.Field_Name__c, new Map<String, String>());
            }
            Map<String, String> keyValue = parcoursMappings.get(mapping.Field_Name__c);
            keyValue.put(mapping.API_Value__c, mapping.Local_Value__c);
            parcoursMappings.put(mapping.Field_Name__c, keyValue);
        }
        return parcoursMappings;
    }  
    
    
    @AuraEnabled(cacheable=false)
    public static ConsoResponse getEstimationLWC(VI_parcours__c parcours){
        system.debug('### Start getEstimationLWC');
        Map<String, Map<String, String>> parcoursMappings = getCustomSettings();
        system.debug('### parcoursMappings :  ' + parcoursMappings);
        system.debug('VI_EnergieChauffageSaisieConso__c '+parcours.VI_EnergieChauffageSaisieConso__c);
        String anneeConstruction = parcoursMappings.get('VI_AnneeConstructionLogementSaisieConso__c').get(parcours.VI_AnneeConstructionLogementSaisieConso__c);
        String energieChauffage = parcoursMappings.get('VI_EnergieChauffageSaisieConso__c').get(parcours.VI_EnergieChauffageSaisieConso__c);
        String energieECS = parcoursMappings.get('VI_EnergieEauChaudeSaisieConso__c').get(parcours.VI_EnergieEauChaudeSaisieConso__c);
        String typeChauffage = parcoursMappings.get('VI_DispositifChauffageSaisieConso__c').get(parcours.VI_DispositifChauffageSaisieConso__c);
        String typeECS = parcoursMappings.get('VI_DispositifEauChaudeSaisieConso__c').get(parcours.VI_DispositifEauChaudeSaisieConso__c);
        String typeLogement = parcoursMappings.get('VI_TypeLogementSaisieConso__c').get(parcours.VI_TypeLogementSaisieConso__c);
        String typeResidence = parcoursMappings.get('VI_TypeResidenceSaisieConso__c').get(parcours.VI_TypeResidenceSaisieConso__c);
        String energieCuisson = parcoursMappings.get('VI_EnergieCuissonSaisieConso__c').get(parcours.VI_EnergieCuissonSaisieConso__c);
        Integer nbrPersonnesFoyer = Integer.valueOf(parcours.VI_NombreOccupantLogementSaisieConso__c);
        Integer surface = Integer.valueOf(parcours.VI_SurfaceLogementSaisieConso__c);
        Decimal estimationGaz;
        Decimal estimationElec;
        Decimal estimationElecHP;
        Decimal estimationElecHC;
        try{
            system.debug('estimationGaz');
            //estimate Gaz
            estimationGaz = getEstimationGaz(anneeConstruction,
                                             parcours.VI_CodePostalRechercheLocal__c, 
                                             energieChauffage, 
                                             typeChauffage, 
                                             nbrPersonnesFoyer,
                                             surface,
                                             energieECS, 
                                             typeECS,
                                             energieCuisson, 
                                             typeLogement, 
                                             typeResidence );
            
            system.debug('estimationGaz'+ estimationGaz);
            //estimate Elec
            string codePostal = (parcours.VI_CodePostalRechercheLocal__c != null?parcours.VI_CodePostalRechercheLocal__c.substring(0,2): null);
            estimationElec = getEstimationElec(anneeConstruction, 
                                               codePostal, 
                                               energieChauffage,  
                                               energieECS, 
                                               nbrPersonnesFoyer, 
                                               surface, 
                                               typeChauffage,
                                               typeECS,
                                               typeLogement, 
                                               typeResidence,
                                               energieCuisson,
                                               parcours.VI_LaveLingeElecSaisieConso__c,
                                               parcours.VI_CongelateurElecSaisieConso__c,
                                               parcours.VI_LaveVaisselleElecSaisieConso__c,
                                               parcours.VI_SecheLingeElecSaisieConso__c); 
            system.debug('estimationElec'+ estimationElec);
            if(parcours.VI_SaisieConsommationElec_HP_HC__c == true || parcours.VI_SaisieEstimationConsoElec_HP_HC__c == 'Oui'){
                System.debug('### energieChauffage : ' + energieChauffage);
                System.debug('### energieECS : ' + energieECS);
                System.debug('### typeChauffage : ' + typeChauffage);
                System.debug('### typeECS : ' + typeECS);
                VI_SM017_PreconiserRepartitionHPHCConso.EstimationHPHC EstimationElecHPHC = getEstimationElecHPHC(energieChauffage,  energieECS,  typeChauffage,  typeECS);
                system.debug('estimationElec '+estimationElec);
                system.debug('cleRepartitionHP '+EstimationElecHPHC.cleRepartitionHP);
                system.debug('cleRepartitionHP '+EstimationElecHPHC.cleRepartitionHC);
                estimationElecHP = estimationElec*EstimationElecHPHC.cleRepartitionHP;
                estimationElecHC = estimationElec*EstimationElecHPHC.cleRepartitionHC;
                system.debug('EstimationElecHPHC'+ EstimationElecHPHC);
            }
            
            system.debug('estimationElecHP'+ estimationElecHP);
            system.debug('estimationElecHC'+ estimationElecHC);
            system.debug('estimationElec'+ estimationElec);
            system.debug('estimationGaz'+ estimationGaz);
            parcours.VI_Estimation_conso_gaz__c = estimationGaz;
            parcours.VI_Estimation_conso_elec_HP__c = (estimationElecHP != null? estimationElecHP: estimationElec);
            parcours.VI_Estimation_conso_elec_HC__c = estimationElecHC;
            system.debug('parcours'+ parcours);
            //update parcours;
            return new ConsoResponse(parcours, null);
        }
        catch(exception e ){
            system.debug('e.getMessage()'+ e.getMessage());
            return new ConsoResponse(parcours, e.getMessage());
        }
        
    } 
    
    public class ConsoResponse{
        @AuraEnabled
        public VI_parcours__c parcours;
        @AuraEnabled
        public String message;
        public ConsoResponse(VI_parcours__c parcours, String message){
            this.parcours = parcours;
            this.message = message;
        }
    }
}