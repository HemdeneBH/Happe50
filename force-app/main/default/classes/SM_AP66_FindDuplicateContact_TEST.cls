/*
* @Author: Amine Deghais ~ amine.deghais@external.engie.com
* @Date: 03/09/2019
* @Description: test Class:Insère un contact et vérifie si la méthode duplicate le détecte comme contacte "Doublon"
*/
@isTest
private class SM_AP66_FindDuplicateContact_TEST {
    @isTest static void testFindDuplicates(){
        Test.startTest();        
        Map < String, Object > inputMap=new Map<String,Object>();        
        Map < String, Object > outputMap =new Map<String,Object>();
        SM_AP66_FindDuplicateContact service=new SM_AP66_FindDuplicateContact();        
        Contact contactCheck=new Contact(
            LastName = 'SENE2',
            Email = 'sene.alain@yopmail.com',
            Adresse_Mail_3__c = 'sene.alain3@yopmail.com',
            Adresse_Mail_2__c = 'sene.alain@2yopmail.com',
            Adresse_Mail_Principale__c='Adresse Mail 1',
            Mobile_3__c='+33654545402',
            Mobile_2__c='+33654545402', 
            Mobile_Principal__c='Mobile 1',
            Tel_Fixe_3__c='+33154545402', 
            Tel_Fixe_2__c ='+33154545402',
            Tel_Fixe_Principal__c ='Tel Fixe 2',
            TelFixePrincipalValueRW__c	='+33154545402',
            Phone='+33154545402',
            MobilePhone='+33654545402',
            tech_bypass_dupRul__c = false,
            RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Smile').getRecordTypeId());        
        insert contactCheck;      
        inputMap.put('ContactInfo',new Map<String,Object>{
                'CivilityBlock' =>  new Map<String,Object>{
                    'LastName' =>  contactCheck.LastName
                } ,                
                'Complement_adresse__c' => contactCheck.Complement_adresse__c,                
                'Address'=>new Map<String,Object>{                                  
                    'StreetFormula'=>  contactCheck.MailingStreet,
                        'PC'=>  contactCheck.MailingPostalCode,
                        'CityFormula'=>  contactCheck.MailingCity,
                        'Country'=>  contactCheck.MailingCountry
                        
                        },     
                            'Email'=>new Map<String,Object>{
                                'NewEmail1'=> contactCheck.Email,
                                    'NewEmail2' => contactCheck.Adresse_Mail_2__c,
                                    'NewEmail3' => contactCheck.Adresse_Mail_3__c,
                                    'selectedEmail'=>'Adresse Mail 1'
                                    
                                    }, 
                                        'TelMobile'=>new Map<String,Object>{
                                            'SFNewMobile1' => contactCheck.MobilePhone ,
                                                'selectedNumMobile'=>'Mobile 1'
                                                },
                                                    'TelFixe'=>new Map<String,Object>{
                                                        'SFNewTelFixe2'=>contactCheck.Tel_Fixe_2__c,
                                                            'selectedNumFixe'=>'Tel Fixe 2'
                                                            },                                                                                                                                
                                                                'RecordTypeId' =>Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Smile').getRecordTypeId()
                                                                });        
        service.invokeMethod('findDuplicates', inputMap,  outputMap, null);
        System.debug('output'+outputMap);
        Boolean duplicatesFound = (Boolean) outputMap.get('duplicatesFound');
        //duplication nemarche pas dans les classe de tests
        System.assertEquals(duplicatesFound, true);

        Test.stopTest();
    }
}