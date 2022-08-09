/**
 * @File Name          : HP_EM019_Task.cls
 * @Description        : 
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc

 * @Last Modified On   : 01-25-2021

 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/01/2020   Mohamed Aamer     Initial Version
**/
public with sharing class HP_EM019_EmailMessage {

    public static void createEmailMessage(String email, Integer idClient, String code, String body) {

        Contact contact =[SELECT ID ,Id_Tiers__c FROM Contact WHERE Id_Tiers__c =: idClient];
        Savepoint savePoint = Database.setSavepoint();
        
        try {
            EmailMessage emailMessage = HP_EM019_EmailMessage.createEmailMessage(email, code, body);
            insert emailMessage;
            HP_EM019_EmailMessage.createEmailMessageRelation(emailMessage, contact);
        } catch (DmlException dmlException) {
            Database.rollback(savePoint);
            System.debug('failed to insert EmailMessage or EmailMessageRelation: '+ dmlException);
        }
    
    } 

    public static EmailMessage createEmailMessage(String email,String code,String body) {
            EmailMessage emailMessage = new EmailMessage();
            emailMessage.status = '3';
            emailMessage.fromName = 'CABESTAN';
            switch on code {
                when 'SF52' {
                    emailMessage.subject ='Envoi Email: '+'Confirmation de la modification de vos informations personnelles';
                    emailMessage.toAddress = email;
                    emailMessage.htmlBody =body;
                }
                when 'SF12'{
                    emailMessage.subject ='Envoi Email: '+'Aucune saisie d\'index EM élec / gaz (annulation demande)';
                    emailMessage.toAddress = email;
                    emailMessage.htmlBody =body;
                }
                when 'SF13'{
                    emailMessage.subject ='Envoi Email: '+'Confirmation transmission demande au distributeur';
                    emailMessage.toAddress = email;
                    emailMessage.htmlBody =body;
                }
                when  'SF20'{
                    emailMessage.subject ='Envoi Email: '+'Relevé de compteur manquant - demande sur index estimé';
                    emailMessage.toAddress = email;
                    emailMessage.htmlBody =body;
                }
                when 'SF21'{
                    emailMessage.subject ='Envoi Email: '+'Confirmation demande résiliation';
                    emailMessage.toAddress = email;
                    emailMessage.htmlBody =body; 
                }
                when 'SF22'{
                    emailMessage.subject ='Envoi Email: '+'Résiliation fournisseur';
                    emailMessage.toAddress = email;
                    emailMessage.htmlBody =body;
                }
            }
           return emailMessage;
    }

    public static void createEmailMessageRelation(EmailMessage em, Contact cont){
        try{
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.emailMessageId = em.id;
            emr.relationId = cont.Id;
            emr.relationType = 'ToAddress';
            insert emr;
        }catch(DmlException dmlException){
            System.debug('failed to insert EmailMessageRelation: '+ dmlException);
        }
       
    }

    public static Map<Id,EmailMessage> createEmailMessageMap(Set<Id> idSet) {
        List<EmailMessage> emailMessageList = [select Id, CreatedDate, HP_ResponseDate__c, HP_ResponseUser__c From EmailMessage Where Id in: idSet];
        if(emailMessageList.size() > 0) {
            Map<Id,EmailMessage> resultMap = new Map<Id, EmailMessage>();
            for(EmailMessage em : emailMessageList) {
                resultMap.put(em.Id, em);
            }
            return resultMap;
        }
        return null;
    }

    /**
    * @description 
    * @author Antoine Latour | 17-11-2020 
    * @param List<EmailMessage> emailMessageList 
    * @param Map<Id EmailMessage> emailPrecedentMap 
    **/
    public static void updateMailResponseTime(List<EmailMessage> emailMessageList, Map<Id,EmailMessage> emailPrecedentMap) {
        List<EmailMessage> emailMessageToUpdate = new List<EmailMessage>();
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE name ='HP'];
        System.debug('emailMessageList: '+ emailMessageList.size());
        System.debug('emailMessageList: '+ emailMessageList);
        System.debug('emailPrecedentMap: '+ emailPrecedentMap);


        for(EmailMessage item : emailMessageList) {
            System.debug('item: '+ item);
            System.debug('HP_TECH_Incoming__c: '+ item.HP_TECH_Incoming__c);
            System.debug('!item.ReplyToEmailMessageId: '+ item.ReplyToEmailMessageId);
            System.debug('condition: '+ (!item.HP_TECH_Incoming__c && item.ReplyToEmailMessageId != null));

            if(!item.HP_TECH_Incoming__c && item.ReplyToEmailMessageId != null) {
                System.debug('item: '+ item);

                EmailMessage emailPrecedent = emailPrecedentMap.get(item.ReplyToEmailMessageId);
                System.debug('emailPrecedent: '+ emailPrecedent);
                emailPrecedent.HP_ResponseDate__c = item.CreatedDate;
                Map<String,Boolean> QSMap = getQS(emailPrecedent,bh);
                emailPrecedent.HP_QS24__c = QSMap.get('HP_QS24__c');
                emailPrecedent.HP_QS48__c = QSMap.get('HP_QS48__c');    
                emailPrecedent.HP_ResponseUser__c = item.CreatedById;
                emailPrecedent.Case__c = item.ParentId;
                emailMessageToUpdate.add(emailPrecedent);
            }
        }
        System.debug('emailMessageToUpdate: '+ emailMessageToUpdate);

        if(emailMessageToUpdate.size() > 0) Database.update(emailMessageToUpdate);
    }
 
    public static Map<Id, EmailMessage> filterMapByIsHappe(Map<Id,EmailMessage> mapEmailMessageIn) {
        Map<Id,EmailMessage> mapEmailMessageOut = new Map<Id,EmailMessage>();
        
        if(mapEmailMessageIn == null) {
            return null;
        }
        for(EmailMessage item : mapEmailMessageIn.values()) {
            if(item.HP_isHappe__c){
                mapEmailMessageOut.put(item.Id, item);
            }
        }
    
        return mapEmailMessageOut;
    }

    public static List<EmailMessage> filterListByIsHappe(List<EmailMessage> listEmailMessageIn) {
        List<EmailMessage> listEmailMessageOut = new List<EmailMessage>();
        
        if(listEmailMessageIn == null) {
            return null;
        }
        
        for(EmailMessage item : listEmailMessageIn) {
            if(item.HP_isHappe__c){
                listEmailMessageOut.add(item);
            }
        }
    
        return listEmailMessageOut;
    }

    /**
    * @description 
    * @author Ali AJELLAL | 01-19-2021 
    * @param emailPrecedent 
    * @param bh 
    * @return Map<String, Boolean> 
    **/
    public static Map<String,Boolean> getQS(EmailMessage emailPrecedent, BusinessHours bh){


        Integer QS24Minutes = 1440;


        Map<String,Boolean> QSMap = new Map<String,Boolean>();
        QSMap.put('HP_QS24__c', false);
        QSMap.put('HP_QS48__c', false);
        Datetime createdDate = emailPrecedent.CreatedDate;
        Datetime responseDate = emailPrecedent.HP_ResponseDate__c;

        Time createdTime = createdDate.Time();
        Time responseTime = responseDate.Time();
        // QS24 true : le prochain J+1 ouvré avec H - 1min 
        Boolean isMinuteVerify = (responseTime.hour() == createdTime.hour()) && (responseTime.minute() <= createdTime.minute()-1);
        Boolean isResponseHourValid = (responseTime.hour() < createdTime.hour());

        // si réponse ds le meme jour
        if(responseDate.isSameDay(createdDate)){
            QSMap.put('HP_QS24__c', true);
            QSMap.put('HP_QS48__c', true);
        }
        // récuperer le 1er et le 2eme jour ouvré à partir de la date de creation du mail(createdDate).
        Datetime nextStartPlusOne = BusinessHours.nextStartDate(bh.id, createdDate.addDays(1));
        Datetime nextStartPlusTwo = BusinessHours.nextStartDate(bh.id, nextStartPlusOne.addDays(1));
        System.debug('nextStartPlusOne: '+ nextStartPlusOne);
        System.debug('nextStartPlusTwo: '+ nextStartPlusTwo);


       if(nextStartPlusOne.isSameDay(responseDate) ){
           QSMap.put('HP_QS48__c', true);
           QSMap.put('HP_QS24__c', false);
           // QS24 true : le prochain J+1 ouvré avec minimum H - 1min 
           if(isResponseHourValid || isMinuteVerify ) QSMap.put('HP_QS24__c', true);
    
       }

       if(nextStartPlusTwo.isSameDay(responseDate) ){
           // QS48 true : le prochain J+2 ouvré avec minimum H - 1min 
           if(isResponseHourValid || isMinuteVerify) QSMap.put('HP_QS48__c', true);
       }


       System.debug('QSMap: '+ QSMap);

      return QSMap;
    }









    /**
    * @description 
    * @author Antoine Latour | 09-04-2021 
    * @param Set<Id> casesIdSet 
    * @return Map<Id, List<EmailMessage>> 
    **/
    public static Map<Id, List<EmailMessage>> loadEmailMessagesFromCase(Set<Id> casesIdSet) {
        List<EmailMessage> emailMessageList = [select Id, ParentId From EmailMessage Where ParentId in: casesIdSet];
        if(emailMessageList == null || emailMessageList.isEmpty()) return null;

        Map<Id, List<EmailMessage>> mapEmailMessage = new Map<Id, List<EmailMessage>>();
        for(EmailMessage em : emailMessageList) {
            List<EmailMessage> tempList = null;
            if(mapEmailMessage.containsKey(em.ParentId)) {
                tempList = mapEmailMessage.get(em.ParentId);
            }
            else {
                tempList = new List<EmailMessage>();
            }
            tempList.add(em);
            mapEmailMessage.put(em.ParentId, tempList);
        }

        return mapEmailMessage;
    }








}