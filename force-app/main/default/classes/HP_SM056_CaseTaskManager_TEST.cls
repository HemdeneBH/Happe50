/**
 * @description       : 
 * @author            : Slimene Belhaj Ali
 * @group             : 
 * @last modified on  : 03-09-2021
 * @last modified by  : Slimene Belhaj Ali
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-09-2021   Slimene Belhaj Ali   Initial Version
**/
@isTest
public with sharing class HP_SM056_CaseTaskManager_TEST {
    @isTest
    public static void getLastTaskFromCaseIdTEST() {
        HP_SM056_CaseTaskManager.getLastTaskFromCaseId('5000E00000FFRIjQAP');
    }

    @isTest
    public static void diabolocomViewAdminFieldPermissionTEST() {
        HP_SM056_CaseTaskManager.diabolocomViewAdminFieldPermission();
    }
}