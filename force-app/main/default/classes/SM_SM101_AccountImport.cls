/**
 * @author Nourelimane SMOUNI && Ayoub BERRAMDANE
 * @date 25/02/2022
 * @description SM_SM101_AccountImport - Handle creation of account from external source
 */
public inherited sharing class SM_SM101_AccountImport {
    
    /* SyncEventLog__c handling utility */
	public static SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('xdata', 'Account');
    /* Custom Permission to bypass the import of account */
    public static final String PERMISSION_BP_IMPORT_ACCOUNT = 'BP_IMPORT_ACCOUNT';
    /* Launch queueable only if number of records to process is greater */
    public static final Integer MIN_QUEUEABLE_BATCH_SIZE;
    /* Status to return when ok */
    public static final String STATUS_OK = 'OK';
    /* Status to return when ok */
    public static final String STATUS_KO = 'KO';

    static {
        MIN_QUEUEABLE_BATCH_SIZE = (Integer) SM_EM105_ProcessSettings.getProcessSettings('XDATA_IMPORT').get('QueueableThreshold');
    }

    /**
     * @author Nourelimane SMOUNI && Ayoub BERRAMDANE
     * @date 25/02/2022
     * @description ContactInputWrp - Wrapper to map data from xdata import
     */
    public inherited sharing class AccountInputWrp{
        String name;
        String noCompteContrat;
        String idPortefeuilleContrat;
        String idBatiment;
        String idLocal; 
        String lbPortefeuilleContrat; 
        String idFoyer;
        String lbFoyer;
        String dateDebut;
        String dateFin;   
    }

    /**
     * @author Nourelimane SMOUNI && Ayoub BERRAMDANE
     * @date 25/02/2022
     * @description AccountOutputWrp - Wrapper to map response
     */
    public inherited sharing class AccountOutputWrp{
        String jobId;
        String message = 'Unhandled Error';
        String status = STATUS_KO;
    }
     
    /**
     * @author Nourelimane SMOUNI && Ayoub BERRAMDANE
     * @date 28/02/2022
     * @description AsyncImportAccount - Queueable class to implement account import logics
     */
    public inherited sharing class AsyncImportAccount implements System.Queueable{
        /* List of accounts with details represented by key/value pairs */
        List<Map<String,String>> accounts;
        
        /**
         * @param accounts List of accounts with details represented by key/value pairs
         * @description Constructor
         */
        public AsyncImportAccount(List<Map<String,String>> accounts){
            this.accounts = accounts;
        }

        /**
         * @author Nourelimane SMOUNI && Ayoub BERRAMDANE
         * @date 28/02/2022
         * @param context QueueableContext
         * @description process asynchronously the import of account
         * @return N/A
         */
        public void execute(QueueableContext context) {
            SM_SM101_AccountImport.processAccountImport(accounts);
        }
    }

    /**
     * @author Nourelimane SMOUNI && Ayoub BERRAMDANE
     * @date 25/02/2022
     * @param accounts List of accounts with details represented by key/value pairs
     * @description process asynchronously the import of account from external source
     * @return String informations about the processing of the query
     */
    public static String importAccounts(List<Map<String,String>> accounts){
        AccountOutputWrp output = new AccountOutputWrp();

        if (FeatureManagement.checkPermission(PERMISSION_BP_IMPORT_ACCOUNT)){
            output.message = 'Not Processed, Bypass has been set';
            output.status = STATUS_OK;
        } else {
            try{
                AsyncImportAccount importAccount = new AsyncImportAccount(accounts);
                if (accounts.size() > MIN_QUEUEABLE_BATCH_SIZE){
                    output.jobId = System.enqueueJob(importAccount);
                    output.message = 'Processing';
                    output.status = STATUS_OK;
                } else {
                    importAccount.execute(null);
                    output.message = 'Processed';
                    output.status = STATUS_OK;
                }
            } catch(Exception exp){
                output.message = exp.getMessage();
                output.status = STATUS_KO;
            }
        }

        return JSON.serialize(output);
    }

    /**
     * @author Nourelimane SMOUNI && Ayoub BERRAMDANE
     * @date 28/02/2022
     * @param accounts List of accounts with details represented by key/value pairs
     * @description process asynchronously the import of account from external source
     * @return String informations about the processing of the query
     */
    public static void processAccountImport(List<Map<String,String>> accounts){
        /* List of accounts with details represented by accountsWrp */
        List<AccountInputWrp> accountsWrp;
        Map<String, AccountInputWrp> accountsFromWsByNoCompteContrat = new Map<String, AccountInputWrp>();
        Map<String, Account> inDbAccountsByNoCompteContrat = new Map<String,Account>();
        Map<String, Account> newAccountsByNoCompteContrat = new Map<String,Account>();
        Map<String, Account> existingAccountsByNoCompteContrat = new Map<String, Account>();
        Map<String, Account> existingAccountsByNoCompteContratNotFound = new Map<String, Account>();

        //1ST level error handling
        try{
            if (accounts != null && !accounts.isEmpty()){
                accountsWrp = (List<AccountInputWrp>) JSON.deserialize(JSON.serialize(accounts), List<AccountInputWrp>.class);
            }
            
            if (accountsWrp == null || accountsWrp.isEmpty()){
                return;
            }

            for (AccountInputWrp acc : accountsWrp){
                if (String.isNotEmpty(acc.noCompteContrat) && String.isNotEmpty(acc.idLocal)){
                    accountsFromWsByNoCompteContrat.put(acc.noCompteContrat, acc);
                } else if (String.isEmpty(acc.noCompteContrat)){
                    xiu.logImportError('No Business Person',null, JSON.serialize(acc));
                } else if (String.isEmpty(acc.idLocal)){
                    xiu.logImportError('Pas de idLocal correct', null, JSON.serialize(acc));
                }
            }

            if (accountsFromWsByNoCompteContrat.isEmpty()){
                return;
            }
    
            inDbAccountsByNoCompteContrat = SM_EM101_Account.getMapByNoCompteContrat(accountsFromWsByNoCompteContrat.keySet());
        } catch (Exception exp){
            APU000_Logger.log(LoggingLevel.ERROR, 'SM_SM101_AccountImport', 'processAccountImport', exp.getMessage());
            xiu.logImportError('Import Account Error : '+exp.getMessage(),null, JSON.serialize(accounts));
            saveLogs();
            //Do not continue if error detect in this block to avoid inconsistency
            return;
        }

        //Error handling contact by contact in this step
        for (String key : accountsFromWsByNoCompteContrat.keySet()){
            AccountInputWrp accFromWs = accountsFromWsByNoCompteContrat.get(key);

            try {
                Account accInDb = inDbAccountsByNoCompteContrat.get(key);

                if (accInDb == null){
                    Account accTemp = SM_EM101_Account.createTechnicalConsumer2(accFromWs.noCompteContrat,accFromWs.name,accFromWs.idPortefeuilleContrat,accFromWs.idBatiment,accFromWs.idLocal,accFromWs.lbPortefeuilleContrat,accFromWs.idFoyer,accFromWs.lbFoyer,accFromWs.dateDebut,accFromWs.dateFin);
                    newAccountsByNoCompteContrat.put(key, accTemp);
                } else {
                    existingAccountsByNoCompteContrat.put(accFromWs.noCompteContrat, accInDB);
                    fillAccount(accInDb, accFromWs);
                }
             
            }catch (Exception exp){
                APU000_Logger.log(LoggingLevel.ERROR, 'SM_SM101_AccountImport', 'processAccountImport', exp.getMessage());
                xiu.logImportError('Mapping Error', null, JSON.serialize(accountsFromWsByNoCompteContrat.get(key)));
                //remove all related records to avoid post processing
                existingAccountsByNoCompteContrat.remove(accFromWs.noCompteContrat);
                existingAccountsByNoCompteContratNotFound.remove(accFromWs.noCompteContrat);
                newAccountsByNoCompteContrat.remove(key);
            }
        }

        // Create a savepoint to rollback everything
        Savepoint savepoint = null;
        try {

            savepoint = Database.setSavepoint();

            // To insert the Account 
            if (!newAccountsByNoCompteContrat.isEmpty()){
                Database.SaveResult[] acsrs = SM_EM101_Account.insertWithFailureAllowed(newAccountsByNoCompteContrat.values());
            }
            
            // To update the Account 
            if (!existingAccountsByNoCompteContrat.isEmpty()){
                Database.SaveResult[] accsrs = SM_EM101_Account.updateWithFailureAllowed(existingAccountsByNoCompteContrat.values());
            }
        }catch (Exception exp){
            if (savepoint != null){
                //If for any reason there is an exception, we rollback all
                Database.rollback(savepoint);
            }
            APU000_Logger.log(LoggingLevel.ERROR, 'SM_SM101_AccountImport', 'processAccountImport', exp.getMessage());
            xiu.logImportError('Import Account Error : '+exp.getMessage(),null, JSON.serialize(accounts));
        }

        saveLogs();
    }

    /**
     * @author Nourelimane SMOUNI && Ayoub BERRAMDANE
     * @date 28/02/2022
     * @description Commit errors into DB
     * @return N/A
     */
    private static void saveLogs(){
        try {
            xiu.saveLogs();
        } catch(Exception exp){
            //failing to save log must not break the transaction
            //should be done async or through platform events
            return;
        }
    }

    /**
     * @author Nourelimane SMOUNI && Ayoub BERRAMDANE
     * @date 28/02/2022
     * @param Acc account record
     * @param ac account wrapper record from ws
     * @description Map Account Wrapper attributes to Account record
     * @return Account updated account with wrapper info
     */
    private static Account fillAccount(Account acc, AccountInputWrp ac) {  
        acc.Name = String.isEmpty(ac.name)?acc.Name:ac.name;
        acc.No_Compte_contrat__c = String.isEmpty(ac.noCompteContrat)?acc.No_Compte_contrat__c:ac.noCompteContrat;
        acc.ID_Porte_feuille_contrat__c = String.isEmpty(ac.idPortefeuilleContrat)?acc.ID_Porte_feuille_contrat__c:Double.valueOf(ac.idPortefeuilleContrat);
        acc.ID_Batiment__c = String.isEmpty(ac.idBatiment)?acc.ID_Batiment__c:Double.valueOf(ac.idBatiment);
        acc.ID_Local__c = String.isEmpty(ac.idLocal)?acc.ID_Local__c:Double.valueOf(ac.idLocal);
        acc.LB_Portefeuille_contrat__c = String.isEmpty(ac.lbPortefeuilleContrat)?acc.LB_Portefeuille_contrat__c:ac.lbPortefeuilleContrat;
        acc.FoyerId__c = String.isEmpty(ac.idFoyer)?acc.FoyerId__c:Double.valueOf(ac.idFoyer);
        acc.FoyerLabel__c = String.isEmpty(ac.lbFoyer)?acc.FoyerLabel__c:ac.lbFoyer;
        acc.StartDate__c = String.isEmpty(ac.dateDebut)?acc.StartDate__c:Date.valueOf(ac.dateDebut);
        acc.EndDate__c = String.isEmpty(ac.dateFin)?acc.EndDate__c:Date.valueOf(ac.dateFin);

        return acc;
    }
}