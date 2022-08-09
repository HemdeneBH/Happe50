/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 07-07-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_EC_UpdateCustomerData {

    @AuraEnabled
    public static String createCaseDonnees(String contactId){
        System.debug('HP_EC_UpdateCustomerData.createCaseDonnees | Method Start');
        String data;
        try {
            Case myCase = new Case();
            myCase.ContactId = contactId;
            myCase.RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Mail');
            myCase.HP_Type__c = 'HP_CONTRACT_DATA';
            myCase.Status = 'TO_DO';
            myCase.Motif__c = 'Coordonnées clients (modification/justificatifs/RGPD)';
            myCase.HP_Sous_type__c = 'HP_Creation_Dossier_RGPD';
            myCase.OwnerId = HP_UTIL_QueueManager.getQueueIdByName('HP_Niveau_3');
            insert myCase;
            data = myCase.Id;
        } catch (Exception e) {
            System.debug('HP_EC_UpdateCustomerData.createCaseDonnees | Exception : ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
        System.debug('HP_EC_UpdateCustomerData.createCaseDonnees | Method Exit');
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object updateEnergieVert(String contractId, String energieVert){
        System.debug('HP_EC_UpdateCustomerData.updateEnergieVert | Method Start');
        Object data;
        String exceptionMessage;
        try {
            data = (Object) JSON.deserializeUntyped(JSON.serialize(HP_SM006_FactureManager.updateEnergieVert(contractId, energieVert, '0')));
        } catch (Exception e) {
            System.debug('HP_EC_UpdateCustomerData.updateEnergieVert | Exception : ' + e.getMessage() + ' ' + e.getStackTraceString());
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, e.getMessage());
        }
        System.debug('HP_EC_UpdateCustomerData.updateEnergieVert | Method Exit');
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object updateJourDrp(String contractId, String drp){
        System.debug('HP_EC_UpdateCustomerData.updateJourDrp | Method Start');
        Object data;
        String exceptionMessage;
        try {
            Map<String, String> paramMap = new Map<String, String>{'id_contrat_xdata' => contractId, 'drp' => drp, 'profil' => '0'};
            HTTPResponse res = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_PROPOSITION_MODIFIER, paramMap);
            System.debug('### DRP Response : ' + res.getBody());
            data = (Object) JSON.deserializeUntyped(res.getBody());
        } catch (Exception e) {
            System.debug('HP_EC_UpdateCustomerData.updateJourDrp | Exception : ' + e.getMessage() + ' ' + e.getStackTraceString());
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, e.getMessage());
        }
        System.debug('HP_EC_UpdateCustomerData.updateJourDrp | Method Exit');
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object updateMensualite(String contractId, String montantMensualite){
        System.debug('HP_EC_UpdateCustomerData.updateMensualite | Method Start');
        Object data;
        String exceptionMessage;
        try {
            Map<String, String> paramMap = new Map<String, String>{'id_contrat_xdata' => contractId, 'mensualite' => montantMensualite, 'profil' => '0'};
            HTTPResponse res = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_MAJ_MENSUALITE, paramMap);
            data = (Object) JSON.deserializeUntyped(res.getBody());
        } catch (Exception e) {
            System.debug('HP_EC_UpdateCustomerData.updateMensualite | Exception : ' + e.getMessage() + ' ' + e.getStackTraceString());
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, e.getMessage());
        }
        System.debug('HP_EC_UpdateCustomerData.updateMensualite | Method Exit');
        return data;
    }

    @AuraEnabled
    public static String createCaseMensualite(Map<String,Object> objectInformation){
        System.debug('HP_EC_UpdateCustomerData.createCaseMensualite | Method Start');
        System.debug('####Object Information : ' + objectInformation);
        System.debug('#### Type : ' + String.valueOf(objectInformation.get('type')));
        String data;
        try {
            String caseDescription = String.valueOf(objectInformation.get('type')) == 'DRP' ? ' ancienne DRP : ' + String.valueOf(objectInformation.get('oldDRP')) +' ; nouvelle DRP : '+String.valueOf(objectInformation.get('newDRP')) :
            ' ancienne mensualité : ' + String.valueOf(objectInformation.get('oldAmount')) +' ; nouvelle mensualité : '+String.valueOf(objectInformation.get('newAmount')) ;
            Case myCase = new Case();
            myCase.ContactId = String.valueOf(objectInformation.get('contactId'));
            myCase.RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Facturation');
            myCase.HP_Type__c = 'HP_CONTRACT_DATA';
            myCase.Status = 'CLOSED';
            myCase.Origin = 'HP_Espace_Client';
            myCase.HP_Sous_type__c = String.valueOf(objectInformation.get('type')) == 'DRP' ? 'DRP' :'Changement modalités paiement';
            myCase.OwnerId = HP_UTIL_QueueManager.getQueueIdByName('HP_Niveau_3');
            myCase.Description = getCurrentDateFormatted() + caseDescription;    
            insert myCase;
            data = myCase.Id;
        } catch (Exception e) {
            System.debug('HP_EC_UpdateCustomerData.createCaseMensualite | Exception : ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
        System.debug('HP_EC_UpdateCustomerData.createCaseMensualite | Method Exit');
        return data;
    }

    private static String getCurrentDateFormatted(){
        return String.valueOf(Date.today().day()) + '/' + String.valueOf(Date.today().month()) + '/' + String.valueOf(Date.today().year());
    }
    

    @AuraEnabled
    public static Map<String,Object> updateEmail(String idTiers, String email){
        System.debug('HP_EC_UpdateCustomerData.updateEmail | Methode Start');
        Map<String,Object> resultObject = new Map<String,Object>();
        try {
            HP_Community_User__c myCommunityUser = [SELECT Id, Name, Username__c FROM HP_Community_User__c WHERE Id_Tiers__c = :idTiers LIMIT 1];
            system.debug('community user'+myCommunityUser);
            myCommunityUser.Username__c = email;
            update myCommunityUser;
            resultObject.put('success', true);
        } catch (Exception ex) {
            system.debug('exception message '+ex.getMessage());
            System.debug('HP_EC_UpdateCustomerData.updateEmail | Exception : '+ ex.getStackTraceString());
            resultObject.put('success', false);
        }
        System.debug('HP_EC_UpdateCustomerData.updateEmail | Methode Exit');
        return resultObject;
    }

//get Avatar to display
    @AuraEnabled(cacheable=true)
    public static HP_Community_User__c getAvatar(String idTiers) {
        HP_Community_User__c data = new HP_Community_User__c();
        String exceptionMessage;
        try {
                data = [select id, Avatar__c from HP_Community_User__c WHERE Id_Tiers__c = :idTiers LIMIT 1];
                if(data.Avatar__c == null || data.Avatar__c == ''){
                    HP_Community_User__c defaultAvatar = (HP_Community_User__c)HP_Community_User__c.sObjectType.newSObject(null, true);
                    data.Avatar__c = (String)defaultAvatar.get('Avatar__c');
                    System.debug('default avatr is'+data.Avatar__c);
                }

            }

        catch (Exception e) {
            System.debug('ERROR HP EC getAvat  : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //Client side message
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        return data;

    }

//update Avatar to display
    @AuraEnabled
    public static Map<String,Object> updateAvatar(String idTiers, String avatar) {
        System.debug('updateAvatar start');
        Map<String,Object> resultObject = new Map<String,Object>();
        HP_Community_User__c data;
        String exceptionMessage;
        try {
            data = [select id, Avatar__c from HP_Community_User__c WHERE Id_Tiers__c = :idTiers LIMIT 1];
            data.Avatar__c = avatar;
            System.debug('data in update avatar++++>'+data);
            update data;
            resultObject.put('success', true);
            
        }
        catch (Exception e) {
            System.debug('ERROR HP EC getAvat  : ' + e.getMessage() + ' ' + e.getStackTraceString());
            resultObject.put('success', false);
        }
        return resultObject;

    }
    @AuraEnabled
    public static string hpSaveClient(Map<String, Object> client){
        System.debug('HP_EC_UpdateCustomerData.hpSaveClient | Methode Start');
        Map<String, Object> clientToPersist = new Map<String, Object>();
        String idXdataPersonne = null;
        Contact contactUpdate = new Contact();
        try {
            for (String key : client.keySet()) {
                if( !'numeroEtranger'.equals(key) ){
                    clientToPersist.put(key,client.get(key));
                }
            }
            if(clientToPersist.get('id') != null) {
                clientToPersist.remove('id');
                idXdataPersonne = String.valueOf(clientToPersist.get('ref'));
                clientToPersist.remove('ref');
                Integer response = HP_CALL001_XDATA.updatePersonne(idXdataPersonne, JSON.serialize(clientToPersist));
                system.debug('response '+response);
                if(response == 204 || response == 200 || response == 201){
                    Decimal idRef = Decimal.valueOf(idXdataPersonne);
                    contactUpdate = [select id, email, MobilePhone, phone, No_Voie__c, MailingPostalCode, MailingCity, MailingStreet from Contact WHERE ID_Tiers__c = :idRef LIMIT 1];
                    contactUpdate.email = String.valueOf(client.get('email'));
                    contactUpdate.MobilePhone = String.valueOf(client.get('numeroMobile')).replaceFirst('0', '+33');
                    contactUpdate.phone = String.valueOf(client.get('numeroFixe')).replaceFirst('0', '+33');
                    contactUpdate.No_Voie__c = String.valueOf(client.get('numVoie'));
                    contactUpdate.MailingPostalCode = String.valueOf(client.get('codePostal'));
                    contactUpdate.MailingCity =String.valueOf(client.get('ville'));
                    contactUpdate.MailingStreet =String.valueOf(client.get('voie'));
                    update contactUpdate;
                    System.debug('contact updated with success '+contactUpdate);
                }
            }
            
        } catch (Exception ex) {
            System.debug('HP_EC_UpdateCustomerData.hpSaveClient | Exception : '+ ex.getMessage());
        }
        System.debug('HP_EC_UpdateCustomerData.hpSaveClient | Methode Exit');
        return contactUpdate.Id;
        
    }

    @AuraEnabled
    public static List<Object> updateConsentementXdata(String idClient, List<Map<String, Object>> concentementList) {
        System.debug('HP_EC_UpdateCustomerData.updateConsentementXdata | Method Start');
        List<Object> data;
        try {
            Integer idQuestion;
            Integer idQuestionnaire;
            for(Map<String, Object> item : concentementList) {
                idQuestion = Integer.valueOf(item.get('idQuestion'));
                idQuestionnaire = Integer.valueOf(item.get('idQuestionnaire'));
                item.remove('idQuestion');
                item.remove('idQuestionnaire');
                item.put('idQuestion', idQuestion);
                item.put('idQuestionnaire', idQuestionnaire);
                item.put('idPersonne' , Integer.valueOf(idClient));
            }
            data =  HP_CALL001_XDATA.sendConsentResponses(JSON.serialize(concentementList));
        } catch (Exception e) {
            System.debug('HP_EC_UpdateCustomerData.updateConsentementXdata | Exception : ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
        System.debug('HP_EC_UpdateCustomerData.updateConsentementXdata | Method Exit');
        return data;
    }

    @AuraEnabled
    public static Map<String, Object> updateConsentementInfos(String idClient, List<Map<String, Object>> concentementList){
        System.debug('HP_EC_UpdateCustomerData.updateConsentementInfos | Method Start');
        Map<String, Object> resultMap = new Map<String, Object>();
        Integer idQuestion;
        Integer idQuestionnaire;
        Boolean consent;
        List<HP_MajConsentements__c> myConsentmentList = new List<HP_MajConsentements__c>();
        try {
            try {
                myConsentmentList = [  SELECT HP_IdQuestionnaireConsentement__c, HP_IdQuestionConsentement__c, 
                                                                HP_DateModification__c, HP_Canal__c, HP_Consentement__c FROM HP_MajConsentements__c 
                                                                WHERE HP_IdXDATA__c = :Integer.valueOf(idClient) ];
            } catch (Exception ex) {
                System.debug('HP_EC_UpdateCustomerData.updateConsentementInfos | No Entries need to create consentements');
            }
            
            Contact myContact = [SELECT Id, Id_Tiers__c FROM Contact WHERE Id_Tiers__c = :Integer.valueOf(idClient) LIMIT 1];
            List<HP_MajConsentements__c> myConsentmentListToInsert = new List<HP_MajConsentements__c>();
            Set<Integer> idQuestionSet = new Set<Integer>();
            Set<Integer> idQuestionnaireSet = new Set<Integer>();
            for(HP_MajConsentements__c consentItem : myConsentmentList) {
                idQuestionSet.add(Integer.valueOf(consentItem.HP_IdQuestionConsentement__c));
                idQuestionnaireSet.add(Integer.valueOf(consentItem.HP_IdQuestionConsentement__c));
            }
            for(Map<String, Object> item : concentementList) {
                idQuestion = Integer.valueOf(item.get('idQuestion'));
                idQuestionnaire = Integer.valueOf(item.get('idQuestionnaire'));
                consent = Boolean.valueOf(item.get('consent'));
                if(myConsentmentList.isEmpty()){
                    myConsentmentListToInsert.add(createConsentement(myContact, consent, idQuestionnaire, idQuestion));
                }else{
                    for(HP_MajConsentements__c consentItem : myConsentmentList){
                        if(consentItem.HP_IdQuestionnaireConsentement__c == idQuestionnaire && consentItem.HP_IdQuestionConsentement__c == idQuestion){
                            consentItem.HP_Consentement__c = consent;
                            consentItem.HP_Canal__c = 'Espace Client';
                            consentItem.HP_DateModification__c = Datetime.now();
                            break;
                        } else if(!idQuestionSet.contains(idQuestion) || !idQuestionnaireSet.contains(idQuestionnaire)){
                            myConsentmentListToInsert.add(createConsentement(myContact, consent, idQuestionnaire, idQuestion));
                            idQuestionSet.add(idQuestion);
                            idQuestionnaireSet.add(idQuestionnaire);
                        }
                    }
                } 
            }
            if(!myConsentmentList.isEmpty()){
                update myConsentmentList;
            }
            if(!myConsentmentListToInsert.isEmpty()){
                insert myConsentmentListToInsert;
            }
            resultMap.put('success', true);
            resultMap.put('errorMessage', null);
        } catch (Exception e) {
            resultMap.put('success', false);
            resultMap.put('errorMessage', e.getMessage());
            System.debug('HP_EC_UpdateCustomerData.updateConsentementInfos | Exception : ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
        
        System.debug('HP_EC_UpdateCustomerData.updateConsentementInfos | Method Exit');
        return resultMap;
    }

    public static HP_MajConsentements__c createConsentement(Contact myContact, Boolean consent, Integer idQuestionnaire, Integer idQuestion){
        return new HP_MajConsentements__c(HP_Contact__c = myContact.Id,
        HP_Consentement__c = consent,
        HP_IdTiersConsentement__c= String.valueOf(myContact.Id_Tiers__c), 
        HP_IdQuestionnaireConsentement__c = idQuestionnaire,
        HP_IdQuestionConsentement__c = idQuestion,
        HP_Source__c = 'Happe',
        HP_Canal__c = 'Espace Client',
        HP_IdXDATA__c = myContact.Id_Tiers__c);
    }

    @AuraEnabled
    public static Map<String, Object> updateOptinMarketing(String idClient, Boolean optinMarketing){
        System.debug('HP_EC_UpdateCustomerData.updateOptinMarketing | Method Start');
        Map<String, Object> resultMap = new Map<String, Object>();
        try {
            Contact myContact = [SELECT HP_OptinMarketing__c, HP_DateOptinMarketing__c FROM Contact WHERE Id_Tiers__c = :Integer.valueOf(idClient) LIMIT 1];
            myContact.HP_DateOptinMarketing__c = Datetime.now();
            myContact.HP_OptinMarketing__c = optinMarketing;
            update myContact;
            resultMap.put('success', true);
            resultMap.put('errorMessage', null);
        } catch (Exception e) {
            resultMap.put('success', false);
            resultMap.put('errorMessage', e.getMessage());
            System.debug('HP_EC_UpdateCustomerData.updateOptinMarketing | Exception : ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
        System.debug('HP_EC_UpdateCustomerData.updateOptinMarketing | Method Exit');
        return resultMap;
    }

}