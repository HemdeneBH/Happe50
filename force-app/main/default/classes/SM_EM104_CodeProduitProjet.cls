/**
 * @author Sutharsan Pushparajah
 * @date 19/04/2022
 * @description SM_EM104_CodeProduitProjet - Entity to manage SM_CodeProduitProjet__mdt CustomMetadaType
 */
public inherited sharing class SM_EM104_CodeProduitProjet {
    
    /* Instance of the SM_CodeProduitProjet__mdt datamanager to access SOQL & DML operations */
    public static ITF001_DataManager datamanager = new DM001_SObjectInstance(SObjectType.SM_CodeProduitProjet__mdt.Name, 'SM_EM104_CodeProduitProjet');

    /* All Active SM_CodeProduitProjet__mdt records sorted by OrderId__c */
    public static List<SM_CodeProduitProjet__mdt> allActivesSortedByOrderId;

    static {
        allActivesSortedByOrderId = getActivesSortedByOrderId();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 19/04/2022
     * @description get All Active SM_CodeProduitProjet__mdt records sorted by OrderId__c
     * @return List<SM_CodeProduitProjet__mdt> All Active SM_CodeProduitProjet__mdt records sorted by OrderId__c
     */
    public static List<SM_CodeProduitProjet__mdt> getActivesSortedByOrderId(){
        return (List<SM_CodeProduitProjet__mdt>) datamanager.query('Projet__c, TypedeProjet__c, CodeProduit__c, IsActive__c', 'IsActive__c = true', 'order by OrderId__c', null, null);
    }
}