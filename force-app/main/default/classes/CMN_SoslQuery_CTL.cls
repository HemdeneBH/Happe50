/***
* @author P-E GROS (Salesforce)
* @date 24/02/2018
* @description Contrôleur Lightning permettant d'exécuter n'importe
*              quelle requête SOSL directement depuis un composant.
***/

public with sharing class CMN_SoslQuery_CTL {

/***
* @description Service d'exécution d'une requête SOSL.
*              Cf limitation sur Search.query() concernant les
*              méthodes SOSL supportées.
*              Attention aux volumétries retournées.
* @param searchQuery Chaîne de caractère contenant la requête SOSL
*        à exécuter.
* @return List<List <sObject>> correspondant au résultat de la requête.
* @Exception aucune spécifique.
***/
  @AuraEnabled
  public static List<List <sObject>> executeSearch(String searchQuery) {
     System.debug('executeSearch : search requested ' + searchQuery);
     List<List <sObject>> resultList = Search.query(searchQuery);
     System.debug('executeSearch : search results ' + resultList);
     return resultList;
  }

}