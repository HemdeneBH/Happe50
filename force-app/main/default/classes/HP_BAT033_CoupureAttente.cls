/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 03-23-2022
 * @last modified by  : Hemdene Ben Hammouda
**/

global class HP_BAT033_CoupureAttente implements Database.Batchable<SObject>, Database.AllowsCallouts, Schedulable{
    public static final Integer BATCH_CHUNK_SIZE = 1;
    private static final String STATUT_ATTENTE = 'HP_PENDING';
    private static final String STATUT_DIFFERE = 'DELAYED_PROCESS';
    private static final String STATUT_FERME = 'CLOSED';
    private static final String TYPE_HAPPE_COUPURE = 'HP_Coupure_ReductionPuissance';
    private static final String TREVE_HIVERNALE = 'HP_DateDebutFin_Treve_Hivernale';
    private static final String GAS = 'Gas';
    private static final String REDUCTION_SOUS_TYPE = 'Réduction de puissance';	
    private static final String QUEUE_N1 = 'HP_Niveau_1';	
    private static final String A_TRAITER_STATUT = 'TO_DO';
    private static final String COUPURE_SOUS_TYPE = 'Coupure';
    private static final String COMPTEUR_TRIPHASE = 'Triphasé';
    private static final String COMPTEUR_MONOPHASE = 'Monophasé';
    private static final String REDUCTION = 'REDUCTION';
    private static final String COUPURE = 'COUPURE';
    private static final String AIDE_PARAM = 'id_client_xdata=';
    private static final String REDUC_ELEC = 'ReducElec';
    private static final String COUPURE_ELEC = 'CoupureElec';
    private static final String COUPURE_GAZ = 'CoupureGaz';

    @TestVisible
    public static String treveHivernale {
        get{
            if(treveHivernale == null){
                treveHivernale = HP_UTIL_MetadataManager.getConfigByKey(TREVE_HIVERNALE);
            }
            return treveHivernale;
        }
        private set;
    }

	global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return HP_SLCT_Case.retrievePendingCoupureQueryLocator();
        
	}

	global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT033_CoupureAttente());
	}

	global static void execute(SchedulableContext sc){
		execute();
	}

	global static void execute(){
		HP_BAT033_CoupureAttente contractualizationBatch = new HP_BAT033_CoupureAttente();
		Database.executeBatch(contractualizationBatch, BATCH_CHUNK_SIZE);
	}

	global void execute(Database.BatchableContext batchableContext, List<Case> caseList){
        System.debug('HP_BAT033_CoupureAttente.execute | Method Start');

        List<Prestation_distributeur__c> listPrestation = new List<Prestation_distributeur__c>();
        HP_EnergyContractRequest energyContractRequest;
        HP_EnergyContractResponse energyContractResponse;
        HP_EnergyResponse energyResponse;
        HP_EnergyRequest energyRequest;

        for(Case aCase : caseList){
            HP_Contrat__c aContrat = aCase.HP_Contrat__r;
            Contact cont = aCase.Contact;
            try {                         
                if(withinTreveHivernale()){
                    if(aCase.HP_Energy__c == GAS){
                        aCase.Status = STATUT_DIFFERE;
                        aCase.Description = getCurrentDateFormatted() + ' - Différé car réduction de puissance impossible sur contrat Gaz';
                        aCase.HP_TreatmentDate__c = getPeriodeHivernaleEndDate().addDays(1);
                    }else{                    
                        energyRequest = new HP_EnergyRequest(REDUCTION, aCase.HP_PDL_PCE__c,
                                                (Integer)(aContrat.HP_Type_de_Compteur__c == 'GAS' ? aContrat.HP_Index_de_Compteur__c :
                                                aContrat.HP_Compteur_Base_Plan_Index__c != null ?  aContrat.HP_Compteur_Base_Plan_Index__c :
                                                aContrat.HP_Compteur_Variable_Plan_prix_Index__c ));
                        energyResponse = HP_SM024_Case.precontratOCTOPUS(null, aContrat, energyRequest);	
                        setPuissanceReduite(energyResponse);
                        aCase.HP_Type_compteur_electricite__c = energyResponse.nombreFils == 2 ? COMPTEUR_MONOPHASE : COMPTEUR_TRIPHASE;
                        energyContractRequest =  energyContractRequestBuilder(cont, energyResponse, aContrat);
                        System.debug('HP_BAT033_CoupureAttente | energyContractRequest : '+energyContractRequest.personId);
                        energyResponse.montantCreance = getSolde(aCase);
                        energyContractResponse = HP_SM027_DistCreatePrestationElec.sendRequest(energyContractRequest, REDUCTION, energyResponse, energyRequest.energyMeterIndex != null);
                        if(energyContractResponse.isSuccess){
                            Case newCase = createPrestationCase(aCase);
                            closeCase(aCase,newCase, REDUC_ELEC);
                            listPrestation.add(createPrestation(aCase, cont, aContrat, energyContractResponse.prestationDistributorId, REDUCTION));
                        }else{
                            setCaseToDo(aCase,REDUC_ELEC,energyContractResponse.messageError);
                        } 
                    }
                }else{
                    if(aCase.HP_Energy__c == GAS){
                        setCaseToDo(aCase,COUPURE_GAZ,null);
                    }else{
                        energyRequest = new HP_EnergyRequest(COUPURE, aCase.HP_PDL_PCE__c,
                                                (Integer)(aContrat.HP_Type_de_Compteur__c == 'GAS' ? aContrat.HP_Index_de_Compteur__c :
                                                aContrat.HP_Compteur_Base_Plan_Index__c != null ?  aContrat.HP_Compteur_Base_Plan_Index__c :
                                                aContrat.HP_Compteur_Variable_Plan_prix_Index__c ));
                        energyResponse = HP_SM024_Case.precontratOCTOPUS(null, aContrat, energyRequest);	
                        aCase.HP_Type_compteur_electricite__c = energyResponse.nombreFils == 2 ? COMPTEUR_MONOPHASE : COMPTEUR_TRIPHASE;
                        energyContractRequest =  energyContractRequestBuilder(cont, energyResponse, aContrat);
                        energyResponse.montantCreance = getSolde(aCase);
                        energyContractResponse = HP_SM027_DistCreatePrestationElec.sendRequest(energyContractRequest, COUPURE, energyResponse, energyRequest.energyMeterIndex != null);
                        if(energyContractResponse.isSuccess == false){
                            setCaseToDo(aCase,COUPURE_ELEC,energyContractResponse.messageError);
                        }else{
                            closeCase(aCase,null, COUPURE_ELEC);
                            listPrestation.add(createPrestation(aCase, cont, aContrat, energyContractResponse.prestationDistributorId, COUPURE));
                        }
                    }
                }
            }catch (Exception ex) {
                System.debug('HP_BAT033_CoupureAttente.execute | Exception : ' + ex.getMessage());   
            }
        }
        update caseList;
        if(!listPrestation.isEmpty()){
            insert listPrestation;
        }
        System.debug('HP_BAT033_CoupureAttente.execute | Method Exit');
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('HP_BAT033_CoupureAttente.finish');
	}

    /* Récupérer la date de fin de la trève hivernalle depuis le custom metadata HP_Parameter */
    public static Date getPeriodeHivernaleEndDate(){
        System.debug('HP_BAT033_CoupureAttente.getPeriodeHivernaleEndDate | Method Start');
        List<String> treveHivernaleDates = treveHivernale.split('-');
        Integer month = Integer.valueOf(treveHivernaleDates[1].split('/')[1]);
        Date resultDate;
        if(Date.today().month()> Integer.valueOf(treveHivernaleDates[1].split('/')[1])){
            resultDate = Date.newInstance(Date.today().year()+1, Integer.valueOf(treveHivernaleDates[1].split('/')[1]), Integer.valueOf(treveHivernaleDates[1].split('/')[0]));
        }else{
            resultDate = Date.newInstance(Date.today().year(), Integer.valueOf(treveHivernaleDates[1].split('/')[1]), Integer.valueOf(treveHivernaleDates[1].split('/')[0]));
        }
        System.debug('HP_BAT033_CoupureAttente.getPeriodeHivernaleEndDate | Method Exit');
        return resultDate;
    }

    /* Déterminer si on est en période de trève hivernale ou pas selon les dates récupérées */
    public static Boolean withinTreveHivernale(){
        List<String> treveHivernaleDates = treveHivernale.split('-');
        Integer endMonth = Integer.valueOf(treveHivernaleDates[1].split('/')[1]);
        Integer endDay = Integer.valueOf(treveHivernaleDates[1].split('/')[0]);
        Integer startMonth = Integer.valueOf(treveHivernaleDates[0].split('/')[1]);
        Integer startDay = Integer.valueOf(treveHivernaleDates[0].split('/')[0]);
        Integer currentMonth = Date.today().month();
        Integer currentDay = Date.today().day();

        if(currentMonth == endMonth){
            return currentDay <= endDay;
        }else if(currentMonth == startMonth){
            return currentDay >= startDay;
        } 

        if(startMonth > endMonth){
            return (currentMonth >= startMonth || currentMonth <= endMonth);
        }else{
            return (currentMonth >= startMonth && currentMonth <= endMonth );
        }
    }

    private static String getCurrentDateFormatted(){
        return String.valueOf(Date.today().day()) + '/' + String.valueOf(Date.today().month()) + '/' + String.valueOf(Date.today().year());
    }

    public static Prestation_distributeur__c createPrestation(Case aCase, Contact cont, HP_Contrat__c acontrat, String businessNumber, String context) {
		Prestation_distributeur__c p = new Prestation_distributeur__c(
			RecordTypeId =  Schema.SObjectType.Prestation_distributeur__c.getRecordTypeInfosByDeveloperName().get('HP_PrestationDistributeur').getRecordTypeId(),
			Date_de_prestation__c = Date.Today().addDays(1),
			Statut__c = 'En cours',
			Type_OPS__c= 'Online',
			Secteur_activite__c = acontrat.HP_Type_de_Compteur__c == 'ELEC' ? 'Elec' : 'Gaz',
            HP_Type_de_prestation__c = context == REDUCTION ? 'ReductionDePuissance' : 'Coupure',
			Numero_PDL_PCE__c = aCase.HP_PDL_PCE__c,
			Contact__c = cont.Id,
			HP_Contrat__c = acontrat.Id,
			Numero_affaire_distributeur__c = businessNumber,
			Name = businessNumber,
			Case__c = aCase.Id
			);
		return p;
	}

    public static Double getSolde(Case aCase){
        System.debug('HP_BAT033_CoupureAttente.getSolde | Method Start');
        Contact con = aCase.Contact;
        HP_Contrat__c cont = aCase.HP_Contrat__r;
        Map<Integer,String> responseMap = new Map<Integer,String>();
        HP_WRP027_AgilabSolde outputData = new HP_WRP027_AgilabSolde();
        String idTiers = String.valueOf(Integer.valueOf(con.ID_Tiers__c));
        Double resultSolde = 0;
        try {
            responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_SOLDE_EFFECTIF,AIDE_PARAM+idTiers);
            outputData = (HP_WRP027_AgilabSolde)HP_ParseUtils.parse(responseMap.get(200),HP_WRP027_AgilabSolde.class);
            for(Map<String, Double> soldeMap :  outputData.output.soldes){
                if(soldeMap.containsKey(cont.HP_Porte_Feuille_Contrat__r.Xdata_Id__c)){
                    resultSolde = (-1 * soldeMap.get(cont.HP_Porte_Feuille_Contrat__r.Xdata_Id__c));
                }
            }
        } catch (Exception ex) {
            System.debug('HP_BAT033_CoupureAttente.getSolde | Exception : '+ex.getMessage() + 'Stack : '+ex.getStackTraceString()+' Line Number : '+ex.getLineNumber());   
        }
        System.debug('HP_BAT033_CoupureAttente.getSolde | Method Exit');
        return resultSolde;
    }

    public static void setPuissanceReduite(HP_EnergyResponse energyResponse){
        System.debug('HP_BAT033_CoupureAttente.setPuissanceReduite | Method Start');
        Double puissanceReduite;
        if(Integer.valueOf(energyResponse.serviceOpeningLevelCode) == 0){
            if(Integer.valueOf(energyResponse.electricityPowerRatingKiloVoltAmpere) == 3){
                puissanceReduite = 2;
            }else{
                puissanceReduite = 3;
            }
        }else{
            puissanceReduite = energyResponse.nombreFils == 2 ? 1 : 3;
        }
        energyResponse.puissanceReduite = puissanceReduite;
        System.debug('HP_BAT033_CoupureAttente.setPuissanceReduite | Method Exit');
    }

    public static Case createPrestationCase(Case aCase){
        System.debug('HP_BAT033_CoupureAttente.createPrestationCase | Method Start');
        Case newCase = aCase.clone(false, false, false, false);
        newCase.HP_TreatmentDate__c = getPeriodeHivernaleEndDate().addDays(1);
        newCase.Status = STATUT_DIFFERE;
        newCase.Origin = 'HP_CRM';
        newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HP_Facturation').getRecordTypeId();
        insert newCase;
        System.debug('HP_BAT033_CoupureAttente.createPrestationCase | Method Exit');
        return newCase;
    }

    public static void setCaseToDo(Case aCase, String context, String errorMessage){
        System.debug('HP_BAT033_CoupureAttente.setCaseToDo | Method Start');
        aCase.Status = A_TRAITER_STATUT;
        aCase.OwnerId = HP_UTIL_QueueManager.getQueueIdByName(QUEUE_N1);
        aCase.HP_TreatmentDate__c = Date.today();
        switch on context {
            when 'ReducElec' {
                aCase.HP_Sous_type__c = REDUCTION_SOUS_TYPE;
                aCase.Description = getCurrentDateFormatted() + ' – Prestation GRD automatique non réalisée, veuillez faire la prestation de réduction de puissance manuellement sur le portail GRD Enedis – ' + errorMessage;
            }
            when 'CoupureElec' {
                aCase.HP_Sous_type__c = COUPURE_SOUS_TYPE;
                aCase.Description = getCurrentDateFormatted() + ' – Prestation GRD automatique non réalisée, veuillez faire la prestation de coupure manuellement sur le portail GRD Enedis – ' + errorMessage;
            }
            when else {
                aCase.HP_Sous_type__c = COUPURE_SOUS_TYPE;
                aCase.Description = getCurrentDateFormatted() + ' – veuillez faire la prestation de coupure manuellement sur le portail GRD';
            }
        }
        System.debug('HP_BAT033_CoupureAttente.setCaseToDo | Method Exit');
    }

    public static void closeCase(Case aCase, Case newCase, String context){
        System.debug('HP_BAT033_CoupureAttente.closeCase | Method Start');
        aCase.Status = STATUT_FERME;
        Case newCasePrestation;
        if(newCase != null){
            newCasePrestation = [SELECT Id, CaseNumber FROM Case WHERE Id = :newCase.Id LIMIT 1];
        }
        if(context == REDUC_ELEC){
            aCase.Description = getCurrentDateFormatted() + ' – Réduction de puissance initiée, requête de coupure - ' + newCasePrestation.CaseNumber + ' créé';
            aCase.HP_Sous_type__c = REDUCTION_SOUS_TYPE;
        }else{
            aCase.Description = getCurrentDateFormatted() + ' – Requête fermée suite à la création de la prestation distributeur de coupure';
            aCase.HP_Sous_type__c = COUPURE_SOUS_TYPE;
        }
        System.debug('HP_BAT033_CoupureAttente.closeCase | Method Exit');
    }

    public static HP_EnergyContractRequest energyContractRequestBuilder(Contact cont, HP_EnergyResponse energyResponse, HP_Contrat__c acontrat) {
		HP_EnergyContractRequest c = new HP_EnergyContractRequest();
		c.personId =   String.valueOf(Integer.valueOf(cont.Id_Tiers__c));
		c.salutation = cont.salutation;
		c.customerLastName = cont.lastName;
		c.customerFirstName = cont.firstName;
		c.contractStartDate = Date.today().addDays(1);
		c.customerMainPhone =  cont.mobilePhone != null ? cont.mobilePhone : cont.Phone;
		c.electricityPowerRatingKiloVoltAmpere = energyResponse.electricityPowerRatingKiloVoltAmpere;
		c.electricityPricingPlan = null;
		c.energyMeterId = acontrat.HP_Id_Compteur__c;
		c.deliveryPointStreetName = energyResponse.deliveryPointStreetName;
		c.deliveryPointStreetNumber= energyResponse.deliveryPointStreetNumber;
		c.deliveryPointCity = energyResponse.deliveryPointCity;
		c.deliveryPointPostalCode = energyResponse.deliveryPointPostalCode;
		c.deliveryPointCountryISO2Code = 'FR';
		c.electricityMeterBasePlanIndex = acontrat.HP_Compteur_Base_Plan_Index__c != null ?  Integer.valueOf(acontrat.HP_Compteur_Base_Plan_Index__c) : null;
		c.electricityMeterVariablePlanPeakPriceIndex =acontrat.HP_Compteur_Variable_Plan_prix_Index__c != null ?
							       Integer.valueOf(acontrat.HP_Compteur_Variable_Plan_prix_Index__c) : null;
		c.electricityMeterVariablePlanBottomPriceIndex = acontrat.HP_Compteur_Plan_Bottom_Price_Index__c != null ?
								 Integer.valueOf(acontrat.HP_Compteur_Plan_Bottom_Price_Index__c) : null;
		c.estimatedConsumption = null;
		c.gasMeterIndex = null;

		return c;
	}
}