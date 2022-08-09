/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   22-02-2021   Antoine Latour   Initial Version
**/
@isTest
public with sharing  class HP_BAT018_CaseDedup_TEST {
   
    @testSetup static void dataSetup(){
        Contact cont = (Contact)HP_UTIL_SmartFactory.createSObject('Contact','HP_Contact', new Map<String, Object>{
            'Id_Tiers__c' => 100166,
            'HP_IsHappe__c' => true,
            'LastName' => 'last',
            'firstname' => 'first',
            'Email' => 'test@gmail.com',
            'Salutation' => ' Mr'
            },null,null,null);
        insert cont;

        List<Case> caseList = new List<Case>();
        Case case1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {            'Status' =>  HP_SLCT_Case.Status.TO_DO.name(),
            'Subject' => 'Case 1' ,
            'Description' => 'Description 1',
            'Contact__c' => cont.Id
        }, null,null,null);
        caseList.add(case1);

        Case case2 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {            'Status' =>  HP_SLCT_Case.Status.HP_PENDING.name(),
            'Subject' => 'Case 2' ,
            'Description' => 'Description 1',
            'Contact__c' => cont.Id
        }, null,null,null);
        caseList.add(case2);

        Case case3 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {            'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
            'Subject' => 'Case 1' ,
            'Description' => 'Description 1',
            'Contact__c' => cont.Id
            }
            , null,null,null);
        caseList.add(case3);

        insert caseList;

        Test.setCreatedDate(case1.Id, DateTime.newInstance(2012,12,12));
        Test.setCreatedDate(case2.Id, DateTime.newInstance(2013,12,12));
    }


    @isTest 
    public static void  updateDuplicatedCases() {
    
        Test.startTest();
        HP_BAT018_CaseDedup.execute();
        Test.stopTest();

        List<Case> caseList = [SELECT Id, Contact.id_tiers__c, Status, Description, Subject, CreatedDate, SuppliedEmail, HP_isHappe__c FROM Case WHERE HP_isHappe__c = True ORDER BY CreatedDate ASC];
        System.assert(caseList.get(0).Status == 'TO_DO');
        System.assert(caseList.get(1).Status == 'HP_PENDING');
        System.assert(caseList.get(2).Status == 'CANCELED');

    }

}