@isTest
public class SM_AP61_PersonneOctopus_TEST {
    /*
    *   @description : Appel depuis le selfcare
    */
   
    @isTest(SeeAllData = false)
    public static void majPersonneAdresse()
    {
        SM_OCTOPUS__c orgSettings = new SM_OCTOPUS__c();
        orgSettings.certName__c = 'smileselfsignedcert';
        insert orgSettings;
        // Test 1
        Account acc = new Account(ID_Local__c =4543,ID_Porte_feuille_contrat__c=432432, No_Compte_contrat__c='5435',Name='test user');
        insert acc ;
        Contact aContact1 = new Contact(AccountId=acc.Id, Firstname = 'Testing1', Lastname = 'Testing1', Identifiant_Buisness_Partener__c = '0123456789');
        insert aContact1;
        System.debug('*** majPersonne');
        Map < String, Object > inputMap1 = new Map < String, Object >();     
        Map < String, Object > outMap1 = new Map < String, Object >();   
        Map < Object, Object > elementsMap1 = new Map < Object, Object >();  
        Map < Object, Object > adresseMap1 = new Map < Object, Object >();   
        Map < Object, Object > emailMap1 = new Map < Object, Object >();
        Map < Object, Object > email3BlocMap1 = new Map < Object, Object >();
        Map < Object, Object > fixeMap1 = new Map < Object, Object >();
        Map < Object, Object > fixe3BlocMap1 = new Map < Object, Object >();
        Map < Object, Object > mobileMap1 = new Map < Object, Object >();
        Map < Object, Object > mobile3BlocMap1 = new Map < Object, Object >();
        Map < Object, Object > canauxMkt1 = new Map < Object, Object >();
        Map < Object, Object > stopMkt1 = new Map < Object, Object >();
        emailMap1.put('NouvelleAdresseMail1', 'email1@engie.com');
        emailMap1.put('NouvelleAdresseMail2', 'email2@engie.com');
        email3BlocMap1.put('NouvelleAdresseMail3', 'email3@engie.com');
        emailMap1.put('Email3Block', email3BlocMap1);
        emailMap1.put('principalEmail', 'Adresse Mail 1');
        emailMap1.put('RefusEmail', false);
        fixeMap1.put('NewTelFixe1', '0101010101');
        fixeMap1.put('NewTelFixe2', '0101010102');
        fixe3BlocMap1.put('NewTelFixe3', '0101010103');
        fixeMap1.put('Fix3Block', fixe3BlocMap1);
        fixeMap1.put('principalFixe', 'Tel Fixe 1');
        fixeMap1.put('RefusTelFixe', false);
        mobileMap1.put('NewMobile1', '0601010101');
        mobileMap1.put('NewMobile2', '0601010102');
        mobile3BlocMap1.put('NewMobile3', '0601010103');
        mobileMap1.put('mobile3Block', mobile3BlocMap1);
        mobileMap1.put('principalMobile', 'Mobile 1');
        mobileMap1.put('RefusTelMobile', false);
        elementsMap1.put('AdresseEmail', emailMap1);
        elementsMap1.put('TelFixe', fixeMap1);
        elementsMap1.put('TelMobile', mobileMap1);
        elementsMap1.put('AdresseContact', adresseMap1);
        adresseMap1.put('NoVoie', '104');
        adresseMap1.put('Adresse', 'avenue aristide Briand');
        adresseMap1.put('ComplementAdresse', '4e etage');
        adresseMap1.put('Ville', 'Bagneux');
        adresseMap1.put('CodePostal', '92220');
        adresseMap1.put('Chez', 'Test Test');
        
        inputMap1.put('updateComplement', true);
        inputMap1.put('updateAdresse', true);
        inputMap1.put('updateChez', true);
        
        
        
        stopMkt1.put('StopPhoning', true);
        stopMkt1.put('StopMailing', true);
        canauxMkt1.put('CanalPreference', 'Courrier');
        canauxMkt1.put('Stop', stopMkt1);
        elementsMap1.put('ChoixCanal', canauxMkt1);
        inputMap1.put('ChoixElements', elementsMap1);
        inputMap1.put('ContextId', aContact1.Id);
        Test.startTest();
        SM_AP61_PersonneOctopus personneWS = new SM_AP61_PersonneOctopus();
        personneWS.invokeMethod('majPersonneAdresse',inputMap1,outMap1,null);
        //System.assertEquals('OCTOPUS_MAJPersonne_01', outMap.get('majPersonneRet'));
        Test.stopTest();
    }
    @isTest(SeeAllData = false)
    public static void majPersonneLWC()
    {
        SM_OCTOPUS__c orgSettings = new SM_OCTOPUS__c();
        orgSettings.certName__c = 'smileselfsignedcert';
        insert orgSettings;
        // Test 1
        Account acc = new Account(ID_Local__c =4543,ID_Porte_feuille_contrat__c=432432, No_Compte_contrat__c='5435',Name='test user');
        insert acc ;
        Contact aContact1 = new Contact(AccountId=acc.Id, Firstname = 'Testing1', Lastname = 'Testing1', Identifiant_Buisness_Partener__c = '0123456789');
        insert aContact1;
        System.debug('*** majPersonne');
        Map < String, Object > inputMap1 = new Map < String, Object >();     
        Map < String, Object > outMap1 = new Map < String, Object >();   
        Map < Object, Object > elementsMap1 = new Map < Object, Object >();  
        Map < Object, Object > adresseMap1 = new Map < Object, Object >();   
        Map < Object, Object > emailMap1 = new Map < Object, Object >();
        Map < Object, Object > email3BlocMap1 = new Map < Object, Object >();
        Map < Object, Object > fixeMap1 = new Map < Object, Object >();
        Map < Object, Object > fixe3BlocMap1 = new Map < Object, Object >();
        Map < Object, Object > mobileMap1 = new Map < Object, Object >();
        Map < Object, Object > mobile3BlocMap1 = new Map < Object, Object >();
        Map < Object, Object > canauxMkt1 = new Map < Object, Object >();
        Map < Object, Object > stopMkt1 = new Map < Object, Object >();
        emailMap1.put('NouvelleAdresseMail1', 'email1@engie.com');
        emailMap1.put('NouvelleAdresseMail2', 'email2@engie.com');
        email3BlocMap1.put('NouvelleAdresseMail3', 'email3@engie.com');
        emailMap1.put('Email3Block', email3BlocMap1);
        emailMap1.put('principalEmail', 'Adresse Mail 1');
        emailMap1.put('RefusEmail', false);
        fixeMap1.put('NewTelFixe1', '+33101010101');
        fixeMap1.put('NewTelFixe2', '+33101010102');
        fixe3BlocMap1.put('NewTelFixe3', '+33101010103');
        fixeMap1.put('Fix3Block', fixe3BlocMap1);
        fixeMap1.put('principalFixe', 'Tel Fixe 1');
        fixeMap1.put('RefusTelFixe', false);
        mobileMap1.put('NewMobile1', '+33601010101');
        mobileMap1.put('NewMobile2', '+33601010102');
        mobile3BlocMap1.put('NewMobile3', '+33601010103');
        mobileMap1.put('mobile3Block', mobile3BlocMap1);
        mobileMap1.put('principalMobile', 'Mobile 1');
        mobileMap1.put('RefusTelMobile', false);
        elementsMap1.put('AdresseEmail', emailMap1);
        elementsMap1.put('TelFixe', fixeMap1);
        elementsMap1.put('TelMobile', mobileMap1);
        elementsMap1.put('AdresseContact', adresseMap1);
        adresseMap1.put('NoVoie', '104');
        adresseMap1.put('Adresse', 'avenue aristide Briand');
        adresseMap1.put('ComplementAdresse', '4e etage');
        adresseMap1.put('Ville', 'Bagneux');
        adresseMap1.put('CodePostal', '92220');
        adresseMap1.put('Chez', 'Test Test');
        stopMkt1.put('StopPhoning', true);
        stopMkt1.put('StopMailing', true);
        canauxMkt1.put('CanalPreference', 'Courrier');
        canauxMkt1.put('Stop', stopMkt1);
        elementsMap1.put('ChoixCanal', canauxMkt1);
        inputMap1.put('ChoixElements', elementsMap1);
        inputMap1.put('ContextId', aContact1.Id);
        // Test 2
        Account acc2 = new Account(ID_Local__c =4544,ID_Porte_feuille_contrat__c=432433, No_Compte_contrat__c='5436',Name='test user2');
        insert acc2 ;
        Contact aContact2 = new Contact(AccountId=acc2.Id, Firstname = 'Testing2', Lastname = 'Testing2', Identifiant_Buisness_Partener__c = '1234567890', Mobile_2__c = '+33601010102');
        insert aContact2;
        System.debug('### RRH aContact2 = '+aContact2);
        System.debug('*** majPersonne');
        Map < String, Object > inputMap2 = new Map < String, Object >();     
        Map < String, Object > outMap2 = new Map < String, Object >();   
        Map < Object, Object > elementsMap2 = new Map < Object, Object >();  
        Map < Object, Object > adresseMap2 = new Map < Object, Object >();   
        Map < Object, Object > emailMap2 = new Map < Object, Object >();
        Map < Object, Object > email3BlocMap2 = new Map < Object, Object >();
        Map < Object, Object > fixeMap2 = new Map < Object, Object >();
        Map < Object, Object > fixe3BlocMap2 = new Map < Object, Object >();
        Map < Object, Object > mobileMap2 = new Map < Object, Object >();
        Map < Object, Object > mobile3BlocMap2 = new Map < Object, Object >();
        Map < Object, Object > canauxMkt2 = new Map < Object, Object >();
        Map < Object, Object > stopMkt2 = new Map < Object, Object >();
        
        emailMap2.put('NouvelleAdresseMail1', 'email1@engie.com');
        emailMap2.put('NouvelleAdresseMail2', 'email2@engie.com');
        email3BlocMap2.put('NouvelleAdresseMail3', 'email3@engie.com');
        emailMap2.put('Email3Block', email3BlocMap2);
        emailMap2.put('principalEmail', 'Adresse Mail 1');
        emailMap2.put('RefusEmail', true);
        fixeMap2.put('NewTelFixe1', '+33101010201');
        fixeMap2.put('NewTelFixe2', '+33101010202');
        fixe3BlocMap2.put('NewTelFixe3', '+33101010203');
        fixeMap2.put('Fix3Block', fixe3BlocMap2);
        fixeMap2.put('principalFixe', 'Tel Fixe 1');
        fixeMap2.put('RefusTelFixe', true);
        mobileMap2.put('NewMobile1', '+33601010101');
        mobileMap2.put('NewMobile2', '+33601010102');
        mobile3BlocMap2.put('NewMobile3', '+33601010103');
        mobileMap2.put('mobile3Block', mobile3BlocMap2);
        mobileMap2.put('principalMobile', 'Mobile 1');
        mobileMap2.put('RefusTelMobile', false);
        mobileMap2.put('updatePrincipalMobile', 'Mobile 2');
        elementsMap2.put('AdresseEmail', emailMap2);
        elementsMap2.put('TelFixe', fixeMap2);
        elementsMap2.put('TelMobile', mobileMap2);
        elementsMap2.put('AdresseContact', adresseMap2);
        adresseMap2.put('NoVoie', '104');
        adresseMap2.put('Adresse', 'avenue aristide Briand');
        adresseMap2.put('ComplementAdresse', '4e etage');
        adresseMap2.put('Ville', 'Bagneux');
        adresseMap2.put('CodePostal', '92220');
        adresseMap2.put('Chez', 'Test Test');
        stopMkt2.put('StopPhoning', false);
        stopMkt2.put('StopMailing', false);
        canauxMkt2.put('CanalPreference', 'Mobile');
        canauxMkt2.put('Stop', stopMkt2);
        elementsMap2.put('ChoixCanal', canauxMkt2);
        inputMap2.put('ChoixElements', elementsMap2);
        inputMap2.put('ContextId', aContact2.Id);
        // Test 3
        Account acc3 = new Account(ID_Local__c =4545,ID_Porte_feuille_contrat__c=432434, No_Compte_contrat__c='5437',Name='test user3');
        insert acc3 ;
        Contact aContact3 = new Contact(AccountId=acc3.Id, Firstname = 'Testing3', Lastname = 'Testing3', Identifiant_Buisness_Partener__c = '2345678901', MobilePhone = '+33606060606', 
                                        Mobile_2__c = '+33606060606', Mobile_3__c = '+33606060606', Phone = '+33101010101', Tel_fixe_2__c = '+33101010101', Tel_fixe_3__c = '+33101010101');
        insert aContact3;
        System.debug('*** majPersonne');
        Map < String, Object > inputMap3 = new Map < String, Object >();     
        Map < String, Object > outMap3 = new Map < String, Object >();   
        Map < Object, Object > elementsMap3 = new Map < Object, Object >();  
        Map < Object, Object > adresseMap3 = new Map < Object, Object >();   
        Map < Object, Object > emailMap3 = new Map < Object, Object >();
        Map < Object, Object > email3BlocMap3 = new Map < Object, Object >();
        Map < Object, Object > fixeMap3 = new Map < Object, Object >();
        Map < Object, Object > fixe3BlocMap3 = new Map < Object, Object >();
        Map < Object, Object > mobileMap3 = new Map < Object, Object >();
        Map < Object, Object > mobile3BlocMap3 = new Map < Object, Object >();
        Map < Object, Object > canauxMkt3 = new Map < Object, Object >();
        Map < Object, Object > stopMkt3 = new Map < Object, Object >();
        emailMap3.put('NouvelleAdresseMail1', null);
        emailMap3.put('NouvelleAdresseMail2', null);
        email3BlocMap3.put('NouvelleAdresseMail3', null);
        emailMap3.put('Email3Block', email3BlocMap3);
        emailMap3.put('principalEmail', 'Adresse Mail 1');
        emailMap3.put('RefusEmail', false);
        fixeMap3.put('NewTelFixe1', null);
        fixeMap3.put('NewTelFixe2', null);
        fixe3BlocMap3.put('NewTelFixe3', null);
        fixeMap3.put('Fix3Block', fixe3BlocMap2);
        fixeMap3.put('principalFixe', 'Tel Fixe 1');
        fixeMap3.put('RefusTelFixe', false);
        mobileMap3.put('NewMobile1', '');
        mobileMap3.put('NewMobile2', '');
        mobile3BlocMap3.put('NewMobile3', '');
        mobileMap3.put('mobile3Block', mobile3BlocMap3);
        mobileMap3.put('principalMobile', 'Mobile 1');
        mobileMap3.put('RefusTelMobile', false);
        elementsMap3.put('AdresseEmail', emailMap3);
        elementsMap3.put('TelFixe', fixeMap3);
        elementsMap3.put('TelMobile', mobileMap3);
        elementsMap3.put('AdresseContact', adresseMap3);
        adresseMap3.put('NoVoie', '104');
        adresseMap3.put('Adresse', 'avenue aristide Briand');
        adresseMap3.put('ComplementAdresse', '4e etage');
        adresseMap3.put('Ville', 'Bagneux');
        adresseMap3.put('CodePostal', '92220');
        adresseMap3.put('Chez', 'Test Test');
        stopMkt3.put('StopPhoning', false);
        stopMkt3.put('StopMailing', false);
        canauxMkt3.put('CanalPreference', 'Mobile');
        canauxMkt3.put('Stop', stopMkt3);
        elementsMap3.put('ChoixCanal', canauxMkt3);
        inputMap3.put('ChoixElements', elementsMap3);
        inputMap3.put('ContextId', aContact3.Id);
        Test.startTest();
        SM_AP61_PersonneOctopus.invokeMethodLWC('majPersonne',inputMap1,outMap1);
        SM_AP61_PersonneOctopus.invokeMethodLWC('majPersonne',inputMap2,outMap2);
        SM_AP61_PersonneOctopus.invokeMethodLWC('majPersonne',inputMap3,outMap3);
        Test.stopTest();
    } 
    @isTest(SeeAllData = false)
    public static void creerPersonneCorrespondance_TEST()
    {        
        SM_OCTOPUS__c orgSettings = new SM_OCTOPUS__c();
        orgSettings.certName__c = 'smileselfsignedcert';
        insert orgSettings;
        Map < String, Object > inputMap = new Map < String, Object >();     
        Map < String, Object > outMap = new Map < String, Object >(); 
        inputMap.put('mail1', 'mail1@mail.com');
        inputMap.put('mail2', 'mail2@mail.com');
        inputMap.put('mail3', 'mail3@mail.com');
        inputMap.put('tel1', '0490201291');
        inputMap.put('tel2', '0490201292');
        inputMap.put('tel3', '0490201293');
        inputMap.put('mobile1', '0690201291');
        inputMap.put('mobile2', '0690201292');
        inputMap.put('mobile3', '0690201293');
        Test.startTest();
        SM_AP61_PersonneOctopus personneWS = new SM_AP61_PersonneOctopus();
        personneWS.invokeMethod('creerPersonneCorrespondance',inputMap,outMap,null);
        String idPersonne = (String) outMap.get('idPersonne');
        System.assertEquals('1', idPersonne);
        Test.stopTest();
    }
    @isTest
    public static void majProfilMarketing(){
        //GIVEN
        Account acc = new Account(ID_Local__c =4543,ID_Porte_feuille_contrat__c=432432, No_Compte_contrat__c='5435',Name='test user');
        insert acc ;
        Contact contactNew = new Contact(AccountId=acc.Id,Identifiant_Buisness_Partener__c='1234567890',LastName='user',Email = 'test1@email.com',Adresse_Mail_2__c = 'test2@email.com',Adresse_Mail_3__c = 'test3@email.com',Adresse_Mail_Principale__c = 'Adresse Mail 1') ;
        insert contactNew ;
        SM_OCTOPUS__c orgSettings = new SM_OCTOPUS__c();
        orgSettings.certName__c = 'smileselfsignedcert';
        insert orgSettings;
        Map<String,Object> inputMap = new Map<String,Object>{
            'numeroBP' => '1234567890',
                'email' => 'test3@email.com'
        };
        Map<String,Object> outputMap = new Map<String,Object>();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPersonneV8HttpMock());
        //WHEN
        SM_AP61_PersonneOctopus.majPersonneProfilMarketing(inputMap, outputMap, null);
        //THEN
        Contact afterUpdate = [SELECT Email,Adresse_Mail_2__c,Adresse_Mail_3__c,EmailPrincipalValueRW__c,Adresse_Mail_Principale__c FROM Contact WHERE Identifiant_Buisness_Partener__c = '1234567890' LIMIT 1];
        System.debug('### aka  afterUpdate.EmailPrincipalValueRW__c ' +  afterUpdate.EmailPrincipalValueRW__c);
        System.assertEquals('OK', (String)outputMap.get('MAJProfilMarketing'));
        System.assertEquals('Adresse Mail 3', afterUpdate.Adresse_Mail_Principale__c);
        //System.assertEquals('test3@email.com', afterUpdate.EmailPrincipalValueRW__c);
        Test.stopTest();
    }
    
    @isTest
    public static void majEmailPreferePersonne(){
        //GIVEN
        Account acc = new Account(ID_Local__c =4543,ID_Porte_feuille_contrat__c=432432, No_Compte_contrat__c='5435',Name='test user');
        insert acc ;
        Contact contactNew = new Contact(AccountId=acc.Id,Identifiant_Buisness_Partener__c='1234567890',LastName='user',Email = 'test1@email.com',Adresse_Mail_2__c = 'test2@email.com',Adresse_Mail_3__c = 'test3@email.com',Adresse_Mail_Principale__c = 'Adresse Mail 1') ;
        insert contactNew ;
        SM_OCTOPUS__c orgSettings = new SM_OCTOPUS__c();
        orgSettings.certName__c = 'smileselfsignedcert';
        insert orgSettings;
        Map<String,Object> outputMap = new Map<String,Object>();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPersonneV8HttpMock());
        //WHEN
        SM_AP61_PersonneOctopus.majEmailPreferePersonne('1234567890', 'test3@email.com', 'Adresse Mail 3');
        Test.stopTest();
    }
    @isTest(SeeAllData = false)
    public static void lirePersonneLWC()
    {
        SM_OCTOPUS__c orgSettings = new SM_OCTOPUS__c();
        orgSettings.certName__c = 'smileselfsignedcert';
        insert orgSettings;

        Account acc = new Account(ID_Local__c =4543,ID_Porte_feuille_contrat__c=432432, No_Compte_contrat__c='5435',Name='test user for lirePersonne');
        insert acc ;
        Contact aContact1 = new Contact(AccountId=acc.Id, Firstname = 'Testing lirePersonne', Lastname = 'Testing lirePersonne', Identifiant_Buisness_Partener__c = '0306589241');
        //Contact aContact2 = new Contact(AccountId=acc.Id, Firstname = 'Testing lirePersonne', Lastname = 'Testing lirePersonne', Identifiant_Buisness_Partener__c = '0306589');
        insert aContact1;
        //insert aContact2;

        Map < String, Object > inputMap1 = new Map < String, Object >();     
        //Map < String, Object > inputMap2 = new Map < String, Object >();     
        Map < String, Object > outMap1 = new Map < String, Object >(); 
        //Map < String, Object > outMap2 = new Map < String, Object >(); 

        inputMap1.put('ContextId', aContact1.Id);
        //inputMap2.put('ContextId', aContact2.Id);

        Test.startTest();
        outMap1 = SM_AP61_PersonneOctopus.invokeMethodLWC('lirePersonne',inputMap1, null);
        //outMap2 = SM_AP61_PersonneOctopus.invokeMethodLWC('lirePersonne',inputMap2, null);
        System.assertEquals('OCTOPUS_LirePersonne_01', outMap1.get('lirePersonneRet'));
        //System.assertEquals('OCTOPUS_LirePersonne_13', outMap2.get('lirePersonneRet'));
        Test.stopTest();
    }

    @isTest(SeeAllData = false)
    public static void majTitulaire()
    {
        SM_OCTOPUS__c orgSettings = new SM_OCTOPUS__c();
        orgSettings.certName__c = 'smileselfsignedcert';
        insert orgSettings;

        Account acc = new Account(ID_Local__c =4543,ID_Porte_feuille_contrat__c=432432, No_Compte_contrat__c='5435',Name='test user');
        insert acc ;
        Contact aContact = new Contact(AccountId=acc.Id, Firstname = 'Testing', Lastname = 'Testing', Identifiant_Buisness_Partener__c = '0123456789');
        insert aContact;

        System.debug('*** majTitulaire' + aContact);
        Map < String, Object > inputMap = new Map < String, Object >();     
        Map < String, Object > outMap = new Map < String, Object >();   

        Map < String, Object > elementsMap = new Map < String, Object >(); 
        Map < String, Object > ContactInfo = new Map < String, Object >(); 
         

        ContactInfo.put('Nom', 'test');
        ContactInfo.put('Prenom', 'Apex');
        ContactInfo.put('Civilite', 'MR');
        elementsMap.put('ContactInfo', ContactInfo);
        inputMap.put('ChoixElements', elementsMap);
        inputMap.put('ContextId', aContact.Id);

        Test.startTest();
        
        SM_AP61_PersonneOctopus personneWS = new SM_AP61_PersonneOctopus();
        
        personneWS.invokeMethod('majTitulaire',inputMap,outMap,null);
        System.assertEquals('OCTOPUS_MAJPersonne_01', outMap.get('majPersonneRet'));

        Test.stopTest();
    }
    
    @isTest(SeeAllData = false)
    public static void updateCaseAsych(){
        // Pour augmenter le taux de couverture
        Account acc = new Account(ID_Local__c =4543,ID_Porte_feuille_contrat__c=432432, No_Compte_contrat__c='5435',Name='test user');
        insert acc ;
        Contact aContact1 = new Contact(AccountId=acc.Id, Firstname = 'Testing1', Lastname = 'Testing1', Identifiant_Buisness_Partener__c = '0123456789');
        insert aContact1;
        String input = '{"idContact":"'+aContact1.id+'", "No_Voie__c":"1","MailingStreet":"test","MailingPostalCode":"test","MailingCity":"paris","Chez":"test","Complement_adresse__c":"test"}';
        SM_AP61_PersonneOctopus.updateCaseAsych(input);
    }
}