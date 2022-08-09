/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-05-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class HP_SM070_CheckIfHoliday_TEST {
    
    @testSetup 
        static void dataSetup(){
                Account acc = (Account)HP_UTIL_SmartFactory.createSObject('Account','HP_Account' ,new Map<String, Object>{
                    'HP_XDataExternalId__c' => 100166,
                    'Name' => 'UnitTest',
                    'OwnerId' => UserInfo.getUserId()
                },null,null, null);
                insert acc;
                
                Contact acontact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
                    'AccountId' => acc.Id,
                    'Id_Tiers__c' => 100166,
                    'Salutation'=>'MR',
                    'lastName' => 'testnicot',
                    'firstName' => 'lenfant',
                    'email' => 'user@example.com',
                    'mobilePhone' => '0756543434',
                    'Phone' => '0145454545',
                    'No_Voie__c' => '22',
                    'MailingStreet' => 'rue des bois',
                    'MailingPostalCode' => '92160',
                    'Complement_adresse__c' => 'REZID',
                    'MailingCity' =>'ANTONY',
                    'OwnerId' => UserInfo.getUserId()
                }, null, null, null);
                insert acontact;

                String todate = '01/01/2021';  
                Date dt = Date.parse( todate );  

                Case acase = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
                    'Description' => 'Description Test',
                    'Subject' => 'TEST',
                    'HP_Type__c' => 'HP_RappelLeadNonSigne',
                    'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone'),
                    'OwnerId' => UserInfo.getUserId(),
                    'HP_TreatmentDate__c' => dt,
                    'Status' => 'TO_DO'}, null);
                insert acase;
            }
    @isTest     
    public static void HolidayTest() {
        List<Case> cList = [SELECT Id,HP_reponseApprobation__c,HP_TreatmentDate__c FROM Case LIMIT 1 ] ;
        List<Id> idList = new List<Id>();
        for (Case c : cList){
            idList.add(c.Id);
            System.debug('aCase  test before:'+ c.HP_TreatmentDate__c);
        }

    	HP_SM070_HolidayWeekend.checkTreatmentDay(idList); 
        System.debug('aCase  test before:'+ cList[0].HP_TreatmentDate__c);

        
    }
}