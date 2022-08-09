@isTest
public class SM_AP61_PersonneOctopus_TEST {
    /*
    *   @description : Appel depuis le selfcare
    */
    @isTest(SeeAllData = false)
    public static void majPersonne()
    {
        SM_OCTOPUS__c orgSettings = new SM_OCTOPUS__c();
        orgSettings.certName__c = 'smilecert';
        insert orgSettings;

        Contact aContact = new Contact(Firstname = 'Testing', Lastname = 'Testing', Identifiant_Buisness_Partener__c = '0123456789');
        insert aContact;

        System.debug('*** majPersonne');
        Map < String, Object > inputMap = new Map < String, Object >();     
        Map < String, Object > outMap = new Map < String, Object >();   

        Map < String, Object > elementsMap = new Map < String, Object >();  

        Map < String, Object > adresseMap = new Map < String, Object >();   
        
        Map < String, Object > emailMap = new Map < String, Object >();
        Map < String, Object > email3BlocMap = new Map < String, Object >();

        Map < String, Object > fixeMap = new Map < String, Object >();
        Map < String, Object > fixe3BlocMap = new Map < String, Object >();

        Map < String, Object > mobileMap = new Map < String, Object >();
        Map < String, Object > mobile3BlocMap = new Map < String, Object >();

        Map < String, Object > canauxMkt = new Map < String, Object >();
        Map < String, Object > stopMkt = new Map < String, Object >();

        emailMap.put('NouvelleAdresseMail1', 'email1@engie.com');
        emailMap.put('NouvelleAdresseMail2', 'email2@engie.com');
        email3BlocMap.put('NouvelleAdresseMail3', 'email3@engie.com');
        emailMap.put('Email3Block', email3BlocMap);
        emailMap.put('principalEmail', 'Adresse Mail 1');
        emailMap.put('RefusEmail', false);

        fixeMap.put('NewTelFixe1', '0101010101');
        fixeMap.put('NewTelFixe2', '0101010102');
        fixe3BlocMap.put('NewTelFixe3', '0101010103');
        fixeMap.put('Fix3Block', fixe3BlocMap);
        fixeMap.put('principalFixe', 'Tel Fixe 1');
        fixeMap.put('RefusTelFixe', false);

        mobileMap.put('NewMobile1', '0601010101');
        mobileMap.put('NewMobile2', '0601010102');
        mobile3BlocMap.put('NewMobile3', '0601010103');
        mobileMap.put('mobile3Block', mobile3BlocMap);
        mobileMap.put('principalMobile', 'Mobile 1');
        mobileMap.put('RefusTelMobile', false);

        elementsMap.put('AdresseEmail', emailMap);
        elementsMap.put('TelFixe', fixeMap);
        elementsMap.put('TelMobile', mobileMap);
        elementsMap.put('AdresseContact', adresseMap);

        adresseMap.put('NoVoie', '104');
        adresseMap.put('Adresse', 'avenue aristide Briand');
        adresseMap.put('ComplementAdresse', '4e etage');
        adresseMap.put('Ville', 'Bagneux');
        adresseMap.put('CodePostal', '92220');

        stopMkt.put('StopPhoning', true);
        stopMkt.put('StopMailing', true);

        canauxMkt.put('CanalPreference', 'Courrier');
        canauxMkt.put('Stop', stopMkt);

        elementsMap.put('ChoixCanal', canauxMkt);

        inputMap.put('ChoixElements', elementsMap);
        inputMap.put('ContextId', aContact.Id);

        Test.startTest();
        
        SM_AP61_PersonneOctopus personneWS = new SM_AP61_PersonneOctopus();
        
        personneWS.invokeMethod('majPersonne',inputMap,outMap,null);
        System.assertEquals('OCTOPUS_MAJPersonne_01', outMap.get('majPersonneRet'));

        Test.stopTest();
    }

    @isTest(SeeAllData = false)
    public static void majPersonneLWC()
    {
        SM_OCTOPUS__c orgSettings = new SM_OCTOPUS__c();
        orgSettings.certName__c = 'smilecert';
        insert orgSettings;

        Contact aContact = new Contact(Firstname = 'Testing', Lastname = 'Testing', Identifiant_Buisness_Partener__c = '0123456789');
        insert aContact;

        System.debug('*** majPersonne');
        Map < String, Object > inputMap = new Map < String, Object >();     
        Map < String, Object > outMap = new Map < String, Object >();   

        Map < Object, Object > elementsMap = new Map < Object, Object >();  

        Map < Object, Object > adresseMap = new Map < Object, Object >();   
        
        Map < Object, Object > emailMap = new Map < Object, Object >();
        Map < Object, Object > email3BlocMap = new Map < Object, Object >();

        Map < Object, Object > fixeMap = new Map < Object, Object >();
        Map < Object, Object > fixe3BlocMap = new Map < Object, Object >();

        Map < Object, Object > mobileMap = new Map < Object, Object >();
        Map < Object, Object > mobile3BlocMap = new Map < Object, Object >();

        Map < Object, Object > canauxMkt = new Map < Object, Object >();
        Map < Object, Object > stopMkt = new Map < Object, Object >();

        emailMap.put('NouvelleAdresseMail1', 'email1@engie.com');
        emailMap.put('NouvelleAdresseMail2', 'email2@engie.com');
        email3BlocMap.put('NouvelleAdresseMail3', 'email3@engie.com');
        emailMap.put('Email3Block', email3BlocMap);
        emailMap.put('principalEmail', 'Adresse Mail 1');
        emailMap.put('RefusEmail', false);

        fixeMap.put('NewTelFixe1', '0101010101');
        fixeMap.put('NewTelFixe2', '0101010102');
        fixe3BlocMap.put('NewTelFixe3', '0101010103');
        fixeMap.put('Fix3Block', fixe3BlocMap);
        fixeMap.put('principalFixe', 'Tel Fixe 1');
        fixeMap.put('RefusTelFixe', false);

        mobileMap.put('NewMobile1', '0601010101');
        mobileMap.put('NewMobile2', '0601010102');
        mobile3BlocMap.put('NewMobile3', '0601010103');
        mobileMap.put('mobile3Block', mobile3BlocMap);
        mobileMap.put('principalMobile', 'Mobile 1');
        mobileMap.put('RefusTelMobile', false);

        elementsMap.put('AdresseEmail', emailMap);
        elementsMap.put('TelFixe', fixeMap);
        elementsMap.put('TelMobile', mobileMap);
        elementsMap.put('AdresseContact', adresseMap);

        adresseMap.put('NoVoie', '104');
        adresseMap.put('Adresse', 'avenue aristide Briand');
        adresseMap.put('ComplementAdresse', '4e etage');
        adresseMap.put('Ville', 'Bagneux');
        adresseMap.put('CodePostal', '92220');
        adresseMap.put('Chez', 'Test Test');

        stopMkt.put('StopPhoning', true);
        stopMkt.put('StopMailing', true);

        canauxMkt.put('CanalPreference', 'Courrier');
        canauxMkt.put('Stop', stopMkt);

        elementsMap.put('ChoixCanal', canauxMkt);

        inputMap.put('ChoixElements', elementsMap);
        inputMap.put('ContextId', aContact.Id);

        Test.startTest();
        
        SM_AP61_PersonneOctopus.invokeMethodLWC('majPersonne',inputMap,outMap);
        //System.assertEquals('OCTOPUS_MAJPersonne_01', outMap.get('majPersonneRet'));

        Test.stopTest();
    } 
    
    @isTest(SeeAllData = false)
    public static void creerPersonneCorrespondance_TEST()
    {        
        SM_OCTOPUS__c orgSettings = new SM_OCTOPUS__c();
        orgSettings.certName__c = 'smilecert';
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
        inputMap.put('refusFixe', true);
        inputMap.put('refusMobile', true);
        inputMap.put('refusEmail', true);
        
        
        Test.startTest();
        
        SM_AP61_PersonneOctopus personneWS = new SM_AP61_PersonneOctopus();
        personneWS.invokeMethod('creerPersonneCorrespondance',inputMap,outMap,null);
        
        String idPersonne = (String) outMap.get('idPersonne');
        System.assertEquals('1', idPersonne);
        
        inputMap = new Map < String, Object >();
        inputMap.put('mail1', '');
        inputMap.put('mail2', '');
        inputMap.put('mail3', '');
        inputMap.put('tel1', '');
        inputMap.put('tel2', '');
        inputMap.put('tel3', '');
        inputMap.put('mobile1', '');
        inputMap.put('mobile2', '');
        inputMap.put('mobile3', '');
        inputMap.put('refusFixe', false);
        inputMap.put('refusMobile', false);
        inputMap.put('refusEmail', false);
        
        personneWS.invokeMethod('creerPersonneCorrespondance',inputMap,outMap,null);
        
        idPersonne = (String) outMap.get('idPersonne');
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
        orgSettings.certName__c = 'smilecert';
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
        System.assertEquals('OK', (String)outputMap.get('MAJProfilMarketing'));
        System.assertEquals('Adresse Mail 3', afterUpdate.Adresse_Mail_Principale__c);
        System.assertEquals('test3@email.com', afterUpdate.EmailPrincipalValueRW__c);
        Test.stopTest();
    }
}