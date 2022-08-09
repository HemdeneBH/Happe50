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
    
}