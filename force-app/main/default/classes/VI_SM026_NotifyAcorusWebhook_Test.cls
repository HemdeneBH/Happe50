/**
* @Author: Jalal ARIB (Coe Engie B2C-DGP)
* @Description: Classe de Test qui permet de tester l'appel à Acorus
* Le contenu de l'objet est envoyé sous forme de Json
* @CreatedDate: 10/11/2020
* @LastModified: 
*/
@isTest
public class VI_SM026_NotifyAcorusWebhook_Test{
    @testSetup
    static void testSetup(){
        List<Group> ownerQueue = [Select Id,DeveloperName from Group where Type = 'Queue'];
        
        system.debug('query queue '+ownerQueue);
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        u.isactive=true;
        insert u;
    }
    
    @isTest static void testTrigger() {
        User u =[Select id,isactive from user where firstname='Test' and lastname='Test' limit 1];
            Test.startTest();
            // create Account
            Account Acc = SM_TestDataFactory.createAccount('Harmonica_Account');
            Insert acc;
            // Create Case
            Id CaseRTId = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Acquisition_Harmonica').getRecordTypeId();
            Case caseTest = SM_TestDataFactory.createCase('TEST', Acc.Id);
            caseTest.recordTypeId=CaseRTId;
            caseTest.Sous_type__c = 'Changement de fournisseur';
            caseTest.Origin = 'Partner Community';
            caseTest.CPV_E_Lien_CPV__c = 'test1';
            insert caseTest;   
        	Donnees_Vente__c ddv= new Donnees_Vente__c(CaseId__c = caseTest.Id);
        	insert ddv;
            system.assertEquals('test1', caseTest.CPV_E_Lien_CPV__c);
            caseTest.CPV_E_Lien_CPV__c = 'test';
            system.assertEquals('test', caseTest.CPV_E_Lien_CPV__c);
            update caseTest;   
            Test.stopTest();
        
    }
    
}