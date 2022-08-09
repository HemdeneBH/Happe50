@isTest 
public class VI_SM040_RedirectionDocusign_Test {

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
        
        // Creation du Parcours
        VI_Parcours__c Parcours = VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
        Parcours.VI_EnveloppeCPV__c='test_Id_EnveloppeCPV';
        Parcours.VI_EnveloppeMandat__c='test_Id_EnveloppeMandat';
        Parcours.VI_Email_CPV__c='test_email_CPV@gmail.com';
        insert Parcours;
    }
    
    @isTest
    public static void redirectURLTest1CPV() {
        
      	VI_Parcours__c parcours = [Select Id,VI_EnveloppeCPV__c, VI_EnveloppeMandat__c, VI_Email_CPV__c From VI_Parcours__c limit 1];
            
        // Creation De l'URL   
        // // Cryptage d'une partie de URL
       	Blob key = Crypto.generateAesKey(128);
        String encodedKeyCPV = EncodingUtil.base64encode(key);
		Blob data = Blob.valueOf('id='+parcours.id+'&Type=CPV');
        Blob encrypted = Crypto.encryptWithManagedIV('AES128', key, data);
        String encodedEncryptedCPV = EncodingUtil.base64encode(encrypted);
        
        // // Creation du DocusignTokens
		VI_DocuSignTokens__c DocuSignTokens = new VI_DocuSignTokens__c();
        DocuSignTokens.Name = 'TimeStampTest';
        DocuSignTokens.VI_Value__c = encodedKeyCPV;
        insert DocuSignTokens;
        
        Test.startTest();
        // Constitution de l'URL de redirection
        PageReference tpageRef = Page.RedirectDocusign;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('encrypted', encodedEncryptedCPV);
        ApexPages.currentPage().getParameters().put('TimeStamp', DocuSignTokens.Name);
        
        VI_SM040_RedirectionDocusign.redirectURL();
        Test.stopTest();
    }
    
    @isTest
    public static void redirectURLTest2Mandat() {
        
      	VI_Parcours__c parcours = [Select Id,VI_EnveloppeCPV__c, VI_EnveloppeMandat__c, VI_Email_CPV__c From VI_Parcours__c limit 1];
            
        // Creation De l'URL   
        // // Cryptage d'une partie de URL
       	Blob key = Crypto.generateAesKey(128);
        String encodedKeyCPV = EncodingUtil.base64encode(key);
		Blob data = Blob.valueOf('id='+parcours.id+'&Type=Mandat');
        Blob encrypted = Crypto.encryptWithManagedIV('AES128', key, data);
        String encodedEncryptedCPV = EncodingUtil.base64encode(encrypted);
        
        // // Creation du DocusignTokens
		VI_DocuSignTokens__c DocuSignTokens = new VI_DocuSignTokens__c();
        DocuSignTokens.Name = 'TimeStampTest';
        DocuSignTokens.VI_Value__c = encodedKeyCPV;
        insert DocuSignTokens;
        
        Test.startTest();
        // Constitution de l'URL de redirection
        PageReference tpageRef = Page.RedirectDocusign;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('encrypted', encodedEncryptedCPV);
        ApexPages.currentPage().getParameters().put('TimeStamp', DocuSignTokens.Name);
        
        VI_SM040_RedirectionDocusign.redirectURL();
        Test.stopTest();
    }
    
    @isTest
    public static void redirectURLTest3WhitoutType() {
        
      	VI_Parcours__c parcours = [Select Id,VI_EnveloppeCPV__c, VI_EnveloppeMandat__c, VI_Email_CPV__c From VI_Parcours__c limit 1];
            
        // Creation De l'URL   
        // // Cryptage d'une partie de URL
       	Blob key = Crypto.generateAesKey(128);
        String encodedKeyCPV = EncodingUtil.base64encode(key);
		Blob data = Blob.valueOf('id='+parcours.id+'&Type=NULL');
        Blob encrypted = Crypto.encryptWithManagedIV('AES128', key, data);
        String encodedEncryptedCPV = EncodingUtil.base64encode(encrypted);
        
        // // Creation du DocusignTokens
		VI_DocuSignTokens__c DocuSignTokens = new VI_DocuSignTokens__c();
        DocuSignTokens.Name = 'TimeStampTest';
        DocuSignTokens.VI_Value__c = encodedKeyCPV;
        insert DocuSignTokens;
        
        Test.startTest();
        // Constitution de l'URL de redirection
        PageReference tpageRef = Page.RedirectDocusign;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('encrypted', encodedEncryptedCPV);
        ApexPages.currentPage().getParameters().put('TimeStamp', DocuSignTokens.Name);
        
        VI_SM040_RedirectionDocusign.redirectURL();
        Test.stopTest();
    }
    
}