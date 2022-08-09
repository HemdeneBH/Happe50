/**
 * @File Name          : HP_SM033_PrestationFluxUpdate.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc

 * @Last Modified On   : 11-13-2020

 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    30/03/2020   Mouhamadoune Coulibaly     Initial Version
**/
public with sharing class HP_SM033_PrestationFluxUpdate implements Queueable { 

    final  List <Prestation_distributeur__c> opsToUpdate;
    final List<CMN_OPSinfo> opsInfos;

    public HP_SM033_PrestationFluxUpdate(List <Prestation_distributeur__c> opsToUpdate, List<CMN_OPSinfo> opsInfos){
        this.OPSinfos = OPSinfos; 
        this.opsToUpdate = opsToUpdate;
    }

    public void execute(QueueableContext context) {
        updateOPSAndCase(this.opsToUpdate,this.opsInfos);
    }

    public static void updateOPSAndCase(List <Prestation_distributeur__c> opsToUpdate, List<CMN_OPSinfo> opsInfos){
        Datetime startCall = Datetime.now();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        List <Prestation_distributeur__c> opsHP_toUpdate = new List <Prestation_distributeur__c>();
        try{
            Id hpRecordTypeId = Schema.SObjectType.Prestation_distributeur__c.getRecordTypeInfosByDeveloperName().get('HP_PrestationDistributeur').getRecordTypeId();
            handleBody(req, OPSinfos, hpRecordTypeId);
            for (Prestation_distributeur__c ops : opsToUpdate) {
                if (ops.RecordTypeId == hpRecordTypeId) {
                    opsHP_toUpdate.add(ops);
                }
            }
            handleUpdatedOPS(opsHP_toUpdate,response);

        }
        catch(Exception e){
            response.addError('SM033-1', e.getMessage());
            response.code = HP_HttpStatus.BAD_REQUEST;
        }
        finally {
            req.requestURI = '/updateOPS';
            res.statusCode = response.code;
            res.responseBody = Blob.valueOf(JSON.serializePretty(response));
			HP_UTIL_HTTPUtils.saveLogResponse(req, res, (Datetime.now().getTime() - startCall.getTime()));
		}
    }

    public static void handleBody(RestRequest req , List<CMN_OPSinfo> OPSinfos, Id hpRecordTypeId){
        List<CMN_OPSinfo> opsInfosToLog = new List<CMN_OPSinfo>();
        Map <String, CMN_OPSinfo> ids_OPS = new Map <String, CMN_OPSinfo>();
        for (CMN_OPSinfo opstemp: OPSinfos) {
            ids_OPS.put(opstemp.idAffaire, opstemp);
        }
        List <Prestation_distributeur__c> hpAccs = [SELECT Id, Numero_affaire_distributeur__c  FROM Prestation_distributeur__c WHERE Numero_affaire_distributeur__c IN: ids_OPS.keySet() AND RecordTypeId = : hpRecordTypeId];
        for (Prestation_distributeur__c hpAcc : hpAccs){
            opsInfosToLog.add(ids_OPS.get(hpAcc.Numero_affaire_distributeur__c));
        }
        req.requestBody =   Blob.valueof(HP_ParseUtils.serialize((Object) opsInfosToLog));  
    }

    public static void handleUpdatedOPS (List <Prestation_distributeur__c> hpUpdatedOps, HP_WRP022_SFResponse response) {
        Map<Id, Case> caseByPrestaId = new Map<Id, Case>();
        Id queueNiv1Id = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HP_Niveau_1'].Id;
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HP_PrestationDistributeur').getRecordTypeId();
        Map<Id, Prestation_distributeur__c> newFieldPrestationList = new Map<Id,Prestation_distributeur__c> ([select Id,Case__c, Contact__c, HP_Contrat__c, HP_Contrat__r.HP_Souscription__c from Prestation_distributeur__c
        where id in :hpUpdatedOps]);
        for (Prestation_distributeur__c hpOps : hpUpdatedOps) {
                final String opsType = hpOps.Situation_de_vente__c;
                final String energyType = hpOps.Secteur_activite__c;
                final String lastMilestoneStatus;
                final String energy;
 
            if (opsType == 'Changement de fournisseur' || opsType == 'Emménagement') {
                if (energyType == 'Elec') {
                    //Elec
                    lastMilestoneStatus = hpOps.Statut_dernier_jalon__c;
                    energy = HP_SLCT_Case.Energy.Electricity.name();
                    if (hpOps.Statut__c == 'Terminé' && lastMilestoneStatus != 'CPRE') {
                        caseByPrestaId.put(hpOps.Id, handleCaseAndUpdateXDataAgilab(caseRecordTypeId, energy, hpOps, queueNiv1Id, newFieldPrestationList.get(hpOps.Id)));
                    }
                } else {
                    //Gaz
                    lastMilestoneStatus = hpOps.Statut_dernier_jalon__c;
                    energy = HP_SLCT_Case.Energy.Gas.name();
                    if (lastMilestoneStatus == '022' || lastMilestoneStatus == '023' || lastMilestoneStatus == '041') {
                        caseByPrestaId.put(hpOps.Id, handleCaseAndUpdateXDataAgilab(caseRecordTypeId, energy, hpOps, queueNiv1Id, newFieldPrestationList.get(hpOps.Id)));
                    }
                }
            }
        }
    
        try{
            if(!caseByPrestaId.isEmpty()){
                insert caseByPrestaId.values();
                response.addInfo('SM033-2', 'Insertion des cases : ' + caseByPrestaId.keySet());
            }
            for (Prestation_distributeur__c hpOps : hpUpdatedOps){
                if(caseByPrestaId.containsKey(hpOps.Id)){
                    hpOps.Case__c = caseByPrestaId.get(hpOps.Id).Id;
                }
            }
    
            List<Database.UpsertResult> updateOPSResultList = Database.upsert(hpUpdatedOps, true);
            if (updateOPSResultList.size()>0) {
                system.debug('OPS isSuccess');
                response.addInfo('SM033-3', 'Mise à jour des prestations.');
            }
        
        }catch(Exception e ){
            response.addError('SM033-4', e.getMessage());
        }   
    }
 
    public static Case handleCaseAndUpdateXDataAgilab (Id caseRecordTypeId, String energy, Prestation_distributeur__c hpOps, Id queueNiv1Id, Prestation_distributeur__c newFieldOPS) {
 
            System.debug('Create Case hpOps Id: '+hpOps);
            Case hpCase = new Case();
            hpCase.ParentId = newFieldOPS.Case__c;
            hpCase.ContactId = newFieldOPS.Contact__c;
            hpCase.HP_Contrat__c = newFieldOPS.HP_Contrat__c;
            hpCase.RecordTypeId = caseRecordTypeId;
            hpCase.Status = HP_SLCT_Case.Status.TO_DO.name();
            hpCase.Origin = HP_SLCT_Case.Origin.HP_CRM.name();
            hpCase.HP_Energy__c = energy;
            hpCase.HP_Souscription__c = (newFieldOPS.HP_Contrat__r != null ? newFieldOPS.HP_Contrat__r.HP_Souscription__c: null);
            hpCase.OwnerId = queueNiv1Id;
            hpCase.Reason = HP_SLCT_Case.Reason.HP_PRESTATION_GRD.name();
            hpCase.Description = 'Demande non réalisée';
            hpCase.HP_Type__c = 'HP_Flux_GRD';
            hpOps.HP_TECH_toNotify__c = true;     
            hpCase.HP_TECH_ExternalId__c = energy+'/FLUX_GRD/'+ hpOps.Numero_affaire_distributeur__c;

            return hpCase;
    }
}