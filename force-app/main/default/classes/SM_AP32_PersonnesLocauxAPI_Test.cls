@isTest
public class SM_AP32_PersonnesLocauxAPI_Test {
    
    @testSetup static void setup() {
        SM_AP08_TestLib.insertCS_GenericEndpoints();
        SM_AP08_TestLib.insertCS_XDATACredentials(); 
    }
    
    
    @isTest
    public static void testCallPersonnesLocaux(){
        Test.startTest();
        
        /*      



Contact testContact = [SELECT Id,Identifiant_Buisness_Partener__c,ID_Tiers_Unifie__c,ID_Tiers__c FROM Contact where LastName = : 'user'];
system.debug(testContact);
*/
        
        Account acc = new Account(ID_Local__c =4543,ID_Porte_feuille_contrat__c=432432, No_Compte_contrat__c='5435',Name='test user');
        insert acc ;
        
        Contact contactNew = new Contact(AccountId=acc.Id,Identifiant_Buisness_Partener__c='432432',LastName='user') ;
        insert contactNew ;
        
        contactNew.AccountId = acc.Id;
        update contactNew;
        
        Map < String, Object > input = new Map < String, Object > ();
        Map < String, Object > output = new Map < String, Object > ();
        input.put('Id', contactNew.Id);
        List<Object> locaux = new List <Object>();
        Map <String,Object> inputLocal = new Map< String, Object >();
        
        
        SM_AP32_PersonnesLocauxAPI service = new SM_AP32_PersonnesLocauxAPI();
        service.invokeMethod('callPersonnesLocaux', input, output, null);
        
        Map<String,Object> result = new Map < String, Object > ();                           
        
        result.put('id', 25972);
        result.put('idBatiment',19746);
        result.put('idPersonne"', 37442);
        result.put('idAdresse', 198036);
        result.put('idAdresseL2', 502669);
        result.put('codePostal', '78000');
        result.put('libelleVoie','AVENUE DE PARIS');
        result.put('numeroVoie','1985');
        result.put('codeINSEE','78646');
        result.put('ville','VERSAILLES');
        result.put('numeroLocal','0713909216');
        result.put('complementAdresse','MODIFICATION D#UN RDV DE MES GAZ');
        
        inputLocal.put('AccountId',acc.Id);
        inputLocal.put('ID_Porte_feuille_contrat',acc.ID_Porte_feuille_contrat__c);
        inputLocal.put('No_Compte_contrat',acc.No_Compte_contrat__c);
        inputLocal.put('idContact',contactNew.Id);
        locaux.add(inputLocal);
        
        
        SM_AP32_PersonnesLocauxAPI.transformDataToCard(locaux);
        
        List<Object> listLocaux = new List<Object>();
        Map<String,Object>mapLocaux = new Map<String, Object>();
        
        mapLocaux.put('contactIdBP', '123'); 
        mapLocaux.put('BuildingNumber', '32');
        mapLocaux.put('StreetAddress', 'test libellevoie');
        mapLocaux.put('AdditionalAddress', 'test complement');
        mapLocaux.put('PostalCode', '34321');
        mapLocaux.put('City', 'test ville');
        mapLocaux.put('id',4543);
        
        listLocaux.add(mapLocaux);    
        SM_AP32_PersonnesLocauxAPI.LocalModel locauxModel = new  SM_AP32_PersonnesLocauxAPI.LocalModel('543543','5435','432432','123','54325','4543','32','test libellevoie','test complement','34321','test ville') ;
        
        
        Test.stopTest();	
    }
}