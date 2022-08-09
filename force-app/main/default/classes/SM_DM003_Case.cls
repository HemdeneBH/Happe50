/**
 * @description       : DM Class for Case Object
 * @author            : Mohamed Aamer
 * @last modified on  : 03-11-2022
 * @last modified by  : Mohamed Aamer
**/
public with sharing class SM_DM003_Case {

    public static List<Case> retrieveCasesByPcIds(final Set<String> pcIds){
        List<Case> cases = [ 
            SELECT Id,Origin,RecordType.DeveloperName,Status,Sous_statut__c,Subject,CPV_E_Canal_d_envoi__c,CPV_E_Lien_CPV__c,CPV_E_Envoyee__c,CPV_E_Date_de_signature__c,CPV_E_Signee__c,
            (
                SELECT Case__c,Numero_PC__c,CPV_canal_envoi__c,Lien_CPV__c,CPV_Envoyee__c,CPV_Conforme__c,CPV_Signee__c,CPV_Date_de_signature__c
                FROM Orders__r
                WHERE Numero_PC__c IN :pcIds
            )
            FROM Case
            WHERE Id IN (
                SELECT Case__c
                FROM Order
                WHERE Numero_PC__c IN :pcIds
            )
        ];
        return cases;
    }
}