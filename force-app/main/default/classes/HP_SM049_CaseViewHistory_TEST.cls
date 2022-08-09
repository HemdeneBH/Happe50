@IsTest
public with sharing class HP_SM049_CaseViewHistory_TEST {
    @testSetup static void dataSetup(){
        Case acase = (Case) HP_UTIL_SmartFactory.createSObject('Case',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),

        'Subject' => 'case ' ,
        'HP_Energy__c' => 'Electricity',
        'HP_CompteurCommunicant__c'=> true,
        'HP_EffectiveDate__c' => date.today().addDays(1)
        }, null
        );

    insert acase;
    }
    @isTest 
    public static void  insertCaseHistoryViewTEST() {
        HP_SM049_CaseViewHistory.insertCaseHistoryView([select Id from case limit 1].Id);
    }
}