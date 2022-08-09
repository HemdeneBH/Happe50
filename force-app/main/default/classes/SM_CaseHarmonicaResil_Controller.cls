public class SM_CaseHarmonicaResil_Controller {
    
    @AuraEnabled
    public static String getContactId(String caseId){
        String contactId = [Select ContactId from Case Where id = :caseId].ContactId;
        return contactId;
    }

}