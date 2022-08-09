/*
*@Author: Clément Bouquin
*@Description: Bouton d'import de contact depuis un fichier CSV 
*@CreatedDate: 17/11/2021
*@LastModified: 17/11/2021
*/

public with sharing class VI_PPButtonImportContact {
    /*    
* @author Clément Bouquin
* @date 17/11/2021
* @description Bouton d'import de contact depuis un fichier CSV 
* @param String base64Data
* @return list<String>
*/
    
    @AuraEnabled
    public static list<String> saveFile(String base64Data) {
        String data= JSON.deserializeUntyped(base64Data).toString();
        list<Contact> lstCCToInsert = new list<Contact>();
        list<String> lstCSVLines = data.split('\n');
        String utilisateurActif = '';
        Boolean insertFail = false;
        Integer failAtLineI = 2;
        String insertErrorMessage = '';
        list<String> lstErrors = new list<String>();
        id recordTypeContactPartenaire = VI_ObjectUtils.getRecordTypeId('Contact','PartenaireContactRT');
        User loggedInUserAccount = [Select Id, AccountId
                                  from User
                                  Where Id = :UserInfo.getUserId()];
        for(Integer i = 0; i < lstCSVLines.size(); i++){
            Contact con = new Contact();
            String csvLine = lstCSVLines[i];
            List<String> csvRowData = new List<String>();
            for(String column : csvLine.split(';')){
                column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                csvRowData.add(column);
            }
            if (i == 0) {
                if(!csvRowData[0].replaceAll('\r\n|\n|\r','').equals('Salutation') ||
                   !csvRowData[1].replaceAll('\r\n|\n|\r','').equals('Firstname') || !csvRowData[2].replaceAll('\r\n|\n|\r','').equals('Lastname') ||
                   !csvRowData[3].replaceAll('\r\n|\n|\r','').equals('VI_CodeVendeur__c') || 
                   !csvRowData[4].replaceAll('\r\n|\n|\r','').equals('VI_Site_Prestataire__c') || !csvRowData[5].replaceAll('\r\n|\n|\r','').equals('VI_TypeUtilisateurPartnerCommunity__c') ||
                   !csvRowData[6].replaceAll('\r\n|\n|\r','').equals('Email') || !csvRowData[7].replaceAll('\r\n|\n|\r','').equals('VI_Utilisateur_actif__c')) {
                       insertErrorMessage = 'Le Header du fichier est invalide, les colonnes doivent etre nommées: Salutation; Firstname; Lastname; VI_CodeVendeur__c; VI_Site_Prestataire__c; VI_TypeUtilisateurPartnerCommunity__c; Email; VI_Utilisateur_actif__c.';
                       lstErrors.add(insertErrorMessage);
                       return lstErrors;
                   }
            }
            else {
                con.RecordTypeId =recordTypeContactPartenaire;
                con.Salutation = csvRowData[0].replaceAll('\r\n|\n|\r','');
                con.Firstname = csvRowData[1].replaceAll('\r\n|\n|\r','');
                con.Lastname = csvRowData[2].replaceAll('\r\n|\n|\r','');
                con.VI_CodeVendeur__c = csvRowData[3].replaceAll('\r\n|\n|\r','');
                con.AccountId = loggedInUserAccount.AccountId;
                if(!String.isBlank(csvRowData[4])){
                    con.VI_Site_Prestataire__c = csvRowData[4].replaceAll('\r\n|\n|\r','');
                }
                con.VI_TypeUtilisateurPartnerCommunity__c = csvRowData[5].replaceAll('\r\n|\n|\r','');
                con.Email = csvRowData[6].replaceAll('\r\n|\n|\r','');
                con.VI_Utilisateur_actif__c = csvRowData[7].replaceAll('\r\n|\n|\r','').toLowerCase().equals('true');
                lstCCToInsert.add(con);
            }
            
        }
        if (!lstCCToInsert.isEmpty()){
            Savepoint sp = Database.setSavepoint();
            Database.SaveResult[] saveResultList = Database.insert(lstCCToInsert, false);
            
            // Iterate through saveResultList based on isSuccess capture the failed records
            for (Database.SaveResult sr : saveResultList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                }
                else {
                    // Operation failed, so get all errors
                    insertFail = true;
                    insertErrorMessage = '\n';
                    for(Database.Error err : sr.getErrors()) {
                        insertErrorMessage = insertErrorMessage + err.getStatusCode() + ': ' + err.getMessage() + ' Cette erreur concerne le contact de la ligne: ' + failAtLineI;
                        if (err.getFields() != null && !err.getFields().isempty()) {
                            insertErrorMessage = insertErrorMessage + ' et affecte le champ: ' + err.getFields();
                        }
                        lstErrors.add(insertErrorMessage);
                    }
                }
                FailAtLineI++;
            }
            if (insertFail){
                Database.rollback(sp);
                return lstErrors;
            }
        }
        return null;
    }
}