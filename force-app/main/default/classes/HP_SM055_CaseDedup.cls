/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   22-02-2021   Antoine Latour   Initial Version
**/
public without sharing class HP_SM055_CaseDedup{

    /**
    * @description 
    * @author Antoine Latour | 22-02-2021 
    * @param List<Case> casesList 
    **/
    public static void updateDuplicatedCases(List<Case> casesList){
        if(casesList == null) return;
        Map<String, Case> casesMap = new Map<String, Case>();
        List<Case> caseToUpdate = new List<Case>();

        for(Case oneCase : casesList) {
            String caseContact = '';
            if(oneCase.Contact.ID_Tiers__c != null) {
                caseContact = String.valueOf(oneCase.Contact.ID_Tiers__c);
            }
            else {
                caseContact = oneCase.SuppliedEmail;
            }
            String caseDescription = oneCase.Description;
            String caseSubject = oneCase.Subject;

            String key = caseContact + '/' + caseSubject + '/' + caseDescription;
            if(!casesMap.containsKey(key)) {
                casesMap.put(key, oneCase);
            }
            else {
                Case savedCase = casesMap.get(key);
                if(oneCase.CreatedDate >= savedCase.CreatedDate) {
                    oneCase.Status = 'CANCELED';
                    caseToUpdate.add(oneCase);
                }
                else {
                    savedCase.Status = 'CANCELED';
                    caseToUpdate.add(savedCase);
                    casesMap.put(key, oneCase);
                }
            }
        }

        if(caseToUpdate.size() > 0) Database.update(caseToUpdate);
    }
}