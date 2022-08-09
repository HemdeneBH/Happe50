/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 02-22-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_SM075_CoupureReduction {

    public static void processCoupureReduction(List<Id> caseIds){
        HP_EM054_CoupureReduction.processCoupureReduction(caseIds);
    }

}