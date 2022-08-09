/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-15-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-13-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@IsTest
public with sharing class HP_EM051_HPProcessInstance_TEST {
       
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

                Case acase = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
                    'Description' => 'Description Test',
                    'Subject' => 'TEST',
                    'HP_Type__c' => 'HP_RappelLeadNonSigne',
                    'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone'),
                    'OwnerId' => UserInfo.getUserId(),
                    'Status' => 'TO_DO'}, null);
                insert acase;
            }
    
    @isTest
    public static void TestApprovalResponse() {
        Case c = [SELECT Id,HP_reponseApprobation__c FROM Case LIMIT 1 ] ;
        List<Id> caseIds = new List<Id>();
        caseIds.add(c.Id);
        Test.startTest();

        // 
        User user1 = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
            
        // Create an approval request for the account
        Approval.ProcessSubmitRequest req1 = 
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(c.id);
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(user1.Id); 
        
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('HP_APR001_EmailCaseApproval');
        req1.setSkipEntryCriteria(true);
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        // Verify the result
        System.assert(result.isSuccess());
        
        System.assertEquals(
            'Pending', result.getInstanceStatus(), 
            'Instance Status'+result.getInstanceStatus());
        
        // Approve the submitted request
        // First, get the ID of the newly created item
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 = 
            new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        
        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));
        
        // Submit the request for approval
        Approval.ProcessResult result2 =  Approval.process(req2);
        // 

        ProcessInstance p = [SELECT Id,Status FROM ProcessInstance LIMIT 1 ];
        HP_EM051_HPProcessInstance.approvalResponse(caseIds);
        ProcessInstanceStep ps = [SELECT Id,Comments FROM ProcessInstanceStep LIMIT 1 ] ;

        Test.stopTest();
        // System.assert(c.HP_reponseApprobation__c == ps.Comments);
    }
}