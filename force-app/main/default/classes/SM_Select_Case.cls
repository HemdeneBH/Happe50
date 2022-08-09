/**
 * @File Name          : SM_Select_Case
 * @Description        :
 * @Author             : Geetha SENTHILNATHAN
 * @Group              :
 * @Last Modified By   : GSEN
 * @Last Modified On   : 11/09/2020 à 10:00:00
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    11/09/2020   Equipe Dev SMILE-FT3      Initial Version
 **/
public with sharing class SM_Select_Case {
    public static List<Case> getCasesById(List<Id> idsCase) {
        return [SELECT Id FROM Case WHERE Id IN:idsCase];
    }
}