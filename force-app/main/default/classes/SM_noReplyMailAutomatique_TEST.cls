/*
* @Author: Ibrahim Merabti
* @Date: 10/06/2020
* @Description: Test Class for SM_noReplyMailAutomatique
*/

@isTest
public class SM_noReplyMailAutomatique_TEST {

    @testSetup 
    static void setup() {
        
        // create Account
        Account Acc = SM_TestDataFactory.createAccount('Harmonica_Account');
        Insert acc;
        
        // Create Case
        Case harmonicaCase = SM_TestDataFactory.createCase('TEST', Acc.Id);
        insert harmonicaCase;
        
        // create a contact
        Contact cc = SM_TestDataFactory.createContact('Test', acc.Id);
        cc.email = 'test@test.com';
        insert cc;
        
        // create an Email Message
        EmailMessage emg = SM_TestDataFactory.createEmailMessage(Acc.Id, harmonicaCase.Id, new List<Id>{cc.Id}, 'test@test.com', '0', 'ibrahim.merabti@external.engie.com', 'TEST', 'TEST', 'TEST');
        insert emg;
    }
    
    @isTest 
    public static void testSendNoReplyEmail(){
       EmailMessage emg = [select fromAddress from EmailMessage limit 1];  
       Test.startTest();
        SM_noReplyMailAutomatique.sendNoReplyMail(new List<EmailMessage>{emg});
        Integer invocations = Limits.getEmailInvocations();
        Test.StopTest(); 
        system.assertEquals(2, invocations);
    }
    
}