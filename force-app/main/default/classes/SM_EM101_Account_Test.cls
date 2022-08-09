@isTest
public class SM_EM101_Account_Test {
    @testSetup static void dataCreation(){
        List<Account> lstAccount = new List<Account>();
        lstAccount.add(new Account(No_Compte_contrat__c = '0001',Name='acc1'));
        lstAccount.add(new Account(No_Compte_contrat__c = '0003',Name='acc2'));
        Database.insert(lstAccount);
    }
    // Test de la methode createTechnicalConsumer  
    @isTest static void testCreateTechnicalConsumer() {
        SM_EM101_Account.createTechnicalConsumer('00001');
        
    }
    // Test de la methode createTechnicalConsumer2 
    @isTest static void testCreateTechnicalConsumer2(){
        SM_EM101_Account.createTechnicalConsumer2( 'name','noCompteContrat','00000','234','333','lbPortefeuilleContrat','124','lbFoyer',String.valueOf(System.today()),String.valueOf(System.today()+1));
    }
    // Test de la methode getMapByNumCompteContrat
    @isTest static void testGetMapByNumCompteContrat() {
        Set<String>numsComptesContrat = new Set<String>();
        for(Integer i = 0 ; i<100 ; i++){
            numsComptesContrat.add('000'+i);
        }
        Map<String, Account> AccountByNoCompteContrat = SM_EM101_Account.getMapByNoCompteContrat(numsComptesContrat);
        system.debug('Accounts by num compte contrat sont : ' + AccountByNoCompteContrat);
    }
    // Test de la methode getByNumCompteContrat
    @isTest static void testGetByNumCompteContrat() {
        Set<String>numsComptesContrat = new Set<String>();
        for(Integer i = 0 ; i<100 ; i++){
            numsComptesContrat.add('000'+i);
        }
        List< Account> AccountByNoCompteContrat = SM_EM101_Account.getByNoCompteContrat(numsComptesContrat);
        system.debug('Accounts by num compte contrat sont : ' + AccountByNoCompteContrat);
    }
    // Test de la methode insertWithFailureAllowed
    @isTest static void testInsert() {
        Set<String>numsComptesContrat = new Set<String>();
        
        for(Integer i = 0 ; i<100 ; i++){
            numsComptesContrat.add('000'+i);}
        List< Account> AccountByNoCompteContrat = SM_EM101_Account.getByNoCompteContrat(numsComptesContrat);
        SM_EM101_Account.insertWithFailureAllowed(AccountByNoCompteContrat);
        
    }
    // Test de la methode updateWithFailureAllowed
    @isTest static void testUpdate() {
        Set<String>numsComptesContrat = new Set<String>();
        
        for(Integer i = 0 ; i<100 ; i++){
            numsComptesContrat.add('000'+i);}
        List< Account> AccountByNoCompteContrat = SM_EM101_Account.getByNoCompteContrat(numsComptesContrat);
        SM_EM101_Account.updateWithFailureAllowed(AccountByNoCompteContrat);
        
    }
    // Test de la methode upsertWithFailureAllowed
    @isTest static void testUpsert() {
        Set<String>numsComptesContrat = new Set<String>();
        for(Integer i = 0 ; i<100 ; i++){
            numsComptesContrat.add('000'+i);}
        List< Account> AccountByNoCompteContrat = SM_EM101_Account.getByNoCompteContrat(numsComptesContrat);
        SM_EM101_Account.upsertWithFailureAllowed(AccountByNoCompteContrat,Account.Fields.No_Compte_contrat__c);
        
    }
}