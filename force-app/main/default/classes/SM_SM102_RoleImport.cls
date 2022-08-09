/**
* @author Rajaa MOUHIB
* @date 03/03/2022
* @description SM_SM102_RoleImport - Handle creation of AccountContactRelation from external source
*/
public inherited sharing class SM_SM102_RoleImport {
    
    /* SyncEventLog__c handling utility */
    public static SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('xdata', 'AccountContactRelation');
    /* Custom Permission to bypass the import of role */
    public static final String PERMISSION_BP_IMPORT_ROLE = 'BP_IMPORT_ROLE';
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
     * @author  Rajaa MOUHIB
     * @date 04/03/2022
     * @description RoleInputWrp - Wrapper to map data from xdata import
     */
    public inherited sharing class RoleInputWrp{
        String accountNo;
        String contactNo;
        String roles;
        String fl_obsolete;
        String dt_fin;
        String dt_debut;    
    }
    
    /**
     * @author  Rajaa Mouhib
     * @date 04/03/2022
     * @description RoleOutputWrp - Wrapper to map response
     */
    public inherited sharing class RoleOutputWrp{
        String jobId;
        String message = 'Unhandled Error';
        String status = STATUS_KO;
    }
    
    /**
     * @author  Rajaa MOUHIB
     * @date 04/03/2022
     * @param accountContactRelations List of accountContactRelations with details represented by key/value pairs
     * @description process asynchronously the import of accountContactRelation from external source
     * @return String informations about the processing of the query
     */
    public static String importRoles(List<Map<String,String>> accountContactRelations){
        RoleOutputWrp output = new  RoleOutputWrp();
        
        if (FeatureManagement.checkPermission(PERMISSION_BP_IMPORT_ROLE)){
            output.message = 'Not Processed, Bypass has been set';
            output.status = STATUS_OK;
        } else {
            try{
                AsyncImportRole importRole = new AsyncImportRole(accountContactRelations);
                
                if (accountContactRelations.size() > MIN_QUEUEABLE_BATCH_SIZE){
                    output.jobId = System.enqueueJob(importRole);
                    output.message = 'Processing';
                    output.status = STATUS_OK;
                } else {
                    importRole.execute(null);
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
     * @author  Rajaa MOUHIB
     * @date 04/03/2022
     * @description AsyncImportRole - Queueable class to implement accountContactRelation import logics
     */
    public inherited sharing class AsyncImportRole implements System.Queueable{
        /* List of AccountContactRelations with details represented by key/value pairs */
        List<Map<String,String>> accountContactRelations;
        
        /**
         * @param accountContactRelations List of accountContactRelations with details represented by key/value pairs
         * @description Constructor
         */
        public AsyncImportRole(List<Map<String,String>> accountContactRelations){
            this.accountContactRelations = accountContactRelations;
        }
        
        /**
         * @author  Rajaa MOUHIB
         * @date 04/03/2022
         * @param context QueueableContext
         * @description process asynchronously the import of accountContactRelation
         * @return N/A
         */
        public void execute(QueueableContext context) {
            SM_SM102_RoleImport.processRoleImport(accountContactRelations);
        }
    }
    
    /**
     * @author  Rajaa MOUHIB & Ayoub BERRAMDANE
     * @date 04/03/2022
     * @param accountContactRelations List of  accountContactRelations with details represented by key/value pairs
     * @descriptio n process the import of accountContactRelations
     * @return N/A
     */
    public static void processRoleImport(List<Map<String,String>> accountContactRelations){

        /* List of accountContactRelations with details represented by RoleInputWrp */
        List<RoleInputWrp> roleInputWrp;
        Map<String, RoleInputWrp> rolesFromWsById = new Map<String, RoleInputWrp>();
        Set<String> NoCompteContratFromWs = new Set<String>();
        Set<String> IdBuisnessPartenerFromWs = new Set<String>();
        Map<String, Account> newAccountByCtRefClient = new Map<String, Account> ();
        Map<String, Contact> newContactByIdBuisnessPartener = new Map<String, Contact> ();
        Map<String, AccountContactRelation>   newDbRolesByRoleId =new Map<String, AccountContactRelation>();
        Map<String, Contact> inDbContactsByIdBuisnessPartener = new Map<String,Contact>();
        Map<String, Account> inDbAccountsByRefClient = new Map<String,Account>();
        Map<String, AccountContactRelation>  inDbRolesById = new Map<String, AccountContactRelation>();
        Map<String, Account>  existingAccountsByRefClient = new Map<String, Account>();
        Map<String, Contact>  existingContactsByIdBuisnessPartener = new Map<String, Contact>();
        
        //1ST level error handling for account
        try{
            if (accountContactRelations != null && !accountContactRelations.isEmpty()){
                roleInputWrp = (List<RoleInputWrp>) JSON.deserialize(JSON.serialize(accountContactRelations), List<RoleInputWrp>.class);
            }
            
            if (roleInputWrp == null || roleInputWrp.isEmpty()){
                return;
            }
            
            // Lister les accounts et contacts existants et non existants
            for(RoleInputWrp rl  : roleInputWrp){
                if (String.isNotEmpty(rl.accountNo ) && String.isNotEmpty(rl.contactNo) && String.isNotEmpty(rl.roles)){
                    String rolek = 'C_' + rl.accountNo + '_B_' + rl.contactNo;
                    rolesFromWsById.put(rolek, rl);
                    NoCompteContratFromWs.add(rl.accountNo);
                    IdBuisnessPartenerFromWs.add(rl.contactNo);
                } else {
                    xiu.logImportError('Pas accountId ou contactId ou roleId', null, JSON.serialize(rl));
                }
            }

 			inDbContactsByIdBuisnessPartener = SM_EM100_Contact.getByIdentifiantBusinessPartners(IdBuisnessPartenerFromWs);
            inDbAccountsByRefClient = SM_EM101_Account.getMapByNoCompteContrat(NoCompteContratFromWs);
        } catch (Exception exp){
            APU000_Logger.log(LoggingLevel.ERROR, 'SM_SM102_RoleImport', 'processRoleImport', exp.getMessage());
            xiu.logImportError('Import Role Error : '+exp.getMessage(), null, JSON.serialize(accountContactRelations));
            saveLogs();
            //Do not continue if error detect in this block to avoid inconsistency
            return;
        }
        
        for (String key : rolesFromWsById.keySet()){
            
            RoleInputWrp rlFromWs = rolesFromWsById.get(key);
            
            try {

                Boolean isActive = true;
                Date startDate = null;
                Date endDate = null;
                
                try{
                    if (String.isNotEmpty(rlFromWs.fl_obsolete)){
                    	isActive = Boolean.valueOf(rlFromWs.fl_obsolete);
                    }
                    
                    if (String.isNotEmpty(rlFromWs.dt_fin)){
                        endDate = Date.valueOf(rlFromWs.dt_fin);
                    }
                    
                    if (String.isNotEmpty(rlFromWs.dt_debut)){
                        startDate = Date.valueOf(rlFromWs.dt_debut);
                    }
                } catch (Exception exp){
                    APU000_Logger.log(LoggingLevel.WARN, 'SM_SM102_RoleImport', 'processRoleImport', exp.getMessage());
                }
                    
                AccountContactRelation rlInDb = SM_EM102_AccountContactRelation.createRole(rlFromWs.accountNo,rlFromWs.contactNo,key,rlFromWs.roles,isActive,endDate,startDate);
               
                newDbRolesByRoleId.put(key, rlInDb);
                Account accountInDB = inDbAccountsByRefClient.get(rlFromWs.accountNo);
                Contact contactInDB = inDbContactsByIdBuisnessPartener.get(rlFromWs.contactNo);
                
                if (accountInDB == null){
                    Account accTemp = SM_EM101_Account.createTechnicalConsumer(rlFromWs.accountNo);
                    newAccountByCtRefClient.put(key, accTemp);
                }  
                    
                if (contactInDB == null){
                    Contact ctTemp = SM_EM100_Contact.createContactSmile(rlFromWs.contactNo);
                    ctTemp.Account = new Account(No_Compte_contrat__c = rlFromWs.accountNo);
                    newContactByIdBuisnessPartener.put(key, ctTemp);
                } 
                
            } catch (Exception exp){
                APU000_Logger.log(LoggingLevel.ERROR, 'SM_SM102_RoleImport', 'processRoleImport', exp.getMessage());
                xiu.logImportError('Mapping Error', null, JSON.serialize(rolesFromWsById.get(key)));
                //remove all related records to avoid post processing
            }
        }
        
        // Create a savepoint to rollback everything
        Savepoint savepoint = null;
        
        try { 

            savepoint = Database.setSavepoint();
            if (!newAccountByCtRefClient.isEmpty()){  
                Database.UpsertResult[] acsrs = SM_EM101_Account.upsertWithFailureAllowed(newAccountByCtRefClient.values(), SM_EM101_Account.FIELD_EXTID_NO_COMPTE_CONTRAT);
            }

            if (!newContactByIdBuisnessPartener.isEmpty()){
                Database.UpsertResult[] coList = SM_EM100_Contact.upsertWithFailureAllowed(newContactByIdBuisnessPartener.values(), SM_EM100_Contact.FIELD_EXTID_IDENTIFIANT_BUSINESS_PARTENER);    
            }

            if (!newDbRolesByRoleId.isEmpty()){
                Database.UpsertResult[] rlList = SM_EM102_AccountContactRelation.upsertWithFailureAllowed(newDbRolesByRoleId.values(), SM_EM102_AccountContactRelation.FIELD_EXTID_IDENTIFIANT_ROLE);
            }
             
        } catch (Exception exp){
            if (savepoint != null){
                //If for any reason there is an exception, we rollback all
                Database.rollback(savepoint);
            }
            APU000_Logger.log(LoggingLevel.ERROR, 'SM_SM102_RoleImport', 'processRoleImport', exp.getMessage());
            xiu.logImportError('Import AccountContactRelation Error : '+exp.getMessage(), null, JSON.serialize(accountContactRelations));
        }

        saveLogs();
    }
    
    /**
     * @author Rajaa MOUHIB & Ayoub BERRAMDANE
     * @date 04/03/2022
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
}