/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-06-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   08-06-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public with sharing class HP_UTIL_Vue360LoadGlobalParam_Test {
    @isTest 
    static void execute(){
        HP_UTIL_Vue360LoadGlobalParam testClass = new HP_UTIL_Vue360LoadGlobalParam();
        Test.startTest();
        Object result = testClass.processing(null, null);
        Test.stopTest();
        System.assert(result != null, 'Erreur');
    }
}