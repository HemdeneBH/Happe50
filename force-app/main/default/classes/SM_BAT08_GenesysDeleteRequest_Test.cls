@isTest
public class SM_BAT08_GenesysDeleteRequest_Test {

    
    @testSetup
    static void testData() {
    
        insert new ByPassSettings__c(
            SetupOwnerId = UserInfo.getUserId(),
            ValidationRule__c   = true,
            ProcessBuilder__c   = true,
            CaseTrigger__c      = true,
            AccountTrigger__c   = true,
            ContactTrigger__c   = true
        );
        
        List<case> cases = new List<case>();
        Id userId ='0051v00000A8HiMAAV' ; 
        // insert 50 cases
        Id recordTypeIdCRC = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Acquisition').getRecordTypeId();
        for (Integer i=0;i<50;i++) {
            if(i<15){
               cases.add(new case(RecordTypeId= recordTypeIdCRC,
                                   Origin= 'Téléphone',
                                   Status= 'En attente',
                                   Type= 'Acquisition',
                                   Sous_type__c= 'Emménagement',
                                   SM_Tech_SupprimerGenesys__c= true,
                                   PureCloud_conversationId__c= '000000'+i));
                                              
            }else{
             cases.add(new case(RecordTypeId= recordTypeIdCRC,
                                   Origin= 'Téléphone',
                                   Status= 'A traiter',
                                   Type= 'Acquisition',
                                   Sous_type__c= 'Emménagement',
                                   SM_Tech_EnvoyerGenesys__c= true));
                                    
            }
                    
           
        }
       
        insert cases;
       
        System.debug([select count()from case]);
    }
    @isTest 
    static void testDeleteCallout() {
        Test.setMock(HttpCalloutMock.class, new SM_BAT08_GenesysDeleteRequest_Mock());
        Test.startTest();
        SM_BAT08_GenesysDeleteRequest deleteBatch = new SM_BAT08_GenesysDeleteRequest(20);
        Id batchId = Database.executeBatch(deleteBatch,99);
        Test.stopTest();
        // Vérifier si toutes les cases sont traitées
        System.assertEquals(30, [select count() from case where SM_Tech_SupprimerGenesys__c= true or SM_Tech_EnvoyerGenesys__c= true ]);   
    }
}