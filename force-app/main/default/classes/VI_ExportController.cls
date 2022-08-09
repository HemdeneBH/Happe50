/*
*@Auhtor: Paul Ghoussoub
*@Description: Controller du LWC vI_LWC_ExportTasks qui permet d'exporter des taches
*@CreatedDate: 16/11/2021
*/
public with sharing class VI_ExportController {
    /*
*@Auhtor: Paul Ghoussoub
*@Description Recuperation des taches concernées par le conseiller connectè
*@CreatedDate: 16/11/2021
*/
    @AuraEnabled( cacheable = true )  
    public static List < sObject > fetchRecs(String recordTypeName,Boolean isExterne) {
        system.debug('isExterne '+isExterne);
        system.debug('recordTypeName '+recordTypeName);
        String recordTypeToQuery;
        if (recordTypeName=='VI_DemandeBO'){
            recordTypeToQuery=VI_ObjectUtils.getRecordTypeId('Task','VI_DemandeBO');
        }
        else{
            recordTypeToQuery=VI_ObjectUtils.getRecordTypeId('Task','PurePlayerTask');
        }
        List < sObject > listRecs = new List < sObject >();
        String strSOQL = 'SELECT Id,Subject,VI_TECH_MemePrestataire__c ,VI_Site_prestataire__c,VI_DateDeCreationDuParcours__c,VI_OwnerIdURL__c,VI_OwnerName__c,VI_WhatName__c,VI_WhatIdUrl__c,VI_TaskId__c,WhatId,what.name,ActivityDate,OwnerId,owner.name,VI_NomClient__c,VI_TelephonePrincipal__c,VI_StatutDuParcours__c,VI_StatutDuCase__c,VI_ApercuDuCommentaire__c FROM Task WHERE  Status=\'A Traiter\' AND recordtypeid=\''+recordTypeToQuery+'\'';
        
        if(!isExterne){
            strSOQL+=' AND VI_TECH_MemePartenaire__c=true';
        }
        else{
            if(recordTypeName.equals('PurePlayerTask')){
                strSOQL+=' AND VI_TECH_MemePrestataire__c =true';
            }
            if(recordTypeName.equals('VI_DemandeBO')){
                strSOQL+=' AND VI_TECH_MemePrestataire__c =true AND VI_TECH_MemePartenaire__c=true';
            }
        }
        
        system.debug( 'SOQL is ' + strSOQL );
        listRecs = Database.query( strSOQL );
        system.debug('listRecs '+listRecs);
        return listRecs;
    }  
    
    /*
*@Auhtor: Paul Ghoussoub
*@Description Recuperer les taches selectionnées, les mettre dans un fichier csv et les envoyés par mail à l'utilisateur
*@CreatedDate: 16/11/2021
*/
    @AuraEnabled
    public static void exportTasks(List<Task> listTasks,String recordTypeName) {  
        String userEmail=Userinfo.getUserEmail();
        system.debug('listTasks '+listTasks);
        String generatedCSVFile ='';
        String generatedCSVFileRecords ='';
        String fileRow = '';
        String statutDuParcours='';
        for(Task currentTask: listTasks){
            fileRow = '';
            statutDuParcours='';
            fileRow = fileRow +';'+ currentTask.VI_Site_prestataire__c;
            if (recordTypeName=='PurePlayerTask'){
                fileRow = fileRow +';'+ currentTask.VI_OwnerName__c;
            }
            fileRow = fileRow +';'+ currentTask.VI_DateDeCreationDuParcours__c;
            if (recordTypeName=='PurePlayerTask'){
                fileRow = fileRow +';'+ currentTask.ActivityDate;
            }
            fileRow = fileRow +';'+(currentTask.Subject == null? '':currentTask.Subject);
            fileRow = fileRow +';'+(currentTask.VI_WhatName__c == null? '':currentTask.VI_WhatName__c);
            fileRow = fileRow +';'+(currentTask.VI_NomClient__c == null? '':currentTask.VI_NomClient__c);
            fileRow = fileRow +';'+(currentTask.VI_TelephonePrincipal__c == null? '':currentTask.VI_TelephonePrincipal__c);
            if(currentTask.VI_StatutDuParcours__c!=null){
                statutDuParcours=currentTask.VI_StatutDuParcours__c;
                if(statutDuParcours.contains('é')){
                    statutDuParcours=statutDuParcours.replace('é','e');
                }
                if(statutDuParcours.contains('à')){
                    statutDuParcours=statutDuParcours.replace('à','a');
                }
            }
            fileRow = fileRow +';'+(statutDuParcours == null? '':statutDuParcours);
            fileRow = fileRow +';'+(currentTask.VI_StatutDuCase__c == null? '':currentTask.VI_StatutDuCase__c);
            fileRow = fileRow +';'+(currentTask.VI_ApercuDuCommentaire__c == null? '':currentTask.VI_ApercuDuCommentaire__c);
            fileRow = fileRow.replaceFirst(';','');
            generatedCSVFileRecords = generatedCSVFileRecords + fileRow + '\n';
        }
        generatedCSVFile = 'Site / Prestataire;';
        if (recordTypeName=='PurePlayerTask'){
            generatedCSVFile=generatedCSVFile+'Attribue a;';
        }
        generatedCSVFile=generatedCSVFile+'Date de creation du parcours;';
        if (recordTypeName=='PurePlayerTask'){
            generatedCSVFile=generatedCSVFile+'Echeance;';
        }
        generatedCSVFile =generatedCSVFile+'Objet;Associe a;Nom Client;Telephone Principal;Statut du parcours;Statut du case;Apercu du commentaire\n'+generatedCSVFileRecords ;
        Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
        Blob csvBlob = blob.valueOf(generatedCSVFile);
        String csvName = 'Tâches sélectionnées.csv';
        csvAttachment.setFileName(csvName);
        csvAttachment.setBody(csvBlob);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{userEmail};
            String subject = 'Tâches sélectionnées';
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setPlainTextBody('Bonjour,\n\nVeuillez trouver en pièce jointe les tâches que vous avez séléctionné.\n\nCordialement,');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
        if(!Test.isRunningTest()){
            Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        }
    }
    
}