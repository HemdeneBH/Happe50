/*
*@Author: Amal Chreiteh
*@Description: Classe de test de la classe VI_ParcoursPPMPaiement_Controller
*@CreatedDate: 23/03/2021
*@LastModified: 23/03/2021
*/


@isTest
public class VI_parcoursPPMPaiement_Test {
    
    //Teste la méthode getCoobClient
    @isTest static void getCoob() {
        VI_parcours__c parcours = new VI_parcours__c();
        parcours.VI_IDReferenceClient__c = '202000001';
        insert parcours;
        test.startTest();
        VI_ParcoursPPMPaiement_Controller.IbanClientWrapper coobs = VI_ParcoursPPMPaiement_Controller.getCoobClient(parcours);
        if (coobs.coordonnees.size ()> 0){
            VI_SM027_CoordonneesBancaires.Coordonnees coord = coobs.coordonnees[0];
            System.assertEquals('FR7613335003010497764704742' ,coord.IbanNumber);
        } 
        test.stopTest();
    }
    
    //Teste la méthode createCoobClient
    @isTest static void createCoob() {
        VI_parcours__c parcours = new VI_parcours__c();
        parcours.VI_IDReferenceClient__c = '300014091';
        parcours.VI_IBANMoyendePaiement__c = 'FR1930002005680000876440G50';
        parcours.VI_NomTitulaireMoyendePaiement__c = 'IS Test';
        insert parcours;
        test.startTest();
        VI_SM027_CoordonneesBancaires.Coordonnees coobs = VI_ParcoursPPMPaiement_Controller.createCoobClient(parcours);
        test.stopTest();
        System.assertEquals('FR1930002005680000876440G50' ,coobs.idCoordonneeBancaire);
        
    }
    
    //Teste la méthode createAccount pour un client ayant un compte
    @isTest static void createAccount() {
        VI_parcours__c parcours = new VI_parcours__c();
        parcours.VI_IDReferenceClient__c = '202000001';
        parcours.VI_Id_coordonnees_bancaires__c = '0202000001-01';
        String idCompteContrat;
        insert parcours;
        test.startTest();
        String responseCreateAccount = VI_ParcoursPPMPaiement_Controller.createAccount(parcours, idCompteContrat);
        System.assertEquals('000516694472' ,responseCreateAccount);
        idCompteContrat = '000516694472';
        responseCreateAccount = VI_ParcoursPPMPaiement_Controller.createAccount(parcours, idCompteContrat);
        System.assertEquals('000516694472' ,responseCreateAccount);
        test.stopTest();
        
    }
    
    //Teste la méthode createAccountSF
    @isTest static void createAccountSF() {
        
        Account account = new Account();
        account.Name = 'ACC_Technique';
        insert account; 
        
        Contact contact = new Contact();
        contact.LastName = 'UZUMAKI';
        contact.FirstName = 'Naruto';
        contact.AccountId = account.Id;
        insert contact;
        
        VI_parcours__c parcours = new VI_parcours__c();
        parcours.VI_Contact__c = contact.Id;
        parcours.VI_idCompteClient__c = '202000001';
        String idCompteContrat = '0202000001';
        insert parcours;
        VI_ParcoursPPMPaiement_Controller.chooseIBANexistant(parcours);
        
        String responseCreateAccount = VI_ParcoursPPMPaiement_Controller.createAccountSF(parcours, idCompteContrat, contact);
        List<AccountContactRelation> acR=[Select id from AccountContactRelation];
        system.debug('responseCreateAccount '+responseCreateAccount);
        System.assert(acR.size()>0);
        
    }
    
    
    //Teste la méthode createCoobClientLWC
    @isTest static void createCoobClientLWC() {
        
        Account account = new Account();
        account.Name = 'ACC_Technique';
        insert account; 
        
        Contact contact = new Contact();
        contact.LastName = 'UZUMAKI';
        contact.FirstName = 'Naruto';
        contact.AccountId = account.Id;
        insert contact;     
        
        VI_parcours__c parcours = new VI_parcours__c();
        //parcours.VI_Contact__c = '0031q00000ay3zpAAA';
        parcours.VI_IDReferenceClient__c = '300014091';
        parcours.VI_IBANMoyendePaiement__c = 'FR1930002005680000876440G50';
        parcours.VI_NomTitulaireMoyendePaiement__c = 'IS Test';
        parcours.VI_Contact__c = contact.Id;
        String idCompteContrat = '0202000001';
        insert parcours;
        test.startTest();
        VI_ParcoursPPMPaiement_Controller.saisieIbanWrapper responseCreateCoobClientLWC = VI_ParcoursPPMPaiement_Controller.createCoobClientLWC(parcours);
        system.debug('responseCreateCoobClientLWC'+ responseCreateCoobClientLWC);
        test.stopTest();
        //System.assertEquals('0202000001-001' ,responseCreateCoobClientLWC.ibanClientWrapper.coordonnees[0].idCoordonneeBancaire);
        
    }
}