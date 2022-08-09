/**
 * @File Name          : HP_AgilabCommercialPropositionService.cls
 * @Description        :
 * @Author             : mouhamadoune.coulybaly@external.engie.com
 * @Group              :
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 25/02/2020 à 14:19:24
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    16/12/2019   mouhamadoune.coulybaly@external.engie.com     Initial Version
 **/
public with sharing class HP_AgilabCommercialPropositionService {

	private enum Fields {
		id_contrat_xdata,
		statut_contrat,
		date_resiliation
	}
	public class PrestationParameter {
		@InvocableVariable(required=false)
		public Integer xDataId;
		@InvocableVariable(required=false)
		public String status;
	}


	@InvocableMethod(label='Update contract Status in Agilab' description='Trigger update contract in Agilab Status: AwaitingEnergyDistributor.' )
	public static void updateContractStatusAwaitingDistributor(final List<Integer> xDataId){
		if (System.IsBatch() == false  && System.isFuture() == false) {
			updateContractAsync(xDataId[0], HP_constantes.AGILAB_STATUS_BY_STATUS.get('AwaitingEnergyDistributor'), null);
		}
	}

	@future(callout=true)
	public static void updateContractAsync(Integer xDataId, String agilabStatus, String datePrestation){
		updateContractSync(xDataId, agilabStatus, datePrestation,new HP_WRP022_SFResponse(200));
	}

	public static void updateContractSync(Integer xDataId, String agilabStatus, String datePrestation, HP_WRP022_SFResponse response){
		try {
			Map<String, String> paramMap = new Map<String, String> {
				Fields.id_contrat_xdata.name() => String.valueOf(xDataId),
					    Fields.statut_contrat.name() => agilabStatus
			};
			if(datePrestation != null) {
				paramMap.put(Fields.date_resiliation.name(), datePrestation);
			}

			Map<Integer, String> responseNoteMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_PROPOSITION_MODIFIER, paramMap);
			System.debug('Response =============================' + responseNoteMap);
			response.addInfo('AgilabCommercialPropositionService', 'success');
		}catch(Exception e ) {
			response.code = HP_HttpStatus.BAD_REQUEST;
			response.addError('AgilabCommercialPropositionService Error: ', e.getMessage());
		}

	}

	public static void resiliationAgilab(Case acase, Integer xDataId, Integer indexHp, HP_WRP022_SFResponse response){
		try {
			Map<String, String> paramMap = new Map<String, String> {
				'contrat_number' => String.ValueOf(xDataId),
				'email' => acase.ContactEmail
			};
			if( acase.HP_index_gaz__c != null) {
				paramMap.put('gaz_index', String.ValueOf(acase.HP_index_gaz__c));
			}
			if( indexHp != null) {
				paramMap.put('hp', String.ValueOf(indexHp));
			}
			if(acase.HP_index_elec_hc__c != null) {
				paramMap.put('hc', String.ValueOf(acase.HP_index_elec_hc__c));
			}
		    if(acase.HP_EffectiveDate__c  != null) {
				paramMap.put('date_resil', String.ValueOf(acase.HP_EffectiveDate__c));
			}
			
			HTTPResponse responseAgilab = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_HAPPE_RESILIATION_CREATE, paramMap);
			Map<String,Object> responseAsMap =  (Map<String,Object>) JSON.deserializeUntyped(responseAgilab.getBody());
			Map<String,Object> outputAsMap =  (Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(responseAsMap.get('output')));
			acase.Motif__c = (String) responseAsMap.get('message');  
			acase.Description = (String) outputAsMap.get('description');
			switch on (String)outputAsMap.get('code_retour') {
				when '41', '42' , '43', '44'{
					acase.Status = 'CANCELED';
				}
				when '45', '46'{
					acase.Status = 'TO_DO';
				}
				when '47' {
					acase.Status = 'HP_PENDING';
					acase.HP_TreatmentDate__c = acase.HP_EffectiveDate__c.addDays(-6); 
				}
				when '48' {
					acase.Status = 'HP_PENDING';
				}
				when '49'{
					acase.Status = 'TO_DO';
					QueueSObject queueID = [Select Queue.Id, Queue.Name, Queue.Type from QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name =: 'HP_Niveau_3_Email'  Limit 1];
					if (queueID.id   != null){
                    	acase.OwnerId = queueID.Queue.Id;
	               	}
				}
				when 'OK'{
					acase.Status = 'NEW_CASE';
					acase.Motif__c = null;
				}
			}
			response.addInfo('AgilabCommercialPropositionService', 'success');
		}catch(Exception e ) {
			response.code = HP_HttpStatus.BAD_REQUEST;
			response.addError('AgilabCommercialPropositionService Error: ', e.getMessage());
		}
	}



}