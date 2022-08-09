/**
* @author Rajaa MOUHIB
* @date 04/03/2022
* @description SM_EM102_AccountContactRelation - Entity to manage AccountContactRelation SObject
*/
public inherited sharing class SM_EM102_AccountContactRelation {


    /* External Id field Identifiant_Buisness_Partener__c */
    public static final Schema.SObjectField FIELD_EXTID_IDENTIFIANT_ROLE = AccountContactRelation.Fields.rolekey__c;
 
    /**
     * @author  Rajaa MOUHIB
     * @date 04/03/2022
     * @description Create a technical AccountContactRelation
     * @return AccountContactRelation instance of accountContactRelationt for technical consumer
     */
    public static AccountContactRelation createRole(String NoComptecontrat ,String IdBuisnessPartener ,String rolekey, String Roles,Boolean active, Date endDate, Date startDate){
        return new AccountContactRelation(
            Account =  new Account(No_Compte_contrat__c = NoComptecontrat),
            Contact = new Contact(Identifiant_Buisness_Partener__c=IdBuisnessPartener),
            rolekey__c=rolekey,
            Roles=Roles,
            IsActive=active,
            EndDate = endDate,
            StartDate = startDate);
    }

    /**
     * @author  Rajaa MOUHIB
     * @date 04/03/2022
     * @param accountContactRelations list of account to insert/update through upsert
     * @param externalIdField Field used as externalId for upsert
     * @description insert/update through upsert account records and allow partial success
     * @return Database.UpsertResult[] List of upsertresult for account upsert
     */
    public static Database.UpsertResult[] upsertWithFailureAllowed(List<AccountContactRelation> accountContactRelations, Schema.SObjectField externalIdField){
       Database.UpsertResult[] srs = Database.upsert(accountContactRelations, externalIdField,false);
       return srs;
    }
}