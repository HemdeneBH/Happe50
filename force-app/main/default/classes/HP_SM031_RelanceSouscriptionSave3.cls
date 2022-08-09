/**
 * @File Name          : HP_SM031_RelanceSouscriptionSave3.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 04-25-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    22/05/2020   Sara El-Hannaoui     Initial Version
**/
public with sharing class HP_SM031_RelanceSouscriptionSave3 {
    
    
	/**
	* @description Permet de relancer le processus de contractualisation depuis une requête dont le record type est “HP_ContractErrorSave3” afin de créer le contrat dans Agilab et la prestation GRD.
	* @author Sara El-Hannaoui | 25/05/2020 
	* @param finalList<Id> myCaseIds 
	* @return List<String> 
	**/
        @InvocableMethod(label='Rerun contractualisation Agilab save 3')
	public static List<String> rerunContractualisationAgilab(final List<Id> myCaseIds){  
                List<String> listResult = new  List<String> ();         
                System.debug('MyCase' +myCaseIds);
                List<Case>  myCaseList = HP_EM010_Case.loadCase(myCaseIds[0]);
                listResult.add(execute(myCaseList[0]));
                return listResult;	
	}

	public static String execute(Case myCase){
                String selfcareId = myCase.HP_Souscription__r.HP_Souscription_Digital_Id__c;
                String energy = myCase.HP_Energy__c == 'Gas' ? 'GAS' : 'ELEC';
                HP_WRP022_SFResponse response = new HP_WRP022_SFResponse(HP_HttpStatus.OK);
                Map<String,List<SObject> > resultApi = null;
        
                String relanceContractResult;

                HP_Porte_Feuille_Contrat__c ptf = HP_EM024_PorteFeuilleContrat.loadPorteFeuilleContrat(selfcareId);
                Contact cont = HP_EM020_Contact.loadContact(ptf.HP_Contact__c);
                List<HP_Contrat__c> contractList = HP_EM023_Contrat.loadContratByEnergy(selfcareId, energy);
                HP_Souscription__c souscription = HP_EM005_Souscription.loadSouscription(selfcareId);
                
                resultApi = HP_SM024_Case.callAPIProcessing(souscription, cont, contractList, ptf, true, response);
                List<Case> caseList = (List<Case>)resultApi.get('case');
                boolean isContractualisationEnErreurAgilab = false;
                for (Integer i = (caseList.size()-1) ; i>= 0 ; i--){
                        if(caseList[i].RecordTypeId != Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HP_ContractErrorSave3').getRecordTypeId()){
                                continue;
                        }
                        if (caseList[i].HP_Type__c == 'HP_Contractualization') {
                                isContractualisationEnErreurAgilab = true;
                        }
                        myCase.Description = caseList[i].Description;
                        relanceContractResult = 'Le contrat Agilab n’a pas pu être créé. Visualisez la description de la requête pour plus de détail.';
                        resultApi.get('case').remove(i);
                }
                if (relanceContractResult == null){
                        myCase.Status = 'CLOSED';
                        relanceContractResult = 'Le contrat est créé dans Agilab';
                }

                String electricityContractXdataId = '';
                String gasContractXdataId = '';
                if (!isContractualisationEnErreurAgilab) {
                        for(HP_Contrat__c acontrat : contractList) {
                                String typeCompteur = acontrat.HP_Type_de_Compteur__c;
                                if (typeCompteur == 'ELEC') {
                                        souscription.OK_Electricite__c = true;
                                        electricityContractXdataId = String.valueOf(acontrat.HP_Contrat_XdataId__c);
                                        System.debug('souscription.OK_Electricite__c = true;');
                                }
                                if (typeCompteur == 'GAS') {
                                        souscription.OK_Gaz__c = true;
                                        gasContractXdataId = String.valueOf(acontrat.HP_Contrat_XdataId__c);
                                        System.debug('souscription.OK_Gaz__c = true;');
                                } 
                        }
                        myCase.Etat_du_Case__c = 'Contrat validé';

                        if(myCase.Etat_du_Case__c == 'Contrat validé' && souscription.HP_Type_Energie__c != 'COMBINED_GAS_AND_ELECTRICITY'){
                                HP_SM063_WelcomeEmailSender.sendWelcomeEmail(souscription.Id,electricityContractXdataId, gasContractXdataId, souscription.OK_Electricite__c, souscription.OK_Gaz__c);
                        }
                        if(myCase.Etat_du_Case__c == 'KO définitif' && souscription.HP_Type_Energie__c == 'COMBINED_GAS_AND_ELECTRICITY'){
                                HP_SM063_WelcomeEmailSender.sendWelcomeEmail(souscription.Id,electricityContractXdataId, gasContractXdataId, souscription.OK_Electricite__c, souscription.OK_Gaz__c);
                        }
                }
                if(!isContractualisationEnErreurAgilab){
                        ID jobID = System.enqueueJob(new HP_EC_CommunityUserManagerAsync(cont.Id_Tiers__c));
		}
                resultApi.get('case').add(myCase);
                HP_SM022_SouscriptionSave3.updateDataProcessing(null, resultApi, souscription, cont, contractList, false, true, response);
                return relanceContractResult; 
	}

}