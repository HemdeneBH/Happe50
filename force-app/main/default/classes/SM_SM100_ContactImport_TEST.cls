/**
 * @author Agourri Mostafa + AYOUB BERRAMDANE
 * @date 16/02/2022
 * @description SM_EM101_Account - Entity to manage Account SObject
 */
@isTest
private class SM_SM100_ContactImport_TEST {

    @testSetup static void dataCreation(){
        Account acc = new Account();
        acc.Name = 'EJ_ACCOUNT';
        acc.RecordTypeId = SM_AP45_XdataImportUtils.getRecTypeId(Account.sObjectType, 'Consumer');
        acc.No_Compte_contrat__c = '000001';
        insert acc;
        
        Contact ct=SM_TestDataFactory.createContact('lastName',acc.Id); 
        ct.Identifiant_Buisness_Partener__c='0000001';
		insert ct;
    }
    
    @isTest static void testSyncImportContacts(){
        List<Map<String,String>> ListContacts = new List<Map<String,String>>();
        for(Integer i = 0 ; i<10 ; i++){
            Map<String,String> Contact = new Map<String,String>{
                'referenceClient' => '000000'+i,
                'idTiers' => '100'+i,
                'idTiersUnifie' => '200'+i,
                'civilite'=>'MR',
                'firstName'=>'Lorem'+i,
                'lastName' => 'Upsom'+i,
                'mobilePrincipal' => 'Mobile 1',
                'mobile1' => '+33652954152',
                'adresseMailPrincipale' => 'Adresse Mail 1',
                'adresseMail1' => 'test'+i+'@valid.com',
                'adresseMail2' => 'test'+i+'@invalid',
                'adresseMail3' => 'test'+i+'@invalid',
                'adresseMailEspaceClient'=> 'test'+i+'@invalid',
                'complementAdresse'=>'Complement_adresse__c',
                'mailingPostCode'=>'MailingPostalCode',
                'mailingCity'=>'MailingCity',
                'noCompteContrat' => '000000'+i,
                'segmentMarketing' => 'Segment_Marketing__c' 
            };
                if(math.mod(i,10)==0) Contact.remove('noCompteContrat');
            ListContacts.add(Contact);
        }      
        String SyncOutput = SM_SM100_ContactImport.importContacts(ListContacts);
        System.debug('output >>>>> ' + SyncOutput);
   }
    
    @isTest static void testASyncImportContacts(){
        List<Map<String,String>> ListContacts = new List<Map<String,String>>();
        for(Integer i = 0 ; i<100 ; i++){
            Map<String,String> Contact = new Map<String,String>{
                'referenceClient' => '000000'+i,
                'idTiers' => '100'+i,
                'idTiersUnifie' => '200'+i,
                'civilite'=>'MR',
                'firstName'=>'Lorem'+i,
                'lastName' => 'Upsom'+i,
                'mobilePrincipal' => 'Mobile 1',
                'mobile1' => '+33652954152',
                'adresseMailPrincipale' => 'Adresse Mail 1',
                'adresseMail1' => 'test'+i+'@valid.com',
                'adresseMail2' => 'test'+i+'@invalid',
                'adresseMail3' => 'test'+i+'@invalid',
                'adresseMailEspaceClient'=> 'test'+i+'@invalid',
                'complementAdresse'=>'Complement_adresse__c',
                'mailingPostCode'=>'MailingPostalCode',
                'mailingCity'=>'MailingCity',
                'noCompteContrat' => '000000'+i,
                'segmentMarketing' => 'Segment_Marketing__c' 
            };
            ListContacts.add(Contact);
        }      
        String SyncOutput = SM_SM100_ContactImport.importContacts(ListContacts);
        System.debug('output >>>>> ' + SyncOutput);
    }
}