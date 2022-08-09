/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-16-2022
 * @last modified by  : Hemdene Ben Hammouda
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   09-28-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

public with sharing class HP_HDL001_Case extends TriggerHandler {
    private List<Case> newList = null;
    private String rtReclamationId;
    private String rtResiliationId;
    private String rtPrestationId;
    private String rtChatId;
    private String rtEmailId;
    private String rtFactureId;
    private Map<Id,Case> newMap = null;
    private Map<Id,Case> oldMap = null;
    private Integer HP_LIMITE_DUREE_ATTRIBUTION;

    public HP_HDL001_Case() {

        if(!HP_UTIL_ProfileManager.isHappeProfile() && !Test.isRunningTest()) {
            return;
        }

        this.newList = HP_SM040_CaseHandler.filterByHappeListCase(Trigger.New);
        this.newMap = HP_SM040_CaseHandler.filterByHappeMapCase((Map<Id,Case>)Trigger.newMap);
        this.oldMap = HP_SM040_CaseHandler.filterByHappeMapCase((Map<Id,Case>)Trigger.oldMap);
        
        rtReclamationId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_Mediation_Reclamation');
        rtResiliationId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_ContractCancelationCase');
        rtPrestationId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_PrestationDistributeur');
        rtChatId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_Chat');
        rtEmailId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Mail');
        rtFactureId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_Facturation');

        HP_LIMITE_DUREE_ATTRIBUTION = Integer.valueOf(HP_UTIL_MetadataManager.getConfigByKey('HP_LIMITE_DUREE_ATTRIBUTION'));
    }

    public override void beforeUpdate() {
        HP_SM040_CaseHandler.checkEscalade(newList, oldMap);
        HP_SM040_CaseHandler.populateDateAttributionPersonne(newList, oldMap);
        HP_SM040_CaseHandler.flagCaseN1Queue(newList);
        HP_SM040_CaseHandler.updateStatusCaseQueue(newList, oldMap);
        HP_SM040_CaseHandler.modifyOwnerIfRecordChange(newList, oldMap);
    }
  
    public override void afterUpdate() {
        HP_SM040_CaseHandler.removeReclamationAPIAgilab(newList, rtReclamationId, oldMap);
        HP_SM040_CaseHandler.populateCreateHistoryCase(newList,newMap, oldMap,HP_LIMITE_DUREE_ATTRIBUTION);
        HP_SM040_CaseHandler.notifyNewOwner(newList, oldMap);
    }

    public override void afterInsert() {
        HP_SM040_CaseHandler.setReclamationAPIAgilab(newList, rtReclamationId);
        HP_SM040_CaseHandler.processCoupureReduction(newList, rtFactureId);
        HP_SM040_CaseHandler.createHistoryCase(newList);
    }

    public override void beforeInsert() {
        HP_SM040_CaseHandler.createHPChatCase(newList, rtChatId);
        HP_SM040_CaseHandler.updateCaseContrat(newList, rtResiliationId, rtPrestationId);
        HP_SM040_CaseHandler.flagCaseN1Queue(newList);
        HP_SM040_CaseHandler.changeBusinessHour(newList);

        HP_SM040_CaseHandler.checkDuplication(newList, rtEmailId);

        HP_SM040_CaseHandler.autoAssign(newList);
    }
}