/**
 * @description       : 
 * @author            : Slimene Belhaj Ali
 * @group             : 
 * @last modified on  : 03-09-2021
 * @last modified by  : Slimene Belhaj Ali
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-03-2021   Slimene Belhaj Ali   Initial Version
**/
public inherited sharing class HP_SM056_CaseTaskManager {
    @AuraEnabled
    public static Task getLastTaskFromCaseId(String caseId){
        return HP_EM048_Task.getLastTaskFromCaseId(caseId);
    }

    @AuraEnabled
    public static Boolean diabolocomViewAdminFieldPermission(){
        return FeatureManagement.checkPermission('HP_DiabolocomViewAdminField');
    }
}