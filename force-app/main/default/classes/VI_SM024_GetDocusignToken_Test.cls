/*
*@Author: Paul Ghoussoub
*@Description: VI_SM024_GetDocusignToken
*@CreatedDate: 2/12/2020
*@LastModified: 29/12/2021
*/

@isTest 
public class VI_SM024_GetDocusignToken_Test {
    @testSetup 
    static void testSetup(){ 
        MP_Xdata_credentials__c client_id = new MP_Xdata_credentials__c();
        client_id.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        client_id.Name = 'VI_client_id';
        insert client_id;
        
        MP_Xdata_credentials__c client_secret = new MP_Xdata_credentials__c();
        client_secret.Value__c = 'fa1a7c0c-8420-447e-bfd8-b54303b84794';
        client_secret.Name = 'VI_client_secret';
        insert client_secret;
        
        MP_Xdata_credentials__c VI_api_key_digital_INT = new MP_Xdata_credentials__c();
        VI_api_key_digital_INT.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        VI_api_key_digital_INT.Name = 'VI_api_key_digital_INT';
        insert VI_api_key_digital_INT;
        
        MP_Xdata_credentials__c VI_digital_id_client = new MP_Xdata_credentials__c();
        VI_digital_id_client.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        VI_digital_id_client.Name = 'VI_api_key_INT';
        insert VI_digital_id_client;
        
        MP_Xdata_credentials__c VI_digital_secret_client = new MP_Xdata_credentials__c();
        VI_digital_secret_client.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        VI_digital_secret_client.Name = 'VI_digital_secret_client';
        insert VI_digital_secret_client;
        
        MP_Xdata_credentials__c VI_scope = new MP_Xdata_credentials__c();
        VI_scope.Value__c = 'apiset.read';
        VI_scope.Name = 'VI_scope';
        insert VI_scope;
        
        MP_Xdata_credentials__c VI_user_tranquility = new MP_Xdata_credentials__c();
        VI_user_tranquility.Value__c = '4bf81dd4-b8ec-4c4b-9c84-8e009d8a2b35';
        VI_user_tranquility.Name = 'VI_user_tranquility';
        insert VI_user_tranquility;
        
        MP_Xdata_credentials__c VI_password_tranquility = new MP_Xdata_credentials__c();
        VI_password_tranquility.Value__c = '868e3fed-b555-4e42-9430-5bc93755ca51';
        VI_password_tranquility.Name = 'VI_password_tranquility';
        insert VI_password_tranquility;
    }
   
    @isTest
    static void testGetToken(){
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestGetDocusignToken');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        String token=VI_SM024_GetDocusignToken.getAccessToken('local.VIToken');
        system.assertEquals('test', token);
        Test.stopTest();
    }
    
   @isTest
    static void testCreateEnvelope(){
        Account acct = new Account(Name='TEST_ACCT', VI_Type_Enseigne__c='INDIRECTE', VI_TypeParcours__c='PURE PLAYERS');
        insert acct;
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;     
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        Contact c=new Contact(LastName='test',Salutation='MR',FirstName='test',MailingPostalCode='testt',Mailingcity='test',Mailingcountry='test');
        Id contactrecordTypeId = Contact.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId();
        c.recordTypeId=contactrecordTypeId;
        insert c;
        date d=system.today();
       // VI_Parcours__c p=new VI_Parcours__c(VI_Contact__c=c.id,VI_Email_CPV__c='test@test.com',VI_OffreChoisieGazPanierClient__c='GBUKF2',VI_InfosCompl_DateContratEffectif__c=d,
       //                                     VI_OffreChoisieElecPanierClient__c='EBUKF3V100',VI_ChoixParcours__c='EM'); 
         VI_Parcours__c p=new VI_Parcours__c(VI_Contact__c=c.id,VI_Email_CPV__c='test@test.com',VI_ChoixMoyenPaiement__c = 'Autre',VI_OffreChoisieGazPanierClient__c='GBUKF2',VI_InfosCompl_DateContratEffectif__c=d
                                             , VI_TypeParcours__c='PURE PLAYERS',
                                            VI_OffreChoisieElecPanierClient__c='EBUKF3V100',VI_ChoixParcours__c='EM',VI_IDReferenceClient__c='test',VI_ID_Mandat__c='test',VI_Id_coordonnees_bancaires__c='0202000001-01'); 
        
        insert p;
        Test.startTest();
        List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> listcouple=new List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element>();
        VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element element=new VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element();
        listcouple.add(element);
        VI_SM024_GetDocusignToken.retourEnvoiDocument retourEnvoi=  VI_SM024_GetDocusignToken.envoyerDocumentsfromLWC(p,null,listcouple,'local.VIDocusignToken');
        //system.assert(retourEnvoi.parcours.VI_EmailEnvoye__c);
        //system.assert(retourEnvoi.parcours.VI_Date_envoi_email__c!=null);
        Test.stopTest();
    }
    
    @isTest
    static void testCreateEnvelope3(){
        date d=system.today();
        Account acct = new Account(Name='TEST_ACCT',VI_Type_Enseigne__c='INDIRECTE', VI_TypeParcours__c='PURE PLAYERS');
        insert acct;
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;     
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        Contact c=new Contact(LastName='test',Salutation='MR',FirstName='test',MailingPostalCode='testt',Mailingcity='test',Mailingcountry='test');
        Id contactrecordTypeId = Contact.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId();
        c.recordTypeId=contactrecordTypeId;
        insert c;
        VI_Parcours__c p=new VI_Parcours__c(VI_Contact__c=c.id,VI_Email_CPV__c='test@test.com',VI_ChoixMoyenPaiement__c = 'Autre', VI_IBANEnSelfCare__c= true,VI_OffreChoisieGazPanierClient__c='GBUKF2',VI_InfosCompl_DateContratEffectif__c=d
                                            , VI_TypeParcours__c='PURE PLAYERS',
                                            VI_OffreChoisieElecPanierClient__c='EBUKF3V100',VI_IDReferenceClient__c='test',VI_ID_Mandat__c='test',VI_Id_coordonnees_bancaires__c='0202000001-01'); 
        insert p;
        p.VI_ChoixParcours__c='CHF';      
        update p;
        Test.startTest(); 
        List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> listcouple=new List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element>();
        VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element element=new VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element();
        listcouple.add(element);
        VI_SM024_GetDocusignToken.retourEnvoiDocument retourEnvoi = VI_SM024_GetDocusignToken.envoyerDocumentsfromLWC(p,null,listcouple,'local.VIDocusignToken');
        //system.assert(retourEnvoi.parcours.VI_EmailEnvoye__c);
        //system.assert(retourEnvoi.parcours.VI_Date_envoi_email__c!=null);
        Test.stopTest();
        
    }
    
    @isTest
    static void testCreateEnvelope2(){
        date d=system.today();
        Account acct = new Account(Name='TEST_ACCT',VI_Type_Enseigne__c='INDIRECTE', VI_TypeParcours__c='PURE PLAYERS');
        insert acct;
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;     
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        Contact c=new Contact(LastName='test',Salutation='MR',FirstName='test',MailingPostalCode='testt',Mailingcity='test',Mailingcountry='test');
        Id contactrecordTypeId = Contact.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId();
        c.recordTypeId=contactrecordTypeId;
        insert c;
  
        VI_Parcours__c p=new VI_Parcours__c(VI_Contact__c=c.id,VI_Email_CPV__c='test@test.com', VI_OffreChoisieGazPanierClient__c='GBUKF2',VI_InfosCompl_DateContratEffectif__c=d
                                            , VI_TypeParcours__c='PURE PLAYERS',
                                            VI_OffreChoisieElecPanierClient__c='EBUKF3V100',VI_IDReferenceClient__c='test',VI_ID_Mandat__c='test',VI_Id_coordonnees_bancaires__c='0202000001-01'); 
        
        insert p;
        p.VI_ChoixParcours__c='EM';      
        update p;
        Test.startTest(); 
        List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> listcouple=new List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element>();
        VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element element=new VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element();
        listcouple.add(element);
        VI_SM024_GetDocusignToken.retourEnvoiDocument retourEnvoi = VI_SM024_GetDocusignToken.envoyerDocumentsfromLWC(p,null,listcouple,'local.VIDocusignToken');
        //system.assert(retourEnvoi.parcours.VI_EmailEnvoye__c);
        //system.assert(retourEnvoi.parcours.VI_Date_envoi_email__c!=null);
        Test.stopTest();
        
    }
    @isTest
    static void testCreateEnvelope4(){
        date d=system.today();
        Account acct = new Account(Name='TEST_ACCT',VI_Type_Enseigne__c='INDIRECTE', VI_TypeParcours__c='PURE PLAYERS');
        insert acct;
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;     
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        Contact c=new Contact(LastName='test',Salutation='MR',FirstName='test',MailingPostalCode='testt',Mailingcity='test',Mailingcountry='test');
        Id contactrecordTypeId = Contact.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId();
        c.recordTypeId=contactrecordTypeId;
        insert c;
        VI_Parcours__c p=new VI_Parcours__c(VI_Contact__c=c.id,VI_Email_CPV__c='test@test.com',VI_OffreChoisieGazPanierClient__c='GBUKF2',VI_InfosCompl_DateContratEffectif__c=d,
                                        //
                                            VI_TypeParcours__c='PURE PLAYERS', VI_OffreChoisieElecPanierClient__c='EBUKF3V100' ); 
        
        insert p;
        p.VI_ChoixParcours__c='EM';      
        update p;
        Test.startTest(); 
        List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> listcouple=new List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element>();
        VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element element=new VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element();
        listcouple.add(element);
        VI_SM024_GetDocusignToken.retourEnvoiDocument retourEnvoi = VI_SM024_GetDocusignToken.envoyerDocumentsfromLWC(p,null,listcouple,'local.VIDocusignToken');
        system.assertEquals(retourEnvoi.retourMessage,'Erreur lors de la génération du CPV');
        Test.stopTest();
        
    }
}