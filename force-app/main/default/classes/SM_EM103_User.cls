/**
 * @author Sutharsan Pushparajah
 * @date 19/04/2022
 * @description SM_EM103_User - Entity to manage User SObject
 */
public inherited sharing class SM_EM103_User {
   
    /* Instance of the user datamanager to access SOQL & DML operations */
    public static ITF001_DataManager datamanager = new DM001_SObjectInstance(SObjectType.User.Name, 'SM_EM103_User');
    
    /**
     * @author Sutharsan Pushparajah
     * @date 19/04/2022
     * @param fields fields to query separated by comma
     * @param ids List of User Id to query on
     * @description Query User records filtered on id
     * @return List<User> List of user records queried by id
     */
    public static List<User> getByIds(String fields, List<Id> ids){
        return datamanager.queryBy(fields, String.valueOf(User.Id), ids);
    } 
}