public with sharing class SM_HarmonicaDisplayContactInfos {
    public SM_HarmonicaDisplayContactInfos() {}
    @AuraEnabled(cacheable=true)
    public static String getDataClient (String caseId){
        System.debug('### caseId '+caseId);
        Donnees_Vente__c donneVente = [SELECT id,CaseId__r.contact.reference_client_f__c, 
                                              Civilite_client__c,Email_client__c,Nom_client__c,
                                              Prenom_client__c, Telephone_client__c,Libelle_voie__c,
                                              Code_postale__c,Numero_de_voie__c,Commune__c,E_documents__c,Statut_Iban__c,
                                       		  CaseId__r.Origin, CaseId__r.MES_urgente__c,Maj_email__c, CaseId__r.Type , 
                                  			  CaseId__r.Depex__c, CaseId__r.Degex__c,CaseId__r.Depexplus__c,CaseId__r.Degexplus__c,
                                 			  CaseId__r.Garantie_Electromenager__c,CaseId__r.Assurance_Facture__c, EmailRisque__c 
                                        FROM Donnees_Vente__c
                                        WHERE CaseId__c = :caseId];
        System.debug('## donneVente '+donneVente);
        return JSON.serialize(donneVente);
    }
}