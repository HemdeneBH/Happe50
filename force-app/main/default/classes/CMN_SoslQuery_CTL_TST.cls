/***
* @author P-E GROS (Salesforce)
* @date 24/02/2018
* @description Classe de test du Contrôleur Lightning CMN_SoslQuery_CTL
* @see CMN_SoslQuery_CTL
***/

@isTest
private class CMN_SoslQuery_CTL_TST {
    
/***
* @description Methode de test de la méthode executeQuery
* @see executeQuery
***/
    @isTest
    static void testExecuteQuery () {
        String testQuery = 'FIND \'TEST\' IN ALL FIELDS RETURNING Account (Name)';
        List<List <sObject>> sobjLists = CMN_SoslQuery_CTL.executeSearch(testQuery);
        System.assertEquals(1,sobjLists.size());
        System.assertEquals(0,sobjLists[0].size());
    }

}