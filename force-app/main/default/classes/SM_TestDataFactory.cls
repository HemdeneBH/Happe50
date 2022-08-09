/**
 * @description       : 
 * @author            : Mohamed Aamer
 * @group             : 
 * @last modified on  : 04-10-2022
 * @last modified by  : Mohamed Aamer
**/
@isTest
public class SM_TestDataFactory {
    public static Account createAccount(String accountName){
        Account account = new Account();
        account.Name = accountName;
        return account;
    }
    public static Contact createContact(String lastName, String accountId){
        Contact contact = new Contact();
        contact.AccountId = accountId;
        contact.LastName = lastName;
        return contact;
    }
    public static Case createCase(String subject, String accountId){
        Case newCase = new Case();
        newCase.Subject = subject;
        newCase.AccountId = accountId;
        return newCase;
    }
    public static EmailMessage createEmailMessage(String accountId, String caseRecordId, List<Id> listContactIds, String toAddress, String statusValue, String fromAddress, String textBody, String emailSubject, String htmlBody){
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.toIds = listContactIds;
        emailMessage.toAddress = toAddress;
        emailMessage.status = statusValue;
        emailMessage.FromAddress = fromAddress;
        emailMessage.TextBody = textBody;
        emailMessage.Subject = emailSubject;
        emailMessage.RelatedToId = accountId;
        emailMessage.htmlBody = htmlBody;
        //emailMessage.Case__c = caseRecordId;
        return emailMessage;
    }
    public static Product2 createProduct(String productName, String productCode, String productFamily){
        Product2 product = new Product2();
        product.Name = productName;
        product.ProductCode = productCode;
        product.IsActive = true;
        product.Family = productFamily;
        return product;
    }
    public static Pricebook2 createStandardPricebook (){
        Pricebook2 pricebook = new Pricebook2();
        pricebook.Id = Test.getStandardPricebookId();
        pricebook.isActive = true;
        return pricebook;
    }
    public static PricebookEntry createPriceBookEntry(String pricebookId, String productId, Integer unitPrice){
        PricebookEntry pricebookEntry = new PricebookEntry();
        pricebookEntry.Pricebook2Id = pricebookId;
        pricebookEntry.Product2Id = productId;
        pricebookEntry.IsActive = true;
        pricebookEntry.UnitPrice = unitPrice;
        return pricebookEntry;
    }
    public static APIMonitoring__c createAPIMonitoring(String body, String source, String destination, String url, String status, String statusCode){
        APIMonitoring__c apiMonitoring = new APIMonitoring__c();
        apiMonitoring.RequestBody__c = body;
        apiMonitoring.Source__c = source;
        apiMonitoring.Destination__c = destination;
        apiMonitoring.URL__c = url;
        apiMonitoring.Status__c = status;
        apiMonitoring.StatusCode__c = statusCode;
        return apiMonitoring;
    }
    
    public static User createUser(String alias, String email, String lastName, String username, String profileName){
        Profile profile = [SELECT Id 
                           FROM Profile 
                           WHERE Name = :profileName]; 
        User user = new User();
        user.Alias = alias;
        user.Email = email; 
        user.EmailEncodingKey = 'UTF-8';
        user.LastName = lastName; 
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US'; 
        user.ProfileId = profile.Id;
        user.TimeZoneSidKey = 'America/Los_Angeles'; 
        user.UserName = username; 
        return user;
    }
 
    
    // classe utiliser pour User prov --> classe SM_SM06_JitHandler_TEST
     public static Map<string,String> createMapDataUser(String firstName, String lastName, String email,String uid,String Title,String CompanyName,
     String AboutMe,String Street,String State,String City,String Zip,String Country,String department,String groups){
         Map<string,String> dataUser=  new Map<String, String>
        {   'firstName'=>firstName, 
            'lastName'=>lastName,
            'email'=>email,
            'uid'=> uid,
            'Title'=>Title,
            'CompanyName'=>CompanyName,
            'AboutMe'=>AboutMe,
            'Street'=>Street,
            'State'=>State,
            'City'=>City,
            'Zip'=>Zip,
            'Country'=>Country,
            'department'=> department,
            'groups'=> groups
         }; 
        return dataUser;
    }

    /*Cette méthode ne crée pas de Sobject*/
    /* Cette méthode initie un jeu de données pour le passer en parametre à la méthode de la création d'espace client */
    public static Map<String,Object> createAccountData(String prenom, String nom, String civilite, String email, String numeroBP){
        return new Map<String,Object>{
            'prenom' => prenom,
                'nom' => nom,
                'civilite' => civilite,
                'email' => email,
                'numeroBP' => numeroBP
                };
                    } 
   public static Donnees_Vente__c createDonneeVente (String CaseId,String Commune, String CodePack, String numeroVoie, String libelleVoie, String codePostal){
        Donnees_Vente__c dv = new Donnees_Vente__c();
       dv.caseId__c = CaseId;
        dv.commune__c = Commune;
        dv.Code_pack__c = CodePack;
        dv.Numero_de_voie__c = numeroVoie;
        dv.Libelle_voie__c = libelleVoie;
        dv.Code_postale__c =  codePostal;
        return dv;
    }
    
    public static Prestation_Distributeur__c createOPSData(String contactId, String caseId, Date datePrestation, 	
                                                           String noAffaire, String statut, String recordTypeId) {	
        Prestation_Distributeur__c pd = new Prestation_Distributeur__c();	
        pd.Contact__c=contactId;	
        pd.Case__c=caseId;	
        pd.Date_de_prestation__c=datePrestation;	
        pd.Numero_affaire_distributeur__c=noAffaire;	
        pd.Statut__c=statut;	
        pd.RecordTypeId=recordTypeId;	
        return pd;	
    }
    
        public static MP_Xdata_credentials__c createXdataCredentials(String value, String name) {	
        MP_Xdata_credentials__c xdcr = new MP_Xdata_credentials__c();
        xdcr.Value__c = value;
        xdcr.Name = name;
        return xdcr;	
    }

    public static Omnichannel_Rule__c createOmniChannelRule(String Objet, String Champ, String Valeur, 	
                                                           String Competence, Date dateDebut, Date dateFin) {	
        Omnichannel_Rule__c omniRule = new Omnichannel_Rule__c();	
        omniRule.Objet__c=Objet;	
        omniRule.Champ__c=Champ;	
        omniRule.Valeur__c=Valeur;	
        omniRule.Competence__c=Competence;	
        omniRule.Date_de_debut__c=dateDebut;	
        omniRule.Date_de_fin__c=dateFin;	
        return omniRule;	
    }

    public static UserRole createUserRole(String name){
        UserRole userR = new UserRole();
        userR.Name = name;
        return userR;
    }
}