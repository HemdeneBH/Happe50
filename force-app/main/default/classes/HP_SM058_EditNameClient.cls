/**
 * @description       : 
 * @author            : Slimene Belhaj Ali
 * @group             : 
 * @last modified on  : 04-13-2021
 * @last modified by  : Slimene Belhaj Ali
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-26-2021   Slimene Belhaj Ali   Initial Version
**/
public with sharing class HP_SM058_EditNameClient {
    
    @AuraEnabled
    public static Map<String, Object> editName(String contactId, String xdataId, String salutation, String firstName, String lastName,
    String numVoie, String voie, String codePostal, String ville, String motif, String contrats, Boolean isJust){
        Map<String, Object> result = new Map<String, Object>(); 
        Map<String, Object> clientToPersist = new Map<String, Object>();
        clientToPersist.put('civilite', salutation);
        clientToPersist.put('nom', firstName);
        clientToPersist.put('prenom', lastName);

        clientToPersist.put('numVoie', numVoie);
        clientToPersist.put('voie', voie);
        clientToPersist.put('codePostal', codePostal);

        clientToPersist.put('ville', ville);
        clientToPersist.put('pays', 'FR');
        HTTPResponse response= HP_UTIL_HTTPUtils.calloutPut(HP_Constantes.XDATA_PERSONNE, JSON.serialize(clientToPersist), '/'+xdataId);
		
        if(response.getStatusCode() > 300) {
            Case cas = caseProcessing(contactId, salutation, firstName, lastName, 'DELAYED_PROCESS', contrats, motif, isJust, null);
            result.put('success', false);
            result.put('caseId', cas.Id);
            return result;
        }

        Case cas = caseProcessing(contactId, salutation, firstName, lastName, 'CLOSED', contrats, motif, isJust, null);
        Contact cont = new Contact(Id = contactId, firstName = firstName, LastName = lastName, HP_IsChanged__c = true);
        update cont;

        result.put('success', true);
        result.put('caseId', cas.Id);
        return result;

    }

    

    public static Case loadEditNameCase(String contactId) {
        List<Case> caseList = [select Id from Case where ContactId = :contactId and IsClosed = false and HP_Type__c = 'HP_Modification_titulaire' limit 1];
        if(caseList.size() == 0) {
            return null;
        }
        return caseList.get(0);
    }

    public static Case caseProcessing(String contactId, String salutation, String firstName, String lastName, String status,
    String contrats, String motif, Boolean isJust, Boolean isInst) {
        Case cas = loadEditNameCase(contactId);
        if(cas == null) {
            cas = new Case();
        }
        cas.ContactId = contactId;
        cas.RecordTypeId =  HP_UTIL_RecordType.getRecordTypeId('Case','HP_CaseRecontact');
        cas.Priority = 'Medium';
        cas.HP_Sous_type__c = 'Aucun';
        cas.HP_type__c = 'HP_Modification_titulaire';
        cas.Origin = 'HP_CRM';
    
        DateTime dT = System.now().addDays((status == 'CLOSED' ? 0 : 1));
        cas.HP_TreatmentDate__c = Date.newinstance(dT.year(), dT.month(), dT.day());
        cas.status = status;
        if(status == 'DELAYED_PROCESS' && cas.Id == null) {
            cas.ownerId = HP_UTIL_QueueManager.getQueueIdByName('HP_Niveau_1');
        } else if(HP_UTIL_ProfileManager.getCurrentUserProfileName().contains('HP_Conseiller Niveau 1') && status == 'DELAYED_PROCESS') {
            cas.ownerId = HP_UTIL_QueueManager.getQueueIdByName('HP_Niveau_2');
        }else if(HP_UTIL_ProfileManager.getCurrentUserProfileName().contains('HP_Conseiller Niveau 2') && status == 'DELAYED_PROCESS') {
            cas.ownerId = HP_UTIL_QueueManager.getQueueIdByName('HP_Niveau_3');
        }
        
        if(contrats != null) {
            cas.HP_Contrats__c = contrats;
        }
        
        if(motif != null) {
            cas.HP_MotifDuChangementDeTitulaire__c = motif;
        }
        
        if(salutation != null && firstName != null && lastName != null) {
            cas.Description = 'Nouveau titulaire : \n Civilité :' + salutation + '/Prénom : ' + firstName + '/ Nom : ' + lastName;
        }
        if(isJust == true) {
            cas.HP_TraitementDesJustificatifs__c = isJust;
        }

        if(isInst == true) {
            cas.HP_DemandeDeJustificatif__c = isInst;
        }

        System.debug('@@ cas ' + cas);
        upsert cas;

        return cas;
    }

    public static void createEmailMessage(String subject, String body, String email, String contactId, String caseId) {
        EmailMessage em = new EmailMessage(subject = subject, toAddress = email, htmlBody = body, RelatedToId = caseId);
        insert em;

        EmailMessageRelation emr = new EmailMessageRelation(emailMessageId = em.id, relationId = contactId, relationType = 'ToAddress');
        insert emr;
    } 
    @AuraEnabled
    public static void sendJustificatif(String contactId,String contrats, String motif, String emailClient){
        Contact cont = [select toLabel(Salutation), FirstName, LastName, email, mobilePhone, Id_Tiers__c from contact where Id = :contactId];
        String objet = 'Justificatif pour modification du titulaire de votre compte client';
        String body = 'Réf Client : ' +  cont.Id_Tiers__c + '<br/> ' 
        + (cont.Salutation != null ? cont.Salutation : 'Madame, Monsieur') + ' ' +cont.FirstName + ' ' +cont.LastName + ',<br/>'
        + 'Vous souhaitez modifier le ou les personnes titulaires d’un contrat d’énergie.<br/>'+
        'Afin de traiter votre demande au plus vite nous avons besoin des documents nécessaires à la modification demandée pour mettre à jour votre espace client et produire un avenant au contrat initial/futurs documents.<br/>'
        +'Veuillez nous faire parvenir en pièce jointe retour l’un des éléments suivants :'
        +'<ul><li>Certificat de mariage</li><li>Certificat de PACS</li><li>Certificat de divorce</li><li>Certificat de décès</li><li>Certificat de succession</li></ul><br/>'
        +'Dès réception de votre mail nous vous confirmerons la bonne exécution de votre demande sous un délai de 48h ouvrées.';
        Map<String, String> input = new Map<String, String>();
        input.put('idFormulaireCode', 'SF52');
        input.put('email', emailClient);
        input.put('idClient', String.valueOf(cont.Id_Tiers__c));
        input.put('canalCommunicationCode', 'EMAIL');
        input.put('canalCommunicationLibCourt', 'Email');
        input.put('idFormulaireLibCourt', 'Mail happe');
        input.put('objet', objet);
        input.put('contenu', body);
        HP_UTIL_MailSmsEnvoi.envoiAsync(input);
        Case cas = caseProcessing(contactId, null, null, null, 'HP_PENDING', contrats, motif, null, true);
        createEmailMessage(objet, body, emailClient, contactId, cas.Id);
    }

    @AuraEnabled
    public static void notificationClient(String contactId, boolean sms, boolean email, Boolean sge, Boolean omega, String caseId){
        System.debug('@@@ contactId ' + contactId + '  ' + sms + '  ' + email);
        Contact cont = [select toLabel(Salutation), FirstName, LastName, email, mobilePhone, Id_Tiers__c from contact where Id = :contactId];
        if(sms == true && cont.mobilePhone != null) {
            Map<String, String> input = new Map<String, String>();
            input.put('idFormulaireCode', 'SMS1');
            input.put('idClient', String.valueOf(cont.Id_Tiers__c));
            input.put('contenu', 'Suite à votre demande, nous avons procédé à la modification de vos coordonnées pour votre contrat. Le service client happ-e by ENGIE');
            input.put('numMobile', cont.mobilePhone.replace('+33', '0'));
            input.put('canalCommunicationCode', 'SMS');
            HP_UTIL_MailSmsEnvoi.envoiAsync(input);
        } else if(sms == true && cont.mobilePhone != null) {
            System.debug('Le contact n\'a pas un tel mobile');
        }

        if(email == true) {
            Map<String, String> input = new Map<String, String>();
            input.put('idFormulaireCode', 'SF52');
            input.put('email', cont.Email);
            input.put('idClient', String.valueOf(cont.Id_Tiers__c));
            input.put('canalCommunicationCode', 'EMAIL');
            input.put('canalCommunicationLibCourt', 'Email');
            input.put('idFormulaireLibCourt', 'Mail happe');
            input.put('objet', 'Mise à jour de votre compte client');
            input.put('contenu', 'Réf Client : ' +  cont.Id_Tiers__c + '<br/> ' 
            + (cont.Salutation != null ? cont.Salutation : 'Madame, Monsieur') + ' ' +cont.FirstName + ' ' +cont.LastName + ',<br/>'
            + 'Nous avons bien procédé à votre demande de modification de coordonnées.<br/>'
            + 'Les changements sont désormais visibles depuis votre espace client.<br/>'
            + 'Si vous n\'êtes pas à l’origine de cette demande, veuillez nous contacter par mail ou en nous téléphonant au 09 77 420 410 (ouvert du Lundi au Vendredi de 09h à 18h et le Samedi de 09h à 17h)<br/>');
            HP_UTIL_MailSmsEnvoi.envoiAsync(input);
        }

        
        if(caseId != null) {
            Case cas = new Case(Id = caseId);
            if(sge == true)cas.HP_ModificationEffectueeSGE__c = sge;
            
            if(omega == true)cas.HP_ModificationEffectureOMEGA__c = omega;
            update cas;
        }
    }
}