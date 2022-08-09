/**
* @description       : Controller for SM_CaseHarmonicaCHO aura component (FT1-4947)
* @author            : Zouhair BOUKHRISS
* @group             : 
* @last modified on  : 02-07-2021
* @last modified by  : David ATTALi
* Modifications Log 
* Ver   Date         Author               Modification
* 1.0   01-07-2021   Zouhair BOUKHRISS    Initial Version
* 1.1   02-07-2021   David ATTALI         Comments and add contactId on HarmonicaCHOData class to return it
**/
public class SM_CaseCHOHarmonica_Controller {
    
    public class HarmonicaCHOData {
        @AuraEnabled public String harmonicaBankDetailsId;
        @AuraEnabled public String clientBPId;
        @AuraEnabled public String contactId;
    }

   
    @AuraEnabled
    public static HarmonicaCHOData getDataCHO(String caseId) {
        
        // Get MoveInData from Donnees_Vente__c
        Donnees_Vente__c data = [SELECT CaseId__r.ContactId, CaseId__r.Contact.Identifiant_Buisness_Partener__c, IBAN_crypte__c, IBAN_Titulaire__c, ID_coordonnees_bancaires__c
                                 FROM Donnees_Vente__c WHERE CaseId__c = :caseId];
        
        System.debug('### getData() - data (Donnees_Vente__c) : ' + data);
        
        HarmonicaCHOData harmonicaCHO = new HarmonicaCHOData();
        harmonicaCHO.contactId = data.CaseId__r.ContactId;
        harmonicaCHO.clientBPId = data.CaseId__r.Contact.Identifiant_Buisness_Partener__c;
       
        
        String idBP = data.CaseId__r.Contact.Identifiant_Buisness_Partener__c;
        String ibanCrypte = data.IBAN_crypte__c;
        String ibanTitulaire = data.IBAN_Titulaire__c;
        String harmonicaBankDetailsId  = data.ID_coordonnees_bancaires__c;
        // Decrypts IBAN in Harmonica Case (Origin : Tunnel en ligne)
        if(!String.isBlank(ibanCrypte) && String.isBlank(harmonicaBankDetailsId)) {



        try{
                harmonicaBankDetailsId = SM_CaseHarmonicaMoveIn_controller.getHarmonicaBankDetailsId(idBP, ibanCrypte, ibanTitulaire);
            } catch(Exception ex) {
                harmonicaBankDetailsId = '';

            }
        }
        harmonicaCHO.harmonicaBankDetailsId = harmonicaBankDetailsId;
        return harmonicaCHO;
    }
}