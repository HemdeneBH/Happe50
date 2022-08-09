/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-25-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
global class HP_BAT024_CaseCheckAgilab implements Database.Batchable<sObject>, Database.AllowsCallouts, System.Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface{
	private static final Integer BATCH_CHUNK_SIZE = 1;
    private static final String HP_ERROR_TIMEOUT = 'HP_ERROR_TIMEOUT';
    private static final String HP_ERROR_EXISTING_ID = 'HP_ERROR_EXISTING_ID';

    global static void launchNewScheduler(String schedule,String jobName){
		  System.schedule(jobName, schedule, new HP_BAT024_CaseCheckAgilab());
    }

    global static void execute(SchedulableContext sc){
		  execute();
    }
    
    public static void execute(){
		HP_BAT024_CaseCheckAgilab batch = new HP_BAT024_CaseCheckAgilab();
		Database.executeBatch(batch, BATCH_CHUNK_SIZE); 
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        ID recordType = HP_UTIL_RecordType.getRecordTypeId('Case','HP_ContractErrorSave3');
        return Database.getQueryLocator(
            [SELECT Id, ContactEmail, Description, ContactId, OwnerId, HP_Contrat__c, HP_TECH_ExternalId__c, HP_Energy__c, Status, Contact__c,
        
             Contact.Id, Contact.salutation, Contact.lastName, Contact.firstName, Contact.Id_Tiers__c, Contact.No_Voie__c, Contact.phone,
             Contact.HP_Indicatif__c, Contact.MailingStreet, Contact.MailingCity, Contact.MailingPostalCode, Contact.Complement_adresse__c,
             Contact.HP_Numero_etranger__c, Contact.email, Contact.mobilephone, Contact.HP_OptinMarketing__c, Contact.HP_StopEmail__c,
             Contact.HP_StopSMS__c, Contact.HP_Shared_URL__c,
             
             HP_Souscription__r.HP_Souscription_Digital_Id__c,
             HP_Souscription__r.HP_type_Souscription__c, 
             
             HP_Contrat__r.HP_Contrat_XdataId__c,
             HP_Contrat__r.HP_Proposition_Commerciale_XdataId__c,
             HP_Contrat__r.HP_Type_de_Compteur__c,
             HP_Contrat__r.HP_Id_Compteur__c, 
             HP_Contrat__r.HP_Numero_reference_du_Compteur__c,
             HP_Contrat__r.HP_Compteur_Base_Plan_Index__c, 
			 HP_Contrat__r.HP_Compteur_Variable_Plan_prix_Index__c, 
			 HP_Contrat__r.HP_Compteur_Plan_Bottom_Price_Index__c, 
			 HP_Contrat__r.HP_Index_de_Compteur__c,
             
             HP_Contrat__r.HP_Porte_Feuille_Contrat__r.Id, 
             HP_Contrat__r.HP_Porte_Feuille_Contrat__c,
             HP_Contrat__r.HP_Porte_Feuille_Contrat__r.HP_Contact__c, 
             HP_Contrat__r.HP_Porte_Feuille_Contrat__r.HP_Souscription_Digital_Id__c, 
             HP_Contrat__r.HP_Porte_Feuille_Contrat__r.Xdata_Id__c,
             
             HP_Contrat__r.HP_Souscription__r.HP_ActivationPrioritaire__c,
            HP_Contrat__r.HP_Souscription__r.HP_CoContractant__r.Id,
            HP_Contrat__r.HP_Souscription__r.HP_CoContractant__r.Salutation,
            HP_Contrat__r.HP_Souscription__r.HP_CoContractant__r.firstName,
            HP_Contrat__r.HP_Souscription__r.HP_CoContractant__r.lastName,
            HP_Contrat__r.HP_Souscription__r.HP_Code_Electrique_Produit__c,
            HP_Contrat__r.HP_Souscription__r.HP_Code_Gaz_Produit__c,
            HP_Contrat__r.HP_Souscription__r.HP_Code_postal__c,
            HP_Contrat__r.HP_Souscription__r.HP_Code_postal_facturation__c,
            HP_Contrat__r.HP_Souscription__r.HP_Complement_d_adresse__c,
            HP_Contrat__r.HP_Souscription__r.HP_Complement_d_adresse_facturation__c,
            HP_Contrat__r.HP_Souscription__r.HP_Contact__r.Complement_adresse__c,
            HP_Contrat__r.HP_Souscription__r.HP_Contact__r.Email,
            HP_Contrat__r.HP_Souscription__r.HP_Contact__r.Firstname,
            HP_Contrat__r.HP_Souscription__r.HP_Contact__r.Id_Tiers__c,
            HP_Contrat__r.HP_Souscription__r.HP_Contact__r.Lastname, 
            HP_Contrat__r.HP_Souscription__r.HP_Contact__r.MailingCity,
            HP_Contrat__r.HP_Souscription__r.HP_Contact__r.MailingPostalCode,
            HP_Contrat__r.HP_Souscription__r.HP_Contact__r.MailingStreet,
            HP_Contrat__r.HP_Souscription__r.HP_Contact__r.No_Voie__c,
            HP_Contrat__r.HP_Souscription__r.HP_Contact__r.Salutation,
            HP_Contrat__r.HP_Souscription__r.HP_Date_Origine__c,
            HP_Contrat__r.HP_Souscription__r.HP_Date_de_Contractualisation__c,
            HP_Contrat__r.HP_Souscription__r.HP_Estimation_Consommation_electrique__c,
            HP_Contrat__r.HP_Souscription__r.HP_Estimation_Consommation_gaz__c,
            HP_Contrat__r.HP_Souscription__r.HP_IBAN__c, 
            HP_Contrat__r.HP_Souscription__r.HP_Jour_de_facturation__c, 
            HP_Contrat__r.HP_Souscription__r.HP_Methode_de_paiement__c,
            HP_Contrat__r.HP_Souscription__r.HP_Montant_de_la_facturation_electrique__c,
            HP_Contrat__r.HP_Souscription__r.HP_Montant_de_la_facturation_gaz__c,
            HP_Contrat__r.HP_Souscription__r.HP_Nom_de_rue__c,
            HP_Contrat__r.HP_Souscription__r.HP_Nom_de_rue_facturation__c,
            HP_Contrat__r.HP_Souscription__r.HP_Nom_de_ville__c,
            HP_Contrat__r.HP_Souscription__r.HP_Nom_de_ville_facturation__c,
            HP_Contrat__r.HP_Souscription__r.HP_Numero_de_voie__c,
            HP_Contrat__r.HP_Souscription__r.HP_Numero_de_voie_facturation__c,
            HP_Contrat__r.HP_Souscription__r.HP_OptionVert__c, 
            HP_Contrat__r.HP_Souscription__r.HP_Parrainage__c,
            HP_Contrat__r.HP_Souscription__r.HP_Periode_de_facturation__c,
            HP_Contrat__r.HP_Souscription__r.HP_Plan_de_Prix_electrique__c,
            HP_Contrat__r.HP_Souscription__r.HP_Puissance_Compteur_electrique__c,
            HP_Contrat__r.HP_Souscription__r.HP_RUM__c,
            HP_Contrat__r.HP_Souscription__r.HP_Souscription_Digital_Id__c,
            HP_Contrat__r.HP_Souscription__r.HP_Statut__c, 
            HP_Contrat__r.HP_Souscription__r.HP_Type_Energie__c,
            HP_Contrat__r.HP_Souscription__r.HP_code_Postal_Insee__c,
            HP_Contrat__r.HP_Souscription__r.HP_code_Postal_Insee_facturation__c,
            HP_Contrat__r.HP_Souscription__r.HP_code_promotion__c,
            HP_Contrat__r.HP_Souscription__r.HP_isCommunicantElec__c,
            HP_Contrat__r.HP_Souscription__r.HP_isCommunicantGaz__c,		
            HP_Contrat__r.HP_Souscription__r.HP_isGaspar__c,
            HP_Contrat__r.HP_Souscription__r.HP_isLinky__c,
            HP_Contrat__r.HP_Souscription__r.HP_type_Souscription__c,
            HP_Contrat__r.HP_Souscription__r.HP_VoucherCode__c,
            HP_Contrat__r.HP_Souscription__r.Id,
            HP_Contrat__r.HP_Souscription__r.OK_Electricite__c,
            HP_Contrat__r.HP_Souscription__r.OK_Gaz__c
             FROM Case 
             WHERE HP_isHappe__c = true 
             AND HP_Contrat__r.HP_Contrat_XdataId__c != null
             AND HP_Contrat__r.HP_Contrat_XdataId__c != 0  
             AND RecordTypeId = :recordType
             AND HP_type__c = 'HP_Contractualization'
             AND IsClosed = false]
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Case> scope) {
        scope = filterCases(scope);
        System.debug('***scope***:'+scope);
        if(scope.isEmpty()){
            return;
        }
        List<Case> listGRD = new List<Case>();
        ID contractErrorRt = HP_UTIL_RecordType.getRecordTypeId('Case','HP_ContractErrorSave3');
        ID prestaAutoRt = HP_UTIL_RecordType.getRecordTypeId('Case','HP_PrestationDistributeur');
        ID queueConseillerPremierNiveau = HP_UTIL_QueueManager.getQueueIdByName('HP_Niveau_1');
        List<CaseApiResult> caseApiResultList = new List<CaseApiResult>();
        for(Case c : scope){           
            Map<String,List<SObject> > resultApi = null;
            
            HP_WRP022_SFResponse response = new HP_WRP022_SFResponse(HP_HttpStatus.OK);            
            HP_Porte_Feuille_Contrat__c ptf = c.HP_Contrat__r.HP_Porte_Feuille_Contrat__r;
            Contact cont = c.Contact;
            //cont.Id_Tiers__c = integer.valueof(cont.Id_Tiers__c);
            HP_Contrat__c contrat = c.HP_Contrat__r;
            //contrat.HP_Contrat_XdataId__c = integer.valueof(contrat.HP_Contrat_XdataId__c);
            List<HP_Contrat__c> contractList = new List<HP_Contrat__c> {c.HP_Contrat__r};
            HP_Souscription__c souscription = c.HP_Contrat__r.HP_Souscription__r;
            resultApi = HP_SM024_Case.callAPIProcessing(souscription, cont, contractList, ptf, true, response);
            List<Case> caseList = (List<Case>)resultApi.get('case');

            System.debug('***caseList***:'+caseList);

            boolean contractualisationError = false;
            boolean createPrestation = false;
            String electricityContractXdataId = '';
            String gasContractXdataId = '';
            for (Integer i = (caseList.size()-1) ; i>= 0 ; i--){
                if(caseList[i].Description == HP_UTIL_MetadataManager.getConfigByKey(HP_ERROR_EXISTING_ID)) {
                    createPrestation = true;
                    resultApi.get('case').remove(i);
                    if (contractList[0].HP_Type_de_Compteur__c == 'ELEC') {
                        souscription.OK_Electricite__c = true;
                        electricityContractXdataId = String.valueOf(contrat.HP_Contrat_XdataId__c);
                    }
                    if (contractList[0].HP_Type_de_Compteur__c == 'GAS') {
                        souscription.OK_Gaz__c = true;
                        gasContractXdataId = String.valueOf(contrat.HP_Contrat_XdataId__c);
                    }
                    if (souscription.HP_Type_Energie__c != 'COMBINED_GAS_AND_ELECTRICITY' && (souscription.OK_Gaz__c==true || souscription.OK_Electricite__c==true)) {
                        //c.Etat_du_Case__c = 'Contrat validé';
                        HP_SM063_WelcomeEmailSender.sendWelcomeEmail(souscription.Id,electricityContractXdataId, gasContractXdataId, souscription.OK_Electricite__c, souscription.OK_Gaz__c);
                    } 
                    continue;
                }
                if(caseList[i].RecordTypeId != contractErrorRt){
                    continue;
                }
                contractualisationError = true;
                createPrestation = false;
                c.Description = caseList[i].Description;
                resultApi.get('case').remove(i);
            }
				               
            if (!contractualisationError){
                if(createPrestation) {
                	Case prestaCase = new Case();
                    prestaCase.RecordTypeId = prestaAutoRt;
                    prestaCase.HP_Type__c = 'HP_AUTOMATED_PROCESS';
                    prestaCase.Status = 'HP_PENDING';
					prestaCase.OwnerId = queueConseillerPremierNiveau;
					prestaCase.HP_Souscription__c = c.HP_Souscription__c;
					prestaCase.ContactId = c.ContactId;
                    prestaCase.Reason = 'HP_PRESTATION_GRD';
					prestaCase.HP_Energy__c = c.HP_Energy__c;
					prestaCase.HP_TECH_ExternalId__c = c.HP_Contrat__r.HP_Proposition_Commerciale_XdataId__c + 'HP_PrestationDistributeur' + c.HP_Contrat__r.HP_Type_de_Compteur__c;
					prestaCase.HP_Contrat__c = c.HP_Contrat__c;
                    if(souscription.HP_type_Souscription__c == 'MOVING_IN'){
                        prestaCase.HP_TypePrestation__c = 'MES';
                    }
                    if(souscription.HP_type_Souscription__c == 'SWITCH_SUPLIER'){
                        prestaCase.HP_TypePrestation__c = 'CHF';
                    }
                    resultApi.get('case').add(prestaCase);
                }
                c.Status = 'CLOSED';
            }
            resultApi.get('case').add(c);
            CaseApiResult caseResults = new CaseApiResult();
            caseResults.resultApi = resultApi;
            caseResults.souscription = souscription;
            caseResults.cont = cont;
            caseResults.contractList = contractList;
            caseResults.response = response;
            
            caseApiResultList.add(caseResults);
            ID jobID = System.enqueueJob(new HP_EC_CommunityUserManagerAsync(cont.Id_Tiers__c));
      	}
        for(CaseApiResult item : caseApiResultList) {
            HP_SM022_SouscriptionSave3.updateDataProcessing(null, item.resultApi, item.souscription, item.cont, item.contractList, false, true, item.response);
        }
        
        Database.update(scope);
	}
    
    class CaseApiResult {
        public Map<String,List<SObject>> resultApi;
        public HP_Souscription__c souscription;
        public Contact cont;
        public List<HP_Contrat__c> contractList;
        public HP_WRP022_SFResponse response;
    }
    
    
    private List<Case> filterCases(List<Case> caseList) {
        List<Case> filteredCaseList = new List<Case>();
        for(Case aCase : caseList) {
            if(aCase.Description == HP_UTIL_MetadataManager.getConfigByKey(HP_ERROR_TIMEOUT)) {
                filteredCaseList.add(aCase);
            }
        }
        
        return filteredCaseList;
    }
   
    global void finish(Database.BatchableContext bc){
    }
}