/**
 * @author Sutharsan Pushparajah
 * @date 09/11/2021
 * @description SM_EM101_Account - Entity to manage Account SObject
 */
public inherited sharing class SM_EM101_Account {
    /* Technical account name */
    public static final String TECHNICAL_NAME = 'AC_TECHNIQUE';
    /* External Id field No_Compte_contrat__c */
    public static final Schema.SObjectField FIELD_EXTID_NO_COMPTE_CONTRAT = Account.Fields.No_Compte_contrat__c;
    /* Consumer RecordType Id */
	public static final Id RT_ID_CONSUMER = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Consumer').getRecordTypeId();
    /* Instance of the Account datamanager to access SOQL & DML operations */
    public static ITF001_DataManager datamanager = new DM001_SObjectInstance(SObjectType.Account.Name, 'SM_EM101_Account');
   
    /**
     * @author Sutharsan Pushparajah
     * @date 09/11/2021
     * @param numCompteContrat Account Contract Number to store in No_Compte_contrat__c
     * @description Create a technical account
     * @return Account instance of account for technical consumer
     */
    public static Account createTechnicalConsumer(String numCompteContrat){
        return new Account(Name=TECHNICAL_NAME, recordtypeid = RT_ID_CONSUMER, No_Compte_contrat__c = numCompteContrat);
    } 
    
    /**
     * @author Nourelimane SMOUNI && Ayoub BERRAMDANE
     * @date 01/03/2022
     * @param noCompteContrat Account Contract Number to store in No_Compte_contrat__c
     * @param name Account Name to store in No_Compte_contrat__c
     * @param idPortefeuilleContrat  Contract Id Portefuille Number to store in ID_Porte_feuille_contrat__c
     * @param idBatiment  Batiment Id to store in ID_Batiment__c
     * @param idLocal  Local Id to store in ID_Local__c
     * @param lbPortefeuilleContrat  Contract Portefeuille Lb to store in LB_Portefeuille_contrat__c
     * @param idFoyer  Foyer Id to store in FoyerId__c
     * @param lbFoyer  Foyer Lb to store in FoyerLabel__c
     * @param dateDebut Start Date to store in StartDate__c
     * @param dateFin  End Date to store in EndDate__c
     * @description Create a technical account
     * @return Account instance of account for technical consumer
     */
    public static Account createTechnicalConsumer2(String noCompteContrat,String name,String idPortefeuilleContrat,String idBatiment,String idLocal,String lbPortefeuilleContrat,String idFoyer,String lbFoyer,String dateDebut,String dateFin){
        Account acc = new Account(
            Name = name, 
            recordtypeid = RT_ID_CONSUMER, 
            No_Compte_contrat__c = noCompteContrat,
            FoyerLabel__c = lbFoyer,
            LB_Portefeuille_contrat__c = lbPortefeuilleContrat
        );
        
        acc.ID_Porte_feuille_contrat__c = String.isEmpty(idPortefeuilleContrat)?null:double.valueOf(idPortefeuilleContrat);
        acc.ID_Batiment__c = String.isEmpty(idBatiment)?null:double.valueOf(idBatiment);
        acc.ID_Local__c = String.isEmpty(idLocal)?null:double.valueOf(idLocal);
        acc.FoyerId__c = String.isEmpty(idFoyer)?null:double.valueOf(idFoyer);
        acc.StartDate__c = String.isEmpty(dateDebut)?null:Date.valueOf(dateDebut);
        acc.EndDate__c = String.isEmpty(dateFin)?null:Date.valueOf(dateFin);
        
        return acc;
    }

    /**
     * @author Nourelimane SMOUNI && Ayoub BERRAMDANE
     * @date 01/03/2022
     * @param noCompteContrats No_Compte_contrat__c to filter on
     * @description Map of account record filtered by No_Compte_contrat__c
     * @return Map<String, Account> Map of account record filtered by No_Compte_contrat__c
     */
    public static Map<String, Account> getMapByNoCompteContrat(Set<String> NoCompteContrat){
        Map<String, Account> AccountByNoCompteContrat = new Map<String, Account>();
        
        for(Account acc: [Select Name,Id, No_Compte_contrat__c,ID_Porte_feuille_contrat__c,ID_Batiment__c,ID_Local__c,LB_Portefeuille_contrat__c, FoyerId__c, FoyerLabel__c, StartDate__c, EndDate__c, RecordtypeId from Account where No_Compte_contrat__c in :NoCompteContrat]){
            AccountByNoCompteContrat.put(acc.No_Compte_contrat__c, acc);
        } 
        
        return AccountByNoCompteContrat;
    }
 
    /** 
     * @author Sutharsan Pushparajah
     * @date 09/11/2021
     * @param noCompteContrats No_Compte_contrat__c to filter on
     * @description List of account record filtered by No_Compte_contrat__c
     * @return List<Account> List of account record filtered by No_Compte_contrat__c
     */
    public static List<Account> getByNoCompteContrat(Set<String> noCompteContrats){
        
        List<Account> accounts = new List<Account>(); 
        
        for(Account acc: [select id, No_Compte_contrat__c from Account where No_Compte_contrat__c in :noCompteContrats]){
            accounts.add(acc);
        }
        
        return accounts;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 09/11/2021
     * @param accounts list of account to insert
     * @description insert account records and allow partial success
     * @return Database.SaveResult[] List of savedresult for account creation
     */
    public static Database.SaveResult[] insertWithFailureAllowed(List<Account> accounts){
        Database.SaveResult[] acsrs = Database.insert(accounts,false);
        return acsrs;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 09/11/2021
     * @param accounts list of account to insert/update through upsert
     * @param externalIdField Field used as externalId for upsert
     * @description insert/update through upsert account records and allow partial success
     * @return Database.UpsertResult[] List of upsertresult for account upsert
     */
    public static Database.UpsertResult[] upsertWithFailureAllowed(List<Account> accounts, Schema.SObjectField externalIdField){
        Database.UpsertResult[] srs = Database.upsert(accounts, externalIdField,false);
        return srs;
    }
    
    /**
     * @author Nourelimane SMOUNI && Ayoub BERRAMDANE
     * @date 01/03/2022
     * @param accounts list of account to update 
     * @description update account records and allow partial success
     * @return Database.SaveResult[] List of saveresult for account upsert
     */
    public static Database.SaveResult[] updateWithFailureAllowed(List<Account> accounts){
        Database.SaveResult[] accsrs = Database.update(accounts,false);
        return accsrs;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @param fields fields to query separated by comma
     * @param ids List of contact Id to query on
     * @description Query Account records filtered on id
     * @return List<Contact> List of Account records queried by id
     */
    public static List<Account> getByIds(String fields, List<Id> ids){
        return datamanager.queryBy(fields, String.valueOf(Account.Id), ids);
    }
}